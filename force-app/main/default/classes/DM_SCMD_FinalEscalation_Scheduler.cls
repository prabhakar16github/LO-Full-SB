/***********************************************************************************
 * Class Name  : DM_SCMD_FinalEscalation_Scheduler
 * Description : This class is to schedule the DM_SCMD_FinalEscalation batch class.Run for 6th to 9th day of record creation.
 * Created By  : Shivangi Srivastava
 * *******************************************************************************/ 
global class DM_SCMD_FinalEscalation_Scheduler implements Schedulable{
	public void execute(SchedulableContext sc){
        Database.executeBatch(new DM_SCMD_FinalEscalation());
    }
}