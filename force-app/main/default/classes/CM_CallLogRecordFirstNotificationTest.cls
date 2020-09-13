@isTest
public class CM_CallLogRecordFirstNotificationTest{
        
        @testSetup static void setup(){
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
            
            Call_Monitoring__c cm = new Call_Monitoring__c();
            cm.RecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Log').getRecordTypeId();
            cm.Organization_Name_CM__c = acc.id;
            cm.Account_Type_CM__c = 'MCM';
            cm.Reporting_Month_CM__c = String.valueOf(date.today().month()); // current month in number
            cm.Reporting_Year_CM__c = String.valueOf(date.today().year()); // current year in number
            
            cm.ownerid = u.id; 
            insert cm;
        }
        
        
        static testMethod void testCase(){
            CM_CallLogRecordFirstNotificationBatch  cml2 = new CM_CallLogRecordFirstNotificationBatch (3);
            Database.executeBatch(cml2);
            
         }
         
         static testMethod void testCase1(){
            CM_CallLogRecordFirstNotificationBatch  cml1 = new CM_CallLogRecordFirstNotificationBatch (2);
            Database.executeBatch(cml1);
         }
         
         static testMethod void testCase2(){
            CM_CallLogRecordFirstNotificationBatch  cml = new CM_CallLogRecordFirstNotificationBatch (1);
            Database.executeBatch(cml);
         }
         
         static testMethod void testCase3(){
            test.startTest();
            CM_CallLogRecordFirstNotifScheduled  cl = new CM_CallLogRecordFirstNotifScheduled (1);
            String sch = '20 30 8 10 2 ?';
            String jobID = system.schedule('test job', sch, cl);
            test.stopTest();
         }
         
 }