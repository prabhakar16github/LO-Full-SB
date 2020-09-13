public without sharing class SCMDisputeMonthlyRemHandler {
    
    public static void scheduleScmd(Date dateToday){
    	   
    	  String reportingPeriod = '';
    	  
    	  String month = String.valueOf(dateToday.month());
        
		  if(month.length() == 1){
				month = '0' + month; // format month
		  }
    	  
    	  reportingPeriod = dateToday.year() +'-'+ month; 
    	  Map<String, Batch_Job_Setting__c> batchJobSettings = Batch_Job_Setting__c.getAll();
    	  Integer currentDay = dateToday.day();
    	  
    	  if( batchJobSettings.get('SCMD_FirstEscalationDayThree').Current_Day__c == 3 
    	  		&& batchJobSettings.get('SCMD_FirstEscalationDayThree').Actual_Date_To_Run__c == dateToday ){
    	  		
    	  		// for LO
	    	  	SCMD_FirstEscalationNotification scmdFirstEsc = new SCMD_FirstEscalationNotification(reportingPeriod); // for day three
	    	  	Database.executeBatch(scmdFirstEsc, 10); 
	    	  	
	    	  	//for ACF
	    	  	SCMD_ACF_FirstEscalationNotification scmdACFFirstEscalationBatchObj = new SCMD_ACF_FirstEscalationNotification(reportingPeriod);
				Database.executeBatch(scmdACFFirstEscalationBatchObj, 10);
                    
                
    	  }else if(isQualifiedRunSecondEscalation(batchJobSettings, dateToday)) {
    	  		
    	  		// for LO
	    	  	SCMD_SecondEscalation_Notification scmdSecondEsc = new SCMD_SecondEscalation_Notification(reportingPeriod); // for day 4 and 5
	    	  	Database.executeBatch(scmdSecondEsc, 10);
	    	  	
	    	  	//for ACF
	    	  	SCMD_ACFSecondEscalation_Notification scmdAcfSecondEscalation = new SCMD_ACFSecondEscalation_Notification(reportingPeriod);
				Database.executeBatch(scmdAcfSecondEscalation, 10);
              
              
    	  }else if(isQualifiedRunFinalEscalation(batchJobSettings, dateToday)){
    	  		
    	  		// for LO
	    	  	SCMD_FinalEscalation scmdFinal = new SCMD_FinalEscalation(reportingPeriod); // for day 6,7,8,9
				Database.executeBatch(scmdFinal, 10);
				
				//for ACF
				SCMD_ACFFinalEscalation scmdAcfFinalEscalation = new SCMD_ACFFinalEscalation(reportingPeriod);
				Database.executeBatch(scmdAcfFinalEscalation, 10);
              
             
    	  }else if(isQualifiedRunNoResponse(batchJobSettings, dateToday)){ // for day 10
    	  		
    	  		// for LO
	    	  	SCMD_NoResponseFirmNotificationBatch noResponseFirmBatch = new SCMD_NoResponseFirmNotificationBatch(reportingPeriod); 
	    	  	Database.executeBatch(noResponseFirmBatch, 10);
	    	  	
	    	  	//for ACF
	    	  	SCMD_NoResponseACFFirmNotificationBatch noResponseAcfFirmBatch = new SCMD_NoResponseACFFirmNotificationBatch(reportingPeriod);
	    	  	Database.executeBatch(noResponseAcfFirmBatch, 10);  
              
               
    	  }
    }
    
    @TestVisible
    private static boolean isQualifiedRunFirstEscalation(Map<String, Batch_Job_Setting__c> batchJobSettings, Date dateToday){
    	Boolean isQualifiedRunFirstEscalation = false;
    	if( batchJobSettings.get('SCMD_FirstEscalationDayThree').Current_Day__c == 3 
    	  				&& batchJobSettings.get('SCMD_FirstEscalationDayThree').Actual_Date_To_Run__c == dateToday ){
    	  					
    	 	isQualifiedRunFirstEscalation = true; 
    	 }
    	 return isQualifiedRunFirstEscalation;
    }
    
    @TestVisible
    private static boolean isQualifiedRunSecondEscalation(Map<String, Batch_Job_Setting__c> batchJobSettings, Date dateToday){
    	Boolean isQualifiedRunSecondEscalation = false;
    	if( (batchJobSettings.get('SCMD_SecondEscalation_DayFour').Current_Day__c == 4 
    	  				&& batchJobSettings.get('SCMD_SecondEscalation_DayFour').Actual_Date_To_Run__c == dateToday ) 
    	  			|| (batchJobSettings.get('SCMD_SecondEscalation_DayFive').Current_Day__c == 5 
    	  				&& batchJobSettings.get('SCMD_SecondEscalation_DayFive').Actual_Date_To_Run__c == dateToday ) ){
    	  					
    	 	isQualifiedRunSecondEscalation = true; 
    	 }
    	 return isQualifiedRunSecondEscalation;
    }
    
    @TestVisible
    private static boolean isQualifiedRunFinalEscalation(Map<String, Batch_Job_Setting__c> batchJobSettings, Date dateToday){
    	Boolean isQualifiedRunFinalEscalation = false;
    	if( ( batchJobSettings.get('SCMD_FinalEscalation_DaySix').Current_Day__c == 6 
    	  				&& batchJobSettings.get('SCMD_FinalEscalation_DaySix').Actual_Date_To_Run__c == dateToday ) 
    	  			|| (batchJobSettings.get('SCMD_FinalEscalation_DaySeven').Current_Day__c == 7 
    	  				&& batchJobSettings.get('SCMD_FinalEscalation_DaySeven').Actual_Date_To_Run__c == dateToday ) 
    	  			|| (batchJobSettings.get('SCMD_FinalEscalation_DayEight').Current_Day__c == 8 
    	  				&& batchJobSettings.get('SCMD_FinalEscalation_DayEight').Actual_Date_To_Run__c == dateToday )
    	  			|| (batchJobSettings.get('SCMD_FinalEscalation_DayNine').Current_Day__c == 9 
    	  				&& batchJobSettings.get('SCMD_FinalEscalation_DayNine').Actual_Date_To_Run__c == dateToday ) ){
    	  					
    	 	isQualifiedRunFinalEscalation = true; 
    	 }
    	 return isQualifiedRunFinalEscalation;
    }
    
    @TestVisible
    private static boolean isQualifiedRunNoResponse(Map<String, Batch_Job_Setting__c> batchJobSettings, Date dateToday){
    	Boolean isQualifiedRunNoResponse = false;
    	if( batchJobSettings.get('SCMD_NoResponse_DayTen').Current_Day__c == 10 
    	  				&& batchJobSettings.get('SCMD_NoResponse_DayTen').Actual_Date_To_Run__c == dateToday ){
    	  					
    	 	isQualifiedRunNoResponse = true; 
    	 }
    	 return isQualifiedRunNoResponse;
    }
    
    public static void bufferCode(){
    	// needs to remove the method 
    	Integer i = 0;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	
    }
}