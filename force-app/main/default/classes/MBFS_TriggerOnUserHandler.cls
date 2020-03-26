/**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Trigger handler for user
**/
public with sharing  class MBFS_TriggerOnUserHandler 
{
   public void runTrigger()
    {
        // Method will be called to handle After Insert events       
        if(Trigger.isAfter && Trigger.isInsert)
        {
            onAfterInsert((list<user>)trigger.new);
        }
        // Method will be called to handle After update events       
        if(Trigger.isAfter && Trigger.isUpdate)
        {
            onAfterUpdate((list<user>)trigger.new,(Map<Id,user>)trigger.oldMap);
        }
        // Method will be called to handle After update events       
        if(Trigger.isBefore && Trigger.isUpdate)
        {
            onbeforeUpdate((list<user>)trigger.new,(Map<Id,user>)trigger.oldMap);
        }
   }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/ 
  private void onBeforeUpdate(list<user> lstTriggerNew,map<Id,user>triggerOldMap)
  {
    
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/ 
  private void onBeforeInsert(list<user> lstTriggerNew)
  {
      
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/ 
  private void onAfterInsert(list<user> lstTriggerNew)
  {
       addPartnerUserAsGroupMember(lstTriggerNew,null);
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/ 
  private  void onAfterUpdate(list<user> triggerNew,map<Id,user>triggerOldMap)
  {
      addPartnerUserAsGroupMember(triggerNew,triggerOldMap);
  }
  /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/ 
  private static void addPartnerUserAsGroupMember(list<user> triggerNew,map<Id,user>triggerOldMap)
  {
      set<string>setSalesGroup = new set<string>();
      set<string>setUserId     = new set<string>();
      
      //get set user Id and sales group Id.
      for(user objUser:triggerNew)
      {
        if(   objUser.MBFS_Sales_Group_Name__c <> null && 
            objUser.contactId <> null &&
             ((trigger.isInsert && objUser.MBFS_Sales_Group__c) ||
              (trigger.isUpdate && triggerOldMap.get(objUser.id).MBFS_Sales_Group__c <> objUser.MBFS_Sales_Group__c)))
        {  
            setSalesGroup.add(objUser.MBFS_Sales_Group_Name__c);
            setUserId.add(objUser.Id);
        }  
      }
      if(setSalesGroup.size()>0)
      {
        //this method is used in future due to setup/non set up object validation.
        boolean isInFuture = System.isFuture();
        if(isInFuture){
              addUserAsGroupMember(setSalesGroup,setUserId,trigger.isUpdate);
        }  
        else{
            callFutureToAddGroupMember(setSalesGroup,setUserId,trigger.isUpdate);    
        }  
      }
  }
  
  /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/   
  @future
  private static void callFutureToAddGroupMember(set<string>setSalesGroup, set<string>setUserId,boolean isupdate)
  {
       addUserAsGroupMember(setSalesGroup,setUserId,isupdate);
  }
  
  /**
    @author: Lokesh Pant
    @company: Saasfocus
  **/   
  public static void addUserAsGroupMember(set<string>setSalesGroup, set<string>setUserId,boolean isupdate)
  {
        list<groupMember>lstgroupMember = new List<groupMember>();
        set<Id>setRemovedUserId = new set<Id>();
        set<Id>setGroupId = new set<Id>();
        map<string,group>mapGroupNameToGroup = new map<string,group>();
      for(group objGroup: [select id,Name from group where name in:setSalesGroup])
        {
               mapGroupNameToGroup.put(objGroup.Name,objGroup);
        }//End of for loop
          
        if(mapGroupNameToGroup <> null && mapGroupNameToGroup.keyset().size()>0)
        {
           for(user objUser:[select id,MBFS_Sales_Group__c,MBFS_Sales_Group_Name__c 
                        from   user 
                        where  id in:setUserId])
           {
                  if(objUser.MBFS_Sales_Group__c && 
                     mapGroupNameToGroup.get(objUser.MBFS_Sales_Group_Name__c) <> null)
                  {
                       //Insert user in the salesgroup
                       groupmember objGM      = new groupMember();
                       objGM.GroupId          = mapGroupNameToGroup.get(objUser.MBFS_Sales_Group_Name__c).id;
                       objGM.UserOrGroupId    = objUser.id;
                       lstgroupMember.add(objGM);
                  }
                  else if(objUser.MBFS_Sales_Group__c == false && 
                          isupdate &&
                          mapGroupNameToGroup.get(objUser.MBFS_Sales_Group_Name__c) <> null)
                  {
                         //remove user from sales group.
                         setRemovedUserId.add(objUser.id);
                         setGroupId.add(mapGroupNameToGroup.get(objUser.MBFS_Sales_Group_Name__c).id); 
                  }  
           }//End of User Loop.
           
           // insert group Members.   
           // here database.insert false is used to insert only new group member to salesforce, if any existing group member is came to insert then that group member will not be inserting
           // and that's why the failed scenaio is not catered here.
           if(lstgroupMember <> null && lstgroupMember.size()>0){
                database.insert(lstgroupMember,false);
           }
           //Delete Group Members
           if(setRemovedUserId.size()>0){
             delete [select id from groupMember where GroupId in:setGroupId and UserOrGroupId in:setRemovedUserId];
           }  
        }
    }
}