@isTest
private class LRMM_CounterclaimTaskTriggerTest {

    static testMethod void myUnitTest() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User();
        u.Alias = 'standt12';
        u.Email='standarduser12@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testing12';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='ishan12@salesforce.com';
        
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
        
        Counterclaim__c ccObj = new Counterclaim__c();
        ccObj.CC_Organization_Name__c = acc.id;
        ccObj.CC_Opposing_Counsel__c = 'test';
        ccObj.CC_Opposing_Counsel_Comments__c = 'test';
        ccObj.CC_Opposing_Counsel_Email__c = 'email@gmail.com';
        ccObj.CC_Opposing_Counsel_Firm_Name__c = 'test';
        ccObj.CC_Opposing_counsel_Phone__c = '34634';
        insert ccObj;    
        
        ccObj = [SELECT CC_Resolution_Amount__c, CC_Resolution_Date__c, CC_Resolution_Notes__c, CC_Resolution_Payment_To__c, 
                        CC_Resolution_Type__c, CC_Counterclaim_Status__c FROM Counterclaim__c WHERE id =: ccObj.id];
        //ccObj.CC_Resolution_Amount__c = 121;
        ccObj.CC_Resolution_Date__c = system.today();
        ccObj.CC_Resolution_Notes__c = 'Test';
        ccObj.CC_Resolution_Payment_To__c = 'ACF';
        ccObj.CC_Resolution_Type__c = 'Arbitration';
        ccObj.CC_Counterclaim_Status__c = 'Pending Resolution';
        update ccObj;
        
        ccObj = [SELECT CC_Resolution_Amount__c, CC_Resolution_Date__c, CC_Resolution_Notes__c, CC_Resolution_Payment_To__c, 
                        CC_Resolution_Type__c, CC_Counterclaim_Status__c FROM Counterclaim__c WHERE id =: ccObj.id];
        ccObj.CC_Resolution_Amount__c = null;
        ccObj.CC_Resolution_Date__c = null;
        ccObj.CC_Resolution_Notes__c = null;
        ccObj.CC_Resolution_Payment_To__c = null;
        ccObj.CC_Resolution_Type__c = null;
        ccObj.CC_Counterclaim_Status__c = 'Pending Resolution';
        update ccObj;    
    }
        static testMethod void myUnitTest1() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User();
        u.Alias = 'sta';
        u.Email='standarduser123@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testing12';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='ishan123@salesforce.com';
        
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
            
        Counterclaim__c counter = new Counterclaim__c();
        counter.CC_Organization_Name__c = acc.id;
        counter.CC_State_Filed__c = Sp.id;    
        counter.CC_Opposing_Counsel__c = 'test';
        counter.CC_Opposing_Counsel_Comments__c = 'test';
        counter.CC_Opposing_Counsel_Email__c = 'email@gmail.com';
        counter.CC_Opposing_Counsel_Firm_Name__c = 'test';
        counter.CC_Opposing_counsel_Phone__c = '34634';
        insert counter;        
    }
}