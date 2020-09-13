@isTest
public class PAM_InquiryController_Test{
    
    public static testMethod void unitTest(){
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
        
        Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c();
        pamObj = new Process_Adherence_Monitoring__c();
        pamObj.RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SOL').getRecordTypeId();                                                
        pamObj.Organization_Name__c = acc.id;
        pamObj.Account_Number__c = '121211';
        pamObj.SOL_Firm_Date_Filed_Suit__c=system.today();
        pamObj.SOL_Firm_SOL_Date__c=system.today();
        pamObj.SOL_Firm_SOL_Process__c='Test';
        pamObj.SOL_State_Where_Firm_Filed_Suit__c='AK';
        insert pamObj;
        
        apexpages.currentpage().getparameters().put('id',pamObj.id);
        
        PAM_InquiryController pamInquiryObj = new PAM_InquiryController();
        
        /************************************** for (LO FRB) PAM RecordType *****************************************************/
        
        pamObj.RecordTypeId=Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO FRB').getRecordTypeId();    
        update pamObj;
        PAM_InquiryController pamInquiryObj2 = new PAM_InquiryController();
        
        /************************************** for (LO IR) PAM RecordType *****************************************************/
        pamObj.RecordTypeId=Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR').getRecordTypeId();    
        update pamObj;
        PAM_InquiryController pamInquiryObj3 = new PAM_InquiryController();
        
        /************************************** for (LO PNA) PAM RecordType *****************************************************/
        pamObj.RecordTypeId=Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO PNA').getRecordTypeId();    
        update pamObj;
        PAM_InquiryController pamInquiryObj4 = new PAM_InquiryController();
        
        /************************************** for (LO PSNM) PAM RecordType *****************************************************/
        pamObj.RecordTypeId=Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO PSNM').getRecordTypeId();    
        pamObj.Account_Standing__c = '';
        update pamObj;
        PAM_InquiryController pamInquiryObj5 = new PAM_InquiryController();
        
        /*************************************** for (ACF IR) PAM RecordType *********************************************************/
        pamObj.RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR').getRecordTypeId();
        update pamObj;
        PAM_InquiryController pamInquiryObj6 = new PAM_InquiryController();
        
        pamInquiryObj.saveCase();
        
         /*************************************** for (DM IR) PAM RecordType *********************************************************/
        pamObj.RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM IR').getRecordTypeId();
        update pamObj;
        PAM_InquiryController pamInquiryObj7 = new PAM_InquiryController();
        
        pamInquiryObj.saveCase();
    }
}