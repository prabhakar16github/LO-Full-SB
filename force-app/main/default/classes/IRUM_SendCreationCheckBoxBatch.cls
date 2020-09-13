public class IRUM_SendCreationCheckBoxBatch implements Database.Batchable<sObject> {
	
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = IRUM_SendCreationCheckBoxHandler.getQuery();
        String accountSentToIseries = 'Accounts Sent To ISeries';
        Id irAccountSentToIseriesRecType = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR - Account #\'s Sent').getRecordTypeId();
        System.debug('IRUM_SendCreationCheckBoxBatch >> '+Database.query(query));
        return Database.getQueryLocator(query); 
    }
    
    public void execute(Database.BatchableContext bc, List<PAM_Unmatched__c> pamUnmatched){
    	try{
    		IRUM_SendCreationCheckBoxHandler.processPamUnmatched(pamUnmatched);
    	}catch(Exception e){
    		system.debug('Exception in IRUM_SendCreationCheckBoxBatch execute '+e);
    		Messaging.SingleEmailMessage exceptionErrorMail = Utils.getExceptionErrorMail(new List<Exception>{e});
    	}
    }
    
    public void finish(Database.BatchableContext bc){
    	AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
					      TotalJobItems, CreatedBy.Email
					      FROM AsyncApexJob WHERE Id = :bc.getJobId()];
					      
		List<Messaging.SingleEmailMessage> mailsTosend = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'IRUM_SendCreationCheckBoxBatch');
		mailsTosend.add(mail);
		
		if(!Test.isRunningTest()){
	   		Messaging.sendEmail(mailsTosend);
	   	}
    }    
}