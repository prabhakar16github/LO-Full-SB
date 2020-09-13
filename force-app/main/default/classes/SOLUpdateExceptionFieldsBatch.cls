global class SOLUpdateExceptionFieldsBatch implements Database.Batchable<SObject>{

    global database.querylocator start(Database.BatchableContext bc){
    	
        /*List<AggregateResult> accountsInUse = [SELECT Organization_Name__c, COUNT_DISTINCT(Organization_Name__r.Name) FROM Process_Adherence_Monitoring__c 
                                                WHERE Organization_Name__c != null GROUP By Organization_Name__c];
        List<String> accountIdList = new List<String>();
        for(AggregateResult aggregateObj : accountsInUse){
            accountIdList.add(aggregateObj.get('Organization_Name__c')+'');
        }
        String query = 'SELECT FRB_Firm_Check__c, SOL_Exceptions_0_4__c, SOL_Exceptions_5_9__c, SOL_Exceptions_10__c FROM Account WHERE id in: accountIdList';
        */
        String query = 'SELECT Id, FRB_Firm_Check__c, SOL_Exceptions_0_4__c, SOL_Exceptions_5_9__c, SOL_Exceptions_10__c FROM Account WHERE Id IN (SELECT Organization_Name__c FROM Process_Adherence_Monitoring__c WHERE Organization_Name__c != null)';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accList){
        Id recordTypeSOL =  Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SOL').getRecordTypeId();
        List<AggregateResult> aggregateCCMList = [SELECT Account_Standing__c,Organization_Name__c, Count(Id) FROM Process_Adherence_Monitoring__c WHERE 
                                                    Organization_Name__c IN: accList AND (Account_Standing__c = '0-4 Days (New Exception)' OR 
                                                    Account_Standing__c = '5-9 Days (Approaching Critical Timeframe)' OR
                                                    Account_Standing__c = '10+ Days (Immediate Correction Required)') AND Status__c != 'Closed' AND 
                                                    RecordtypeId =: recordTypeSOL Group By Organization_Name__c,Account_Standing__c];
        
        Map<Id,Account> accountMap = new Map<Id,Account>(accList);
        
        for(Account accObj : accList){
            accObj.SOL_Exceptions_0_4__c = 0;
            accObj.SOL_Exceptions_5_9__c  = 0;
            accObj.SOL_Exceptions_10__c = 0;
        }
        
        for(AggregateResult aggObj : aggregateCCMList){
            if(accountMap.get(aggObj.get('Organization_Name__c')+'') == null) continue;
            Account accObj = accountMap.get(aggObj.get('Organization_Name__c')+'');
            accObj.FRB_Firm_Check__c = true;
            if(aggObj.get('Account_Standing__c') == '0-4 Days (New Exception)'){
                accObj.SOL_Exceptions_0_4__c = Decimal.ValueOf(String.ValueOf(aggObj.get('expr0')));
            }
              
            if(aggObj.get('Account_Standing__c') == '5-9 Days (Approaching Critical Timeframe)'){
                accObj.SOL_Exceptions_5_9__c  = Decimal.ValueOf(String.ValueOf(aggObj.get('expr0')));
            }
             
            if(aggObj.get('Account_Standing__c') == '10+ Days (Immediate Correction Required)'){
                accObj.SOL_Exceptions_10__c = Decimal.ValueOf(String.ValueOf(aggObj.get('expr0')));
            }
        }
        
        update accList;
    }
    
    global void finish(Database.BatchableContext bc){
    
	// Get the ID of the AsyncApexJob representing this batch job
	   // from Database.BatchableContext.
	   // Query the AsyncApexJob object to retrieve the current job's information.
	   AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
						      TotalJobItems, CreatedBy.Email
						      FROM AsyncApexJob 
						      WHERE Id = :BC.getJobId()];
						      
	   // Send an email to the Apex job's submitter notifying of job completion.
	   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	   String[] toAddresses = new String[] {'lcsalesforceadmin@mcmcg.com'};
	   mail.setToAddresses(toAddresses);
	   mail.setSubject('Apex Sharing Recalculation ' + a.Status);
	   mail.setPlainTextBody('The SOLUpdateExceptionFieldsBatch batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
	   
	   if(!Test.isRunningTest()){
		   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	   }
	   
	    if(a != null && a.NumberOfErrors == 0 && !Test.isRunningTest()){
	    	Database.executeBatch(new PAM_SendSOLNotificationBatch(),1);
	    }else{
	    
		   Messaging.SingleEmailMessage sendErrorMail = new Messaging.SingleEmailMessage();
		   String[] notifyUserAddress = new String[] {'lcsalesforceadmin@mcmcg.com'};
		   sendErrorMail.setToAddresses(notifyUserAddress);
		   sendErrorMail.setSubject('PAMSendSOL Notification did\'nt run');
		   sendErrorMail.setPlainTextBody('PAMSendSOL Notification did\'nt run beacause SOLUpdateExceptionFieldsBatch '+ a.Status+', Apex job has ' + a.NumberOfErrors + ' failures. \n Please fix and run it manually.');
		   
		   if(!Test.isRunningTest()){
			   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { sendErrorMail });
		   }
	    	
	    }
    }
}