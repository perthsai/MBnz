@isTest
public class MBFS_TaskComponentControllerTest {

    public static Contract contractObj ;
    public static Account accObj ;
    public static Campaign campObj ;
    public static User userObj ;
    
    public static List<Task> taskList = new  List<Task> ();
    private static void  loadData(){
        userObj = MBFS_CommonDataGeneratorTest.generateStandardUser();
        accObj= MBFS_CommonDataGeneratorTest.createAccount();
        campObj = MBFS_CommonDataGeneratorTest.createCampaign();
        contractObj =     MBFS_CommonDataGeneratorTest.generateContract(userObj.Id,accObj.Id,campObj.id);
        taskList = MBFS_CommonDataGeneratorTest.createtask(contractObj.Id);
        contractObj = MBFS_CommonDataGeneratorTest.updateContract(contractObj,taskList.get(0).Id);
    }
    
    static testMethod void unitTest() {
        loadData();
        MBFS_TaskComponentController.getTasksMethod('Overdue');
    }
}