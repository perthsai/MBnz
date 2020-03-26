/**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Wrapper class for RTM screen
**/
public class MBSF_RTMDataWrapper {
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Main Wrapper class 
    **/
    public class WrapperDataByMonth implements MBFS_MarkerInterface{
         
        @AuraEnabled public List<MonthWeekFilterData> monthWeekFilterData{get;set;} 
        @AuraEnabled public List<CampaignFilterData> campaignFilterData{get;set;}         
        @AuraEnabled public ResultSet resultSet{get;set;} 
        @AuraEnabled public List<TaskDurationData> taskDurationDataData{get;set;} 
        @AuraEnabled public Integer recordCount{get;set;} 
        @AuraEnabled public Date nextTaskDate{get;set;} 
        @AuraEnabled public Boolean isError{get;set;} 
        public WrapperDataByMonth(){}
        public WrapperDataByMonth(List<MonthWeekFilterData> monthWeekFilterData,List<CampaignFilterData> campaignFilterData,
                                  ResultSet resultSet,List<TaskDurationData> taskDurationDataData,Integer recordCount,Date nextTaskDate){            
            this.monthWeekFilterData = monthWeekFilterData ;
            this.campaignFilterData = campaignFilterData ;                                                           
            this.resultSet = resultSet ;
            this.taskDurationDataData = taskDurationDataData ;  
            this.recordCount = recordCount ;   
            this.nextTaskDate = nextTaskDate ;                          
        }
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Sub Wrapper class for Month week data
    **/
    public class MonthWeekFilterData implements MBFS_MarkerInterface{
        @AuraEnabled public String columnLabel{get;set;}        
        @AuraEnabled public String columnApiName{get;set;}
        public MonthWeekFilterData(String columnLabel,String columnApiName){
            this.columnLabel = columnLabel ;
            this.columnApiName = columnApiName ;
        }      
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Sub Wrapper class for campaign data
    **/
    public class CampaignFilterData implements MBFS_MarkerInterface{
        @AuraEnabled public String campaignId{get;set;}        
        @AuraEnabled public String campaignName{get;set;}
        public CampaignFilterData(String campaignId,String campaignName){
            this.campaignId = campaignId ;
            this.campaignName = campaignName ;
        }      
    }
    
   /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description:Sub Wrapper class for campaign member records cell
    **/ 
   public class Cell implements MBFS_MarkerInterface{
  		@AuraEnabled public String fieldApi {get; set;}
        @AuraEnabled public String fieldType {get; set;}
        @AuraEnabled public Object fieldValue {get; set;}
        @AuraEnabled public Long unixTime {get; set;}
        @AuraEnabled public Decimal currencyVal {get; set;}
        @AuraEnabled public List<String> pickValues {get; set;}
        @AuraEnabled public boolean isWritable {get; set;}
        @AuraEnabled public String fieldLabel {get; set;}
        
        public Cell (String fApi, Object fVal, String fType, String fieldLabel) {
        	this.fieldApi = fApi;
            this.fieldType = fType;
            this.fieldValue = fVal;
           
            this.fieldLabel = fieldLabel ;
            if (fType.equalsIgnoreCase('datetime') && this.fieldValue instanceof Datetime && this.fieldValue !=null) {
            	
                Datetime temp = Datetime.valueOf(this.fieldValue);
                this.unixTime =	temp.getTime();
                fieldValue = date.newinstance(temp.year(), temp.month(), temp.day());
            }
            if (fType.equalsIgnoreCase('currency') && this.fieldValue instanceof Decimal && this.fieldValue !=null) {
            	
                this.currencyVal = (Decimal)this.fieldValue;
            }
        }
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description:Sub Wrapper class for campaign member records row
    **/
    public class Row implements MBFS_MarkerInterface{
        @AuraEnabled public List<Cell> fields {get; set;}  
        @AuraEnabled public String contractId {get; set;}   
        @AuraEnabled public Boolean isSelected {get; set;} 
        public Row(List<Cell> cols,String contractId) {
            this.fields = cols;
            this.contractId = contractId ;
            isSelected = false ;
        }
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description:Sub Wrapper class for all contract records
    **/
    public class ResultSet implements MBFS_MarkerInterface{
        @AuraEnabled public List<Row> rows {get; set;}
        @AuraEnabled public Integer size {get; set;}
        @AuraEnabled public List<Cell> columnHeader {get; set;}
        @AuraEnabled public Boolean isError{get;set;}
        public ResultSet(){}
        public ResultSet(List<Row> rw, Integer siz, List<Cell> ch, String obName) {
        	this.rows = rw;
            this.size = siz;
            this.columnHeader = ch;
        }
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description:Sub Wrapper class for task duration data
    **/
    
