@isTest
public class CM_PreventDuplicateRecordsTest {
	@isTest
    static void test1(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Call_Monitoring__c cm = new Call_Monitoring__c();
        cm.RecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId();
        cm.Organization_Name_CM__c = acc.Id;
        cm.Reporting_Month_CM__c = '07';
        cm.Reporting_Year_CM__c = '2019';
        insert cm;
        
        Call_Monitoring__c cm2 = new Call_Monitoring__c();
        cm2.RecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Log').getRecordTypeId();
        cm2.Organization_Name_CM__c = acc.Id;
        cm2.Reporting_Month_CM__c = '07';
        cm2.Reporting_Year_CM__c = '2019';
        try{
            insert cm2;
        }catch(Exception e){}
        
    }
}