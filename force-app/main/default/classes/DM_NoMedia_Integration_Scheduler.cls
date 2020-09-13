/***********************************************************************************
 * Class Name  : DM_NoMedia_Integration_Scheduler
 * Description : Scheduler class for DM_NoMedia_Integration.
 * Created By  : Prabhakar Joshi
 * Created Date: 27-Jan-2020
 * *******************************************************************************/

global class DM_NoMedia_Integration_Scheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        String fromDate = String.valueOf(System.today().addDays(-1)).split(' ')[0];
        DM_NoMedia_Integration.getData(fromDate);
    }
}