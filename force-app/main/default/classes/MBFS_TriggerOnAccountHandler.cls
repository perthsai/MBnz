/**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Trigger handler for account
**/
public with sharing  class MBFS_TriggerOnAccountHandler 
{
    public void runTrigger()
    {
        // Method will be called to handle After Insert events       
        if(Trigger.isAfter && Trigger.isInsert)
        {
            onAfterInsert((list<Account>)trigger.new);
        }
        // Method will be called to handle After update events       
        if(Trigger.isAfter && Trigger.isUpdate)
        {
            onAfterUpdate((list<Account>)trigger.new,(Map<Id,Account>)trigger.oldMap);
        }
        // Method will be called to handle After update events       
        if(Trigger.isBefore && Trigger.isUpdate)
        {
            onbeforeUpdate((list<Account>)trigger.new,(Map<Id,Account>)trigger.oldMap);
        }
   }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
   */ 
  private void onBeforeUpdate(list<Account> lstTriggerNew,map<Id,Account>triggerOldMap)
  {
  	
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
   */ 
  private void onAfterInsert(list<Account> lstTriggerNew)
  {
  	 ceateDealerGroupAndQueue(lstTriggerNew,null);
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
   */ 
  private  void onAfterUpdate(list<Account> triggerNew,map<Id,Account>triggerOldMap)
  {
  	 ceateDealerGroupAndQueue(triggerNew,triggerOldMap);
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
   */ 
  public static void ceateDealerGroupAndQueue(list<Account> triggerNew,map<Id,Account>triggerOldMap)
  {
  		set<Id>setAccountId         = new set<Id>();
  		Id accountRecordTypeId      = MBSF_CommonHelper.getRecordTypeId('Account','Dealer Account'); 
  		List<group>lstGroupToInsert = new List<group>();
  		List<group>lstQueueToInsert = new List<group>();
   		for(Account objAccount:triggerNew)
  		{
  			if( objAccount.MBFS_Sales_Group__c == true && 
  				 (trigger.isInsert ||
  				  objAccount.MBFS_Sales_Group__c <> triggerOldMap.get(objAccount.id).MBFS_Sales_Group__c) &&
  				objAccount.recordTypeId == accountRecordTypeId &&
  				objAccount.MBFS_Dealer_Code__c <> null)
  			{
  				//create group.
  				lstGroupToInsert.add(createGroup(objAccount.MBFS_Dealer_Code__c));
  				
  				//create queue 
  				lstQueueToInsert.add(createQueue(objAccount.MBFS_Dealer_Code__c));
  			}
  		}//End of account  loop;  
  		if(lstGroupToInsert.size()>0)
  		{
  			//insert group 
  			   Database.SaveResult[] srGroupList = Database.insert(lstGroupToInsert, false);
  			
  			//insert queue
  			   Database.SaveResult[] srQueueList = Database.insert(lstQueueToInsert, false);
  			
  			// get group success Id. 
  			   set<Id>setGroupSuccessId = getRecordSuccessId(srGroupList);
  			
  			// get queue success Id. 
  			   set<Id>setQueueSuccessId = getRecordSuccessId(srQueueList);
  			
  			//create QueueSObject
  			// due to set/nonSetUp object validation, this method is in future. 
  			   createQueueSobject(setQueueSuccessId);
  			
  			//add Group  as queue member.
  			// due to set/nonSetUp object validation, this method is in future.
  			   addGroupAsQueueMember(setGroupSuccessId,setQueueSuccessId);
  			
  		}
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
   */ 
  private static group createGroup(string dealerCode)
  {
  	 Group  objGroup                = new Group();
  	 objGroup.DeveloperName         = 'X'+dealerCode+'_Sales';//due to validation of Group name(Can only start with alphabet and only contain underscore.)
  	 objGroup.Name                  = dealerCode+' Sales';
  	 return  objGroup;
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
   */ 
   //In this method Group Develooper name is used as 'X'+GroupCode+'_DealerSalesQueue', as if the user manually creates a group and the group name starts with Number then
   // automatically salesforce appends 'X' in the developer name. 
  private static group createQueue(string dealerCode)
  {
  	 Group  objGroup                = new Group();
  	 objGroup.Name                  = dealerCode+'-DealerSalesQueue';
  	 objGroup.DeveloperName         = 'X'+dealerCode+'_DealerSalesQueue';//due to validation of Group name(Can only start with alphabet and only contain underscore.)
  	 objGroup.Type                  = 'Queue';
  	 objGroup.Email                 = '';
  	 objGroup.DoesSendEmailToMembers= true;
  	 objGroup.DoesIncludeBosses     = true;
  	 return  objGroup;
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
   */ 
  private static QueueSObject createQueueSobject(id queueId)
  {
  	   QueueSObject obj = new QueueSObject();
  	   obj.SobjectType  = 'Lead';
  	   obj.QueueId      =  queueId;
  	   return obj;
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
   */ 
  @future
  private static void createQueueSobject(set<Id>setQueueId)
  {
	  	List<QueueSObject>lstQueueSObject = new List<QueueSObject>();
	  	for(Id queueId:setQueueId)
	  	{
	  		lstQueueSObject.add(createQueueSobject(queueId));
	  	}
	  	if(lstQueueSObject.size()>0)
	  	   insert lstQueueSObject;
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
   */ 
  private static set<Id>getRecordSuccessId(List<Database.SaveResult>lstSaveResult)
  {
  	set<Id>setSuccessId = new set<Id>();
	for (Database.SaveResult sr : lstSaveResult) 
	{
	    if (sr.isSuccess()) 
	    {
	        setSuccessId.add(sr.getId());
	    }
	}
	return setSuccessId; 
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
   */ 
  @future
  private static void addGroupAsQueueMember(set<Id>setGroupId,set<Id>setQueueId)
  {
  	  map<string,group>mapDealerCodeToDealerGroup = getGroupMap(setGroupId,' ');
  	  map<string,group>mapDealerCodeToDealerQueue = getGroupMap(setQueueId,'-');
  	  list<GroupMember>lstGroupMember = new List<GroupMember>();
  	  
  	  if(mapDealerCodeToDealerGroup <> null &&
  	     mapDealerCodeToDealerGroup.keyset().size()>0 &&
  	     mapDealerCodeToDealerQueue <> null &&
  	     mapDealerCodeToDealerQueue.keyset().size()>0)
  	  {
  	  	    for(string dealerCode:mapDealerCodeToDealerQueue.keyset())
  	  	    {
  	  	    	GroupMember objGroupMember    = new GroupMember();
  	  	    	objGroupMember.GroupId        = mapDealerCodeToDealerQueue.get(dealerCode).id;//queue Id
  	  	    	objGroupMember.UserOrGroupId  = mapDealerCodeToDealerGroup.get(dealerCode).id;//Group Id
  	  	    	lstGroupMember.add(objGroupMember);
  	  	    }//End of group loop.
  	  	    
  	  	    if(lstGroupMember.size()>0)
  	  	       insert lstGroupMember;
  	  }   
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
   */ 
  private static map<string,group> getGroupMap(set<Id>setGroupId,string separator)
  {
  	  map<string,group>mapDealerCodeToDealerGroup = new map<string,group>();
  	  List<string>lstdelaerGroupName;  
  	  for(Group objGroup:[select id,Name,DeveloperName from Group where id in:setGroupId])
  	  {
  	  	    lstdelaerGroupName = objGroup.Name.split(separator);
  	  	    if(lstdelaerGroupName <> null && lstdelaerGroupName.size()>0)
  	  	    {
  	  	    	mapDealerCodeToDealerGroup.put(lstdelaerGroupName[0],objGroup);	
  	  	    }
  	  }//End of loop.
  	  
  	  return mapDealerCodeToDealerGroup;
  }
}