@isTest
public class mbfs_scheduled_Next_Week_CampaignTest {
    public static Campaign campObj ;
    private static void  loadData(){
        campObj = MBFS_CommonDataGeneratorTest.createCampaign();
    }
    
    static testMethod void unitTest() {
        loadData(); 
        SchedulableContext sc ;
        mbfs_scheduled_Next_Week_Campaign  obj = new mbfs_scheduled_Next_Week_Campaign ();
        obj.execute(sc);
    }

}