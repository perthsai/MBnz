trigger MBFS_TriggerOnCampaignMember on MBFS_Campaign_Member__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) 
{

    MBFS_TriggerOnCampaignMemberHandler objHandler = new MBFS_TriggerOnCampaignMemberHandler();
    objHandler.runTrigger();
}