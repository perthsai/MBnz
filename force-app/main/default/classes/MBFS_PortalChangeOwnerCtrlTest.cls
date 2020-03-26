@isTest
public class MBFS_PortalChangeOwnerCtrlTest {

    public static User userObj ;   
    public static Contract contractObj ;
    public static Account accObj ;
    public static Campaign campObj ;  
    public static List<Lead> leadList ;
    public static Group groupDetails ;
    public static GroupMember objGroupMember ;
    private static void  loadData(){        
        userObj = MBFS_CommonDataGeneratorTest.generateStandardUser();  
        accObj= MBFS_CommonDataGeneratorTest.createAccount();
        campObj = MBFS_CommonDataGeneratorTest.createCampaign();
        contractObj =     MBFS_CommonDataGeneratorTest.generateContract(userObj.Id,accObj.Id,campObj.id);             
        leadList = MBFS_CommonDataGeneratorTest.createLead(contractObj.Id);   
       
    }
    
    private static void createGroupAndMember(){
        groupDetails = new Group() ;
        groupDetails.Name = '1100 Sales';
        insert groupDetails ;
        
        objGroupMember                = new GroupMember();
  	    objGroupMember.GroupId        = groupDetails.id;//queue Id
  	  	objGroupMember.UserOrGroupId  = userObj.id;//Group Id
        insert objGroupMember ;
    }
    static testMethod void unitTest() {
        
        loadData();
        //createGroupAndMember();
        Test.startTest();
        accObj.MBFS_Dealer_Code__c = '1100' ;    
        accObj.MBFS_Active_Dealer__c = true;
       
        update accObj ;
        
        Lead leadObj  = leadList.get(0);
        leadObj.MBFS_Account__c = accObj.Id ;
        update leadObj ;
        
        MBFS_PortalChangeOwnerCtrl.onLoadCall(leadObj.Id);
        Test.stopTest();
    }
    
    static testMethod void unitTest1() {       
        loadData();
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
           createGroupAndMember();
        }
        Test.startTest();
        accObj.MBFS_Dealer_Code__c = '1100' ;    
        accObj.MBFS_Active_Dealer__c = true;
       
        update accObj ;
        
        Lead leadObj  = leadList.get(0);
        leadObj.MBFS_Account__c = accObj.Id ;
        update leadObj ;
        
        MBFS_PortalChangeOwnerCtrl.onLoadCall(leadObj.Id);
        Test.stopTest();
    }
    
    static testMethod void unitTest2() {       
        loadData();
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
           createGroupAndMember();
        }
        Test.startTest();
        accObj.MBFS_Dealer_Code__c = '1100' ;    
        accObj.MBFS_Active_Dealer__c = true;
       
        update accObj ;
        
        Lead leadObj  = leadList.get(0);
        leadObj.MBFS_Account__c = accObj.Id ;
        update leadObj ;
        
        MBFS_PortalChangeOwnerCtrl.changeOwner(leadObj.Id,userObj.Id);
        Test.stopTest();
    }
}