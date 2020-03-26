({
    renderPage: function(component) {  
        var records = component.get("v.AllAccountList");
        var pageNumber = component.get("v.pageNumber"); 
        var defaultCount = component.get("v.defaultCount");    
        
        var pageRecords = records.slice((pageNumber-1)* defaultCount, pageNumber * defaultCount); 
        //Set The Intention Status
        for(var i=0 ; i < pageRecords.length; i++){
            for(var j=0 ; j < pageRecords[i].fields.length; j++){
                if(!$A.util.isUndefinedOrNull(pageRecords[i].fields[j].fieldApi) &&
                   !$A.util.isUndefinedOrNull(pageRecords[i].fields[j].fieldValue) &&
                   pageRecords[i].fields[j].fieldApi === "mbfs_intention_status__c" && 
                   pageRecords[i].fields[j].fieldValue !== ""){                    
                    pageRecords[i].fields[j].fieldValue = "<img src=" +pageRecords[i].fields[j].fieldValue+" style='height:25px; width:25px;' alt='Loading' border='0'/>";
                }
            }
        }
        //Set The Intention Status
        
        component.set("v.PageAccountList", pageRecords);      
        var countData = component.get("v.WrapperData").recordCount ;      
        
        component.set("v.totalNoOfrecord",countData);           
        component.set("v.maxPage", Math.floor((countData + (defaultCount - 1))/defaultCount)); 
        
    },
    loadData: function(component) {   
        
        if(!$A.util.isUndefinedOrNull(component.get("v.WrapperData"))
           && !$A.util.isUndefinedOrNull(component.get("v.defaultCount"))){
            var WrapperData = component.get("v.WrapperData"); 
            
            component.set("v.AllAccountList",WrapperData.resultSet.rows);    
            component.set("v.sortField","MBFS_Last_Activity_Due_Date__c");
            component.set("v.pageNumber",1);
            this.renderPage(component);
        }     
        
    },
    loadMoreData: function(component,event,noOfRecord) {
        
        var checkParameter  = !$A.util.isUndefinedOrNull(noOfRecord)           
        && !$A.util.isUndefinedOrNull(component.get("v.campaignName")) 
        && !$A.util.isUndefinedOrNull(component.get("v.dateFilter"))
        && !$A.util.isUndefinedOrNull(component.get("v.sortField"))
        && !$A.util.isUndefinedOrNull(component.get("v.sortAsc"))           
        && !$A.util.isUndefinedOrNull(component.get("v.WrapperData"))
        && !$A.util.isUndefinedOrNull(component.get("v.AllAccountList")) ;
        
        if(checkParameter)
        {              
            this.waiting();
            
            var wrapperObj = { 
                filter      : "",
                campaignId  : component.get("v.campaignName"),
                dateFilter  : component.get("v.dateFilter"),
                sortField   : component.get("v.sortField"),
                isAscending : component.get("v.sortAsc"),
                noOfRecord  : noOfRecord
            };
            
            
            var action = component.get("c.onFilterChange");
            action.setParams({                
                jsonParameter : JSON.stringify(wrapperObj)
            });   
            
            action.setCallback(this, function(response){
                var state = response.getState(); 
                
                if ((state === "SUCCESS") && (component.isValid())) {                  
                    var records = response.getReturnValue(); 
                    var isError = records.isError ;
                    if(isError === false){ 
                        var WrapperData = component.get("v.WrapperData");                   
                        var AllAccountList = component.get("v.AllAccountList");
                        
                        var updatedData = records.rows ;
                        
                        if(updatedData !== null){
                            while(AllAccountList.length > 0) {
                                AllAccountList.pop();
                            }
                            AllAccountList = updatedData;  
                            WrapperData.resultSet.rows = updatedData ;
                            component.set("v.WrapperData",WrapperData); 
                            component.set("v.AllAccountList",AllAccountList); 
                        } 
                        
                        component.set("v.pageNumber", Math.min(component.get("v.pageNumber")+1, component.get("v.maxPage")));                    
                        this.doneWaiting();
                    }else{
                        this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                        this.doneWaiting();      
                    }
                }else if(state === "ERROR"){   
                    this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                    this.doneWaiting();                 
                }
            });
            $A.enqueueAction(action);
        }else{
            this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
            this.doneWaiting();
        }
    },
    onLastClick: function(component,event,noOfRecord) {
        
        var checkParameter  = !$A.util.isUndefinedOrNull(noOfRecord)
        && !$A.util.isUndefinedOrNull(component.get("v.campaignName")) 
        && !$A.util.isUndefinedOrNull(component.get("v.dateFilter"))
        && !$A.util.isUndefinedOrNull(component.get("v.sortField"))
        && !$A.util.isUndefinedOrNull(component.get("v.sortAsc"))           
        && !$A.util.isUndefinedOrNull(component.get("v.WrapperData"))
        && !$A.util.isUndefinedOrNull(component.get("v.AllAccountList")) ;
        
        if(checkParameter)
        {              
            this.waiting();            
            
            var wrapperObj = { 
                filter      : "",
                campaignId  : component.get("v.campaignName"),
                dateFilter  : component.get("v.dateFilter"),
                sortField   : component.get("v.sortField"),
                isAscending : component.get("v.sortAsc"),
                noOfRecord  : noOfRecord
            };
            
            var action = component.get("c.onFilterChange");
            action.setParams({                 
                jsonParameter : JSON.stringify(wrapperObj)
            });   
            
            action.setCallback(this, function(response){
                var state = response.getState(); 
                
                if ((state === "SUCCESS") && (component.isValid())) {                  
                    var records = response.getReturnValue();  
                    var isError = records.isError ;
                    if(isError === false){
                        var WrapperData = component.get("v.WrapperData");                   
                        var AllAccountList = component.get("v.AllAccountList");
                        
                        var updatedData = records.rows ;
                        
                        if(updatedData !== null){
                            while(AllAccountList.length > 0) {
                                AllAccountList.pop();
                            }
                            AllAccountList = updatedData;  
                            WrapperData.resultSet.rows = updatedData ;
                            component.set("v.WrapperData",WrapperData); 
                            component.set("v.AllAccountList",AllAccountList); 
                        } 
                        
                        component.set("v.pageNumber", component.get("v.maxPage"));
                        this.doneWaiting(); 
                    }else{
                        this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                        this.doneWaiting();     
                    }
                }else if(state === "ERROR"){
                    this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                    this.doneWaiting();                  
                }
            });
            $A.enqueueAction(action);
        }else{
            this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
            this.doneWaiting(component, event);
        }
    },
    sortData: function(component,event,sortField,sortAsc,noOfRecord) {
        
        var checkParameter  =  !$A.util.isUndefinedOrNull(sortField) 
        && !$A.util.isUndefinedOrNull(sortAsc)
        && !$A.util.isUndefinedOrNull(component.get("v.campaignName"))  
        && !$A.util.isUndefinedOrNull(component.get("v.dateFilter")) 
        && !$A.util.isUndefinedOrNull(component.get("v.defaultCount")) ;
        
        if(checkParameter)
        {     
            this.waiting();
            
            var wrapperObj = { 
                filter      : "",
                campaignId  : component.get("v.campaignName"),
                dateFilter  : component.get("v.dateFilter"),
                sortField   : sortField,
                isAscending : sortAsc,
                noOfRecord  : noOfRecord
            };
            
            
            var action = component.get("c.onFilterChange");        
            action.setParams({                
                jsonParameter : JSON.stringify(wrapperObj)
            });   
            
            action.setCallback(this, function(response){
                var state = response.getState();   
                
                if ((state === "SUCCESS") && (component.isValid())) {
                    var records = response.getReturnValue(); 
                    var isError = records.isError ;
                    if(isError === false){ 
                        if(records !== null && records.rows !== null){
                            var updatedData = records.rows ;                      
                            var WrapperData = component.get("v.WrapperData"); 
                            WrapperData.resultSet.rows = updatedData ;
                            component.set("v.WrapperData",WrapperData);  
                            
                            component.set("v.AllAccountList",updatedData);     
                            component.set("v.pageNumber",1);
                        }
                        this.renderPage(component);
                        this.doneWaiting(); 
                    }else{
                        this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                        this.doneWaiting();  
                    }
                }else if(state === "ERROR"){
                    this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                    this.doneWaiting();                  
                }
            });
            $A.enqueueAction(action);
        }else{
            this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
            this.doneWaiting(component, event);
        }
        
    },
    onContractDetailsClickHelper : function(component,event,contractId) {       
        if(!$A.util.isUndefinedOrNull(contractId))
        {    
            this.waiting();
            var action = component.get("c.getContractDetails");        
            action.setParams({ 
                "contractId" :contractId
            });   
            
            action.setCallback(this, function(response){
                var state = response.getState();                 
                if ((state === "SUCCESS") && (component.isValid())) {
                    var records = response.getReturnValue();  
                    var isError = records.isError ;
                    if(isError === false){ 
                        component.set("v.ContractDeatilsData",records);
                        this.doneWaiting();
                    }else{
                        this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                        this.doneWaiting(); 
                    }
                }else if(state === "ERROR"){
                    this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                    this.doneWaiting();                 
                }
            });
            $A.enqueueAction(action);
        }else{
            this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
            this.doneWaiting();
        }
        
    },
    onNewLeadCreatClickHelper : function(component,event,contractId) {    
        
        if(!$A.util.isUndefinedOrNull(contractId))
        {     
            this.waiting();
            var action = component.get("c.onEditNewTask");        
            action.setParams({ 
                "contractId" :contractId
            });   
            
            action.setCallback(this, function(response){
                var state = response.getState();  
                if ((state === "SUCCESS") && (component.isValid())) {
                    var records = response.getReturnValue(); 
                    
                    var isError = records.isError ;
                    if(isError === false){ 
                        component.set("v.NewEditTaskData",records);
                        
                        var OutComeList = [];
                        for (var keyofMap in records.outComeToSubOutCome){
                            OutComeList.push({
                                key: keyofMap,
                                value: records.outComeToSubOutCome[keyofMap]
                            });
                        }                    
                        component.set("v.OutComeList",OutComeList);
                        
                        var FUTURE_LEAD = component.get("v.FUTURE_LEAD");
                        
                        var fNameCheck = !$A.util.isUndefinedOrNull(records.conObj.Account) &&
                            !$A.util.isUndefinedOrNull(records.conObj.Account.IsPersonAccount) &&
                            !$A.util.isUndefinedOrNull(records.conObj.Account.FirstName) &&
                            records.conObj.Account.IsPersonAccount === true ;
                        if(fNameCheck){                            
                            FUTURE_LEAD.FirstName = records.conObj.Account.FirstName ;
                        }else {
                            FUTURE_LEAD.FirstName = "" ;
                        }
                        
                        var lNameCheck = !$A.util.isUndefinedOrNull(records.conObj.Account) &&
                            !$A.util.isUndefinedOrNull(records.conObj.Account.IsPersonAccount) &&
                            !$A.util.isUndefinedOrNull(records.conObj.Account.LastName) &&
                            records.conObj.Account.IsPersonAccount === true ;
                        if(lNameCheck){                           
                            FUTURE_LEAD.LastName = records.conObj.Account.LastName ;
                        }else{
                            FUTURE_LEAD.LastName = "" ;
                        }
                        
                        var emailCheck =   !$A.util.isUndefinedOrNull(records.conObj.Account) &&
                            !$A.util.isUndefinedOrNull(records.conObj.Account.IsPersonAccount) &&
                            !$A.util.isUndefinedOrNull(records.conObj.Account.PersonEmail) &&
                            records.conObj.Account.IsPersonAccount === true ;
                        
                        if(emailCheck){                            
                            FUTURE_LEAD.Email = records.conObj.Account.PersonEmail ;
                        }else{
                            FUTURE_LEAD.Email = "" ;
                        }
                        
                        var phoneCheck =   !$A.util.isUndefinedOrNull(records.conObj.Account) &&
                            !$A.util.isUndefinedOrNull(records.conObj.Account.IsPersonAccount) &&
                            !$A.util.isUndefinedOrNull(records.conObj.Account.Phone) &&
                            records.conObj.Account.IsPersonAccount === true ;
                        if(phoneCheck){                           
                            FUTURE_LEAD.Phone = records.conObj.Account.Phone ;
                        }else{
                            FUTURE_LEAD.Phone = "";
                        }
                        
                        var mobileCheck = !$A.util.isUndefinedOrNull(records.conObj.Account) &&
                            !$A.util.isUndefinedOrNull(records.conObj.Account.IsPersonAccount) &&
                            !$A.util.isUndefinedOrNull(records.conObj.Account.PersonMobilePhone) &&
                            records.conObj.Account.IsPersonAccount === true ;
                        
                        if(mobileCheck){                            
                            FUTURE_LEAD.MobilePhone = records.conObj.Account.PersonMobilePhone ;
                        }else{
                            FUTURE_LEAD.MobilePhone = "";
                        }
                        
                        if(!$A.util.isUndefinedOrNull(records.conObj.MBFS_Dealer_Account__c)){                                
                            FUTURE_LEAD.MBFS_Dealer_Account__c = records.conObj.MBFS_Dealer_Account__r.Id ;
                            FUTURE_LEAD.MBFS_Dealer_Account__r = records.conObj.MBFS_Dealer_Account__r ;
                        }else{
                            FUTURE_LEAD.MBFS_Dealer_Account__c = ""; 
                            FUTURE_LEAD.MBFS_Dealer_Account__r = "";
                        }
                        
                        component.set("v.FUTURE_LEAD",FUTURE_LEAD);                       
                        this.doneWaiting(); 
                    }else{
                        this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                        this.doneWaiting();    
                    }
                }else if(state === "ERROR"){
                    this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                    this.doneWaiting();               
                }
            });
            $A.enqueueAction(action);
        }else{
            this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
            this.doneWaiting();
        }
        
    },
    newEditTaskSubmitHelper: function(component,event,jsonData) { 
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
                        
                        var cmpTarget = component.find('MBFSRTMNewTaskPopUp');
                        $A.util.removeClass(cmpTarget, 'slds-show');
                        //Team Saasfocus 12-06-2018
                        $A.util.addClass(cmpTarget, 'slds-hide');
                        
                        var assignToEvt = component.getEvent("assignToEvt");
                        assignToEvt.setParams({
                            "monthWeekFilterName" : "" ,
                            "campaignName" : component.get("v.campaignName") ,
                            "dateFilter" : component.get("v.dateFilter") ,
                            "defaultCount": component.get("v.defaultCount")
                        });
                        assignToEvt.fire(); 
                        this.clearForm(component,event);
                        this.doneWaiting();
                    }else{
                        this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                        this.doneWaiting();  
                        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:0} .forceStyle.desktop .viewport{overflow:hidden}");
                    }
                }else if(state === "ERROR"){
                    this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                    this.doneWaiting();  
                    component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:0} .forceStyle.desktop .viewport{overflow:hidden}");
                }
            });
            $A.enqueueAction(action);
        }else{
            this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
            this.doneWaiting();
        }
        
    },
    initCallHelper : function(component,event) {
        this.waiting();
        
        var pickListValuesTask = [];
        pickListValuesTask.push('MBFS_Customer_Not_Interested__c');
        pickListValuesTask.push('MBFS_Do_Not_Call__c');
        pickListValuesTask.push('MBFS_Lost_to_Competitor__c');
        
        
        var pickListValuesLead = [];
        pickListValuesLead.push('MBFS_Interested_Vehicle_category__c');
        pickListValuesLead.push('MBFS_Vehicle_Make_interest__c');
        pickListValuesLead.push('MBFS_Model_Interest__c');
        pickListValuesLead.push('MBFS_Lead_Type__c');
        
        var pickListMap = {
            Task :  pickListValuesTask,
            Lead :  pickListValuesLead 
        }
        
        var action = component.get("c.getPickListToValue");        
        action.setParams({ 
            "objectToFieldMap":JSON.stringify(pickListMap)
        }); 
        
        
        action.setCallback(this, function(response){
            var state = response.getState();  
            
            if ((state === "SUCCESS") && (component.isValid())) {                
                var responseData = response.getReturnValue(); 
                
                var isError = responseData.isError ;
                
                if(isError === false){ 
                    
                    var records = responseData.rtmPickListToValueData ;                    
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
                    this.doneWaiting();
                }else{                        
                    this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                    this.doneWaiting();
                }
            }else if(state === "ERROR"){                
                this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                this.doneWaiting();
            }
        });
        $A.enqueueAction(action);      
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
                    
                    var regExpressionNumber =  /^[0-9 ]+/ ; // /^[0-9]+$/;
                   
                    
                    if(component.get("v.MBFS_Interested_Vehicle_category_Value") === ""){
                        component.set("v.exceptionFlag",false); 
                        this.showToast(component,"error","Error!","Interested vehicle category is required"); 
                        
                        
                    }else if(component.get("v.MBFS_Vehicle_Make_interest_Value") === ""){
                        component.set("v.exceptionFlag",false); 
                        this.showToast(component,"error","Error!","Vehicle make interest is required");                         
                        
                    }else if(component.get("v.MBFS_Model_Interest_Value") === ""){
                        component.set("v.exceptionFlag",false); 
                        this.showToast(component,"error","Error!","Vehicle model interest is required");                        
                        
                    }else if((FUTURE_LEAD.FirstName).trim() === ""){
                        component.set("v.exceptionFlag",false);
                        this.showToast(component,"error","Error!","First name is required"); 
                    }else if((FUTURE_LEAD.LastName).trim() === ""){
                        component.set("v.exceptionFlag",false);
                        this.showToast(component,"error","Error!","Last name is required"); 
                    }else if(FUTURE_LEAD.Email != "" && regExpressionEmail && !regExpressionEmail.test((FUTURE_LEAD.Email).trim())){                       
                        component.set("v.exceptionFlag",false);
                        this.showToast(component,"error","Error!","Email format is not correct");                          
                    }else if(FUTURE_LEAD.Phone != "" && regExpressionNumber && !regExpressionNumber.test((FUTURE_LEAD.Phone).trim())){
                        component.set("v.exceptionFlag",false);
                        this.showToast(component,"error","Error!","Phone format is not correct");
                    }else if(FUTURE_LEAD.MobilePhone !="" && regExpressionNumber && !regExpressionNumber.test((FUTURE_LEAD.MobilePhone).trim())){
                        component.set("v.exceptionFlag",false);
                        this.showToast(component,"error","Error!","MobilePhone format is not correct");
                    }else if(MBFS_Lead_Type_Value === 'Retailer Lead' && (FUTURE_LEAD.MBFS_Dealer_Account__c).trim() ===""){
                        component.set("v.exceptionFlag",false);
                        this.showToast(component,"error","Error!","Dealer is required");
                    }else if(MBFS_Lead_Type_Value === 'Retailer Lead' && (FUTURE_LEAD.MBFS_Dealer_Account__c).trim() !==""){                        
                        component.set("v.exceptionFlag",false);
                        this.validateDealerAcc(component,event,(FUTURE_LEAD.MBFS_Dealer_Account__c).trim());
                        
                       //Finance Lead Email
                    }else if(MBFS_Lead_Type_Value === 'Finance Lead' && (FUTURE_LEAD.Email).trim() ===""){
                        component.set("v.exceptionFlag",false);
                        this.showToast(component,"error","Error!","Email is required");    
                        
                        //Finance Task                       
                    }else if(MBFS_Lead_Type_Value === 'Finance Lead' && (FINANCE_TASK.ActivityDate).trim() ===""){
                        component.set("v.exceptionFlag",false);
                        this.showToast(component,"error","Error!","Finance task due date is required");                   
                    }else{
                        component.set("v.exceptionFlag",true);  
                    }                                    
                }else if(actionName === 'FUTURE_TASK'){  
                    
                    var FUTURE_TASK = component.get("v.FUTURE_TASK");
                    if((FUTURE_TASK.Subject).trim() === ""){
                        component.set("v.exceptionFlag",false);
                        this.showToast(component,"error","Error!","Subject is mandatory"); 
                    }if((FUTURE_TASK.ActivityDate).trim() ===""){
                        component.set("v.exceptionFlag",false);
                        this.showToast(component,"error","Error!","ActivityDate is mandatory");
                    }else {
                        component.set("v.exceptionFlag",true);  
                    }   
                }else{
                    component.set("v.exceptionFlag",true); 
                }         
            }else{
                component.set("v.exceptionFlag",false);
                this.showToast(component,"error","Error!","Outcome and Suboutcome are mandatory");  
            }
        }
    },
    showToast: function(component,type,title,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({               
            "type": type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    },
    clearForm : function(component) {
        
        var WrapperData =  component.get("v.WrapperData");
        var ActivityDate = WrapperData.nextTaskDate ;
        
        component.set("v.outComeName","");
        component.set("v.subOutComeName","");
        component.set("v.subOutComeAction","");
        
        component.set("v.FUTURE_TASK.Subject","Call");
        component.set("v.FUTURE_TASK.ActivityDate",ActivityDate);
        component.set("v.FUTURE_TASK.Description","");
        component.set("v.FUTURE_LEAD.Description","");        
        
        
    },
    clearFormWithOutCome : function(component) {
        var WrapperData =  component.get("v.WrapperData");
        var ActivityDate = WrapperData.nextTaskDate ;
        
        component.set("v.subOutComeName","");
        component.set("v.subOutComeAction","");
        
        component.set("v.FUTURE_TASK.Subject","Call");
        component.set("v.FUTURE_TASK.ActivityDate",ActivityDate);
        component.set("v.FUTURE_TASK.Description","");   
        component.set("v.FUTURE_LEAD.Description","");  
        
    },
    waiting: function() {
        if(!$A.util.isUndefinedOrNull(document.getElementById("RTMspinner")))
        {
            document.getElementById("RTMspinner").style.display = "block";            
        }  
        
    },
    doneWaiting: function() {
        if(!$A.util.isUndefinedOrNull(document.getElementById("RTMspinner")))
        {
            document.getElementById("RTMspinner").style.display = "none";
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
                        this.showToast(component,"error","Error!","Dealer must be active");
                    }else{
                        component.set("v.exceptionFlag",true); 
                        this.editTaskSubmitHelper(component, event);
                    }
                }else if(state === "ERROR"){
                    this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));                                     
                }
            });
            $A.enqueueAction(action);
        }else{
            this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));        
        }
    },
    editTaskSubmitHelper: function(component, event) {
         var NewEditTaskData = component.get("v.NewEditTaskData");
         var outComeName = component.get("v.outComeName");
         var subOutComeName = component.get("v.subOutComeName");
         var subOutComeAction = component.get("v.subOutComeAction");      
         
         var campaignName = component.get("v.campaignName");      
         var selectedContractID = component.get("v.selectedContractID");
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
             
             this.newEditTaskSubmitHelper(component, event,JSON.stringify(wrapperObj));
             component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:5} .forceStyle.desktop .viewport{overflow:visible}");
        }
    }
})