({
    initCall: function(component, event, helper) {  
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:5} .forceStyle.desktop .viewport{overflow:visible}");
        
        helper.initCallHelper(component, event);    
    },
    doInIT : function(component, event, helper) {    
        var params = event.getParam('arguments');
        
        var checkParameter =  !$A.util.isUndefinedOrNull(params) 
                               && !$A.util.isUndefinedOrNull(params.WrapperData)           
                               && !$A.util.isUndefinedOrNull(params.campaignName)
                               && !$A.util.isUndefinedOrNull(params.dateFilter) ;
        if(checkParameter){
            
            var records =  params.WrapperData;
            
            component.set("v.WrapperData",records);                      
            component.set("v.campaignName",params.campaignName);
            component.set("v.dateFilter",params.dateFilter);
            
            
            var FUTURE_TASK = component.get("v.FUTURE_TASK");
            FUTURE_TASK.ActivityDate = records.nextTaskDate ;
            component.set("v.FUTURE_TASK",FUTURE_TASK);
            
            //Finance Task
            var FINANCE_TASK = component.get("v.FINANCE_TASK");
            FINANCE_TASK.ActivityDate = records.nextTaskDate ;
            component.set("v.FINANCE_TASK",FINANCE_TASK);
            
            helper.loadData(component);
        }else {
            helper.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));  
        }    
    },
    onNewLeadCreatClick: function(component, event, helper) {
        var apiName   = event.currentTarget.id;  
        component.set("v.selectedContractID",apiName);
        var MBFSRTMNewTaskPopUp = component.find('MBFSRTMNewTaskPopUp');
        $A.util.addClass(MBFSRTMNewTaskPopUp, 'slds-show');
        //TeamSaasFocus 12-06-2018
        $A.util.removeClass(MBFSRTMNewTaskPopUp, 'slds-hide');
        
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:0} .forceStyle.desktop .viewport{overflow:hidden}");
        helper.onNewLeadCreatClickHelper(component, event,apiName);
        
    },
    hideModal: function(component, event, helper) {
        var MBFSRTMNewTaskPopUp = component.find('MBFSRTMNewTaskPopUp');
        $A.util.removeClass(MBFSRTMNewTaskPopUp, 'slds-show'); 
        //TeamSaasFocus 12-06-2018
        $A.util.addClass(MBFSRTMNewTaskPopUp, 'slds-hide');
        
        var MBFSRTMContractDetails  = component.find('MBFSRTMContractDetails');
        $A.util.removeClass(MBFSRTMContractDetails, 'slds-show');
        //TeamSaasFocus 12-06-2018
        $A.util.addClass(MBFSRTMContractDetails, 'slds-hide');
        
        helper.clearForm(component);
        
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:5} .forceStyle.desktop .viewport{overflow:visible}");
    },
    onOutComeChange: function(component, event, helper) {
        var outComeName = component.get("v.outComeName") ;
        var OutComeList = component.get("v.OutComeList");
        var SubOutComeList = [];
        for (var i = 0 ; i < OutComeList.length ; i++){
            if(OutComeList[i].key === outComeName){
                var sub =   OutComeList[i].value ;
                
                for (var j = 0 ; j < sub.length ; j++){                                
                    SubOutComeList.push({
                        key: sub[j].action,
                        value: sub[j].subOutCome
                    });
                }    
            }                          
        } 
        
        component.set("v.SubOutComeList",SubOutComeList);
        
        helper.clearFormWithOutCome(component);
       
        
    },
    onSubOutComeChange: function(component, event, helper) {
        var subOutComeName = component.get("v.subOutComeName") ;
        var SubOutComeList = component.get("v.SubOutComeList");
        var actionName = "";
        for (var i = 0 ; i < SubOutComeList.length ; i++){
            if(SubOutComeList[i].value === subOutComeName){
                actionName = SubOutComeList[i].key ;
                break ;
            }
        }
       
        component.set("v.subOutComeAction",actionName); 
    },
    newEditTaskSubmit: function(component, event, helper) {      
        
         var subOutComeAction = component.get("v.subOutComeAction");                               
         helper.validateForm(component, event,subOutComeAction);
         
         if(component.get("v.exceptionFlag") === true ){
             helper.editTaskSubmitHelper(component, event);
         }
    },
    onContractDetailsClick: function(component, event, helper) {
        var apiName   = event.currentTarget.id;  
        component.set("v.selectedContractID",apiName);
        var MBFSRTMContractDetails = component.find('MBFSRTMContractDetails');
        $A.util.addClass(MBFSRTMContractDetails, 'slds-show');
        //TeamSaasFocus 12-06-2018
        $A.util.removeClass(MBFSRTMContractDetails, 'slds-hide');
        
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:0} .forceStyle.desktop .viewport{overflow:hidden}");
        helper.onContractDetailsClickHelper(component, event,apiName);
    },
    firstPage: function(component, event, helper) {
        component.set("v.pageNumber", 1);
    },
    prevPage: function(component, event, helper) {
        if(!$A.util.isUndefinedOrNull(component.get("v.pageNumber"))){
            component.set("v.pageNumber", Math.max(component.get("v.pageNumber")-1, 1)); 
        }else {
            helper.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }             
    },
    nextPage: function(component, event, helper) { 
        if(!$A.util.isUndefinedOrNull(component.get("v.AllAccountList")) 
           && !$A.util.isUndefinedOrNull(component.get("v.defaultCount"))){
            var totalRecord = +component.get("v.AllAccountList").length + +component.get("v.defaultCount");
            helper.loadMoreData(component,event,totalRecord);
        }else {
            helper.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }    
    },
    lastPage: function(component, event, helper) {
        
        if(!$A.util.isUndefinedOrNull(component.get("v.AllAccountList")) 
           && !$A.util.isUndefinedOrNull(component.get("v.totalNoOfrecord"))) {
            helper.onLastClick(component,event,component.get("v.totalNoOfrecord"));
        }else {
            helper.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }        
    },
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },
    sortField : function(component, event, helper) {
        var defaultCount = component.get("v.defaultCount")
        
        var checkParameter  =  !$A.util.isUndefinedOrNull(component.get("v.sortAsc"))
                               && !$A.util.isUndefinedOrNull(component.get("v.sortField"))
                               && !$A.util.isUndefinedOrNull(defaultCount) ;
                            
        if(checkParameter) 
        {
            
            var sortAsc = component.get("v.sortAsc");
            var sortField = component.get("v.sortField");
            var apiName   = event.currentTarget.id;  
            
            sortAsc = sortField !== apiName || !sortAsc;
            component.set("v.sortAsc", sortAsc);
            component.set("v.sortField", apiName);      
            helper.sortData(component, event,apiName,sortAsc,defaultCount);
        }else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": $A.get("$Label.c.MBFS_ParameterIsNull")
            });
            toastEvent.fire();
        }    
        
    },  
    onDefaultCountChange : function(component, event, helper) {        
        var sortAsc = component.get("v.sortAsc");
        var sortField = component.get("v.sortField");
        var defaultCount = component.get("v.defaultCount");
        
        var checkParameter  = !$A.util.isUndefinedOrNull(sortAsc) 
                               && !$A.util.isUndefinedOrNull(sortField)
                               && !$A.util.isUndefinedOrNull(defaultCount) ;
        
        if(checkParameter) 
        {          
            helper.sortData(component, event,sortField,sortAsc,defaultCount);
        }else {
            helper.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }
    },
    onLeadTypeChange: function(component, event, helper) {
        
        let records = component.get("v.MBFS_Nature_of_LeadAll")[0] ;
             
        let MBFS_Lead_Type_Value = component.get("v.MBFS_Lead_Type_Value");
        if(MBFS_Lead_Type_Value === "Retailer Lead"){
             component.set("v.MBFS_Nature_of_Request",records.Retailer_Lead.values);   
             component.set("v.MBFS_Nature_of_Request_Value",records.Retailer_Lead.values[0]);
            
             component.set("v.MBFS_Lead_Source",records.Retailer_Source.values);   
             component.set("v.MBFS_Lead_Source_Value",records.Retailer_Source.values[0]);
            
            
        }else if(MBFS_Lead_Type_Value === "Finance Lead"){
             component.set("v.MBFS_Nature_of_Request",records.Finance_Lead.values);   
             component.set("v.MBFS_Nature_of_Request_Value",records.Finance_Lead.values[0]);
            
             component.set("v.MBFS_Lead_Source",records.Finance_Source.values);   
             component.set("v.MBFS_Lead_Source_Value",records.Finance_Source.values[0]);
            
        }else if(MBFS_Lead_Type_Value === "Insurance Lead"){
             component.set("v.MBFS_Nature_of_Request",records.Insurance_Lead.values);   
             component.set("v.MBFS_Nature_of_Request_Value",records.Insurance_Lead.values[0]);
            
             component.set("v.MBFS_Lead_Source",records.Insurance_Source.values);   
             component.set("v.MBFS_Lead_Source_Value",records.Insurance_Source.values[0]);
            
        }
    
    },
    onCustomerIntention: function(component, event, helper) {
        var MBFSRTMContractDetails  = component.find('MBFSRTMContractDetails');
        $A.util.removeClass(MBFSRTMContractDetails, 'slds-show');
        //TeamSaasFocus 12-06-2018
        $A.util.addClass(MBFSRTMContractDetails, 'slds-hide');
        
        //component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:5} .forceStyle.desktop .viewport{overflow:visible}");        
        
        var MBFSCUSTOMERINTENTIONPopUp  = component.find('MBFSCUSTOMERINTENTIONPopUp');
        $A.util.addClass(MBFSCUSTOMERINTENTIONPopUp, 'slds-show');
        //TeamSaasFocus 12-06-2018
        $A.util.removeClass(MBFSCUSTOMERINTENTIONPopUp, 'slds-hide');
       
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:0} .forceStyle.desktop .viewport{overflow:hidden}");
        
        var MBFS_CustomerIntention = component.find('MBFS_CustomerIntention');               
        MBFS_CustomerIntention.setRecordId(component.get("v.selectedContractID"),true);  
        
        
    },
    onDetailEditTask: function(component, event, helper) {
        
        var apiName = component.get("v.selectedContractID") ;
        var MBFSRTMContractDetails  = component.find('MBFSRTMContractDetails');
        $A.util.removeClass(MBFSRTMContractDetails, 'slds-show');
        //TeamSaasFocus 12-06-2018
        $A.util.addClass(MBFSRTMContractDetails, 'slds-hide');
        
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:5} .forceStyle.desktop .viewport{overflow:visible}");
        
        var MBFSRTMNewTaskPopUp = component.find('MBFSRTMNewTaskPopUp');
        $A.util.addClass(MBFSRTMNewTaskPopUp, 'slds-show');
        //TeamSaasFocus 12-06-2018
        $A.util.removeClass(MBFSRTMNewTaskPopUp, 'slds-hide');
        
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index:0} .forceStyle.desktop .viewport{overflow:hidden}");
        helper.onNewLeadCreatClickHelper(component, event,apiName);
    
    }
  
})