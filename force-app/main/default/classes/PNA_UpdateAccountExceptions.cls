global class PNA_UpdateAccountExceptions implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
    	
    	String query = 'SELECT Id, Name, PNA_Exceptions_0_3_bucket__c, PNA_Exceptions_4_6_bucket__c, PNA_Exceptions7Plusbucket__c FROM Account WHERE Id '
    						+'IN (SELECT Organization_Name__c FROM Process_Adherence_Monitoring__c WHERE Organization_Name__c != null)';  
    						
    	return Database.getQueryLocator(query);
    	 
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accountList){
        // process each batch of records
        
        Id recordTypeLo_PNA =  Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO PNA').getRecordTypeId();
        
        Map<Id, Account> accountByAccountId = new Map<Id, Account>(accountList);
        
        for(Account accountObj : accountList){
			
			accountObj.PNA_Exceptions_0_3_bucket__c = 0;
			accountObj.PNA_Exceptions_4_6_bucket__c = 0;
			accountObj.PNA_Exceptions7Plusbucket__c = 0;        	
        	
        }
        
        List<AggregateResult> aggregateResults = [SELECT Account_Standing__c,Organization_Name__c, Count(Id) FROM Process_Adherence_Monitoring__c WHERE 
                                                    Organization_Name__c IN :accountByAccountId.keySet() 
                                                    AND (Account_Standing__c = '0-3 Days (Green - New Exception)' OR 
                                                    Account_Standing__c = '4-6 Days (Yellow - Outside Correction Timeframe)' OR
                                                    Account_Standing__c = '7+ Days (Red - Immediate Correction Required)') AND Status__c != 'Closed'  
                                                    AND RecordtypeId = :recordTypeLo_PNA Group By 
                                                    Organization_Name__c,Account_Standing__c];
		
		for(AggregateResult aggregateObj : aggregateResults){
			
			Account accountObj = accountByAccountId.get(String.valueOf(aggregateObj.get('Organization_Name__c')));
			
			if(aggregateObj.get('Account_Standing__c') == '0-3 Days (Green - New Exception)'){
				
				accountObj.PNA_Exceptions_0_3_bucket__c = Decimal.ValueOf(String.ValueOf(aggregateObj.get('expr0')));
			}
			
			if(aggregateObj.get('Account_Standing__c') == '4-6 Days (Yellow - Outside Correction Timeframe)'){
				
				accountObj.PNA_Exceptions_4_6_bucket__c = Decimal.ValueOf(String.ValueOf(aggregateObj.get('expr0')));
			}
			
			if(aggregateObj.get('Account_Standing__c') == '7+ Days (Red - Immediate Correction Required)'){
				
				accountObj.PNA_Exceptions7Plusbucket__c = Decimal.ValueOf(String.ValueOf(aggregateObj.get('expr0')));
			}
			
			accountByAccountId.put(accountObj.Id, accountObj);
		
		}
		
		update accountByAccountId.values();
    }
        
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
					      TotalJobItems, CreatedBy.Email
					      FROM AsyncApexJob WHERE Id = :bc.getJobId()];
					      
		List<Messaging.SingleEmailMessage> mailsTosend = new List<Messaging.SingleEmailMessage>();
					      
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'PNA_UpdateAccountExceptions');
		mailsTosend.add(mail);
		
		if(a != null && a.NumberOfErrors == 0 && !Test.isRunningTest()){
			
			Database.executeBatch(new PNA_SendReportNotification(), 1);
			Messaging.sendEmail(mailsTosend);
		
		}else if(!Test.isRunningTest()){
			
			String errorBody = 'PNA_SendReportNotification did\'nt run beacause PNA_UpdateAccountExceptions '
									+ a.Status+' Apex job has ' + a.NumberOfErrors + ' failures. \n Please fix and run it manually.';
			
			Messaging.SingleEmailMessage errorMail = Utils.getErrorMail(errorBody, 'PNA_SendReportNotification did\'nt run');
			mailsTosend.add(errorMail);
			Messaging.sendEmail(mailsTosend);
			
		}
    }
        
}