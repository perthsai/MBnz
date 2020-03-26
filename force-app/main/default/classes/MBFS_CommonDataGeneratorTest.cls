@isTest
public class MBFS_CommonDataGeneratorTest {
   
    public static List<MBFS_Customer_Intention__c> generateCustomerIntention(String contractId)
    {
    
      List<MBFS_Customer_Intention__c> lst = new List<MBFS_Customer_Intention__c>();
      MBFS_Customer_Intention__c obj = new MBFS_Customer_Intention__c();
      obj.MBFS_Comments__c = 'test';
      obj.MBFS_Contract__c = contractId ;
      obj.MBFS_Communication_Channel__c = 'test';
      obj.MBFS_Contract_Expiry_Duration__c = 'test';
      obj.MBFS_Contract_Type__c = 'test';
      obj.MBFS_Option__c = 'test';
      obj.MBFS_Sub_Option__c = 'test';
      insert obj ;
      lst.add(obj);
      return lst; 
    }
    
    
    public static User generateStandardUser(){
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User userObj = new User();
        userObj.LastName = 'Walaia123456789';
        userObj.IsActive = true ;
        userObj.FirstName='JASON';
        userObj.Alias = 'jliv';
        userObj.Email = 'Walaia123456789@asdf.com';
        userObj.Username = 'Walaia123456789@asdf.com';
        userObj.ProfileId = profileId.id ;
        userObj.TimeZoneSidKey = 'GMT';
        userObj.LanguageLocaleKey = 'en_US';
        userObj.EmailEncodingKey = 'UTF-8';
        userObj.LocaleSidKey = 'en_US';
        insert userObj ;
        return userObj ;
    }
    
     public static User generateUser(){
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User userObj = new User();
        userObj.LastName = 'Walaia1234567890010101';
        userObj.IsActive = true ;
        userObj.FirstName='JASON';
        userObj.Alias = 'jliv';
        userObj.Email = 'Walaia1234567890010101@asdf.com';
        userObj.Username = 'Walaia1234567890010101@asdf.com';
        userObj.ProfileId = profileId.id ;
        userObj.TimeZoneSidKey = 'GMT';
        userObj.LanguageLocaleKey = 'en_US';
        userObj.EmailEncodingKey = 'UTF-8';
        userObj.LocaleSidKey = 'en_US';
        insert userObj ;
        return userObj ;
    }
    
    public static List<MBSF_ContractColumns__c> generateMBSFContractColumns(){
        
        List<MBSF_ContractColumns__c> ls = new List<MBSF_ContractColumns__c>();
        MBSF_ContractColumns__c conObj = new MBSF_ContractColumns__c();
        conObj.Name = 'AccountName';
        conObj.ApiName__c = 'Account.Name';
        conObj.MBFS_Sequence__c = 0 ;
        insert conObj ;
        ls.add(conObj);
        
        MBSF_ContractColumns__c conObj2 = new MBSF_ContractColumns__c();
        conObj2.Name = 'CreatedDate';
        conObj2.ApiName__c = 'CreatedDate';
        conObj2.MBFS_Sequence__c = 1 ;
        insert conObj2 ;
        ls.add(conObj2);
        return ls ;
    }
    
    public static List<MBFS_RTM_Contract_Column__c> generateMBSFRTMContractColumns(){
        
        List<MBFS_RTM_Contract_Column__c> ls = new List<MBFS_RTM_Contract_Column__c>();
        MBFS_RTM_Contract_Column__c conObj = new MBFS_RTM_Contract_Column__c();
        conObj.Name = 'AccountName';
        conObj.ApiName__c = 'Account.Name';
        conObj.MBFS_Sequence__c = 0 ;
        insert conObj ;
        ls.add(conObj);
        
        MBFS_RTM_Contract_Column__c conObj2 = new MBFS_RTM_Contract_Column__c();
        conObj2.Name = 'CreatedDate';
        conObj2.ApiName__c = 'CreatedDate';
        conObj2.MBFS_Sequence__c = 1 ;
        insert conObj2 ;
        ls.add(conObj2);
        return ls ;
    }
    
