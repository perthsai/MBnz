({
	doInIT : function(component, event, helper) {
        var params = event.getParam('arguments');
        if(!$A.util.isUndefinedOrNull(params) && !$A.util.isUndefinedOrNull(params.WrapperData))
        {
            var records =  params.WrapperData;
            component.set("v.selectAllCheckBox", false);
            component.set("v.WrapperData",records);           
            helper.loadData(component);                       
        }else {
            helper.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false"); 
        }    
    },
    firstPage: function(component) {
        component.set("v.pageNumber", 1);
    },
    prevPage: function(component, event, helper) {
        if(!$A.util.isUndefinedOrNull(component.get("v.pageNumber"))){
            component.set("v.pageNumber", Math.max(component.get("v.pageNumber")-1, 1)); 
        }else {
            helper.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false");  
        }             
    },
    nextPage: function(component, event, helper) { 
        if(!$A.util.isUndefinedOrNull(component.get("v.AllAccountList")) 
           && !$A.util.isUndefinedOrNull(component.get("v.defaultCount"))){
            
            var total = +component.get("v.AllAccountList").length + +component.get("v.defaultCount") ;              
            helper.loadMoreData(component,event,total);
            
        }else {
            helper.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false"); 
        }    
    },
    lastPage: function(component, event, helper) {
         if(!$A.util.isUndefinedOrNull(component.get("v.AllAccountList")) 
           && !$A.util.isUndefinedOrNull(component.get("v.totalNoOfrecord"))) {
             
           helper.loadLast(component,event,component.get("v.totalNoOfrecord"));
           
         }else {
            helper.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false"); 
         }        
    },
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },
    sortField : function(component, event, helper) {   
        component.set("v.selectAllCheckBox", false);
        if(!$A.util.isUndefinedOrNull(component.get("v.sortAsc"))
          && !$A.util.isUndefinedOrNull(component.get("v.sortField"))) {
           
            var sortAsc = component.get("v.sortAsc");
            var sortField = component.get("v.sortField");
            var apiName   = event.currentTarget.id;  
            
            sortAsc = sortField !== apiName || !sortAsc;
            component.set("v.sortAsc", sortAsc);
            component.set("v.sortField", apiName);      
            helper.updateViewHelper(component, event,apiName,sortAsc);
            
        }else {
            helper.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false"); 
        }    
        
    },
    selectAllCheckBox : function(component, event, helper) {
        helper.selectAllCheckBoxHelper(component, event);
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
            helper.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false"); 
        }    
    },
    onDefaultCountChange : function(component, event, helper) {   
        component.set("v.selectAllCheckBox", false);
        var sortAsc = component.get("v.sortAsc");
        var sortField = component.get("v.sortField");
        if(!$A.util.isUndefinedOrNull(sortAsc) && !$A.util.isUndefinedOrNull(sortField)) 
        {            
            helper.updateViewHelper(component, event,sortField,sortAsc);
        }else {
            helper.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false"); 
        }
    },
    onCampaignChange : function(component, event, helper) {
        var campaignId = component.get("v.campaignId") ;
        var WrapperData = component.get("v.WrapperData");
        if(!$A.util.isUndefinedOrNull(WrapperData) && 
           !$A.util.isUndefinedOrNull(campaignId)) 
        {   
            var selectedItemCount = 0 ;        
            WrapperData.resultSet.rows.forEach(function(entry) {
                if(entry.isSelected === true){
                    selectedItemCount = selectedItemCount + 1 ;
                }
            });
            if(selectedItemCount > 0){
               helper.onCampaignChangeHelper(component, event ,campaignId ,WrapperData);
            }else{
               helper.showToast(component,"true","Please select at least one record. ","true","false"); 
            }  
        }else {
            helper.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false"); 
        }      
    },
})