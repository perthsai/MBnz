@isTest
public class MBFS_TriggerOnLeadhandlerTest {

    public static List<Lead> leadList ;
    public static User userObj ;
    public static Contract contractObj ;
    public static Account accObj ;
    public static Campaign campObj ;
    public static List<Task> taskList = new  List<Task> ();
    public static List<Group> groupList ;
    private static void  loadData(){
        userObj = MBFS_CommonDataGeneratorTest.generateStandardUser();
        accObj= MBFS_CommonDataGeneratorTest.createAccount();
        campObj = MBFS_CommonDataGeneratorTest.createCampaign();
        contractObj =     MBFS_CommonDataGeneratorTest.generateContract(userObj.Id,accObj.Id,campObj.id);
        taskList = MBFS_CommonDataGeneratorTest.createtask(contractObj.Id);
        contractObj = MBFS_CommonDataGeneratorTest.updateContract(contractObj,taskList.get(0).Id);
        leadList = MBFS_CommonDataGeneratorTest.createLead(contractObj.Id);
        
    }
    
     static testMethod void unitTestShareWithDealerGroup() {
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
       
    }
}