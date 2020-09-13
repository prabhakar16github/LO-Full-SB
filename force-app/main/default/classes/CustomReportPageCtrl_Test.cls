@isTest
public class CustomReportPageCtrl_Test {
    public static testMethod void TestCase(){
        
        Id recTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute').getRecordTypeId();
        Process_Adherence_Monitoring__c pam = new Process_Adherence_Monitoring__c();
        pam.SCMD_Reporting_Period__c = '2020-02';
        pam.Status__c='Account Numbers Added';
        pam.Account_Type__c='ACF';
        pam.RecordTypeId = recTypeId;
        insert pam;
        SCM_Account_Numbers__c acc = new SCM_Account_Numbers__c();
        acc.Answer_Filed_Account_s__c ='11';
        acc.Process_Adherence_Monitoring_Record__c = pam.Id;
        insert acc;
        
        CustomReportPageCtrl ctrl = new CustomReportPageCtrl();
    }
     public static testMethod void TestCase1(){
        
        Id recTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute').getRecordTypeId();
        Process_Adherence_Monitoring__c pam = new Process_Adherence_Monitoring__c();
        pam.SCMD_Reporting_Period__c = '2020-02';
        pam.Status__c='Account Numbers Added';
        pam.Account_Type__c='Legacy';
        pam.RecordTypeId = recTypeId;
        insert pam;
        SCM_Account_Numbers__c acc = new SCM_Account_Numbers__c();
        acc.Answer_Filed_Account_s__c ='11';
        acc.Process_Adherence_Monitoring_Record__c = pam.Id;
        insert acc;
        
        CustomReportPageCtrl ctrl = new CustomReportPageCtrl();
         ctrl.pamSelected='Legacy';
         ctrl.getRecords();
         for(CustomReportPageCtrl.WrapperClass wc : ctrl.wrapperClassList){
             wc.isSelected = true;
         }
         ctrl.updateStatus();
    }
}