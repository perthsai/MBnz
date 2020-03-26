@isTest
public class MBFS_CreateNewLeadControllerTest {
    public static User userObj ;
    public static List<MBSF_ContractColumns__c> contractColumnObj ;
    public static Contract contractObj ;
    public static Account accObj ;
    public static Campaign campObj ;
    public static MBSF_LeadColumns__c leadColObj ;
    public static List<Task> taskList = new  List<Task> ();
    public static String initCallHelper   = '{"Task":["MBFS_Customer_Not_Interested__c","MBFS_Do_Not_Call__c","MBFS_Lost_to_Competitor__c"],"Lead":["MBFS_Interested_Vehicle_category__c","MBFS_Vehicle_Make_interest__c","MBFS_Model_Interest__c","MBFS_Lead_Type__c"]}';
    public static String submitDataNewLead   = '';
    public static List<MBFS_RTH_SubOutComeAndAction__c>  outCome ;
    public static List<MBFS_Diary_Notes__c> dilyNotes ;
    public static List<Lead> leadList ;
    public static List<MBFS_RTM_Contract_Column__c> rtmContractColumn ;
    public static List<MBFS_CampaignContractColumn__c> campContList ;
    public static MBSF_RTMDataWrapper.CommonDataWrapper commDataWrap;
    
    public static List<MBFS_Contract_Account_Junction__c> guarantorList ;
    public static List<mbfs_Insurance__c> insuranceList ;
    public static List<MBFS_Customer_Intention__c>  customerIntentionObj ;
    
    
    private static void  loadData(){
        
        
        userObj = MBFS_CommonDataGeneratorTest.generateStandardUser();
        contractColumnObj = MBFS_CommonDataGeneratorTest.generateMBSFContractColumns();
        accObj= MBFS_CommonDataGeneratorTest.createAccount();
        campObj = MBFS_CommonDataGeneratorTest.createCampaign();
        contractObj =     MBFS_CommonDataGeneratorTest.generateContract(userObj.Id,accObj.Id,campObj.id);
        taskList = MBFS_CommonDataGeneratorTest.createtask(contractObj.Id);
        contractObj = MBFS_CommonDataGeneratorTest.updateContract(contractObj,taskList.get(0).Id);
        
        leadColObj = MBFS_CommonDataGeneratorTest.generateMBSFLeadColumns();
        outCome = MBFS_CommonDataGeneratorTest.createSubOutComeAndAction();
        dilyNotes = MBFS_CommonDataGeneratorTest.createDairyNotes(contractObj.Id);
        leadList = MBFS_CommonDataGeneratorTest.createLead(contractObj.Id);
        
        rtmContractColumn = MBFS_CommonDataGeneratorTest.generateMBSFRTMContractColumns();
        
        campContList = MBFS_CommonDataGeneratorTest.generateMBSFCampContractColumns();
        
        guarantorList  = MBFS_CommonDataGeneratorTest.contractAccountJunction(accObj.Id,contractObj.Id);
        
        insuranceList  = MBFS_CommonDataGeneratorTest.getIndurances(contractObj.Id);
        customerIntentionObj  = MBFS_CommonDataGeneratorTest.generateCustomerIntention(contractObj.Id);
        
    }
    
     static testMethod void unitTestgetPickListToValue() {
        loadData();       
        MBFS_CreateNewLeadController.onLoadCall(initCallHelper,contractObj.Id);        
    }
    static testMethod void unitTestOnEditNewTask() {
        loadData();        
        MBFS_CreateNewLeadController.onEditNewTask(contractObj.Id);        
    }
    static testMethod void unitTestOnEditNewTask1() {
        loadData();       
        contractObj = MBFS_CommonDataGeneratorTest.updateContract(contractObj,null);
        MBFS_CreateNewLeadController.onEditNewTask(contractObj.Id);        
    }
    
