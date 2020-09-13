/***********************************************************************************
 * Class Name  : DM_SCMD_FirstEscalation_Scheduler
 * Description : This class is to schedule the DM_SCMD_FirstEscalation batch class. Run on 3rd day of record creation.
 * Created By  : Shivangi Srivastava
 * Created Date: 13-02-2020
 * *******************************************************************************/ 
global class DM_SCMD_FirstEscalation_Scheduler implements Schedulable {
    public void execute(SchedulableContext sc){
        Database.executeBatch(new DM_SCMD_FirstEscalation());
    }
}