@isTest
public class MBFS_CustomerIntentionControllerTest {

    public static User userObj ;
    public static Contract contractObj ;
    public static Account accObj ;
    public static Campaign campObj ;
    public static List<MBFS_Customer_Intention__c>  customerIntentionObj ;
    public static  List<MBFS_RTH_SubOutComeAndAction__c> subOutcomeList ;    
    
    
    private static void  loadData(){
        Id RecordTypeIdOS = Schema.SObjectType.MBFS_RTH_SubOutComeAndAction__c.getRecordTypeInfosByName().get('Customer Intention').getRecordTypeId();
        userObj = MBFS_CommonDataGeneratorTest.generateStandardUser();
        accObj= MBFS_CommonDataGeneratorTest.createAccount();
        campObj = MBFS_CommonDataGeneratorTest.createCampaign();
        contractObj =     MBFS_CommonDataGeneratorTest.generateContract(userObj.Id,accObj.Id,campObj.id);
        customerIntentionObj  = MBFS_CommonDataGeneratorTest.generateCustomerIntention(contractObj.Id);
        List<MBFS_RTH_SubOutComeAndAction__c> outcomeSubOutcomeList = MBFS_CommonDataGeneratorTest.createSubOutComeAndAction();
        
        subOutcomeList  = new List<MBFS_RTH_SubOutComeAndAction__c>();
        for(MBFS_RTH_SubOutComeAndAction__c subOutome : outcomeSubOutcomeList){
            subOutome.RecordTypeId  = RecordTypeIdOS ;
            subOutcomeList.add(subOutome);
        }
        System.debug('========= '+subOutcomeList);
        update subOutcomeList;
    }
    
    static testMethod void unitTest() {
        loadData();
        MBFS_CustomerIntentionController.onLoadCall(contractObj.Id);
    }
    
    static testMethod void unitTestInsertCustomerIntention() {
        loadData();
        String customerIntention = JSON.serialize(customerIntentionObj.get(0)); 
        String contractObject = JSON.serialize(contractObj); 
        MBFS_CustomerIntentionController.insertCustomerIntention(customerIntention,contractObject);
    }
    static testMethod void unitTestInsertCustomerIntentionChannel() {
        loadData();
        MBFS_Customer_Intention__c cIObj = customerIntentionObj.get(0) ;
        cIObj.MBFS_Communication_Channel__c = '';
        String customerIntention = JSON.serialize(cIObj); 
        String contractObject = JSON.serialize(contractObj); 
        MBFS_CustomerIntentionController.insertCustomerIntention(customerIntention,contractObject);
    }
    
    static testMethod void unitTestInsertCustomerIntentionOption() {
        loadData();
        MBFS_Customer_Intention__c cIObj = customerIntentionObj.get(0) ;
        cIObj.MBFS_Option__c  = '';
        String customerIntention = JSON.serialize(cIObj); 
        String contractObject = JSON.serialize(contractObj); 
        MBFS_CustomerIntentionController.insertCustomerIntention(customerIntention,contractObject);
    }
    static testMethod void unitTestInsertCustomerIntentionSubOption() {
        loadData();
        MBFS_Customer_Intention__c cIObj = customerIntentionObj.get(0) ;
        cIObj.MBFS_Sub_Option__c   = '';
        String customerIntention = JSON.serialize(cIObj); 
        String contractObject = JSON.serialize(contractObj); 
        MBFS_CustomerIntentionController.insertCustomerIntention(customerIntention,contractObject);
    }
}