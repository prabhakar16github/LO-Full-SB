@isTest
private class PAM_SendCCMNotificationBatchTest {

    static testMethod void PAM_SendCCMNotificationBatchTest() {
        Account a1 = new Account();
        a1.Name = 'TestAcc';
        a1.Firm_ID__c = 'Test';
        a1.FRB_Firm_Check__c = True;
        a1.CCM_Exceptions_0_30__c = 5;
        a1.CCM_Exceptions_31_60__c = 10;
        a1.CCM_Exceptions_61__c = 15;
        insert a1;
        
        Contact c = new Contact(AccountId = a1.id,LastName = 'abc',FirstName='aa',Contact_Type_SME__c = 'FRB',Inactive_Contact__c = False,Email='test@test.com');
        insert c;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CC - User Access' limit 1];
        User u2 = new User(Alias = 'newUser1', Username='test1@gmail.com.full',CommunityNickname='ann',Email='newuser@testorg.com',TimeZoneSidKey = 'Asia/Kuala_Lumpur',
        EmailEncodingKey='UTF-8', LastName='Testing',ContactId=c.id, LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id);

        List<Process_Adherence_Monitoring__c> pamList = new List<Process_Adherence_Monitoring__c>();
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = a1.id,Exception_Date__c=system.today().addDays(-2)));
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = a1.id,Exception_Date__c=system.today().addDays(-31)));
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = a1.id,Exception_Date__c=system.today().addDays(-60)));
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = a1.id,Exception_Date__c=system.today().addDays(-65)));
        insert pamList;

        Database.executeBatch(new PAM_SendCCMNotificationBatch(),1);
        
    }
}