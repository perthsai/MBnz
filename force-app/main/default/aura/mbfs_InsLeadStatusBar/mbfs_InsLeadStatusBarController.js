({
	doInit : function(component, event, helper)
    {
        var leadId  = component.get("v.recordId");
        helper.loadStatusBarData(component, event, helper,'Lead','Insurance_Lead_Status__c',null,leadId);
	},
    updateStatus : function(component,event,helper)
    {
        var newStatus = event.currentTarget.id;
        var objLead   = component.get("v.objLead");
        component.set("v.currentStatus",newStatus);
        if (newStatus === 'Lost' && objLead.Status !== 'Lost')
        {
            component.set("v.OpenSoldPopUp",true);
        }
        else if(objLead.Status === 'Lost')
        {
            helper.showToast(component, event, helper,
                             'Lead is already lost','Error');
        }
        else if (newStatus === 'Policy Sold' && objLead.Status !== 'Policy Sold')
        {
            component.set("v.OpenSoldPopUp",true);
        }        
        else if(objLead.Status === 'Policy Sold')
        {
            helper.showToast(component, event, helper,
                             'Lead is already Policy sold','Error');
        }
        else if(newStatus !== 'Lost' && newStatus !== 'Policy Sold')
        {
            helper.updateLeadStatus(component,event,helper,newStatus);
        }
    },
    onConfirmation:function(component,event,helper)
    {
        var newStatus = component.get("v.currentStatus");
        var objLead   = component.get("v.objLead");
        if((objLead.MBFS_Sold_Items__c !== null && objLead.MBFS_Sold_Items__c !== '' && newStatus === 'Delivered'))
        {

        	helper.updateLeadValues(component,event,helper,'Delivered',objLead);
        }
        if((objLead.Close_Reason_Insurance__c !== null && objLead.Close_Reason_Insurance__c !== '' && newStatus === 'Lost'))
        {
            	objLead.MBFS_Closing_reason__c = objLead.Close_Reason_Insurance__c;

        	helper.updateLeadValues(component,event,helper,'Lost',objLead);
        }        
        else if((objLead.Underwriter__c !== null && objLead.Underwriter__c !== '' && objLead.Premium__c !== null && objLead.Premium__c !== '' && objLead.Policy_Number__c !== null && objLead.Policy_Number__c !== '' && newStatus === 'Policy Sold'))
        {

        	helper.updateLeadValues(component,event,helper,'Policy Sold',objLead);
        }
        else
        {
            component.set("v.errorMsg", "Required Field");
            return;
        }
    },
    closeModal : function(component)
    {
	    component.set("v.OpenSoldPopUp",false);
        component.set("v.CommentPopUp",false);
        $A.get('e.force:refreshView').fire();
	},
})