({
    hideModalHelper: function(component) { 
        component.set("v.cssStyle", null);
        $A.get("e.force:closeQuickAction").fire(); 
        component.set("v.isVisible",false);
        component.set("v.WrapperData",null);
        component.set("v.optionList",null);
        component.set("v.subOptionList",null);    
    },
    showToast: function(component,openToast,message,isError,isSuccess) {
        component.set("v.openToast",openToast);
        component.set("v.message",message);
        component.set("v.isError",isError);
        component.set("v.isSuccess",isSuccess);
    },
    waiting: function(component) {
        if(!$A.util.isUndefinedOrNull(document.getElementById("RTHSegspinner")))
        {            
            document.getElementById("RTHSegspinner").style.display = "block";            
        }          
    },
    doneWaiting: function(component) {
        if(!$A.util.isUndefinedOrNull(document.getElementById("RTHSegspinner")))
        {
            document.getElementById("RTHSegspinner").style.display = "none";
        }
    },
    onInItHelper: function(component) {
        if(!$A.util.isUndefinedOrNull(component.get("v.recordId")))
        {   
            this.waiting(component);           
            var action = component.get("c.onLoadCall");
            action.setParams({                  
                contractId : component.get("v.recordId")
            });       
            action.setCallback(this, function(response){
                var state = response.getState();                
                if ((state === "SUCCESS") && (component.isValid())) {
                    var records = response.getReturnValue();  
                           
                    this.onInItHelperSetData(component,records);                    
                }if(state === "ERROR"){
                    this.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false"); 
                    this.doneWaiting(component); 
                }
            });
            $A.enqueueAction(action);
        }else{
            this.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false"); 
            this.doneWaiting(component);
        }
        
    },
    onUserIntentionSubmitHelper: function(component) {
        if(!$A.util.isUndefinedOrNull(component.get("v.WrapperData")))
        {   
            this.waiting(component);
            var WrapperData  = component.get("v.WrapperData");
            var action = component.get("c.insertCustomerIntention");
           
            
            action.setParams({                  
                customerIntention : JSON.stringify(WrapperData.customerIntentionObj),
                contractObject    : JSON.stringify(WrapperData.contractObj)
            });       
            action.setCallback(this, function(response){
                var state = response.getState();
                
                if ((state === "SUCCESS") && (component.isValid())) {
                    var records = response.getReturnValue(); 
                    var isError = records.isError ;
                    if(isError === true){
                        this.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false"); 
                    	this.doneWaiting(component);
                    }else{
                        if(records.errorCode === 1001){                          
                            component.set("v.isValiadtionFail",true);
             			    this.showToast(component,"true",records.errorMessage,"true","false"); 
                        }else if(records.errorCode === 1002){
                            component.set("v.isValiadtionFail",true);
             			    this.showToast(component,"true",records.errorMessage,"true","false"); 
                        }else if(records.errorCode === 1003){
                            component.set("v.isValiadtionFail",true);
             			    this.showToast(component,"true",records.errorMessage,"true","false"); 
                        }else{
                            if(component.get("v.fromRTM") === false)
                            {
                          
                                $A.get('e.force:refreshView').fire();
                            }
                            component.set("v.isValiadtionFail",false);
                            this.hideModalHelper(component);                   		
                        }  
                        this.doneWaiting(component);
                    }                   
                }if(state === "ERROR"){
                    this.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false"); 
                    this.doneWaiting(component); 
                }
                this.doneWaiting(component); 
            });
            $A.enqueueAction(action);
        }else{
            this.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false"); 
            this.doneWaiting(component);
        }
        
    },
    onInItHelperSetData: function(component , records) {
        var isError = records.isError ;
        if(isError === false){ 
            var optionToSubOptionMap = records.optionToSubOptionMap;
            var optionList = Object.keys(optionToSubOptionMap);
                       
            var SubOutComeList =  ["--None--"];
            component.set("v.subOptionList",SubOutComeList);
                
            component.set("v.optionList",optionList);
            component.set("v.WrapperData",records);
            this.doneWaiting(component);   
        }else{
            this.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false"); 
            this.doneWaiting(component); 
        }
    },
    validateForm: function(component) { 
        var WrapperData  = component.get("v.WrapperData");
        var customerIntentionObj = WrapperData.customerIntentionObj ;
       
        if((customerIntentionObj.MBFS_Communication_Channel__c).trim() === "" || 
           (customerIntentionObj.MBFS_Communication_Channel__c).trim() === "--None--"){
             component.set("v.isValiadtionFail",true);
             this.showToast(component,"true","Communication channel "+$A.get("$Label.c.MBFS_Is_Required"),"true","false"); 
        }else if((customerIntentionObj.MBFS_Option__c).trim() === "" ||
                (customerIntentionObj.MBFS_Option__c).trim() === "--None--"){
             component.set("v.isValiadtionFail",true);
             this.showToast(component,"true","Option "+$A.get("$Label.c.MBFS_Is_Required"),"true","false"); 
        }else if((customerIntentionObj.MBFS_Sub_Option__c).trim() === "" || 
                (customerIntentionObj.MBFS_Sub_Option__c).trim() === "--None--"){
             component.set("v.isValiadtionFail",true);
             this.showToast(component,"true","Sub Option "+$A.get("$Label.c.MBFS_Is_Required"),"true","false"); 
        }else{
             component.set("v.isValiadtionFail",false);
        }
    }
})