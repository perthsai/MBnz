({
    closeMessage : function(component, event, helper) {
        component.set("v.open", false);
        component.set("v.ShowSaveMeassage", false);
        component.set("v.ShowErrorMessage", false);
    },
    /*
     * Automatically close toaster winow after 
     * a some time interval
     */
    OnInitCloseTost : function(component,event,helper)
    {
        window.setTimeout(
            $A.getCallback(function() {
                if (component.isValid()) {
                    component.set("v.open", false);
                    component.set("v.ShowSaveMeassage", false);
                    component.set("v.ShowErrorMessage", false);
                }
            }), 2000
        );
    }
})