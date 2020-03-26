/**
    @author: Lokesh Pant
    @company: Saasfocus
    @description: Schedule class to create campaign and Campaign members for 3 MONTHS.
**/
global class mbfs_scheduled_3_Months_Campaign implements Schedulable 
{
    //Campaign name should be 3_MONTHS_DECEMBER_2017
    global void execute(SchedulableContext sc) 
    {
        string campaignName =  MBSF_CommonHelper.getcamapignName('3_MONTHS'); 
        Id campaignId;          
        if(MBSF_CommonHelper.getExistingCamapignId(campaignName) == null){
            campaignId = MBSF_CommonHelper.createCampaign(campaignName,'3_MONTHS');
            mbfs_addCampaignMembers objMembers = new mbfs_addCampaignMembers(campaignId,'3_MONTHS');
            database.executeBatch(objMembers);
        }       
    }
}