   static testMethod void unitTestonNewEditTaskSubmit() {
        loadData();
        submitDataNewLead   = '{"taskObj":{"Id":"'+taskList.get(0).Id +'","Subject":"Call","ActivityDate":"2017-11-09","Type":"Call","Description":"calll me up","WhatId":"'+contractObj.id+'"},"outcome":"Made Contact","suboutcome":"Lead Sent","subOutComeAction":"WASH_LIST_NEW_LEAD","newtask":{"sobjectType":"Task","Subject":"Call","ActivityDate":"2017-11-13","Description":""},"newlead":{"sobjectType":"Lead","Description":"12344","PartnerAccount":"","FirstName":"Martin","LastName":"lawrence","Email":"amarendra.kumar1@saasfocus.com","Phone":"8888888888","MobilePhone":"888888888","MBFS_Dealer_Account__c":"'+accObj.Id+'","MBFS_Dealer_Account__r":{"Name":"City Mercedes","Id":"'+accObj.Id+'"},"MBFS_Nature_of_Request__c":"Trade","MBFS_Lead_Type__c":"Retailer Lead","MBFS_Interested_Vehicle_category__c":"PC","MBFS_Vehicle_Make_interest__c":"Mercedes-Benz","MBFS_Model_Interest__c":"A Class"},"campaignId":"None","dateTimeFilter":"None","selectedContractID":"'+contractObj.Id+'"}';
        
        MBFS_CreateNewLeadController.onNewEditTaskSubmit(submitDataNewLead);        
    }
    static testMethod void unitTestonNewEditTaskSubmitDND() {
        loadData();
        submitDataNewLead   = '{"taskObj":{"Id":"'+taskList.get(0).Id +'","Subject":"Call","ActivityDate":"2017-11-09","Type":"Call","Description":"calll me up","WhatId":"'+contractObj.id+'","MBFS_Do_Not_Call__c":"Over Contracted"},"outcome":"No Call Required","suboutcome":"Do Not Call Register","subOutComeAction":"WASH_LIST_DO_NOT_CALL_REGISTER","newtask":{"sobjectType":"Task","Subject":"Call","ActivityDate":"2017-11-13","Description":"","MBFS_Do_Not_Call__c":"Over Contracted"},"newlead":{"sobjectType":"Lead","Description":"","PartnerAccount":"","FirstName":"Martin","LastName":"lawrence","Email":"amarendra.kumar1@saasfocus.com","Phone":"8888888888","MobilePhone":"888888888","MBFS_Dealer_Account__c":"'+accObj.Id+'","MBFS_Dealer_Account__r":{"Name":"City Mercedes","Id":"'+accObj.Id+'"}},"campaignId":"None","dateTimeFilter":"None","selectedContractID":"'+contractObj.Id+'"}';
       
        MBFS_CreateNewLeadController.onNewEditTaskSubmit(submitDataNewLead);        
    }
    static testMethod void unitTestonNewEditTaskSubmitLTC() {
        loadData();
        submitDataNewLead   = '{"taskObj":{"Id":"'+taskList.get(0).Id +'","Subject":"Call","ActivityDate":"2017-11-09","Type":"Call","Description":"calll me up","WhatId":"'+contractObj.id+'","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"outcome":"Made Contact","suboutcome":"Lost to Competitor","subOutComeAction":"WASH_LIST_LOST_TO_COMPETITOR","newtask":{"sobjectType":"Task","Subject":"Call","ActivityDate":"2017-11-13","Description":"","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"newlead":{"sobjectType":"Lead","Description":"","PartnerAccount":"","FirstName":"Martin","LastName":"lawrence","Email":"amarendra.kumar1@saasfocus.com","Phone":"8888888888","MobilePhone":"888888888","MBFS_Dealer_Account__c":"'+accObj.Id+'","MBFS_Dealer_Account__r":{"Name":"City Mercedes","Id":"'+accObj.Id+'"}},"campaignId":"None","dateTimeFilter":"None","selectedContractID":"'+contractObj.Id+'"}';
       
        MBFS_CreateNewLeadController.onNewEditTaskSubmit(submitDataNewLead);        
    }
    static testMethod void unitTestonNewEditTaskSubmitNullId() {
        loadData();
        submitDataNewLead   = '{"taskObj":{"Subject":"Call","ActivityDate":"2017-11-09","Type":"Call","Description":"calll me up","WhatId":"'+contractObj.id+'","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"outcome":"Made Contact","suboutcome":"Lost to Competitor","subOutComeAction":"WASH_LIST_LOST_TO_COMPETITOR","newtask":{"sobjectType":"Task","Subject":"Call","ActivityDate":"2017-11-13","Description":"","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"newlead":{"sobjectType":"Lead","Description":"","PartnerAccount":"","FirstName":"Martin","LastName":"lawrence","Email":"amarendra.kumar1@saasfocus.com","Phone":"8888888888","MobilePhone":"888888888","MBFS_Dealer_Account__c":"'+accObj.Id+'","MBFS_Dealer_Account__r":{"Name":"City Mercedes","Id":"'+accObj.Id+'"}},"campaignId":"None","dateTimeFilter":"None","selectedContractID":"'+contractObj.Id+'"}';
        
        MBFS_CreateNewLeadController.onNewEditTaskSubmit(submitDataNewLead);        
    }
    static testMethod void unitTestonNewEditTaskSubmitFinance() {
        loadData();
        submitDataNewLead   = '{"taskObj":{"Id":"'+taskList.get(0).Id +'","Subject":"Call","ActivityDate":"2017-11-09","Type":"Call","Description":"calll me up","WhatId":"'+contractObj.id+'","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"outcome":"Made Contact","suboutcome":"Lead Sent","subOutComeAction":"WASH_LIST_NEW_LEAD","newtask":{"sobjectType":"Task","Subject":"Call","ActivityDate":"2017-11-13","Description":"","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"newlead":{"sobjectType":"Lead","Description":"","PartnerAccount":"","FirstName":"Martin","LastName":"lawrence","Email":"amarendra.kumar1@saasfocus.com","Phone":"8888888888","MobilePhone":"888888888","MBFS_Dealer_Account__c":"'+accObj.Id+'","MBFS_Dealer_Account__r":{"Name":"City Mercedes","Id":"'+accObj.Id+'"},"MBFS_Nature_of_Request__c":"Mid- Term Refinance","MBFS_Lead_Type__c":"Finance Lead","MBFS_Interested_Vehicle_category__c":"PC","MBFS_Vehicle_Make_interest__c":"Mercedes-Benz","MBFS_Model_Interest__c":"A Class"},"campaignId":"None","dateTimeFilter":"None","selectedContractID":"'+contractObj.Id+'"}';
        
        MBFS_CreateNewLeadController.onNewEditTaskSubmit(submitDataNewLead);        
    }
    
