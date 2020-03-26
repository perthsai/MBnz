@isTest
public class MBFS_ContractSegmentationControllerTest {

   
    public static User userObj ;
    public static List<MBSF_ContractColumns__c> contractColumnObj ;
    public static Contract contractObj ;
    public static Account accObj ;
    public static Campaign campObj ;
    public static MBSF_LeadColumns__c leadColObj ;
    public static String jsonData = '{ "agilityData":[ { "columnApiName":"Yes", "columnLabel":"Yes" }, { "columnApiName":"No", "columnLabel":"No" } ], "assigneeData":[ { "userId":"", "userName":"Pankaj Kakkar" }, { "userId":"", "userName":"Tamsyn" }, { "userId":"", "userName":"john" }, { "userId":"", "userName":"Retention Team Member" }, { "userId":"", "userName":"Lokesh pant" }, { "userId":"", "userName":"MBFSAu ServiceOps" }, { "userId":"", "userName":"Amarendra kumar" } ], "campaignFilterData":[ ], "chartData":[ { "count":3, "label":"Lokesh pant (3)" } ], "monthWeekFilterData":[ { "columnApiName":"6_MONTHS", "columnLabel":"6 Month Expiry Contracts" }, { "columnApiName":"3_MONTHS", "columnLabel":"3 Month Expiry Contracts" }, { "columnApiName":"NEXT_WEEK", "columnLabel":"Next Week Expiry Contracts" }, { "columnApiName":"All", "columnLabel":"All" } ], "recordCount":3, "resultSet":{ "columnHeader":[ { "fieldApi":"Account.Name", "fieldLabel":"Account Name", "fieldType":"", "fieldValue":"Account Name" } ], "rows":[ { "contractId":"", "fields":[ { "fieldApi":"account.name", "fieldLabel":"Account Name", "fieldType":"REFERENCE", "fieldValue":"Acme (Sample)" } ], "isSelected":true} ], "size":3 } }';
    public static String jsonDataLead = '{ "agilityData":[ ], "assigneeData":[ { "userId":"", "userName":"Pankaj Kakkar" } ], "campaignFilterData":[ ], "chartData":[ ], "monthWeekFilterData":[ ], "recordCount":95, "resultSet":{ "columnHeader":[ { "fieldApi":"FirstName", "fieldLabel":"First Name", "fieldType":"", "fieldValue":"First Name" } ], "rows":[ { "contractId":"", "fields":[ { "fieldApi":"firstname", "fieldLabel":"First Name", "fieldType":"STRING", "fieldValue":"Lead 3" } ], "isSelected":true } ], "size":25 } }'; 
    public static List<Task> taskList = new  List<Task> ();
    public static List<Lead> leadList ;
    public static MBSF_DataWrapper.CommonDataWrapper commDataWrap;
    private static void  loadData(){
        
        userObj = MBFS_CommonDataGeneratorTest.generateStandardUser();
        contractColumnObj = MBFS_CommonDataGeneratorTest.generateMBSFContractColumns();
        accObj= MBFS_CommonDataGeneratorTest.createAccount();
        campObj = MBFS_CommonDataGeneratorTest.createCampaign();
        contractObj =     MBFS_CommonDataGeneratorTest.generateContract(userObj.Id,accObj.Id,campObj.id);
        taskList = MBFS_CommonDataGeneratorTest.createtask(contractObj.Id);
        contractObj = MBFS_CommonDataGeneratorTest.updateContract(contractObj,taskList.get(0).Id);
        
        leadColObj = MBFS_CommonDataGeneratorTest.generateMBSFLeadColumns();
        leadList = MBFS_CommonDataGeneratorTest.createLead(contractObj.Id);      
    }
    
