@isTest
public class MBFS_TriggerOnCampaignMemberHandlerTest {
    
    public static Contract contractObj ;
    public static Campaign campObj ;
    public static List<MBFS_Campaign_Member__c> campMemList ;
    public static List<Task> taskList = new  List<Task> ();
    public static User userObj ;
    public static Account accObj ;
    private static void  loadData(){
        campObj = MBFS_CommonDataGeneratorTest.createCampaign();
        accObj= MBFS_CommonDataGeneratorTest.createAccount();
        userObj = MBFS_CommonDataGeneratorTest.generateStandardUser();
        contractObj =     MBFS_CommonDataGeneratorTest.generateContract(userObj.Id,accObj.Id,campObj.id);
        taskList = MBFS_CommonDataGeneratorTest.createtask(contractObj.Id);
        contractObj = MBFS_CommonDataGeneratorTest.updateContract(contractObj,taskList.get(0).Id);
        campMemList = MBFS_CommonDataGeneratorTest.createCampMem(contractObj.Id,campObj.Id);
        
        
    }
    static testMethod void unitTest() {
        loadData();
        
    }
}