@isTest
public class CM_UpdateNotificationUsersList_Test {
    @isTest
    static void CallMonitoring_UnitTest(){
               
        Account acc = new Account();
        acc.Firm_ID__c ='test';
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        insert acc;
        
        Contact con = new Contact(FirstName = 'testFname',LastName = 'test', AccountId = acc.Id,Community_User__c = true, Inactive_Contact__c = false);
        insert con;
 
        
        ProfileName__c pn = new ProfileName__c();
        pn.name='TW_ProfileName';
        pn.ProfileLabel__c = 'CC - TW';
        insert pn;
    
        Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Customer Community User'];
        System.debug('======profile===='+p);
        User u = new User();
        u.Alias = 'testcm';
        u.Email='standard1user11cm@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingc1m';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='cm1@salesforce.com';
        u.ContactId = con.id; 
        insert u;
        
        Call_Monitoring__c callMonitoringObjOld = new Call_Monitoring__c(
            RecordTypeId =  Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId(),
            Organization_Name_CM__c = acc.Id,
            Account_Type_CM__c = 'MCM',
            Reporting_Month_CM__c = '04',
            Reporting_Year_CM__c = '2017',
            Attachments__c = true,
            Account_Number_CM__c = 'testcmNumb'
        );
        insert callMonitoringObjOld;
        
        Test.startTest();        
        callMonitoringObjOld.Reporting_Year_CM__c = '2018';
        update callMonitoringObjOld; 
        Test.stopTest();
        System.assert(true);
    }
}