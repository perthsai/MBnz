@isTest
public class MBFS_RTMContractSegmentationCtrlTest {

   
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
    static testMethod void unitTest() {
        loadData();
        String jsonParameter = '';
        commDataWrap = new MBSF_RTMDataWrapper.CommonDataWrapper ();
        commDataWrap.filter =  '4_MONTHS';
        commDataWrap.campaignId = '';
        commDataWrap.dateFilter  = 'Today_OverDue';
        commDataWrap.sortField    = 'CreatedDate';
        commDataWrap.isAscending = true ;   
        commDataWrap.noOfRecord = 1000 ;
        jsonParameter = JSON.serialize(commDataWrap);    
            
        MBFS_RTMContractSegmentationController.onLoadCall(jsonParameter);
        
        commDataWrap = new MBSF_RTMDataWrapper.CommonDataWrapper ();
        commDataWrap.filter =  '4_MONTHS';
        commDataWrap.campaignId = campObj.Id;
        commDataWrap.dateFilter  = 'Today_OverDue';
        commDataWrap.sortField    = 'CreatedDate';
        commDataWrap.isAscending = true ;   
        commDataWrap.noOfRecord = 1000 ;
        jsonParameter = JSON.serialize(commDataWrap);  
        MBFS_RTMContractSegmentationController.onLoadCall(jsonParameter);
        
        
        commDataWrap = new MBSF_RTMDataWrapper.CommonDataWrapper ();
        commDataWrap.filter =  '4_MONTHS';
        commDataWrap.campaignId = campObj.Id;
        commDataWrap.dateFilter  = 'Today_OverDue';
        commDataWrap.sortField    = 'CreatedDate';
        commDataWrap.isAscending = true ;   
        commDataWrap.noOfRecord = 1000 ;
        jsonParameter = JSON.serialize(commDataWrap); 
        MBFS_RTMContractSegmentationController.onLoadCall(jsonParameter);
       
        
        commDataWrap = new MBSF_RTMDataWrapper.CommonDataWrapper ();
        commDataWrap.filter =  '4_MONTHS';
        commDataWrap.campaignId = '';
        commDataWrap.dateFilter  = 'Today_OverDue';
        commDataWrap.sortField    = 'CreatedDate';
        commDataWrap.isAscending = true ;   
        commDataWrap.noOfRecord = 1000 ;
        jsonParameter = JSON.serialize(commDataWrap); 
        MBFS_RTMContractSegmentationController.onLoadCall(jsonParameter);
    }
    
    static testMethod void unitTestOnFilterChange() {
        loadData();
        
        String jsonParameter = '';
        commDataWrap = new MBSF_RTMDataWrapper.CommonDataWrapper ();
        commDataWrap.filter =  '4_MONTHS';
        commDataWrap.campaignId = '';
        commDataWrap.dateFilter  = 'Today_OverDue';
        commDataWrap.sortField    = 'CreatedDate';
        commDataWrap.isAscending = true ;   
        commDataWrap.noOfRecord = 1000 ;
        jsonParameter = JSON.serialize(commDataWrap);          
        MBFS_RTMContractSegmentationController.onFilterChange(jsonParameter);
        
        commDataWrap = new MBSF_RTMDataWrapper.CommonDataWrapper ();
        commDataWrap.filter =  '4_MONTHS';
        commDataWrap.campaignId = campObj.Id ;
        commDataWrap.dateFilter  = 'Today_OverDue';
        commDataWrap.sortField    = 'CreatedDate';
        commDataWrap.isAscending = true ;   
        commDataWrap.noOfRecord = 1000 ;
        jsonParameter = JSON.serialize(commDataWrap); 
        MBFS_RTMContractSegmentationController.onFilterChange(jsonParameter);
        
        commDataWrap = new MBSF_RTMDataWrapper.CommonDataWrapper ();
        commDataWrap.filter =  '4_MONTHS';
        commDataWrap.campaignId = campObj.Id ;
        commDataWrap.dateFilter  = 'Today_OverDue';
        commDataWrap.sortField    = 'CreatedDate';
        commDataWrap.isAscending = true ;   
        commDataWrap.noOfRecord = 1000 ;
        jsonParameter = JSON.serialize(commDataWrap); 
        MBFS_RTMContractSegmentationController.onFilterChange(jsonParameter);
       
        commDataWrap = new MBSF_RTMDataWrapper.CommonDataWrapper ();
        commDataWrap.filter =  '6_MONTHS';
        commDataWrap.campaignId = '' ;
        commDataWrap.dateFilter  = 'Today_OverDue';
        commDataWrap.sortField    = 'CreatedDate';
        commDataWrap.isAscending = true ;   
        commDataWrap.noOfRecord = 1000 ;
        jsonParameter = JSON.serialize(commDataWrap); 
        MBFS_RTMContractSegmentationController.onFilterChange(jsonParameter);
    }
    
