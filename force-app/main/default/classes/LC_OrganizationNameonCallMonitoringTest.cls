@isTest
private class LC_OrganizationNameonCallMonitoringTest {

    static testMethod void LC_OrganizationNameonCallMonitoringTest() {
        Account a1 = new Account();
        a1.Name = 'TestAcc';
        a1.Firm_ID__c = 'Test';
        insert a1;
        
        Contact c = new Contact();
        c.AccountId = a1.id;
        c.LastName = 'abc';
        c.FirstName='aa';
        insert c;
        
        Id pId = [SELECT Id FROM Profile WHERE UserType = 'CspLitePortal' LIMIT 1].Id;
        User user1 = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = pId, ContactId = c.Id, CommunityNickname='test123',
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        
        insert user1;
        
        Id RecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Materials').getRecordTypeId();
        Call_Monitoring__c Ci = new Call_Monitoring__c();
        
        Ci.Organization_Name_CM__c = a1.id;
        Ci.Account_Type_CM__c = 'AA';
        Ci.Reporting_Month_CM__c = '01';
        Ci.Reporting_Year_CM__c = '2016';
        Ci.RecordTypeId = RecordTypeId;
        
        insert Ci;
        
    }
}