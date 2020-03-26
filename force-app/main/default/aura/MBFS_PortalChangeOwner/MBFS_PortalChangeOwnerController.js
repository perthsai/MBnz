({
	initCall : function(component, event, helper) {
        
	    helper.initCallHelper(component, event);	
	},
    onChangeOwnerSubmit : function(component, event, helper) {
        
        helper.onChangeOwnerSubmitHelper(component, event);
    },
    hideModal  : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire() ;
        $A.get('e.force:refreshView').fire();
    }
})