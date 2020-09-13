global class IR_MonthlyReminderBatch implements Database.Batchable<sObject> {
	
	public String reportingPeriod{set;get;}
	
	public IR_MonthlyReminderBatch(String reportingPeriod){
		
		this.reportingPeriod = reportingPeriod;
	}

    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        
        String recordTypeIR = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR').getRecordTypeId();
        String statusNew = 'New';
        
        String query = 'SELECT Id, Name, Organization_Name__c, Organization_Name__r.Name, Organization_Name__r.Firm_ID__c, RecordTypeId, RecordType.Name,'
        				+' Status__c , SCMD_Reporting_Period__c'
        				+' FROM Process_Adherence_Monitoring__c'
        				+' WHERE RecordTypeId = :recordTypeIR AND SCMD_Reporting_Period__c =:reportingPeriod AND Status__c = :statusNew';
        				
      	return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){
    	
        // process each batch of records
        IR_Service.irReminderNotification(pamList, reportingPeriod);
       
    }
        
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        
        
         AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
					      TotalJobItems, CreatedBy.Email
					      FROM AsyncApexJob WHERE Id = :bc.getJobId()];
					      
		List<Messaging.SingleEmailMessage> mailsTosend = new List<Messaging.SingleEmailMessage>();
					      
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'IR_MonthlyReminderBatch');
		mailsTosend.add(mail);
	   	
	   	if(!Test.isRunningTest()){
	   		
	   		Messaging.sendEmail(mailsTosend);
	   	}
        
    }
         
}