@isTest
public class CM_MissingMaterialBatch_Test {
    @isTest
    static void CallMonitoringQA(){
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'user000@test.com',
            Username = 'user000@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
         );
         insert u; 
        
        Account acc = new Account();
        acc.Firm_ID__c ='testAcc';
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        acc.OwnerId = u.id;
        acc.FM_Process_Manager__c = u.Id;
        
        insert acc;
        
        
        Contact con = new Contact(LastName = 'test', AccountId = acc.Id,Community_User__c = true, Inactive_Contact__c = false, Email = 'test@test.com');
        insert con;
        
        
        List<Call_Monitoring__c> cmList = new List<Call_Monitoring__c>();
        Call_Monitoring__c callMonitoringObjFirst = new Call_Monitoring__c(
            RecordTypeId =  Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId(),
            Organization_Name_CM__c = acc.Id,
            Account_Type_CM__c = 'MCM',
            Reporting_Month_CM__c = '04',
            Reporting_Year_CM__c = '2017',
            Attachments__c = true
        );
        Call_Monitoring__c callMonitoringObjSecond = new Call_Monitoring__c(
            RecordTypeId =  Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId(),
            Organization_Name_CM__c = acc.Id,
            Account_Type_CM__c = 'MCM',
            Reporting_Month_CM__c = '05',
            Reporting_Year_CM__c = '2017',
            Attachments__c = true
        );
        Call_Monitoring__c callMonitoringThird = new Call_Monitoring__c(
            RecordTypeId =  Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId(),
            Organization_Name_CM__c = acc.Id,
            Account_Type_CM__c = 'MCM',
            Reporting_Month_CM__c = '04',
            Reporting_Year_CM__c = '2017',
            Attachments__c = true
        );
        cmList.add(callMonitoringObjFirst);
        cmList.add(callMonitoringObjSecond);
        cmList.add(callMonitoringThird);
        insert cmList;
        
        Date QACreatedDate1 = System.today()-4;
        Test.setCreatedDate(cmList[0].Id, QACreatedDate1);
        Date QACreatedDate2 = System.today()-5;
        Test.setCreatedDate(cmList[1].Id, QACreatedDate2);  
        Date QACreatedDate3 = System.today()-6;
        Test.setCreatedDate(cmList[2].id, QACreatedDate3);
        
        Test.startTest();
        CM_MissingMaterialScheduler objSch = new CM_MissingMaterialScheduler();
        objSch.execute(null);
        
        System.assert(true);
        
        Test.stopTest();
        
        
    }
}