    static testMethod void unitTest() {
        loadData();
        String jsonParameter = '';
        commDataWrap = new MBSF_DataWrapper.CommonDataWrapper();
        commDataWrap.filter = '4_MONTHS';
        commDataWrap.campaignId = '';
        commDataWrap.assignedId = '';
        commDataWrap.agility = 'Yes';
        commDataWrap.residual = '1200';
        commDataWrap.vehicleMakeInterest = 'Mercedes';
        commDataWrap.sortField = 'CreatedDate';
        commDataWrap.isAscending = true;
        commDataWrap.noOfRecord = 100;
        commDataWrap.globalFilter = 'MBSF_CAMPAIGN';
        jsonParameter = JSON.serialize(commDataWrap);
        MBFS_ContractSegmentationController.onLoadCall(jsonParameter);
        
        commDataWrap = new MBSF_DataWrapper.CommonDataWrapper();
        commDataWrap.filter = '4_MONTHS';
        commDataWrap.campaignId = campObj.Id;
        commDataWrap.assignedId = '';
        commDataWrap.agility = 'Yes';
        commDataWrap.residual = '1200';
        commDataWrap.vehicleMakeInterest = 'Mercedes';        
        commDataWrap.sortField = 'CreatedDate';
        commDataWrap.isAscending = true;
        commDataWrap.noOfRecord = 100;
        commDataWrap.globalFilter = 'MBSF_CAMPAIGN';
        jsonParameter = JSON.serialize(commDataWrap);
        MBFS_ContractSegmentationController.onLoadCall(jsonParameter);
        
        commDataWrap = new MBSF_DataWrapper.CommonDataWrapper();
        commDataWrap.filter = 'All';
        commDataWrap.campaignId = campObj.Id;
        commDataWrap.assignedId = '';
        commDataWrap.agility = 'Yes';
        commDataWrap.residual = '1200';
        commDataWrap.vehicleMakeInterest = 'Mercedes';        
        commDataWrap.sortField = 'CreatedDate';
        commDataWrap.isAscending = true;
        commDataWrap.noOfRecord = 100;
        commDataWrap.globalFilter = 'MBSF_LEAD';
        jsonParameter = JSON.serialize(commDataWrap);
        MBFS_ContractSegmentationController.onLoadCall(jsonParameter);
        
        commDataWrap = new MBSF_DataWrapper.CommonDataWrapper();
        commDataWrap.filter = 'All';
        commDataWrap.campaignId = '';
        commDataWrap.assignedId = '';
        commDataWrap.agility = 'Yes';
        commDataWrap.residual = '1200';
        commDataWrap.vehicleMakeInterest = 'Mercedes';        
        commDataWrap.sortField = 'CreatedDate';
        commDataWrap.isAscending = true;
        commDataWrap.noOfRecord = 100;
        commDataWrap.globalFilter = 'MBSF_LEAD';
        jsonParameter = JSON.serialize(commDataWrap);
        MBFS_ContractSegmentationController.onLoadCall(jsonParameter);
    }
    
    static testMethod void unitTestCampaign() {
        loadData();
        String jsonParameter = '';
        commDataWrap = new MBSF_DataWrapper.CommonDataWrapper();
        commDataWrap.filter = '4_MONTHS';
        commDataWrap.campaignId = campObj.Id;
        commDataWrap.assignedId = '';
        commDataWrap.agility = 'Yes';
        commDataWrap.residual = '1200';
        commDataWrap.vehicleMakeInterest = 'Mercedes';        
        commDataWrap.sortField = 'CreatedDate';
        commDataWrap.isAscending = true;
        commDataWrap.noOfRecord = 100;
        commDataWrap.globalFilter = 'MBSF_CAMPAIGN';
        jsonParameter = JSON.serialize(commDataWrap);
        
        MBFS_ContractSegmentationController.onLoadCall(jsonParameter);
    }
    
