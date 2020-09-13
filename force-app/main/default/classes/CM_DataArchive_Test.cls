/***********************************************************************************
* Class Name  : CM_DataArchive_Test
* Description : Test class for CM_DataArchiveScheduler, CM_DataArchiveBatch
* Created By  : Shivangi Srivastava
* Created Date: 16-Apr-2020
* *******************************************************************************/

@isTest
public class CM_DataArchive_Test {
    @isTest static void CM_UnitTest(){
        Account accPortal = new Account();
        accPortal.Name = 'test';
        insert accPortal;
        
        Contact conP = new Contact();
        conP.AccountId = accPortal.Id;
        conP.LastName = 'testCon';
        insert conP;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CC - User Access']; 
        User u = new User(Alias = 'standt', Email='abcsqwert@xyz.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='abcsqwert@qwert.com',contactId = conP.Id);
        
        System.runAs(u) {
            Date lastmonth = System.today().addMonths(-7);
            
            Call_Monitoring__c cm = new Call_Monitoring__c();
            cm.RecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId();
            cm.Organization_Name_CM__c = accPortal.Id;
            //cm.Reporting_Month_CM__c = '07';
            //cm.Reporting_Year_CM__c = '2019';
            cm.LastModifiedDate = lastmonth;
            cm.CreatedDate = lastmonth;
            insert cm;
            
            
            
            Attachment att = new Attachment();
            att.ParentId = cm.Id;
            att.LastModifiedDate = lastmonth;
            att.Name = 'Attachment QA';
            att.body = Blob.valueOf('Test Body');
            att.CreatedDate = lastmonth;
            //att.CreatedById = '0054P0000092LtUQAU';
            insert att;
            
            
            
            
            Test.startTest();
            CM_DataArchiveScheduler sch = new CM_DataArchiveScheduler();
            sch.execute(NULL);
            Test.stopTest();
        }
        
    }
}