    static testMethod void unitTestOnEditNewTask() {
        loadData();        
        MBFS_RTMContractSegmentationController.onEditNewTask(contractObj.Id);        
    }
    static testMethod void unitTestOnEditNewTask1() {
        loadData();       
        contractObj = MBFS_CommonDataGeneratorTest.updateContract(contractObj,null);
        MBFS_RTMContractSegmentationController.onEditNewTask(contractObj.Id);        
    }
    
    static testMethod void unitTestfetchAccount() {
        loadData();       
        MBFS_RTMContractSegmentationController.fetchAccount('test');        
    }
    
    static testMethod void unitTestgetPickListToValue() {
        loadData();       
        MBFS_RTMContractSegmentationController.getPickListToValue(initCallHelper);        
    }
    static testMethod void unitTestonNewEditTaskSubmit() {
        loadData();
        submitDataNewLead   = '{"taskObj":{"Id":"'+taskList.get(0).Id +'","Subject":"Call","ActivityDate":"2017-11-09","Type":"Call","Description":"calll me up","WhatId":"'+contractObj.id+'"},"outcome":"Made Contact","suboutcome":"Lead Sent","subOutComeAction":"WASH_LIST_NEW_LEAD","newtask":{"sobjectType":"Task","Subject":"Call","ActivityDate":"2017-11-13","Description":""},"newlead":{"sobjectType":"Lead","Description":"12344","PartnerAccount":"","FirstName":"Martin","LastName":"lawrence","Email":"amarendra.kumar1@saasfocus.com","Phone":"8888888888","MobilePhone":"888888888","MBFS_Dealer_Account__c":"'+accObj.Id+'","MBFS_Dealer_Account__r":{"Name":"City Mercedes","Id":"'+accObj.Id+'"},"MBFS_Nature_of_Request__c":"Trade","MBFS_Lead_Type__c":"Retailer Lead","MBFS_Interested_Vehicle_category__c":"PC","MBFS_Vehicle_Make_interest__c":"Mercedes-Benz","MBFS_Model_Interest__c":"A Class"},"campaignId":"None","dateTimeFilter":"None","selectedContractID":"'+contractObj.Id+'"}';
        
        MBFS_RTMContractSegmentationController.onNewEditTaskSubmit(submitDataNewLead);        
    }
    static testMethod void unitTestonNewEditTaskSubmitDND() {
        loadData();
        submitDataNewLead   = '{"taskObj":{"Id":"'+taskList.get(0).Id +'","Subject":"Call","ActivityDate":"2017-11-09","Type":"Call","Description":"calll me up","WhatId":"'+contractObj.id+'","MBFS_Do_Not_Call__c":"Over Contracted"},"outcome":"No Call Required","suboutcome":"Do Not Call Register","subOutComeAction":"WASH_LIST_DO_NOT_CALL_REGISTER","newtask":{"sobjectType":"Task","Subject":"Call","ActivityDate":"2017-11-13","Description":"","MBFS_Do_Not_Call__c":"Over Contracted"},"newlead":{"sobjectType":"Lead","Description":"","PartnerAccount":"","FirstName":"Martin","LastName":"lawrence","Email":"amarendra.kumar1@saasfocus.com","Phone":"8888888888","MobilePhone":"888888888","MBFS_Dealer_Account__c":"'+accObj.Id+'","MBFS_Dealer_Account__r":{"Name":"City Mercedes","Id":"'+accObj.Id+'"}},"campaignId":"None","dateTimeFilter":"None","selectedContractID":"'+contractObj.Id+'"}';
       
        MBFS_RTMContractSegmentationController.onNewEditTaskSubmit(submitDataNewLead);        
    }
    static testMethod void unitTestonNewEditTaskSubmitLTC() {
        loadData();
        submitDataNewLead   = '{"taskObj":{"Id":"'+taskList.get(0).Id +'","Subject":"Call","ActivityDate":"2017-11-09","Type":"Call","Description":"calll me up","WhatId":"'+contractObj.id+'","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"outcome":"Made Contact","suboutcome":"Lost to Competitor","subOutComeAction":"WASH_LIST_LOST_TO_COMPETITOR","newtask":{"sobjectType":"Task","Subject":"Call","ActivityDate":"2017-11-13","Description":"","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"newlead":{"sobjectType":"Lead","Description":"","PartnerAccount":"","FirstName":"Martin","LastName":"lawrence","Email":"amarendra.kumar1@saasfocus.com","Phone":"8888888888","MobilePhone":"888888888","MBFS_Dealer_Account__c":"'+accObj.Id+'","MBFS_Dealer_Account__r":{"Name":"City Mercedes","Id":"'+accObj.Id+'"}},"campaignId":"None","dateTimeFilter":"None","selectedContractID":"'+contractObj.Id+'"}';
       
        MBFS_RTMContractSegmentationController.onNewEditTaskSubmit(submitDataNewLead);        
    }
    static testMethod void unitTestonNewEditTaskSubmitNullId() {
        loadData();
        submitDataNewLead   = '{"taskObj":{"Subject":"Call","ActivityDate":"2017-11-09","Type":"Call","Description":"calll me up","WhatId":"'+contractObj.id+'","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"outcome":"Made Contact","suboutcome":"Lost to Competitor","subOutComeAction":"WASH_LIST_LOST_TO_COMPETITOR","newtask":{"sobjectType":"Task","Subject":"Call","ActivityDate":"2017-11-13","Description":"","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"newlead":{"sobjectType":"Lead","Description":"","PartnerAccount":"","FirstName":"Martin","LastName":"lawrence","Email":"amarendra.kumar1@saasfocus.com","Phone":"8888888888","MobilePhone":"888888888","MBFS_Dealer_Account__c":"'+accObj.Id+'","MBFS_Dealer_Account__r":{"Name":"City Mercedes","Id":"'+accObj.Id+'"}},"campaignId":"None","dateTimeFilter":"None","selectedContractID":"'+contractObj.Id+'"}';
        
        MBFS_RTMContractSegmentationController.onNewEditTaskSubmit(submitDataNewLead);        
    }
    static testMethod void unitTestonNewEditTaskSubmitFinance() {
        loadData();
        submitDataNewLead   = '{"taskObj":{"Id":"'+taskList.get(0).Id +'","Subject":"Call","ActivityDate":"2017-11-09","Type":"Call","Description":"calll me up","WhatId":"'+contractObj.id+'","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"outcome":"Made Contact","suboutcome":"Lead Sent","subOutComeAction":"WASH_LIST_NEW_LEAD","newtask":{"sobjectType":"Task","Subject":"Call","ActivityDate":"2017-11-13","Description":"","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"newlead":{"sobjectType":"Lead","Description":"","PartnerAccount":"","FirstName":"Martin","LastName":"lawrence","Email":"amarendra.kumar1@saasfocus.com","Phone":"8888888888","MobilePhone":"888888888","MBFS_Dealer_Account__c":"'+accObj.Id+'","MBFS_Dealer_Account__r":{"Name":"City Mercedes","Id":"'+accObj.Id+'"},"MBFS_Nature_of_Request__c":"Mid- Term Refinance","MBFS_Lead_Type__c":"Finance Lead","MBFS_Interested_Vehicle_category__c":"PC","MBFS_Vehicle_Make_interest__c":"Mercedes-Benz","MBFS_Model_Interest__c":"A Class"},"campaignId":"None","dateTimeFilter":"None","selectedContractID":"'+contractObj.Id+'"}';
        
        MBFS_RTMContractSegmentationController.onNewEditTaskSubmit(submitDataNewLead);        
    }
    
