/**
@author: Amarendra Kumar
@company: Saasfocus
@description: Controller Class for customer intention Screen 
**/
public With Sharing class MBFS_CustomerIntentionController {
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    @AuraEnabled
    public static MBFS_CustomerIntentionWrapper.WrapperData onLoadCall(String contractId) 
    {     
        
        MBFS_CustomerIntentionWrapper.WrapperData wrapperObj ;
        try{            
            wrapperObj  = new MBFS_CustomerIntentionWrapper.WrapperData();
            List<String> communicationChannel = MBSF_CommonHelper.getPicklistValues('Contract','MBFS_CI_Communication_Channel__c'); 
            
            Contract contractObj = [Select Id,MBFS_Customer_Intention_Expiry_Duration__c,MBFS_CI_Comments__c,MBFS_Expiry_Duration__c,MBFS_CI_Communication_Channel__c,
                                    MBFS_CI_Option__c,MBFS_Customer_Intention_Id__c,MBFS_CI_Sub_Option__c,MBFS_Agility__c 
                                    from Contract where Id =: contractId];
            
            String agilityValue = '';
            if(contractObj.MBFS_Agility__c == null){
                agilityValue = MBFS_Constant.NON_AGILITY;
            }else{
                agilityValue = contractObj.MBFS_Agility__c ;
            }
            List<MBFS_RTH_SubOutComeAndAction__c> subOutComeOutcomeList = [select Id,MBFS_Sequence__c,MBFS_Is_Active__c,Name,
                                                                           MBFS_Sub_Outcome__c from MBFS_RTH_SubOutComeAndAction__c 
                                                                           where MBFS_Is_Active__c = true and RecordTypeId in 
                                                                           (SELECT Id FROM RecordType WHERE Name = 'Customer Intention') and 
                                                                           MBFS_Is_Agility__c =:agilityValue ]; 
            
            
            
            
            wrapperObj.contractType =   agilityValue  ;
            wrapperObj.communicationChannel =  communicationChannel ;
            wrapperObj.optionToSubOptionMap = getOptionToSubOption(subOutComeOutcomeList); 
            wrapperObj.contractObj = contractObj ;
            wrapperObj.customerIntentionObj = createCustomerIntentionObject(contractObj);
            wrapperObj.isError = false ;   
        }catch(Exception exce){
            wrapperObj.isError = true ;
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_CustomerIntentionController','onLoadCall',contractId,exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj);            
        }        
        return wrapperObj ; 
    }
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    private static MBFS_Customer_Intention__c createCustomerIntentionObject(Contract contractObj){
        MBFS_Customer_Intention__c customerIntentionObj = new MBFS_Customer_Intention__c();
        customerIntentionObj.MBFS_Contract__c = contractObj.Id ;
        customerIntentionObj.MBFS_Contract_Expiry_Duration__c = contractObj.MBFS_Expiry_Duration__c ;
        customerIntentionObj.MBFS_Comments__c = '' ; 
        customerIntentionObj.MBFS_Communication_Channel__c = '' ;
        customerIntentionObj.MBFS_Option__c = '' ;
        customerIntentionObj.MBFS_Sub_Option__c = '' ;
        
        if(contractObj.MBFS_Agility__c != null){
            customerIntentionObj.MBFS_Contract_Type__c = contractObj.MBFS_Agility__c ;
        }else{
            customerIntentionObj.MBFS_Contract_Type__c = MBFS_Constant.NON_AGILITY ;
        }   
        return customerIntentionObj ;
    }
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    private static Map<String,List<String>> getOptionToSubOption(List<MBFS_RTH_SubOutComeAndAction__c> subOutComeOutcomeList){
        Map<String,List<String>> optionToSubOptionMap = new Map<String,List<String>>();
        
        for(Integer i = 0 ; i < subOutComeOutcomeList.size() ; i++ ){     
            for(MBFS_RTH_SubOutComeAndAction__c optionSubOptionObj : subOutComeOutcomeList ){
                if(optionSubOptionObj.MBFS_Sequence__c == i) {  
                    if(optionToSubOptionMap.get(optionSubOptionObj.Name) == null) {
                        List<String> natureList = new List<String>();
                        natureList.add(optionSubOptionObj.MBFS_Sub_Outcome__c);
                        optionToSubOptionMap.put(optionSubOptionObj.Name,natureList);
                    }else{
                        List<String> natureList = optionToSubOptionMap.get(optionSubOptionObj.Name);
                        natureList.add(optionSubOptionObj.MBFS_Sub_Outcome__c);
                        optionToSubOptionMap.put(optionSubOptionObj.Name,natureList);               
                    }
                }
            }
        }                 
        return optionToSubOptionMap ;
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @Description : This method is use to save the customer intetion record and validate customer intention fields . 
    */ 
    @AuraEnabled
    public static MBFS_CustomerIntentionWrapper.ExceptionWrapper insertCustomerIntention(String customerIntention,String contractObject) 
    { 
        MBFS_CustomerIntentionWrapper.ExceptionWrapper exceptionWrapper = new MBFS_CustomerIntentionWrapper.ExceptionWrapper();
        try{
            MBFS_Customer_Intention__c customerIntentionObj =  (MBFS_Customer_Intention__c) System.JSON.deserialize(customerIntention, MBFS_Customer_Intention__c.class);   
            Contract contractObj =  (Contract) System.JSON.deserialize(contractObject, Contract.class);       
            
            if(customerIntentionObj != null){
                 if(customerIntentionObj.MBFS_Communication_Channel__c == '' || customerIntentionObj.MBFS_Communication_Channel__c == MBFS_Constant.NONE_PICKLIST){
                    exceptionWrapper.errorCode = 1001 ;
                    exceptionWrapper.errorMessage = 'Communication Channel '+Label.MBFS_Is_Required;
                }else if(customerIntentionObj.MBFS_Option__c == '' || customerIntentionObj.MBFS_Option__c == MBFS_Constant.NONE_PICKLIST){
                    exceptionWrapper.errorCode = 1002 ;
                    exceptionWrapper.errorMessage = 'Option '+Label.MBFS_Is_Required;
                }else if(customerIntentionObj.MBFS_Sub_Option__c == '' || customerIntentionObj.MBFS_Sub_Option__c == MBFS_Constant.NONE_PICKLIST){
                    exceptionWrapper.errorCode = 1003 ;
                    exceptionWrapper.errorMessage = 'Sub-option '+Label.MBFS_Is_Required;
                }else{
                    exceptionWrapper.errorCode = 0 ;
                    exceptionWrapper.errorMessage = '';
                    insert customerIntentionObj ;                    
                }
            }else {             
                throw new AuraHandledException(Label.MBFS_ParameterIsNull);
            }
        }catch(Exception exce){
            exceptionWrapper.isError = true ;
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_CustomerIntentionController','insertCustomerIntention',customerIntention,exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj);           
        }      
        return exceptionWrapper ;
    }
}