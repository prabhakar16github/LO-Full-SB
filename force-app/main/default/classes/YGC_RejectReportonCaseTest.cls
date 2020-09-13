@isTest
private class YGC_RejectReportonCaseTest {



    
    static testMethod void myUnitTest() {

        
    	Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Case.getRecordTypeInfosByName();
        Id rtLeadID =  rtMap.get('Operations - YGC Reject Report').getRecordTypeId();
    
        Account acc = new Account();
        acc.Name = 'test';
        acc.Phone = '285235';
        acc.Physical_Street__c = 'test';
        acc.Physical_Postal_Code__c = 'test';
        acc.Physical_City__c = 'test';
        acc.Physical_Country__c = 'India';
        
        insert acc;
        
        Contact c = new Contact();
        
        c.FirstName = 'Test';
        c.LastName = 'Test1';
        c.AccountId = acc.id;
        c.Inactive_Contact__c = False;
        c.Contact_Type_SME__c = 'YGC Reject Report';
        
        insert c;
        
        Case cas = new Case();
        
        cas.RecordTypeid = rtLeadID;
        cas.Status = 'New';
        cas.Origin = 'Internal';
        cas.Reason = 'YGC Reject Report';
        
        insert cas;
        Profile p = [SELECT Id FROM Profile WHERE Name='CC - User Access' limit 1];
        User u2 = new User(Alias = 'newUser1', Username='test1@gmail.com.full',CommunityNickname='ann',Email='test@gmail.com',TimeZoneSidKey = 'Asia/Kuala_Lumpur',
        EmailEncodingKey='UTF-8', LastName='Testing',ContactId=c.id, LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id);
        
        Messaging.Singleemailmessage testEmail;
        List<Messaging.Sendemailresult> testEmailResults;
    }
}