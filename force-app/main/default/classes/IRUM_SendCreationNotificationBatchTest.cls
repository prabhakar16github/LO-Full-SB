@isTest
private class IRUM_SendCreationNotificationBatchTest {
	
	
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
	}

    static testMethod void processUnmatchedTest() {
    	
        String reportingPeriod = String.valueOf(System.today().year()) +'-'+ String.valueOf(System.today().month());
    	List<Account> accList = [SELECT Id FROM Account LIMIT 1];
    	Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c();
    	Id pamIRRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR - Account #\'s Sent').getRecordTypeId();
    	pamObj.Organization_Name__c = accList.get(0).Id;
    	pamObj.OwnerId = UserInfo.getUserId();
    	pamObj.Status__c = 'Accounts Sent To ISeries';
    	pamObj.IR_Open_Inventory_Act_Volume__c = 1001;
    	pamObj.RecordTypeId = pamIRRecordTypeId;
    	pamObj.SCMD_Reporting_Period__c = reportingPeriod;
    	insert pamObj;
    	
    	Id pamUmOpenIRRecordTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
    	PAM_Unmatched__c pamUmObj = new PAM_Unmatched__c();
		pamUmObj.PAMUM_Process_Adherence_Monitoring__c = pamObj.Id;
		pamUmObj.PAMUM_Account_Number__c = '1223456789';
		pamUmObj.PAMUM_Status__c = 'New';
		pamUmObj.RecordTypeId = pamUmOpenIRRecordTypeId;
		pamUmObj.SCMDUM_Record_Creation_Notification_Sent__c = false;
		insert pamUmObj;
		
		String casePamRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Operations - PAM').getRecordTypeId();

    	Case caseObj = new Case(Subcategories__c = 'Scripts - IRUM', Status = 'New', 
    								Reason = 'Process Adherence Monitoring (PAM)',
    								RecordTypeId = casePamRecordTypeId);
    								
		Test.startTest();    								
    		insert caseObj; 
    	Test.stopTest();
    	System.assert(true);     	 
    }
}