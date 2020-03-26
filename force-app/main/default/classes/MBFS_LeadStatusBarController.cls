/**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Controller Class for Lead Staus Bar component
**/
public  class  MBFS_LeadStatusBarController 
{
    /** @author:  Lokesh 
        @company: Saasfocus 
        @description: Method is used to load all data on load of component.
    */
    @AuraEnabled
    public static ResultData getData(string object_name,string field_name,string first_value,string leadId)
    {
    	ResultData objData                              = new ResultData();
        objData.lstPicklistValue                        = getPickListValues(object_name,field_name,first_value);
        objData.lstSoldItems                            = getPicklistValues('Lead','MBFS_Sold_Items__c',null);
        objData.lstClosingReasons                       = getPicklistValues('Lead','Close_Reason_Insurance__c',null);
        objData.lstUnderwriters                       = getPicklistValues('Lead','Underwriter__c',null);                
        objData.objLead                                 = getLeadDetail(leadId);
        if(objData.objLead.MBFS_Expected_Delivery_Date__c == null)
        objData.objLead.MBFS_Expected_Delivery_Date__c  = system.today();
        return objData;
    }
    
    
    public class ResultData implements MBFS_MarkerInterface
    {
        @auraEnabled
        public list<string>lstPicklistValue;
        @auraEnabled
        public list<string>lstSoldItems;
        @auraEnabled
        public list<string>lstClosingReasons;
        @auraEnabled
        public list<string>lstUnderwriters;        
        @auraEnabled
        public lead objLead;
        
        public ResultData()
        {
            lstPicklistValue = new List<string>();
            lstSoldItems     = new List<string>();
            objLead          = new lead();
        }
    }
    
    @auraEnabled
    public static void updateLead(lead objLead)
    {
    	update objLead;
    }
    
    
    /** @author:  Lokesh 
        @company: Saasfocus 
        @description: Method is used to update status in the lead object.
    */ 
    @auraEnabled
    public static void updateLeadStatus(string leadId,string newStatus)
    {
        MBSF_DataWrapper.CommonExceptionWrapper exceWrapObj ;
        try
        { 
            Lead objLead   = new Lead(id=leadId);
            objLead.status = newStatus;
            update objLead;
        }
        catch(DmlException ex)
        {
            
            if(ex.getDmlMessage(0).ContainsIgnoreCase('MPE_LeadTrigger: execution of'))
            {
                exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_LeadStatusBarController','updateLeadStatus','',ex);
            	MBSF_CommonHelper.insertErrorLog(exceWrapObj);
            
            }              
            else   
            {
                if(!test.isRunningTest())
                exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_LeadStatusBarController','updateLeadStatus','',ex);
            	MBSF_CommonHelper.insertErrorLog(exceWrapObj);                 
            }
        }
        catch(Exception e)
        {
              exceWrapObj  = MBSF_CommonHelper.createWrapperLogObj('MBFS_LeadStatusBarController','updateLeadStatus','',e);
              MBSF_CommonHelper.insertErrorLog(exceWrapObj);  
        }   
    }
    
    
     /**  
      @author:  Lokesh 
      @company: Saasfocus 
      @Description: This method is used to get lead detail.
  */
    public static Lead getLeadDetail(string leadId)
    {
      List<Lead>lstLead = [select id,status,
                    recordTypeId,MBFS_Completed_Status__c,recordType.Name,email,MBFS_Sold_Items__c,MBFS_Expected_Delivery_Date__c 
                from Lead 
                where id=:leadId];
      if(lstLead <> null && lstLead.size()>0)
      {
        return lstLead[0];
      }
      return new lead();
    }
    
     /** 
      @author:  Lokesh 
      @company: Saasfocus 
      @Description: This method is used to get list of select options.
  */
    public static List<selectOption> getSelectListOptions(Sobject object_name, String field_name, String first_val) 
    {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        if (first_val != null) { //if there is a first value being provided
             options.add(new selectOption(first_val, first_val)); //add the first option
        }
        Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
                      
                options.add(new selectOption(a.getValue(), a.getLabel())); //add the value and label to our final list
        }
        return options; //return the List
    }
    /** 
      @author:  Lokesh 
      @company: Saasfocus 
      @Description: This method is used to get list of select list values.
  */
    public static list<string> getPickListValues(string strObjectName, String field_name, String first_val)
    {
        List<string>lstPicklistValues     = new List<string>();
        Schema.SObjectType sObject_Type    = Schema.getGlobalDescribe().get(strObjectName);
        Sobject object_name               = sObject_Type.newSObject();
        List<selectOption> select_Options = getSelectListOptions(object_name,field_name,first_val);
        if(select_Options <> null && select_Options.size()>0)
        {
            for (selectOption option : select_Options) //for all values in the picklist list
            {         
                lstPicklistValues.add(option.getValue()); //add the value and label to our final list
            }
        }
        return lstPicklistValues;
    }
}