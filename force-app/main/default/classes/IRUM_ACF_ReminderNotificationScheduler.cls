global class IRUM_ACF_ReminderNotificationScheduler implements Schedulable {
	global void execute(SchedulableContext sc){
       
       
       Date nextDate; 
       Database.executeBatch(new IRUM_ACF_ReminderNotificationBatch(),10); 
        if(!test.isRunningTest())
            nextDate = System.today().addDays(1);
		else
            nextDate = Date.newInstance(System.today().year(),System.today().month() , 05);
        
        if(nextDate.day() <= 10){//change to 10 after testing
            scheduleNext(nextDate);
        }
    }
    public static void scheduleNext(Date dt){
        
                
        String nextDayExp = '0 0 0 ' + dt.day() + ' * ' + ' ? ' + dt.year();
        
        
        IRUM_ACF_ReminderNotificationScheduler reminderBatch = new IRUM_ACF_ReminderNotificationScheduler();
        if(!test.isRunningTest())
            system.schedule('IRUM_ACF_Reminder for day'+dt.day(), nextDayExp ,reminderBatch);
        
    }
}