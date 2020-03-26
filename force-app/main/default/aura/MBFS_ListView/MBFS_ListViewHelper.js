({
    renderPage: function(component) {
        
        var records = component.get("v.AllAccountList");
        var pageNumber = component.get("v.pageNumber"); 
        var defaultCount = component.get("v.defaultCount");
        
        var pageRecords = records.slice((pageNumber-1)* defaultCount, pageNumber * defaultCount);
        
        //Set The Intention Status
        for(var i=0 ; i < pageRecords.length; i++){
            for(var j=0 ; j < pageRecords[i].fields.length; j++){
                if(!$A.util.isUndefinedOrNull(pageRecords[i].fields[j].fieldApi) &&
                   !$A.util.isUndefinedOrNull(pageRecords[i].fields[j].fieldValue) &&
                   pageRecords[i].fields[j].fieldApi === "mbfs_intention_status__c" && 
                   pageRecords[i].fields[j].fieldValue !== ""){ 
                    
                    pageRecords[i].fields[j].fieldValue = "<img src=" +pageRecords[i].fields[j].fieldValue+" style='height:25px; width:25px;' border='0'/>";
                }
            }
        }
        //Set The Intention Status
        
        component.set("v.PageAccountList", pageRecords);
        
        var count = 0 ;
        for (var i = 0; i < pageRecords.length; i++){           
            if(pageRecords[i].isSelected === true){
                count = count + 1;
            }
        }
        
        if((pageRecords.length !== count)){
            component.set("v.selectAllCheckBox", false);
        }else{
            if(pageRecords.length !==0 && count !== 0){
                component.set("v.selectAllCheckBox", true);
            }           
        }
        
        var countData = component.get("v.WrapperData").recordCount ;
        component.set("v.totalNoOfrecord",countData);        
        component.set("v.maxPage", Math.floor((countData + (defaultCount - 1))/defaultCount)); 
        
    },
    loadData: function(component) {
        
        if(!$A.util.isUndefinedOrNull(component.get("v.WrapperData"))
           && !$A.util.isUndefinedOrNull(component.get("v.defaultCount"))){
            var WrapperData = component.get("v.WrapperData"); 
            component.set("v.AllAccountList",WrapperData.resultSet.rows);   
            component.set("v.pageNumber",1); 
            component.set("v.selectedRecordCount",0);
            component.set("v.sortField","CreatedDate");
            this.renderPage(component);
        }else{
            this.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }     
        
    },
    loadMoreData: function(component,offset,noOfRecord) {
        
        var checkParameter =   !$A.util.isUndefinedOrNull(offset) 
                               && !$A.util.isUndefinedOrNull(noOfRecord)
                               && !$A.util.isUndefinedOrNull(component.get("v.campaignName"))
                               && !$A.util.isUndefinedOrNull(component.get("v.assigneeName"))
                               && !$A.util.isUndefinedOrNull(component.get("v.agilityName"))
                               && !$A.util.isUndefinedOrNull(component.get("v.residualValue"))
                               && !$A.util.isUndefinedOrNull(component.get("v.vehicleMakeInterest"))
                               && !$A.util.isUndefinedOrNull(component.get("v.sortField"))
                               && !$A.util.isUndefinedOrNull(component.get("v.sortAsc"))
                               && !$A.util.isUndefinedOrNull(component.get("v.globalFilter"))
                               && !$A.util.isUndefinedOrNull(component.get("v.WrapperData"))
                               && !$A.util.isUndefinedOrNull(component.get("v.AllAccountList")) ;
        
        if(checkParameter)
        {              
            this.waiting();
            
            var wrapperObj = {
                filter      : "" ,
                campaignId  : component.get("v.campaignName") ,
                assignedId  : component.get("v.assigneeName") ,
                agility     : component.get("v.agilityName") ,
                residual    : component.get("v.residualValue"),
                vehicleMakeInterest : component.get("v.vehicleMakeInterest"),
                sortField   : component.get("v.sortField"),
                isAscending : component.get("v.sortAsc"),
                noOfRecord  : noOfRecord,
                globalFilter : component.get("v.globalFilter") 
            };
            
            
            
            var action = component.get("c.onSorting");
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
                        var AllAccountList = component.get("v.AllAccountList");
                        
                        var updatedData = records.rows ;
                        
                        if(updatedData !== null){
                            for(var i = 0 ; i < AllAccountList.length ;i++){                                              
                                var contractIdOld = AllAccountList[i].contractId ;
                                for(var j = 0 ; j < updatedData.length ;j++){
                                    var contractIdNew = updatedData[j].contractId ;
                                    if(contractIdNew === contractIdOld){  
                                        updatedData.splice(j,1);                                  
                                        break ;
                                    }
                                }                    
                            }
                            updatedData = AllAccountList.concat(updatedData);
                            
                            while(AllAccountList.length > 0) {
                                AllAccountList.pop();
                            }
                            AllAccountList = updatedData;  
                            WrapperData.resultSet.rows = AllAccountList ;
                            component.set("v.WrapperData",WrapperData); 
                        }                                   
                        component.set("v.AllAccountList",AllAccountList);  
                        component.set("v.pageNumber", Math.min(component.get("v.pageNumber")+1, component.get("v.maxPage")));                        
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
    loadLast: function(component,offset,noOfRecord) {
        var checkParameter =   !$A.util.isUndefinedOrNull(offset) 
                               && !$A.util.isUndefinedOrNull(noOfRecord)
                               && !$A.util.isUndefinedOrNull(component.get("v.campaignName"))
                               && !$A.util.isUndefinedOrNull(component.get("v.assigneeName"))
                               && !$A.util.isUndefinedOrNull(component.get("v.agilityName"))
                               && !$A.util.isUndefinedOrNull(component.get("v.residualValue"))
                               && !$A.util.isUndefinedOrNull(component.get("v.vehicleMakeInterest"))
                               && !$A.util.isUndefinedOrNull(component.get("v.sortField"))
                               && !$A.util.isUndefinedOrNull(component.get("v.sortAsc"))
                               && !$A.util.isUndefinedOrNull(component.get("v.globalFilter"))
                               && !$A.util.isUndefinedOrNull(component.get("v.WrapperData"))
                               && !$A.util.isUndefinedOrNull(component.get("v.AllAccountList"));
        
        if(checkParameter)
        {              
            this.waiting();
            
            var wrapperObj = {
                filter      : "" ,
                campaignId  : component.get("v.campaignName") ,
                assignedId  : component.get("v.assigneeName") ,
                agility     : component.get("v.agilityName") ,
                residual    : component.get("v.residualValue"),
                vehicleMakeInterest : component.get("v.vehicleMakeInterest"),
                sortField   : component.get("v.sortField"),
                isAscending : component.get("v.sortAsc"),
                noOfRecord  : noOfRecord,
                globalFilter : component.get("v.globalFilter") 
            };
           
            var action = component.get("c.onSorting");
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
                        var AllAccountList = component.get("v.AllAccountList");
                        
                        var updatedData = records.rows ;
                        if(updatedData !== null){
                            for(var i = 0 ; i < AllAccountList.length ;i++){                                              
                                var contractIdOld = AllAccountList[i].contractId ;
                                for(var j = 0 ; j < updatedData.length ;j++){
                                    var contractIdNew = updatedData[j].contractId ;
                                    if(contractIdNew === contractIdOld){  
                                        updatedData.splice(j,1);                                  
                                        break ;
                                    }
                                }                    
                            }
                            updatedData = AllAccountList.concat(updatedData);
                            
                            
                            while(AllAccountList.length > 0) {
                                AllAccountList.pop();
                            }
                            AllAccountList = updatedData;  
                            WrapperData.resultSet.rows = AllAccountList ;
                            component.set("v.WrapperData",WrapperData); 
                        }                                   
                        
                        component.set("v.AllAccountList",AllAccountList);  
                       
                        component.set("v.pageNumber", component.get("v.maxPage")); 
                        
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
    sortData: function(component,sortField,sortAsc) {
        var checkParameter =   !$A.util.isUndefinedOrNull(sortField) 
                               && !$A.util.isUndefinedOrNull(sortAsc)
                               && !$A.util.isUndefinedOrNull(component.get("v.campaignName"))
                               && !$A.util.isUndefinedOrNull(component.get("v.assigneeName"))
                               && !$A.util.isUndefinedOrNull(component.get("v.agilityName"))
                               && !$A.util.isUndefinedOrNull(component.get("v.residualValue"))
                               && !$A.util.isUndefinedOrNull(component.get("v.vehicleMakeInterest"))
                               && !$A.util.isUndefinedOrNull(component.get("v.defaultCount"))
                               && !$A.util.isUndefinedOrNull(component.get("v.globalFilter")) ;
        if(checkParameter)
        {          
            this.waiting();
            
            
            var wrapperObj = {
                filter      : "" ,
                campaignId  : component.get("v.campaignName") ,
                assignedId  : component.get("v.assigneeName") ,
                agility     : component.get("v.agilityName") ,
                residual    : component.get("v.residualValue"),
                vehicleMakeInterest : component.get("v.vehicleMakeInterest"),
                sortField   : sortField,
                isAscending : sortAsc,
                noOfRecord  : component.get("v.defaultCount"),
                globalFilter : component.get("v.globalFilter") 
            };
           
            var action = component.get("c.onSorting");        
            action.setParams({               
                jsonParameter : JSON.stringify(wrapperObj)
            });   
            
            action.setCallback(this, function(response){
                var state = response.getState();   

                if ((state === "SUCCESS") && (component.isValid())) {
                    var records = response.getReturnValue();
                    var isError = records.isError ;
                    if(isError === false){ 
                    
                        if(records !== null && records.rows !== null){
                            var updatedData = records.rows ;                      
                            var WrapperData = component.get("v.WrapperData"); 
                            WrapperData.resultSet.rows = updatedData ;
                            component.set("v.WrapperData",WrapperData);  
                           
                            component.set("v.AllAccountList",updatedData); 
                            
                            component.set("v.selectedRecordCount",0);
                            
                            component.set("v.pageNumber",1);
                        }
                        this.doneWaiting();
                        this.renderPage(component);
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
        }else {
            this.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
            this.doneWaiting();
        }
        
    },
    selectAllCheckBoxHelper: function(component) {
        var PageAccountList = component.get("v.PageAccountList");   
        var selectAllCheckBox = component.get("v.selectAllCheckBox");
        var selectedRecordCount = component.get("v.selectedRecordCount");
        
        var checkParameter = !$A.util.isUndefinedOrNull(PageAccountList) 
                             && !$A.util.isUndefinedOrNull(selectAllCheckBox)
                             && !$A.util.isUndefinedOrNull(selectedRecordCount) ;
        
        if(checkParameter)
        {      
            for (var i = 0; i < PageAccountList.length; i++){           
                if(selectAllCheckBox === true){
                    if(PageAccountList[i].isSelected !== true){
                        selectedRecordCount = selectedRecordCount + 1 ;
                    }                    
                    PageAccountList[i].isSelected = true;                    
                }else{
                    if(PageAccountList[i].isSelected !== false){
                        selectedRecordCount = selectedRecordCount - 1 ;
                    }                    
                    PageAccountList[i].isSelected = false;                    
                }
            }
            component.set("v.selectedRecordCount",selectedRecordCount);
            component.set("v.PageAccountList",PageAccountList);
        } else{
            this.showToast("error","Error!",$A.get("$Label.c.MBFS_ParameterIsNull"));
        }      
    },
    changeOwner: function(component,assigneeId,globalFilter) { 
        var WrapperData = component.get("v.WrapperData");
        
        var checkParameter = !$A.util.isUndefinedOrNull(WrapperData) 
                             && !$A.util.isUndefinedOrNull(assigneeId) 
        					 && !$A.util.isUndefinedOrNull(globalFilter) ;
        
        if(checkParameter)
        {
            this.waiting();
            var action = component.get("c.updateData");
            action.setParams({ 
                "data" :JSON.stringify(WrapperData) ,
                "assigneeId":assigneeId,
                "globalFilter":globalFilter
            }); 
            
            action.setCallback(this, function(response){
                var state = response.getState();   
                if ((state === "SUCCESS") && (component.isValid())) {
                    var isError = response.getReturnValue();
                    if(isError === false){ 
                        var cmpTarget = component.find('dialogBoxOpen');
                        $A.util.removeClass(cmpTarget, 'slds-show');
                        
                        //Team Saasfocus 12-06-2018
                        $A.util.addClass(cmpTarget, 'slds-hide');
                        
                        var assignToEvt = component.getEvent("assignToEvt");
                        assignToEvt.setParams({"globalFilter" : globalFilter });
                        assignToEvt.fire();   
                        
                        this.doneWaiting();                   
                        this.showToast("success","success","Updated Successfully.");
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
    onNotCallSubmitHelper: function(component,outCome,subOutCome,globalFilter) { 
        var WrapperData = component.get("v.WrapperData");
       
        var checkParameter =   !$A.util.isUndefinedOrNull(WrapperData) 
                               && !$A.util.isUndefinedOrNull(outCome) 
                               && !$A.util.isUndefinedOrNull(subOutCome) 
                               && !$A.util.isUndefinedOrNull(globalFilter) ;
        if(checkParameter)
        {
            this.waiting();
            var action = component.get("c.onNotCallSave");
            action.setParams({ 
                "data" :JSON.stringify(WrapperData) ,
                "outCome":outCome,
                "subOutCome":subOutCome,
                "globalFilter":globalFilter,
            }); 
            
            action.setCallback(this, function(response){
                var state = response.getState();   
                if ((state === "SUCCESS") && (component.isValid())) {
                    var isError = response.getReturnValue();
                    if(isError === false){ 
                    
                        var cmpTarget = component.find('notCallPopUp');
                        $A.util.removeClass(cmpTarget, 'slds-show'); 
                        
                        //Team Saasfocus 12-06-2018
                        $A.util.addClass(cmpTarget, 'slds-hide'); 
                        
                        var assignToEvt = component.getEvent("assignToEvt");
                        assignToEvt.setParams({"globalFilter" : globalFilter });
                        assignToEvt.fire();   
                        
                        this.doneWaiting();                   
                        this.showToast("success","success","Updated Successfully.");
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
    initCallHelper : function(component) {
        this.waiting();    
        var action = component.get("c.getDoNotCallValues");               
        action.setCallback(this, function(response){
            var state = response.getState();
           
            if ((state === "SUCCESS") && (component.isValid())) {                
                var records = response.getReturnValue(); 
                var isError = records.isError ;
                if(isError === false){ 
                    component.set("v.MBFS_NO_CALL_REQUIRED",records.values.No_Call_Required);   
                    component.set("v.subOutCome",records.values.No_Call_Required[0]);
                    component.set("v.OutCome","No Call Required");
                    this.doneWaiting();
                }else{
                    this.showToast("error","Error!",$A.get("$Label.c.MBFS_Exception_message"));
                    this.doneWaiting();
                }
            }
        });
        $A.enqueueAction(action); 
        this.doneWaiting();
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
        if(!$A.util.isUndefinedOrNull(document.getElementById("RTHAccspinner")))
        {
            document.getElementById("RTHAccspinner").style.display = "block";            
        }  
        
    },
    doneWaiting: function() {
        if(!$A.util.isUndefinedOrNull(document.getElementById("RTHAccspinner")))
        {
            document.getElementById("RTHAccspinner").style.display = "none";
        }
    },
})