global class SCMDUMMonthlyScheduler implements Schedulable{

	global void execute(SchedulableContext sc){
    	
    	
    	String reportingPeriod = '';
    	  
    	Date dateToday = System.today();
    	  
    	String month = String.valueOf(dateToday.month());
        
		if(month.length() == 1){
				
			month = '0' + month; // format month
		}
    	  
    	reportingPeriod = dateToday.year() +'-'+ month; 
    	  
    	Integer currentDay = dateToday.day();
    	  
    	// for LO  
    	  	
	  	SCMDUM_FirstEscalationNotification scmdUmFirstEsc = new SCMDUM_FirstEscalationNotification(reportingPeriod); // for day 4
	  	Database.executeBatch(scmdUmFirstEsc, 10);
	  	
	  	// for ACF
	  	
	  	SCMDUM_ACFFirstEscalationNotification scmdUmACFFirstEsc = new SCMDUM_ACFFirstEscalationNotification(reportingPeriod); // for day 4
	  	Database.executeBatch(scmdUmACFFirstEsc, 10); 
	  
	  	// for LO 
	  	
	  	SCMDUM_FinalEscalationNotification scmdUmFinalEsc = new SCMDUM_FinalEscalationNotification(reportingPeriod); // for day 5, 6, 7, 8
	  	Database.executeBatch(scmdUmFinalEsc, 10);
	  	
	  	// for ACF 
	  	
	  	SCMDUM_ACFFinalEscalationNotification scmdUmACFFinalEsc = new SCMDUM_ACFFinalEscalationNotification(reportingPeriod); // for day 5, 6, 7, 8
	  	Database.executeBatch(scmdUmACFFinalEsc, 10);
	  
	  	// for LO 
	  	
	  	SCMDUM_NoResponseNotification noResponseNotification = new SCMDUM_NoResponseNotification(reportingPeriod); // for day 9
		Database.executeBatch(noResponseNotification, 10);
		
		//for ACF
		
		SCMDUM_ACFNoResponseNotification noResponseACFNotification = new SCMDUM_ACFNoResponseNotification(reportingPeriod); // for day 9
		Database.executeBatch(noResponseACFNotification, 10);
		
    	  	
    }  
}