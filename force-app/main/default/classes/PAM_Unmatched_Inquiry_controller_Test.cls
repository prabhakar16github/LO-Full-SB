@isTest
public class PAM_Unmatched_Inquiry_controller_Test {

    public static testMethod void Test_PAM_Unmatched_Inquiry_controller(){
        
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
        
        PCodeSetting__c pcodeSetting = new PCodeSetting__c();
        pcodeSetting.PcodeValue__c = 'S441';
        pcodeSetting.Name = 'Oral dispute'; 
        
        insert pcodeSetting;
        
        PCodeSetting__c pcodeSetting1 = new PCodeSetting__c();
        pcodeSetting1.PcodeValue__c = 'S442';
        pcodeSetting1.Name = 'Written dispute'; 
        
        insert pcodeSetting1;
        
        
        PCodeSetting__c pcodeSetting2 = new PCodeSetting__c();
        pcodeSetting2.PcodeValue__c = 'M058';
        pcodeSetting2.Name = 'Mailed out validation'; 
        
        insert pcodeSetting2;
        
        Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c();
        pamObj = new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Account_Number__c='121211',SOL_Firm_Date_Filed_Suit__c=system.today(),
                                                        SOL_Firm_SOL_Date__c=system.today(),SOL_Firm_SOL_Process__c='Test',
                                                        SOL_State_Where_Firm_Filed_Suit__c='AK',RecordTypeId=Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SOL').getRecordTypeId());
        insert pamObj;
        
        PAM_Unmatched__c pamun = new PAM_Unmatched__c();
        pamun.PAMUM_Account_Number__c = '1234567';
        pamun.PAMUM_Organization_Name__c = acc.Id;
        pamun.PAMUM_Process_Adherence_Monitoring__c = pamObj.Id;
        pamun.SCMDUM_PCode_Sent__c = 'S441';
        pamun.RecordTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId();
        insert pamun;
        
        apexpages.currentpage().getparameters().put('id',pamun.id);
        PAM_Unmatched_Inquiry_controller pamUnInqObj = new PAM_Unmatched_Inquiry_controller();
        pamUnInqObj.saveCase();

 
        PAM_Unmatched__c pamObj1 = new PAM_Unmatched__c();
        pamObj1 = new PAM_Unmatched__c(PAMUM_Organization_Name__c = acc.id,PAMUM_Account_Number__c='121211',PAMUM_Process_Adherence_Monitoring__c=pamObj.Id,
                                                        RecordTypeId=Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId());
        insert pamObj1;
    }
}