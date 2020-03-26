/**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Trigger handler for lead object
**/
public with sharing  class MBFS_TriggerOnLeadhandler 
{
   public void runTrigger()
    {
        // Method will be called to handle After Insert events       
        if(Trigger.isAfter && Trigger.isInsert)
        {
            onAfterInsert((list<lead>)trigger.new);
        }
        // Method will be called to handle After update events       
        if(Trigger.isAfter && Trigger.isUpdate)
        {
            onAfterUpdate((list<lead>)trigger.new,(Map<Id,lead>)trigger.oldMap);
        }
        // Method will be called to handle After update events       
        if(Trigger.isBefore && Trigger.isUpdate)
        {
            onbeforeUpdate((list<lead>)trigger.new,(Map<Id,lead>)trigger.oldMap);
        }
        // Method will be called to handle before insert events       
        if(Trigger.isBefore && Trigger.isInsert)
        {
            onbeforeInsert((list<lead>)trigger.new);
        }
   }
   /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/ 
  private void onBeforeUpdate(list<lead> lstTriggerNew,map<Id,lead>triggerOldMap)
  {
     assignRetailerLeadToDealerQueue(lstTriggerNew,triggerOldMap,false);
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/ 
  private void onbeforeInsert(list<lead> lstTriggerNew)
  {
      assignRetailerLeadToDealerQueue(lstTriggerNew,null,true);
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/ 
  private void onAfterInsert(list<lead> lstTriggerNew)
  {
		shareWithDealerGroup(lstTriggerNew,null,true);
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/ 
  private  void onAfterUpdate(list<lead> lstTriggerNew,map<Id,lead>triggerOldMap)
  {
      shareWithDealerGroup(lstTriggerNew,triggerOldMap,false);
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/ 
  private void shareWithDealerGroup(list<lead> triggerNew,map<Id,lead>triggerOldMap,boolean isInsert)
  {
  	    set<string>setSalesGroupName         = new set<string>();
  	    list<LeadShare> lstLeadShareToInsert = new List<LeadShare>();
  	    map<string,group>mapGroupNameToGroup = new map<string,group>();
  		for(lead objlead : triggerNew)
  		{
	  		if(isInsert && objlead.MBFS_Account__c != null)
	  		{
	           setSalesGroupName.add(objlead.MBFS_Sales_Group_Name__c);
	        }
	        else if(!isInsert && 
	                objlead.MBFS_Account__c != null && 
	                triggerOldMap.ContainsKey(objlead.Id) && 
	                (triggerOldMap.get(objlead.Id).MBFS_Account__c != objlead.MBFS_Account__c || 
	                 (triggerOldMap.get(objlead.Id).OwnerId != objlead.OwnerId)))
	        {
	           setSalesGroupName.add(objlead.MBFS_Sales_Group_Name__c);               
	        }
  		}//End of loop   
        
        if(setSalesGroupName.size()>0)
        {
        	 for(group objGroup: [select id,Name from group where name in:setSalesGroupName])
	         {
	               mapGroupNameToGroup.put(objGroup.Name,objGroup);
	         }//End of for loop
	         
	         if(mapGroupNameToGroup.size()>0)
	         {
	         	  for(lead objlead : triggerNew)
	         	  {
	         	  	  if(mapGroupNameToGroup.get(objlead.MBFS_Sales_Group_Name__c) <> null)
	         	  	  {
	         	  	  	    LeadShare objLeadShare        = new LeadShare();
                            objLeadShare.LeadId           = objLead.Id;
                            objLeadShare.UserOrGroupId    = mapGroupNameToGroup.get(objlead.MBFS_Sales_Group_Name__c).id;
                            objLeadShare.LeadAccessLevel  = 'Edit';
                            objLeadShare.RowCause         = 'Manual';
                            lstLeadShareToInsert.add(objLeadShare); 
	         	  	  }
	         	  }//End of loop
	         }
	         
	         if(lstLeadShareToInsert.size()>0)
	         {
	         	 database.insert(lstLeadShareToInsert,false);
	         }
        }
  }
    
  /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/   
  private static void assignRetailerLeadToDealerQueue(list<lead> triggerNew,map<Id,lead>triggerOldMap,boolean isInsert)
  {
  	    set<string>setDealerQueueName  = new set<string>();
  	    map<string,string>mapQueueNameToQueueId = new map<string,string>();
  	    for(lead objlead : triggerNew)
  		{
	  		if(isInsert && objlead.MBFS_Account__c != null)
	  		{
	           setDealerQueueName.add(objlead.MBFS_Dealer_Sales_Queue__c	);
	        }
	        else if(!isInsert && 
	                objlead.MBFS_Account__c != null && 
	                triggerOldMap.ContainsKey(objlead.Id) && 
	                triggerOldMap.get(objlead.Id).MBFS_Account__c != objlead.MBFS_Account__c)
	        {
	           setDealerQueueName.add(objlead.MBFS_Dealer_Sales_Queue__c	);               
	        }
  		}//End of loop   
  		
  		if(setDealerQueueName.size()>0)
  		{
  			for(group objGroup: [select id,Name from group where name in:setDealerQueueName and type='Queue'])
	        {
	               mapQueueNameToQueueId.put(objGroup.Name,objGroup.id);
	        }//End of for loop
	        
	        if(mapQueueNameToQueueId.size()>0)
	        {
	        	for(lead objlead : triggerNew)
  				{
  					if(mapQueueNameToQueueId.get(objlead.MBFS_Dealer_Sales_Queue__c) <> null)
  						objlead.ownerId = mapQueueNameToQueueId.get(objlead.MBFS_Dealer_Sales_Queue__c);
  				}
	        }
  		}
  }
}