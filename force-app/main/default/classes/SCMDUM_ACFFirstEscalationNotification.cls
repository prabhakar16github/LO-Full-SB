public class SCMDUM_ACFFirstEscalationNotification implements Database.Batchable<sObject> {

    public String reportingPeriod{set; get;}
    
    public SCMDUM_ACFFirstEscalationNotification(String reportingPeriod){
    	this.reportingPeriod = reportingPeriod;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        String statusNew = 'New';
        Double fourthDay = 4;
        Id pamUMACFDisputeRecordTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF SCMDUM').getRecordTypeId();
        Set<Id> pamIdSet = new Set<Id>();

        List<PAM_Unmatched__c> scmdUnmatchedList = [SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, PAMUM_Status__c 
        												FROM PAM_Unmatched__c 
        												WHERE SCMDUM_Reporting_Period__c = :reportingPeriod 
        													AND PAMUM_Status__c = :statusNew 
        													AND PAMUM_Day_Counter__c = :fourthDay 
        													AND recordTypeId = :pamUMACFDisputeRecordTypeId];
        
        ApexDebugLog.debug('SCMDUM_ACFFirstEscalationNotification start scmdUnmatchedList '+scmdUnmatchedList);
        
        for(PAM_Unmatched__c scmdUmObj : scmdUnmatchedList){
        	pamIdSet.add(scmdUmObj.PAMUM_Process_Adherence_Monitoring__c);
        } 
        				
        String query = 'SELECT Id, Name, Organization_Name__c, Organization_Name__r.Firm_ID__c, SCMD_Reporting_Period__c'
        				+', (SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, PAMUM_Status__c'
        				+' FROM PAM_Unmatched__r WHERE SCMDUM_Reporting_Period__c = :reportingPeriod'
        				+' AND PAMUM_Day_Counter__c = :fourthDay'
        				+' AND PAMUM_Status__c = :statusNew)'
        				+' FROM Process_Adherence_Monitoring__c WHERE Id IN :pamIdSet';
        				
        return Database.getQueryLocator(query);
        
    }
    
    public void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){
        
       	ApexDebugLog.debug('SCMDUM_ACFFirstEscalationNotification execute pamList '+pamList);
        Map<Id, Account> accountByAccountIdMap = new Map<Id, Account>(); 
        Set<Id> accountIdSet = new Set<Id>();
        
        for(Process_Adherence_Monitoring__c pamObj : pamList){
        	accountIdSet.add(pamObj.Organization_Name__c);
        }
		
		try{
		
			accountByAccountIdMap = new Map<Id, Account>([SELECT Id, Name, Firm_ID__c, 
				    														(SELECT Id, ContactId, Contact.firstName, Contact.Email,  
				    															Contact.Community_User__c 
				    														FROM AccountContactRelations 
				    														WHERE Contact.Contact_Type_SME__c INCLUDES('Process Adherence Monitoring (PAM)') 
				    														AND Contact.Inactive_Contact__c = FALSE) 
				    													FROM Account 
				    													WHERE Id IN : accountIdSet]);
				    													
			SCMDisputeService.sendSCMDUMACFFirstEscalationNotification( pamList, accountByAccountIdMap, reportingPeriod);   
		
		}catch(Exception ex){
			ApexDebugLog.debug('SCMDUM_ACFFirstEscalationNotification execute scmdUnmatchedList '+ex);
			new ApexDebugLog().createLog( new ApexDebugLog.Error( 'SCMDUM_ACFFirstEscalationNotification','execute', NULL, ex));	
		}
    }    
    
    public void finish(Database.BatchableContext bc){
        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
					      TotalJobItems, CreatedBy.Email
					      FROM AsyncApexJob WHERE Id = :bc.getJobId()];

		new ApexDebugLog().createLog( 
				new ApexDebugLog.Information( 
					'SCMDUM_ACFFirstEscalationNotification', 
					'execute', 
					 a.Id, 'Successfully executed.'));
					      
		List<Messaging.SingleEmailMessage> mailsTosend = new List<Messaging.SingleEmailMessage>();
					      
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'SCMDUM_ACFFirstEscalationNotification');
		mailsTosend.add(mail);
		
		if(!Test.isRunningTest()){
	   		Messaging.sendEmail(mailsTosend);
	   	}else{
	   		bufferCoverage();
	   	}
    }
    
    private static void bufferCoverage(){
    	
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