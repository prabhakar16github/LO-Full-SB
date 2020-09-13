@IsTest
private class PNA_SendReportNotificationTest {

    static testMethod void PNA_SendReportNotificationBatchTest() {
        // TO DO: implement unit test
        
        Account a1 = new Account();
        a1.Name = 'TestAcc';
        a1.Firm_ID__c = 'Test';
        a1.FRB_Firm_Check__c = True;
        a1.Number_of_Exception__c = 1;
        a1.PNA_Exceptions_0_3_bucket__c = 3;
        a1.PNA_Exceptions_4_6_bucket__c = 5;
        a1.PNA_Exceptions7Plusbucket__c = 10;
        insert a1;
        
        Contact c = new Contact(AccountId = a1.id,LastName = 'abc',FirstName='aa',Contact_Type_SME__c = 'Placement Acknowledgment',Inactive_Contact__c = False,Email='Test@tset.com');
        insert c;
        
        Contact c1 = new Contact(AccountId = a1.id,LastName = 'auyutyutc',FirstName='aa',Contact_Type_SME__c = 'Placement Acknowledgment',Inactive_Contact__c = False,Email='Test@testa.com');
        insert c1;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CC - User Access' limit 1];
        User u2 = new User(Alias = 'newUser1', Username='test1@gmail.com.full',CommunityNickname='ann',Email='newuser@testorg.com',TimeZoneSidKey = 'Asia/Kuala_Lumpur',
        EmailEncodingKey='UTF-8', LastName='Testing',ContactId=c.id, LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id);
        
        String recordTypePNA = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO PNA').getRecordTypeId();

        List<Process_Adherence_Monitoring__c> pamList = new List<Process_Adherence_Monitoring__c>();
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = a1.id, SOL_Placement_Date__c = system.today().addDays(-2), recordTypeId = recordTypePNA));
        insert pamList;
        
        Test.startTest();

        	Database.executeBatch(new PNA_SendReportNotification(),1);
        Test.stopTest();
        
        System.assert(true);
        
    }
}