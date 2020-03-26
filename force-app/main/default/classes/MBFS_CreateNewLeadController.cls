/**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Controller Class for RTM 
**/
public With Sharing class MBFS_CreateNewLeadController {
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    @AuraEnabled
    public static MBFS_CreateNewLeadCtrWrapper.WrapperData onLoadCall(String jsonData,String contractId)
    {       
          MBFS_CreateNewLeadCtrWrapper.WrapperData wrapperData = new MBFS_CreateNewLeadCtrWrapper.WrapperData();
          try {
              MBSF_RTMDataWrapper.RTMPickListValues pickListValues = MBFS_RTMContractSegmentationController.getPickListToValue(jsonData);
              MBSF_RTMDataWrapper.NewEditTaskData newEditTaskData =  onEditNewTask(contractId);
              
              
              wrapperData.pickListValues = pickListValues ;
              wrapperData.newEditTaskData = newEditTaskData ;
              Datetime dt = DateTime.newInstance(System.today().addDays(+1), Time.newInstance(0, 0, 0, 0));
              Date newTaskDefaultDate = MBSF_CommonHelper.getDateExecludeWeekend(dt); 
              wrapperData.newTaskDefaultDate = newTaskDefaultDate ; 
              wrapperData.isError = false ;
          }catch(Exception exce){
            wrapperData.isError = true ;
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_CreateNewLeadController','onLoadCall',jsonData,exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj);  
          }    
          return wrapperData ;
    }
    
    @TestVisible
    private static MBSF_RTMDataWrapper.NewEditTaskData onEditNewTask(String contractId){
        
        MBSF_RTMDataWrapper.NewEditTaskData newEditTaskData = new MBSF_RTMDataWrapper.NewEditTaskData();
        try {
            
            Contract conObj = [select id,MBFS_Do_Not_Call__c,MBFS_Last_Activity_Id__c,CustomerSigned.FirstName,CustomerSigned.LastName,
                               CustomerSigned.Email,CustomerSigned.Phone,CustomerSigned.MobilePhone,Account.FirstName,
                               Account.LastName,Account.PersonEmail,Account.Phone,Account.PersonMobilePhone,Account.IsPersonAccount, 
                               Account.MBFS_Active_Dealer__c, MBFS_Dealer_Account__c,MBFS_Dealer_Account__r.Name,MBFS_Dealer_Account__r.MBFS_Active_Dealer__c from contract where Id=:contractId ]; 
            Task taskObj = new Task();
            if(conObj.MBFS_Last_Activity_Id__c != null){
                taskObj = [select id,Subject,ActivityDate,Type,Description,WhatId from Task where Id=: conObj.MBFS_Last_Activity_Id__c];
                
            }else{
                Datetime dt = DateTime.newInstance(System.today(), Time.newInstance(0, 0, 0, 0));               
                Date returDate ; 
                String dayName=dt .format('EEEE');             
                if(dayName =='Saturday'){
                    returDate = System.today().addDays(+2);                                 
                }
                else if(dayName =='Sunday'){
                    returDate = System.today().addDays(+1);                 
                }else {
                    returDate = System.today() ; 
                }
                
                taskObj.ActivityDate = returDate ; 
                taskObj.Subject= 'Call';
            }
            
            
            
            List<MBFS_RTH_SubOutComeAndAction__c> subOutComeAndActionList = [select Id,Name,MBFS_Action__c,MBFS_Sub_Outcome__c,MBFS_Sequence__c from 
                                                                             MBFS_RTH_SubOutComeAndAction__c where MBFS_Is_Active__c = true
                                                                             and RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'Outcome and action') and MBFS_Incoming__c = true];
            
            Map<String,List<MBSF_RTMDataWrapper.SubOutComeActionData>> outComeToSubOutCome= MBSF_CommonHelper.getOutComeToSubOutComeMap(subOutComeAndActionList);
            
            
            newEditTaskData = new MBSF_RTMDataWrapper.NewEditTaskData(taskObj,outComeToSubOutCome,conObj); 
            newEditTaskData.isError = false ;
        }catch(Exception exce){
            newEditTaskData.isError = true ;
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_CreateNewLeadController','onEditNewTask',contractId,exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj);  
        }
        return newEditTaskData;
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    @AuraEnabled
    public static boolean validateDealerAccount(String accountId){
        Account accountObject = [select id,MBFS_Active_Dealer__c,Name from Account  where Id =: accountId] ;
        return accountObject.MBFS_Active_Dealer__c ;
    }
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */     
    @AuraEnabled
    public static Boolean  onNewEditTaskSubmit(String data){  
        Boolean isError = false ;
        try {
            if(data != null){
                Map<String,Object> dataMap = (Map<String,Object>) JSON.deserializeUntyped(data);    
                
                String subOutComeAction = (String) dataMap.get('subOutComeAction') ;
                String outcome = (String) dataMap.get('outcome') ;
                String suboutcome = (String) dataMap.get('suboutcome') ;               
                String selectedContractID = (String) dataMap.get('selectedContractID');
                
                
                Contract conObj = [select Id,MBFS_Campaign__c,MBFS_Contract_Expiry_Duration__c,
                                   MBFS_No_of_Completed_Task__c,CustomerSigned.FirstName,CustomerSigned.LastName,
                                   CustomerSigned.Phone,CustomerSigned.Email,Account.IsPersonAccount,Account.FirstName,
                                   Account.LastName,Account.PersonEmail,Account.Phone,Account.PersonMobilePhone,AccountId,
                                   CustomerSignedId,
                                   MBFS_Related_Vehicle__c from Contract where Id =:selectedContractID];
                
                
                if(conObj.AccountId != null && subOutComeAction == 'WASH_LIST_DO_NOT_CALL_REGISTER'){
                    Account accountObj = new Account(Id=conObj.AccountId,MBFS_Do_Not_Call__c = true);
                    update accountObj ;
                }
                              
                
                Contract conTractObj = new Contract();
                if(selectedContractID != null && subOutComeAction != null 
                   && (subOutComeAction == 'WASH_LIST' ||
                       subOutComeAction == 'WASH_LIST_DO_NOT_CALL_REGISTER' ||
                       subOutComeAction == 'WASH_LIST_LOST_TO_COMPETITOR' || subOutComeAction == 'WASH_LIST_NEW_LEAD' || 
                       subOutComeAction =='WASH_LIST_CUSTOMER_NOT_INTERESTED'))
                {
                    
                    conTractObj.Id = selectedContractID ;
                    conTractObj.MBFS_Block_Campaign__c = conObj.MBFS_Campaign__c ;
                    conTractObj.MBFS_Block_Contract_Month__c  = conObj.MBFS_Contract_Expiry_Duration__c ;
                    
                }
                if(outcome != null && suboutcome !=null && (subOutComeAction =='FUTURE_TASK'))
                {
                                                                
                                                                conTractObj.Id = selectedContractID ;                                            
                                                                conTractObj.MBFS_Last_Activity_OutCome__c = outcome ;
                                                                conTractObj.MBFS_Last_Activity_Sub_OutCome__c = suboutcome ;
                                                                conTractObj.MBFS_Last_Activity_Comments__c = outcome ;  
                                                                
                }
                
               
                
                Map<String,Object> taskObjMap = (Map<String,Object>) dataMap.get('taskObj');
                
                if(taskObjMap != null &&  (String) taskObjMap.get('Subject') != null 
                   && taskObjMap.get('ActivityDate')  != null)
                {
                    createOrUpadtePreviousTask(taskObjMap,subOutComeAction,outcome,suboutcome,conObj);
                    conTractObj.Id = selectedContractID ;
                    conTractObj.MBFS_Last_Activity_Due_Date__c = null ;                                                      
                }
                
                if(conTractObj != null && conTractObj.Id != null)
                {
                    update conTractObj ;
                }
                
                
                
                if((subOutComeAction =='FUTURE_TASK') && 
                   dataMap.get('newtask') != null){
                       Map<String,Object> newTaskObj = (Map<String,Object>) dataMap.get('newtask') ;
                       createNewTask(newTaskObj,subOutComeAction,outcome,suboutcome,conObj);
                }
                
                           
                if((subOutComeAction =='WASH_LIST_NEW_LEAD')){                   
                    if(dataMap.get('newlead') != null){
                        Map<String,Object> newleadMap = (Map<String,Object>) dataMap.get('newlead');
                        Map<String,Object> financetask = (Map<String,Object>) dataMap.get('financetask') ;
                        createLead(newleadMap,conObj.id,conObj,financetask,outcome,suboutcome);
                    }                  
                }                
            }
        }catch(Exception exce){
            isError = true ;
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_CreateNewLeadController','onNewEditTaskSubmit',data,exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj);
        }
        return isError ;
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */
    @TestVisible
    private static void createNewTaskFinance(Map<String,Object> newTaskObj ,String outcome,String suboutcome,Contract conObj,Lead leadObj){
        
        if(newTaskObj != null){  
            Id devRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('General').getRecordTypeId();
            Task taskNew = new Task ();
            if((String) newTaskObj.get('Subject') != null && newTaskObj.get('ActivityDate') != null){
                taskNew.Subject =  (String) newTaskObj.get('Subject') ;
                taskNew.RecordTypeId = devRecordTypeId ;
                taskNew.ActivityDate = Date.valueOf((String) newTaskObj.get('ActivityDate')) ;                        
                taskNew.whoid  = leadObj.Id  ;
                taskNew.Type = 'Call';
                taskNew.Description= String.valueOf(newTaskObj.get('Description')) ;               
                taskNew.Status ='Open';
                taskNew.MBFS_ContractMonth__c = conObj.MBFS_Contract_Expiry_Duration__c ;
                taskNew.MBFS_Campaign__c    = conObj.MBFS_Campaign__c ;  
                taskNew.MBFS_OutCome__c     = outcome ; 
                taskNew.MBFS_Sub_Outcome__c = suboutcome ; 
                insert taskNew ;
            }          
        }
    }
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */
    @TestVisible
    private static void createNewTask(Map<String,Object> newTaskObj ,String subOutComeAction,String outcome,String suboutcome,Contract conObj){
        
        if(newTaskObj != null){  
            Id devRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Contract Segment').getRecordTypeId();
            Task taskNew = new Task ();
            if((String) newTaskObj.get('Subject') != null && newTaskObj.get('ActivityDate') != null && newTaskObj.get('Description') != null){
                taskNew.Subject =  (String) newTaskObj.get('Subject') ;
                taskNew.RecordTypeId = devRecordTypeId ;
                taskNew.ActivityDate = Date.valueOf((String) newTaskObj.get('ActivityDate')) ;                        
                taskNew.WhatId = conObj.Id ;
                taskNew.Type = 'Call';
                taskNew.Description= String.valueOf(newTaskObj.get('Description')) ;               
                taskNew.Status ='Open';
                taskNew.MBFS_ContractMonth__c = conObj.MBFS_Contract_Expiry_Duration__c ;
                taskNew.MBFS_Campaign__c    = conObj.MBFS_Campaign__c ;                              
            }    
            insert taskNew ;   
        }
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    @TestVisible
    private static void createOrUpadtePreviousTask(Map<String,Object> taskObjMap ,String subOutComeAction,String outcome,String suboutcome,Contract conObj){
        if(taskObjMap != null &&  (String) taskObjMap.get('Subject') != null 
           && taskObjMap.get('ActivityDate')  != null)
        {
            Task taskObj = new Task();
            Id devRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Contract Segment').getRecordTypeId();
            
            if(taskObjMap.get('Id') != null){
                taskObj.Id = (String) taskObjMap.get('Id') ;
                taskObj.Subject = (String) taskObjMap.get('Subject') ;
                taskObj.ActivityDate = Date.valueOf((String) taskObjMap.get('ActivityDate')) ;
                taskObj.Description = (String) taskObjMap.get('Description') ;
                taskObj.MBFS_ContractMonth__c = conObj.MBFS_Contract_Expiry_Duration__c ;
                
                                   
                if(subOutComeAction == 'WASH_LIST_DO_NOT_CALL_REGISTER' && taskObjMap.get('MBFS_Do_Not_Call__c') != null){
                    taskObj.MBFS_Do_Not_Call__c = (String) taskObjMap.get('MBFS_Do_Not_Call__c')  ;
                    taskObj.MBFS_Lost_to_Competitor__c = '';
                    taskObj.MBFS_Customer_Not_Interested__c = '';
                }
                if(subOutComeAction == 'WASH_LIST_LOST_TO_COMPETITOR' && taskObjMap.get('MBFS_Lost_to_Competitor__c') != null){
                    taskObj.MBFS_Lost_to_Competitor__c = (String) taskObjMap.get('MBFS_Lost_to_Competitor__c')  ;
                    taskObj.MBFS_Do_Not_Call__c = '';
                    taskObj.MBFS_Customer_Not_Interested__c = '';
                }
                if(taskObjMap.get('MBFS_Customer_Not_Interested__c') != null && subOutComeAction =='WASH_LIST_CUSTOMER_NOT_INTERESTED'){
                    taskObj.MBFS_Customer_Not_Interested__c = (String) taskObjMap.get('MBFS_Customer_Not_Interested__c') ; 
                    taskObj.MBFS_Do_Not_Call__c = '';
                    taskObj.MBFS_Lost_to_Competitor__c = '';
                }
                
                taskObj.MBFS_OutCome__c = outcome ;
                taskObj.MBFS_Sub_Outcome__c = suboutcome ;
                
                taskObj.Status  = 'Completed';                  
                update taskObj ;
            }else {
                taskObj.Subject = (String) taskObjMap.get('Subject') ;
                taskObj.ActivityDate = Date.valueOf((String) taskObjMap.get('ActivityDate')) ;
                taskObj.Description = (String) taskObjMap.get('Description') ;
                taskObj.WhatId = conObj.Id ;
                taskObj.RecordTypeId = devRecordTypeId ;
                taskObj.Type = 'Call';
                taskObj.Status ='Completed';
                taskObj.MBFS_OutCome__c = outcome ;
                taskObj.MBFS_Sub_Outcome__c = suboutcome ;
                
                taskObj.MBFS_ContractMonth__c = conObj.MBFS_Contract_Expiry_Duration__c ;
                taskObj.MBFS_Campaign__c    = conObj.MBFS_Campaign__c ;
                if(subOutComeAction == 'WASH_LIST_DO_NOT_CALL_REGISTER' && taskObjMap.get('MBFS_Do_Not_Call__c') != null){
                    taskObj.MBFS_Do_Not_Call__c = (String) taskObjMap.get('MBFS_Do_Not_Call__c')  ;
                }
                if(subOutComeAction == 'WASH_LIST_LOST_TO_COMPETITOR' && taskObjMap.get('MBFS_Lost_to_Competitor__c') != null){
                    taskObj.MBFS_Lost_to_Competitor__c = (String) taskObjMap.get('MBFS_Lost_to_Competitor__c')  ;
                }
                if(taskObjMap.get('MBFS_Customer_Not_Interested__c') != null && subOutComeAction =='WASH_LIST_CUSTOMER_NOT_INTERESTED'){
                    taskObj.MBFS_Customer_Not_Interested__c = (String) taskObjMap.get('MBFS_Customer_Not_Interested__c') ;  
                }
                
                
                insert taskObj ;
                
            }                                     
        }
    }
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    @TestVisible
    private static void createLead(Map<String,Object> newleadMap ,String contractId,Contract contractObject,Map<String,Object> financetask ,String outcome,String suboutcome)
    {  
        if(newleadMap != null && newleadMap.get('MBFS_Lead_Type__c') != null){
            
            String leadType = (String) newleadMap.get('MBFS_Lead_Type__c');           
            if(leadType == 'Retailer Lead'){
                if(newleadMap.get('MBFS_Dealer_Account__c') != null){
                    Id devRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();                    
                    String dealerAccount = (String)  newleadMap.get('MBFS_Dealer_Account__c') ;                                   
                    Lead leadObj = new Lead();
                    leadObj = intilizeLeadObj(newleadMap ,contractId) ;
                    leadObj.MBFS_Lead_Type__c = leadType ;
                    leadobj.RecordTypeId = devRecordTypeId ;                   
                    leadObj.MBFS_CMS_Contract_No__c = contractId ;
                    leadObj.Status = 'New Enquiry';
                    leadObj.MBFS_Account__c = dealerAccount ;
                    //leadObj.OwnerId =   queueId ; 
                                      
                    insert  leadObj ;                      
                }                
            }else if(leadType == 'Finance Lead'){                
                Group queueName = [SELECT Id,Type FROM Group where Type='Queue' and name='Finance Lead Queue' limit 1];
                Id queueId = queueName.Id ;
                Id devRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Finance').getRecordTypeId();
                Lead leadObj = new Lead();
                leadObj = intilizeLeadObj(newleadMap ,contractId) ;
                leadobj.RecordTypeId = devRecordTypeId ;
                leadObj.MBFS_Lead_Type__c = leadType ;               
                leadObj.MBFS_CMS_Contract_No__c = contractId ;
                leadObj.Status = 'New Enquiry';                
                leadObj.OwnerId =   queueId ; 
                insert  leadObj ;
                if(financetask != null && contractObject != null && leadObj != null){
                    createNewTaskFinance(financetask ,outcome,suboutcome,contractObject,leadObj) ;
                }
            
            }else if(leadType == 'Insurance Lead'){               
                Group queueName = [SELECT Id,Type FROM Group where Type='Queue' and name='Insurance Lead Queue' limit 1];
                Id queueId = queueName.Id ;
                Id devRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Insurance').getRecordTypeId();
                Lead leadObj = new Lead();
                leadObj = intilizeLeadObj(newleadMap ,contractId) ;
                leadobj.RecordTypeId = devRecordTypeId ;
                leadObj.MBFS_Lead_Type__c = leadType ;               
                leadObj.MBFS_CMS_Contract_No__c = contractId ;
                leadObj.Status = 'New Enquiry';             
                leadObj.OwnerId =   queueId ; 
                insert  leadObj ;               
            }
        }
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */
    @TestVisible
    private static Lead intilizeLeadObj(Map<String,Object> newleadMap ,String contractId)
    { 
        Lead leadObj = new Lead();
        if(newleadMap.get('MBFS_Interested_Vehicle_category__c') != null){
            leadObj.MBFS_Interested_Vehicle_category__c= (String) newleadMap.get('MBFS_Interested_Vehicle_category__c');
        }
        if(newleadMap.get('MBFS_Vehicle_Make_interest__c') != null){
            leadObj.MBFS_Vehicle_Make_interest__c= (String) newleadMap.get('MBFS_Vehicle_Make_interest__c');
        }
        if(newleadMap.get('MBFS_Model_Interest__c') != null){
            leadObj.MBFS_Model_Interest__c= (String) newleadMap.get('MBFS_Model_Interest__c');
        }
        if(newleadMap.get('MBFS_Nature_of_Request__c') != null){
            leadObj.MBFS_Nature_of_Request__c= (String) newleadMap.get('MBFS_Nature_of_Request__c');
        }
        if(newleadMap.get('LeadSource') != null){
            leadObj.LeadSource= (String) newleadMap.get('LeadSource');
        }
        if(newleadMap.get('Description') != null){
            leadObj.Description= (String) newleadMap.get('Description');
        }
        
        if(newleadMap.get('FirstName') != null){
            leadObj.FirstName = (String) newleadMap.get('FirstName') ;
        }
        if(newleadMap.get('LastName') != null){
            leadObj.LastName= (String) newleadMap.get('LastName') ;
        }
        if(newleadMap.get('Email') != null){
            leadObj.Email= (String) newleadMap.get('Email') ;
        }
        if(newleadMap.get('Phone') != null){
            leadObj.Phone= (String) newleadMap.get('Phone') ;
        }
        if(newleadMap.get('MobilePhone') != null){
            leadObj.MobilePhone= (String) newleadMap.get('MobilePhone') ;
        }
        return leadObj ;
    }
       
}