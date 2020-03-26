@isTest
public class mbfs_addCampaignMembersTest {
     public static Campaign campObj ;
     public static Contract contractObj ;
     public static List<Task> taskList = new  List<Task> ();
     public static User userObj ;
     public static Account accObj ; 
      
       
     private static void  loadData(){
        campObj  = MBFS_CommonDataGeneratorTest.createCampaign();
        userObj = MBFS_CommonDataGeneratorTest.generateStandardUser();
        accObj= MBFS_CommonDataGeneratorTest.createAccount();
        contractObj =     MBFS_CommonDataGeneratorTest.generateContract(userObj.Id,accObj.Id,campObj.id);
        taskList = MBFS_CommonDataGeneratorTest.createtask(contractObj.Id);
        contractObj = MBFS_CommonDataGeneratorTest.updateContract(contractObj,taskList.get(0).Id);
     }

    static testmethod void  mbfs_addCampaignMemberstest()
    {
        Test.startTest();
          loadData();
          mbfs_addCampaignMembers  obj = new mbfs_addCampaignMembers (campObj.Id,'6_Months');
         
          
          DataBase.executeBatch(obj); 
        Test.stopTest();  
    }

}