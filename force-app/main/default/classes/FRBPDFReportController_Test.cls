@isTest
public class FRBPDFReportController_Test{

    public static testMethod void unitTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        Id rtLeadID =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Operations - PAM').getRecordTypeId();
        
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
        acc.Number_of_Exception__c = 1;
        acc.Number_of_exceptions_under_4_6_bucket__c = 3;
        acc.Number_of_exceptions_under_7_10_bucket__c = 5;
        acc.Number_of_exceptions_under_11_19_bucket__c = 10;
        insert acc;   
        
        List<Process_Adherence_Monitoring__c> pamList = new List<Process_Adherence_Monitoring__c>();
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-2),Account_Standing__c='0-3 Days (Green - New Exception)'));
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-5),Account_Standing__c='4-6 Days (Yellow - Outside Correction Timeframe)'));
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-8),Account_Standing__c='7-10 Days (Orange - Approaching Critical Timeframe)'));
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-13),C1_TOTAL_BAL_THRESHOLD__c=true,
                                                        C2_RCVRABLE_COST_COST_SPENT__c=true,C3_ATTY_OTHER_FEES_CNTRCT_AMT__c=true,
                                                        C4_ATTY_FEES_STAT_AMT__c=true,C5_INTEREST_RATE__c=true,C6_INTEREST_THRESHOLD__c=true,
                                                        C7_CALCULATED_BALANCE_FIRM_BAL__c=true,C7A_PRIN_AMT_PLACED_PRIN__c=true,
                                                        C7B_REC30_PMTS_ADJS_REC42_PMTS_ADJS__c=true,C7C_REC30_RCVR_COST_REC42_RCVR_COST__c=true,
                                                        C7D_CURRENT_BALANCE_0__c=true,Account_Standing__c='11-19 Days (Red - Immediate Correction Required)'));
        insert pamList;
        
        apexpages.currentpage().getparameters().put('id',acc.id);
        apexpages.currentpage().getparameters().put('name','Test Account');
        FRBPDFReportController FRBReportObj = new FRBPDFReportController();
    }
}