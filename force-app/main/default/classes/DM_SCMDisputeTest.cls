@isTest
private class DM_SCMDisputeTest {
    @testSetup
    static void testSetup(){
        Account acc = new Account();
        acc.Name = 'TestAcc';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('In Network').getRecordTypeId();
        acc.Firm_Status_IN__c = 'Active';
        acc.Firm_ID__c = '123';
        insert acc;    
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'testCon';
        con.Email = 'con@test.com';
        con.Contact_Type_SME__c = 'Process Adherence Monitoring (PAM)';
        con.Inactive_Contact__c = false;
        con.Community_User__c = true;
        insert con;
        
        EmailNotification__c em = new EmailNotification__c();
        em.Name = 'System Admin';
        em.Email__c = 'test@abc.com';
        insert em;
        
    }
    
    @isTest
    static void creationTestMethod(){
        Account acct = [SELECT Id FROM Account WHERE Name='TestAcc' LIMIT 1];
        
        Test.startTest();
        DM_SCMDisputeMonthlyBatch initial = new DM_SCMDisputeMonthlyBatch();
        Database.executeBatch(initial);
        /*IR_ACF_InitialNotificationBatchScheduler initial = new IR_ACF_InitialNotificationBatchScheduler();
        initial.execute(null);
        System.assert(true);*/
        Test.stopTest();
    }
    @isTest
    static void firstNotification(){
        Account acct = [SELECT Id FROM Account WHERE Name='TestAcc1' LIMIT 1];
        Test.startTest();
        DM_SCMD_FirstEscalation first = new DM_SCMD_FirstEscalation();
        Database.executeBatch(first);
		DM_SCMD_SecondEscalation second = new DM_SCMD_SecondEscalation();
        Database.executeBatch(second);
		DM_SCMD_FinalEscalation finl = new DM_SCMD_FinalEscalation();
        Database.executeBatch(finl);
		DM_SCMD_NoResponse noResponse = new DM_SCMD_NoResponse();
        Database.executeBatch(noResponse);

        Test.stopTest();
    }

}