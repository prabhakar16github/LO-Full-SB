public class SCMDUM_ACFNoResponseNotification implements Database.Batchable<sObject> {
	
	public String reportingPeriod{set; get;}
	
	public SCMDUM_ACFNoResponseNotification(String reportingPeriod){
		this.reportingPeriod = reportingPeriod;
	}
 
	public Database.QueryLocator start(Database.BatchableContext bc){
        
        String statusFinalEscalation = 'Final Escalation';
        Double dayNine = 9;
        Set<Id> pamIdSet = new Set<Id>();
        Id pamUMScmDisputeRecordTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF SCMDUM').getRecordTypeId();
        
        List<PAM_Unmatched__c> scmdUnmatchedList = [SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, PAMUM_Status__c 
        												FROM PAM_Unmatched__c 
        												WHERE SCMDUM_Reporting_Period__c = :reportingPeriod 
        													AND PAMUM_Status__c = :statusFinalEscalation 
        													AND PAMUM_Day_Counter__c = :dayNine 
        													AND recordTypeId = :pamUMScmDisputeRecordTypeId ];
        													
     	for(PAM_Unmatched__c scmdUmObj : scmdUnmatchedList){
        	pamIdSet.add(scmdUmObj.PAMUM_Process_Adherence_Monitoring__c);
        } 
        
        String query = 'SELECT Id, Name, Organization_Name__c, Organization_Name__r.Owner.Email, '
        				+'Organization_Name__r.Firm_ID__c, SCMD_Reporting_Period__c'
        				+', (SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, PAMUM_Status__c'
        				+' FROM PAM_Unmatched__r WHERE PAMUM_Day_Counter__c = :dayNine'
        				+' AND SCMDUM_Reporting_Period__c = :reportingPeriod'
        				+' AND PAMUM_Status__c = :statusFinalEscalation )'
        				+' FROM Process_Adherence_Monitoring__c WHERE Id IN :pamIdSet';
        				
        return Database.getQueryLocator(query);
        
    }
	
	public void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){
		try{
	        SCMDisputeService.sendSCMDUMACFNoResponseMail(pamList);
			ApexDebugLog.debug('SCMDUM_ACFNoResponseNotification execute pamList '+pamList);
		}catch(Exception e){
			new ApexDebugLog().createLog( new ApexDebugLog.Error( 'SCMDUM_ACFNoResponseNotification','execute', NULL, e));	
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
					      
		Messaging.SingleEmailMessage mail = Utils.getBatchStatusMail(a, 'SCMDUM_ACFNoResponseNotification');
		mailsTosend.add(mail);
		
		if(!Test.isRunningTest()){
	   		Messaging.sendEmail(mailsTosend);
	   	}
        
    }
}