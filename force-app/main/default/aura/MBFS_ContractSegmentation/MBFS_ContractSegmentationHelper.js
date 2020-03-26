({
    loadData: function(component, event,campaignName,assignedId,agility,residual,vehicleMakeInterest,globalFilter) {
        
        var checkParameter =   !$A.util.isUndefinedOrNull(campaignName)
                               && !$A.util.isUndefinedOrNull(assignedId)
                               && !$A.util.isUndefinedOrNull(agility) 
                               && !$A.util.isUndefinedOrNull(residual)
                               && !$A.util.isUndefinedOrNull(vehicleMakeInterest)
                               && !$A.util.isUndefinedOrNull(component.get("v.sortField"))
                               && !$A.util.isUndefinedOrNull(component.get("v.sortAsc"))
                               && !$A.util.isUndefinedOrNull(component.get("v.defaultCount"))
                               && !$A.util.isUndefinedOrNull(globalFilter) ;
        
        if(checkParameter)
        {   
            this.waiting();
            
            var wrapperObj = {
                filter      : "" ,
                campaignId  : campaignName ,
                assignedId  : assignedId ,
                agility     : agility ,
                residual    : residual,
                vehicleMakeInterest : vehicleMakeInterest,
                sortField   : component.get("v.sortField"),
                isAscending : component.get("v.sortAsc"),
                noOfRecord  : component.get("v.defaultCount"),
                globalFilter : globalFilter 
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
                        var globalFilter         = component.get("v.globalFilter");
                        
                        if(globalFilter === 'MBSF_CAMPAIGN'){
                            var MBSF_SummaryChart = component.find('MBSF_SummaryChart');               
                            MBSF_SummaryChart.recordDataList(records.chartData,records.recordCount);
                        }   
                        
                        var assigneeName        = component.get("v.assigneeName");
                        var agilityName         = component.get("v.agilityName");               
                        var campaignName         = component.get("v.campaignName");
                        var residualValue        = component.get("v.residualValue");
                        var vehicleMakeInterest = component.get("v.vehicleMakeInterest")
                        
                        var MBFS_ListView = component.find('MBFS_ListView');               
                        MBFS_ListView.recordDataList(records,assigneeName,agilityName,campaignName,residualValue,vehicleMakeInterest,globalFilter);
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
    filterChange: function(component, event,campaignId,assignedId,agility,residual,vehicleMakeInterest,globalFilter) {
        
        var checkParameter =  !$A.util.isUndefinedOrNull(campaignId)
                               && !$A.util.isUndefinedOrNull(assignedId)
                               && !$A.util.isUndefinedOrNull(agility)
                               && !$A.util.isUndefinedOrNull(residual)
                               && !$A.util.isUndefinedOrNull(vehicleMakeInterest)
                               && !$A.util.isUndefinedOrNull(component.get("v.sortField"))
                               && !$A.util.isUndefinedOrNull(component.get("v.sortAsc"))
                               && !$A.util.isUndefinedOrNull(component.get("v.defaultCount"))
                               && !$A.util.isUndefinedOrNull(globalFilter) ;
        
        if(checkParameter)
        {   
            this.waiting();
            
            var wrapperObj = {
                filter      : "" ,
                campaignId  : campaignId ,
                assignedId  : assignedId ,
                agility     : agility ,
                residual    : residual,
                vehicleMakeInterest : vehicleMakeInterest,
                sortField   : component.get("v.sortField"),
                isAscending : component.get("v.sortAsc"),
                noOfRecord  : component.get("v.defaultCount"),
                globalFilter : globalFilter 
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
                        WrapperData.resultSet = records.resultSet ;
                        WrapperData.chartData = records.records ;
                        
                        component.set("v.WrapperData", WrapperData);
                        
                        var globalFilter = component.get("v.globalFilter");
                        if(globalFilter === 'MBSF_CAMPAIGN'){                    
                            var MBSF_SummaryChart = component.find('MBSF_SummaryChart');               
                            MBSF_SummaryChart.recordDataList(records.chartData,records.recordCount);   
                        }
                        
                       
                        var assigneeName        = component.get("v.assigneeName");
                        var agilityName         = component.get("v.agilityName");
                        
                        var campaignName         = component.get("v.campaignName");
                        var residualValue        = component.get("v.residualValue");
                        var vehicleMakeInterest  = component.get("v.vehicleMakeInterest");
                        
                        var MBFS_ListView = component.find('MBFS_ListView');               
                        MBFS_ListView.recordDataList(records,assigneeName,agilityName,campaignName,residualValue,vehicleMakeInterest,globalFilter);
                        this.doneWaiting();
                    }else{
                        console.log('helper 1');
                        this.showToast("error","Error!",$A.get("$Label.c.MBFS_Exception_message")); 
                        this.doneWaiting();
                    }
                }else if(state === "ERROR"){
                    console.log('helper 2');
                    this.showToast("error","Error!",$A.get("$Label.c.MBFS_Exception_message")); 
                    this.doneWaiting();
                }
            });
            $A.enqueueAction(action);
        }else{
            console.log('helper 3');
            this.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
            this.doneWaiting();
        }
    },
    onAssignSuccess: function(component, event,apiName) { 
       component.set("v.defaultCount",25);         
       this.filterChange(component, event,component.get("v.campaignName"),component.get("v.assigneeName"),component.get("v.agilityName"),component.get("v.residualValue"),component.get("v.vehicleMakeInterest"),apiName)
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