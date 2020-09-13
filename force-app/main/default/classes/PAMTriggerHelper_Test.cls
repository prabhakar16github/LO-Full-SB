@isTest
public class PAMTriggerHelper_Test{
    
    @testSetup
    static void testSetupMethod(){
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
        
        DM_API_Credentials__c cred = new DM_API_Credentials__c();
        cred.Name = 'API 2';
        cred.Endpoint_URL__c = 'www.google.com';
        cred.API_Key__c = '1234avcd';
        cred.correlation_id__c = 'test';
        cred.Key_Secret__c = '32323adad';
        cred.mcm_appid__c = 'test';
        cred.mcm_userid__c = 'salesforce';
        insert cred;
    }
    public static testMethod void unitTest(){
        Account acc = [SELECT Firm_ID__c,Name,Phone,Physical_Street__c,Physical_City__c,Physical_Postal_Code__c,Physical_Country__c,
                      Physical_State_Province__c,Paralegal__c,MCM_Attorney__c
                      FROM Account][0];
        
        
        DM_API_Credentials__c cred = [SELECT Id,Name,Endpoint_URL__c,API_Key__c,correlation_id__c,Key_Secret__c,mcm_appid__c,mcm_userid__c
                                     FROM DM_API_Credentials__c][0];
        
        
        Id IRRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR').getRecordTypeId();
        Id PSNMRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordtypeInfosByName().get('LO PSNM').getRecordTypeId();
        Id pnaRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO PNA').getRecordTypeId();
        Id DM_PSNM_RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordtypeInfosByName().get('DM PSNM').getRecordTypeId();
        
        
        List<Process_Adherence_Monitoring__c> pamList = new List<Process_Adherence_Monitoring__c>();
        pamList.add(new Process_Adherence_Monitoring__c(recordTypeId = pnaRecordTypeId,Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-2)));
        pamList.add(new Process_Adherence_Monitoring__c(recordTypeId = PSNMRecordTypeId,Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-5)));
        pamList.add(new Process_Adherence_Monitoring__c(recordTypeId = IRRecordTypeId,Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-8)));
        //pamList.add(new Process_Adherence_Monitoring__c(recordTypeId = RSNMRecordTypeId,Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-8)));
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-13),C1_TOTAL_BAL_THRESHOLD__c=true,
                                                        C2_RCVRABLE_COST_COST_SPENT__c=true,C3_ATTY_OTHER_FEES_CNTRCT_AMT__c=true,
                                                        C4_ATTY_FEES_STAT_AMT__c=true,C5_INTEREST_RATE__c=true,C6_INTEREST_THRESHOLD__c=true,
                                                        C7_CALCULATED_BALANCE_FIRM_BAL__c=true,C7A_PRIN_AMT_PLACED_PRIN__c=true,
                                                        C7B_REC30_PMTS_ADJS_REC42_PMTS_ADJS__c=true,C7C_REC30_RCVR_COST_REC42_RCVR_COST__c=true,
                                                        C7D_CURRENT_BALANCE_0__c=true));
        pamList.add(new Process_Adherence_Monitoring__c(recordTypeId = DM_PSNM_RecordTypeId,Organization_Name__c = acc.id,Status__c = 'New',PSNM_Flag__c = 'No',Account_Number__c = '4343434343'));
        insert pamList;
        
        for(Process_Adherence_Monitoring__c pamObj : pamList){
            if(pamObj.RecordTypeId != DM_PSNM_RecordTypeId && pamObj.RecordTypeId != DM_PSNM_RecordTypeId){
                pamObj.C1_TOTAL_BAL_THRESHOLD__c=false;
                pamObj.C2_RCVRABLE_COST_COST_SPENT__c=false;
                pamObj.C3_ATTY_OTHER_FEES_CNTRCT_AMT__c=false;
                pamObj.C4_ATTY_FEES_STAT_AMT__c=false;
                pamObj.C5_INTEREST_RATE__c=false;
                pamObj.C6_INTEREST_THRESHOLD__c=false;
                pamObj.C7_CALCULATED_BALANCE_FIRM_BAL__c=false;
                pamObj.C7A_PRIN_AMT_PLACED_PRIN__c=false;
                pamObj.C7B_REC30_PMTS_ADJS_REC42_PMTS_ADJS__c=false;
                pamObj.C7C_REC30_RCVR_COST_REC42_RCVR_COST__c=false;
                pamObj.C7D_CURRENT_BALANCE_0__c=false;
            }else{
                pamObj.Status__c = 'Closed';
                pamObj.SOL_Observation_Description__c = 'Alternative Logic';
                pamObj.Change_PSNM_Flag_to_yes__c = true;
                
            }
        }
        update pamList;
    }
    
    @isTest
    static void testRunForDM(){
        Account acc = [SELECT Firm_ID__c,Name,Phone,Physical_Street__c,Physical_City__c,Physical_Postal_Code__c,Physical_Country__c,
                      Physical_State_Province__c,Paralegal__c,MCM_Attorney__c
                      FROM Account][0];
        
        Id DM_RSNM_RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordtypeInfosByName().get('DM RSNM').getRecordTypeId();
        
        List<Process_Adherence_Monitoring__c> pamList = new List<Process_Adherence_Monitoring__c>{new Process_Adherence_Monitoring__c(
            recordTypeId = DM_RSNM_RecordTypeId,
            Organization_Name__c = acc.id,
            Status__c = 'New',
            RSNM_Flag__c = 'No',
            Account_Number__c = '4343434354'
        )};
            
            insert pamList;
        
        for(Process_Adherence_Monitoring__c pamObj : pamList){
            pamObj.Status__c = 'Closed';
            pamObj.SOL_Observation_Description__c = 'Alternative Logic';
            pamObj.Change_RSNM_Flag_to_yes__c = true;
        }
        
        update pamList;
    }
    
    @isTest
    static void testRunForDM2(){
        Account acc = [SELECT Firm_ID__c,Name,Phone,Physical_Street__c,Physical_City__c,Physical_Postal_Code__c,Physical_Country__c,
                      Physical_State_Province__c,Paralegal__c,MCM_Attorney__c
                      FROM Account][0];
        
        Id DM_RSNM_RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordtypeInfosByName().get('DM RSNM').getRecordTypeId();
        
        List<Process_Adherence_Monitoring__c> pamList = new List<Process_Adherence_Monitoring__c>{new Process_Adherence_Monitoring__c(
            recordTypeId = DM_RSNM_RecordTypeId,
            Organization_Name__c = acc.id,
            Status__c = 'New',
            RSNM_Flag__c = 'No',
            Account_Number__c = '4343434354'
        )};
            
            insert pamList;
        
        for(Process_Adherence_Monitoring__c pamObj : pamList){
            pamObj.Change_RSNM_Flag_to_yes__c = true;
        }
        
        update pamList;
    }
}