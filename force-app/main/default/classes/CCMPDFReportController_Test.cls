@isTest
public class CCMPDFReportController_Test{

    public static testMethod void unitTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
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
        insert u;
        
        Account acc = new Account();
        acc.Firm_ID__c ='test';
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        acc.Paralegal__c = u.id;
        acc.MCM_Attorney__c = u.id;
        acc.FRB_Firm_Check__c = True;
        acc.CCM_Exceptions_0_30__c = 5;
        acc.CCM_Exceptions_31_60__c = 10;
        acc.CCM_Exceptions_61__c = 15;
        insert acc;
        
        Id CCMJRRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO CCM - JR').getRecordTypeId();
        
        List<Process_Adherence_Monitoring__c> pamList = new List<Process_Adherence_Monitoring__c>();
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-2),
                                                            RecordTypeId=CCMJRRecordTypeId,Account_Standing__c='0-30 Days (New Exception)'));
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-30),
                                                            RecordTypeId=CCMJRRecordTypeId,Account_Standing__c='31-60 Days (Approaching Critical Timeframe)'));
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-60),
                                                            RecordTypeId=CCMJRRecordTypeId,Account_Standing__c='31-60 Days (Approaching Critical Timeframe)'));
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-65),
                                                            RecordTypeId=CCMJRRecordTypeId,Account_Standing__c='61+ Days (Immediate Correction Required)'));
        insert pamList;
        
        system.debug('List: ' + [SELECT Account_Standing__c FROM Process_Adherence_Monitoring__c WHERE id in: pamList]);
        
        apexpages.currentpage().getparameters().put('id',acc.id);
        apexpages.currentpage().getparameters().put('name','Test Account');
        CCMPDFReportController CCMReportObj = new CCMPDFReportController();
    }
}