public class SCMD_ACFFinalEscalation implements Database.Batchable<sObject>, Database.stateful {
	
	public String reportingPeriod{set; get;}
	
	public SCMD_ACFFinalEscalation(String reportingPeriod){
		this.reportingPeriod = reportingPeriod; 
	}
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        String recordTypeACFScmDispute = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute').getRecordTypeId();
    	String secondEscalationStatus = 'Second Escalation';
    	String finalEscalationStatus = 'Final Escalation';
        String query = 'SELECT Id, Name, Organization_Name__c, Organization_Name__r.Name, Organization_Name__r.Firm_ID__c, RecordTypeId, RecordType.Name,'
        				+' Status__c, SCMD_Reporting_Period__c '
        				+'FROM Process_Adherence_Monitoring__c ' 
        				+'WHERE RecordTypeId = :recordTypeACFScmDispute AND (Status__c = :secondEscalationStatus OR Status__c = :finalEscalationStatus) '
        				+'AND SCMD_Reporting_Period__c = :reportingPeriod';
        				
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){
        // process each batch of records
        try{
	        Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId = new Map<Id, List<Process_Adherence_Monitoring__c>>();
	        Map<Id, List<AccountContactRelation>> accountContactRelListByAccId = new Map<Id, List<AccountContactRelation>>();
	        for(Process_Adherence_Monitoring__c pamObj : pamList){
	        	pamObj.Status__c = 'Final Escalation';
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
		       SCMDisputeService.sendACFFinalEscalationEmailToContacts(pamListByAccId, accountContactRelListByAccId);
	       }
        }catch(Exception e){
			ApexDebugLog.debug('Exception in SCMD_ACFFinalEscalation execute' + e);
			new ApexDebugLog().createLog( new ApexDebugLog.Error( 'SCMD_ACFFinalEscalation','execute', NULL, e));
    	}
       
    }    
    
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
         AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
					      TotalJobItems, CreatedBy.Email
					      FROM AsyncApexJob WHERE Id = :bc.getJobId()];
		
		 new ApexDebugLog().createLog( 
				new ApexDebugLog.Information( 
					'SCMD_ACFFinalEscalation', 
					'execute', 
					 a.Id, 'Successfully executed.'));
					 			      
		List<Messaging.SingleEmailMessage> mailsTosend = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'SCMD_ACFFinalEscalation');
		mailsTosend.add(mail);
	   	if(!Test.isRunningTest()){
	   		Messaging.sendEmail(mailsTosend);
	   	}
    }
}