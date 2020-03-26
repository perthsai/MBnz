@isTest
public class mbfs_scheduled_6_Months_CampaignTest {

    public static Campaign campObj ;
    private static void  loadData(){
        campObj = MBFS_CommonDataGeneratorTest.createCampaign();
    }
    
    static testMethod void unitTest() {
        loadData(); 
        SchedulableContext sc ;
        mbfs_scheduled_6_Months_Campaign  obj = new mbfs_scheduled_6_Months_Campaign ();
        obj.execute(sc);
    }
}