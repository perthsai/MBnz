/**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Controller Class for RTM 
**/
public class MBFS_CreateNewLeadCtrWrapper {

    public class WrapperData implements MBFS_MarkerInterface{
        @AuraEnabled public MBSF_RTMDataWrapper.RTMPickListValues pickListValues {get;set;}
        @AuraEnabled public MBSF_RTMDataWrapper.NewEditTaskData newEditTaskData {get;set;}
        @AuraEnabled public Boolean isError{get;set;} 
        @AuraEnabled public Date newTaskDefaultDate{get;set;}
    }
}