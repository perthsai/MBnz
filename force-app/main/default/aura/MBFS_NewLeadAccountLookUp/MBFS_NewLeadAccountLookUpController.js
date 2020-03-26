({
    doInit : function(component, event, helper) {
        var selectedRecord = component.get("v.selectedRecord");
        
        if(selectedRecord === ""){            
            var lookupPill = component.find("lookup-pill");
            $A.util.addClass(lookupPill, 'slds-hide');
            $A.util.removeClass(lookupPill, 'slds-show');
            
            var lookupField = component.find("lookupField");
            $A.util.removeClass(lookupField, 'slds-hide');
            $A.util.addClass(lookupField, 'slds-show');                      
        } 
    },
    keyPressController : function(component, event, helper) {
        
        var getInputkeyWord = component.get("v.SearchKeyWord");
         
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
        
    },
    
   
    clear :function(component,event,helper){
        
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.accountId","");
    },
    
      
    handleComponentEvent : function(component, event, helper) {
        
       	 
        var selectedAccountGetFromEvent = event.getParam("accountByEvent");
        component.set("v.selectedRecord" , selectedAccountGetFromEvent);         
        var accountId = event.getParam("accountId");        
        component.set("v.accountId" , accountId); 
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
                
        var searchRes = component.find("searchRes");
        $A.util.addClass(searchRes, 'slds-is-close');
        $A.util.removeClass(searchRes, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');          
    },
      
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();    
    },
   
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
})