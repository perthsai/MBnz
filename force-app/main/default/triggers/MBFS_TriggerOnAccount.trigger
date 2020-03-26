trigger MBFS_TriggerOnAccount on Account (after delete, after insert, after undelete, after update, before delete, before insert, before update) 
{
    MBFS_TriggerOnAccountHandler obj = new MBFS_TriggerOnAccountHandler();
    obj.runTrigger();   
}