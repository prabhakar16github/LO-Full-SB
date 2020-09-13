global class SCMD_ScheduleMonthlyJobs implements Schedulable {
	
    global void execute(SchedulableContext ctx) {
    	SCMD_ScheduleMonthlyHandler.scheduleMonthlyJob();
    }
}