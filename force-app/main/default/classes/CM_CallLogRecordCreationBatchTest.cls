@isTest
private class CM_CallLogRecordCreationBatchTest{

    static testMethod void testCase(){
         account acc = new account(name='test');
         acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('In Network').getRecordTypeId();
         acc.Firm_Status_IN__c = 'Active';
         acc.VO_Tier__c = '1';
         insert acc;
         
         contact con = new contact();
         con.lastName = 'test';
         con.Community_User__c = true;
         con.accountid = acc.id;
         con.email ='avaneesh.singh@mcmcg.com';
         insert con;
         
         Profile p = [SELECT Id FROM Profile WHERE Name='CC - User Access']; 
         User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com', contactid=con.id);
         insert u;
         
         CM_CallLogRecordCreationBatch  cl = new CM_CallLogRecordCreationBatch ();
         Database.executeBatch(cl);
    }
    
    static testMethod void testCase1(){
            test.startTest();
            CM_CallLogRecordCreationBatchSchedule cl = new CM_CallLogRecordCreationBatchSchedule();
            String sch = '20 30 8 10 2 ?';
            String jobID = system.schedule('test job', sch, cl);
            test.stopTest();
    }

}