/**
    @author: Lokesh Pant
    @company: Saasfocus
    @description: Schedule class to create campaign and Campaign members for 6 MONTHS.
**/
global class mbfs_scheduled_6_Months_Campaign implements Schedulable 
{
    //Campaign name should be 6_MONTHS_DECEMBER_2017
    global void execute(SchedulableContext sc) 
    {
        string campaignName =  MBSF_CommonHelper.getcamapignName('6_MONTHS'); 
        Id camapignId;          
        if(MBSF_CommonHelper.getExistingCamapignId(campaignName) == null){
            camapignId = MBSF_CommonHelper.createCampaign(campaignName,'6_MONTHS');
            mbfs_addCampaignMembers objMembers = new mbfs_addCampaignMembers(camapignId,'6_MONTHS');
            database.executeBatch(objMembers);
        }       
    }
}