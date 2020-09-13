@isTest
private class LC_OrganizationNameonUserSupportTest {

    static testMethod void LC_OrganizationNameonUserSupportTest() {
        Account a1 = new Account();
        a1.Name = 'TestAcc';
        a1.Firm_ID__c = 'Test';
        insert a1;
        
        Contact c = new Contact();
        c.AccountId = a1.id;
        c.LastName = 'abc';
        c.FirstName='aa';
        insert c;
        
        User_Support__c Ci = new User_Support__c();
        Ci.Organization_Name__c = a1.id;
        Ci.First_Name__c = 'test';
        Ci.Last_Name__c = 'Last';
        Ci.Email_Address__c = 'ishanometa@gmail.com';
        
        insert Ci;
        
    }
}