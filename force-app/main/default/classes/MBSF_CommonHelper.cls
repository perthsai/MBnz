/**
    @author: Amarendra Kumar
    @company: Saasfocus
    @description: Common helper class
**/
public With Sharing class MBSF_CommonHelper 
{
    private static string OPEN = 'Open';
    

    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
   
    public static MBSF_DataWrapper.CommonExceptionWrapper createWrapperLogObj(String className,String methodName , 
                                                                              String inputData,Exception exceptionObj)
    {
        MBSF_DataWrapper.CommonExceptionWrapper wrapObj = new MBSF_DataWrapper.CommonExceptionWrapper();
        wrapObj.className = className ; 
        wrapObj.methodName = methodName ;
        wrapObj.inputData  = inputData ; 
        wrapObj.exceptionObj = exceptionObj ;
        return wrapObj;
    }

    
     /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
   
    public static void insertErrorLog(MBSF_DataWrapper.CommonExceptionWrapper wrapObj)
    {
        
        String outPutLogData = 'Message -'+wrapObj.exceptionObj.getMessage() + ' \n StackTrace - '+wrapObj.exceptionObj.getStackTraceString();
        MBFS_Error_Log__c errorObj = new MBFS_Error_Log__c();
        errorObj.Class_Name__c = wrapObj.className ;
        errorObj.MBFS_Input_Data__c = wrapObj.inputData ;
        errorObj.Method_Name__c = wrapObj.methodName ;
        errorObj.MBFS_Output_Data__c  = outPutLogData ;
        insert  errorObj ;      
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
   
    public static String insertErrorLog(String className,String methodName , String inputData,String outputData)
    {
        MBFS_Error_Log__c errorObj = new MBFS_Error_Log__c();
        errorObj.Class_Name__c = className ;
        errorObj.MBFS_Input_Data__c = inputData ;
        errorObj.Method_Name__c = methodName ;
        errorObj.MBFS_Output_Data__c  = outputData ;
        return String.valueOf(errorObj) ;
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    public static boolean isContactId(string recordId)
    {
        if(string.isNotEmpty(recordId))
        {
            string prefix = recordId.substring(0,3);
            if(prefix.equalsIgnoreCase(label.Contract_Prefix_Key))
                return true;
        }
        return false;   
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    public static List<Contract> getContractQueryResult(string query)
    {
        
        List<Contract> contractList = Database.query(query) ; 
        return contractList;    
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName)
    {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        return fieldSetObj.getFields();
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    public static List<Lead> getLeadResult(string query)
    {      
        List<Lead> leadList = Database.query(query) ;
        return leadList;    
    }
    
    
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    public static void updateContract(List<Contract> conList){
        if(conList != null && conList.size() > 0){
            update conList ;
        }
    }    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    public static void updateAccount(List<Account> accountList){
        if(accountList != null && accountList.size() > 0){
            update accountList ;
        }
    }    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    public static void insertTask(List<Task> taskList){
        if(taskList != null && taskList.size() > 0){
            insert taskList ;
        }
    }  
    
   /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    public static Date getDateExecludeWeekend(DateTime dataTimeValue){
        String dayName=dataTimeValue .format('EEEE');
        Date returDate ; 
        if(dayName =='Saturday'){
            returDate = System.today().addDays(+3);                
        }
        else if(dayName =='Sunday'){
            returDate = System.today().addDays(+2);                
        }else {
            returDate = System.today().addDays(+1) ;
        }
        return returDate;
    }      
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    public static Map<String,List<MBSF_RTMDataWrapper.SubOutComeActionData>> getOutComeToSubOutComeMap(List<MBFS_RTH_SubOutComeAndAction__c> subOutComeAndActionList)
    {
        Map<String,List<MBSF_RTMDataWrapper.SubOutComeActionData>> outComeToSubOutCome= new Map<String,List<MBSF_RTMDataWrapper.SubOutComeActionData>>();
        
        for(Integer i = 0 ; i < subOutComeAndActionList.size() ; i++ ){
            
            for(MBFS_RTH_SubOutComeAndAction__c outComeObj : subOutComeAndActionList){
                if(outComeObj.MBFS_Sequence__c == i) {
                    
                    if(outComeToSubOutCome.get(outComeObj.Name) == null){
                        List<MBSF_RTMDataWrapper.SubOutComeActionData> subOutComeList = new List<MBSF_RTMDataWrapper.SubOutComeActionData>();
                        MBSF_RTMDataWrapper.SubOutComeActionData obj = new MBSF_RTMDataWrapper.SubOutComeActionData
                            (outComeObj.MBFS_Sub_Outcome__c,outComeObj.MBFS_Action__c);
                        
                        subOutComeList.add(obj);
                        outComeToSubOutCome.put(outComeObj.Name, subOutComeList);
                    }else{
                        
                        List<MBSF_RTMDataWrapper.SubOutComeActionData> subOutComeList = outComeToSubOutCome.get(outComeObj.Name);
                        MBSF_RTMDataWrapper.SubOutComeActionData obj = new MBSF_RTMDataWrapper.SubOutComeActionData
                            (outComeObj.MBFS_Sub_Outcome__c,outComeObj.MBFS_Action__c);
                        subOutComeList.add(obj);
                        outComeToSubOutCome.put(outComeObj.Name, subOutComeList); 
                    }
                    
                }
            }
        }
        
        return outComeToSubOutCome ;
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    public static MBSF_DataWrapper.ResultSet processResults(String objName, List<Object> sObjects,List<Object> contractColumnData,String globalFilter) {
        Integer totalRows = sObjects.size();
        List<MBSF_DataWrapper.Row> rows = new List<MBSF_DataWrapper.Row>();
        Map<String, Schema.DescribeFieldResult> fieldType = MBSF_CommonHelper.describeFields(objName);
        List<MBSF_DataWrapper.Cell> colNames = new List<MBSF_DataWrapper.Cell>();
        
        
        if(globalFilter == 'MBSF_MONTH' || globalFilter == 'MBSF_CAMPAIGN'){
            
            List<MBSF_ContractColumns__c> columnData = (List<MBSF_ContractColumns__c>) contractColumnData ;
            for(Integer i = 0 ; i < columnData.size() ; i++ )
            {
                for(MBSF_ContractColumns__c contractColumn:columnData)
                {
                    if(contractColumn.MBFS_Sequence__c == i){
                        colNames.add(new MBSF_DataWrapper.Cell(contractColumn.ApiName__c, contractColumn.Name,'',contractColumn.Name));  
                        break ;
                    }
                }    
            }
            
            rows = processResultsRowsForContractAndCampaign(contractColumnData,sObjects,fieldType);
            
            
        } else if(globalFilter == 'MBSF_LEAD'){
            List<MBSF_LeadColumns__c> columnData = (List<MBSF_LeadColumns__c>) contractColumnData ;
            for(Integer i = 0 ; i < columnData.size() ; i++ )
            {
                for(MBSF_LeadColumns__c contractColumn:columnData)
                {
                    if(contractColumn.MBFS_Sequence__c == i){
                        colNames.add(new MBSF_DataWrapper.Cell(contractColumn.ApiName__c, contractColumn.Name,'', contractColumn.Name));  
                        break ;
                    }
                }    
            }
            rows = processResultsRowsForLead(contractColumnData,sObjects,fieldType);
        }
        return new MBSF_DataWrapper.ResultSet(rows, totalRows, colNames, objName);
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    public static List<MBSF_DataWrapper.Row> processResultsRowsForLead(List<Object> contractColumnData,List<Object> sObjects,Map<String, Schema.DescribeFieldResult> fieldType){
        
            List<MBSF_DataWrapper.Row> rows = new List<MBSF_DataWrapper.Row>();
            Map<String,String> apiNameToLable = new Map<String,String>();
            List<MBSF_DataWrapper.Cell> colNames = new List<MBSF_DataWrapper.Cell>();
        
            List<MBSF_LeadColumns__c> columnData = (List<MBSF_LeadColumns__c>) contractColumnData ;
            List<Lead> sObjectsList = (List<Lead>) sObjects ;
            List<String> fields = new List<String>();            
            for(Integer i = 0 ; i < columnData.size() ; i++ )
            {
                for(MBSF_LeadColumns__c contractColumn:columnData)
                {
                    if(contractColumn.MBFS_Sequence__c == i){
                        fields.add(contractColumn.ApiName__c);
                        apiNameToLable.put(contractColumn.ApiName__c,contractColumn.Name);
                        colNames.add(new MBSF_DataWrapper.Cell(contractColumn.ApiName__c, contractColumn.Name,'', contractColumn.Name));  
                        break ;
                    }
                }    
            }
            
            for(Lead temp : sObjectsList) {
                List<MBSF_DataWrapper.Cell> cols = new List<MBSF_DataWrapper.Cell>();
                for (String fld : fields) {
                    String apiName = fld ;
                    fld = fld.trim().toLowerCase();
                    MBSF_DataWrapper.Cell col;                   
                    if (fld.containsAny('(') || fld.containsAny('((')) {
                        fld = fld.substring(fld.lastIndexOfIgnoreCase('(')+1, fld.IndexOfIgnoreCase(')')).trim();
                    }
                    if (fld.contains('.')) {
                        Object fieldVal = getRelatedObjectFieldValue(fld, temp);
                        col = new MBSF_DataWrapper.Cell(fld, fieldVal,  'REFERENCE',apiNameToLable.get(apiName)); //update based object only in release one    
                    } else if (temp.get(fld) != null){
                        col = new MBSF_DataWrapper.Cell(fld, temp.get(fld),  fieldType.get(fld).getType().name(),apiNameToLable.get(apiName));
                    } else {
                        col = new MBSF_DataWrapper.Cell(fld, '',  fieldType.get(fld).getType().name(),apiNameToLable.get(apiName));
                    }
                    
                    cols.add(col);
                }
                rows.add(new MBSF_DataWrapper.Row(cols,temp.Id));
            }
          return rows ;
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    public static List<MBSF_DataWrapper.Row> processResultsRowsForContractAndCampaign(List<Object> contractColumnData,List<Object> sObjects,Map<String, Schema.DescribeFieldResult> fieldType){
            Map<String,String> apiNameToLable = new Map<String,String>();
            List<MBSF_DataWrapper.Row> rows = new List<MBSF_DataWrapper.Row>();
            List<MBSF_DataWrapper.Cell> colNames = new List<MBSF_DataWrapper.Cell>();
            
            List<MBSF_ContractColumns__c> columnData = (List<MBSF_ContractColumns__c>) contractColumnData ;
            List<String> fields = new List<String>();           
            List<Contract> sObjectsList = (List<Contract>) sObjects ;
    
            for(Integer i = 0 ; i < columnData.size() ; i++ )
            {
                for(MBSF_ContractColumns__c contractColumn:columnData)
                {
                    if(contractColumn.MBFS_Sequence__c == i){
                        fields.add(contractColumn.ApiName__c);
                        apiNameToLable.put(contractColumn.ApiName__c,contractColumn.Name);
                        colNames.add(new MBSF_DataWrapper.Cell(contractColumn.ApiName__c, contractColumn.Name,'',contractColumn.Name));  
                        break ;
                    }
                }    
            }
                        
            for(Contract temp : sObjectsList) {
                List<MBSF_DataWrapper.Cell> cols = new List<MBSF_DataWrapper.Cell>();
                for (String fld : fields) {
                    String apiName = fld ;
                    fld = fld.trim().toLowerCase();
                    MBSF_DataWrapper.Cell col;
                                        
                    if (fld.containsAny('(') || fld.containsAny('((')) {
                        fld = fld.substring(fld.lastIndexOfIgnoreCase('(')+1, fld.IndexOfIgnoreCase(')')).trim();
                    }
                    if (fld.contains('.')) {
                        Object fieldVal = getRelatedObjectFieldValue(fld, temp);
                        col = new MBSF_DataWrapper.Cell(fld, fieldVal,  'REFERENCE', apiNameToLable.get(apiName)); //update based object only in release one    
                    } else if (temp.get(fld) != null){
                        col = new MBSF_DataWrapper.Cell(fld, temp.get(fld),  fieldType.get(fld).getType().name(),apiNameToLable.get(apiName));
                    } else {
                        col = new MBSF_DataWrapper.Cell(fld, '',  fieldType.get(fld).getType().name(),apiNameToLable.get(apiName));
                    }
                    
                    cols.add(col);
                }
                rows.add(new MBSF_DataWrapper.Row(cols,temp.Id));
            }  
        return rows ;
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    public static MBSF_RTMDataWrapper.ResultSet processResultsRTM(String objName, List<Object> sObjects,List<Object> contractColumnData) {
        Integer totalRows = sObjects.size();
        List<MBSF_RTMDataWrapper.Row> rows = new List<MBSF_RTMDataWrapper.Row>();
        Map<String, Schema.DescribeFieldResult> fieldType = MBSF_CommonHelper.describeFields(objName);
        List<MBSF_RTMDataWrapper.Cell> colNames = new List<MBSF_RTMDataWrapper.Cell>();
        Map<String,String> apiNameToLable = new Map<String,String>();
        
        
        List<MBFS_RTM_Contract_Column__c> columnData = (List<MBFS_RTM_Contract_Column__c>) contractColumnData ;
        List<Contract> sObjectsList = (List<Contract>) sObjects ;
        List<String> fields = new List<String>();
        
        for(Integer i = 0 ; i < columnData.size() ; i++ )
        {
            for(MBFS_RTM_Contract_Column__c contractColumn:columnData)
            {
                if(contractColumn.MBFS_Sequence__c == i){
                    fields.add(contractColumn.ApiName__c);
                    apiNameToLable.put(contractColumn.ApiName__c,contractColumn.Name);
                    colNames.add(new MBSF_RTMDataWrapper.Cell(contractColumn.ApiName__c, contractColumn.Name,'',contractColumn.Name));  
                    break ;
                }
            }    
        }
        
        
        for(Contract temp : sObjectsList) {
            List<MBSF_RTMDataWrapper.Cell> cols = new List<MBSF_RTMDataWrapper.Cell>();
            for (String fld : fields) {
                String apiName = fld ;
                fld = fld.trim().toLowerCase();
                MBSF_RTMDataWrapper.Cell col;
                
                
                
                if (fld.containsAny('(') || fld.containsAny('((')) {
                    fld = fld.substring(fld.lastIndexOfIgnoreCase('(')+1, fld.IndexOfIgnoreCase(')')).trim();
                }
                if (fld.contains('.')) {
                    Object fieldVal = getRelatedObjectFieldValue(fld, temp);
                    col = new MBSF_RTMDataWrapper.Cell(fld, fieldVal,  'REFERENCE',apiNameToLable.get(apiName)); //update based object only in release one    
                } else if (temp.get(fld) != null){
                    col = new MBSF_RTMDataWrapper.Cell(fld, temp.get(fld),  fieldType.get(fld).getType().name(),apiNameToLable.get(apiName));
                } else {
                    col = new MBSF_RTMDataWrapper.Cell(fld, '',  fieldType.get(fld).getType().name(),apiNameToLable.get(apiName));
                }
                
                cols.add(col);
            }
            rows.add(new MBSF_RTMDataWrapper.Row(cols,temp.Id));
            
            
        } 
        return new MBSF_RTMDataWrapper.ResultSet(rows, totalRows, colNames, objName);
    }
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    public static MBFS_CampaignDataWrapper.ResultSet processResultsCampaign(String objName, List<Object> sObjects, List<Object> contractColumnData) {
        Integer totalRows = sObjects.size() ;
        List<MBFS_CampaignDataWrapper.Row> rows = new List<MBFS_CampaignDataWrapper.Row>();
        Map<String, Schema.DescribeFieldResult> fieldType = MBSF_CommonHelper.describeFields(objName);
        List<MBFS_CampaignDataWrapper.Cell> colNames = new List<MBFS_CampaignDataWrapper.Cell>();
        Map<String,String> apiNameToLable = new Map<String,String>();
        
        
        List<MBFS_CampaignContractColumn__c> columnData = (List<MBFS_CampaignContractColumn__c>) contractColumnData ;
        List<Contract> sObjectsList = (List<Contract>) sObjects ;
        List<String> fields = new List<String>();
        
        for(Integer i = 0 ; i < columnData.size() ; i++ )
        {
            for(MBFS_CampaignContractColumn__c contractColumn:columnData)
            {
                if(contractColumn.MBFS_Sequence__c == i){
                    fields.add(contractColumn.ApiName__c);
                    apiNameToLable.put(contractColumn.ApiName__c,contractColumn.Name);
                    colNames.add(new MBFS_CampaignDataWrapper.Cell(contractColumn.ApiName__c, contractColumn.Name,'', null, false,contractColumn.Name));  
                    break ;
                }
            }    
        }
        
        
        for(Contract temp : sObjectsList) {
            List<MBFS_CampaignDataWrapper.Cell> cols = new List<MBFS_CampaignDataWrapper.Cell>();
            for (String fld : fields) {
                String apiName = fld ;
                fld = fld.trim().toLowerCase();
                MBFS_CampaignDataWrapper.Cell col;
                //System.debug(logginglevel.info,'fld = '+fld+'fieldType.get(fld)= '+fieldType.get(fld));
                List<String> pickVals = new List<String>();
                if (fieldType.get(fld) !=null && fieldType.get(fld).getType().name().equalsIgnoreCase('picklist') && fieldType.get(fld) != null) pickVals = getPicklistValues(fieldType.get(fld).getPicklistValues());
                
                if (fld.containsAny('(') || fld.containsAny('((')) {
                    fld = fld.substring(fld.lastIndexOfIgnoreCase('(')+1, fld.IndexOfIgnoreCase(')')).trim();
                }
                if (fld.contains('.')) {
                    Object fieldVal = getRelatedObjectFieldValue(fld, temp);
                    col = new MBFS_CampaignDataWrapper.Cell(fld, fieldVal,  'REFERENCE', pickVals, false,apiNameToLable.get(apiName)); //update based object only in release one    
                } else if (temp.get(fld) != null){
                    col = new MBFS_CampaignDataWrapper.Cell(fld, temp.get(fld),  fieldType.get(fld).getType().name(), pickVals, fieldType.get(fld).isUpdateable(),apiNameToLable.get(apiName));
                } else {
                    col = new MBFS_CampaignDataWrapper.Cell(fld, '',  fieldType.get(fld).getType().name(), pickVals, fieldType.get(fld).isUpdateable(),apiNameToLable.get(apiName));
                }
                
                cols.add(col);
            }
            rows.add(new MBFS_CampaignDataWrapper.Row(cols,temp.Id));
            
            
        } 
        return new MBFS_CampaignDataWrapper.ResultSet(rows, totalRows, colNames, objName);
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    
    private static Map<String, Schema.DescribeFieldResult> describeFields(String objName) {
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(new List<String>{objName});
        Map<String, Schema.DescribeSObjectResult> childObjects = new Map<String, Schema.DescribeSObjectResult>();
        Map<String, Schema.DescribeFieldResult> fieldResults = new Map<String, Schema.DescribeFieldResult>();
        //describe object
        for(Schema.SObjectField field : results[0].fields.getMap().values()) {
            Schema.DescribeFieldResult fResult = field.getDescribe();
            
            fieldResults.put(fResult.getName().toLowerCase(), fResult);
        }
        return fieldResults;
    }
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    
    private static Object getRelatedObjectFieldValue(String relationshipField, sObject resultObj) {
        Object result = '';
        sObject resultObjData ;
        if (String.isNotBlank(relationshipField) && resultObj != null) {
            List<String> tempLevels = relationshipField.split('\\.');
            String findRelField = tempLevels[tempLevels.size()-1];
            tempLevels.remove(tempLevels.size()-1);
            for (Integer i=0; i<tempLevels.size(); i++) {
                if (resultObj != null)  {
                    resultObjData = resultObj.getsObject(tempLevels[i]);
                }
            }   
            result = resultObjData != null ? resultObjData.get(findRelField) : null;    
        }
        return result;
    }
    
    
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    private static List<String> getPicklistValues(List<Schema.PicklistEntry> pickEntries) {
        List<String> pickVals = new List<String>();
        for (Schema.PicklistEntry pick : pickEntries) {
            pickVals.add(pick.getValue());    
        }
        return pickVals;
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    public static List<Lead> getContractDetailsLead(String contractId) {               
        List<Lead> leadList = [select id,FirstName,LastName,Email,MBFS_CMS_Contract_No__c,Status from Lead where MBFS_CMS_Contract_No__c = :contractId ];            
        return leadList;
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    public static List<Task> getContractDetailsTask(String contractId) {   
        List<Task> taskList = [select id,Subject,ActivityDate,Type,Description,MBFS_OutCome__c,MBFS_Sub_Outcome__c from Task where whatid=: contractId and type='Call' and Status ='Completed' order by ActivityDate desc];      
        return taskList;
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    public static List<MBSF_RTMDataWrapper.ContractDeatils> getContractFieldSet(String contractId,String fieldSetName) {
        Map<String,String> apiNameToLabelMap = new Map<String,String>();
        
        String sqlQuery = 'Select ';
        List<Schema.FieldSetMember> fieldSetMemList = MBSF_CommonHelper.readFieldSet(fieldSetName,'Contract');
        
        for(Integer i= 0 ; i < fieldSetMemList.size() ; i++){
            
            String fieldApiName = '';                
            String typeValue = String.valueOf(fieldSetMemList.get(i).getType());
            
            if(typeValue == 'REFERENCE'){
                
                if(fieldSetMemList.get(i).getFieldPath() == 'AccountId'){
                    fieldApiName = 'Account.Name';
                }else if(fieldSetMemList.get(i).getFieldPath() == 'CustomerSignedId'){
                    fieldApiName = 'CustomerSigned.Name';
                }else if(fieldSetMemList.get(i).getFieldPath() == 'ActivatedById'){
                    fieldApiName = 'ActivatedBy.Name';
                }else if(fieldSetMemList.get(i).getFieldPath() == 'CompanySignedId'){
                    fieldApiName = 'CompanySigned.Name';
                }else if(fieldSetMemList.get(i).getFieldPath() == 'OwnerId'){
                    fieldApiName = 'Owner.Name';
                }else if(fieldSetMemList.get(i).getFieldPath() == 'CreatedById'){
                    fieldApiName = 'CreatedBy.Name';
                }else if(fieldSetMemList.get(i).getFieldPath() == 'LastModifiedById'){
                    fieldApiName = 'LastModifiedBy.Name';
                }else if(fieldSetMemList.get(i).getFieldPath() == 'Pricebook2Id'){
                    fieldApiName = 'Pricebook2.Name';
                }else if(fieldSetMemList.get(i).getFieldPath().contains('__c')){
                    String apiName = fieldSetMemList.get(i).getFieldPath().replace('__c','__r');
                    fieldApiName = apiName +'.Name'; 
                }
                
            }else {
                fieldApiName = fieldSetMemList.get(i).getFieldPath() ;
            }
            
            
            apiNameToLabelMap.put(fieldApiName, fieldSetMemList.get(i).getLabel());
            
            if(i == fieldSetMemList.size() - 1 ){
                sqlQuery = sqlQuery + fieldApiName;
            }else{
                sqlQuery = sqlQuery + fieldApiName + ' , ';
            }  
            
        }
        
        
        sqlQuery = sqlQuery +' from Contract where Id =:contractId' ;
        Contract conObj = Database.query(sqlQuery);
        
        List<MBSF_RTMDataWrapper.ContractDeatils> conDetailsList = new List<MBSF_RTMDataWrapper.ContractDeatils>();
        
        
        for(String apiName : apiNameToLabelMap.keySet()){
            String apiValue = '';
            if(apiName.contains('.')){
                
                List<String> relatedObjList =  apiName.split('\\.');
                
                if(conObj.getSobject(relatedObjList.get(0)) != null){
                    if(relatedObjList.get(1) != null && relatedObjList.get(1) == 'Phone'){
                        apiValue = String.valueOf(conObj.getSobject(relatedObjList.get(0)).get('Phone')) ; 
                    }else if(relatedObjList.get(1) != null && relatedObjList.get(1) == 'Name'){
                        apiValue = String.valueOf(conObj.getSobject(relatedObjList.get(0)).get('Name')) ; 
                    }else if(relatedObjList.get(1) != null && relatedObjList.get(1) == 'PersonMobilePhone'){
                        apiValue = String.valueOf(conObj.getSobject(relatedObjList.get(0)).get('PersonMobilePhone')) ; 
                    }else if(relatedObjList.get(1) != null && relatedObjList.get(1) == 'PersonEmail'){
                        apiValue = String.valueOf(conObj.getSobject(relatedObjList.get(0)).get('PersonEmail')) ; 
                    }else if(relatedObjList.get(1) != null && relatedObjList.get(1) == 'PersonBirthdate'){
                        apiValue = String.valueOf(conObj.getSobject(relatedObjList.get(0)).get('PersonBirthdate')) ; 
                    }else if(relatedObjList.get(1) != null && relatedObjList.get(1) == 'MBFS_Custom_Address__c'){
                        apiValue = String.valueOf(conObj.getSobject(relatedObjList.get(0)).get('MBFS_Custom_Address__c')) ; 
                    }
                    
                } 
               
            }else{
                apiValue = String.valueOf(conObj.get(apiName)) ; 
            }
            String labelvalue = '';
            if(apiNameToLabelMap.get(apiName).contains(' ID')){
                labelvalue = apiNameToLabelMap.get(apiName).replace(' ID','');
            }else {
                labelvalue = apiNameToLabelMap.get(apiName);
            }
            
            
            MBSF_RTMDataWrapper.ContractDeatils obj = new MBSF_RTMDataWrapper.ContractDeatils(labelvalue,apiValue);
            conDetailsList.add(obj);
        }
        return conDetailsList ;
    }
    
    /**
    @author: Amarendra Kumar
    @company: Saasfocus
    */ 
    
    public static List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 
        
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); 
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); 
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); 
        for (Schema.PicklistEntry a : pick_list_values) { 
            lstPickvals.add(a.getValue());
        }
        
        return lstPickvals;
    }
    /** 
    @author:  Lokesh 
    @company: Saasfocus 
    @Description: This utitliy method is used to get record type Id.
    */
    private static Map<String, Schema.SObjectType> mapSObjectSchema;
    public static id getRecordTypeId(string strObjectApiName, string strRecordTypeName)
    {
        // if the object API name is blank or the record type name is blank, return null
        if(IsNullOrEmpty(strObjectApiName) || IsNullOrEmpty(strRecordTypeName))
        {
            return null;
        }
        // if sobjectSchemaMap is null then assign values to it by getGloblaDescribe()
        if(mapSObjectSchema == null) 
        {
            mapSObjectSchema = Schema.getGlobalDescribe();
        }
        // get the describe object result based on given object API Name
        Schema.SObjectType sObjType = mapSObjectSchema.get(strObjectApiName) ;
        Schema.DescribeSObjectResult cfrSchema = sObjType.getDescribe() ;
        // get the map of recordtype info
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        // get the record type id based on given record type name
        Id idRecordType = RecordTypeInfo.get(strRecordTypeName).getRecordTypeId();
        return idRecordType;
    }
    //Checks wheather Null or empty - String 
    public static boolean IsNullOrEmpty(string strInput)
    {
        if(strInput != null && !strInput.trim().equals('')){ return false; }
        return true;
    }
    
    //Checks wheather Null or empty - Decimal
    public static boolean IsNullOrEmpty(Decimal DInput)
    {
        if(DInput == null){ return true; }
        return false;
    }
    
    //Checks wheather Null or empty - Double
    public static boolean IsNullOrEmpty(Double DInput)
    {
        if(DInput == null){ return true; }
        return false;
    }
    
    /** 
    @author:  Amarendra 
    @company: Saasfocus 
    @Description: This utitliy method is used get the RTM resultset.
    */
    
    public static MBSF_RTMDataWrapper.ResultSet rtmResultSetHelper(MBSF_RTMDataWrapper.CommonDataWrapper wrapObj)
    {
        MBSF_RTMDataWrapper.ResultSet resultSet ;
        String suppressvalue =   Label.Suppress_value ;  
        String logedInUserId = userinfo.getUserId();
        
        List<String> campaignIdSet = new List<String>();
        for(Campaign campObj : [select Id,Name from Campaign where isActive = true and ownerid=:logedInUserId]){            
            campaignIdSet.add(campObj.id);
        }
        List<MBFS_RTM_Contract_Column__c> contractColumnData = MBFS_RTM_Contract_Column__c.getall().values();  
        Set<String> columnApiNames = new  Set<String> ();
        
        String soqlQuery = 'select Id ';
        for(MBFS_RTM_Contract_Column__c contractColumn : contractColumnData){               
            soqlQuery = soqlQuery + ' , '+ contractColumn.ApiName__c ;
            columnApiNames.add(contractColumn.ApiName__c);
        }
        // Thow an exception if CS does not contain field name
        if(!columnApiNames.contains(wrapObj.sortField)){
            throw new AuraHandledException(Label.ApiName_No_Access);
        }
        soqlQuery = soqlQuery + ' from Contract where MBFS_Suppress__c= \''+String.escapeSingleQuotes(suppressvalue) +'\'' +' and MBFS_Fleet__c = false and MBFS_Block__c = false and MBFS_Assign_To__c= \''+String.escapeSingleQuotes(logedInUserId)+'\''+' and ownerid=\''+String.escapeSingleQuotes(logedInUserId)+'\'' ;
        
        
        String campaignId = wrapObj.campaignId.trim();
		String dateFilter = wrapObj.dateFilter.trim();
		String sortField = String.escapeSingleQuotes(wrapObj.sortField.trim());
		Integer noOfRecord = (Integer) wrapObj.noOfRecord ;
        Boolean isAscending = (Boolean)wrapObj.isAscending ;
        
        if(campaignId != MBFS_Constant.All && campaignId != MBFS_Constant.None){
            soqlQuery = soqlQuery + ' and MBFS_Campaign__c =\''+String.escapeSingleQuotes(campaignId)+'\'';
        }
        if(campaignId == MBFS_Constant.All && campaignIdSet != null && campaignIdSet.size() > 0){
            soqlQuery = soqlQuery + ' and MBFS_Campaign__c In:campaignIdSet';
        }
        
        if(dateFilter != MBFS_Constant.None){
            if(dateFilter == MBFS_Constant.Today){
                soqlQuery = soqlQuery + ' and MBFS_Last_Activity_Due_Date__c ='+String.valueOf(System.today()) ;
            }else if(dateFilter == MBFS_Constant.Today_OverDue){
                soqlQuery = soqlQuery + ' and (MBFS_Last_Activity_Due_Date__c <= '+String.valueOf(System.today());
                soqlQuery = soqlQuery + ' OR MBFS_Last_Activity_Due_Date__c = null) ';
            }else if(dateFilter == MBFS_Constant.OverDue){
                soqlQuery = soqlQuery + ' and (MBFS_Last_Activity_Due_Date__c <= '+String.valueOf(System.today().addDays(-1));
                soqlQuery = soqlQuery + ' OR MBFS_Last_Activity_Due_Date__c = null) ';
            }else if(dateFilter == MBFS_Constant.MBFS_RTM_FUTURE_DURATION ){
                soqlQuery = soqlQuery + ' and (MBFS_Last_Activity_Due_Date__c > '+String.valueOf(System.today());
                soqlQuery = soqlQuery + ' ) ';
            }
        }     
        
        if (sortField != '') {
            soqlQuery += ' order by ' + sortField;
            if (isAscending) {
                soqlQuery += ' asc NULLS first ';
            } else {
                soqlQuery += ' desc NULLS last ';
            }
        }
        soqlQuery += ' LIMIT '+noOfRecord ;
        
        
        List <Contract> lstResult =  Database.query(soqlQuery);
        
        resultSet =  processResultsRTM('Contract', lstResult,contractColumnData);
        
        return resultSet ;
    }
     /**
        @author: Lokesh Pant
        @company: Saasfocus
        This method is used to return list of task based on filter.
    */
    public static List<task> getListOfTask(string filter)
    {
         string strLoggedInUserId = UserInfo.getUserId();
         string strQuery = 'SELECT WhoId,WhatId,IsClosed,ActivityDate,Status,Subject,Who.Name,What.Name FROM Task where ';
         if(filter=='Overdue'){
            strQuery += ' ActivityDate<TODAY AND Status=:OPEN AND OwnerId =:strLoggedInUserId';
         }
         else if(filter=='Today'){
            strQuery += ' (ActivityDate=TODAY OR (ActivityDate<TODAY AND Status=:OPEN)) AND OwnerId =:strLoggedInUserId';   
         }
         else if(filter=='Today + Overdue'){
            strQuery += ' (ActivityDate=TODAY OR (ActivityDate<TODAY AND Status=:OPEN)) AND OwnerId =:strLoggedInUserId';
         }
         else if(filter=='Next 7 Days'){
            strQuery += ' ActivityDate=NEXT_N_DAYS:7 AND OwnerId =:strLoggedInUserId';
         }
         else if(filter=='Next 7 Days + Overdue'){
            strQuery += ' ((ActivityDate=NEXT_N_DAYS:7) OR (ActivityDate<:TODAY  AND Status=:OPEN)) AND OwnerId = :strLoggedInUserId';
         }
         else if(filter=='This Month'){
            strQuery += 'ActivityDate =THIS_MONTH AND OwnerId = :strLoggedInUserId';
         }
         else if(filter=='All Open'){
            strQuery += ' Status=:OPEN AND OwnerId =:strLoggedInUserId';
         }
         else if(filter=='Tomorrow'){
            strQuery += ' ActivityDate=TOMORROW AND OwnerId =:strLoggedInUserId';
         }
         return database.query(strQuery);
    }
    //Map of Integer , String , which contains number regarding month(String).
    public static Map<Integer, string> monthsMap = new Map<Integer, string>{
      1 => 'January', 
      2 => 'February',
      3 => 'March',
      4 => 'April', 
      5 => 'May', 
      6 => 'June',
      7 => 'July',
      8 => 'August', 
      9 => 'September', 
      10 => 'October',
      11 => 'November',
      12 => 'December'
    };
    /**
	    @author:  Lokesh Pant
	    @company: Saasfocus
    */ 
    public static string getcamapignName(string campaign_Type)
    {
         string year          =  string.valueof(system.today().year());
         string month         =  MBSF_CommonHelper.monthsMap.get(system.today().month()).toUpperCase();     
         return campaign_Type+'_'+month+'_'+year; 
    }
    /**
	    @author:  Lokesh Pant
	    @company: Saasfocus
    */ 
    public static Id getExistingCamapignId(string campaign_Name)
    {
        List<Campaign>lstcampaign = [select id from campaign where mbfs_Campaign_Unique_Name__c=:campaign_Name];
        if(lstcampaign.size()>0)
             return lstcampaign[0].id;
        return null;     
    }
    /**
	    @author:  Lokesh Pant
	    @company: Saasfocus
    */ 
    public static id createCampaign(string campaign_Name,string campaignType)
    {
         campaign objCampaign                        = new campaign();
         objCampaign.Name                            = campaign_Name; 
         objCampaign.mbfs_Campaign_Unique_Name__c    = campaign_Name;
         objCampaign.mbfs_Automatic_Campaign__c      = true; 
         objCampaign.IsActive                        = true;
         objCampaign.StartDate                       = getFirstDateOfMonth();
         objCampaign.EndDate                         = getFirstDateOfMonth().addMonths(2); 
         objCampaign.Months__c                       = campaignType;
         insert objCampaign;
         return objCampaign.id;
    }
    /**
	    @author:  Lokesh Pant
	    @company: Saasfocus
    */ 
    public static date getFirstDateOfMonth()
    {
         return Date.newInstance(system.today().year(), system.today().month(), 1);     
    }
    /**
	    @author: Lokesh Pant
	    @company: Saasfocus
    */ 
    public static MBFS_Campaign_Member__c createCampaignMember(Contract objContract,Id campaignId)
    {
         MBFS_Campaign_Member__c objMember = new MBFS_Campaign_Member__c();
         objMember.MBFS_Campaign__c        = campaignId;
         objMember.MBFS_Contract__c        = objContract.Id;        
         objMember.mbfs_Status__c          = objContract.Status;
         objMember.mbfs_Suppress__c        = objContract.MBFS_Suppress__c;
         return objMember;
    }
}