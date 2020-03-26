/**
    @author: Lokesh Pant
    @company: Saasfocus
    @description: Controller Class for Task Component 
**/ 
public class MBFS_TaskComponentController {
    /**
    @author: Lokesh Pant
    @company: Saasfocus
    */ 
    @AuraEnabled
    public static List<Task> getTasksMethod(String filter)
    {
        return MBSF_CommonHelper.getListOfTask(filter);
    }
}