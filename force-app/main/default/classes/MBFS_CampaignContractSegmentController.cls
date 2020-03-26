/**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Controller Class for Campaign Screen 
**/
public  With Sharing class MBFS_CampaignContractSegmentController {
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    @AuraEnabled
    public static MBFS_CampaignDataWrapper.WrapperData onLoadCall(String jsonParameter) 
    {      
        
        MBFS_CampaignDataWrapper.WrapperData wrapperdata = new MBFS_CampaignDataWrapper.WrapperData();
        String suppressvalue =   Label.Suppress_value ;  
        try{
            MBFS_CampaignDataWrapper.CommonDataWrapper wrapObj =  (MBFS_CampaignDataWrapper.CommonDataWrapper) System.JSON.deserialize(jsonParameter, MBFS_CampaignDataWrapper.CommonDataWrapper.class);
            Integer noOfRecordData  = Integer.valueOf(wrapObj.noOfRecord);
            if(noOfRecordData > 50000){
                 noOfRecordData = 50000 ;                                                            
            } 
            Set<String> columnApiNames = new  Set<String> ();       
            List<MBFS_CampaignContractColumn__c> contractColumnData = MBFS_CampaignContractColumn__c.getall().values();  
            
            String soqlQuery = 'select Id ';
            for(MBFS_CampaignContractColumn__c contractColumn : contractColumnData){
                soqlQuery = soqlQuery + ' , '+ contractColumn.ApiName__c ;
                columnApiNames.add(contractColumn.ApiName__c);
            }
            // Throw an exception if CS does not contain field name
            if(!columnApiNames.contains(wrapObj.sortField)){
                throw new AuraHandledException(Label.ApiName_No_Access);
            }
            
            soqlQuery = soqlQuery + ' from Contract where MBFS_Suppress__c= {0} and MBFS_Fleet__c = false and MBFS_Block__c = false and MBFS_Expiry_month_Difference_from_today__c <= 6  order by {1} {2} LIMIT {3} ' ;
            String sortField = String.escapeSingleQuotes(wrapObj.sortField.trim()) ; 
            Boolean isAscending = (Boolean) wrapObj.isAscending ; 
            List<String> fillers = new List<String>();
            fillers.add('\''+String.escapeSingleQuotes(suppressvalue) +'\'');
            
            if (sortField != '') {
                fillers.add(sortField) ;
               
                if (isAscending) {
                    fillers.add(' asc NULLS first ');
                } else {
                    fillers.add(' desc NULLS last ');
                }
            }
            fillers.add(String.valueOf(noOfRecordData));               
            String formattedQuery = String.format(soqlQuery, fillers);
            
            List <Contract> lstResult =  Database.query(formattedQuery);
           
            MBFS_CampaignDataWrapper.ResultSet resultSet =  MBSF_CommonHelper.processResultsCampaign('Contract', lstResult,contractColumnData);
            
            
            String summarySQL = 'select count(Id) noOfCont,MBFS_Assign_To__c from contract where MBFS_Suppress__c=:suppressvalue and MBFS_Fleet__c = false and MBFS_Block__c = false and  MBFS_Expiry_month_Difference_from_today__c <= 6 ';                            
            summarySQL = summarySQL + ' group by MBFS_Assign_To__c ';           
            List<AggregateResult> chartresult = Database.query(summarySQL);
            Integer allDataCount = 0 ;
            for(AggregateResult aggObj : chartresult){
                String userId = (String) aggObj.get('MBFS_Assign_To__c') ;
                Integer noOfCont = (Integer) aggObj.get('noOfCont') ;
                
                allDataCount = allDataCount + noOfCont ;
            }
            
            wrapperdata = new MBFS_CampaignDataWrapper.WrapperData(null,null,resultSet,allDataCount);
            wrapperdata.isError = false ;
           
        }catch(Exception exce){ 
            wrapperdata.isError = true ;
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_CampaignContractSegmentController','onLoadCall',jsonParameter,exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj);
        }
        return wrapperdata ;
        
    }
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */   

    @AuraEnabled
    public static Boolean onChangeCampaignSubmit(String campaignId,String contractData) 
    {      
        Boolean isError = false ;
        try {
            Set<String> contractSet = new Set<String>();
            List<MBFS_Campaign_Member__c> campaignMemberListInserted = new List<MBFS_Campaign_Member__c>();
            List<MBFS_Campaign_Member__c> campaignMemberListUpdated = new List<MBFS_Campaign_Member__c>();
            List<Contract> contractListToUpdated = new List<Contract>();
            
            if(campaignId != null && contractData != null){
                
                Map<String,Object> dataMap = (Map<String,Object>) JSON.deserializeUntyped(contractData);	
                Map<String,Object> resultSetMap = (Map<String,Object>) dataMap.get('resultSet');
                List<Object> contractList = (List<Object>) resultSetMap.get('rows');
                        
                for(Object contractObj : contractList){
                    Map<String,Object> contractMap = (Map<String,Object>) contractObj ;
                    
                    Boolean isSelected = (Boolean) contractMap.get('isSelected') ;
                    if(isSelected == true){
                        String contractId = (String) contractMap.get('contractId');
                        contractSet.add(contractId) ;
                        MBFS_Campaign_Member__c campaignMemberObj = new MBFS_Campaign_Member__c();
                        campaignMemberObj.MBFS_Active__c = true ;
                        campaignMemberObj.MBFS_Campaign__c = campaignId ;
                        campaignMemberObj.MBFS_Contract__c = contractId ;
                        campaignMemberListInserted.add(campaignMemberObj);
                        
                        Contract conObj = new Contract(Id=contractId ,MBFS_Campaign__c = campaignId);
                        contractListToUpdated.add(conObj);
                    }                  
                }
                
                
                if(contractSet != null && contractSet.size() > 0 ){
                    List<MBFS_Campaign_Member__c> campaignMemberList = [Select Id,MBFS_Active__c,MBFS_Campaign__c,MBFS_Contract__c from 
                                                                             MBFS_Campaign_Member__c where MBFS_Contract__c In: contractSet ];
                
                    for(MBFS_Campaign_Member__c campaignMemberObj : campaignMemberList){
                        campaignMemberObj.MBFS_Active__c = false ;
                        campaignMemberListUpdated.add(campaignMemberObj) ;
                    }
                }
                
                
                if(campaignMemberListUpdated != null && campaignMemberListUpdated.size() > 0){
                    update campaignMemberListUpdated ;
                }
                
                if(campaignMemberListInserted != null && campaignMemberListInserted.size() > 0){
                    insert campaignMemberListInserted ;
                }
                
                if(contractListToUpdated != null && contractListToUpdated.size() > 0){
                    update contractListToUpdated ;
                }
                
            } 
        }catch(Exception exce){
           
           isError = true ;
           MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_CampaignContractSegmentController','onChangeCampaignSubmit',contractData,exce);
           MBSF_CommonHelper.insertErrorLog(exceWrapObj); 
        }  
        return isError ;
    }
}