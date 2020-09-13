global class PNA_SendReportNotification implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        
        String recordTypePNA = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO PNA').getRecordTypeId();
        
        String query = 'SELECT Name, Firm_ID__c, PNA_Exceptions_0_3_bucket__c, PNA_Exceptions_4_6_bucket__c,'
        				+' PNA_Exceptions7Plusbucket__c,'
        				+' (SELECT id FROM Process_Adherence_Monitoring__r WHERE Status__c != \'Closed\' AND RecordTypeId = :recordTypePNA LIMIT 1)'
        				+' FROM Account WHERE (PNA_Exceptions_0_3_bucket__c != 0 AND PNA_Exceptions_0_3_bucket__c != null)'
        				+' OR (PNA_Exceptions_4_6_bucket__c != 0 AND PNA_Exceptions_4_6_bucket__c != null)'
        				+' OR (PNA_Exceptions7Plusbucket__c != 0 AND PNA_Exceptions7Plusbucket__c != null)';
        				
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accountList){
        // process each batch of records
        PNA_Service.sendReportnotificationToContacts(accountList);
    }
        
    global void finish(Database.BatchableContext bc){
    	
        // execute any post-processing operations
        List<Case> caseList = [SELECT Id, Outcome_FTR__c FROM Case 
        							WHERE Outcome_FTR__c = 'Scripts - PNA running in progress' 
        							AND Reason = 'Process Adherence Monitoring (PAM)' 
        							AND Subcategories__c = 'Scripts - PNA' 
        							AND Type = 'SME'];
        							
    	AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
					      TotalJobItems, CreatedBy.Email
					      FROM AsyncApexJob WHERE Id = :bc.getJobId()];
					      
    	for( Case caseObj : caseList ){
    		if( a.NumberOfErrors == 0 ){
				caseObj.Outcome_FTR__c = 'Completed.';
    		}    		
    	}
    	update caseList;
    	
		List<Messaging.SingleEmailMessage> mailsTosend = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'PNA_SendReportNotification');
		mailsTosend.add(mail);
		
		if(!Test.isRunningTest()){
	   		
	   		Messaging.sendEmail(mailsTosend);
	   	}
    
    }
        
}