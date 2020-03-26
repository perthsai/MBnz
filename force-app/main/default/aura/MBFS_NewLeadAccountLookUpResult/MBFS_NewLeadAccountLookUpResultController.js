({
	selectAccount : function(component, event, helper){      
        
        var getSelectAccount = component.get("v.oAccount");
        var accountId = component.get("v.accountId");
        
        var compEvent = component.getEvent("oSelectedAccountEvent");
        
        compEvent.setParams({"accountByEvent" : getSelectAccount ,"accountId":accountId});  
        
        compEvent.fire();
    },
})