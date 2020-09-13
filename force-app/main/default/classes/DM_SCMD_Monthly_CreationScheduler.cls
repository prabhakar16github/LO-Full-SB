/***********************************************************************************
 * Class Name  : DM_SCMD_Monthly_CreationScheduler
 * Description : This class is to schedule the DM_SCMD_Monthly_CreationBatch class. Run on 1st of each month
 * Created By  : Shivangi Srivastava
 * Created Date: 13-02-2020
 * *******************************************************************************/ 
global class DM_SCMD_Monthly_CreationScheduler implements Schedulable {
    
    
    global void execute(SchedulableContext sc){
        Database.executeBatch(new DM_SCMD_Monthly_CreationBatch()); 
        
    }
}