    public static List<MBFS_CampaignContractColumn__c> generateMBSFCampContractColumns(){
        
        List<MBFS_CampaignContractColumn__c> ls = new List<MBFS_CampaignContractColumn__c>();
        MBFS_CampaignContractColumn__c conObj = new MBFS_CampaignContractColumn__c();
        conObj.Name = 'AccountName';
        conObj.ApiName__c = 'Account.Name';
        conObj.MBFS_Sequence__c = 0 ;
        insert conObj ;
        ls.add(conObj);
        
        MBFS_CampaignContractColumn__c conObj2 = new MBFS_CampaignContractColumn__c();
        conObj2.Name = 'CreatedDate';
        conObj2.ApiName__c = 'CreatedDate';
        conObj2.MBFS_Sequence__c = 1 ;
        insert conObj2 ;
        ls.add(conObj2);
        return ls ;
    }
    
    
    public static MBSF_LeadColumns__c generateMBSFLeadColumns(){
        List<MBSF_LeadColumns__c> li = new List<MBSF_LeadColumns__c>();
        MBSF_LeadColumns__c leadColObj = new MBSF_LeadColumns__c();
        leadColObj.Name = 'CreatedDate';
        leadColObj.ApiName__c = 'CreatedDate';
        leadColObj.MBFS_Sequence__c = 0 ;
        insert leadColObj ;
        
        return leadColObj ;
    }
    
    public static Contract generateContract(String userId,String accId,String campId){
        Contract conObj = new Contract();
        conObj.status   = 'Activated';
        conObj.MBFS_Fleet__c   = false ;
        conObj.MBFS_Assign_To__c = userId ;
        //conObj.MBFS_Agility__c = 'Yes';
        conObj.MBFS_Contract_terms_Months__c = 'R1' ;
        conObj.StartDate = System.today() ;
        conObj.EndDate = System.today().addMonths(+6) ;
        conObj.MBFS_Residual_Amount__c = 1200 ; 
        conObj.MBFS_Make_Manufacturer__c = 'Mercedes-Benz';
        conObj.AccountId = accId ;
        conObj.MBFS_Campaign__c = campId ;
        insert conObj ;
        return conObj ;
    }
    
    public static Contract updateContract(Contract conObj,String taskId){
        conObj.status   = 'Activated';
        conObj.MBFS_Last_Activity_Id__c = taskId ;
        update conObj ;
        return conObj ;
    }
    
     public static Account createAccount(){
        Account accObj = new Account();
        Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer Account').getRecordTypeId(); 
        accObj.Name = 'Test';
       // accObj.LastName  = 'Test1'; 
        accObj.RecordTypeId = RecordTypeIdContact ;
        insert  accObj ;
        return accObj ; 
     }
    
    public static Campaign createCampaign(){
        Campaign campObj = new Campaign();
        campObj.Name = 'test and group';
        campObj.IsActive = true ; 
        insert campObj ;
        return campObj ; 
     }
    
    public static List<Task> createtask(String contractId){
        List<Task> taskList = new List<Task>();
        for(Integer i = 0 ; i < 5;i++){
            Task t = new Task();
            t.WhatId  = contractId ;
            t.Subject = 'test';
            t.ActivityDate = system.today();
            taskList.add(t);
            
        }
        insert taskList ;
        return taskList ; 
     }
    
    
    public static List<Lead> createLead(String contractId){
        List<Lead> leadList = new List<Lead>();
        for(Integer i = 0 ; i < 5;i++){
            Lead l = new Lead();
            l.MBFS_CMS_Contract_No__c  = contractId ;
            l.status = 'New Enquiry';
            l.LastName = 'wal';
            leadList.add(l);
        }
        insert leadList ;
        return leadList ; 
     }
    
    public static List<MBFS_RTH_SubOutComeAndAction__c> createSubOutComeAndAction(){
       List<MBFS_RTH_SubOutComeAndAction__c> l = new List<MBFS_RTH_SubOutComeAndAction__c>();
       
       MBFS_RTH_SubOutComeAndAction__c obj1 = new MBFS_RTH_SubOutComeAndAction__c();
       obj1.Name = 'Insurance Lead';
       obj1.MBFS_Sub_Outcome__c = 'Insurance Enquiry';
       obj1.MBFS_Action__c = 'Insurance_Lead';
       obj1.MBFS_Is_Active__c = true ;
       obj1.MBFS_Sequence__c = 0 ;
       obj1.MBFS_IsLeadType__c = true ;
       obj1.MBFS_Is_Agility__c = 'Non-Agility';
       insert obj1 ;
        
       MBFS_RTH_SubOutComeAndAction__c obj2 = new MBFS_RTH_SubOutComeAndAction__c();
       obj2.Name = 'Retailer Lead';
       obj2.MBFS_Sub_Outcome__c = 'Agility Return';
       obj2.MBFS_Action__c = 'Retailer_Lead';
       obj2.MBFS_Is_Active__c = true ;
       obj2.MBFS_Sequence__c = 1 ;
       obj2.MBFS_IsLeadType__c = true ;
       obj2.MBFS_Is_Agility__c = 'Non-Agility';
       insert obj2 ;
       
       l.add(obj1);
       l.add(obj2);
       return l ; 
     }
    
