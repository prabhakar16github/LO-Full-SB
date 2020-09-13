@isTest
private class LRMM_RecordAssgnmentonSettlementTest {
    
    static testMethod void LRMM_RecordAssgnmentonSettlementTest() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User();
        u.Alias = 'standt1';
        u.Email='standarduser11@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testing11';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='ishan1@salesforce.com';
        
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
        
        Contact c = new Contact();
        c.LastName = 'test';
        c.AccountId = acc.id;
        c.Phone = '981824124';
        c.Email = 'ishan@gmail.com';
        
        insert c;
        
        Settlement_Approval__c counter = new Settlement_Approval__c();
        counter.SA_Organization_Name__c= acc.id;
        counter.SA_Pro_Se__c = true;
        
        insert counter;     
        
    }
    static testMethod void LRMM_RecordAssignmentonDiscoveryTest1() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User();
        u.Alias = 'stan';
        u.Email='standarduser11@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testing11';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='ishan1@salesforce.com';
        
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
        
        Contact c = new Contact();
        c.LastName = 'test';
        c.AccountId = acc.id;
        c.Phone = '981824124';
        c.Email = 'ishan@gmail.com';
        
        insert c;
        
        State_Profile__c Sp = new State_Profile__c();
        Sp.Name = 'test';
        Sp.State_NPV_Group__c = 'High';
        Sp.SP_Paralegal__c = u.id;
        Sp.SP_MCM_Attorney__c = u.id;
        
        insert Sp;    
        
        Settlement_Approval__c counter = new Settlement_Approval__c();
        counter.SA_Organization_Name__c = acc.id;
        counter.SA_State_Filed__c   = Sp.id;
        counter.SA_Pro_Se__c = true;
        insert counter;  
        counter.SA_Attorney_Approval_Needed__c = true;
        update counter;
    }
}