({
	renderPage: function(component) {
        
        var records = component.get("v.AllAccountList");
        var pageNumber = component.get("v.pageNumber"); 
        var defaultCount = component.get("v.defaultCount");
                
        var pageRecords = records.slice((pageNumber-1)* defaultCount, pageNumber * defaultCount);
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
        }     
        
    },
    loadMoreData: function(component,event,noOfRecord) {
        
        var checkParameters = !$A.util.isUndefinedOrNull(noOfRecord)        
                               && !$A.util.isUndefinedOrNull(component.get("v.sortField"))
                               && !$A.util.isUndefinedOrNull(component.get("v.sortAsc"))
                               && !$A.util.isUndefinedOrNull(component.get("v.WrapperData"))
                               && !$A.util.isUndefinedOrNull(component.get("v.AllAccountList")) ;        
        if(checkParameters)
        {              
            this.waiting();  
            
            var wrapperObj = { 
                campaignId      : component.get("v.campaignId") ,
                noOfRecord      : noOfRecord ,
                isAscending     : component.get("v.sortAsc") ,
                sortField       : component.get("v.sortField")
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
                        var AllAccountList = component.get("v.AllAccountList");
                        var updatedData = records.resultSet.rows ;
                        if(!$A.util.isUndefinedOrNull(updatedData)){
                            
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
                        this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message")); 
                    	this.doneWaiting();
                    }
                }else if(state === "ERROR"){
                    this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message")); 
                    this.doneWaiting();
                }
            });
            $A.enqueueAction(action);
        }else{
            this.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false");   
            this.doneWaiting();
        }
    },
    loadLast: function(component,event,noOfRecord) {
        
        var checkParameters = !$A.util.isUndefinedOrNull(noOfRecord)
                               && !$A.util.isUndefinedOrNull(component.get("v.campaignId")) 
                               && !$A.util.isUndefinedOrNull(component.get("v.sortField"))
                               && !$A.util.isUndefinedOrNull(component.get("v.sortAsc"))
                               && !$A.util.isUndefinedOrNull(component.get("v.WrapperData"))
                               && !$A.util.isUndefinedOrNull(component.get("v.AllAccountList")) ;
        
        if(checkParameters)
        {              
            this.waiting();  
                    
            var wrapperObj = { 
                campaignId      : component.get("v.campaignId") ,
                noOfRecord      : noOfRecord ,
                isAscending     : component.get("v.sortAsc") ,
                sortField       : component.get("v.sortField")
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
                        var AllAccountList = component.get("v.AllAccountList");
                        
                        var updatedData = records.resultSet.rows ;
                        
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
                        this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));      
                        this.doneWaiting();
                    }
                }else if(state === "ERROR"){
                  
                   this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));      
                   this.doneWaiting();
                }
            });
            $A.enqueueAction(action);
        }else{
           this.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false");      
           this.doneWaiting();
        }
    },
    updateViewHelper: function(component,event,sortField,sortAsc) {
       
        var checkParameters =  !$A.util.isUndefinedOrNull(sortField) 
                               && !$A.util.isUndefinedOrNull(sortAsc)
                               && !$A.util.isUndefinedOrNull(component.get("v.campaignId")) 
                               && !$A.util.isUndefinedOrNull(component.get("v.defaultCount")) ;
        if(checkParameters)
        {          
            this.waiting();   
            
            var wrapperObj = { 
                campaignId      : component.get("v.campaignId") ,
                noOfRecord      : component.get("v.defaultCount") ,
                isAscending     : sortAsc ,
                sortField       : sortField
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
                        if(records !== null && records.resultSet.rows !== null){
                            var updatedData = records.resultSet.rows ;                      
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
                        this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));  
                        this.doneWaiting();
                    }
                }else if(state === "ERROR"){                                       
                    this.showToast(component,"error","Error!",$A.get("$Label.c.MBFS_Exception_message"));  
                    this.doneWaiting();
                }
            });
            $A.enqueueAction(action);
        }else{
           this.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false"); 
           this.doneWaiting();
        }
        
    },
    selectAllCheckBoxHelper: function(component,event) {
        var PageAccountList = component.get("v.PageAccountList");   
        var selectAllCheckBox = component.get("v.selectAllCheckBox");
        var selectedRecordCount = component.get("v.selectedRecordCount");
        
        var checkParameters = !$A.util.isUndefinedOrNull(PageAccountList) && 
                              !$A.util.isUndefinedOrNull(selectAllCheckBox) && 
                              !$A.util.isUndefinedOrNull(selectedRecordCount) ;
        
        if(checkParameters)
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
            this.showToast(component,"true",$A.get("$Label.c.MBFS_ParameterIsNull"),"true","false");        
        }      
    },
    onCampaignChangeHelper : function(component, event, coampainId , contractData) {
        
       if(!$A.util.isUndefinedOrNull(coampainId) && 
          !$A.util.isUndefinedOrNull(contractData))
        {     
            this.waiting();            
            var action = component.get("c.onChangeCampaignSubmit");        
            action.setParams({ 
                "campaignId" :coampainId ,                
                "contractData":JSON.stringify(contractData)
            });   
            
            action.setCallback(this, function(response){
                var state = response.getState();   
                
                if ((state === "SUCCESS") && (component.isValid())) {                   
                    var records = response.getReturnValue(); 
                    
                    if(records === false){ 
                   
                        this.showToast(component,"true","Record updated successfully","false","true"); 
                        
                        this.doneWaiting();
                        var campaignEvt = component.getEvent("campaignEvt");
                        campaignEvt.setParams({"campaignId" : coampainId});
                        campaignEvt.fire(); 
                    }else{
                       this.showToast(component,"true",$A.get("$Label.c.MBFS_Exception_message"),"true","false"); 
                    	this.doneWaiting(); 
                    }
                 
                }else if(state === "ERROR"){
                    this.showToast(component,"true",$A.get("$Label.c.MBFS_Exception_message"),"true","false"); 
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
        if(!$A.util.isUndefinedOrNull(document.getElementById("CampAccspinner")))
        {            
            document.getElementById("CampAccspinner").style.display = "block";            
        }  
        
    },
    doneWaiting: function() {
        if(!$A.util.isUndefinedOrNull(document.getElementById("CampAccspinner")))
        {
           document.getElementById("CampAccspinner").style.display = "none";
        }
    },
})