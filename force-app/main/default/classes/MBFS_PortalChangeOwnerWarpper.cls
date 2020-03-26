/**
@author: Amarendra Kumar
@company: Saasfocus
@description: Wrapper Class to change owner 
**/
public class MBFS_PortalChangeOwnerWarpper {
    
    public class WrapperData implements MBFS_MarkerInterface{
        @AuraEnabled public List<OwnerData> userIdToName{get;set;} 
        @AuraEnabled public Boolean isError{get;set;} 
    }
    
    public class OwnerData implements MBFS_MarkerInterface{
        @AuraEnabled public String userId{get;set;} 
        @AuraEnabled public String userName{get;set;}  
    }
    
     public class OwnerChnageSubmit implements MBFS_MarkerInterface{
        @AuraEnabled public String listId{get;set;} 
        @AuraEnabled public Boolean isError{get;set;} 
    }
}