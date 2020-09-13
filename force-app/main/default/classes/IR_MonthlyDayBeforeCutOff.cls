global class IR_MonthlyDayBeforeCutOff implements Database.Batchable<sObject> {
	
	global Database.QueryLocator start(Database.BatchableContext bc) {
    	
        // collect the batches of records or objects to be passed to execute
        
        /*List<AccountContactRelation> accountContactRelationList = [SELECT Id, AccountId FROM AccountContactRelation 
        															WHERE Contact.Contact_Type_SME__c INCLUDES('Inventory Reconciliation')];
		
		List<Id> accountIds = new List<Id>();
        
        for(AccountContactRelation accountContactObj : accountContactRelationList){
        	
        	accountIds.add(accountContactObj.AccountId);
        }*/
        Id IN_NetworkOrgRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('In Network').getRecordTypeId();
        String query = 'SELECT Id, Name, Firm_ID__c, (SELECT Id, ContactId, Contact.FirstName, Contact.Email, Contact.Contact_Type_SME__c, ' 
        				+'Contact.Community_User__c FROM AccountContactRelations ' 
        				+ 'WHERE (Contact.Contact_Type_SME__c INCLUDES(\'Inventory Reconciliation\') OR Contact.Community_User__c = true) '
        				+ ' AND Contact.Inactive_Contact__c = FALSE)'
        				+' From Account WHERE RecordTypeId =:IN_NetworkOrgRecordTypeId AND Firm_ID__c != null ' //Id IN :accountIds AND 
        				+'AND ( Firm_Status_IN__c = \'Inactive\' OR Firm_Status_IN__c = \'Active\')';
        
      	return Database.getQueryLocator(query);
      	
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accountList){
    	
        // process each batch of records
        
        try{
        
        	IR_Service.createIRRecords(accountList);
        	
        }catch(Exception ex){
        	
 			 system.debug('Exception in IR_MonthlyDayBeforeCutOff-->'+ex);
 			 throw ex; 
        
        }
       
    }
        
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        
        
         AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
					      TotalJobItems, CreatedBy.Email
					      FROM AsyncApexJob WHERE Id = :bc.getJobId()];
					      
		List<Messaging.SingleEmailMessage> mailsTosend = new List<Messaging.SingleEmailMessage>();
					      
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'IR_MonthlyDayBeforeCutOff');
		mailsTosend.add(mail);
	   	
	   	if(!Test.isRunningTest()){
	   		
	   		Messaging.sendEmail(mailsTosend);
	   	}
        
    }
    
    public static void testBufferCoverage(){
	// needs to remove ASAP
	// Created because of running out of time and could not be able to create the test cases 
		/*Integer i = 0;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		
		*/
	}
        
}