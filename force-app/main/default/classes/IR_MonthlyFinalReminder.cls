global class IR_MonthlyFinalReminder implements Database.Batchable<sObject> {
	
	public String reportingPeriod{set;get;}
	
	public IR_MonthlyFinalReminder(String reportingPeriod){
		
		this.reportingPeriod = reportingPeriod;
	}

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String recordTypeIR = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR').getRecordTypeId();
        String statusNew = 'New';
        
        String query = 'SELECT Id, Name, Organization_Name__c, Organization_Name__r.Name, Organization_Name__r.Firm_ID__c, RecordTypeId, RecordType.Name,'
        				+' Status__c , SCMD_Reporting_Period__c'
        				+' FROM Process_Adherence_Monitoring__c'
        				+' WHERE RecordTypeId = :recordTypeIR AND SCMD_Reporting_Period__c =:reportingPeriod AND Status__c = :statusNew';
        				
      	return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){
        try{
        	IR_Service.irFinalReminder(pamList, reportingPeriod);
        }catch(Exception ex){
        	system.debug('Exception in IR monthly First Escalation-->'+ex);
 			throw ex; 
        }
    }
        
    global void finish(Database.BatchableContext bc){
        
         AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
					      TotalJobItems, CreatedBy.Email
					      FROM AsyncApexJob WHERE Id = :bc.getJobId()];
					      
		List<Messaging.SingleEmailMessage> mailsTosend = new List<Messaging.SingleEmailMessage>();
					      
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'IR_MonthlyFinalReminder');
		mailsTosend.add(mail);
	   	
	   	if(!Test.isRunningTest()){
	   		
	   		Messaging.sendEmail(mailsTosend);
	   	}
        
    }
         
}