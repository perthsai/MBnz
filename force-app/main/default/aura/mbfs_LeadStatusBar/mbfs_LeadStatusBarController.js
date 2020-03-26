({   
	doInit : function(component, event, helper) 
    {   
        var leadId  = component.get("v.recordId");
        helper.loadStatusBarData(component, event, helper,'Lead','MBFS_Retailer_Lead_Status__c',null,leadId);
	},   
    updateStatus : function(component,event,helper)
    {
        var newStatus = event.currentTarget.id;
        var objLead   = component.get("v.objLead");
        component.set("v.currentStatus",newStatus);         
        if(((newStatus === 'Sold' && objLead.Status !== 'Sold' && objLead.Status !== 'Delivered') || 
                 (newStatus === 'Delivered' && objLead.Status !== 'Delivered')) && 
                objLead.Status !== 'Lost')
        {
            component.set("v.OpenSoldPopUp",true);
        }
        else if(objLead.Status === 'Lost')
        {
            helper.showToast(component, event, helper,
                             'Lead is already lost','Error');
        }
        else if(objLead.Status === 'Sold')
        {
            helper.showToast(component, event, helper,
                             'Lead is already sold','Error');
        }
        else if(objLead.Status === 'Delivered')
        {
            helper.showToast(component, event, helper,
                             'Lead is already delivered','Error');
        }
        else if(newStatus !== 'Sold' && newStatus !== 'Delivered')
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
        else if((objLead.MBFS_Expected_Delivery_Date__c !== null && objLead.MBFS_Expected_Delivery_Date__c !== '' && newStatus === 'Sold'))
        {
            
        	helper.updateLeadValues(component,event,helper,'Sold',objLead);
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
        $A.get('e.force:refreshView').fire(); 
	}
})