/**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Trigger handler for Campaign member
**/
public with sharing class MBFS_TriggerOnCampaignMemberHandler {
    
    public void runTrigger()
    {
        // Method will be called to handle Before Insert events       
        if(Trigger.isBefore && Trigger.isInsert)
        {
       
        }
        // Method will be called to handle After Insert events       
        if(Trigger.isAfter && Trigger.isInsert)
        {
            onAfterInsert((list<MBFS_Campaign_Member__c>)trigger.new);
        }
        // Method will be called to handle After update events       
        if(Trigger.isAfter && Trigger.isUpdate)
        {
            
        }
        // Method will be called to handle Before update events       
        if(Trigger.isBefore && Trigger.isUpdate)
        {
            onbeforeUpdate((list<MBFS_Campaign_Member__c>)trigger.new,(Map<Id,MBFS_Campaign_Member__c>)trigger.oldMap);
        }
    }
    /**
        @author: Amarendra Kumar
        @company: Saasfocus
    **/ 
    private void onBeforeInsert(list<MBFS_Campaign_Member__c> lstTriggerNew)
    {
        
    }
    /**
        @author: Amarendra Kumar
        @company: Saasfocus
    **/ 
    private void onBeforeUpdate(list<MBFS_Campaign_Member__c> lstTriggerNew,map<Id,MBFS_Campaign_Member__c>triggerOldMap)
    {
        
    }
    /**
        @author: Amarendra Kumar
        @company: Saasfocus
    **/ 
    private void onAfterInsert(list<MBFS_Campaign_Member__c> lstTriggerNew)
    {
        updateContract(lstTriggerNew);
    }
    
    /**
        @author: Amarendra Kumar
        @company: Saasfocus
    **/ 
    private void updateContract(list<MBFS_Campaign_Member__c> lstTriggerNew){
        if(lstTriggerNew != null && lstTriggerNew.size() > 0){
            Map<Id,Id> contractIdToCoampaignIdMap = new Map<Id,Id>();
            List<Contract> contractListToUpdate = new List<Contract>();
        
            for(MBFS_Campaign_Member__c campMemObj : lstTriggerNew){
                if(campMemObj.MBFS_Contract__c != null && campMemObj.MBFS_Campaign__c!= null){
                    contractIdToCoampaignIdMap.put(campMemObj.MBFS_Contract__c,campMemObj.MBFS_Campaign__c);                    
                }   
            }
            if(contractIdToCoampaignIdMap != null && contractIdToCoampaignIdMap.keySet().size() > 0){
                for(Id conId : contractIdToCoampaignIdMap.keySet()){
                    Contract conObj = new Contract(Id = conId ,MBFS_Campaign__c = contractIdToCoampaignIdMap.get(conId));
                    contractListToUpdate.add(conObj);
                }
                if(contractListToUpdate != null && contractListToUpdate.size() > 0){
                    update contractListToUpdate ;
                }
            }
        }        
    }
    
   
}