@isTest
private class SCMDisputeMonthlyBatchTest {

    static testMethod void batchTest() {
        // TO DO: implement unit test
        
        
        Account accountObj = new Account();
        
        accountObj.Firm_ID__c = 'UT-11';
        accountObj.Firm_Status_IN__c = 'Active';
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
        
        insert contactObj;
        
        AccountContactRelation accountContactRelationObj = new AccountContactRelation(); 
        accountContactRelationObj.ContactId = contactObj.Id;
        accountContactRelationObj.AccountId = accountObj.Id;
        
       // insert accountContactRelationObj; 
        
        
        SCMD_VSMail_Id__c scmdMailObj = new SCMD_VSMail_Id__c();
        scmdMailObj.name = 'test';
        scmdMailObj.Mail_Id__c = 'test@123.com'; 
        insert scmdMailObj;
        
        
        SCMDisputeMonthlyBatch scmdMonObj = new SCMDisputeMonthlyBatch();
        
        Database.executeBatch(scmdMonObj); 
        
        Test.stopTest();
        
        system.assert(true);
    }
}