    public static List<MBFS_Diary_Notes__c> createDairyNotes(String contractId){
       List<MBFS_Diary_Notes__c> l = new List<MBFS_Diary_Notes__c>();
       
       MBFS_Diary_Notes__c obj1 = new MBFS_Diary_Notes__c();
       obj1.MBFS_Event_Code__c  = '0001';
       obj1.MBFS_Comment__c = 'test';
       obj1.Contract__c  = contractId ;
       obj1.MBFS_Execution_Date__c    = system.today() ;
       insert obj1 ;
        
       MBFS_Diary_Notes__c obj2 = new MBFS_Diary_Notes__c();
       obj2.MBFS_Event_Code__c  = '0002';
       obj2.MBFS_Comment__c = 'test';
       obj2.Contract__c  = contractId ;
       obj2.MBFS_Execution_Date__c    = system.today() ;
       insert obj2 ; 
     
       l.add(obj1);
       l.add(obj2);
       return l ; 
     }
    
    public static List<MBFS_Campaign_Member__c> createCampMem(String contractId,String campId){
       List<MBFS_Campaign_Member__c> l = new List<MBFS_Campaign_Member__c>();
       
       MBFS_Campaign_Member__c obj1 = new MBFS_Campaign_Member__c();
       obj1.MBFS_Contract__c =contractId;
       obj1.MBFS_Campaign__c =campId;
       obj1.MBFS_Active__c   =   true ;
       insert obj1 ;
        
       MBFS_Campaign_Member__c obj2 = new MBFS_Campaign_Member__c();
       obj2.MBFS_Contract__c =contractId;
       obj2.MBFS_Campaign__c =campId;
       obj2.MBFS_Active__c   =   true ;
       insert obj2 ; 
     
       l.add(obj1);
       l.add(obj2);
       return l ; 
     }
    
    public static List<Group> craeteGroup(List<String> name){
        List<Group> gl= new List<Group> ();
        for(String glName : name){
            Group g = new Group ();
            g.name = glName ;
            gl.add(g);
        }
        insert gl ;
        return gl ;
    }
    
    public static Contact craeteContact(String accId){
        Contact conObj = new Contact();
        conObj.Lastname = 'Test';
        conObj.Firstname = 'Test';
        conObj.AccountId = accId ;
        conObj.Email = 'amarendra.kumar1@saasfocus.com';
        insert conObj ;
        return conObj ;
    }
    
     public static List<MBFS_Contract_Account_Junction__c> contractAccountJunction(String accId,String conId){
         
         List<MBFS_Contract_Account_Junction__c> l = new List<MBFS_Contract_Account_Junction__c>();
         
         MBFS_Contract_Account_Junction__c obj1 = new MBFS_Contract_Account_Junction__c();
         obj1 .MBFS_Account__c = accId ;
         obj1 .MBFS_Contract__c = conId ;
         obj1 .Name = 'Test' ;
         insert obj1  ;
         
         MBFS_Contract_Account_Junction__c obj2 = new MBFS_Contract_Account_Junction__c();
         obj2 .MBFS_Account__c = accId ;
         obj2 .MBFS_Contract__c = conId ;
         obj2.Name = 'Test1';
         insert obj2  ;
         
         l.add(obj1);
         l.add(obj2);
         return l;
    }
    
    public static List<mbfs_Insurance__c> getIndurances(String conId){
         
         List<mbfs_Insurance__c> l = new List<mbfs_Insurance__c>();
         
         mbfs_Insurance__c obj1 = new mbfs_Insurance__c();
         obj1 .mbfs_Contract__c = conId;
         obj1 .mbfs_Expiry_Date__c = system.today();
         obj1 .Name = '00001';
         insert obj1  ;
         
         mbfs_Insurance__c obj2 = new mbfs_Insurance__c();
         obj2 .mbfs_Contract__c = conId;
         obj2 .mbfs_Expiry_Date__c = system.today();
         obj2 .Name = '000002';
         insert obj2  ;
         
         l.add(obj1);
         l.add(obj2);
         return l;
    }
    
}