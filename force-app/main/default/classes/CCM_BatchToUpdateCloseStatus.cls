global class CCM_BatchToUpdateCloseStatus implements Database.Batchable<SObject>{
    
    global database.querylocator start(Database.BatchableContext bc){
        Id recordTypeCCM_JR =  Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO CCM - JR').getRecordTypeId();
        Id recordTypeCCM_SR =  Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO CCM - SR').getRecordTypeId();
        String query = '';
        if(Test.isRunningTest()){
            query = 'SELECT Status__c,LastModifiedDate FROM Process_Adherence_Monitoring__c WHERE (RecordtypeId =: recordTypeCCM_JR OR ' +
                            'RecordtypeId =: recordTypeCCM_SR) AND Status__c != \'Closed\'';
        }else{
            query = 'SELECT Status__c,LastModifiedDate FROM Process_Adherence_Monitoring__c WHERE (RecordtypeId =: recordTypeCCM_JR OR ' +
                        'RecordtypeId =: recordTypeCCM_SR) AND Status__c != \'Closed\' AND LastModifiedDate != TODAY';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, Process_Adherence_Monitoring__c[] FRBList){
        for(Process_Adherence_Monitoring__c p:FRBLIST){
            p.status__C = 'Closed';
            p.Account_Resolution_Date__c= System.today();
            p.ToupdateCloseStatus__c = true;
        }
        checkRecursive.stopTrigger();
        Database.Saveresult[] srList = database.update(FRBList,false);
        system.debug('Result: ' + srList);
    }
    
    global void finish(Database.BatchableContext bc){
    	
    	AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
						      TotalJobItems, CreatedBy.Email
						      FROM AsyncApexJob 
						      WHERE Id = :BC.getJobId()];
						      
		// Send an email to the Apex job's submitter notifying of job completion.
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {'lcsalesforceadmin@mcmcg.com'};
		mail.setToAddresses(toAddresses);
		mail.setSubject('Apex Sharing Recalculation ' + a.Status);
		mail.setPlainTextBody('The CCM_BatchToUpdateCloseStatus batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
		
		if(!Test.isRunningTest()){
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });				      
		}
		
		system.debug('a---------->'+a);
						      
		if(a != null && a.NumberOfErrors == 0 && !Test.isRunningTest()){
			
			Database.executeBatch(new CCM_UpdateExceptionFieldsBatch(),1);
		
		}else{
			
			Messaging.SingleEmailMessage sendErrorMail = new Messaging.SingleEmailMessage();
			String[] notifyUserAddress = new String[] {'lcsalesforceadmin@mcmcg.com'};
			sendErrorMail.setToAddresses(notifyUserAddress);
			sendErrorMail.setSubject('CCM_UpdateExceptionFieldsBatch did\'nt run');
			sendErrorMail.setPlainTextBody('CCM_UpdateExceptionFieldsBatch did\'nt run beacause CCM_UpdateExceptionFieldsBatch '+ a.Status+' Apex job has ' + a.NumberOfErrors + ' failures. \n Please fix and run it manually.');
			
			if(!Test.isRunningTest()){
				Messaging.sendEmail(new Messaging.SingleEmailMessage[] { sendErrorMail });			
			}
		
		}
    }
}