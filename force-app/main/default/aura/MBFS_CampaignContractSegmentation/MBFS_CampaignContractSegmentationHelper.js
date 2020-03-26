({
	loadData: function(component) {  
        var checkParameter =   !$A.util.isUndefinedOrNull(component.get("v.sortField"))
                               && !$A.util.isUndefinedOrNull(component.get("v.sortAsc"))
                               && !$A.util.isUndefinedOrNull(component.get("v.defaultCount"))
                               && !$A.util.isUndefinedOrNull(component.get("v.recordId")) ;
        if(checkParameter)
        {   
            this.waiting();
            
            var wrapperObj = { 
                campaignId      : component.get("v.recordId"),
                noOfRecord  : component.get("v.defaultCount"),
                isAscending  : component.get("v.sortAsc") ,
                sortField     : component.get("v.sortField")
            };
            
             
            
            var action = component.get("c.onLoadCall");
            action.setParams({                  
                jsonParameter : JSON.stringify(wrapperObj)
            });       
            action.setCallback(this, function(response){
                var state = response.getState();
               
                if ((state === "SUCCESS") && (component.isValid())) {
                    var records = response.getReturnValue();                    
                    var isError = records.isError ;
                    
                    if(isError === false){ 
                    
                        component.set("v.WrapperData", records);                   
                        var MBFS_CampaignListView = component.find('MBFS_CampaignListView');                                  
                        MBFS_CampaignListView.recordDataList(records);      
                        this.doneWaiting();   
                    }else{
                        this.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false"); 
                    	this.doneWaiting(); 
                    }
                }if(state === "ERROR"){
                    this.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false"); 
                    this.doneWaiting(); 
                }
            });
            $A.enqueueAction(action);
        }else{
            this.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false"); 
            this.doneWaiting();
        }
    },
    showToast: function(component,openToast,message,isError,isSuccess) {
         component.set("v.openToast",openToast);
         component.set("v.message",message);
         component.set("v.isError",isError);
         component.set("v.isSuccess",isSuccess);
    },
    waiting: function() {
        if(!$A.util.isUndefinedOrNull(document.getElementById("RTHSegspinner")))
        {            
            document.getElementById("RTHSegspinner").style.display = "block";            
        }  
        
    },
    doneWaiting: function() {
        if(!$A.util.isUndefinedOrNull(document.getElementById("RTHSegspinner")))
        {
           document.getElementById("RTHSegspinner").style.display = "none";
        }
    },
    
})