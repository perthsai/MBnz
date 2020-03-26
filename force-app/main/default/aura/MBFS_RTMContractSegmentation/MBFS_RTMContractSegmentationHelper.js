({
	loadData: function(component, event,filter,campaignName,dateFilter) { 
        var checkParameter =   !$A.util.isUndefinedOrNull(campaignName)
                               && !$A.util.isUndefinedOrNull(dateFilter)
                               && !$A.util.isUndefinedOrNull(component.get("v.sortField"))
                               && !$A.util.isUndefinedOrNull(component.get("v.sortAsc"))
                               && !$A.util.isUndefinedOrNull(component.get("v.defaultCount")) ;
        
        if(checkParameter)
        {   
            
            this.waiting();
            
            var wrapperObj = { 
                filter :  "",
                campaignId  : campaignName ,
                dateFilter  : dateFilter,
                sortField   : component.get("v.sortField"),
                isAscending : component.get("v.sortAsc"),
                noOfRecord  : component.get("v.defaultCount")
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
                        var campaignName         = component.get("v.campaignName");
                        var dateFilter         = component.get("v.dateFilter");
                        
                        var MBFS_RTMListView = component.find('MBFS_RTMListView');               
                        MBFS_RTMListView.recordDataList(records,"",campaignName,dateFilter);    
                        this.doneWaiting();  
                    }else{
                         this.showToast("error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                         this.doneWaiting();
                    }   
                }else if(state === "ERROR"){
                    this.showToast("error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                    this.doneWaiting();
                }
            });
            $A.enqueueAction(action);
        }else{
            this.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
            this.doneWaiting();
        }
    },
    onFilterChangeHelper: function(component, event,filter,campaignName,dateFilter) {
        var checkParameter =   !$A.util.isUndefinedOrNull(campaignName)
                               && !$A.util.isUndefinedOrNull(dateFilter)
                               && !$A.util.isUndefinedOrNull(component.get("v.sortField"))
                               && !$A.util.isUndefinedOrNull(component.get("v.sortAsc"))
                               && !$A.util.isUndefinedOrNull(component.get("v.defaultCount")) ;
        
        if(checkParameter)
        {   
            this.waiting();
            
             var wrapperObj = { 
                filter :  "",
                campaignId  : campaignName ,
                dateFilter  : dateFilter,
                sortField   : component.get("v.sortField"),
                isAscending : component.get("v.sortAsc"),
                noOfRecord  : component.get("v.defaultCount")
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
                        var WrapperData = component.get("v.WrapperData");   
                        WrapperData.resultSet.rows = records.resultSet.rows ;                   
                        WrapperData.recordCount = records.recordCount ;
                        component.set("v.WrapperData",WrapperData);
         
                        var campaignName         = component.get("v.campaignName");
                        var dateFilter         = component.get("v.dateFilter");
                        
                        var MBFS_RTMListView = component.find('MBFS_RTMListView');               
                        MBFS_RTMListView.recordDataList(records,"",campaignName,dateFilter);    
                        this.doneWaiting(); 
                    }else{
                        this.showToast("error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                    	this.doneWaiting();
                    }
                }else if(state === "ERROR"){
                    this.showToast("error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                    this.doneWaiting();
                }
            });
            $A.enqueueAction(action);
        }else{
            this.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
            this.doneWaiting();
        }
    },
    waiting: function() {
        if(!$A.util.isUndefinedOrNull(document.getElementById("RTMSegspinner")))
        {            
            document.getElementById("RTMSegspinner").style.display = "block";            
        }  
        
    },
    doneWaiting: function() {
        if(!$A.util.isUndefinedOrNull(document.getElementById("RTMSegspinner")))
        {
           document.getElementById("RTMSegspinner").style.display = "none";
        }
    },
    showToast: function(type,title,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({               
                "type": type,
                "title": title,
                "message": message
        });
        toastEvent.fire();
    },
})