/**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Controller Class for RTM 
**/
public With Sharing class MBFS_RTMContractSegmentationController {
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    @AuraEnabled
    public static MBSF_RTMDataWrapper.WrapperDataByMonth onLoadCall(String jsonParameter) 
    {           
               
        MBSF_RTMDataWrapper.WrapperDataByMonth wrapperdata = new MBSF_RTMDataWrapper.WrapperDataByMonth();
        String suppressvalue =   Label.Suppress_value ;  
        String logedInUserId = userinfo.getUserId();
        
        try{
            MBSF_RTMDataWrapper.CommonDataWrapper wrapObj =  (MBSF_RTMDataWrapper.CommonDataWrapper) System.JSON.deserialize(jsonParameter, MBSF_RTMDataWrapper.CommonDataWrapper.class);
            Integer noOfRecordData  = Integer.valueOf(wrapObj.noOfRecord);
            if(noOfRecordData > 50000){
                noOfRecordData = 50000 ;                                                            
            }  
            List<MBSF_RTMDataWrapper.MonthWeekFilterData> monthWeekFilterDataList = new List<MBSF_RTMDataWrapper.MonthWeekFilterData>();
            List<String> campaignIdSet = new List<String>();  
            
                     
            List<MBSF_RTMDataWrapper.CampaignFilterData> campaignFilterDataList = new List<MBSF_RTMDataWrapper.CampaignFilterData>();
            for(Campaign campObj : [select Id,Name from Campaign where mbfs_Visiblity__c = true]){
                MBSF_RTMDataWrapper.CampaignFilterData campaignFilterData = new MBSF_RTMDataWrapper.CampaignFilterData(campObj.Id,campObj.Name);
                campaignFilterDataList.add(campaignFilterData);
                campaignIdSet.add(campObj.id);
            }            
            List<MBSF_RTMDataWrapper.TaskDurationData> taskDurationDataList = new List<MBSF_RTMDataWrapper.TaskDurationData>();
            MBSF_RTMDataWrapper.TaskDurationData todayPlusOverDue = new MBSF_RTMDataWrapper.TaskDurationData('Today+OverDue','Today_OverDue');
            MBSF_RTMDataWrapper.TaskDurationData todayOnly = new MBSF_RTMDataWrapper.TaskDurationData('Today','Today');            
            MBSF_RTMDataWrapper.TaskDurationData overDue = new MBSF_RTMDataWrapper.TaskDurationData('OverDue','OverDue');
            MBSF_RTMDataWrapper.TaskDurationData noneOnly = new MBSF_RTMDataWrapper.TaskDurationData('None','None');
            MBSF_RTMDataWrapper.TaskDurationData futureOnly = new MBSF_RTMDataWrapper.TaskDurationData('Future','Future');
            taskDurationDataList.add(todayPlusOverDue);
            taskDurationDataList.add(todayOnly);
            taskDurationDataList.add(overDue); 
            taskDurationDataList.add(noneOnly); 
            taskDurationDataList.add(futureOnly);                  
            MBSF_RTMDataWrapper.ResultSet resultSet = MBSF_CommonHelper.rtmResultSetHelper( wrapObj);           
            String summarySQL = 'select count(Id) noOfCont,MBFS_Assign_To__c from contract where MBFS_Suppress__c=:suppressvalue and MBFS_Fleet__c = false and MBFS_Block__c = false and MBFS_Assign_To__c=:logedInUserId ';
            
            
            String campaignId = String.escapeSingleQuotes(wrapObj.campaignId.trim()) ;
            if(campaignId != MBFS_Constant.All && campaignId != MBFS_Constant.None){
                summarySQL = summarySQL + ' and MBFS_Campaign__c=:campaignId ';
            }
            if(campaignId == MBFS_Constant.All && campaignIdSet != null && campaignIdSet.size() > 0){
                summarySQL = summarySQL + ' and MBFS_Campaign__c IN : campaignIdSet ';
            }
            String dateFilter = wrapObj.dateFilter.trim() ;
            if(dateFilter != MBFS_Constant.None){
                if(dateFilter == MBFS_Constant.Today){
                    summarySQL = summarySQL + ' and MBFS_Last_Activity_Due_Date__c ='+String.valueOf(System.today()) ;
                }else if(dateFilter == MBFS_Constant.Today_OverDue){
                    summarySQL = summarySQL + ' and (MBFS_Last_Activity_Due_Date__c <= '+String.valueOf(System.today());
                    summarySQL = summarySQL + ' OR MBFS_Last_Activity_Due_Date__c = null) ';
                }else if(dateFilter == MBFS_Constant.OverDue){
                    summarySQL = summarySQL + ' and (MBFS_Last_Activity_Due_Date__c <= '+String.valueOf(System.today().addDays(-1));
                    summarySQL = summarySQL + ' OR MBFS_Last_Activity_Due_Date__c = null) ';
                }else if(dateFilter == MBFS_Constant.MBFS_RTM_FUTURE_DURATION ){
                    summarySQL = summarySQL + ' and (MBFS_Last_Activity_Due_Date__c > '+String.valueOf(System.today());
                    summarySQL = summarySQL + ' ) ';
                }
            }
            summarySQL = summarySQL + ' group by MBFS_Assign_To__c ';
            
            List<AggregateResult> chartresult = Database.query(summarySQL);
            Integer allDataCount = 0 ;
            for(AggregateResult aggObj : chartresult){
                String userId = (String) aggObj.get('MBFS_Assign_To__c') ;
                Integer noOfCont = (Integer) aggObj.get('noOfCont') ;
                if(userId != null){
                    allDataCount = allDataCount + noOfCont ;
                }
            }                     
            Datetime dt = DateTime.newInstance(System.today().addDays(+1), Time.newInstance(0, 0, 0, 0));
            Date newTaskDefaultDate = MBSF_CommonHelper.getDateExecludeWeekend(dt);          
            wrapperdata = new MBSF_RTMDataWrapper.WrapperDataByMonth(monthWeekFilterDataList,campaignFilterDataList,resultSet,taskDurationDataList,allDataCount,newTaskDefaultDate);            
            wrapperdata.isError = false ;
            
            
        }catch(Exception exce){
            wrapperdata.isError = true ;
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_RTMContractSegmentationController','onLoadCall',jsonParameter,exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj);
        }
        return wrapperdata ;
    }
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    @AuraEnabled
    public static MBSF_RTMDataWrapper.ResultSet onFilterChange(String jsonParameter)
    {  
        MBSF_RTMDataWrapper.ResultSet resultSet = new MBSF_RTMDataWrapper.ResultSet();
        
        String logedInUserId = userinfo.getUserId();
        try{    
            MBSF_RTMDataWrapper.CommonDataWrapper wrapObj =  (MBSF_RTMDataWrapper.CommonDataWrapper) System.JSON.deserialize(jsonParameter, MBSF_RTMDataWrapper.CommonDataWrapper.class);
            Integer noOfRecordData  = Integer.valueOf(wrapObj.noOfRecord);
            if(noOfRecordData > 50000){
                noOfRecordData = 50000 ;                                                            
            }  
            
            resultSet = MBSF_CommonHelper.rtmResultSetHelper( wrapObj);
            resultSet.isError = false ;
        }catch(Exception exce){
            resultSet.isError = true ;
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_RTMContractSegmentationController','onFilterChange',jsonParameter,exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj);    
        }
        return resultSet ;
    }
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    
    @AuraEnabled
    public static MBSF_RTMDataWrapper.ContractDeatilsData getContractDetails(String contractId){
        MBSF_RTMDataWrapper.ContractDeatilsData contractDeatilsData = new MBSF_RTMDataWrapper.ContractDeatilsData();
        try { 
            
            List<Lead> leadList = MBSF_CommonHelper.getContractDetailsLead(contractId);
            List<Task> taskList = MBSF_CommonHelper.getContractDetailsTask(contractId);
            
            List<MBSF_RTMDataWrapper.ContractDeatils> finance =  MBSF_CommonHelper.getContractFieldSet(contractId,'MBFS_Finance');           
            List<MBSF_RTMDataWrapper.ContractDeatils> borrower =  MBSF_CommonHelper.getContractFieldSet(contractId,'MBFS_Borrower');
            List<MBSF_RTMDataWrapper.ContractDeatils> rtmDetails =  MBSF_CommonHelper.getContractFieldSet(contractId,'MBFS_RTMDetails');
            List<MBSF_RTMDataWrapper.ContractDeatils> customerIntention =  MBSF_CommonHelper.getContractFieldSet(contractId,'MBFS_Customer_Intention');
            
            
            
            Contract conObj = [select id,MBFS_Do_Not_Call__c from Contract where Id=:contractId];
            List<MBFS_Diary_Notes__c> diaryNotesList = [select id,MBFS_Comment__c,MBFS_Comments_description__c,MBFS_Reason__c,Contract__c,MBFS_Event_Code__c,MBFS_Execution_Date__c from 
                                                        MBFS_Diary_Notes__c where Contract__c =:contractId order by MBFS_Execution_Date__c desc];
            
            Boolean doNotCall = conObj.MBFS_Do_Not_Call__c ;
            
            List<MBFS_Contract_Account_Junction__c> guarantorList = [Select Id,MBFS_Account__r.Name,MBFS_Account__r.PersonEmail,
                                                                     MBFS_Account__r.PersonMobilePhone,MBFS_Account__r.Phone,
                                                                     MBFS_Account__r.BillingAddress,MBFS_Account__r.PersonBirthdate,
                                                                     MBFS_Account__r.MBFS_Custom_Address__c
                                                                     from MBFS_Contract_Account_Junction__c where MBFS_Contract__c=:contractId];
            
           
            List<mbfs_Insurance__c> insuranceList = [Select Id,mbfs_Contract__r.MBFS_Policy_Number__c,Name,mbfs_Expiry_Date__c,
                                                     mbfs_Insured_Amount__c,mbfs_Issue_Date__c  from mbfs_Insurance__c 
                                                     where mbfs_Contract__c=:contractId];
            
            
            List<MBFS_Customer_Intention__c>  customerIntentionList    = [select Id,CreatedDate,MBFS_Comments__c,MBFS_Communication_Channel__c,MBFS_Contract_Expiry_Duration__c,
                                                    MBFS_Contract_Type__c,MBFS_Option__c,MBFS_Sub_Option__c from MBFS_Customer_Intention__c where
                                                    MBFS_Contract__c =:contractId];
           
            
            contractDeatilsData = new MBSF_RTMDataWrapper.ContractDeatilsData(finance,borrower,rtmDetails,customerIntention,
                                                                              taskList,leadList,doNotCall,
                                                                              diaryNotesList,guarantorList,insuranceList,customerIntentionList);
            contractDeatilsData.isError = false ;
        }catch(Exception exce){
            contractDeatilsData.isError = true ;
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_RTMContractSegmentationController','getContractDetails',contractId,exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj);    
           
        }
        return contractDeatilsData;
    }
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    
    @AuraEnabled
    public static MBSF_RTMDataWrapper.NewEditTaskData onEditNewTask(String contractId){
        
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
                                                                             and RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'Outcome and action') and MBFS_Outgoing__c = true];
            
            Map<String,List<MBSF_RTMDataWrapper.SubOutComeActionData>> outComeToSubOutCome= MBSF_CommonHelper.getOutComeToSubOutComeMap(subOutComeAndActionList);
            
            
            newEditTaskData = new MBSF_RTMDataWrapper.NewEditTaskData(taskObj,outComeToSubOutCome,conObj); 
            newEditTaskData.isError = false ;
        }catch(Exception exce){
            newEditTaskData.isError = true ;
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_RTMContractSegmentationController','onEditNewTask',contractId,exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj);  
        }
        return newEditTaskData;
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
                String campaignId = (String) dataMap.get('campaignId');
                String dateTimeFilter = (String) dataMap.get('dateTimeFilter');
                
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
                if(campaignId != null && selectedContractID != null && subOutComeAction != null 
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
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_RTMContractSegmentationController','onNewEditTaskSubmit',data,exce);
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
                if(newTaskObj.get('Description') != null){
                    taskNew.Description= String.valueOf(newTaskObj.get('Description')) ;
                }                              
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
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    
    @AuraEnabled
    public static MBSF_RTMDataWrapper.RTMPickListValues getPickListToValue(String objectToFieldMap){  
        
        MBSF_RTMDataWrapper.RTMPickListValues rtmPickListToValueData = new MBSF_RTMDataWrapper.RTMPickListValues();
        Map<String,MBSF_RTMDataWrapper.PickListToValueData> pickListToValueData = new Map<String,MBSF_RTMDataWrapper.PickListToValueData>();
        try {            
            Map<String,Object> objectToFieldsMap =  (Map<String,Object> ) JSON.deserializeUntyped(objectToFieldMap);            
            for(String objName : objectToFieldsMap.keySet()){            
                List<Object> fieldApiNameObj =  (List<Object> ) objectToFieldsMap.get(objName) ;
                List<String> fieldApiNameStr = new List<String> ();
                for(Object obj : fieldApiNameObj){
                    fieldApiNameStr.add((String) obj);
                }             
                Schema.SObjectType convertType = Schema.getGlobalDescribe().get(objName);
                Sobject genericObject = convertType.newSObject();                
                if(objName == 'Task'){                                     
                    Task taskObj = (Task)convertType.newSObject();                   
                    Schema.sObjectType sobject_type = taskObj.getSObjectType();
                    Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); 
                    Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();  
                    for(String field_name :fieldApiNameStr) {
                        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); 
                        List<String> options = new List<String>();
                        for (Schema.PicklistEntry a : pick_list_values) { 
                            options.add(a.getValue()); 
                        }
                        MBSF_RTMDataWrapper.PickListToValueData obj= new MBSF_RTMDataWrapper.PickListToValueData(options);
                        pickListToValueData.put(field_name,obj);
                    }                     
                }else if(objName == 'Lead'){
                    Lead taskObj = (Lead)convertType.newSObject();                   
                    Schema.sObjectType sobject_type = taskObj.getSObjectType();
                    Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); 
                    Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();  
                    for(String field_name :fieldApiNameStr) {
                        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); 
                        List<String> options = new List<String>();
                        for (Schema.PicklistEntry a : pick_list_values) { 
                            options.add(a.getValue()); 
                        }
                        MBSF_RTMDataWrapper.PickListToValueData obj= new MBSF_RTMDataWrapper.PickListToValueData(options);
                        pickListToValueData.put(field_name,obj);
                    }                                      
                }                                
            }
            
            Map<String,List<String>> actionToValuesMap = new Map<String,List<String>>();            
            List<MBFS_RTH_SubOutComeAndAction__c> lNobjList = [select Id,MBFS_Sequence__c,MBFS_Is_Active__c,Name,
                                                               MBFS_Sub_Outcome__c,MBFS_Action__c from 
                                                               MBFS_RTH_SubOutComeAndAction__c where MBFS_Is_Active__c = true 
                                                               and RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'Lead Type')];               
            for(Integer i = 0 ; i < lNobjList.size() ; i++ ){     
                for(MBFS_RTH_SubOutComeAndAction__c lNobj : lNobjList ){
                    if(lNobj.MBFS_Sequence__c == i) {  
                        if(actionToValuesMap.get(lNobj.MBFS_Action__c) == null) {
                            List<String> natureList = new List<String>();
                            natureList.add(lNobj.MBFS_Sub_Outcome__c);
                            actionToValuesMap.put(lNobj.MBFS_Action__c,natureList);
                        }else{
                            List<String> natureList = actionToValuesMap.get(lNobj.MBFS_Action__c);
                            natureList.add(lNobj.MBFS_Sub_Outcome__c);
                            actionToValuesMap.put(lNobj.MBFS_Action__c,natureList);               
                        }
                    }
                }
            }               
            for(String key : actionToValuesMap.keySet()){
                MBSF_RTMDataWrapper.PickListToValueData obj= new MBSF_RTMDataWrapper.PickListToValueData(actionToValuesMap.get(key));
                pickListToValueData.put(key,obj);
            } 
           
           rtmPickListToValueData = new MBSF_RTMDataWrapper.RTMPickListValues(pickListToValueData); 
           rtmPickListToValueData.rtmPickListToValueData =  pickListToValueData ;
           rtmPickListToValueData.isError = false ; 
        }catch(Exception exce){  
            rtmPickListToValueData.isError = true ; 
            MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_RTMContractSegmentationController','getPickListToValue',objectToFieldMap,exce);
            MBSF_CommonHelper.insertErrorLog(exceWrapObj); 
        }
        return rtmPickListToValueData ;
    } 
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    @AuraEnabled
    public static List<Account> fetchAccount(String searchKeyWord){
        String searchKey = searchKeyWord + '%';
        List < Account > returnList = new List <Account> ();
        List < Account > lstOfLoan = new List<Account>();
        if(searchKeyWord.length() > 0){
            lstOfLoan = [select id, Name from Account where Name LIKE: searchKey and RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'Dealer Account') and MBFS_Active_Dealer__c = true];
        }
        
        for (Account objLoan : lstOfLoan) {
            returnList.add(objLoan);
        }
        return returnList;
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
   
}