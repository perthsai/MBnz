/**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Wrapper class for campaign member screen
**/

public class MBFS_CampaignDataWrapper {

    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Main Wrapper class 
    **/
    public class WrapperData implements MBFS_MarkerInterface{
         
        @AuraEnabled public List<MonthWeekFilterData> monthWeekFilterData{get;set;} 
        @AuraEnabled public List<CampaignData> campaignData{get;set;} 
        @AuraEnabled public ResultSet resultSet{get;set;}      
        @AuraEnabled public Integer recordCount{get;set;} 
        @AuraEnabled public Boolean isError{get;set;}
        public WrapperData(){}
        public WrapperData(List<MonthWeekFilterData> monthWeekFilterData,List<CampaignData> campaignData ,
                                  ResultSet resultSet,Integer recordCount){            
            this.monthWeekFilterData = monthWeekFilterData ;  
            this.campaignData = campaignData ;                          
            this.resultSet = resultSet ;
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
    public class CampaignData implements MBFS_MarkerInterface{
        @AuraEnabled public String columnLabel{get;set;}        
        @AuraEnabled public String columnApiName{get;set;}
        public CampaignData(String columnLabel,String columnApiName){
            this.columnLabel = columnLabel ;
            this.columnApiName = columnApiName ;
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
        
        public Cell (String fApi, Object fVal, String fType, List<String> pickVal, boolean readOnly,String fieldLabel) {
        	this.fieldApi = fApi;
            this.fieldType = fType;
            this.fieldValue = fVal;
            this.isWritable = readOnly;
            this.pickValues = pickVal;
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
    @description:Sub Wrapper class for all campaign member records
    **/
    public class ResultSet implements MBFS_MarkerInterface{
        @AuraEnabled public List<Row> rows {get; set;}
        @AuraEnabled public Integer size {get; set;}
        @AuraEnabled public List<Cell> columnHeader {get; set;}
        @AuraEnabled public Boolean isError{get;set;}
        public ResultSet(List<Row> rw, Integer siz, List<Cell> ch, String obName) {
        	this.rows = rw;
            this.size = siz;
            this.columnHeader = ch;
        }
    }
   
   /**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description:Sub Wrapper class for common data
   **/ 
   public class CommonDataWrapper implements MBFS_MarkerInterface{
        @AuraEnabled public String sortField {get; set;} 
        @AuraEnabled public Boolean isAscending {get; set;} 
        @AuraEnabled public Integer noOfRecord {get; set;} 
        @AuraEnabled public String campaignId {get; set;} 
    }
    
}