    public class TaskDurationData implements MBFS_MarkerInterface{
        @AuraEnabled public String taskLabel {get; set;} 
        @AuraEnabled public String taskApiName {get; set;} 
        public TaskDurationData(String taskLabel, String taskApiName) {
        	this.taskLabel = taskLabel;
            this.taskApiName = taskApiName;
        }
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description:Sub Wrapper class for contract related list data
    **/
    public class ContractDeatilsData implements MBFS_MarkerInterface{
        @AuraEnabled public List<ContractDeatils> conObjFinance {get; set;} 
        @AuraEnabled public List<ContractDeatils> conObjBorrower {get; set;}        
        @AuraEnabled public List<ContractDeatils> conObjRTMDetails {get; set;}
        @AuraEnabled public List<ContractDeatils> conObjCustomerIntention {get; set;}
        
        
        @AuraEnabled public List<Task> taskList {get; set;} 
        @AuraEnabled public List<Lead> leadList {get; set;} 
        @AuraEnabled public List<MBFS_Diary_Notes__c> diaryNotesList {get; set;} 
        
        @AuraEnabled public List<MBFS_Contract_Account_Junction__c> guarantorList {get; set;} 
        @AuraEnabled public List<mbfs_Insurance__c> insuranceList {get; set;}    
        
        @AuraEnabled public List<MBFS_Customer_Intention__c> customerIntentionList {get; set;}
        @AuraEnabled public Boolean isDoNotCall {get; set;} 
        @AuraEnabled public Boolean isError{get;set;} 
        
        public ContractDeatilsData(){}
        public ContractDeatilsData(List<ContractDeatils> conObjFinance,List<ContractDeatils> conObjBorrower,
                                   List<ContractDeatils> conObjRTMDetails, List<ContractDeatils> conObjCustomerIntention,                                 
                                   List<Task> taskList,List<Lead> leadList,Boolean isDoNotCall,
                                   List<MBFS_Diary_Notes__c> diaryNotesList,List<MBFS_Contract_Account_Junction__c> guarantorList,
                                   List<mbfs_Insurance__c> insuranceList,List<MBFS_Customer_Intention__c> customerIntentionList) {
        	this.conObjFinance = conObjFinance;
            this.conObjBorrower = conObjBorrower;
            
            this.conObjRTMDetails = conObjRTMDetails; 
            this.conObjCustomerIntention = conObjCustomerIntention ;                         
            this.taskList = taskList;
            this.leadList = leadList ;
            this.isDoNotCall = isDoNotCall ;  
            this.diaryNotesList = diaryNotesList ;   
            this.guarantorList =guarantorList ;
            this.insuranceList = insuranceList ;
            this.customerIntentionList = customerIntentionList ;                           
        }
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description:Sub Wrapper class for contract details
    **/
    public class ContractDeatils implements MBFS_MarkerInterface{
        @AuraEnabled public String label {get; set;}
        @AuraEnabled public String value {get; set;}
        public ContractDeatils(String label,String value) {
        	this.label = label;
            this.value = value;
        }
    }
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description:Sub Wrapper class for task
    **/
    public class NewEditTaskData implements MBFS_MarkerInterface{
        @AuraEnabled public Task taskObj {get; set;} 
        @AuraEnabled public Map<String,List<SubOutComeActionData>> outComeToSubOutCome{get; set;} 
        @AuraEnabled public Contract conObj {get; set;} 
        @AuraEnabled public Boolean isError{get;set;} 
        public NewEditTaskData(){}
        public NewEditTaskData(Task taskObj, Map<String,List<SubOutComeActionData>> outComeToSubOutCome,Contract conObj) {
        	this.taskObj = taskObj;
            this.outComeToSubOutCome = outComeToSubOutCome;
            this.conObj = conObj ;
        }
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description:Sub Wrapper class for outcome and sub-outcome
    **/
    public class SubOutComeActionData implements MBFS_MarkerInterface{
        @AuraEnabled public String subOutCome {get; set;} 
        @AuraEnabled public String action {get; set;} 
        public SubOutComeActionData(String subOutCome, String action) {
        	this.subOutCome = subOutCome;
            this.action = action;
        }
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description:Sub Wrapper class for picklist values
    **/
    public class RTMPickListValues implements MBFS_MarkerInterface{
        @AuraEnabled public Map<String,MBSF_RTMDataWrapper.PickListToValueData> rtmPickListToValueData {get; set;} 
        @AuraEnabled public Boolean isError{get;set;} 
        public RTMPickListValues(){}
        public RTMPickListValues(Map<String,MBSF_RTMDataWrapper.PickListToValueData> rtmPickListToValueData) {
            this.rtmPickListToValueData = rtmPickListToValueData;
        }
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description:Sub Wrapper class for picklist values
    **/
    public class PickListToValueData implements MBFS_MarkerInterface{
        @AuraEnabled public List<String> values {get; set;} 
        @AuraEnabled public Boolean isError{get;set;} 
        public PickListToValueData(List<String> values) {
            this.values = values;
        }
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description:Sub Wrapper class for common data
    **/
    public class CommonDataWrapper implements MBFS_MarkerInterface{
        @AuraEnabled public String filter {get; set;} 
        @AuraEnabled public String campaignId {get; set;} 
        @AuraEnabled public String dateFilter {get; set;} 
        @AuraEnabled public String sortField {get; set;} 
        @AuraEnabled public Boolean isAscending {get; set;} 
        @AuraEnabled public Integer noOfRecord {get; set;} 
    }
}