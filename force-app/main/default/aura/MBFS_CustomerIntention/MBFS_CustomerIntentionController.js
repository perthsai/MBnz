({
    doInit: function(component,event ,helper) {            
        if(!$A.util.isUndefinedOrNull(component.get("v.recordId")) 
           && component.get("v.recordId") !== "")
        {
            
            var MBFSCIPOPUP = component.find('MBFSCIPOPUP');
            $A.util.removeClass(MBFSCIPOPUP, 'slds-fade-in-open');   
            $A.util.removeClass(MBFSCIPOPUP, 'slds-modal'); 
            
            var MBFS_BACKGROUND = component.find('MBFS_BACKGROUND');
            $A.util.removeClass(MBFS_BACKGROUND, 'slds-backdrop slds-backdrop_open'); 
            
            var MBFS_Container_Width = component.find('MBFS_Container_Width');
            $A.util.addClass(MBFS_Container_Width, 'CustomerIntention'); 
            
            helper.onInItHelper(component);
        }
        
    },
    setRecordId: function(component,event ,helper) {  
        var params = event.getParam('arguments');
        component.set("v.recordId",params.recordId);
        component.set("v.isVisible",params.isVisible);
        
        component.set("v.fromRTM",true);
        
        var MBFS_Container_Width = component.find('MBFS_Container_Width');
        $A.util.addClass(MBFS_Container_Width, 'RTMIntention'); 
        
        helper.onInItHelper(component);
    },
    onOptionChange: function(component, event, helper) {            
        var WrapperData  = component.get("v.WrapperData");
        var optionToSubOptionMap = WrapperData.optionToSubOptionMap;
        
        var optionValue = component.get("v.WrapperData.customerIntentionObj.MBFS_Option__c");
         
        var SubOutComeList = [];
        if(optionValue !== ""){
            for (var key in optionToSubOptionMap) {           
                if(key === optionValue){
                    SubOutComeList = optionToSubOptionMap[key];                  
                    break ;
                }
            }  
            component.set("v.WrapperData.customerIntentionObj.MBFS_Sub_Option__c",SubOutComeList[0]);
        }else{
           SubOutComeList.push("--None--"); 
        }        
        component.set("v.subOptionList",SubOutComeList);
        
    },
    hideModal: function(component, event, helper) { 
        helper.hideModalHelper(component);
        
    },
    onUserIntentionSubmit: function(component,event,helper) { 
        helper.validateForm(component);
        if(component.get("v.isValiadtionFail") === false ){
            //if (confirm("Do you want to save this record") == true) {
                helper.onUserIntentionSubmitHelper(component);
            //}
        }
    }
})