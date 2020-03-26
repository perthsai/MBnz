/**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Trigger handler for task object
**/
public with sharing class MBFS_TriggerOnTaskHandler 
{
    public void runTrigger()
    {
        // Method will be called to handle Before Insert events       
        if(Trigger.isBefore && Trigger.isInsert)
        {
            onBeforeInsert((list<Task>)trigger.new);
        }
        // Method will be called to handle After Insert events       
        if(Trigger.isAfter && Trigger.isInsert)
        {
            onAfterInsert((list<Task>)trigger.new);
        }
        // Method will be called to handle After update events       
        if(Trigger.isAfter && Trigger.isUpdate)
        {
            onAfterUpdate((list<Task>)trigger.new,(Map<Id,Task>)trigger.oldMap);
        }
        // Method will be called to handle Before update events       
        if(Trigger.isBefore && Trigger.isUpdate)
        {
            onbeforeUpdate((list<Task>)trigger.new,(Map<Id,Task>)trigger.oldMap);
        }
   }
   /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/ 
  private void onBeforeInsert(list<Task> lstTriggerNew)
  {
     updateTaskNumber(lstTriggerNew);
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/ 
  private void onBeforeUpdate(list<Task> lstTriggerNew,map<Id,Task>triggerOldMap)
  {
     //updateTaskNumber(lstTriggerNew);
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/ 
  private void onAfterInsert(list<Task> lstTriggerNew)
  {
      updateLastActivityOnContract(lstTriggerNew);
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/ 
  private  void onAfterUpdate(list<Task> triggerNew,map<Id,Task>triggerOldMap)
  {
     updateLastActivityOnContract(triggerNew);
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/ 
  private void updateLastActivityOnContract(list<Task> triggerNew)
  {
     
      set<Id>setContractId                    = new set<Id>();
      set<Id>setTaskId                        = new set<Id>();
      set<string> setCampaign                     = new set<string>();
      List<Contract>lstContractToUpdate       = new List<Contract>();
      map<Id,Contract>mapContractIdToContract = new map<Id,Contract>();
      for(Task objTask:triggerNew)
      {
          if(objTask.WhatId <> null && 
             MBSF_CommonHelper.isContactId(objTask.WhatId) &&
             objTask.Type == 'Call' &&
             (objTask.Status == 'Open' || objTask.Status == 'Completed')
             && objTask.MBFS_Campaign__c != null)
          {
                setTaskId.add(objTask.id);
                setContractId.add(objTask.WhatId);
                setCampaign.add(objTask.MBFS_Campaign__c);
          } 
      }//End of Trigger New Loop.
      if(setContractId.size()>0)
      {
           for(Contract objContract:[select id,
                                            (select id from Tasks where MBFS_Campaign__c=:setCampaign and status='Completed' and Type='Call')
                                     from Contract
                                     where id in:setContractId])
           {
                mapContractIdToContract.put(objContract.Id,objContract);
           }//End Of Contract Loop.
           
           for(Task objTask:triggerNew)
           {      
               if(setTaskId.contains(objTask.id))
               {
                  Contract objContact                            = new Contract(Id=objTask.WhatId);
                  objContact.MBFS_No_of_Completed_Task__c        = mapContractIdToContract.get(objTask.WhatId).Tasks.size();
                  objContact.MBFS_Last_Activity_Subject__c       = objTask.subject;
                  objContact.MBFS_Last_Activity_Segmentation__c  = objTask.MBFS_Campaign__c;
                  if(objTask.Status != null && objTask.Status !='Completed'){ 
                     objContact.MBFS_Last_Activity_Due_Date__c      = objTask.ActivityDate;
                  }
                  objContact.MBFS_Last_Activity_Comments__c      = objTask.Description;
                  objContact.MBFS_Last_Activity_Id__c   = objTask.id ;
                  if(objTask.Status != null && objTask.Status =='Completed'){
                      objContact.MBFS_Last_Activity_OutCome__c = objTask.MBFS_OutCome__c ;
                      objContact.MBFS_Last_Activity_Sub_OutCome__c = objTask.MBFS_Sub_Outcome__c ;
                  }    
                  lstContractToUpdate.add(objContact);  
               }
           }//End of loop.
           
           
           if(lstContractToUpdate.size()>0)
           {
               update lstContractToUpdate;
           }
      }
  }
  
   /**
    @author: Amarendra Kumar
    @company: Saasfocus
   **/
   private void updateTaskNumber(list<Task> triggerNew)
    {
        Set<Id> setContractId   = new Set<Id>();
        Set<String> setCampaign    = new Set<String>();
        Map<String,Integer> keyToTaskCountMap = new Map<String,Integer>();
        
        for(Task objTask:triggerNew)
        {
            if(objTask.WhatId <> null && MBSF_CommonHelper.isContactId(objTask.WhatId) && objTask.MBFS_Campaign__c != null)
            {
                setContractId.add(objTask.WhatId);
                setCampaign.add(objTask.MBFS_Campaign__c);     
            }           
        } 
        
        if(setContractId.size() > 0 && setCampaign.size() > 0){
            for(Task taskObj : [Select Id,MBFS_ContractMonth__c,MBFS_Campaign__c,WhatId,MBFS_Task_Number__c from Task where whatid IN : setContractId and MBFS_Campaign__c IN : setCampaign ]){
                
                
                String mapKey = taskObj.WhatId+'_'+taskObj.MBFS_Campaign__c ;               
                if(keyToTaskCountMap.get(mapKey) == null){                  
                    keyToTaskCountMap.put(mapKey,1);
                }else {
                    Integer count = keyToTaskCountMap.get(mapKey) + 1 ;                   
                    keyToTaskCountMap.put(mapKey,count);
                }
                
            }
            
            
            for(Task objTask:triggerNew)
            {
                if(objTask.WhatId <> null && MBSF_CommonHelper.isContactId(objTask.WhatId) && objTask.MBFS_Campaign__c != null)
                {
                    String mapKey = objTask.WhatId+'_'+objTask.MBFS_Campaign__c ;
                    if(keyToTaskCountMap.get(mapKey) != null){
                        objTask.MBFS_Task_Number__c = keyToTaskCountMap.get(mapKey) + 1;
                    }else {
                        objTask.MBFS_Task_Number__c = 1;
                    }
                    
                }
            }
            
        }   
    }
  
}