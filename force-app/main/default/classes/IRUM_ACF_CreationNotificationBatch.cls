global class IRUM_ACF_CreationNotificationBatch  implements Database.Batchable<Sobject>{
    public Database.QueryLocator start(Database.BatchableContext bc) {
		
		String statusNew = 'New';
		String statusAccountSentToIseries = 'Accounts Sent To ISeries';  
		Id irACFRecType = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR - Account #\'s Sent').getRecordTypeId();
        Id irACFOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Open').getRecordTypeId();
		Id irACFClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Closed').getRecordTypeId();
		
        String query = 'SELECT Id, Name, SCMD_Day_Counter__c, Organization_Name__c, Organization_Name__r.Name, '
    					+ 'SCMD_Reporting_Period__c, ' 
        				+'( SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, SCMDUM_Record_Creation_Notification_Sent__c '
        				+' FROM PAM_Unmatched__r WHERE SCMDUM_Record_Creation_Notification_Sent__c = false '
        				+'AND (RecordTypeId = :irACFOpenRecType OR RecordTypeId = :irACFClosedRecType) AND PAMUM_Status__c = :statusNew LIMIT 1)'
        				+ ' FROM Process_Adherence_Monitoring__c WHERE recordTypeId = :irACFRecType AND Status__c = :statusAccountSentToIseries';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamlist){
		IR_ACF_UnmatchedService.processUnmatched(pamlist);
    }
        
    public void finish(Database.BatchableContext bc){
    	List<Case> caseList = [SELECT Id, Outcome_FTR__c FROM Case 
        							WHERE Outcome_FTR__c = 'Scripts - IRUM ACF running in progress' 
        							AND Reason = 'Process Adherence Monitoring (PAM)' 
        							AND Subcategories__c = 'Scripts - IRUM ACF' 
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
		} 
    
}