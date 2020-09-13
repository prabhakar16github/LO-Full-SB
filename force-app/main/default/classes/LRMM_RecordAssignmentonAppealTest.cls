@isTest
private class LRMM_RecordAssignmentonAppealTest {

    static testMethod void LRMM_RecordAssignmentonAppealTest () {
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
        
        Appeal__c counter = new Appeal__c();
        counter.AP_Organization_Name__c = acc.id;
        counter.AP_Opposing_Counsel__c = '23523';
        counter.AP_Opposing_Counsel_Comments__c = 'test';
        counter.AP_Opposing_Counsel_Email__c = 'test@gmail.com';
        counter.AP_Opposing_Counsel_Firm_Name__c = 'test';
        counter.AP_Opposing_counsel_Phone__c = '12412';
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
        
        Appeal__c counter = new Appeal__c();
        counter.AP_Organization_Name__c = acc.id;
        counter.AP_State_Filed__c = Sp.id;
        counter.AP_Opposing_Counsel__c = '23523';
        counter.AP_Opposing_Counsel_Comments__c = 'test';
        counter.AP_Opposing_Counsel_Email__c = 'test@gmail.com';
        counter.AP_Opposing_Counsel_Firm_Name__c = 'test';
        counter.AP_Opposing_counsel_Phone__c = '12412';
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
        insert cadObj;
        
        return cadObj.id;
    }
    
    public static testMethod void testAppeal(){
        Consumer_Account_Details__c cadObj = [SELECT Organization_name__c FROM Consumer_Account_Details__c WHERE id =: createData()];
        
        Appeal__c appealObj = new Appeal__c();
        appealObj.AP_Organization_Name__c = cadObj.Organization_name__c;
        appealObj.AP_Consumer_Account_Record__c = cadObj.id;
        appealObj.AP_Matter_Name__c = 'test';
        appealObj.AP_Court_File__c = 'test';
        appealObj.AP_County_Court_Name__c = 'test';
        appealObj.AP_Account_Number__c = '111';
        appealObj.AP_Judge_Name__c = 'test';
        appealObj.AP_Prior_Experience_with_Judge__c = 'Yes';
        appealObj.AP_IfPriorExperience_with_Judge_Comments__c = 'test';
        appealObj.AP_County_Filed__c = 'test';
        appealObj.AP_Assigned_Attorney__c= 'test';
        appealObj.AP_Assigned_Attorney_Cell_Phone__c = '12412';
        appealObj.AP_Assigned_Attorney_Direct_Line__c = '2424';
        appealObj.AP_Assigned_Attorney_Email__c = 'test@gmail.com';
        appealObj.AP_Opposing_Counsel__c = '23523';
        appealObj.AP_Opposing_Counsel_Comments__c = 'test';
        appealObj.AP_Opposing_Counsel_Email__c = 'test@gmail.com';
        appealObj.AP_Opposing_Counsel_Firm_Name__c = 'test';
        appealObj.AP_Opposing_counsel_Phone__c = '12412';
        appealObj.AP_Appeal_Status__c = 'Pending Resolution';
        insert appealObj;
        
        appealObj = [SELECT AP_Resolution_Amount__c, AP_Resolution_Date__c, AP_Resolution_Notes__c, AP_Resolution_Payment_To__c, 
                        AP_Resolution_Type__c, AP_Appeal_Status__c FROM Appeal__c WHERE id =: appealObj.id];
        //appealObj.AP_Resolution_Amount__c = 121;
        appealObj.AP_Resolution_Date__c = system.today();
        appealObj.AP_Resolution_Notes__c = 'Test';
        appealObj.AP_Resolution_Payment_To__c = 'ACF';
        appealObj.AP_Resolution_Type__c = 'Arbitration';
        appealObj.AP_Appeal_Status__c = 'Closed';
        update appealObj;
        
        appealObj = [SELECT AP_Resolution_Amount__c, AP_Resolution_Date__c, AP_Resolution_Notes__c, AP_Resolution_Payment_To__c, 
                        AP_Resolution_Type__c, AP_Appeal_Status__c FROM Appeal__c WHERE id =: appealObj.id];
        appealObj.AP_Resolution_Amount__c = null;
        appealObj.AP_Resolution_Date__c = null;
        appealObj.AP_Resolution_Notes__c = null;
        appealObj.AP_Resolution_Payment_To__c = null;
        appealObj.AP_Resolution_Type__c = null;
        appealObj.AP_Appeal_Status__c = 'Pending Resolution';
        update appealObj;
    }
}