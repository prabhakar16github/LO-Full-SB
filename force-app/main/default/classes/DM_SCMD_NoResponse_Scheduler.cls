/***********************************************************************************
 * Class Name  : DM_SCMD_NoResponse_Scheduler
 * Description : This class is to schedule the DM_SCMD_NoResponse batch class. Run on 10th day of creation.
 * Created By  : Shivangi Srivastava
 * *******************************************************************************/ 
global class DM_SCMD_NoResponse_Scheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        database.executeBatch(new DM_SCMD_NoResponse());
    }

}