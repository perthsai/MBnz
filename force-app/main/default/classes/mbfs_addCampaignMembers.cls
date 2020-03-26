/**
    @author: Lokesh Pant
    @company: Saasfocus
    @description: Batch class to add campaign member
    @Date: 02-01-2018 
**/ 

global class mbfs_addCampaignMembers implements 
             Database.Batchable<sObject>,
             Database.Stateful
{
    global Id campaignId;
    global string filter;
    
    //used to initialise filter name and campaign Id.
    global mbfs_addCampaignMembers (Id obj_campaignId,string filter_value)
    {
         campaignId = obj_campaignId;
         filter     = filter_value; 
    }   
    
    //This is used to load all the contracts based on filter value.
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
         string strQuery = 'select id,Status,MBFS_Suppress__c from Contract where MBFS_Contract_Expiry_Duration__c=:filter';
         return Database.getQueryLocator(strQuery);      
    }
    
    //This method is called for each batch of records that you pass to it.
    global void execute(Database.BatchableContext BC, List<Contract> scope)
    {
        List<MBFS_Campaign_Member__c>lstCampaignMember = new List<MBFS_Campaign_Member__c>();
        for(Contract objContract:scope)
        {
             lstCampaignMember.add(createCampaignMember(objContract,campaignId)); 
        }
         
        database.insert(lstCampaignMember,false);            
    }
    
    //This method is called after all batches are processed.
    global void finish(Database.BatchableContext BC)
    {
          
    }
    
    private MBFS_Campaign_Member__c createCampaignMember(Contract objContract,Id campaignId)
    {
         MBFS_Campaign_Member__c objMember = new MBFS_Campaign_Member__c();
         objMember.MBFS_Campaign__c        = campaignId;
         objMember.MBFS_Contract__c        = objContract.Id;        
         objMember.mbfs_Status__c          = objContract.Status;
         objMember.mbfs_Suppress__c        = objContract.MBFS_Suppress__c;
         return objMember;
    }
    
}