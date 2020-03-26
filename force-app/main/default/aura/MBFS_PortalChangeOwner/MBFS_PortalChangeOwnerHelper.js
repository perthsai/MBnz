({
    initCallHelper : function(component, event) {
        
        if(!$A.util.isUndefinedOrNull(component.get("v.recordId")))
        { 
            this.waiting();
            var action = component.get("c.onLoadCall");        
            action.setParams({ 
                "leadId":component.get("v.recordId")
            }); 
            
            action.setCallback(this, function(response){
                var state = response.getState();
                
                if ((state === "SUCCESS") && (component.isValid())) { 
                    var responseData = response.getReturnValue(); 
                    
                    var isError = responseData.isError ;                    
                    if(isError === false){ 
                        component.set("v.UserIdToName",responseData.userIdToName);
                       
                        component.set("v.SelectedUser",responseData.userIdToName[0].userId);
                        this.doneWaiting();
                    }else{                        
                        this.showToast(component, event, helper,$A.get("$Label.c.MBFS_ParameterIsNull"),'Error');
                        this.doneWaiting();
                    }
                }else if(state === "ERROR"){                
                    this.showToast(component, event, helper,$A.get("$Label.c.MBFS_ParameterIsNull"),'Error');
                    this.doneWaiting();
                }               
            });
            $A.enqueueAction(action); 
        }
    },
    onChangeOwnerSubmitHelper : function(component, event) {
        if(!$A.util.isUndefinedOrNull(component.get("v.recordId")) && 
           !$A.util.isUndefinedOrNull(component.get("v.SelectedUser")))
        {
            this.waiting();
            var action = component.get("c.changeOwner");        
            action.setParams({ 
                "leadId":component.get("v.recordId"),
                "ownerId":component.get("v.SelectedUser")
            }); 
            
            action.setCallback(this, function(response){
                var state = response.getState();
                
                if ((state === "SUCCESS") && (component.isValid())) { 
                    var responseData = response.getReturnValue(); 
                    
                    var isError = responseData.isError ;  
                    var listId  = responseData.listId ;
                    if(isError === false){ 
                        var navEvent = $A.get("e.force:navigateToList");
                        navEvent.setParams({
                            "listViewId": listId,
                            "listViewName": null,
                            "scope": "Lead"
                        });
                        navEvent.fire(); 
                        $A.get("e.force:closeQuickAction").fire() ;
                        this.doneWaiting();
                    }else{                        
                        this.showToast(component, event, helper,$A.get("$Label.c.MBFS_ParameterIsNull"),'Error');
                        this.doneWaiting();
                    }
                }else if(state === "ERROR"){                
                    this.showToast(component, event, helper,$A.get("$Label.c.MBFS_ParameterIsNull"),'Error');
                    this.doneWaiting();
                }               
            });
            $A.enqueueAction(action); 
        }
    },
    showToast : function(component, event, helper,message,type) {        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : type,
            "title": type,
            "message": message
        });
        toastEvent.fire();
    },
    waiting: function() {
        if(!$A.util.isUndefinedOrNull(document.getElementById("PortalChanegOwnerspinner")))
        {
            document.getElementById("PortalChanegOwnerspinner").style.display = "block";            
        }         
    },
    doneWaiting: function() {
        if(!$A.util.isUndefinedOrNull(document.getElementById("PortalChanegOwnerspinner")))
        {
            document.getElementById("PortalChanegOwnerspinner").style.display = "none";
        }
    },
})