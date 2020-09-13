global class IR_MonthlyInitialNotificationBatch implements Database.Batchable<sObject>, Database.stateful {
	
	public Integer noOfOrganisations = 0;
	
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        
        List<AccountContactRelation> accountContactRelationList = [SELECT Id, AccountId FROM AccountContactRelation 
        															WHERE Contact.Contact_Type_SME__c INCLUDES('Inventory Reconciliation')];
		
		List<Id> accountIds = new List<Id>();
        
        for(AccountContactRelation accountContactObj : accountContactRelationList){
        	
        	accountIds.add(accountContactObj.AccountId);
        } 
        
        String query = 'SELECT Id, Name, Firm_ID__c, (SELECT Id, ContactId, Contact.FirstName, Contact.Email, Contact.Contact_Type_SME__c, ' 
        				+'Contact.Community_User__c FROM AccountContactRelations ' 
        				+ 'WHERE (Contact.Contact_Type_SME__c INCLUDES(\'Inventory Reconciliation\') OR Contact.Community_User__c = true) '
        				+ ' AND Contact.Inactive_Contact__c = FALSE)'
        				+' From Account WHERE Id IN :accountIds AND Firm_ID__c != null '
        				+'AND ( Firm_Status_IN__c = \'Inactive\' OR Firm_Status_IN__c = \'Active\')';
        				
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accountList){
        // process each batch of records
        
        IR_Service.sentInitialNotification(accountList, '');
        
        noOfOrganisations = noOfOrganisations + accountList.size();
    }
        
    global void finish(Database.BatchableContext bc){
        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
					      TotalJobItems, CreatedBy.Email
					      FROM AsyncApexJob WHERE Id = :bc.getJobId()];
		
		List<Messaging.SingleEmailMessage> mailsTosend = new List<Messaging.SingleEmailMessage>();		
					      
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'IR Monthy Initial Notification');
	   	
	   	mailsTosend.add(mail);
	   	
	   	Messaging.SingleEmailMessage noOfrecordsCreatedMail = new Messaging.SingleEmailMessage();
	   	String[] createdRecordsToAddresses = new String[] {'lcsalesforceadmin@mcmcg.com'};
	   	
	   	List<SCMD_VSMail_Id__c> vsMailIds = SCMD_VSMail_Id__c.getAll().values(); // getting values from custom setting
	   	
	   	for(SCMD_VSMail_Id__c mailId : vsMailIds){
	   		
	   		createdRecordsToAddresses.add(mailId.Mail_Id__c);
	   	}
	   	
	   	noOfrecordsCreatedMail.setToAddresses(createdRecordsToAddresses);
	   	noOfrecordsCreatedMail.setSubject('IR Initial Monthy Notification ' + a.Status);
	   	noOfrecordsCreatedMail.setPlainTextBody('IR Initial Monthy Notification sent to '+noOfOrganisations+' organizations.');
	   
	   	mailsTosend.add(noOfrecordsCreatedMail);
		
	   	if(!Test.isRunningTest()){
	   		Messaging.sendEmail(mailsTosend);
	   	}
    }
        
}