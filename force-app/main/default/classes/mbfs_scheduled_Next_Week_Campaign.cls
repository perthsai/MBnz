/**
    @author: Lokesh Pant
    @company: Saasfocus
    @description: Schedule class to create campaign and Campaign members for NEXT Week.
**/
global class mbfs_scheduled_Next_Week_Campaign implements Schedulable 
{
    //Campaign name should be NEXT_WEEK_DECEMBER_2017
    global void execute(SchedulableContext sc) 
    {
        string campaignName =  MBSF_CommonHelper.getcamapignName('NEXT_WEEK'); 
        Id campaignId;          
        if(MBSF_CommonHelper.getExistingCamapignId(campaignName) <> null)
            campaignId = MBSF_CommonHelper.getExistingCamapignId(campaignName);
        else
            campaignId = MBSF_CommonHelper.createCampaign(campaignName,'NEXT_WEEK');
        
        mbfs_addCampaignMembers objMembers = new mbfs_addCampaignMembers(campaignId,'NEXT_WEEK');
        database.executeBatch(objMembers);      
    }
}