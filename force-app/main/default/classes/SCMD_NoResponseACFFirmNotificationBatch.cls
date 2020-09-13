public class SCMD_NoResponseACFFirmNotificationBatch implements Database.Batchable<sObject>, Database.stateful {
    
    public String reportingPeriod{set; get;}
    
    public SCMD_NoResponseACFFirmNotificationBatch(String reportingPeriod){
    	this.reportingPeriod = reportingPeriod;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
    	
        String finalEscalationStatus = 'Final Escalation';
        String recordTypeACFScmDispute = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute').getRecordTypeId();
        
        String query = 'SELECT Id, Name, Organization_Name__c, Organization_Name__r.Name, Organization_Name__r.Firm_ID__c, RecordTypeId, RecordType.Name,'
        				+' Status__c , SCMD_Reporting_Period__c '
        				+'FROM Process_Adherence_Monitoring__c ' 
        				+'WHERE RecordTypeId = :recordTypeACFScmDispute AND Status__c = :finalEscalationStatus '
        				+'AND SCMD_Reporting_Period__c = :reportingPeriod';
        				
        return Database.getQueryLocator(query);
        
    }
    
    public void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){
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
		        SCMDisputeService.sendNoResponseACFFirmsMailToOwners(pamListByAccId, accountOwnerEmailByAccId);
	        }
	        
        }catch(Exception e){
			ApexDebugLog.debug('Exception in SCMD_NoResponseACFFirmNotificationBatch execute ' + e);
			new ApexDebugLog().createLog( new ApexDebugLog.Error( 'SCMD_NoResponseACFFirmNotificationBatch','execute', NULL, e));
        }
        
    }    
    
    public void finish(Database.BatchableContext bc){

         AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
					      TotalJobItems, CreatedBy.Email
					      FROM AsyncApexJob WHERE Id = :bc.getJobId()];
		
		new ApexDebugLog().createLog( 
				new ApexDebugLog.Information( 
					'SCMD_NoResponseACFFirmNotificationBatch', 
					'execute', 
					 a.Id, 'Successfully executed.'));			      
		List<Messaging.SingleEmailMessage> mailsTosend = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'SCMD_NoResponseACFFirmNotificationBatch');
		mailsTosend.add(mail);
	   	if(!Test.isRunningTest()){
	   		Messaging.sendEmail(mailsTosend);
	   	}
        
    }    
    
}