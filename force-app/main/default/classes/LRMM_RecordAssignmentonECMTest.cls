@isTest
private class LRMM_RecordAssignmentonECMTest{

    static testMethod void LRMM_RecordAssignmentonECMTest () {
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
        
        Escalated_Contested_Matters__c counter = new Escalated_Contested_Matters__c();
        counter.ECM_Organization_Name__c = acc.id;
        counter.ECM_Opposing_Counsel__c = '23523';
        counter.ECM_Opposing_Counsel_Comments__c = 'test';
        counter.ECM_Opposing_Counsel_Email__c = 'test@gmail.com';
        counter.ECM_Opposing_Counsel_Firm_Name__c = 'test';
        counter.ECM_Opposing_counsel_Phone__c = '12412';
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
        
        Escalated_Contested_Matters__c counter = new Escalated_Contested_Matters__c();
        counter.ECM_Organization_Name__c = acc.id;
        counter.ECM_State_Filed__c = Sp.id;
        counter.ECM_Opposing_Counsel__c = '23523';
        counter.ECM_Opposing_Counsel_Comments__c = 'test';
        counter.ECM_Opposing_Counsel_Email__c = 'test@gmail.com';
        counter.ECM_Opposing_Counsel_Firm_Name__c = 'test';
        counter.ECM_Opposing_counsel_Phone__c = '12412';
        insert counter;  
    }
    
    public static String createData(){
        Account accObj = new Account();
        accObj.Firm_ID__c ='test';
        accObj.Name = 'CA137';
        accObj.Phone = '98828383';
        accObj.Physical_Street__c= 'test';
        accObj.Physical_City__c = 'city';
        accObj.Physical_Postal_Code__c = '11111';
        accObj.Physical_Country__c = 'test country';
        accObj.Physical_State_Province__c = 'Province';
        accObj.Paralegal__c = UserInfo.getUserId();
        accObj.MCM_Attorney__c = UserInfo.getUserId();
        insert accObj;
        
        Consumer_Account_Details__c cadObj = new Consumer_Account_Details__c();
        cadObj.Organization_name__c = accObj.id;
        cadObj.Account_Number__c = '111';
        cadObj.OwnerId =  UserInfo.getUserId();
        cadObj.Original_Creditor__c = 'test';
        cadObj.CAD_Credit_Card__c  = true;
        insert cadObj;
        
        return cadObj.id;
    }
    
    public static testMethod void testAppeal(){
        Consumer_Account_Details__c cadObj = [SELECT Organization_name__c FROM Consumer_Account_Details__c WHERE id =: createData()];
        
        Escalated_Contested_Matters__c ecmObj = new Escalated_Contested_Matters__c();
        ecmObj.ECM_Organization_Name__c = cadObj.Organization_name__c;
        ecmObj.ECM_Consumer_Account_Detail_Name__c = cadObj.id;
        ecmObj.ECM_Matter_Name__c = 'test';
        ecmObj.ECM_Court_File__c = 'test';
        ecmObj.ECM_County_Court_Name__c = 'test';
        ecmObj.ECM_Account_Number__c = '111';
        ecmObj.ECM_Judge_Name__c = 'test';
        ecmObj.ECM_Prior_Experience_with_Judge__c = 'Yes';
        ecmObj.ECM_IfPriorExperiencewith_Judge_Comments__c = 'test';
        ecmObj.ECM_Assigned_Attorney__c= 'test';
        ecmObj.ECM_Assigned_Attorney_Cell_Phone__c = '12412';
        ecmObj.ECM_Assigned_Attorney_Direct_Line__c = '2424';
        ecmObj.ECM_Assigned_Attorney_Email__c = 'test@gmail.com';
        ecmObj.ECM_Opposing_Counsel__c = '23523';
        ecmObj.ECM_Opposing_Counsel_Comments__c = 'test';
        ecmObj.ECM_Opposing_Counsel_Email__c = 'test@gmail.com';
        ecmObj.ECM_Opposing_Counsel_Firm_Name__c = 'test';
        ecmObj.ECM_Opposing_counsel_Phone__c = '12412';
        ecmObj.ECM_Status__c = 'Pending Resolution';
        insert ecmObj;
        
        ecmObj = [SELECT ECM_Resolution_Amount__c, ECM_Resolution_Date__c, ECM_Resolution_Notes__c, ECM_Resolution_Payment_To__c, 
                        ECM_Resolution_Type__c, ECM_Status__c FROM Escalated_Contested_Matters__c WHERE id =: ecmObj.id];
        //ecmObj.ECM_Resolution_Amount__c = 121;
        ecmObj.ECM_Resolution_Date__c = system.today();
        ecmObj.ECM_Resolution_Notes__c = 'Test';
        ecmObj.ECM_Resolution_Payment_To__c = 'ACF';
        ecmObj.ECM_Resolution_Type__c = 'Arbitration';
        ecmObj.ECM_Status__c = 'Pending Resolution';
        update ecmObj;
        
        ecmObj = [SELECT ECM_Resolution_Amount__c, ECM_Resolution_Date__c, ECM_Resolution_Notes__c, ECM_Resolution_Payment_To__c, 
                        ECM_Resolution_Type__c, ECM_Status__c FROM Escalated_Contested_Matters__c WHERE id =: ecmObj.id];
        ecmObj.ECM_Resolution_Amount__c = null;
        ecmObj.ECM_Resolution_Date__c = null;
        ecmObj.ECM_Resolution_Notes__c = null;
        ecmObj.ECM_Resolution_Payment_To__c = null;
        ecmObj.ECM_Resolution_Type__c = null;
        ecmObj.ECM_Status__c = 'Pending Resolution';
        ecmObj.ECM_Attorney_Approval_Needed__c = true;
        update ecmObj;
    }
}