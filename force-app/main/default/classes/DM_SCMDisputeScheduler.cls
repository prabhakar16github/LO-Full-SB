/***********************************************************************************
 * Class Name  : DM_SCMDisputeScheduler
 * Description : This class is to schedule the DM_SCMDisputeSchedulerHandler class.
 * Created By  : Shivangi Srivastava
 * Created Date: 18-02-2020
 * *******************************************************************************/ 
global class DM_SCMDisputeScheduler implements Schedulable {
    public Date dt;
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
            dt = System.today();
        }
        
        if(dt != NULL){
            DM_SCMDisputeSchedulerHandler handler = new DM_SCMDisputeSchedulerHandler(dt);
            handler.scheduleJobs();
        }    
    }
}