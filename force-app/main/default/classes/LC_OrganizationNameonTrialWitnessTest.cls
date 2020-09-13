@isTest
private class LC_OrganizationNameonTrialWitnessTest {

    static testMethod void LC_OrganizationNameonTrialWitnessTest() {
        Account a1 = new Account();
        a1.Name = 'TestAcc';
        a1.Firm_ID__c = 'Test';
        insert a1;
        
        Contact c = new Contact();
        c.AccountId = a1.id;
        c.LastName = 'abc';
        c.FirstName='aa';
        insert c;
        
        Trial_Witness_Request__c Ci = new Trial_Witness_Request__c();
        Ci.Account_Number__c = 'test';
        Ci.Defendant_Name__c = 'test';
        Ci.Date_of_Trial__c = system.today();
        Ci.Date_Response_is_Needed_By__c = system.today();
        Ci.Time_of_Trial__c = '01:00';
        Ci.AM_PM__c = 'AM';
        Ci.Time_Zone__c = 'Eastern';
        Ci.County_Court_Name__c = 'test';
        Ci.Assigned_Attorney__c	= 'test';
        Ci.Opposing_Counsel__c = 'test';
        Ci.Suit_Balance__c = 100;
        Ci.Court_Costs__c = 00;
        Ci.Counterclaim__c = 'Yes';
        
        
        insert Ci;
        
    }
}