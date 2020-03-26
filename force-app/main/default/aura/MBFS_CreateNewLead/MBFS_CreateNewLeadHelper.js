({
    initCallHelper : function(component, event,contractId) {
        if(!$A.util.isUndefinedOrNull(contractId))
        {     
            this.waiting();
            var pickListValuesLead = [];
            pickListValuesLead.push('MBFS_Interested_Vehicle_category__c');
            pickListValuesLead.push('MBFS_Vehicle_Make_interest__c');
            pickListValuesLead.push('MBFS_Model_Interest__c');
            pickListValuesLead.push('MBFS_Lead_Type__c');
            
            
            var pickListValuesTask = [];
            pickListValuesTask.push('MBFS_Customer_Not_Interested__c');
            pickListValuesTask.push('MBFS_Do_Not_Call__c');
            pickListValuesTask.push('MBFS_Lost_to_Competitor__c');
            
            var pickListMap = {
                Task :  pickListValuesTask,
                Lead :  pickListValuesLead 
            }
            
            var action = component.get("c.onLoadCall");        
            action.setParams({ 
                "jsonData":JSON.stringify(pickListMap),
                "contractId":contractId
            }); 
            
            action.setCallback(this, function(response){
                var state = response.getState();  
                
                if ((state === "SUCCESS") && (component.isValid())) {                
                    var responseData = response.getReturnValue(); 
                    
                    var isError = responseData.isError ;
                    
                    if(isError === false){ 
                        
                        var records = responseData.pickListValues.rtmPickListToValueData ;                    
                        component.set("v.MBFS_Nature_of_LeadAll",records);
                        
                        component.set("v.MBFS_Customer_Not_Interested",records.MBFS_Customer_Not_Interested__c.values);
                        component.set("v.MBFS_Customer_Not_Interested_Value",records.MBFS_Customer_Not_Interested__c.values[0]);
                        
                        component.set("v.MBFS_Do_Not_Call",records.MBFS_Do_Not_Call__c.values);
                        component.set("v.MBFS_Do_Not_Call_Value",records.MBFS_Do_Not_Call__c.values[0]);
                        
                        component.set("v.MBFS_Lost_to_Competitor",records.MBFS_Lost_to_Competitor__c.values);   
                        component.set("v.MBFS_Lost_to_Competitor_Value",records.MBFS_Lost_to_Competitor__c.values[0]);
                        
                        component.set("v.MBFS_Nature_of_Request",records.Retailer_Lead.values);   
                        component.set("v.MBFS_Nature_of_Request_Value",records.Retailer_Lead.values[0]);
                        
                        //Set the lead source on load
                        component.set("v.MBFS_Lead_Source",records.Retailer_Source.values);   
                        component.set("v.MBFS_Lead_Source_Value",records.Retailer_Source.values[0]);
                        
                        component.set("v.MBFS_Lead_Type",records.MBFS_Lead_Type__c.values);   
                        component.set("v.MBFS_Lead_Type_Value",records.MBFS_Lead_Type__c.values[0]);
                        
                        component.set("v.MBFS_Interested_Vehicle_category",records.MBFS_Interested_Vehicle_category__c.values);   
                        //component.set("v.MBFS_Interested_Vehicle_category_Value",records.MBFS_Interested_Vehicle_category__c.values[0]);
                        
                        component.set("v.MBFS_Vehicle_Make_interest",records.MBFS_Vehicle_Make_interest__c.values);   
                        //component.set("v.MBFS_Vehicle_Make_interest_Value",records.MBFS_Vehicle_Make_interest__c.values[0]);
                        
                        component.set("v.MBFS_Model_Interest",records.MBFS_Model_Interest__c.values);   
                        //component.set("v.MBFS_Model_Interest_Value",records.MBFS_Model_Interest__c.values[0]);
                        
                        
                        //Future Task
                        var FUTURE_TASK = component.get("v.FUTURE_TASK");
                        FUTURE_TASK.ActivityDate = responseData.newTaskDefaultDate ;
                        component.set("v.FUTURE_TASK",FUTURE_TASK);
                        
                        //Finance Task
                        var FINANCE_TASK = component.get("v.FINANCE_TASK");
                        FINANCE_TASK.ActivityDate = responseData.newTaskDefaultDate ;
                        component.set("v.FINANCE_TASK",FINANCE_TASK);
                        
                        //Lead data
                        this.createLeadObject(component,event,responseData.newEditTaskData);
                        
                        this.doneWaiting();
                    }else{                        
                        this.showToast(component,"true",$A.get("$Label.c.MBFS_Exception_message"),"true","false");
                        this.doneWaiting();
                    }
                }else if(state === "ERROR"){                
                    this.showToast(component,"true",$A.get("$Label.c.MBFS_Exception_message"),"true","false");
                    this.doneWaiting();
                }
            });
            $A.enqueueAction(action); 
            
        }
    },
    createLeadObject: function(component,event,responseData) {
        
        component.set("v.NewEditTaskData",responseData);
        
        var OutComeList = [];
        for (var keyofMap in responseData.outComeToSubOutCome){
            OutComeList.push({
                key: keyofMap,
                value: responseData.outComeToSubOutCome[keyofMap]
            });
        }                    
        component.set("v.OutComeList",OutComeList);
        
        var FUTURE_LEAD = component.get("v.FUTURE_LEAD");
        
        var fNameCheck = !$A.util.isUndefinedOrNull(responseData.conObj.Account) &&
            !$A.util.isUndefinedOrNull(responseData.conObj.Account.IsPersonAccount) &&
            !$A.util.isUndefinedOrNull(responseData.conObj.Account.FirstName) &&
            responseData.conObj.Account.IsPersonAccount === true ;
        if(fNameCheck){                            
            FUTURE_LEAD.FirstName = responseData.conObj.Account.FirstName ;
        }else {
            FUTURE_LEAD.FirstName = "" ;
        }
        
        
        var lNameCheck = !$A.util.isUndefinedOrNull(responseData.conObj.Account) &&
            !$A.util.isUndefinedOrNull(responseData.conObj.Account.IsPersonAccount) &&
            !$A.util.isUndefinedOrNull(responseData.conObj.Account.LastName) &&
            responseData.conObj.Account.IsPersonAccount === true ;
        if(lNameCheck){                           
            FUTURE_LEAD.LastName = responseData.conObj.Account.LastName ;
        }else{
            FUTURE_LEAD.LastName = "" ;
        }
        
        var emailCheck =   !$A.util.isUndefinedOrNull(responseData.conObj.Account) &&
            !$A.util.isUndefinedOrNull(responseData.conObj.Account.IsPersonAccount) &&
            !$A.util.isUndefinedOrNull(responseData.conObj.Account.PersonEmail) &&
            responseData.conObj.Account.IsPersonAccount === true ;
        
        if(emailCheck){                            
            FUTURE_LEAD.Email = responseData.conObj.Account.PersonEmail ;
        }else{
            FUTURE_LEAD.Email = "" ;
        }
        
        var phoneCheck =   !$A.util.isUndefinedOrNull(responseData.conObj.Account) &&
            !$A.util.isUndefinedOrNull(responseData.conObj.Account.IsPersonAccount) &&
            !$A.util.isUndefinedOrNull(responseData.conObj.Account.Phone) &&
            responseData.conObj.Account.IsPersonAccount === true ;
        if(phoneCheck){                           
            FUTURE_LEAD.Phone = responseData.conObj.Account.Phone ;
        }else{
            FUTURE_LEAD.Phone = "";
        }
        
        var mobileCheck = !$A.util.isUndefinedOrNull(responseData.conObj.Account) &&
            !$A.util.isUndefinedOrNull(responseData.conObj.Account.IsPersonAccount) &&
            !$A.util.isUndefinedOrNull(responseData.conObj.Account.PersonMobilePhone) &&
            responseData.conObj.Account.IsPersonAccount === true ;
        
        if(mobileCheck){                            
            FUTURE_LEAD.MobilePhone = responseData.conObj.Account.PersonMobilePhone ;
        }else{
            FUTURE_LEAD.MobilePhone = "";
        }
        
        if(!$A.util.isUndefinedOrNull(responseData.conObj.MBFS_Dealer_Account__c)){                                
            FUTURE_LEAD.MBFS_Dealer_Account__c = responseData.conObj.MBFS_Dealer_Account__r.Id ;
            FUTURE_LEAD.MBFS_Dealer_Account__r = responseData.conObj.MBFS_Dealer_Account__r ;
        }else{
            FUTURE_LEAD.MBFS_Dealer_Account__c = ""; 
            FUTURE_LEAD.MBFS_Dealer_Account__r = "";
        }
        
        component.set("v.FUTURE_LEAD",FUTURE_LEAD); 
        
    },
    validateForm: function(component,event,actionName) { 
        
        var checkParameter =  !$A.util.isUndefinedOrNull(component.get("v.outComeName")) &&
            !$A.util.isUndefinedOrNull(component.get("v.subOutComeName")) &&
            !$A.util.isUndefinedOrNull(actionName) ;
        
        if(checkParameter){ 
            
            if(component.get("v.outComeName") !== "" && component.get("v.subOutComeName") !==""){               
                if(actionName === 'WASH_LIST_NEW_LEAD'){                    
                    var FUTURE_LEAD = component.get("v.FUTURE_LEAD");
                    var FINANCE_TASK = component.get("v.FINANCE_TASK");
                    var MBFS_Lead_Type_Value = component.get("v.MBFS_Lead_Type_Value");
                    
                    var regExpressionEmail = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
                    
                    var regExpressionNumber = /^[0-9 ]+/;
                   
                    
                    if(component.get("v.MBFS_Interested_Vehicle_category_Value") === ""){
                        component.set("v.exceptionFlag",false); 
                        this.showToast(component,"true","Interested vehicle category is required","true","false");
                        
                    }else if(component.get("v.MBFS_Vehicle_Make_interest_Value") === ""){
                        component.set("v.exceptionFlag",false); 
                        this.showToast(component,"true","Vehicle make interest is required","true","false");
                        
                    }else if(component.get("v.MBFS_Model_Interest_Value") === ""){
                        component.set("v.exceptionFlag",false); 
                        this.showToast(component,"true","Vehicle model interest is required","true","false");
                        
                    }else if((FUTURE_LEAD.FirstName).trim() === ""){
                        component.set("v.exceptionFlag",false); 
                        this.showToast(component,"true","First name is required","true","false");
                        
                    }else if((FUTURE_LEAD.LastName).trim() === ""){
                        component.set("v.exceptionFlag",false);
                        this.showToast(component,"true","Last name is required","true","false");
                        
                    }else if(FUTURE_LEAD.Email != "" && regExpressionEmail && !regExpressionEmail.test((FUTURE_LEAD.Email).trim())){                       
                        component.set("v.exceptionFlag",false);               
                        this.showToast(component,"true","Email format is not correct","true","false");
                        
                    }else if(FUTURE_LEAD.Phone != "" && regExpressionNumber && !regExpressionNumber.test((FUTURE_LEAD.Phone).trim())){
                        component.set("v.exceptionFlag",false);
                        this.showToast(component,"true","Phone format is not correct","true","false"); 
                        
                    }else if(FUTURE_LEAD.MobilePhone !="" && regExpressionNumber && !regExpressionNumber.test((FUTURE_LEAD.MobilePhone).trim())){
                        component.set("v.exceptionFlag",false);
                        this.showToast(component,"true","MobilePhone format is not correct","true","false"); 
                        
                    }else if(MBFS_Lead_Type_Value === 'Retailer Lead' && (FUTURE_LEAD.MBFS_Dealer_Account__c).trim() ===""){
                        component.set("v.exceptionFlag",false);
                        this.showToast(component,"true","Dealer is required","true","false"); 
                       
                    }else if(MBFS_Lead_Type_Value === 'Retailer Lead' && (FUTURE_LEAD.MBFS_Dealer_Account__c).trim() !==""){                        
                        component.set("v.exceptionFlag",false);
                        this.validateDealerAcc(component,event,(FUTURE_LEAD.MBFS_Dealer_Account__c).trim());
                        
                    }else if(MBFS_Lead_Type_Value === 'Finance Lead' && (FUTURE_LEAD.Email).trim() ===""){
                        component.set("v.exceptionFlag",false);
                        this.showToast(component,"true","Email is required","true","false"); 
                        
                    }else if(MBFS_Lead_Type_Value === 'Finance Lead' && (FINANCE_TASK.ActivityDate).trim() ===""){
                        component.set("v.exceptionFlag",false);
                        this.showToast(component,"true","Finance task due date is required","true","false");                        
                    }else{
                        component.set("v.exceptionFlag",true);  
                    }                                   
                }else if(actionName === 'FUTURE_TASK'){  
                    
                    var FUTURE_TASK = component.get("v.FUTURE_TASK");
                    if((FUTURE_TASK.Subject).trim() === ""){
                        component.set("v.exceptionFlag",false);
                        
                        this.showToast(component,"true","Subject is mandatory","true","false"); 
                    }if((FUTURE_TASK.ActivityDate).trim() ===""){
                        component.set("v.exceptionFlag",false);
                        
                        this.showToast(component,"true","ActivityDate is mandatory","true","false");   
                    }else {
                        component.set("v.exceptionFlag",true);  
                    }   
                }else{
                    component.set("v.exceptionFlag",true); 
                }         
            }else{
                component.set("v.exceptionFlag",false);
                this.showToast(component,"true","Outcome and Suboutcome are mandatory","true","false");                                                    
            }
        }
    },
    validateDealerAcc: function(component,event,dealerAccountId) {
        if(!$A.util.isUndefinedOrNull(dealerAccountId))
        {                 
            var action = component.get("c.validateDealerAccount");               
            action.setParams({ 
                "accountId" :dealerAccountId
            });              
            action.setCallback(this, function(response){
                var state = response.getState();                  
                if ((state === "SUCCESS") && (component.isValid())) {
                    var records = response.getReturnValue();                   
                    if(records === false){
                        component.set("v.exceptionFlag",false);
                        this.showToast(component,"true","Dealer must be active","true","false");
                    }else{
                        component.set("v.exceptionFlag",true); 
                        this.editTaskSubmitHelper(component, event);
                    }
                }else if(state === "ERROR"){
                    this.showToast(component,"true",$A.get("$Label.c.MBFS_Exception_message"),"true","false");                                     
                }
            });
            $A.enqueueAction(action);
        }else{
            this.showToast(component,"true",$A.get("$Label.c.MBFS_Exception_message"),"true","false");                                           
        }
    },
    waiting: function() {
        if(!$A.util.isUndefinedOrNull(document.getElementById("NewLeadspinner")))
        {
            document.getElementById("NewLeadspinner").style.display = "block";            
        }         
    },
    doneWaiting: function() {
        if(!$A.util.isUndefinedOrNull(document.getElementById("NewLeadspinner")))
        {
            document.getElementById("NewLeadspinner").style.display = "none";
        }
    },
    showToast: function(component,openToast,message,isError,isSuccess) {
        component.set("v.openToast",openToast);
        component.set("v.message",message);
        component.set("v.isError",isError);
        component.set("v.isSuccess",isSuccess);
    },
    editTaskSubmitHelper: function(component, event) {
         var NewEditTaskData = component.get("v.NewEditTaskData");
         var outComeName = component.get("v.outComeName");
         var subOutComeName = component.get("v.subOutComeName");
         var subOutComeAction = component.get("v.subOutComeAction");      
         
         var campaignName = component.get("v.campaignName");      
         var selectedContractID = component.get("v.recordId");
         var newTask = component.get("v.FUTURE_TASK");
         var newlead = component.get("v.FUTURE_LEAD");
        
         if(component.get("v.exceptionFlag") === true ){
             
             if(subOutComeAction === 'WASH_LIST_DO_NOT_CALL_REGISTER')
             {
                newTask.MBFS_Do_Not_Call__c = component.get("v.MBFS_Do_Not_Call_Value");
             }
             if(subOutComeAction === 'WASH_LIST_LOST_TO_COMPETITOR')
             {
                newTask.MBFS_Lost_to_Competitor__c = component.get("v.MBFS_Lost_to_Competitor_Value");
             }
             
            
             if(subOutComeAction === 'WASH_LIST_NEW_LEAD')
             {
                newlead.MBFS_Nature_of_Request__c = component.get("v.MBFS_Nature_of_Request_Value");
                newlead.MBFS_Lead_Type__c = component.get("v.MBFS_Lead_Type_Value");
                newlead.MBFS_Interested_Vehicle_category__c = component.get("v.MBFS_Interested_Vehicle_category_Value");
                newlead.MBFS_Vehicle_Make_interest__c = component.get("v.MBFS_Vehicle_Make_interest_Value");
                newlead.MBFS_Model_Interest__c = component.get("v.MBFS_Model_Interest_Value"); 
                newlead.LeadSource  =  component.get("v.MBFS_Lead_Source_Value");
             }         
            
             var wrapperObj = new Object();
             
             wrapperObj.taskObj = NewEditTaskData.taskObj ;
             
             if(subOutComeAction === 'WASH_LIST_DO_NOT_CALL_REGISTER'){
               wrapperObj.taskObj.MBFS_Do_Not_Call__c =   component.get("v.MBFS_Do_Not_Call_Value"); 
             }
             if(subOutComeAction === 'WASH_LIST_LOST_TO_COMPETITOR'){
               wrapperObj.taskObj.MBFS_Lost_to_Competitor__c =   component.get("v.MBFS_Lost_to_Competitor_Value"); 
             }
             if(subOutComeAction === 'WASH_LIST_CUSTOMER_NOT_INTERESTED')
             {
                wrapperObj.taskObj.MBFS_Customer_Not_Interested__c = component.get("v.MBFS_Customer_Not_Interested_Value");
             }
            
             wrapperObj.outcome = outComeName ;
             wrapperObj.suboutcome = subOutComeName ;
             wrapperObj.subOutComeAction = subOutComeAction ;
             wrapperObj.newtask = newTask ;
             wrapperObj.newlead = newlead ;
             wrapperObj.campaignId = campaignName ;
             
             wrapperObj.selectedContractID = selectedContractID ;
             //Finance Task
             wrapperObj.financetask =   component.get("v.FINANCE_TASK");
             
             this.insertData(component, event,JSON.stringify(wrapperObj));
            
        }       
    },
    insertData: function(component,event,jsonData) { 
        if(!$A.util.isUndefinedOrNull(jsonData))
        {      
            this.waiting();
            var action = component.get("c.onNewEditTaskSubmit");   
            
            action.setParams({ 
                "data" :jsonData
            });   
            
            action.setCallback(this, function(response){
                var state = response.getState();  
                if ((state === "SUCCESS") && (component.isValid())) {
                    var records = response.getReturnValue(); 
                    var isError = records ;
                    
                    if(isError === false){ 
                        $A.get("e.force:closeQuickAction").fire(); 
                        $A.get('e.force:refreshView').fire();
                        this.doneWaiting();
                    }else{
                        this.showToast(component,"true",$A.get("$Label.c.MBFS_Exception_message"),"true","false");                                     
                        this.doneWaiting();                          
                    }
                }else if(state === "ERROR"){
                    this.showToast(component,"true",$A.get("$Label.c.MBFS_Exception_message"),"true","false");                                     
                    this.doneWaiting();                     
                }
            });
            $A.enqueueAction(action);
        }else{
            this.showToast(component,"true",$A.get("$Label.c.MBFS_Exception_message"),"true","false");                                     
            this.doneWaiting();
        }
        
    },
    clearFormWithOutCome : function(component) {             
        component.set("v.subOutComeName","");
        component.set("v.subOutComeAction","");        
        component.set("v.FUTURE_TASK.Subject","Call");    
        component.set("v.FUTURE_TASK.Description","");   
        component.set("v.FUTURE_LEAD.Description","");         
    },
})