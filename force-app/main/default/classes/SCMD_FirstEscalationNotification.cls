global class SCMD_FirstEscalationNotification implements Database.Batchable<sObject>, Database.stateful {
	
	public String reportingPeriod{set; get;}
	//List<Exception> errors = new List<Exception>();
	
	global SCMD_FirstEscalationNotification(String reportingPeriod){
		
		this.reportingPeriod = reportingPeriod;
	}
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
    	
        // collect the batches of records or objects to be passed to execute

        String recordTypeScmDispute = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute').getRecordTypeId();
    	String status = 'New';
    	
        String query = 'SELECT Id, Name, Organization_Name__c, Organization_Name__r.Name, Organization_Name__r.Firm_ID__c, RecordTypeId, RecordType.Name,'
        				+' Status__c , SCMD_Reporting_Period__c '
        				+'FROM Process_Adherence_Monitoring__c ' 
        				+'WHERE RecordTypeId = :recordTypeScmDispute AND Status__c = :status AND SCMD_Reporting_Period__c = :reportingPeriod';
        				
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){
    	
    	try{
    	
	        Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId = new Map<Id, List<Process_Adherence_Monitoring__c>>();
	        Map<Id, List<AccountContactRelation>> accountContactRelListByAccId = new Map<Id, List<AccountContactRelation>>();
	        
	        for(Process_Adherence_Monitoring__c pamObj : pamList){
	        	
	        	pamObj.Status__c = 'First Escalation';
	        	
	        	if(pamListByAccId.containsKey(pamObj.Organization_Name__c)){
	        		
	        		List<Process_Adherence_Monitoring__c> pamTempList = pamListByAccId.get(pamObj.Organization_Name__c);
	        		
	        		pamTempList.add(pamObj);
	        		
					pamListByAccId.put(pamObj.Organization_Name__c, pamTempList);	        		
	        		
	        	}else{
	        		
	        		pamListByAccId.put(pamObj.Organization_Name__c, new List<Process_Adherence_Monitoring__c>{pamObj});
	        	}
	        	
	        }
	        
	        
	        
	       List<AccountContactRelation> accountContactRelationList = [SELECT Id, AccountId, Account.Name, ContactId, Contact.FirstName, Contact.Email,  
		       															Contact.Community_User__c FROM AccountContactRelation 
		       															WHERE AccountId IN :pamListByAccId.keySet()  
		       															AND Contact.Contact_Type_SME__c Includes('Process Adherence Monitoring (PAM)') 
		       															AND Contact.Inactive_Contact__c = FALSE];
	       															
	       
	       for( AccountContactRelation accountConRelObj : accountContactRelationList){
	       	
	       		if(accountContactRelListByAccId.containsKey(accountConRelObj.AccountId)){
	       			
	       			List<AccountContactRelation> temp = accountContactRelListByAccId.get(accountConRelObj.AccountId);
	       			temp.add(accountConRelObj);
	       			accountContactRelListByAccId.put(accountConRelObj.AccountId, temp);
	       		
	       		}else{
	       			
	       			accountContactRelListByAccId.put(accountConRelObj.AccountId, new List<AccountContactRelation> {accountConRelObj});	
	       		}
	       		
	       }
	       
	       if(!pamListByAccId.isEmpty()){
	       
		       update pamList;
		       SCMDisputeService.sendFirstEscalationEmailToContacts(pamListByAccId, accountContactRelListByAccId);
		       
	       }
	       
    	}catch(Exception ex){
    		
    		 //errors.add(ex);
 			 system.debug('Exception in SCMD_FirstEscalationNotification-->'+ex);
 			 throw ex; 
    	}
        
    }
        
    global void finish(Database.BatchableContext bc){
    	
    	
        // execute any post-processing operations
        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
					      TotalJobItems, CreatedBy.Email
					      FROM AsyncApexJob WHERE Id = :bc.getJobId()];
		
		List<Messaging.SingleEmailMessage> mailsTosend = new List<Messaging.SingleEmailMessage>();
					      
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'SCMD_FirstEscalationNotification');
	   	
	   	mailsTosend.add(mail);
	   	
	   	/*if(!errors.isEmpty()) {
	   	 	
	   	 	Messaging.SingleEmailMessage errorMail = Utils.getExceptionErrorMail(errors, 'SCMD_FirstEscalationNotification');
	   	 	
            mailsTosend.add(errorMail);
            
	   	 }*/
	   	
	   	if(!Test.isRunningTest()){
	   		
	   		Messaging.sendEmail(mailsTosend);
	   	}
	   	
    }  
      
}