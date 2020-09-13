@isTest
public class CallMonitoringTrigger_Test {
    
     @TestSetup
    static void testsetup() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'test';
        con.AccountId = acc.Id;
        con.Community_User__c = true;
        insert con;
        
       Trigger_Setting__c ts = new Trigger_Setting__c();
        ts.Name = 'CallMonitoringTrigger';
        ts.Active__c = true;
        insert ts;
    }
    
    @isTest
    static void test1(){
        Account acc = [SELECT Id,Name FROM Account LIMIT 1];
        
        Contact con = [SELECT Id,LastName FROM Contact LIMIT 1];
        
        Profile prof = [select id from profile where name = 'CC - User Access'];
        
        User uu=new User(firstname = 'TEST', 
                         lastName = 'test', 
                         email = 'test@ac.com', 
                         Username = 'zxcvbasdf123@acc.com', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'test', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = prof.Id,
                        ContactId = con.Id); 
        
        System.runAs(uu){
            List<Trigger_Setting__c> tsList = [SELECT Name,Active__c FROM Trigger_Setting__c];
            
            
            Call_Monitoring__c cm = new Call_Monitoring__c();
            cm.RecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId();
            cm.Organization_Name_CM__c = acc.Id;
            cm.Reporting_Month_CM__c = '07';
            cm.Reporting_Year_CM__c = '2019';
            insert cm;
            
            Call_Monitoring__c cm2 = new Call_Monitoring__c();
            cm2.RecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId();
            cm2.Organization_Name_CM__c = acc.Id;
            cm2.Reporting_Month_CM__c = '07';
            cm2.Reporting_Year_CM__c = '2019';
            try{
                insert cm2;
            }catch(Exception e){}
            
            Call_Monitoring__c cm3 = new Call_Monitoring__c();
            cm3.RecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Materials').getRecordTypeId();
            cm3.Organization_Name_CM__c = acc.Id;
            cm3.Date_of_Call__c = System.today();
            cm3.Reporting_Year_CM__c = '2019';
            insert cm3;
        }
        
        
    }
    
}