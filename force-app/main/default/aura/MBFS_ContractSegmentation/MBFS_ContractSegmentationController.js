({
    doInit : function(component, event, helper) {
       
        var MBSF_CAMPAIGN = component.find('MBSF_CAMPAIGN');
        var MBSF_LEAD = component.find('MBSF_LEAD');        

        $A.util.addClass(MBSF_CAMPAIGN, 'Active');
        $A.util.removeClass(MBSF_LEAD, 'Active');
        
       
        var campaignName = component.get("v.campaignName");
        var assigneeName = component.get("v.assigneeName") ;
        var agilityName = component.get("v.agilityName") ; 
        var residualValue = component.get("v.residualValue") ;
        var vehicleMakeInterest = component.get("v.vehicleMakeInterest");
        var globalFilter = component.get("v.globalFilter");
        
        helper.loadData(component,event,campaignName,assigneeName,agilityName,residualValue,vehicleMakeInterest,globalFilter);
    },
    onMonthWeekFilterChange : function(component, event, helper) {
       
        var assigneeName = component.get("v.assigneeName") ;
        var agilityName = component.get("v.agilityName") ; 
        var residualValue = component.get("v.residualValue");
        var vehicleMakeInterest = component.get("v.vehicleMakeInterest");
        var globalFilter = component.get("v.globalFilter");
        
        var checkParameter =   !$A.util.isUndefinedOrNull(assigneeName)
                               && !$A.util.isUndefinedOrNull(agilityName)
                               && !$A.util.isUndefinedOrNull(globalFilter) ;
        if(checkParameter) 
        {            
        	helper.filterChange(component,event,"",assigneeName,agilityName,residualValue,vehicleMakeInterest,globalFilter);
        }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }
    },
    onAssigneeChange : function(component, event, helper) {
       
        var assigneeName = component.get("v.assigneeName") ;
        var agilityName = component.get("v.agilityName") ;
        var campaignName = component.get("v.campaignName");
        var residualValue = component.get("v.residualValue");
        var vehicleMakeInterest = component.get("v.vehicleMakeInterest");
        var globalFilter = component.get("v.globalFilter");
        
        var checkParameter =   !$A.util.isUndefinedOrNull(assigneeName)
                               && !$A.util.isUndefinedOrNull(agilityName)
                               && !$A.util.isUndefinedOrNull(campaignName)
                               && !$A.util.isUndefinedOrNull(residualValue)
                               && !$A.util.isUndefinedOrNull(vehicleMakeInterest)
                               && !$A.util.isUndefinedOrNull(globalFilter) ;
        if(checkParameter) 
        {       
           helper.filterChange(component,event,campaignName,assigneeName,agilityName,residualValue,vehicleMakeInterest,globalFilter);
        }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }
    },
    onAgilityChange : function(component, event, helper) {
       
        var assigneeName = component.get("v.assigneeName") ;
        var agilityName = component.get("v.agilityName") ;
        var campaignName = component.get("v.campaignName");
        var residualValue = component.get("v.residualValue");
        var vehicleMakeInterest = component.get("v.vehicleMakeInterest");
        var globalFilter = component.get("v.globalFilter");
        
        var checkParameter =  !$A.util.isUndefinedOrNull(assigneeName)
                               && !$A.util.isUndefinedOrNull(agilityName)
                               && !$A.util.isUndefinedOrNull(campaignName)
                               && !$A.util.isUndefinedOrNull(residualValue)
                               && !$A.util.isUndefinedOrNull(vehicleMakeInterest)
                               && !$A.util.isUndefinedOrNull(globalFilter) ;
        if(checkParameter) 
        {   
        	helper.filterChange(component,event,campaignName,assigneeName,agilityName,residualValue,vehicleMakeInterest,globalFilter);
        }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }
    },
    onResidualChange: function(component, event, helper) {
       
        var assigneeName = component.get("v.assigneeName") ;
        var agilityName = component.get("v.agilityName") ;
        var campaignName = component.get("v.campaignName");
        var residualValue = component.get("v.residualValue");
        var vehicleMakeInterest = component.get("v.vehicleMakeInterest");
        var globalFilter = component.get("v.globalFilter");
        
        var checkParameter =   !$A.util.isUndefinedOrNull(assigneeName)
                               && !$A.util.isUndefinedOrNull(agilityName)
                               && !$A.util.isUndefinedOrNull(campaignName)
                               && !$A.util.isUndefinedOrNull(residualValue)
                               && !$A.util.isUndefinedOrNull(vehicleMakeInterest)
                               && !$A.util.isUndefinedOrNull(globalFilter) ;
        if(checkParameter) 
        {   
        	helper.filterChange(component,event,campaignName,assigneeName,agilityName,residualValue,vehicleMakeInterest,globalFilter);
        }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }
    },
     onVehicleMakeInterestChange: function(component, event, helper) {

                var assigneeName = component.get("v.assigneeName") ;
                var agilityName = component.get("v.agilityName") ;
                var campaignName = component.get("v.campaignName");
                var residualValue = component.get("v.residualValue");
                var vehicleMakeInterest = component.get("v.vehicleMakeInterest");
                var globalFilter = component.get("v.globalFilter");

                var checkParameter =   !$A.util.isUndefinedOrNull(assigneeName)
                                       && !$A.util.isUndefinedOrNull(agilityName)
                                       && !$A.util.isUndefinedOrNull(campaignName)
                                       && !$A.util.isUndefinedOrNull(residualValue)
                                       && !$A.util.isUndefinedOrNull(vehicleMakeInterest)
                                       && !$A.util.isUndefinedOrNull(globalFilter) ;
                if(checkParameter)
                {
                    helper.filterChange(component,event,campaignName,assigneeName,agilityName,residualValue,vehicleMakeInterest,globalFilter);
                }else {
                    helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
                }
            },

    onCampaignFilterChange : function(component, event, helper) {
        var campaignName = component.get("v.campaignName") ;
        var assigneeName = component.get("v.assigneeName") ;
        var agilityName = component.get("v.agilityName") ; 
        var residualValue = component.get("v.residualValue");
        var vehicleMakeInterest = component.get("v.vehicleMakeInterest");
        var globalFilter = component.get("v.globalFilter");
        
        var checkParameter =   !$A.util.isUndefinedOrNull(assigneeName)
                               && !$A.util.isUndefinedOrNull(agilityName)
                               && !$A.util.isUndefinedOrNull(campaignName)
                               && !$A.util.isUndefinedOrNull(residualValue)
                               && !$A.util.isUndefinedOrNull(vehicleMakeInterest)
                               && !$A.util.isUndefinedOrNull(globalFilter) ;
        if(checkParameter) 
        {              
        	helper.filterChange(component,event,campaignName,assigneeName,agilityName,residualValue,vehicleMakeInterest,globalFilter);
        }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }
    },
    onCampaignClick : function(component, event, helper) {
        var apiName   = event.target.value; 
              
        if(!$A.util.isUndefinedOrNull(apiName)){
            component.set("v.defaultCount",25);          
            component.set("v.globalFilter",apiName);
            component.set("v.campaignName","All");
            component.set("v.assigneeName","All");
            component.set("v.agilityName","All");
            component.set("v.residualValue","All");
            component.set("v.vehicleMakeInterest","All")
            
                                 
            var MBSF_CAMPAIGN = component.find('MBSF_CAMPAIGN');
            var MBSF_LEAD = component.find('MBSF_LEAD');        
           
            $A.util.addClass(MBSF_CAMPAIGN, 'Active');
            $A.util.removeClass(MBSF_LEAD, 'Active');  
            
            
            var campaignName = component.get("v.campaignName");
            var assigneeName = component.get("v.assigneeName") ;
            var agilityName = component.get("v.agilityName") ; 
            var residualValue = component.get("v.residualValue");
            var vehicleMakeInterest = component.get("v.vehicleMakeInterest")
            var globalFilter = component.get("v.globalFilter");
            
            
            helper.loadData(component,event,campaignName,assigneeName,agilityName,residualValue,vehicleMakeInterest,globalFilter);
        }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }   
    },

    onLeadclick: function(component, event, helper) {
        var apiName   = event.target.value;  
        if(!$A.util.isUndefinedOrNull(apiName)){
            
            component.set("v.defaultCount",25);         
            component.set("v.globalFilter",apiName);
            component.set("v.campaignName","All");
            component.set("v.assigneeName","All");
            component.set("v.agilityName","All");
            component.set("v.residualValue","All");
            component.set("v.vehicleMakeInterest","All")
                     
            var MBSF_CAMPAIGN = component.find('MBSF_CAMPAIGN');
            var MBSF_LEAD = component.find('MBSF_LEAD');        
           
            $A.util.removeClass(MBSF_CAMPAIGN, 'Active');
            $A.util.addClass(MBSF_LEAD, 'Active');
            
            
            var campaignName = component.get("v.campaignName");
            var assigneeName = component.get("v.assigneeName") ;
            var agilityName = component.get("v.agilityName") ; 
            var residualValue = component.get("v.residualValue");
            var vehicleMakeInterest = component.get("v.vehicleMakeInterest");
            var globalFilter = component.get("v.globalFilter");
            
            helper.loadData(component,event,campaignName,assigneeName,agilityName,residualValue,vehicleMakeInterest,globalFilter);
        }else {
            helper.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }      
    },
    handleComponentEvent: function(component, event, helper) {       
         var globalFilter = event.getParam("globalFilter");
         helper.onAssignSuccess(component, event,globalFilter);       
    },
    
})