    static testMethod void unitTestonNewEditTaskSubmitInsurance() {
        loadData();
        submitDataNewLead   = '{"taskObj":{"Id":"'+taskList.get(0).Id +'","Subject":"Call","ActivityDate":"2017-11-09","Type":"Call","Description":"calll me up","WhatId":"'+contractObj.id+'","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"outcome":"Made Contact","suboutcome":"Lead Sent","subOutComeAction":"WASH_LIST_NEW_LEAD","newtask":{"sobjectType":"Task","Subject":"Call","ActivityDate":"2017-11-13","Description":"","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"newlead":{"sobjectType":"Lead","Description":"","PartnerAccount":"","FirstName":"Martin","LastName":"lawrence","Email":"amarendra.kumar1@saasfocus.com","Phone":"8888888888","MobilePhone":"888888888","MBFS_Dealer_Account__c":"'+accObj.Id+'","MBFS_Dealer_Account__r":{"Name":"City Mercedes","Id":"'+accObj.Id+'"},"MBFS_Nature_of_Request__c":"Insurance Quote","MBFS_Lead_Type__c":"Insurance Lead","MBFS_Interested_Vehicle_category__c":"PC","MBFS_Vehicle_Make_interest__c":"Mercedes-Benz","MBFS_Model_Interest__c":"A Class"},"campaignId":"None","dateTimeFilter":"None","selectedContractID":"'+contractObj.Id+'"}';
        
        MBFS_CreateNewLeadController.onNewEditTaskSubmit(submitDataNewLead);        
    }
    static testMethod void unitTestonNewEditTaskSubmitFutureTask() {
        loadData();
        submitDataNewLead   = '{"taskObj":{"Id":"'+taskList.get(0).Id +'","Subject":"Call","ActivityDate":"2017-11-09","Type":"Call","Description":"calll me up","WhatId":"'+contractObj.id+'","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"outcome":"Made Contact","suboutcome":"Call Back Request","subOutComeAction":"FUTURE_TASK","newtask":{"sobjectType":"Task","Subject":"Call","ActivityDate":"2017-11-13","Description":"wwwwww","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"newlead":{"sobjectType":"Lead","Description":"","PartnerAccount":"","FirstName":"Martin","LastName":"lawrence","Email":"amarendra.kumar1@saasfocus.com","Phone":"8888888888","MobilePhone":"888888888","MBFS_Dealer_Account__c":"'+accObj.Id+'","MBFS_Dealer_Account__r":{"Name":"City Mercedes","Id":"'+accObj.Id+'"},"MBFS_Nature_of_Request__c":"Insurance Quote","MBFS_Lead_Type__c":"Insurance Lead","MBFS_Interested_Vehicle_category__c":"PC","MBFS_Vehicle_Make_interest__c":"Mercedes-Benz","MBFS_Model_Interest__c":"A Class"},"campaignId":"None","dateTimeFilter":"None","selectedContractID":"'+contractObj.id+'"}';
        
        MBFS_CreateNewLeadController.onNewEditTaskSubmit(submitDataNewLead);        
    }
    
}