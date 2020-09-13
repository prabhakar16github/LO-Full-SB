@isTest
private class PAM_SendFRBNotificationBatchTest {

    static testMethod void PAM_SendFRBNotificationBatchTest() {
        Account a1 = new Account();
        a1.Name = 'TestAcc';
        a1.Firm_ID__c = 'Test';
        a1.FRB_Firm_Check__c = True;
        a1.Number_of_Exception__c = 1;
        a1.Number_of_exceptions_under_4_6_bucket__c = 3;
        a1.Number_of_exceptions_under_7_10_bucket__c = 5;
        a1.Number_of_exceptions_under_11_19_bucket__c = 10;
        insert a1;
        
        Contact c = new Contact(AccountId = a1.id,LastName = 'abc',FirstName='aa',Contact_Type_SME__c = 'FRB',Inactive_Contact__c = False,Email='Test@tset.com');
        insert c;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CC - User Access' limit 1];
        User u2 = new User(Alias = 'newUser1', Username='test1@gmail.com.full',CommunityNickname='ann',Email='newuser@testorg.com',TimeZoneSidKey = 'Asia/Kuala_Lumpur',
        EmailEncodingKey='UTF-8', LastName='Testing',ContactId=c.id, LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id);

        List<Process_Adherence_Monitoring__c> pamList = new List<Process_Adherence_Monitoring__c>();
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = a1.id,Exception_Date__c=system.today().addDays(-2)));
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = a1.id,Exception_Date__c=system.today().addDays(-5)));
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = a1.id,Exception_Date__c=system.today().addDays(-8)));
        pamList.add(new Process_Adherence_Monitoring__c(Organization_Name__c = a1.id,Exception_Date__c=system.today().addDays(-13),C1_TOTAL_BAL_THRESHOLD__c=true,
                                                        C2_RCVRABLE_COST_COST_SPENT__c=true,C3_ATTY_OTHER_FEES_CNTRCT_AMT__c=true,
                                                        C4_ATTY_FEES_STAT_AMT__c=true,C5_INTEREST_RATE__c=true,C6_INTEREST_THRESHOLD__c=true,
                                                        C7_CALCULATED_BALANCE_FIRM_BAL__c=true,C7A_PRIN_AMT_PLACED_PRIN__c=true,
                                                        C7B_REC30_PMTS_ADJS_REC42_PMTS_ADJS__c=true,C7C_REC30_RCVR_COST_REC42_RCVR_COST__c=true,
                                                        C7D_CURRENT_BALANCE_0__c=true));
        insert pamList;

        Database.executeBatch(new PAM_SendFRBNotificationBatch(),1);
        
    }
}