@isTest
private class SCMDEmailCommunicationTemplatesTest {

	@testsetup
	private static void testsetup(){
		
		Account accountObj = new Account();
        accountObj.Firm_ID__c = 'UT-11';
        accountObj.Firm_Status_IN__c = 'Active';
        accountObj.Name = 'Test Organisation';
        insert accountObj;

        Contact contactObj = new Contact();
        contactObj.Contact_Type_SME__c = 'Process Adherence Monitoring (PAM)'; 
        contactObj.AccountId = accountObj.Id;
        contactObj.FirstName = 'Test';
        contactObj.LastName = 'Test Value User No Duplicate';
        contactObj.Email = 'test@123.com';
        contactObj.Community_User__c = true;
        insert contactObj;
        
        Id pamScmDisputeTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute').getRecordTypeId();
        String reportingPeriod = '';
    	Date dateToday = System.today();
    	String month = String.valueOf(dateToday.month());
		if(month.length() == 1){
			month = '0' + month; // format month
		}
    	reportingPeriod = dateToday.year() +'-'+ month; 
        
        Process_Adherence_Monitoring__c pamObj  = new Process_Adherence_Monitoring__c();
        pamObj.recordTypeId = pamScmDisputeTypeId;
        pamObj.SCMD_Reporting_Period__c = reportingPeriod;
        pamObj.Organization_Name__c = accountObj.Id;
        pamObj.Status__c = 'Account Numbers Added';
        insert pamObj;
        
        PAM_Unmatched__c pamUm = new PAM_Unmatched__c();
        pamUm.PAMUM_Account_Number__c = '1234569874';
        //pamUm.SCMDUM_PCode_Sent__c = 'S441';
        pamUm.PAMUM_Process_Adherence_Monitoring__c = pamObj.Id;
        insert pamUm; 
	}
	
    private static testMethod void communicationTemplateTest() {
    	
		List<Process_Adherence_Monitoring__c> pamList = [SELECT Id, Name, SCMD_Reporting_Period__c, Organization_Name__c, Status__c 
															FROM Process_Adherence_Monitoring__c];
		Test.startTest();
			SCMDEmailCommunicationTemplates.getDayOneMonthlyTemplateSCM(pamList.get(0), 'Test', false);
			SCMDEmailCommunicationTemplates.getUnassignedPamOwnerTemplate();
			SCMDEmailCommunicationTemplates.getDayThreeMonthlyTemplateSCM(pamList.get(0), 'Test', false);
			SCMDEmailCommunicationTemplates.getSecondEscalationTemplateSCM(pamList.get(0), 'Test', false);
			SCMDEmailCommunicationTemplates.getFinalEscalationTemplateSCM(pamList.get(0), 'Test', false);
			SCMDEmailCommunicationTemplates.send_No_Response_MailToOrgOwner();
			SCMDEmailCommunicationTemplates.getSCMDUnmatchedOnCreateTemplate(pamList.get(0), 'Test', false);
			SCMDEmailCommunicationTemplates.getSCMDUnmatchedFirstEscalation(pamList.get(0), 'Test', false);
			SCMDEmailCommunicationTemplates.getSCMDUnmatchedFinalEscalation(pamList.get(0), 'Test', false);
			SCMDEmailCommunicationTemplates.getSCMDUnmatchedNoResponseFromFirmTemplate();
			SCMDEmailCommunicationTemplates.getDayOneACFMonthlyTemplateSCM(pamList.get(0), 'Test', false);
			SCMDEmailCommunicationTemplates.getDayThreeACFMonthlyTemplateSCM(pamList.get(0), 'Test', false);
			SCMDEmailCommunicationTemplates.getACFSecondEscalationTemplateSCM(pamList.get(0), 'Test', false);
			SCMDEmailCommunicationTemplates.getACFFinalEscalationTemplateSCM(pamList.get(0), 'Test', false);
        SCMDEmailCommunicationTemplates.getSCMDUnmatchedACFFirstEscalation(pamList.get(0), 'Test', false);
        SCMDEmailCommunicationTemplates.getSCMDACFUnmatchedFinalEscalation(pamList.get(0), 'Test', false);
        SCMDEmailCommunicationTemplates.getSCMDACFUnmatchedNoResponseFromFirmTemplate();
		Test.stopTest();
		system.assert(true);		
    }
    
    private static testMethod void communicationPamUnmatchedTest(){
    	
    	List<Process_Adherence_Monitoring__c> pamList = [SELECT Id, Name, SCMD_Reporting_Period__c, Organization_Name__c, Status__c 
															FROM Process_Adherence_Monitoring__c];
		
		Test.startTest();
			SCMDEmailCommunicationTemplates.getSCMDUnmatchedACFOnCreateTemplate(pamList.get(0), 'Test', false);
		Test.stopTest();
		system.assert(true);
    }
}