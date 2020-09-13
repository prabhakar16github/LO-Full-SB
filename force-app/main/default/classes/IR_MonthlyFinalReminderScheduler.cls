global class IR_MonthlyFinalReminderScheduler implements Schedulable {

    global void execute(SchedulableContext ctx) {
    	
    	Date todaysDate = System.today();
    	String month = String.valueOf(todaysDate.month());
        
        if(month.length() == 1){
        	month = '0' + month; // format month
        }
        String reportingPeriod = todaysDate.year() +'-'+ month;
        Database.executeBatch(new IR_MonthlyFinalReminder(reportingPeriod), 10);
        List<IR_FinalReminderExecutionDate__c> executionDateSettings = IR_FinalReminderExecutionDate__c.getall().values(); 
        IR_FinalReminderExecutionDate__c executionDateSetting;
        if(!executionDateSettings.isEmpty()){
        	executionDateSetting = executionDateSettings.get(0);
        }else{
        	executionDateSetting = new IR_FinalReminderExecutionDate__c();
        }
        executionDateSetting.Name = 'IR_MonthlyFinalReminderScheduler';
        executionDateSetting.IR_Date_Executed__c = system.today();
        upsert executionDateSetting; 
        IR_MonthlyFinalReminderScheduler.scheduleIRSchedulers(executionDateSetting);
    }
    
    public static void scheduleIRSchedulers(IR_FinalReminderExecutionDate__c executionDateSetting){
    	Date finalReminderExecutedDate = executionDateSetting.IR_Date_Executed__c; 
    	List<IR_JobsNeedToAbort__c> needToAbortJobs = IR_JobsNeedToAbort__c.getAll().Values();
    	
    	if(!needToAbortJobs.isEmpty()){
    		for(IR_JobsNeedToAbort__c needToAbortJobSetting : needToAbortJobs){
    			System.abortJob(needToAbortJobSetting.Job_Id__c);
    		}
    		delete needToAbortJobs;
    	}
    	IR_MonthlyFinalEscalationScheduler finalEscalationScheduleJob = new IR_MonthlyFinalEscalationScheduler(); 
    	IR_MonthlyNoResponseBatchScheduler noResponseScheduleJob = new IR_MonthlyNoResponseBatchScheduler();
    	Date dayOne = finalReminderExecutedDate.addDays(1);
    	Date dayTwo = finalReminderExecutedDate.addDays(2);
    	Date dayThree = finalReminderExecutedDate.addDays(3);
    	Date dayFour = finalReminderExecutedDate.addDays(4);
    	String finalEscalationCronExpresionDayOne = '0 0 0 ' + dayOne.day() + ' * ' + ' ? ' + dayOne.year();
    	String finalEscalationCronExpresionDayTwo = '0 0 0 ' + dayTwo.day() + ' * ' + ' ? ' + dayTwo.year();
    	String finalEscalationCronExpresionDayThree = '0 0 0 ' + dayThree.day() + ' * ' + ' ? ' + dayThree.year();
    	String noResponseSchedulerCronExpresionDayThree = '0 0 0 ' + dayFour.day() + ' * ' + ' ? ' + dayFour.year();
    	
    	String dayOneJobId = system.schedule('IR_FinalEscalationSchedulerDayOne', finalEscalationCronExpresionDayOne, finalEscalationScheduleJob);
    	String dayTwoJobId = system.schedule('IR_FinalEscalationSchedulerDayTwo', finalEscalationCronExpresionDayTwo, finalEscalationScheduleJob);
		String dayThreeJobId = system.schedule('IR_FinalEscalationSchedulerDayThree', finalEscalationCronExpresionDayThree, finalEscalationScheduleJob);
		String dayForthJobId = system.schedule('IR_MonthlyNoResponseBatchScheduler', noResponseSchedulerCronExpresionDayThree, noResponseScheduleJob);
		
		needToAbortJobs = new List<IR_JobsNeedToAbort__c>();
		needToAbortJobs.add(new IR_JobsNeedToAbort__c(Name = 'IR_FinalEscalationSchedulerDayOne', Job_Id__c = dayOneJobId));
		needToAbortJobs.add(new IR_JobsNeedToAbort__c(Name = 'IR_FinalEscalationSchedulerDayTwo', Job_Id__c = dayTwoJobId));
		needToAbortJobs.add(new IR_JobsNeedToAbort__c(Name = 'IR_FinalEscalationSchedulerDayThree', Job_Id__c = dayThreeJobId));
		needToAbortJobs.add(new IR_JobsNeedToAbort__c(Name = 'IR_MonthlyNoResponseBatchScheduler', Job_Id__c = dayForthJobId)); 
		insert needToAbortJobs;
    }
    
}