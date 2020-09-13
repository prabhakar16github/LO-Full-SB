public class DM_SCMDMonthlyReminderScheduler implements Schedulable {
    public Date dateToday {set; get;}

	public void execute(SchedulableContext sc){
		
		if(!Test.isRunningTest()){
			dateToday = System.today();
		}
		DM_SCMDMonthlyReminderHandler.scheduleScmd(dateToday);
	}  
}