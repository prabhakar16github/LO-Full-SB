@isTest
public class FRB_BatchToUpdateCloseStatus_Test{
    
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
        insert acc;   
        
        Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c();
        pamObj = new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Account_Number__c='121211',
                                                        RecordTypeId=Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO FRB').getRecordTypeId(),
                                                        C1_Resolution_Date__c=null,C1_TOTAL_BAL_THRESHOLD__c=true,
                                                        C2_Resolution_Date__c=null,C2_RCVRABLE_COST_COST_SPENT__c=true,
                                                        C3_Resolution_Date__c=null,C3_ATTY_OTHER_FEES_CNTRCT_AMT__c=true,
                                                        C4_Resolution_Date__c=null,C4_ATTY_FEES_STAT_AMT__c=true,
                                                        C5_Resolution_Date__c=null,C5_INTEREST_RATE__c=true,
                                                        C6_Resolution_Date__c=null,C6_INTEREST_THRESHOLD__c=true,
                                                        C7_Resolution_Date__c=null,C7_CALCULATED_BALANCE_FIRM_BAL__c=true,
                                                        C7A_Resolution_Date__c=null,C7A_PRIN_AMT_PLACED_PRIN__c=true,
                                                        C7B_Resolution_Date__c=null,C7B_REC30_PMTS_ADJS_REC42_PMTS_ADJS__c=true,
                                                        C7C_Resolution_Date__c=null,C7C_REC30_RCVR_COST_REC42_RCVR_COST__c=true,
                                                        C7D_Resolution_Date__c=null,C7D_CURRENT_BALANCE_0__c=true);
        insert pamObj;
        
        Database.executeBatch(new FRB_BatchToUpdateCloseStatus(),1);
    }
}