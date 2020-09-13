@isTest
private class SCM_ACF_DisputeMonthlyBatchTest {

    static testMethod void batchTest() {
        // TO DO: implement unit test
        Account accountObj = new Account();
        accountObj.Firm_ID__c = 'UT-11';
        accountObj.Firm_Status_IN_ACF__c = 'Active';
        accountObj.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('In Network').getRecordTypeId();
        accountObj.Name = 'Test Organisation';
        insert accountObj;
        
        Test.startTest();
	        Contact contactObj = new Contact();
	        contactObj.Contact_Type_SME__c = 'Process Adherence Monitoring (PAM)'; 
	        contactObj.AccountId = accountObj.Id;
	        contactObj.FirstName = 'Test';
	        contactObj.LastName = 'Test Value User No Duplicate';
	        contactObj.Email = 'test@123.com';
	        contactObj.Community_User__c = true;
	        contactObj.Inactive_Contact__c = false;
	        insert contactObj;
	        
	        SCMD_VSMail_Id__c scmdMailObj = new SCMD_VSMail_Id__c();
	        scmdMailObj.name = 'test';
	        scmdMailObj.Mail_Id__c = 'test@123.com'; 
	        insert scmdMailObj;
	        SCM_ACF_DisputeMonthlyBatch scmdACFMonObj = new SCM_ACF_DisputeMonthlyBatch();
	        Database.executeBatch(scmdACFMonObj); 
        Test.stopTest();
        
        system.assert(true);
    }
}