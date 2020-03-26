@isTest
public class MBFS_TriggerOnUserHandlerTest {
    
    public static List<Lead> leadList ;
    public static User userObj ;
    public static Contract contractObj ;
    public static Account accObj ;
    public static Campaign campObj ;
    public static List<Task> taskList = new  List<Task> ();
    public static List<Group> groupList ;
    public static Contact conObj ; 
    private static void  loadData(){
        userObj = MBFS_CommonDataGeneratorTest.generateStandardUser();
        accObj= MBFS_CommonDataGeneratorTest.createAccount();
        campObj = MBFS_CommonDataGeneratorTest.createCampaign();
        contractObj =     MBFS_CommonDataGeneratorTest.generateContract(userObj.Id,accObj.Id,campObj.id);
        taskList = MBFS_CommonDataGeneratorTest.createtask(contractObj.Id);
        contractObj = MBFS_CommonDataGeneratorTest.updateContract(contractObj,taskList.get(0).Id);
        leadList = MBFS_CommonDataGeneratorTest.createLead(contractObj.Id);
        conObj = MBFS_CommonDataGeneratorTest.craeteContact(accObj.Id);
    }
    
    public static testMethod void unitTest() {
        loadData();
        
        
        
        Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
            Account acc1 = new Account (
                Name = 'newAcc1'
            );  
        acc1.MBFS_Dealer_Code__c  = '00001';
        insert acc1;
        Contact conCase = new Contact (
            AccountId = acc1.id,
            LastName = 'portalTestUserv1'
        );
        insert conCase;
        //Create user
        
        Profile prfile = [select Id,name from Profile where name ='Partner Community User' limit 1];
        
        User newUser1 = new User(
            profileId = prfile.id,
            username = 'newUser09876543@yahoo.com',
            email = 'pb@f.com',
            emailencodingkey = 'UTF-8',
            localesidkey = 'en_US',
            languagelocalekey = 'en_US',
            timezonesidkey = 'America/Los_Angeles',
            alias='nuser',
            lastname='lastname',
            contactId = conCase.id
        );
        newUser1.MBFS_Sales_Group__c = true ;
        //insert newUser1;
        
        //System.runAs (newUser1) {    
        //}
        
    }
    
    public static testMethod void unitTestAddUserAsGroupMember() {
        loadData();
        accObj= MBFS_CommonDataGeneratorTest.createAccount(); 
        accObj.MBFS_Dealer_Code__c =  '0001';
        accObj.MBFS_Active_Dealer__c = true ;
        
        update  accObj ;
        
        
        userObj = MBFS_CommonDataGeneratorTest.generateUser();
        List<Lead> leadL = new List<Lead>();
        List<String> names = new List<String>(); 
        for(Lead leadObj : leadList){
             leadObj.MBFS_Account__c  = accObj.id ;
             leadObj.ownerid = userObj.id ;
             
             leadL.add(leadObj) ;
             names.add(accObj.MBFS_Dealer_Code__c+ ' Sales');
        }
        groupList =  MBFS_CommonDataGeneratorTest.craeteGroup(names);  
        update leadL ; 
        
        set<string> setUserId = new set<string>();
        setUserId.add(userObj.id);
        Set<String> namesSet = new Set<String>(names);
        MBFS_TriggerOnUserHandler.addUserAsGroupMember(namesSet,setUserId,true);
        
    }
    
}