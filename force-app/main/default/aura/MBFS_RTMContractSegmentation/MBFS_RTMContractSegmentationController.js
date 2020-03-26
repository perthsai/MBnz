({
    doInit : function(component, event, helper) {              
        var campaignName = component.get("v.campaignName");
        var dateFilter   = component.get("v.dateFilter");
        
        helper.loadData(component, event,"",campaignName,dateFilter);
    },
    onMonthWeekFilterChange : function(component, event, helper) {
       
        var campaignName = component.get("v.campaignName");
        var dateFilter   = component.get("v.dateFilter");
        
        helper.onFilterChangeHelper(component, event,"",campaignName,dateFilter);
    },
    onCampaignFilterChange : function(component, event, helper) {
        
        var campaignName = component.get("v.campaignName");
        var dateFilter   = component.get("v.dateFilter");
        
        helper.onFilterChangeHelper(component, event,"",campaignName,dateFilter);
    },
    onDateFilterChange : function(component, event, helper) {
        
        var campaignName = component.get("v.campaignName");
        var dateFilter   = component.get("v.dateFilter");
        
        helper.onFilterChangeHelper(component, event,"",campaignName,dateFilter);
    },
    handleComponentEvent: function(component, event, helper) {         
         var campaignName = event.getParam("campaignName");
         var dateFilter = event.getParam("dateFilter");
         var defaultCount = event.getParam("defaultCount");
         component.set("v.defaultCount",defaultCount);
        
         helper.onFilterChangeHelper(component, event,"",campaignName,dateFilter);
         
    }
})