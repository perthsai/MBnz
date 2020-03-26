trigger MBFS_TriggerOnLead on Lead (after delete, after insert, after undelete, after update, before delete, before insert, before update) 
{
    MBFS_TriggerOnLeadhandler obj = new MBFS_TriggerOnLeadhandler();
    obj.runTrigger();
}