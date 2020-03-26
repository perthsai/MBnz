trigger MBFS_TriggerOnTask on Task (after delete, after insert, 
									after undelete, after update, 
									before delete, before insert, 
									before update) 
{
	MBFS_TriggerOnTaskHandler objHandler = new MBFS_TriggerOnTaskHandler();
    objHandler.runTrigger();
}