    static testMethod void unitTestonNewEditTaskSubmitInsurance() {
        loadData();
        submitDataNewLead   = '{"taskObj":{"Id":"'+taskList.get(0).Id +'","Subject":"Call","ActivityDate":"2017-11-09","Type":"Call","Description":"calll me up","WhatId":"'+contractObj.id+'","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"outcome":"Made Contact","suboutcome":"Lead Sent","subOutComeAction":"WASH_LIST_NEW_LEAD","newtask":{"sobjectType":"Task","Subject":"Call","ActivityDate":"2017-11-13","Description":"","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"newlead":{"sobjectType":"Lead","Description":"","PartnerAccount":"","FirstName":"Martin","LastName":"lawrence","Email":"amarendra.kumar1@saasfocus.com","Phone":"8888888888","MobilePhone":"888888888","MBFS_Dealer_Account__c":"'+accObj.Id+'","MBFS_Dealer_Account__r":{"Name":"City Mercedes","Id":"'+accObj.Id+'"},"MBFS_Nature_of_Request__c":"Insurance Quote","MBFS_Lead_Type__c":"Insurance Lead","MBFS_Interested_Vehicle_category__c":"PC","MBFS_Vehicle_Make_interest__c":"Mercedes-Benz","MBFS_Model_Interest__c":"A Class"},"campaignId":"None","dateTimeFilter":"None","selectedContractID":"'+contractObj.Id+'"}';
        
        MBFS_RTMContractSegmentationController.onNewEditTaskSubmit(submitDataNewLead);        
    }
    static testMethod void unitTestonNewEditTaskSubmitFutureTask() {
        loadData();
        submitDataNewLead   = '{"taskObj":{"Id":"'+taskList.get(0).Id +'","Subject":"Call","ActivityDate":"2017-11-09","Type":"Call","Description":"calll me up","WhatId":"'+contractObj.id+'","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"outcome":"Made Contact","suboutcome":"Call Back Request","subOutComeAction":"FUTURE_TASK","newtask":{"sobjectType":"Task","Subject":"Call","ActivityDate":"2017-11-13","Description":"wwwwww","MBFS_Do_Not_Call__c":"Over Contracted","MBFS_Lost_to_Competitor__c":"Price"},"newlead":{"sobjectType":"Lead","Description":"","PartnerAccount":"","FirstName":"Martin","LastName":"lawrence","Email":"amarendra.kumar1@saasfocus.com","Phone":"8888888888","MobilePhone":"888888888","MBFS_Dealer_Account__c":"'+accObj.Id+'","MBFS_Dealer_Account__r":{"Name":"City Mercedes","Id":"'+accObj.Id+'"},"MBFS_Nature_of_Request__c":"Insurance Quote","MBFS_Lead_Type__c":"Insurance Lead","MBFS_Interested_Vehicle_category__c":"PC","MBFS_Vehicle_Make_interest__c":"Mercedes-Benz","MBFS_Model_Interest__c":"A Class"},"campaignId":"None","dateTimeFilter":"None","selectedContractID":"'+contractObj.id+'"}';
        
        MBFS_RTMContractSegmentationController.onNewEditTaskSubmit(submitDataNewLead);        
    }
    static testMethod void unitTestSubOutComeActionData () {
       MBSF_RTMDataWrapper.SubOutComeActionData  obj = new MBSF_RTMDataWrapper.SubOutComeActionData ('','');       
    }
    static testMethod void unitTestContractDeatilsData () {
       List<MBSF_RTMDataWrapper.ContractDeatils>  li = new List<MBSF_RTMDataWrapper.ContractDeatils>();
       MBSF_RTMDataWrapper.ContractDeatils  ContractDeatilsobj = new MBSF_RTMDataWrapper.ContractDeatils ('Test','Test');  
       li.add(ContractDeatilsobj); 
        
       MBSF_RTMDataWrapper.ContractDeatilsData  obj = new MBSF_RTMDataWrapper.ContractDeatilsData (li,li,li,li,taskList,
       leadList,false,dilyNotes,guarantorList,insuranceList,customerIntentionObj );       
    }
    static testMethod void unitTestCell  () {
       String fieldApi  = 'createddate';
       String fieldType  = 'String';
       Object fieldValue  = 'test' ;
       Long unixTime = 1000 ;
       Decimal currencyVal = 10 ;
       List<String> pickValues = null ;
       boolean isWritable  = true;
       String fieldLabel     = 'createddate';
       MBSF_RTMDataWrapper.Cell   obj = new MBSF_RTMDataWrapper.Cell  (fieldApi,fieldValue,fieldType,fieldLabel);  
       List<MBSF_RTMDataWrapper.Cell> listCell = new List<MBSF_RTMDataWrapper.Cell>();
       listCell.add(obj) ;
       MBSF_RTMDataWrapper.Row    objRow = new MBSF_RTMDataWrapper.Row (listCell,'');          
    }
    static testMethod void unitTestonRTMContractFieldSet() {
        loadData();
        
        MBSF_CommonHelper.getContractFieldSet(contractObj.Id ,'MBFS_Finance');        
    }
    static testMethod void unitTestonRTMOutComeToSubOutcome() {
        loadData();        
        MBSF_CommonHelper.getOutComeToSubOutComeMap(outCome);        
    }
    
