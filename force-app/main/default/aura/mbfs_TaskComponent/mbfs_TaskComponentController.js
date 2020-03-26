({
	doInit : function(component, event, helper) {
		component.showTaskMethod();
	},
    showTask:function(component,event,helper){
        var action=component.get("c.getTasksMethod");
        action.setParams({
            "filter":component.get("v.filterCond")
        });
        action.setCallback(this,function(response){
            component.set("v.Task",response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    gotoURL : function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToSObject");
        urlEvent.setParams({
          "recordId": event.target.id
        });
		urlEvent.fire();
	}
})