/**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Wrapper class for RTH screen
**/
public class MBSF_DataWrapper {

    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Main Wrapper class 
    **/
     public class WrapperDataByMonth implements MBFS_MarkerInterface{
         
        @AuraEnabled public List<MonthWeekFilterData> monthWeekFilterData{get;set;} 
        @AuraEnabled public List<CampaignFilterData> campaignFilterData{get;set;}  
        @AuraEnabled public List<AssigneeData> assigneeData{get;set;}  
        @AuraEnabled public List<AgilityData> agilityData{get;set;}

        @AuraEnabled public ResultSet resultSet{get;set;} 
        @AuraEnabled public List<ChartData> chartData{get;set;}  
        @AuraEnabled public Integer recordCount{get;set;} 
        @AuraEnabled public Boolean isError{get;set;}   
        public WrapperDataByMonth(){} 
        public WrapperDataByMonth(List<MonthWeekFilterData> monthWeekFilterData,List<CampaignFilterData> campaignFilterData,
                                  List<AssigneeData> assigneeData,
                                  List<AgilityData> agilityData, ResultSet resultSet,List<ChartData> chartData,
                                  Integer recordCount){
            
            
            this.monthWeekFilterData = monthWeekFilterData ;
            this.campaignFilterData = campaignFilterData ;                          
            this.assigneeData = assigneeData ;
            this.agilityData = agilityData ;
            this.resultSet = resultSet ;
            this.chartData = chartData ;
            this.recordCount = recordCount ;             
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
    @description:Sub Wrapper class for campaign data
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
    @description:Sub Wrapper class for assignee data
    **/
    public class AssigneeData implements MBFS_MarkerInterface{
        @AuraEnabled public String userId{get;set;}        
        @AuraEnabled public String userName{get;set;}
        public AssigneeData(String userId,String userName){
            this.userId = userId ;
            this.userName = userName ;
        }      
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description:Sub Wrapper class for agility data
    **/
    public class AgilityData implements MBFS_MarkerInterface{
       @AuraEnabled public String columnLabel{get;set;}        
        @AuraEnabled public String columnApiName{get;set;}
        public AgilityData(String columnLabel,String columnApiName){
            this.columnLabel = columnLabel ;
            this.columnApiName = columnApiName ;
        }       
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description:Sub Wrapper class for record cell data
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
        
        public Cell (String fApi, Object fVal, String fType,String fieldLabel) {
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
    @description:Sub Wrapper class for record row data
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
    @description:Sub Wrapper class for contract records 
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
    @description:Sub Wrapper class for chart data 
    **/ 
    public class ChartData implements MBFS_MarkerInterface{
        @AuraEnabled public String label {get;set;}        
        @AuraEnabled public Integer count{get;set;}
              
        public ChartData(String label,Integer count){
            this.label = label ;
            this.count = count ;
        }      
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description:Sub Wrapper class for picklist values
    **/ 
    public class PickListToValueData implements MBFS_MarkerInterface{
        @AuraEnabled public Map<String,List<String>> values {get; set;} 
        @AuraEnabled public Boolean isError{get;set;}
        public PickListToValueData(){}
        public PickListToValueData(Map<String,List<String>>  values) {
            this.values = values;
        }
    }
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description:Sub Wrapper class common data
    **/ 
    public class CommonDataWrapper implements MBFS_MarkerInterface{
        @AuraEnabled public String filter {get; set;} 
        @AuraEnabled public String campaignId {get; set;} 
        @AuraEnabled public String assignedId {get; set;} 
        @AuraEnabled public String agility {get; set;}
        @AuraEnabled public String vehicleMakeInterest {get; set;}
        @AuraEnabled public String residual {get; set;} 
        @AuraEnabled public String sortField {get; set;} 
        @AuraEnabled public Boolean isAscending {get; set;} 
        @AuraEnabled public Integer noOfRecord {get; set;} 
        @AuraEnabled public String globalFilter {get; set;} 
    }
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description:Sub Wrapper class for exception data
    **/ 
    public class CommonExceptionWrapper implements MBFS_MarkerInterface{
        @AuraEnabled public String className {get; set;} 
        @AuraEnabled public String methodName {get; set;} 
        @AuraEnabled public String inputData {get; set;} 
        @AuraEnabled public Exception exceptionObj {get; set;} 
    }
    
}