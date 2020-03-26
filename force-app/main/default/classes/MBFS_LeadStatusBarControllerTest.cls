@isTest
public class MBFS_LeadStatusBarControllerTest {

    public static User userObj ;
    public static Contract contractObj ;
    public static Account accObj ;
    public static Campaign campObj ;
    public static List<Task> taskList = new  List<Task> ();
    public static List<Lead> leadList ;
    private static void  loadData(){
        userObj = MBFS_CommonDataGeneratorTest.generateStandardUser();
        accObj= MBFS_CommonDataGeneratorTest.createAccount();
        campObj = MBFS_CommonDataGeneratorTest.createCampaign();
        contractObj =     MBFS_CommonDataGeneratorTest.generateContract(userObj.Id,accObj.Id,campObj.id);
        taskList = MBFS_CommonDataGeneratorTest.createtask(contractObj.Id);
        contractObj = MBFS_CommonDataGeneratorTest.updateContract(contractObj,taskList.get(0).Id);
        leadList = MBFS_CommonDataGeneratorTest.createLead(contractObj.Id);
    }
    static testMethod void unitTestUpdateLeadStatus() {
        loadData();
        MBFS_LeadStatusBarController.updateLeadStatus(leadList.get(0).Id ,'Completed'); 
    }
    static testMethod void unitTestGetLeadDetail() {
        loadData();
        MBFS_LeadStatusBarController.getLeadDetail(leadList.get(0).Id); 
    }
    static testMethod void unitTestGetSelectListOptions() {
        loadData();
        MBFS_LeadStatusBarController.getSelectListOptions(new Lead() ,'Industry','Agriculture'); 
    }
     static testMethod void unitTestGetPickListValues() {
         loadData();
        MBFS_LeadStatusBarController.getPickListValues('Lead' ,'Industry','Agriculture'); 
    }
    static testMethod void unitTestGetData() {
         loadData();
        MBFS_LeadStatusBarController.getData('Lead' ,'Industry','Agriculture',leadList.get(0).Id); 
    }
}