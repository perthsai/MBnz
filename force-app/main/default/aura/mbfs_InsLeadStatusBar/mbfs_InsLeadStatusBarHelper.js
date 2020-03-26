({
    STAGECSS : ["current","complete","incomplete","Lost"],

	loadStatusBarData : function(component, event, helper,objectName,fieldName,firstValue,leadId) {
		var action = component.get("c.getData");
        action.setParams({"object_name":objectName,
                          "field_name" : fieldName,
                          "first_value":firstValue,
                          "leadId" : leadId});
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var result = response.getReturnValue();
                if(result)
                {
                    component.set("v.objResult",result);
                    component.set("v.objLead",result.objLead);
                    this.setStatusDetail(component, event, helper,
                                         result.lstPicklistValue);
                }
            }
            else if(state === 'ERROR')
            {
                var errors = response.getError();
                if (!$A.util.isUndefined(errors) && errors[0] && errors[0].message) {

                    this.showToast(component, event, helper,$A.get("$Label.c.MBFS_ParameterIsNull"),'Error');
                }
            }
        });
        $A.enqueueAction(action);
	},

    setStatusDetail : function(component, event, helper,lstLeadStatus) {
		var objLead            = component.get("v.objLead");
        if(objLead !== undefined)
        {
            var currentStatus      = objLead.Status;
            var completedStatus    = objLead.MBFS_Completed_Status__c;
            var lstCompletedStatus = [];
            if(completedStatus)
                lstCompletedStatus = completedStatus.split(",");

            var lstStatus          = [];
            for(var count=0;count < lstLeadStatus.length;count++)
            {
                var mapStatus = {"statusName" : "","statusStage" : ""};
                for(var index=0;index < lstCompletedStatus.length;index++)
                {
                    if(lstLeadStatus[count] === lstCompletedStatus[index] &&
                       lstCompletedStatus[index] !== currentStatus)
                    {
                        mapStatus.statusName = lstLeadStatus[count];
                        mapStatus.statusStage = this.STAGECSS[1];
                    }
                }
                if(mapStatus.statusName === "")
                {
                    if(lstLeadStatus[count] === currentStatus)
                    {
                        mapStatus.statusName = lstLeadStatus[count];
                        mapStatus.statusStage = this.STAGECSS[0];
                    }
                    else if(lstLeadStatus[count] === this.STAGECSS[3])
                    {
                        mapStatus.statusName = lstLeadStatus[count];
                        mapStatus.statusStage = this.STAGECSS[3];
                    }
                    else
                    {
                        mapStatus.statusName = lstLeadStatus[count];
                        mapStatus.statusStage = this.STAGECSS[2];
                    }
                }
                lstStatus.push(mapStatus);
            }
            component.set("v.leadStatusValues",lstStatus);
        }
	},

    updateLeadStatus : function(component,event,helper,newStatus)
    {
        var action  = component.get("c.updateLeadStatus");
        var leadId  = component.get("v.recordId");
        action.setParams({"leadId":leadId, "newStatus" : newStatus});
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
               this.updateStageNamedetails(component, event, helper,newStatus);
               this.refreshView(component, event, helper);
            }
            else if(state === 'ERROR')
            {
                var errors = response.getError();
                if (!$A.util.isUndefined(errors) && errors[0] && errors[0].message) {

                    this.showToast(component, event, helper,$A.get("$Label.c.MBFS_ParameterIsNull"),'Error');
                }
            }
        });
        $A.enqueueAction(action);
    },
    updateLeadValues : function(component,event,helper,newStatus,objLead)
    {
    	var action  = component.get("c.updateLead");
    	objLead.Status = newStatus;
        action.setParams({"objLead":objLead});
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
               this.updateStageNamedetails(component, event, helper,'Sold');
               this.refreshView(component, event, helper);
            }
            else if(state === 'ERROR')
            {
                var errors = response.getError();
                if (!$A.util.isUndefined(errors) && errors[0] && errors[0].message) {

                    this.showToast(component, event, helper,$A.get("$Label.c.MBFS_ParameterIsNull"),'Error');
                }
            }
        });
        $A.enqueueAction(action);
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
    refreshView:function(component, event, helper){
        $A.get('e.force:refreshView').fire();
    },

    updateStageNamedetails : function (component, event, helper,selectedStage){
    	var lstStatusDetail = [];
        lstStatusDetail = component.get("v.leadStatusValues");
        for(var countstatus = 0;countstatus < lstStatusDetail.length;countstatus++)
        {
            if(lstStatusDetail[countstatus].statusStage === this.STAGECSS[0])
            {
                lstStatusDetail[countstatus].statusStage = this.STAGECSS[1];
            }
            if(lstStatusDetail[countstatus].statusName === selectedStage)
            {
                lstStatusDetail[countstatus].statusStage = this.STAGECSS[0];
                lstStatusDetail[countstatus].statusName   = selectedStage;
            }
        }
        component.set("v.leadStatusValues",lstStatusDetail);
    },
})