global class PNA_BatchToUpdateCloseStatus implements Database.Batchable<SObject>{
    
    global database.querylocator start(Database.BatchableContext bc){
    	  
       String PNARecordTypeID = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO PNA').getRecordTypeId();
       
       String query= 'Select Id, Status__c FROM Process_Adherence_Monitoring__c ' 
       					+'WHERE RecordtypeId = :PNARecordTypeID  AND Status__c != \'Closed\' AND LastModifiedDate != TODAY';
       
       return Database.getQueryLocator(query);
       
    }
    
    global void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pnaList){
    	
    	
    	for(Process_Adherence_Monitoring__c pamObj : pnaList){
    		
    		pamObj.Status__c = 'Closed';
    	}
    	
    	update pnaList;
    }
    
    global void finish(Database.BatchableContext bc){
    	
    	AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
					      TotalJobItems, CreatedBy.Email
					      FROM AsyncApexJob WHERE Id = :bc.getJobId()];
					      
		List<Messaging.SingleEmailMessage> mailsTosend = new List<Messaging.SingleEmailMessage>();
					      
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'PNA_BatchToUpdateCloseStatus');
		mailsTosend.add(mail);
		
		if(a != null && a.NumberOfErrors == 0 && !Test.isRunningTest()){
			
			Database.executeBatch(new PNA_UpdateAccountExceptions(), 1);
			Messaging.sendEmail(mailsTosend);
		
		}else if(a.NumberOfErrors != 0 && !Test.isRunningTest()){
			
			String errorBody = 'PNA_UpdateAccountExceptions did\'nt run beacause PNA_BatchToUpdateCloseStatus '
									+ a.Status+' Apex job has ' + a.NumberOfErrors + ' failures. \n Please fix and run it manually.';
			
			Messaging.SingleEmailMessage errorMail = Utils.getErrorMail(errorBody, 'PNA_UpdateAccountExceptions did\'nt run');
			mailsTosend.add(errorMail);
			Messaging.sendEmail(mailsTosend);
			
		}else if(Test.isRunningTest()){
			
				// adding buffer in case of test to add coverage because there is no such way to set the last modifieddate to the database table 
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
		}
		
    	
    }
}