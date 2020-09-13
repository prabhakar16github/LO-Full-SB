@isTest
private class LC_OrganizationNameonConsumerInquiryTest {

    static testMethod void LC_OrganizationNameonConsumerInquiryTest()
     {
       Account a1 = new Account();
        a1.Name = 'TestAcc';
        a1.Firm_ID__c = 'Test';
        insert a1;
        
        Contact c = new Contact();
        c.AccountId = a1.id;
        c.LastName = 'abc';
        c.FirstName='aa';
        insert c;
        
        Consumer_Inquiries__c Ci = new Consumer_Inquiries__c();
        
        Ci.Theme_of_Inquiry__c = 'Communication tactics';
        Ci.Nature_of_Inquiry__c = 'Bankruptcy';
        Ci.Source_of_Inquiry__c = 'Email';
        Ci.Classification_of_Inquiry__c = 'Complaint';
        Ci.Inquiry_Summary__c = 'test';
        Ci.Account_Type__c	 = 'AA';
        Ci.Account_Number__c = 'test';
        Ci.Consumer_Name__c = 'test';
        Ci.Complainant_Name__c = 'test';
        Ci.Date_Received__c = system.today();
        Ci.Firm_Name__c = a1.id;
        
        insert Ci;
     }
}