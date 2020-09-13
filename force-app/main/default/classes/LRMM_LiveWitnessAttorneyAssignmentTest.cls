@isTest
private class LRMM_LiveWitnessAttorneyAssignmentTest {

    static testMethod void LRMM_LiveWitnessAttorneyAssignmentTest() {
        
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
        
        State_Profile__c Sp = new State_Profile__c();
        Sp.Name = 'test';
        Sp.State_NPV_Group__c = 'High';
        Sp.SP_Paralegal__c = u.id;
        Sp.SP_MCM_Attorney__c = u.id;
            
        insert Sp;
        Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName();
        Id rtLeadID =  rtMap.get('Live Witness Request Step II').getRecordTypeId();
        Trial_Witness_Request__c TW = new Trial_Witness_Request__c();
        TW.Opposing_Counsel__c = 'test';
        TW.Opposing_Counsel_Comments__c = 'test';
        TW.Opposing_Counsel_Email__c = 'i@gmail.com';
        TW.Opposing_Counsel_Firm_Name__c = 'test';
        TW.Opposing_counsel_Phone__c = '235235';
        TW.Recordtypeid = rtLeadId;
        TW.OrganizationName__c = acc.id;
        TW.State_Filed_State_Profile__c = sp.Id;
        insert TW;
        
        TW.LW_Attorney_Approval_Needed__c = true;
        TW.LW_Attorney_Assignment__c = acc.MCM_Attorney__c;
        update TW;
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
        cadObj.CAD_Credit_Card__c = true;
        insert cadObj;
        
        return cadObj.id;
    }
    
    public static testMethod void testTrialWitess(){
        Consumer_Account_Details__c cadObj = [SELECT Organization_name__c FROM Consumer_Account_Details__c WHERE id =: createData()];
        
        Trial_Witness_Request__c trialWitnessObj = new Trial_Witness_Request__c();
        trialWitnessObj.Recordtypeid = Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName().get('Live Witness Request Step III').getRecordTypeId();
        trialWitnessObj.OrganizationName__c = cadObj.Organization_name__c;
        trialWitnessObj.TW_Consumer_Account_Records__c = cadObj.id;
        trialWitnessObj.Opposing_Counsel__c = 'test';
        trialWitnessObj.Opposing_Counsel_Comments__c = 'test';
        trialWitnessObj.Opposing_Counsel_Email__c = 'i@gmail.com';
        trialWitnessObj.Opposing_Counsel_Firm_Name__c = 'test';
        trialWitnessObj.Opposing_counsel_Phone__c = '235235';
        trialWitnessObj.Status__c = 'Pending Resolution';
        insert trialWitnessObj;
        
        trialWitnessObj = [SELECT LW_Resolution_Amount__c, LW_Resolution_Date__c, LW_Resolution_Notes__c, LW_Resolution_Payment_To__c, 
                        LW_Resolution_Type__c, Status__c FROM Trial_Witness_Request__c WHERE id =: trialWitnessObj.id];
        //trialWitnessObj.LW_Resolution_Amount__c = 121;
        trialWitnessObj.LW_Resolution_Date__c = system.today();
        trialWitnessObj.LW_Resolution_Notes__c = 'Test';
        trialWitnessObj.LW_Resolution_Payment_To__c = 'ACF';
        trialWitnessObj.LW_Resolution_Type__c = 'Arbitration';
        trialWitnessObj.Status__c = 'New';
        update trialWitnessObj;
        
        trialWitnessObj = [SELECT LW_Resolution_Amount__c, LW_Resolution_Date__c, LW_Resolution_Notes__c, LW_Resolution_Payment_To__c, 
                        LW_Resolution_Type__c, Status__c FROM Trial_Witness_Request__c WHERE id =: trialWitnessObj.id];
        trialWitnessObj.LW_Resolution_Amount__c = null;
        trialWitnessObj.LW_Resolution_Date__c = null;
        trialWitnessObj.LW_Resolution_Notes__c = null;
        trialWitnessObj.LW_Resolution_Payment_To__c = null;
        trialWitnessObj.LW_Resolution_Type__c = null;
        trialWitnessObj.Status__c = 'Pending Resolution';
        update trialWitnessObj;
    }
}