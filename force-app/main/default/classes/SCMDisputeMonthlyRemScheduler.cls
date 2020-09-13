/*
	SCMDisputeMonthlyRemScheduler Scheduler class
	Created on 1-May_2018
	Schedule for day 3,4,5,6,7,8,9,10 each month for SCM Dispute notification  

*/
global class SCMDisputeMonthlyRemScheduler implements Schedulable{
	
	public Date dateToday {set; get;}

	global void execute(SchedulableContext sc){
		
		if(!Test.isRunningTest()){
			dateToday = System.today();
		}
		SCMDisputeMonthlyRemHandler.scheduleScmd(dateToday);
	}  
}