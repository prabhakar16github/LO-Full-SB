/***********************************************************************************
 * Class Name  : LRMM_DataArchiveScheduler
 * Description : Scheduler class for 'LRMM_DataArchiveBatch' class
 * Created By  : Prabhakar Joshi
 * Created Date: 1-Apr-2020
 * *******************************************************************************/

global class LRMM_DataArchiveScheduler implements Schedulable{
	global void execute(SchedulableContext sc){
		Database.executeBatch(new LRMM_DataArchiveBatch(),100);
	}
}