    static testMethod void unitTestgetDoNotCallValues() {
        loadData();
        String jsonParameter = '';
        commDataWrap = new MBSF_DataWrapper.CommonDataWrapper();
        commDataWrap.filter = '4_MONTHS';
        commDataWrap.campaignId = '';
        commDataWrap.assignedId = '';
        commDataWrap.agility = 'Yes';
        commDataWrap.residual = '1200';
        commDataWrap.vehicleMakeInterest = 'Mercedes';        
        commDataWrap.sortField = 'CreatedDate';
        commDataWrap.isAscending = true;
        commDataWrap.noOfRecord = 100;
        commDataWrap.globalFilter = 'MBSF_CAMPAIGN';
        jsonParameter = JSON.serialize(commDataWrap);
        MBFS_ContractSegmentationController.onSorting(jsonParameter);
        
        
        commDataWrap = new MBSF_DataWrapper.CommonDataWrapper();
        commDataWrap.filter = '4_MONTHS';
        commDataWrap.campaignId = campObj.Id;
        commDataWrap.assignedId = '';
        commDataWrap.agility = 'Yes';
        commDataWrap.residual = '1200';
        commDataWrap.vehicleMakeInterest = 'Mercedes';        
        commDataWrap.sortField = 'CreatedDate';
        commDataWrap.isAscending = true;
        commDataWrap.noOfRecord = 100;
        commDataWrap.globalFilter = 'MBSF_CAMPAIGN';
        jsonParameter = JSON.serialize(commDataWrap);
        MBFS_ContractSegmentationController.onSorting(jsonParameter);
        
        commDataWrap = new MBSF_DataWrapper.CommonDataWrapper();
        commDataWrap.filter = '4_MONTHS';
        commDataWrap.campaignId = campObj.Id;
        commDataWrap.assignedId = '';
        commDataWrap.agility = 'Yes';
        commDataWrap.residual = '1200';
        commDataWrap.vehicleMakeInterest = 'Mercedes';        
        commDataWrap.sortField = 'CreatedDate';
        commDataWrap.isAscending = true;
        commDataWrap.noOfRecord = 100;
        commDataWrap.globalFilter = 'MBSF_LEAD';
        jsonParameter = JSON.serialize(commDataWrap);
        MBFS_ContractSegmentationController.onSorting(jsonParameter);
       
    }
    static testMethod void unitTestOnSort() {
        loadData();
        MBFS_ContractSegmentationController.getDoNotCallValues();
    }
    static testMethod void unitTestUpdateData() {
        loadData();
        jsonData = '{ "agilityData":[ { "columnApiName":"Yes", "columnLabel":"Yes" }, { "columnApiName":"No", "columnLabel":"No" } ], "assigneeData":[ { "userId":"'+userObj.Id+'", "userName":"Pankaj Kakkar" }, { "userId":"'+userObj.Id+'", "userName":"Tamsyn" }, { "userId":"'+userObj.Id+'", "userName":"john" }, { "userId":"'+userObj.Id+'", "userName":"Retention Team Member" }, { "userId":"'+userObj.Id+'", "userName":"Lokesh pant" }, { "userId":"'+userObj.Id+'", "userName":"MBFSAu ServiceOps" }, { "userId":"'+userObj.Id+'", "userName":"Amarendra kumar" } ], "campaignFilterData":[ ], "chartData":[ { "count":3, "label":"Lokesh pant (3)" } ], "monthWeekFilterData":[ { "columnApiName":"6_MONTHS", "columnLabel":"6 Month Expiry Contracts" }, { "columnApiName":"3_MONTHS", "columnLabel":"3 Month Expiry Contracts" }, { "columnApiName":"NEXT_WEEK", "columnLabel":"Next Week Expiry Contracts" }, { "columnApiName":"All", "columnLabel":"All" } ], "recordCount":3, "resultSet":{ "columnHeader":[ { "fieldApi":"Account.Name", "fieldLabel":"Account Name", "fieldType":"", "fieldValue":"Account Name" } ], "rows":[ { "contractId":"'+contractObj.Id+'", "fields":[ { "fieldApi":"account.name", "fieldLabel":"Account Name", "fieldType":"REFERENCE", "fieldValue":"Acme (Sample)" } ], "isSelected":true} ], "size":3 } }';
        System.debug('======='+jsonData );
        MBFS_ContractSegmentationController.updateData(jsonData,userObj.Id , 'MBSF_CAMPAIGN');
        
    }
    static testMethod void unitTestUpdateDataLead() {
        loadData();
        jsonData = '{ "agilityData":[ { "columnApiName":"Yes", "columnLabel":"Yes" }, { "columnApiName":"No", "columnLabel":"No" } ], "assigneeData":[ { "userId":"'+userObj.Id+'", "userName":"Pankaj Kakkar" }, { "userId":"'+userObj.Id+'", "userName":"Tamsyn" }, { "userId":"'+userObj.Id+'", "userName":"john" }, { "userId":"'+userObj.Id+'", "userName":"Retention Team Member" }, { "userId":"'+userObj.Id+'", "userName":"Lokesh pant" }, { "userId":"'+userObj.Id+'", "userName":"MBFSAu ServiceOps" }, { "userId":"'+userObj.Id+'", "userName":"Amarendra kumar" } ], "campaignFilterData":[ ], "chartData":[ { "count":3, "label":"Lokesh pant (3)" } ], "monthWeekFilterData":[ { "columnApiName":"6_MONTHS", "columnLabel":"6 Month Expiry Contracts" }, { "columnApiName":"3_MONTHS", "columnLabel":"3 Month Expiry Contracts" }, { "columnApiName":"NEXT_WEEK", "columnLabel":"Next Week Expiry Contracts" }, { "columnApiName":"All", "columnLabel":"All" } ], "recordCount":3, "resultSet":{ "columnHeader":[ { "fieldApi":"Account.Name", "fieldLabel":"Account Name", "fieldType":"", "fieldValue":"Account Name" } ], "rows":[ { "contractId":"'+leadList.get(0).Id+'", "fields":[ { "fieldApi":"LastName", "fieldLabel":"LastName", "fieldType":"String", "fieldValue":"Acme (Sample)" } ], "isSelected":true} ], "size":3 } }';
        System.debug('======='+jsonData );
        
        MBFS_ContractSegmentationController.updateData(jsonData,userObj.Id , 'MBSF_LEAD');
    }
    
