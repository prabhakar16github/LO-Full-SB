public class SCM_ACF_DisputeMonthlyBatch implements Database.Batchable<sObject>, Database.stateful {
	
	public Integer noOfPamRecordsCreated = 0;
	public Database.QueryLocator start(Database.BatchableContext bc) {
    	
        /*List<AccountContactRelation> accountContactRelationList = [SELECT Id, AccountId FROM AccountContactRelation 
        																WHERE Contact.Contact_Type_SME__c INCLUDES('Process Adherence Monitoring (PAM)')];
        List<Id> accountIds = new List<Id>();
        for(AccountContactRelation accountContactObj : accountContactRelationList){
        	accountIds.add(accountContactObj.AccountId);
        }*/
        Id IN_NetworkOrgRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('In Network').getRecordTypeId();
        String query = 'SELECT Id, Name, Firm_ID__c, (SELECT Id, ContactId, Contact.FirstName, Contact.Email, Contact.Contact_Type_SME__c, ' 
        				+'Contact.Community_User__c FROM AccountContactRelations ' 
        				+ 'WHERE (Contact.Contact_Type_SME__c INCLUDES(\'Process Adherence Monitoring (PAM)\') OR Contact.Community_User__c = true) '
        				+ ' AND Contact.Inactive_Contact__c = FALSE)'
        				+' From Account WHERE RecordTypeId =:IN_NetworkOrgRecordTypeId AND Firm_ID__c != null '//Id IN :accountIds AND
        				//+' From Account WHERE Id = :oneAccount AND Firm_ID__c != null '
        				+'AND ( Firm_Status_IN_ACF__c = \'Inactive\' OR Firm_Status_IN_ACF__c = \'Active\')';
        				
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Account> accountList){
    	try{
            System.debug('accountList>>>>'+accountList);
    		List<Process_Adherence_Monitoring__c> insertedRecords = SCMDisputeService.createMonthlyACFSCMD(accountList);
	    	noOfPamRecordsCreated += insertedRecords.size();
    	}Catch(Exception ex){
			ApexDebugLog.debug('Exception in SCM_ACF_DisputeMonthlyBatch execute' + ex);
 			new ApexDebugLog().createLog( new ApexDebugLog.Error( 'SCM_ACF_DisputeMonthlyBatch', 'execute', NULL, ex ));   	
    	}
    
    } 
       
    public void finish(Database.BatchableContext bc){
        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
					      TotalJobItems, CreatedBy.Email
					      FROM AsyncApexJob WHERE Id = :bc.getJobId()];
		
		List<Messaging.SingleEmailMessage> mailsTosend = new List<Messaging.SingleEmailMessage>();		
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'SCM ACF Monthly Notification');
	   	mailsTosend.add(mail);
	   	Messaging.SingleEmailMessage noOfrecordsCreatedMail = new Messaging.SingleEmailMessage();
	   	String[] createdRecordsToAddresses = new String[] {'lcsalesforceadmin@mcmcg.com'}; //lcsalesforceadmin@mcmcg.com // Custom setting mail-- attorneyoutsourcing@mcmcg.com
	   	List<SCMD_VSMail_Id__c> vsMailIds = SCMD_VSMail_Id__c.getAll().values();
	   	for(SCMD_VSMail_Id__c mailId : vsMailIds){
	   		createdRecordsToAddresses.add(mailId.Mail_Id__c);
	   	}
	   	noOfrecordsCreatedMail.setToAddresses(createdRecordsToAddresses);
	   	noOfrecordsCreatedMail.setSubject('SCM_ACF_DisputeMonthlyBatch ' + a.Status);
	   	noOfrecordsCreatedMail.setPlainTextBody('The SCM_Monthly ACF Notification sent to '+noOfPamRecordsCreated+' organizations.');
	   	mailsTosend.add(noOfrecordsCreatedMail);
	   	if(!Test.isRunningTest()){
	   		Messaging.sendEmail(mailsTosend);
	   	}
    }
    
        
}