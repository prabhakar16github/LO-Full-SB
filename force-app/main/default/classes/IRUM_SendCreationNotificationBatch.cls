public class IRUM_SendCreationNotificationBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
		
		String statusNew = 'New';
		String statusAccountSentToIseries = 'Accounts Sent To ISeries';  
		Id irRecType = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR - Account #\'s Sent').getRecordTypeId();
        Id irOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
		Id irClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Closed').getRecordTypeId();
		
        
		String query = 'SELECT Id, Name, SCMD_Day_Counter__c, Organization_Name__c, Organization_Name__r.Name, '
    					+ 'SCMD_Reporting_Period__c, ' 
        				+'( SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, SCMDUM_Record_Creation_Notification_Sent__c '
        				+' FROM PAM_Unmatched__r WHERE SCMDUM_Record_Creation_Notification_Sent__c = false '
        				+'AND (RecordTypeId = :irOpenRecType OR RecordTypeId = :irClosedRecType) AND PAMUM_Status__c = :statusNew LIMIT 1)'
        				+ ' FROM Process_Adherence_Monitoring__c WHERE recordTypeId = :irRecType AND Status__c = :statusAccountSentToIseries';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamlist){
		IRUM_SendCreationHandlerUtility.processPam(pamlist);
    }
        
    public void finish(Database.BatchableContext bc){
    	List<Case> caseList = [SELECT Id, Outcome_FTR__c FROM Case 
        							WHERE Outcome_FTR__c = 'Scripts - IRUM running in progress' 
        							AND Reason = 'Process Adherence Monitoring (PAM)' 
        							AND Subcategories__c = 'Scripts - IRUM' 
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
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'IRUM_SendCreationNotificationBatch');
		mailsTosend.add(mail);
		if(!Test.isRunningTest()){
	   		Messaging.sendEmail(mailsTosend);
	   	}
	   	IRUM_SendCreationHandlerUtility.scheduleIRUM_SendCreationHandleScheduler();
    }    
}