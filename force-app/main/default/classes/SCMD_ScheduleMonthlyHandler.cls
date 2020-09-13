public class SCMD_ScheduleMonthlyHandler {
	/*
		current date represents the next month date
	*/
    
    public static Map<String, Integer> currentDayByDayOfWeek = new Map<String, Integer>{'Sunday' => 0, 'Monday' => 1, 'Tuesday' => 2, 'Wednesday' => 3,
    																						'Thursday' => 4, 'Friday' => 5, 'Saturday' => 6};
    																						
	public static final String DAYONESCHEDULERNAME = 'SCMD_MonthlyInitialScheduler';
	public static final String FAILEDJOBID = '000000000000000000';
	public static final String SCMD_MONTHLY_ESCALATION_SCHEDULER_NAME = 'SCMD_Escalation';
	public static Date currentDate {set; get;}
	
	public static void scheduleMonthlyJob(){
		Map<String, Batch_Job_Setting__c> batchJobSettings = Batch_Job_Setting__c.getAll();
    	if(!batchJobSettings.isEmpty()){
	    	delete batchJobSettings.values(); 
    	}
    	// schedule day one    
		Batch_Job_Setting__c batchJobSetting = scheduleMonthlyInitial();
		insert batchJobSetting;
		//schedule rest
		Boolean isScheduled = scheduleMonthlyRestSCMDProcess(batchJobSetting);
	}  
    
    @TestVisible
    private static Batch_Job_Setting__c scheduleMonthlyInitial(){
    	Batch_Job_Setting__c batchJobSetting = new Batch_Job_Setting__c(); 
    	Date expectedDayOneScheduleDate;
    	Date actualDayOneScheduleDate;
    	Integer noOfDaysShifted = 0;
    	Decimal noOfTimesExecuted = 0;
		Map<String, Pam_Batch_Details__c> pam_Batch_DetailsMap = Pam_Batch_Details__c.getAll();
		
		Pam_Batch_Details__c pamBatchDetails = new Pam_Batch_Details__c();

		try{
			noOfTimesExecuted = getNoOfTimesExecuted(pam_Batch_DetailsMap, DAYONESCHEDULERNAME);
			if(currentDate == null){
				currentDate = System.today().addMonths(1).toStartOfMonth();
			}
			Datetime currentDateTime = Datetime.newInstance(currentDate.year(), currentDate.month(), currentDate.day());
			actualDayOneScheduleDate = getDayOneDate(currentDateTime);
			expectedDayOneScheduleDate = Date.newInstance(currentDate.year(), currentDate.month(), 1);
			noOfDaysShifted = daysShifted(expectedDayOneScheduleDate, actualDayOneScheduleDate);
			String cronExpresion = '0 0 0 '+actualDayOneScheduleDate.day()+' * ? *';
			String jobId;
			if(!Test.isRunningTest()){
				jobId = System.schedule('SCMD_MonthlyInitialScheduler', cronExpresion, new SCMDisputeMonthlyScheduler());
			}else{
	    		jobId = '1234thyjikny789654';
	    	}
			pamBatchDetails = getPamBatchDetails(jobId, noOfTimesExecuted);
			   
		}catch(Exception ex){
			pamBatchDetails.Is_Success__c = false;
			pamBatchDetails.Batch_Id__c = FAILEDJOBID;
			pamBatchDetails.Exception_Message__c = ex.getMessage();
			pamBatchDetails.Stack_Trace__c = ex.getStackTraceString();
			pamBatchDetails.No_Of_Times_Executed__c = noOfTimesExecuted;
		}finally{
			pamBatchDetails.Name = DAYONESCHEDULERNAME;
			insert pamBatchDetails;
		}
		
		batchJobSetting.Actual_Date_To_Run__c = actualDayOneScheduleDate;
		batchJobSetting.Expected_Run_Date__c = expectedDayOneScheduleDate;
		batchJobSetting.Days_Shifted__c = noOfDaysShifted; 
		batchJobSetting.Current_Day__c = 1;
		batchJobSetting.name = 'SCMDisputeMonthlyScheduler';
		
		system.debug('expectedDayOneScheduleDate '+expectedDayOneScheduleDate);
		system.debug('actualDayOneScheduleDate '+actualDayOneScheduleDate);
		system.debug('batchJobSetting '+JSON.serialize(actualDayOneScheduleDate));
		return batchJobSetting;
    }
    
    @TestVisible
    private static Boolean scheduleMonthlyRestSCMDProcess(Batch_Job_Setting__c batchJobSetting){
    	Boolean isScheduled = false;
    	Pam_Batch_Details__c pamBatchDetails = new Pam_Batch_Details__c();
    	Map<String, Pam_Batch_Details__c> pam_Batch_DetailsMap = Pam_Batch_Details__c.getAll();
    	Map<String, Batch_Job_Setting__c> batchJobSettingsMap = new Map<String, Batch_Job_Setting__c>();
		Decimal noOfTimesExecuted = 0;
    	try{
	    	setFirstEscalationNotificationDates(batchJobSetting, batchJobSettingsMap);
	    	system.debug('batchJobSettingsMap 1 '+JSON.serialize(batchJobSettingsMap));
	    	setSecondEscalationDates(batchJobSettingsMap.get('SCMD_FirstEscalationDayThree'), batchJobSettingsMap);
	    	system.debug('batchJobSettingsMap 2 '+JSON.serialize(batchJobSettingsMap));
	    	setFinalEscalationDates(batchJobSettingsMap.get('SCMD_SecondEscalation_DayFive'), batchJobSettingsMap);
	    	system.debug('batchJobSettingsMap 3 '+JSON.serialize(batchJobSettingsMap));
	    	setNoResponseFirmNotificationDates(batchJobSettingsMap.get('SCMD_FinalEscalation_DayNine'), batchJobSettingsMap);
	    	system.debug('batchJobSettingsMap 4 '+JSON.serialize(batchJobSettingsMap));
	    	insert batchJobSettingsMap.values();
	    	
	    	noOfTimesExecuted = getNoOfTimesExecuted(pam_Batch_DetailsMap, SCMD_MONTHLY_ESCALATION_SCHEDULER_NAME);
	    	Date initialFirstEscalationDate = batchJobSettingsMap.get('SCMD_FirstEscalationDayThree').Actual_Date_To_Run__c;
	    	Date endEscalationDate = batchJobSettingsMap.get('SCMD_NoResponse_DayTen').Actual_Date_To_Run__c;
	    	String cronExpression = getRestSCMDCronExpression(initialFirstEscalationDate, endEscalationDate);
	    	String jobId;
	    	if(!Test.isRunningTest()){
	    		jobId = System.schedule(SCMD_MONTHLY_ESCALATION_SCHEDULER_NAME, cronExpression, new SCMDisputeMonthlyRemScheduler());
	    	}else{
	    		jobId = '1234th98ikny789687';
	    	}
	    	pamBatchDetails = getPamBatchDetails(jobId, noOfTimesExecuted);
	    	isScheduled = true;
	    	system.debug('batchJobSettingsMap '+JSON.serialize(batchJobSettingsMap));
	    	
    	}catch(Exception ex){
    		pamBatchDetails.Is_Success__c = false;
			pamBatchDetails.Batch_Id__c = FAILEDJOBID;
			pamBatchDetails.Exception_Message__c = ex.getMessage();
			pamBatchDetails.Stack_Trace__c = ex.getStackTraceString();
			pamBatchDetails.No_Of_Times_Executed__c = noOfTimesExecuted;
    		isScheduled = false;
    		system.debug('SCMD_ScheduleMonthlyHandler scheduleMonthlyRestSCMDProcess '+ex);
    		system.debug('SCMD_ScheduleMonthlyHandler scheduleMonthlyRestSCMDProcess ex get stack trace '+ex.getStackTraceString());
    	}finally{
    		pamBatchDetails.Name = SCMD_MONTHLY_ESCALATION_SCHEDULER_NAME;
			insert pamBatchDetails;
    	}
    	
    	return isScheduled;
    }
    
    @TestVisible
    private static Pam_Batch_Details__c getPamBatchDetails(String jobId, Decimal noOfTimesExecuted){
    	Pam_Batch_Details__c pamBatchDetails = new Pam_Batch_Details__c();
    	pamBatchDetails.Batch_Id__c = jobId;
		pamBatchDetails.No_Of_Times_Executed__c = noOfTimesExecuted + 1;
		pamBatchDetails.Is_Success__c = true; 
		return pamBatchDetails;
    }
    
    @TestVisible
    private static String getRestSCMDCronExpression(Date initialFirstEscalationDate, Date endEscalationDate){
    	String cronExpression = '';
    	cronExpression += '0 0 0 ';
    	Integer initialDay = initialFirstEscalationDate.day();
    	Integer endDay = endEscalationDate.day();
    	
    	for(Integer i = initialDay; i <= endDay; i++ ){
    		cronExpression += i+',';
    	}
    	
    	cronExpression = cronExpression.removeEnd(',');
    	cronExpression += ' * ? *';
    	return cronExpression;
    }
    
    @TestVisible
    private static Decimal getNoOfTimesExecuted(Map<String, Pam_Batch_Details__c> pam_Batch_DetailsMap, String schedulerName){
    	
    	Decimal noOfTimesExecuted = 0;
    	Pam_Batch_Details__c existingBatchDetails = pam_Batch_DetailsMap.get(schedulerName);
    	if(existingBatchDetails != null){
			Id existingJobId = existingBatchDetails.Batch_Id__c;
	    	List<CronTrigger> cronTriggers = [SELECT Id FROM CronTrigger WHERE Id = :existingJobId];
			if(!cronTriggers.isEmpty()){
				CronTrigger cronTrigger = cronTriggers.get(0); 
				noOfTimesExecuted = existingBatchDetails.No_Of_Times_Executed__c;
				abortExistingScheduler(cronTrigger.Id);
			}
			delete existingBatchDetails;
		}
		
		return noOfTimesExecuted;
    }
    
    @TestVisible
    private static void abortExistingScheduler(Id cronId){
    	System.abortJob(cronId);
    } 
    
    @TestVisible
    private static void setFirstEscalationNotificationDates(Batch_Job_Setting__c batchJobSetting, Map<String, Batch_Job_Setting__c> batchJobSettingsMap){
    	// create first escalation setting
    	Batch_Job_Setting__c firstEscalationBatchJobSetting = new Batch_Job_Setting__c(); 
    	Integer daysShiftedFirstEscalation = 0;
    	Integer daysShiftedFromInitial = batchJobSetting.Actual_Date_To_Run__c.daysBetween(batchJobSetting.Expected_Run_Date__c);
    	Date expectedDateToRun = batchJobSetting.Actual_Date_To_Run__c.addDays(2);
    	Date actualDateToRun;
    	Datetime currentDateTime = Datetime.newInstance(expectedDateToRun.year(), expectedDateToRun.month(), expectedDateToRun.day());
    	String day = currentDateTime.format('EEEE');
		Boolean isWeekday = checkWeekday(day);
		if(!isWeekday){
			actualDateToRun = getNextWeekdayDate(day, expectedDateToRun);
		}else{
			actualDateToRun = expectedDateToRun;
		}
		
		daysShiftedFirstEscalation = daysShifted(expectedDateToRun, actualDateToRun);
		firstEscalationBatchJobSetting.Actual_Date_To_Run__c = actualDateToRun;
		firstEscalationBatchJobSetting.Expected_Run_Date__c = expectedDateToRun;
		firstEscalationBatchJobSetting.Days_Shifted__c = daysShiftedFirstEscalation; 
		firstEscalationBatchJobSetting.Current_Day__c = 3;
		firstEscalationBatchJobSetting.name = 'SCMD_FirstEscalationDayThree';
		batchJobSettingsMap.put(firstEscalationBatchJobSetting.name ,firstEscalationBatchJobSetting);
    }
    
    @TestVisible
    private static void setSecondEscalationDates(Batch_Job_Setting__c batchJobSetting, Map<String, Batch_Job_Setting__c> batchJobSettingsMap){
    	Batch_Job_Setting__c temp = new Batch_Job_Setting__c();
    	// for day 4
    	temp = getBatchSettingSchedule(batchJobSettingsMap, batchJobSetting.Name, 'SCMD_SecondEscalation_DayFour', 4, 1);
		batchJobSettingsMap.put(temp.Name, temp);
		// for day 5
		temp = getBatchSettingSchedule(batchJobSettingsMap, temp.Name, 'SCMD_SecondEscalation_DayFive', 5, 1);
		batchJobSettingsMap.put(temp.Name, temp);
    }
    
    @TestVisible
    private static void setFinalEscalationDates(Batch_Job_Setting__c batchJobSetting, Map<String, Batch_Job_Setting__c> batchJobSettingsMap){
    	Batch_Job_Setting__c temp = new Batch_Job_Setting__c();
    	// for day 6
    	temp = getBatchSettingSchedule(batchJobSettingsMap, batchJobSetting.Name, 'SCMD_FinalEscalation_DaySix', 6, 1); 
    	batchJobSettingsMap.put(temp.Name, temp);
    	// for day 7
    	temp = getBatchSettingSchedule(batchJobSettingsMap, temp.Name, 'SCMD_FinalEscalation_DaySeven', 7, 1);
    	batchJobSettingsMap.put(temp.Name, temp);
    	// for day 8
    	temp = getBatchSettingSchedule(batchJobSettingsMap, temp.Name, 'SCMD_FinalEscalation_DayEight', 8, 1);
    	batchJobSettingsMap.put(temp.Name, temp);
    	// for day 9
    	temp = getBatchSettingSchedule(batchJobSettingsMap, temp.Name, 'SCMD_FinalEscalation_DayNine', 9, 1);
    	batchJobSettingsMap.put(temp.Name, temp);
    }
    
    @TestVisible
    private static void setNoResponseFirmNotificationDates(Batch_Job_Setting__c batchJobSetting, Map<String, Batch_Job_Setting__c> batchJobSettingsMap){
    	Batch_Job_Setting__c temp = new Batch_Job_Setting__c();
    	temp = getBatchSettingSchedule(batchJobSettingsMap, batchJobSetting.Name, 'SCMD_NoResponse_DayTen', 10, 1);
    	batchJobSettingsMap.put(temp.Name, temp);
    }
    
    @TestVisible
    private static Batch_Job_Setting__c getBatchSettingSchedule(Map<String, Batch_Job_Setting__c> batchJobSettingsMap, String previousSettingName,
    																String settingToCreateName, Integer dayNumber, Integer nextDayDiffernce){
    	Date expectedDateToRun;
    	Batch_Job_Setting__c batchJobSetting = batchJobSettingsMap.get(previousSettingName);
    	Integer daysShiftedFromPrevious = batchJobSetting.Actual_Date_To_Run__c.daysBetween(batchJobSetting.Expected_Run_Date__c);
    	expectedDateToRun = batchJobSetting.Actual_Date_To_Run__c.addDays(nextDayDiffernce);
    	Datetime currentDateTime = Datetime.newInstance(expectedDateToRun.year(), expectedDateToRun.month(), expectedDateToRun.day());
    	String day = currentDateTime.format('EEEE');
		Date actualDateToRun = getActualDateToRun(day, expectedDateToRun);
		Integer daysShifted = daysShifted(expectedDateToRun, actualDateToRun);
    	Batch_Job_Setting__c batchJobSettingToCreate = new Batch_Job_Setting__c();
    	batchJobSettingToCreate.Actual_Date_To_Run__c = actualDateToRun;
		batchJobSettingToCreate.Expected_Run_Date__c = expectedDateToRun;
		batchJobSettingToCreate.Days_Shifted__c = daysShifted; 
		batchJobSettingToCreate.Current_Day__c = dayNumber;
		batchJobSettingToCreate.name = settingToCreateName;
		return batchJobSettingToCreate;  
    }
    
    @TestVisible
    private static Date getActualDateToRun(String day, Date expectedDateToRun){
    	Date actualDateToRun;
		Boolean isWeekday = checkWeekday(day);
		if(!isWeekday){
			actualDateToRun = getNextWeekdayDate(day, expectedDateToRun);
		}else{
			actualDateToRun = expectedDateToRun;
		}
		
		return actualDateToRun;    	
    }
    
    @TestVisible
    private static Date getDayOneDate(Datetime currentDateTime){
    	Date dayOneDate = null; 
    	Date currentDate = Date.newInstance(currentDateTime.year(), currentDateTime.month(), currentDateTime.Day());
		String day = currentDateTime.format('EEEE');
		Boolean isWeekday = checkWeekday(day);
		if(!isWeekday){
			dayOneDate = getNextWeekdayDate(day, currentDate);
		}else{
			dayOneDate = currentDate;
		}
		return dayOneDate;
    }
    
    @TestVisible
    private static Integer daysShifted(Date expectedDate, Date actualDate){
    	return expectedDate.daysBetween(actualDate);
    }
    
    @TestVisible
    private static Date getNextWeekdayDate(String currentDay, Date currentDate){
    	Date weekdayDate;
    	Integer day = getDayNumber(currentDay);
    	if(day == 0){
    		weekdayDate = currentDate.addDays(1);
    	}else if(day == 6){
    		weekdayDate = currentDate.addDays(2);
    	}else{
    		weekdayDate = currentDate;
    	}
    	return weekdayDate;
    }
    
    @TestVisible
    private static Integer getDayNumber(String currentDay){
    	Integer day = 0;
    	day = currentDayByDayOfWeek.get(currentDay);
    	return day; 
    }
    
    @TestVisible
    private static Boolean checkWeekday(String currentDay){
    	Boolean isWeekday = true;
    	if(currentDayByDayOfWeek.get(currentDay) == 0 || currentDayByDayOfWeek.get(currentDay) == 6){
    		isWeekday = false;
    	}
    	return isWeekday;
    }
}