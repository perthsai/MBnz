/**
@author: Amarendra Kumar
@company: Saasfocus
@description: Controller Class for RTH 
**/
public With Sharing class  MBFS_ContractSegmentationController {
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    @AuraEnabled
    public static MBSF_DataWrapper.WrapperDataByMonth onLoadCall(String jsonParameter) {
        
        MBSF_DataWrapper.WrapperDataByMonth wrapperdata = new MBSF_DataWrapper.WrapperDataByMonth();
        try{
            
            MBSF_DataWrapper.CommonDataWrapper wrapObj =  (MBSF_DataWrapper.CommonDataWrapper) System.JSON.deserialize(jsonParameter, MBSF_DataWrapper.CommonDataWrapper.class);
            
            Integer noOfRecordData  = Integer.valueOf(wrapObj.noOfRecord);
            if(noOfRecordData > 50000){
                noOfRecordData = 50000 ;
            } 
            String globalFilter = wrapObj.globalFilter.trim() ;
            if(globalFilter == MBFS_Constant.MBSF_CAMPAIGN){                    
                wrapperdata = onLoadCallForCampaignTab(wrapObj);
                system.debug('shivesh - wrapObj inside onLoadCall '+wrapObj);
            }else if(globalFilter == MBFS_Constant.MBSF_LEAD){
                wrapperdata = onLoadCallForLeadTab(wrapObj);                
            }
            wrapperdata.isError = false ; 
           
        }catch(Exception exce){ 
            wrapperdata.isError = true ;
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_ContractSegmentationController','onLoadCall',jsonParameter,exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj);
        }
        return wrapperdata ;
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    private static MBSF_DataWrapper.WrapperDataByMonth onLoadCallForLeadTab(MBSF_DataWrapper.CommonDataWrapper wrapObj) 
    {
        List<MBSF_DataWrapper.MonthWeekFilterData> monthWeekFilterDataList = new List<MBSF_DataWrapper.MonthWeekFilterData>();
        List<MBSF_DataWrapper.CampaignFilterData> campaignFilterDataList = new List<MBSF_DataWrapper.CampaignFilterData>();               
        List<MBSF_DataWrapper.AssigneeData> assigneeDataList = new List<MBSF_DataWrapper.AssigneeData>();
        
        for(User userObj : [select name,id from user where isActive= true and Is_Standard_User__c = true]){
            MBSF_DataWrapper.AssigneeData assigneeDataObj = new MBSF_DataWrapper.AssigneeData (userObj.Id,userObj.Name);
            assigneeDataList.add(assigneeDataObj);
        }
        
        List<MBSF_DataWrapper.AgilityData> aglityDataList = new List<MBSF_DataWrapper.AgilityData>();
        
        String queueId = '' ;
        Group queueName = [SELECT Id,Type FROM Group where Type='Queue' and name='Retention Queue' limit 1]; 
        
        MBSF_DataWrapper.WrapperDataByMonth wrapperdata ;
        if(queueName != null && queueName.Id != null){
            queueId = queueName.Id ;
        
        
            MBSF_DataWrapper.ResultSet resultSet =  getDataForLeadTab(wrapObj,queueId) ;
            
            String summarySQL = 'select count(Id) noOfCont from Lead where ownerid=:queueId ';
            List<AggregateResult> chartresult = Database.query(summarySQL);
            
            Integer leadCount = 0 ;
            for(AggregateResult aggObj : chartresult){
                Integer noOfCont = (Integer) aggObj.get('noOfCont') ;
                leadCount = leadCount + noOfCont ;
            }
            
            List<MBSF_DataWrapper.ChartData>  chartDataList = new List<MBSF_DataWrapper.ChartData>(); 
            
            wrapperdata = new MBSF_DataWrapper.WrapperDataByMonth(monthWeekFilterDataList,campaignFilterDataList,assigneeDataList,
                                                                                                      aglityDataList,resultSet,chartDataList,leadCount);
        }
        return wrapperdata ;
    }    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    private static MBSF_DataWrapper.ResultSet getDataForLeadTab(MBSF_DataWrapper.CommonDataWrapper wrapObj,String queueId) 
    {
        List<MBSF_LeadColumns__c> leadColumnData = MBSF_LeadColumns__c.getall().values();
        Set<String> columnApiNames = new  Set<String> ();
        String soqlQuery = 'select Id ';
        for(MBSF_LeadColumns__c leadColumn : leadColumnData){                 
            soqlQuery = soqlQuery + ' , '+ leadColumn.ApiName__c ;
            columnApiNames.add(leadColumn.ApiName__c);
        }
        String sortField =  wrapObj.sortField.trim();
        // Throw an exception if CS does not contain field name
        if(!columnApiNames.contains(wrapObj.sortField) ){
            throw new AuraHandledException(Label.ApiName_No_Access);
        }        
        soqlQuery = soqlQuery + ' from Lead where ownerid= {0} order by {1} {2} LIMIT {3}';   
        List<String> fillers = new List<String>();
        if(queueId != ''){
            fillers.add('\''+String.escapeSingleQuotes(queueId) +'\'');
        }
        
        
        Boolean isAscending =   wrapObj.isAscending ;
        Integer noOfRecord = (Integer) wrapObj.noOfRecord ;
        
        if (sortField != '') {
            fillers.add(sortField) ;
            if (isAscending) {
                fillers.add(' asc NULLS first ');
            } else {
                fillers.add(' desc NULLS last ');
            }
        }                
        fillers.add(String.valueOf(noOfRecord));   
        
        String formattedQuery = String.format(soqlQuery, fillers);
        List <Lead> lstResult =  MBSF_CommonHelper.getLeadResult(formattedQuery);
        
        MBSF_DataWrapper.ResultSet resultSet =  MBSF_CommonHelper.processResults('Lead', lstResult,leadColumnData,wrapObj.globalFilter);
        return resultSet ;
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    private static MBSF_DataWrapper.WrapperDataByMonth onLoadCallForCampaignTab(MBSF_DataWrapper.CommonDataWrapper wrapObj) 
    {           
        
        List<MBSF_DataWrapper.MonthWeekFilterData> monthWeekFilterDataList = new List<MBSF_DataWrapper.MonthWeekFilterData>();
        Map<String,String> userIdToNameMap = new Map<String,String>();              
        List<MBSF_DataWrapper.CampaignFilterData> campaignFilterDataList = new List<MBSF_DataWrapper.CampaignFilterData>();
        for(Campaign campObj : [select Id,Name from Campaign where mbfs_Visiblity__c = true]){
            MBSF_DataWrapper.CampaignFilterData campaignFilterData = new MBSF_DataWrapper.CampaignFilterData(campObj.Id,campObj.Name);
            campaignFilterDataList.add(campaignFilterData);
        }
        
        List<MBSF_DataWrapper.AssigneeData> assigneeDataList = new List<MBSF_DataWrapper.AssigneeData>();
        for(User userObj : [select name,id from user where isActive= true and Is_Standard_User__c = true]){
            MBSF_DataWrapper.AssigneeData assigneeDataObj = new MBSF_DataWrapper.AssigneeData (userObj.Id,userObj.Name);
            assigneeDataList.add(assigneeDataObj);
            userIdToNameMap.put(userObj.Id,userObj.Name);
        }
        
        List<MBSF_DataWrapper.AgilityData> aglityDataList = new List<MBSF_DataWrapper.AgilityData>();
        List<String> aglityValueList = MBSF_CommonHelper.getPicklistValues('Contract','MBFS_Agility__c');
        for(String aggValue : aglityValueList){
            MBSF_DataWrapper.AgilityData obj = new MBSF_DataWrapper.AgilityData(aggValue,aggValue);
            aglityDataList.add(obj);

        }                           

        MBSF_DataWrapper.ResultSet resultSet =  getDataForCampaignTab(wrapObj) ;
        
        List<Object> totalCountToChartDataList = createChartDataForCampaignTab(wrapObj,userIdToNameMap);
        
        //Zero index contain chart data
        //First index contain total no of records
        List<MBSF_DataWrapper.ChartData> chartDataList = (List<MBSF_DataWrapper.ChartData>)totalCountToChartDataList.get(0);
        Integer totalNoOfRecords                       = (Integer)totalCountToChartDataList.get(1);                
        
        MBSF_DataWrapper.WrapperDataByMonth  wrapperdata = new MBSF_DataWrapper.WrapperDataByMonth(monthWeekFilterDataList,campaignFilterDataList,assigneeDataList,
                                                                                                   aglityDataList, resultSet,chartDataList,totalNoOfRecords);
        return wrapperdata ;                                                                             
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    private static List<Object> createChartDataForCampaignTab(MBSF_DataWrapper.CommonDataWrapper wrapObj,Map<String,String> userIdToNameMap) {
        
        String suppressvalue =   Label.Suppress_value ;                                                            
        List<Object> chartDataToTotalCountList = new  List<Object> ();                                                             
        String summarySQL = 'select count(Id) noOfCont,MBFS_Assign_To__c,MBFS_Campaign__c from contract where MBFS_Suppress__c=:suppressvalue and MBFS_Fleet__c = false and MBFS_Block__c = false ';
        String campaignId = String.escapeSingleQuotes(wrapObj.campaignId.trim()) ;  
        
        if(campaignId != '' && campaignId != MBFS_Constant.All){
            summarySQL = summarySQL + ' and MBFS_Campaign__c =:campaignId ';
        }else{
            summarySQL = summarySQL + ' and MBFS_Campaign__c != null ';
        }
        String agility = String.escapeSingleQuotes(wrapObj.agility.trim()) ;                                                               
        if(agility != 'All' && agility != 'None'){
            summarySQL = summarySQL + ' and MBFS_Agility__c =:agility ';
        }
        if(agility == 'None'){
            summarySQL = summarySQL + ' and MBFS_Agility__c = null ';
        }

        // SqwarePeg
        String vehicleMakeInterest = String.escapeSingleQuotes(wrapObj.vehicleMakeInterest.trim()) ;
        if(vehicleMakeInterest == MBFS_Constant.MERCEDES){
            summarySQL = summarySQL + ' and MBFS_Make_Manufacturer_Mercedes__c = true ';
        }
        if(vehicleMakeInterest == MBFS_Constant.NON_MERCEDES){
            summarySQL = summarySQL + ' and MBFS_Make_Manufacturer_Mercedes__c = false ';
        }

        String residual = String.escapeSingleQuotes(wrapObj.residual.trim());
        if(residual == MBFS_Constant.ZERO){
            summarySQL = summarySQL + ' and (MBFS_Residual_Amount__c = 0 OR MBFS_Residual_Amount__c = null) ';
        }
        if(residual == MBFS_Constant.GREATER_ZERO){
            summarySQL = summarySQL + ' and MBFS_Residual_Amount__c > 0 ';
        }               
        summarySQL = summarySQL + ' group by MBFS_Assign_To__c,MBFS_Campaign__c' ;
        
        List<AggregateResult> chartresult = Database.query(summarySQL);
        List<MBSF_DataWrapper.ChartData>  chartDataList = new List<MBSF_DataWrapper.ChartData>();
        Map<String,Integer> userIdToCountMap = new Map<String,Integer>();
        Integer totalNoOfRecords = 0 ;
        
        for(AggregateResult aggObj : chartresult){
            Integer noOfCont = (Integer) aggObj.get('noOfCont') ;
            String userId = (String) aggObj.get('MBFS_Assign_To__c') ;
            String campaign = (String) aggObj.get('MBFS_Campaign__c') ;
            String assignedId = String.escapeSingleQuotes(wrapObj.assignedId.trim());
           
            if(campaignId == MBFS_Constant.All || (campaign != null && campaignId == campaign)){
                if(assignedId == MBFS_Constant.NOT_ASSIGNED && userId == null){
                    totalNoOfRecords = totalNoOfRecords + noOfCont ;
                    if(userIdToCountMap.get('NOT_ASSIGNED') == null){
                        userIdToCountMap.put('NOT_ASSIGNED',noOfCont);
                    }else {
                        userIdToCountMap.put('NOT_ASSIGNED',userIdToCountMap.get('NOT_ASSIGNED') + noOfCont);
                    }                                            
                }
                if(assignedId == MBFS_Constant.All){
                    if(userId != null){
                        totalNoOfRecords = totalNoOfRecords + noOfCont ;
                        if(userIdToCountMap.get(userId) == null){
                            userIdToCountMap.put(userId, noOfCont);
                        }else{
                            Integer count = noOfCont + userIdToCountMap.get(userId);
                            userIdToCountMap.put(userId, count) ;
                        }
                    }else{
                        totalNoOfRecords = totalNoOfRecords + noOfCont ;
                        if(userIdToCountMap.get('NOT_ASSIGNED') == null){
                            userIdToCountMap.put('NOT_ASSIGNED',noOfCont);
                        }else {
                            userIdToCountMap.put('NOT_ASSIGNED',userIdToCountMap.get('NOT_ASSIGNED') + noOfCont);
                        }                                                                 
                    }                    
                }
                if(userId != null && assignedId != MBFS_Constant.NOT_ASSIGNED && assignedId != MBFS_Constant.All && userId == assignedId){
                    totalNoOfRecords = totalNoOfRecords + noOfCont ;
                    if(userIdToCountMap.get(userId) == null){
                        userIdToCountMap.put(userId, noOfCont);
                    }else{
                        Integer count = noOfCont + userIdToCountMap.get(userId);
                        userIdToCountMap.put(userId, count) ;
                    }
                }
            }
            
        }
       
        for(String key:userIdToCountMap.keySet()){
            if(key != 'NOT_ASSIGNED'){
                MBSF_DataWrapper.ChartData cdAssign = new MBSF_DataWrapper.ChartData(userIdToNameMap.get(key)+' ('+ userIdToCountMap.get(key)+ ')',userIdToCountMap.get(key));
                chartDataList.add(cdAssign); 
            }else{
                MBSF_DataWrapper.ChartData cdAssign = new MBSF_DataWrapper.ChartData('Not Assigned ('+ userIdToCountMap.get(key)+ ')',userIdToCountMap.get(key));
                chartDataList.add(cdAssign);  
            }
            
        }                                   
        chartDataToTotalCountList.add(chartDataList);
        chartDataToTotalCountList.add(totalNoOfRecords);                                                                     
        return chartDataToTotalCountList ;                                                                                                                                              
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    private static MBSF_DataWrapper.ResultSet getDataForCampaignTab(MBSF_DataWrapper.CommonDataWrapper wrapObj) 
    {
        String suppressValue =   Label.Suppress_value ;      
        List<MBSF_ContractColumns__c> contractColumnData = MBSF_ContractColumns__c.getall().values();   
        Set<String> columnApiNames = new  Set<String> ();
       
        String soqlQuery = 'select Id ';
        for(MBSF_ContractColumns__c contractColumn : contractColumnData){                   
            soqlQuery = soqlQuery + ' , '+ contractColumn.ApiName__c ;
            columnApiNames.add(contractColumn.ApiName__c);
        } 
        String sortField  = String.escapeSingleQuotes(wrapObj.sortField.trim());
        // Throw an exception if CS does not contain field name    
        if(!columnApiNames.contains(wrapObj.sortField) && sortField !='CreatedDate'){
            throw new AuraHandledException(Label.ApiName_No_Access);
        }
        soqlQuery = soqlQuery + ' from Contract where MBFS_Suppress__c=\''+String.escapeSingleQuotes(suppressValue)+'\'' +' and MBFS_Fleet__c = false and MBFS_Block__c = false ';
        
        String assignedId = String.escapeSingleQuotes(wrapObj.assignedId.trim());
        String campaignId = String.escapeSingleQuotes(wrapObj.campaignId.trim());
        String agility    = String.escapeSingleQuotes(wrapObj.agility.trim());
        String vehicleMakeInterest = String.escapeSingleQuotes(wrapObj.vehicleMakeInterest.trim());
        String residual   = String.escapeSingleQuotes(wrapObj.residual.trim());
        
        Integer noOfRecord = (Integer) wrapObj.noOfRecord ; 
        Boolean isAscending = (Boolean) wrapObj.isAscending ;
        
        if(assignedId != MBFS_Constant.NOT_ASSIGNED && assignedId != '' && assignedId != MBFS_Constant.All){
            soqlQuery = soqlQuery + ' and MBFS_Assign_To__c =\''+assignedId +'\'';
        }
        if(assignedId == MBFS_Constant.NOT_ASSIGNED){
            soqlQuery = soqlQuery + ' and MBFS_Assign_To__c = null ';
        }
        
        if(campaignId != '' && campaignId != MBFS_Constant.All){
            soqlQuery = soqlQuery + ' and MBFS_Campaign__c =\''+campaignId +'\'';
        }else{
            soqlQuery = soqlQuery + ' and MBFS_Campaign__c != null ';
        }                
        if(agility != 'All' && agility != 'None'){
            soqlQuery = soqlQuery + ' and MBFS_Agility__c =\''+agility +'\' ';
        }
        if(agility == 'None'){
            soqlQuery = soqlQuery + ' and MBFS_Agility__c = null ';
        }
        //sqwarepeg
        if(vehicleMakeInterest == MBFS_Constant.MERCEDES)
        {
            soqlQuery = soqlQuery + ' and MBFS_Make_Manufacturer_Mercedes__c = true ';
        }
        if(vehicleMakeInterest == MBFS_Constant.NON_MERCEDES){
            soqlQuery = soqlQuery + ' and MBFS_Make_Manufacturer_Mercedes__c = false ';
        }

        if(residual == MBFS_Constant.ZERO){
            soqlQuery = soqlQuery + ' and (MBFS_Residual_Amount__c = 0 OR MBFS_Residual_Amount__c = null) ';
        }
        if(residual == MBFS_Constant.GREATER_ZERO){
            soqlQuery = soqlQuery + ' and MBFS_Residual_Amount__c > 0 ';
        }
       
        if (sortField != '') {
            soqlQuery += ' order by ' + sortField;
            if (isAscending) {
                soqlQuery += ' asc NULLS first ';
            } else {
                soqlQuery += ' desc NULLS last ';
            }
        }                
        soqlQuery += ' LIMIT '+noOfRecord;     
        
        List <Contract> lstResult =  MBSF_CommonHelper.getContractQueryResult(soqlQuery);              
        MBSF_DataWrapper.ResultSet resultSet =  MBSF_CommonHelper.processResults('Contract', lstResult,contractColumnData,wrapObj.globalFilter);        
        return resultSet ;
    }
   
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    @AuraEnabled
    public static MBSF_DataWrapper.ResultSet onSorting(String jsonParameter)
    {       
        MBSF_DataWrapper.ResultSet resultSet = new MBSF_DataWrapper.ResultSet();
        
        try{
            
            MBSF_DataWrapper.CommonDataWrapper wrapObj =  (MBSF_DataWrapper.CommonDataWrapper) System.JSON.deserialize(jsonParameter, MBSF_DataWrapper.CommonDataWrapper.class);
            Integer noOfRecordData  = Integer.valueOf(wrapObj.noOfRecord);
            if(noOfRecordData > 50000){
                noOfRecordData = 50000 ;
            }
            String globalFilter = wrapObj.globalFilter.trim();
            if(globalFilter == MBFS_Constant.MBSF_CAMPAIGN){               
                resultSet =  getDataForCampaignTab(wrapObj) ;               
            }else if(globalFilter == MBFS_Constant.MBSF_LEAD){               
                String queueId = '' ;
                Group queueName = [SELECT Id,Type FROM Group where Type='Queue' and name='Retention Queue' limit 1]; 
                if(queueName != null && queueName.Id != null){
                    queueId = queueName.Id ;
                    resultSet =  getDataForLeadTab(wrapObj,queueId) ;
                }                
            }
            resultSet.isError = false ; 
        }catch(Exception exce){
            resultSet.isError = true ;
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_ContractSegmentationController','onSorting',jsonParameter,exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj);
        }
        return resultSet ;
    }
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */  
    @AuraEnabled
    public static Boolean updateData(String data,String assigneeId,String globalFilter) {
        Boolean isError = false ;
        try{
            if(data != null && assigneeId != null && globalFilter != null && assigneeId != '' && data != '' && globalFilter !=''){
                Map<String,Object> dataMap = (Map<String,Object>) JSON.deserializeUntyped(data);
                Map<String,Object> resultSetMap = (Map<String,Object>) dataMap.get('resultSet');
                List<Object> rowsSetList = (List<Object>) resultSetMap.get('rows');
                
                List<String> recordIdList = new List<String> ();
                for(Integer i = 0 ; i < rowsSetList.size() ; i ++){
                    Map<String,Object> rowDataMap = (Map<String,Object>) rowsSetList[i] ;
                    Boolean isSelected = (Boolean) rowDataMap.get('isSelected') ;
                    if(isSelected == true){
                        String contractId = (String) rowDataMap.get('contractId') ;
                        recordIdList.add(contractId);
                    }
                }                                
                if(globalFilter == MBFS_Constant.MBSF_MONTH || globalFilter == MBFS_Constant.MBSF_CAMPAIGN){
                    List<Contract>  contractListToBeUpdate = new List<Contract>();
                    for(String recordId : recordIdList){
                        Contract conObj = new Contract(Id= recordId ,OwnerId =assigneeId,MBFS_Assign_To__c = assigneeId,MBFS_Contract_Assign_To_Date__c =System.today() );
                        contractListToBeUpdate.add(conObj);
                    }
                    if(contractListToBeUpdate != null && contractListToBeUpdate.size() > 0){
                        //MBSF_CommonHelper.changeTaskOwner(recordIdList,assigneeId);
                        update contractListToBeUpdate ;
                    }
                    
                }else if(globalFilter == MBFS_Constant.MBSF_LEAD){
                    List<Lead>  leadListToBeUpdate = new List<Lead>();
                    
                    for(String recordId : recordIdList){
                        Lead leadObj = new Lead(Id= recordId ,OwnerId =assigneeId);
                        leadListToBeUpdate.add(leadObj);
                    }
                    
                    if(leadListToBeUpdate != null && leadListToBeUpdate.size() > 0){
                        
                        update leadListToBeUpdate ;
                    }
                }
            }
        }catch(Exception exce){
            isError = true ;
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_ContractSegmentationController','updateData',data,exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj);
        }
        return isError ;
    }
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    
    @AuraEnabled
    public static Boolean onNotCallSave(String data,String outCome,String subOutCome,String globalFilter) {
        Boolean isError = false ;
        try {
            if(data != null && globalFilter != null && outCome != null && subOutCome != null){
                
                Map<String,Object> dataMap = (Map<String,Object>) JSON.deserializeUntyped(data);
                Map<String,Object> resultSetMap = (Map<String,Object>) dataMap.get('resultSet');
                List<Object> rowsSetList = (List<Object>) resultSetMap.get('rows');
                
                List<Contract> contractListToUpdated = new List<Contract>();
                List<Task> taskListToInserted = new List<Task>();
                List<Account> accountListToUpdated = new List<Account>();
                Set<String> recordIdList = new Set<String> ();
                
                for(Integer i = 0 ; i < rowsSetList.size() ; i ++) {
                    Map<String,Object> rowDataMap = (Map<String,Object>) rowsSetList[i] ;
                    Boolean isSelected = (Boolean) rowDataMap.get('isSelected') ;
                    if(isSelected == true){
                        String contractId = (String) rowDataMap.get('contractId') ;
                        recordIdList.add(contractId);
                    }
                }
                
                if(recordIdList != null){
                    for(Contract conObj : [select Id,AccountId,MBFS_Contract_Expiry_Duration__c,MBFS_Block_Contract_Month__c,MBFS_Campaign__c from Contract where Id In : recordIdList]){
                        
                        if(globalFilter == MBFS_Constant.MBSF_CAMPAIGN){
                            
                            Contract conTractObj = new Contract(Id= conObj.Id ,MBFS_Block_Campaign__c = conObj.MBFS_Campaign__c);
                            contractListToUpdated.add(conTractObj);
                            
                            Task taskObj = new Task(Subject='Call',Type='Call',MBFS_OutCome__c=outCome,
                                                    Status='Completed',
                                                    MBFS_Sub_Outcome__c=subOutCome,whatId=conObj.Id,ActivityDate = System.today(),
                                                    MBFS_ContractMonth__c= conObj.MBFS_Contract_Expiry_Duration__c,
                                                    MBFS_Campaign__c =conObj.MBFS_Campaign__c );
                            taskListToInserted.add(taskObj);
                        }
                        
                        
                        if(conObj.AccountId != null){
                            Account accObj = new Account(Id = conObj.AccountId ,MBFS_Do_Not_Call__c = true);
                            accountListToUpdated.add(accObj);
                        }
                        
                        
                    }
                }
                
                if(contractListToUpdated != null && contractListToUpdated.size() > 0 && taskListToInserted != null && taskListToInserted.size() > 0){
                    MBSF_CommonHelper.updateContract(contractListToUpdated);
                    MBSF_CommonHelper.insertTask(taskListToInserted);
                }
                if(accountListToUpdated != null && accountListToUpdated.size() > 0){
                    MBSF_CommonHelper.updateAccount(accountListToUpdated);
                }
                
            }
        }catch(Exception exce){ 
            isError = true ;
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_ContractSegmentationController','onNotCallSave',data,exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj);
        }
        return isError ;
    }
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    
    @AuraEnabled
    public static MBSF_DataWrapper.PickListToValueData getDoNotCallValues() {
        MBSF_DataWrapper.PickListToValueData obj = new MBSF_DataWrapper.PickListToValueData();
        try{
            List<String> valueList = new List<String>();
            
            valueList = MBSF_CommonHelper.getPicklistValues('Task','MBFS_Do_Not_Call__c');
            Map<String,List<String>> mapValues = new Map<String,List<String>>();
            mapValues.put('No_Call_Required',valueList);
            
            obj = new MBSF_DataWrapper.PickListToValueData(mapValues);
            obj.isError = false ;
        }catch(Exception exce){
            obj.isError = true ;
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_ContractSegmentationController','getDoNotCallValues','',exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj);
        }
        return obj ;
    }
}