    static testMethod void unitTestOnNotCallSave() {
        loadData();
         jsonData = '{ "agilityData":[ { "columnApiName":"Yes", "columnLabel":"Yes" }, { "columnApiName":"No", "columnLabel":"No" } ], "assigneeData":[ { "userId":"'+userObj.Id+'", "userName":"Pankaj Kakkar" }, { "userId":"'+userObj.Id+'", "userName":"Tamsyn" }, { "userId":"'+userObj.Id+'", "userName":"john" }, { "userId":"'+userObj.Id+'", "userName":"Retention Team Member" }, { "userId":"'+userObj.Id+'", "userName":"Lokesh pant" }, { "userId":"'+userObj.Id+'", "userName":"MBFSAu ServiceOps" }, { "userId":"'+userObj.Id+'", "userName":"Amarendra kumar" } ], "campaignFilterData":[ ], "chartData":[ { "count":3, "label":"Lokesh pant (3)" } ], "monthWeekFilterData":[ { "columnApiName":"6_MONTHS", "columnLabel":"6 Month Expiry Contracts" }, { "columnApiName":"3_MONTHS", "columnLabel":"3 Month Expiry Contracts" }, { "columnApiName":"NEXT_WEEK", "columnLabel":"Next Week Expiry Contracts" }, { "columnApiName":"All", "columnLabel":"All" } ], "recordCount":3, "resultSet":{ "columnHeader":[ { "fieldApi":"Account.Name", "fieldLabel":"Account Name", "fieldType":"", "fieldValue":"Account Name" } ], "rows":[ { "contractId":"' +contractObj.Id+'", "fields":[ { "fieldApi":"account.name", "fieldLabel":"Account Name", "fieldType":"REFERENCE", "fieldValue":"Acme (Sample)" } ], "isSelected":true} ], "size":3 } }';
        MBFS_ContractSegmentationController.onNotCallSave(jsonData,'Insurance Enquiry','Insurance_Lead' , 'MBSF_CAMPAIGN');
        
    }
    static testMethod void unitTestOnNotCallSave1() {
        loadData();
        jsonData = '{ "agilityData":[ { "columnApiName":"Yes", "columnLabel":"Yes" }, { "columnApiName":"No", "columnLabel":"No" } ], "assigneeData":[ { "userId":"'+userObj.Id+'", "userName":"Pankaj Kakkar" }, { "userId":"'+userObj.Id+'", "userName":"Tamsyn" }, { "userId":"'+userObj.Id+'", "userName":"john" }, { "userId":"'+userObj.Id+'", "userName":"Retention Team Member" }, { "userId":"'+userObj.Id+'", "userName":"Lokesh pant" }, { "userId":"'+userObj.Id+'", "userName":"MBFSAu ServiceOps" }, { "userId":"'+userObj.Id+'", "userName":"Amarendra kumar" } ], "campaignFilterData":[ ], "chartData":[ { "count":3, "label":"Lokesh pant (3)" } ], "monthWeekFilterData":[ { "columnApiName":"6_MONTHS", "columnLabel":"6 Month Expiry Contracts" }, { "columnApiName":"3_MONTHS", "columnLabel":"3 Month Expiry Contracts" }, { "columnApiName":"NEXT_WEEK", "columnLabel":"Next Week Expiry Contracts" }, { "columnApiName":"All", "columnLabel":"All" } ], "recordCount":3, "resultSet":{ "columnHeader":[ { "fieldApi":"Account.Name", "fieldLabel":"Account Name", "fieldType":"", "fieldValue":"Account Name" } ], "rows":[ { "contractId":"' +contractObj.Id+'", "fields":[ { "fieldApi":"account.name", "fieldLabel":"Account Name", "fieldType":"REFERENCE", "fieldValue":"Acme (Sample)" } ], "isSelected":true} ], "size":3 } }';
        MBFS_ContractSegmentationController.onNotCallSave(jsonData,'Insurance Enquiry','Insurance_Lead' , 'MBSF_CAMPAIGN');
    }
    static testMethod void unitTestProcessResults() {
        loadData();        
        List<MBSF_LeadColumns__c> li = new List<MBSF_LeadColumns__c>();
        li.add(leadColObj);
        MBSF_CommonHelper.processResults('Lead',leadList,li,'MBSF_LEAD');         
    }
    
