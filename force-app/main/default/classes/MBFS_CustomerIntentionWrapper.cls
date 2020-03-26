/**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Wrapper class for customer intention screen
**/
public class MBFS_CustomerIntentionWrapper {

    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: sub Wrapper class 
    **/
    public class WrapperData  implements MBFS_CutomerIntentionMarkerInterface{
        @AuraEnabled public String contractType{get;set;}
        @AuraEnabled public List<String> communicationChannel{get;set;}
        @AuraEnabled public Map<String,List<String>> optionToSubOptionMap{get;set;}
        @AuraEnabled public Contract contractObj {get;set;}
        @AuraEnabled public Boolean isError{get;set;} 
        @AuraEnabled public MBFS_Customer_Intention__c customerIntentionObj{get;set;} 
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Sub Wrapper class  for exception status and message 
    **/
    public class ExceptionWrapper implements MBFS_CutomerIntentionMarkerInterface{
        @AuraEnabled public Boolean isError{get;set;} 
        @AuraEnabled public String errorMessage{get;set;}
        @AuraEnabled public Integer errorCode{get;set;}
    }
}