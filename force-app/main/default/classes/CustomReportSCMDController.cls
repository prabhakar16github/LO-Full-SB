public class CustomReportSCMDController {

	public transient List<Process_Adherence_Monitoring__c> pamRecordsList {set; get;}
	
    public CustomReportSCMDController(){
    	
    	String pamAccountSentToIseries = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute').getRecordTypeId();
    	String statusAccountNoAdded = 'Account Numbers Added';
		    
		pamRecordsList = [SELECT Id, Name, Organization_Name__r.Name, recordTypeId, SCMD_Oral_Dispute_Account_s__c, 
								 SCMD_Written_Dispute_Account_s__c, SCMD_MailOutValidation_of_Debt_Account_s__c 
						  FROM Process_Adherence_Monitoring__c
						  WHERE recordTypeId = :pamAccountSentToIseries AND Status__c = :statusAccountNoAdded];
						  
    }
    
}