    static testMethod void unitTestAllMonth() {
        loadData();
        String jsonParameter = '';
        commDataWrap = new MBSF_DataWrapper.CommonDataWrapper();
        commDataWrap.filter = 'All';
        commDataWrap.campaignId = '';
        commDataWrap.assignedId = 'NOT_ASSIGNED';
        commDataWrap.agility = 'Yes';
        commDataWrap.residual = 'ZERO';
        commDataWrap.vehicleMakeInterest = 'Mercedes';                
        commDataWrap.sortField = 'CreatedDate';
        commDataWrap.isAscending = false;
        commDataWrap.noOfRecord = 100;
        commDataWrap.globalFilter = 'MBSF_CAMPAIGN';
        jsonParameter = JSON.serialize(commDataWrap);
        MBFS_ContractSegmentationController.onLoadCall(jsonParameter);
    }
    
    static testMethod void unitTestChartDataMonthTab() {
        loadData();
        String jsonParameter = '';
        commDataWrap = new MBSF_DataWrapper.CommonDataWrapper();
        commDataWrap.filter = '6_Months';
        commDataWrap.campaignId = '';
        commDataWrap.assignedId = userObj.Id;
        commDataWrap.agility = 'Yes';
        commDataWrap.residual = '1200';
        commDataWrap.vehicleMakeInterest = 'Non_Mercedes';                        
        commDataWrap.sortField = 'CreatedDate';
        commDataWrap.isAscending = false;
        commDataWrap.noOfRecord = 100;
        commDataWrap.globalFilter = 'MBSF_CAMPAIGN';
        jsonParameter = JSON.serialize(commDataWrap);
       
        
        Map<String,String> userIdToNameMap = new Map<String,String>();
        userIdToNameMap.put(userObj.Id,userObj.Name);
        
    }
    
    static testMethod void unitTestForCommon() {
        MBSF_CommonHelper.IsNullOrEmpty(111.12);
        MBSF_CommonHelper.IsNullOrEmpty(222222);
        
    }
    
}