    static testMethod void unitTestProcessData() {
        loadData();        
        MBSF_CommonHelper.getContractDetailsLead(contractObj.Id); 
        MBSF_CommonHelper.getContractDetailsTask(contractObj.Id);         
    }
    static testMethod void unitTestProcessResultsRTM() {
         loadData();        
         List<Contract> conList = new List<Contract>();
         conList.add(contractObj);
         MBSF_CommonHelper.processResultsRTM('Contract',conList,rtmContractColumn);         
    }
    
    static testMethod void unitTestCommonHelper() {
        loadData();
        String jsonParameter = '';
        commDataWrap = new MBSF_RTMDataWrapper.CommonDataWrapper ();
        commDataWrap.filter =  'All';
        commDataWrap.campaignId = '';
        commDataWrap.dateFilter  = 'OverDue';
        commDataWrap.sortField    = 'CreatedDate';
        commDataWrap.isAscending = true ;   
        commDataWrap.noOfRecord = 1000 ;
        jsonParameter = JSON.serialize(commDataWrap);    
            
        MBSF_CommonHelper.rtmResultSetHelper(commDataWrap);
    }
    
    static testMethod void unitTestCreateNewTaskFinance() {
        loadData();
        String jsonParameter = '{"financetask":{"sobjectType":"Task","Subject":"Call","ActivityDate":"2018-03-21","Description":"Test 1 Test 2"}}';
        
        Map<String, Object> m =  (Map<String, Object>)JSON.deserializeUntyped(jsonParameter);   
            
        MBFS_RTMContractSegmentationController.createNewTaskFinance(m,'Made Contaact','Lead',contractObj,leadList.get(0));
    }
}