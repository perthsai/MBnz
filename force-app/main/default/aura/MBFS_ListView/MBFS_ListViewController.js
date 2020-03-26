({
    initCall: function(component, event, helper) {        
        helper.initCallHelper(component);   
    },
    doInIT : function(component, event, helper) {
        var params = event.getParam('arguments');
        
        var checkParameter =   !$A.util.isUndefinedOrNull(params) 
                               && !$A.util.isUndefinedOrNull(params.WrapperData)
                               && !$A.util.isUndefinedOrNull(params.assigneeName)
                               && !$A.util.isUndefinedOrNull(params.agilityName)
                               && !$A.util.isUndefinedOrNull(params.campaignName)
                               && !$A.util.isUndefinedOrNull(params.residualValue)
                               && !$A.util.isUndefinedOrNull(params.vehicleMakeInterest)
                               && !$A.util.isUndefinedOrNull(params.globalFilter) ;
        
        if(checkParameter){           
            var records =  params.WrapperData;
            component.set("v.selectAllCheckBox", false);
            component.set("v.WrapperData",records);
            component.set("v.assigneeName",params.assigneeName);
            component.set("v.agilityName",params.agilityName);
            component.set("v.campaignName",params.campaignName);
            component.set("v.residualValue",params.residualValue);
            component.set("v.vehicleMakeInterest",params.vehicleMakeInterest);
            component.set("v.globalFilter",params.globalFilter);
            
            helper.loadData(component);
        }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }    
    },
    firstPage: function(component, event, helper) {
        component.set("v.pageNumber", 1);
    },
    prevPage: function(component, event, helper) {
        if(!$A.util.isUndefinedOrNull(component.get("v.pageNumber"))){
            component.set("v.pageNumber", Math.max(component.get("v.pageNumber")-1, 1)); 
        }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }             
    },
    nextPage: function(component, event, helper) { 
        if(!$A.util.isUndefinedOrNull(component.get("v.AllAccountList")) 
           && !$A.util.isUndefinedOrNull(component.get("v.defaultCount"))){
            
            var total = +component.get("v.AllAccountList").length + +component.get("v.defaultCount") ;
            helper.loadMoreData(component,component.get("v.AllAccountList").length,total);
            
        }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }    
    },
    lastPage: function(component, event, helper) {
         if(!$A.util.isUndefinedOrNull(component.get("v.AllAccountList")) 
           && !$A.util.isUndefinedOrNull(component.get("v.totalNoOfrecord"))) {
             
           helper.loadLast(component,component.get("v.AllAccountList").length,component.get("v.totalNoOfrecord"));          
         
         }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
         }        
    },
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },
    sortField : function(component, event, helper) {   
        component.set("v.selectAllCheckBox", false);
        
        var checkParameter = !$A.util.isUndefinedOrNull(component.get("v.sortAsc"))
                              && !$A.util.isUndefinedOrNull(component.get("v.sortField"))
                              && !$A.util.isUndefinedOrNull(event.currentTarget.id) ;
        
        if(checkParameter) {
           
            var sortAsc = component.get("v.sortAsc");
            var sortField = component.get("v.sortField");
            var apiName   = event.currentTarget.id;  
           
            sortAsc = sortField !== apiName || !sortAsc;
            component.set("v.sortAsc", sortAsc);
            component.set("v.sortField", apiName);      
            helper.sortData(component,apiName,sortAsc);
        }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }    
        
    },
    selectAllCheckBox : function(component, event, helper) {
        helper.selectAllCheckBoxHelper(component);
    },
    changeCheckBox: function(component, event, helper) {   
        var selectedRecordCount = component.get("v.selectedRecordCount");
        var checkbox = event.getSource();
        
        if(!$A.util.isUndefinedOrNull(selectedRecordCount) && !$A.util.isUndefinedOrNull(checkbox)) 
        {       
            if(checkbox.get("v.value") === true){
                selectedRecordCount = selectedRecordCount + 1 ; 
            }else{
                selectedRecordCount = selectedRecordCount - 1 ; 
            }        
            component.set("v.selectedRecordCount",selectedRecordCount);
        }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }    
    },
    onAssignedToClick: function(component, event, helper) {
        var WrapperData = component.get("v.WrapperData");
        if(!$A.util.isUndefinedOrNull(WrapperData)) 
        {   
            var selectedItemCount = 0 ;        
            WrapperData.resultSet.rows.forEach(function(entry) {
                if(entry.isSelected === true){
                    selectedItemCount = selectedItemCount + 1 ;
                }
            });
            if(selectedItemCount > 0){
                var cmpTarget = component.find('dialogBoxOpen');
                $A.util.addClass(cmpTarget, 'slds-show');
                //TeamSaasFocus 12-06-2018
                $A.util.removeClass(cmpTarget, 'slds-hide');
                
            }else{
               
                helper.showToast("error","Error!","Please select at least one record.");
            }  
        }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }         
    },
    hideModal: function(component, event, helper) {
        var cmpTarget = component.find('dialogBoxOpen');
        $A.util.removeClass(cmpTarget, 'slds-show'); 
        $A.util.addClass(cmpTarget, 'slds-hide');
        
        var notCallPopUp = component.find('notCallPopUp');
        $A.util.removeClass(notCallPopUp, 'slds-show');
        $A.util.addClass(notCallPopUp, 'slds-hide');
    },
    onAssignedToSubmit: function(component, event, helper) {
        var assignToUserId =  component.get("v.assignToUserId");
        var globalFilter = component.get("v.globalFilter");
        if(!$A.util.isUndefinedOrNull(assignToUserId) 
           && !$A.util.isUndefinedOrNull(globalFilter)) 
        {       
            if(assignToUserId !== ""){
                helper.changeOwner(component,assignToUserId ,globalFilter);
            }else{
                helper.showToast("error","Error!","Please select a user.");
            }
        }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        } 
    },
    onDefaultCountChange : function(component, event, helper) {   
        component.set("v.selectAllCheckBox", false);
        var sortAsc = component.get("v.sortAsc");
        var sortField = component.get("v.sortField");
        if(!$A.util.isUndefinedOrNull(sortAsc) && !$A.util.isUndefinedOrNull(sortField)) 
        {           
            helper.sortData(component,sortField,sortAsc);
        }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }
    },
    onNotCallClick: function(component, event, helper) {
        var WrapperData = component.get("v.WrapperData");
        if(!$A.util.isUndefinedOrNull(WrapperData)) 
        {   
            var selectedItemCount = 0 ;        
            WrapperData.resultSet.rows.forEach(function(entry) {
                if(entry.isSelected === true){
                    selectedItemCount = selectedItemCount + 1 ;
                }
            });
            if(selectedItemCount > 0){
                var cmpTarget = component.find('notCallPopUp');
                $A.util.addClass(cmpTarget, 'slds-show');
                //TeamSaasFocus 12-06-2018
                $A.util.removeClass(cmpTarget, 'slds-hide');
            }else{
                helper.showToast("error","Error!","Please select at least one record.");
            }  
        }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        } 
    },
    onNotCallSubmit: function(component, event, helper) {
        var subOutCome = component.get("v.subOutCome");
        var globalFilter = component.get("v.globalFilter");
        var OutCome = component.get("v.OutCome");
        
        var checkParameter =   !$A.util.isUndefinedOrNull(subOutCome) && 
                               !$A.util.isUndefinedOrNull(globalFilter) &&
                               !$A.util.isUndefinedOrNull(OutCome) ;
        
        if(checkParameter) 
        {              
            helper.onNotCallSubmitHelper(component,OutCome,subOutCome,globalFilter);
        }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        } 
    },
})