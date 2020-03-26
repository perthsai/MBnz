@isTest
public class MBFS_TriggerOnAccountHandlerTest {
    public static Account accObj ;
    private static void  loadData(){    
        Map<String, Schema.SObjectType> mapSObjectSchema = Schema.getGlobalDescribe();
        Schema.SObjectType sObjType = mapSObjectSchema.get('Account') ;
        Schema.DescribeSObjectResult cfrSchema = sObjType.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id idRecordType = RecordTypeInfo.get('Dealer Account').getRecordTypeId();
        accObj= MBFS_CommonDataGeneratorTest.createAccount();
        accObj.MBFS_Sales_Group__c = true ;
        accObj.RecordTypeId = idRecordType ;
        accObj.MBFS_Dealer_Code__c = '00001'; 
        update accObj ;
    }
    static testMethod void unitTest() {
        loadData();   
        
    }
}