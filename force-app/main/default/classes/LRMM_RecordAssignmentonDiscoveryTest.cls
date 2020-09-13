@isTest
private class LRMM_RecordAssignmentonDiscoveryTest {

    static testMethod void LRMM_RecordAssignmentonDiscoveryTest() {
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
        
        Discovery__c counter = new Discovery__c();
        counter.DY_Organization_Name__c = acc.id;
        counter.DY_Request_For_Admissions__c = false;
        counter.DY_Request_For_Production__c = true;
        counter.DY_Interrogatories__c = false;
        counter.DY_Pro_Se__c  = true;
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
        
        Discovery__c counter = new Discovery__c();
        counter.DY_Organization_Name__c = acc.id;
        counter.DY_Request_For_Admissions__c = false;
        counter.DY_Request_For_Production__c = true;
        counter.DY_Interrogatories__c = false;
        counter.DY_State_Filed__c = Sp.id;
         counter.DY_Pro_Se__c = true;
        insert counter;     
        
    }
}