({
	initCall : function(component, event, helper) {
		helper.initCallHelper(component, event,component.get("v.recordId"));
	},
    onLeadTypeChange: function(component, event, helper) {
        
        let records = component.get("v.MBFS_Nature_of_LeadAll")[0] ;
             
        let MBFS_Lead_Type_Value = component.get("v.MBFS_Lead_Type_Value");
        if(MBFS_Lead_Type_Value === "Retailer Lead"){
             component.set("v.MBFS_Nature_of_Request",records.Retailer_Lead.values);   
             component.set("v.MBFS_Nature_of_Request_Value",records.Retailer_Lead.values[0]);
            
             component.set("v.MBFS_Lead_Source",records.Retailer_Source.values);   
             component.set("v.MBFS_Lead_Source_Value",records.Retailer_Source.values[0]);
            
            
        }else if(MBFS_Lead_Type_Value === "Finance Lead"){
             component.set("v.MBFS_Nature_of_Request",records.Finance_Lead.values);   
             component.set("v.MBFS_Nature_of_Request_Value",records.Finance_Lead.values[0]);
            
             component.set("v.MBFS_Lead_Source",records.Finance_Source.values);   
             component.set("v.MBFS_Lead_Source_Value",records.Finance_Source.values[0]);
            
        }else if(MBFS_Lead_Type_Value === "Insurance Lead"){
             component.set("v.MBFS_Nature_of_Request",records.Insurance_Lead.values);   
             component.set("v.MBFS_Nature_of_Request_Value",records.Insurance_Lead.values[0]);
            
             component.set("v.MBFS_Lead_Source",records.Insurance_Source.values);   
             component.set("v.MBFS_Lead_Source_Value",records.Insurance_Source.values[0]);
            
        }    
    },
    newEditTaskSubmit: function(component, event, helper) { 
         var subOutComeAction = component.get("v.subOutComeAction");
         helper.validateForm(component, event,subOutComeAction);        
         if(component.get("v.exceptionFlag") === true ){
             helper.editTaskSubmitHelper(component, event);
         }
    },
    hideModal: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire(); 
    },
    onOutComeChange: function(component, event, helper) {
        var outComeName = component.get("v.outComeName") ;
        var OutComeList = component.get("v.OutComeList");
        var SubOutComeList = [];
        for (var i = 0 ; i < OutComeList.length ; i++){
            if(OutComeList[i].key === outComeName){
                var sub =   OutComeList[i].value ;
                
                for (var j = 0 ; j < sub.length ; j++){                                
                    SubOutComeList.push({
                        key: sub[j].action,
                        value: sub[j].subOutCome
                    });
                }    
            }                          
        } 
        
        component.set("v.SubOutComeList",SubOutComeList);
        
        helper.clearFormWithOutCome(component);       
    },
    onSubOutComeChange: function(component, event, helper) {
        var subOutComeName = component.get("v.subOutComeName") ;
        var SubOutComeList = component.get("v.SubOutComeList");
        var actionName = "";
        for (var i = 0 ; i < SubOutComeList.length ; i++){
            if(SubOutComeList[i].value === subOutComeName){
                actionName = SubOutComeList[i].key ;
                break ;
            }
        }
       
        component.set("v.subOutComeAction",actionName); 
    },
    
})