@isTest
public class MBFS_CampaignContractSegmentContTest {

    
    public static User userObj ;
    public static List<MBSF_ContractColumns__c> contractColumnObj ;
    public static Contract contractObj ;
    public static Account accObj ;
    public static Campaign campObj ;
    public static MBSF_LeadColumns__c leadColObj ;
    public static String jsonData = '';
   
    public static List<Task> taskList = new  List<Task> ();
    public static String initCallHelper   = '{"Task":["MBFS_Customer_Not_Interested__c","MBFS_Do_Not_Call__c","MBFS_Lost_to_Competitor__c"],"Lead":["MBFS_Interested_Vehicle_category__c","MBFS_Vehicle_Make_interest__c","MBFS_Model_Interest__c","MBFS_Lead_Type__c"]}';
    public static String submitDataNewLead   = '';
    public static List<MBFS_RTH_SubOutComeAndAction__c>  outCome ;
    public static List<MBFS_Diary_Notes__c> dilyNotes ;
    public static List<Lead> leadList ;
    public static List<MBFS_CampaignContractColumn__c> campContList ;
    
    public static MBFS_CampaignDataWrapper.CommonDataWrapper commDataWrap;
    
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
        
        campContList = MBFS_CommonDataGeneratorTest.generateMBSFCampContractColumns();
    }
    static testMethod void unitTest() {
        loadData();    
        String jsonParameter = '';
        commDataWrap = new MBFS_CampaignDataWrapper.CommonDataWrapper();
        commDataWrap.sortField = 'CreatedDate';
        commDataWrap.isAscending = true ;
        commDataWrap.noOfRecord = 1000 ;
        commDataWrap.campaignId = campObj.id ;    
        jsonParameter = JSON.serialize(commDataWrap);
        
        MBFS_CampaignContractSegmentController.onLoadCall(jsonParameter);
       
    }
     static testMethod void unitTestOnChangeCampaignSubmit() {
        loadData();    
        jsonData = '{ "recordCount":3, "resultSet":{ "columnHeader":[ { "fieldApi":"ContractNumber", "fieldLabel":"Contract Number", "fieldType":"", "fieldValue":"Contract Number", "isWritable":false }, { "fieldApi":"Account.Name", "fieldLabel":"Account Name", "fieldType":"", "fieldValue":"Account Name", "isWritable":false }, { "fieldApi":"Status", "fieldLabel":"Status", "fieldType":"", "fieldValue":"Status", "isWritable":false }, { "fieldApi":"CreatedDate", "fieldLabel":"Created Date", "fieldType":"", "fieldValue":"Created Date", "isWritable":false } ], "rows":[ { "contractId":"'+contractObj.Id+'", "fields":[ { "fieldApi":"contractnumber", "fieldLabel":"Contract Number", "fieldType":"STRING", "fieldValue":"00000126", "isWritable":false, "pickValues":[ ] }, { "fieldApi":"account.name", "fieldLabel":"Account Name", "fieldType":"REFERENCE", "fieldValue":"Global Media (Sample)", "isWritable":false, "pickValues":[ ] }, { "fieldApi":"status", "fieldLabel":"Status", "fieldType":"PICKLIST", "fieldValue":"Activated", "isWritable":true, "pickValues":[ "In Approval Process", "Activated", "Draft" ] }, { "fieldApi":"createddate", "fieldLabel":"Created Date", "fieldType":"DATETIME", "fieldValue":"2017-10-01", "isWritable":false, "pickValues":[ ], "unixTime":1506844130000 } ], "isSelected":true } ], "size":3 } }'; 
        MBFS_CampaignContractSegmentController.onChangeCampaignSubmit(campObj.Id,jsonData);
       
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
       MBFS_CampaignDataWrapper.Cell   obj = new MBFS_CampaignDataWrapper.Cell  (fieldApi,fieldValue,fieldType,null,false,fieldLabel);  
       List<MBFS_CampaignDataWrapper.Cell> listCell = new List<MBFS_CampaignDataWrapper.Cell>();
       listCell.add(obj) ;
       MBFS_CampaignDataWrapper.Row    objRow = new MBFS_CampaignDataWrapper.Row (listCell,'');          
    }
    static testMethod void unitTestMonthWeekFilterData  () {
        MBFS_CampaignDataWrapper.MonthWeekFilterData obj = new  MBFS_CampaignDataWrapper.MonthWeekFilterData('test','test');
        MBFS_CampaignDataWrapper.CampaignData objCamp = new  MBFS_CampaignDataWrapper.CampaignData('test','test');
        
    }
}