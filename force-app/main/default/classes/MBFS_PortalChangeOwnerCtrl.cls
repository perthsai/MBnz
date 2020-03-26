/**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Controller Class for portal owner change
**/
public With Sharing class MBFS_PortalChangeOwnerCtrl {

    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    @AuraEnabled
    public static MBFS_PortalChangeOwnerWarpper.WrapperData onLoadCall(String leadId) 
    {           
        MBFS_PortalChangeOwnerWarpper.WrapperData wrapData = new MBFS_PortalChangeOwnerWarpper.WrapperData();
        
        try{
            if(leadId != null){
                Lead leadObj = [Select Id,MBFS_Account__c,MBFS_Account__r.MBFS_Dealer_Code__c from Lead where Id =: leadId];
               
                if(leadObj.MBFS_Account__c != null && leadObj.MBFS_Account__r.MBFS_Dealer_Code__c != null) {
                    
                    String groupName = leadObj.MBFS_Account__r.MBFS_Dealer_Code__c+' Sales';
                    
                    Group groupDetails = [SELECT Id FROM Group where name =: groupName ];
                    
                    Set<Id> userIdSet = new Set<Id>();
                    for(GroupMember gmObj : [SELECT GroupId,Id,UserOrGroupId FROM GroupMember WHERE 
                                                         GroupId =: groupDetails.Id])
                    {
                        userIdSet.add(gmObj.UserOrGroupId);
                    }
                    
                    
                    
                    List<MBFS_PortalChangeOwnerWarpper.OwnerData> ownerList = new List<MBFS_PortalChangeOwnerWarpper.OwnerData>();                 
                    for(User userObject : [Select Name,Id,IsActive,ContactId,Contact.AccountId  FROM User where Id In: userIdSet])
                    {
                        MBFS_PortalChangeOwnerWarpper.OwnerData ownerData = new  MBFS_PortalChangeOwnerWarpper.OwnerData();
                        ownerData.userId = userObject.Id;
                        ownerData.userName =  userObject.name ;   
                        ownerList.add(ownerData);
                    }
                    wrapData.userIdToName = ownerList ;
                    wrapData.isError = false ;
                    
                }
            }
        }catch(Exception exce){
            wrapData.isError = true ;
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_PortalChangeOwnerCtrl','onLoadCall',leadId,exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj);            
        }    
        return wrapData ;
    } 
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    @AuraEnabled
    public static MBFS_PortalChangeOwnerWarpper.OwnerChnageSubmit changeOwner(String leadId,String ownerId) 
    {
        MBFS_PortalChangeOwnerWarpper.OwnerChnageSubmit OwnerChnageSubmit = new MBFS_PortalChangeOwnerWarpper.OwnerChnageSubmit();
        try{
            if(leadId != null && ownerId != null){
                Lead leadObj = new Lead(Id =leadId , OwnerId  = ownerId );
                update leadObj ;
                
                ListView listViewObj = [SELECT Id, Name FROM ListView WHERE SobjectType = 'Lead' and Name='All Open Leads' limit 1];
                OwnerChnageSubmit.isError = false ;
                OwnerChnageSubmit.listId =  listViewObj.Id ;
            }           
        } catch(Exception exce){
            OwnerChnageSubmit.isError = true ;
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_PortalChangeOwnerCtrl','onLoadCall','Lead Id '+leadId+' ,Owner Id '+ownerId,exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj);            
        }  
        return OwnerChnageSubmit ;
    }
}