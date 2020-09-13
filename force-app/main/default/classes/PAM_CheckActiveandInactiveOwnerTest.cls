@istest
public with sharing class PAM_CheckActiveandInactiveOwnerTest{
    static testmethod void PAM_CheckActiveandInactiveOwnerTest() {
        Test.startTest();
        //Process_Adherence_Monitoring__c pam = new Process_Adherence_Monitoring__c();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CC - User Access'];
        
        Id rtLeadID =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Operations - PAM').getRecordTypeId();
        
        Account acc = new Account();
        acc.Firm_ID__c ='test';
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        //acc.Paralegal__c = u.id;
        //acc.MCM_Attorney__c = u.id;
        insert acc;  
        
        Contact con = new Contact(LastName ='testCon',AccountId = acc.Id,Contact_Type_SME__c='Process Adherence Monitoring (PAM)');
        insert con;
        
        User u = new User();
        u.Alias = 'ssa';
        u.Email='standarduser11sak@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingsak';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='sak1@salesforce.com';
        u.ContactId = con.id;
        insert u; 
        
        List<Process_Adherence_Monitoring__c> pamList = new List<Process_Adherence_Monitoring__c>();
        pamList.add(new Process_Adherence_Monitoring__c(OwnerId=u.id,Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-2)));
        pamList.add(new Process_Adherence_Monitoring__c(OwnerId=u.id,Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-5)));
        pamList.add(new Process_Adherence_Monitoring__c(OwnerId=u.id,Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-8)));
        pamList.add(new Process_Adherence_Monitoring__c(OwnerId=u.id,Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-13)));
        insert pamList;
        
        Datetime dt = Datetime.now().addMinutes(1);
        PAM_CheckActiveandInactiveOwner sche = new PAM_CheckActiveandInactiveOwner();
        String sch = '0 0 23 * * ?';
        String jobId = System.schedule('Sample_Heading',sch,sche);   
        Test.stopTest();
    }
}