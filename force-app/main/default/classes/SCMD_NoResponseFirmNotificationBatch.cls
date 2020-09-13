global class SCMD_NoResponseFirmNotificationBatch implements Database.Batchable<sObject>, Database.stateful {
    
    public String reportingPeriod{set; get;}
    //List<Exception> errors = new List<Exception>();
    
    public SCMD_NoResponseFirmNotificationBatch(String reportingPeriod){
    
    	this.reportingPeriod = reportingPeriod;
    	
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        
        String finalEscalationStatus = 'Final Escalation';
        String recordTypeScmDispute = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute').getRecordTypeId();
        
        String query = 'SELECT Id, Name, Organization_Name__c, Organization_Name__r.Name, Organization_Name__r.Firm_ID__c, RecordTypeId, RecordType.Name,'
        				+' Status__c , SCMD_Reporting_Period__c '
        				+'FROM Process_Adherence_Monitoring__c ' 
        				+'WHERE RecordTypeId = :recordTypeScmDispute AND Status__c = :finalEscalationStatus '
        				+'AND SCMD_Reporting_Period__c = :reportingPeriod';
        				
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){
        // process each batch of records
        
        try{
        
	        Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId = new Map<Id, List<Process_Adherence_Monitoring__c>>();
	        Map<Id, String> accountOwnerEmailByAccId = new Map<Id, String>();
	        
	        for(Process_Adherence_Monitoring__c pamObj : pamList){
	        	
	        	if(pamListByAccId.containsKey(pamObj.Organization_Name__c)){
	        		
	        		List<Process_Adherence_Monitoring__c> pamTempList = pamListByAccId.get(pamObj.Organization_Name__c);
	        		
	        		pamTempList.add(pamObj);
	        		
					pamListByAccId.put(pamObj.Organization_Name__c, pamTempList);	        		
	        		
	        	}else{
	        		
	        		pamListByAccId.put(pamObj.Organization_Name__c, new List<Process_Adherence_Monitoring__c>{pamObj});
	        	}
	        	
	        }
	        
	        List<Account> accountList = [SELECT OwnerId, Owner.Name, Owner.Email FROM Account WHERE Id IN :pamListByAccId.keySet()]; 
	        
	        for(Account accountObj : accountList){
	        	
	        	accountOwnerEmailByAccId.put(accountObj.Id, accountObj.Owner.Email);
	        }
	        
	        if(pamListByAccId != null){
		        SCMDisputeService.sendNoResponseFirmsMailToOwners(pamListByAccId, accountOwnerEmailByAccId);
	        }
	        
        }catch(Exception ex){
			
			//errors.add(ex);
 			system.debug('Exception in SCMD_NoResponseFirmNotificationBatch-->'+ex);
 			throw ex;        
        }
        
    }    
    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        
        
         AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
					      TotalJobItems, CreatedBy.Email
					      FROM AsyncApexJob WHERE Id = :bc.getJobId()];
					      
		List<Messaging.SingleEmailMessage> mailsTosend = new List<Messaging.SingleEmailMessage>();
					      
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'SCMD_NoResponseFirmNotificationBatch');
		mailsTosend.add(mail);
	   	
	   	/*if(!errors.isEmpty()) {
	   	 	
	   	 	Messaging.SingleEmailMessage errorMail = Utils.getExceptionErrorMail(errors, 'SCMD_NoResponseFirmNotificationBatch');
	   	 	
            mailsTosend.add(errorMail);
            
	   	 }*/
	   	
	   	if(!Test.isRunningTest()){
	   		
	   		Messaging.sendEmail(mailsTosend);
	   	}
        
    }    
    
}