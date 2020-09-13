@isTest
private class LC_RollupFirmScorecardCountonOrgTest {

    static testMethod void LC_RollupFirmScorecardCountonOrgTest() {
        
        Account acc = new Account();
        
        acc.Firm_ID__c = 'test';
        acc.Name = 'Test1';
        acc.Phone = '34354345';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        
        insert acc;
        
        Firm_Scorecard__c fms = new Firm_Scorecard__c();
        
        fms.Name = 'test';
        fms.Organization_Name__c = acc.id;
        
        insert fms;
        
        acc.Firm_ID__c = 'test';
        acc.Name = 'Test1';
        acc.Phone = '34354345';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        acc.Firm_Scorecard_Count__c = 1;
        
        update acc;
        delete fms;
        
        acc.Firm_ID__c = 'test';
        acc.Name = 'Test1';
        acc.Phone = '34354345';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        acc.Firm_Scorecard_Count__c = 0;
        
        
    }
}