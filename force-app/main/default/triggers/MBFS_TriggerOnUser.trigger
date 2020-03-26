trigger MBFS_TriggerOnUser on User (after delete, after insert, after undelete, after update, before delete, before insert, before update) 
{
     MBFS_TriggerOnUserHandler obj = new MBFS_TriggerOnUserHandler();
     obj.runTrigger();    
}