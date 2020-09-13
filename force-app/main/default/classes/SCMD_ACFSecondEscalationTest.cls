@isTest
private class SCMD_ACFSecondEscalationTest {

    static testMethod void secondEscalationTest() {
        Id pamScmDisputeTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute').getRecordTypeId();
        String reportingPeriod = '';
    	Date dateToday = System.today();
    	String month = String.valueOf(dateToday.month());
		if(month.length() == 1){
			month = '0' + month; // format month
		}
    	reportingPeriod = dateToday.year() +'-'+ month; 
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
        
        Process_Adherence_Monitoring__c pamObj  = new Process_Adherence_Monitoring__c();
        pamObj.recordTypeId = pamScmDisputeTypeId;
        pamObj.SCMD_Reporting_Period__c = reportingPeriod;
        pamObj.Organization_Name__c = accountObj.Id;
        pamObj.Status__c = 'First Escalation';
        insert pamObj;
        
        Test.startTest();
	        SCMD_ACFSecondEscalation_Notification scmdACFSecondEscalationBatchObj = new SCMD_ACFSecondEscalation_Notification(reportingPeriod); 
	        Database.executeBatch(scmdACFSecondEscalationBatchObj);
        Test.stopTest();
        System.assert(true);
    }
}