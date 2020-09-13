global class IRUM_MonthlyNoResponseBatch implements Database.Batchable<sObject> {
	
	public String reportingPeriod{set; get;}
	
	global IRUM_MonthlyNoResponseBatch(String reportingPeriod){
		this.reportingPeriod = reportingPeriod;
	}
	
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String statusFinalEscalation = 'Final Escalation';
        Id pamUMIrFirmClosedRecTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Closed').getRecordTypeId();
        Id pamUMIrFirmOpenRecTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
        
        Set<Id> pamIdSet = new Set<Id>();
        
        
        List<PAM_Unmatched__c> scmdUnmatchedList = [SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, PAMUM_Status__c 
        												FROM PAM_Unmatched__c 
        												WHERE SCMDUM_Reporting_Period__c = :reportingPeriod 
        													AND PAMUM_Status__c = :statusFinalEscalation 
        													AND (recordTypeId = :pamUMIrFirmOpenRecTypeId OR recordTypeId = :pamUMIrFirmClosedRecTypeId)];
        													
     	for(PAM_Unmatched__c scmdUmObj : scmdUnmatchedList){
        	
        	pamIdSet.add(scmdUmObj.PAMUM_Process_Adherence_Monitoring__c);
        } 
        
        
        String query = 'SELECT Id, Name, Organization_Name__c, Organization_Name__r.Owner.Email, '
        				+'Organization_Name__r.Firm_ID__c, SCMD_Reporting_Period__c'
        				+', (SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, PAMUM_Status__c'
        				+' FROM PAM_Unmatched__r WHERE SCMDUM_Reporting_Period__c = :reportingPeriod'
        				+' AND PAMUM_Status__c = :statusFinalEscalation )'
        				+' FROM Process_Adherence_Monitoring__c WHERE Id IN :pamIdSet';
        				
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){
        IR_UnmatchedService.sendIRUMNoResponseMail(pamList);
    }
        
    global void finish(Database.BatchableContext bc){
        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
					      TotalJobItems, CreatedBy.Email
					      FROM AsyncApexJob WHERE Id = :bc.getJobId()];
					      
		List<Messaging.SingleEmailMessage> mailsTosend = new List<Messaging.SingleEmailMessage>();
					      
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'IRUM_MonthlyNoResponseBatch');
		mailsTosend.add(mail);
		
		if(!Test.isRunningTest()){
	   		Messaging.sendEmail(mailsTosend);
	   	}
        
    }
        
}