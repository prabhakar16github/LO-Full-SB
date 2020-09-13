global class SCMDisputeMonthlyBatch implements Database.Batchable<sObject>, Database.stateful {
	
	public Integer noOfPamRecordsCreated = 0;
	//List<Exception> errors = new List<Exception>();
	
	global Database.QueryLocator start(Database.BatchableContext bc) {
    	
        /*List<AccountContactRelation> accountContactRelationList = [SELECT Id, AccountId FROM AccountContactRelation 
        															WHERE Contact.Contact_Type_SME__c INCLUDES('Process Adherence Monitoring (PAM)')];
        															
        List<Id> accountIds = new List<Id>();
        
        for(AccountContactRelation accountContactObj : accountContactRelationList){
        	
        	accountIds.add(accountContactObj.AccountId);
        } */
        
        Id IN_NetworkOrgRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('In Network').getRecordTypeId();
        String query = 'SELECT Id, Name, Firm_ID__c, (SELECT Id, ContactId, Contact.FirstName, Contact.Email, Contact.Contact_Type_SME__c, ' 
            +'Contact.Community_User__c FROM AccountContactRelations ' 
            + 'WHERE (Contact.Contact_Type_SME__c INCLUDES(\'Process Adherence Monitoring (PAM)\') OR Contact.Community_User__c = true) '
            + ' AND Contact.Inactive_Contact__c = FALSE)'
            +' From Account WHERE RecordTypeId =:IN_NetworkOrgRecordTypeId ' //Id IN :accountIds AND 
            +'AND (Firm_Status_IN__c = \'Inactive\' OR Firm_Status_IN__c = \'Active\')';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accountList){
    	ApexDebugLog.debug('SCMDisputeMonthlyBatch execute accountList '+accountList);
    	try{
    		
    		List<Process_Adherence_Monitoring__c> insertedRecords = SCMDisputeService.createMonthlyLOSCMD(accountList);
	    	
	    	noOfPamRecordsCreated += insertedRecords.size();
	    	
    	}Catch(Exception ex){
			ApexDebugLog.debug('Exception in SCMDisputeMonthlyBatch execute' + ex);
 			new ApexDebugLog().createLog(new ApexDebugLog.Error('SCMDisputeMonthlyBatch','execute',NULL,ex));   	
    	}
    } 
       
    global void finish(Database.BatchableContext bc){
        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
					      TotalJobItems, CreatedBy.Email
					      FROM AsyncApexJob WHERE Id = :bc.getJobId()];
		
		List<Messaging.SingleEmailMessage> mailsTosend = new List<Messaging.SingleEmailMessage>();		
					      
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'SCM_Monthly Notification');
	   	
	   	mailsTosend.add(mail);
	   	
	   	Messaging.SingleEmailMessage noOfrecordsCreatedMail = new Messaging.SingleEmailMessage();
	   	String[] createdRecordsToAddresses = new String[] {'lcsalesforceadmin@mcmcg.com'};
	   	
	   	List<SCMD_VSMail_Id__c> vsMailIds = SCMD_VSMail_Id__c.getAll().values(); // getting values from custom setting
	   	
	   	for(SCMD_VSMail_Id__c mailId : vsMailIds){
	   		
	   		createdRecordsToAddresses.add(mailId.Mail_Id__c);
	   	}
	   	
	   	noOfrecordsCreatedMail.setToAddresses(createdRecordsToAddresses);
	   	noOfrecordsCreatedMail.setSubject('The SCM Monthly Notification ' + a.Status);
	   	noOfrecordsCreatedMail.setPlainTextBody('The SCM_Monthly Notification sent to '+noOfPamRecordsCreated+' organizations.');
	   
	   	mailsTosend.add(noOfrecordsCreatedMail);
	   	
		/*if(!errors.isEmpty()) {
		   	 	
			Messaging.SingleEmailMessage errorMail = Utils.getExceptionErrorMail(errors, 'SCMDisputeMonthlyBatch');
		   	 	
			mailsTosend.add(errorMail);
		        
		}*/
	   	
	   	
	   	if(!Test.isRunningTest()){
	   		Messaging.sendEmail(mailsTosend);
	   	}
    }
}