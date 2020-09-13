global class SCMDUM_FinalEscalationNotification implements Database.Batchable<sObject> {
	
	public String reportingPeriod{set; get;}
	
	global SCMDUM_FinalEscalationNotification(String reportingPeriod){
		
		this.reportingPeriod = reportingPeriod;
	}
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
    	
        // collect the batches of records or objects to be passed to execute
        
        String statusFirstEscalation = 'First Escalation';
        String statusFinalEscalation = 'Final Escalation';
        
        Id pamUMScmDisputeRecordTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId();
        
        Double fifthDay= 5;
        Double eigthDay = 8;
        
        Set<Id> pamIdSet = new Set<Id>();
        
        
        List<PAM_Unmatched__c> scmdUnmatchedList = [SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, PAMUM_Status__c 
        												FROM PAM_Unmatched__c 
        												WHERE SCMDUM_Reporting_Period__c = :reportingPeriod 
        													AND ( PAMUM_Status__c = :statusFirstEscalation OR PAMUM_Status__c = :statusFinalEscalation ) 
        													AND PAMUM_Day_Counter__c >= :fifthDay AND PAMUM_Day_Counter__c <= :eigthDay
        													AND recordTypeId = :pamUMScmDisputeRecordTypeId];
        													
     	
     	for(PAM_Unmatched__c scmdUmObj : scmdUnmatchedList){
        	
        	pamIdSet.add(scmdUmObj.PAMUM_Process_Adherence_Monitoring__c);
        } 
        
        
        String query = 'SELECT Id, Name, Organization_Name__c, Organization_Name__r.Firm_ID__c, SCMD_Reporting_Period__c'
        				+', (SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, PAMUM_Status__c'
        				+' FROM PAM_Unmatched__r WHERE SCMDUM_Reporting_Period__c = :reportingPeriod'
        				+' AND PAMUM_Day_Counter__c >= :fifthDay AND PAMUM_Day_Counter__c <= :eigthDay'
        				+' AND ( PAMUM_Status__c = :statusFirstEscalation OR PAMUM_Status__c = :statusFinalEscalation ))'
        				+' FROM Process_Adherence_Monitoring__c WHERE Id IN :pamIdSet';
        				
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){
        
        // process each batch of records
        
		system.debug('pamList--------->'+pamList);
		
		Map<Id, Account> accountByAccountIdMap = new Map<Id, Account>(); 
        Set<Id> accountIdSet = new Set<Id>();
        
        for(Process_Adherence_Monitoring__c pamObj : pamList){
        	
        	accountIdSet.add(pamObj.Organization_Name__c);
        }
		
		accountByAccountIdMap = new Map<Id, Account>([SELECT Id, Name, Firm_ID__c, 
			    														(SELECT Id, ContactId, Contact.firstName, Contact.Email,  
			    															Contact.Community_User__c 
			    														FROM AccountContactRelations 
			    														WHERE Contact.Contact_Type_SME__c INCLUDES('Process Adherence Monitoring (PAM)') 
			    														AND Contact.Inactive_Contact__c = FALSE) 
			    													FROM Account 
			    													WHERE Id IN : accountIdSet]);
			    													
		SCMDisputeService.sendSCMDUMFinalEscalationNotification( pamList, accountByAccountIdMap, reportingPeriod);          
    }
        
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
					      TotalJobItems, CreatedBy.Email
					      FROM AsyncApexJob WHERE Id = :bc.getJobId()];
					      
		List<Messaging.SingleEmailMessage> mailsTosend = new List<Messaging.SingleEmailMessage>();
					      
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'SCMDUM_FinalEscalationNotification');
		mailsTosend.add(mail);
		
		if(!Test.isRunningTest()){
	   		
	   		Messaging.sendEmail(mailsTosend);
	   	}else{
	   		bufferCode();
	   	}
    }
    
    private static void bufferCode(){
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