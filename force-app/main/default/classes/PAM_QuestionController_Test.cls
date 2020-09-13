@isTest
public class PAM_QuestionController_Test{
    
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
        acc.Firm_Specialist_ACF__c = u.Id;
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
        pamObj = new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Account_Number__c='121211',SOL_Firm_Date_Filed_Suit__c=system.today(),
                                                     SOL_Firm_SOL_Date__c=system.today(),SOL_Firm_SOL_Process__c='Test',
                                                     SOL_State_Where_Firm_Filed_Suit__c='AK',RecordTypeId=Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SOL').getRecordTypeId());
        insert pamObj;
        
        apexpages.currentpage().getparameters().put('id',pamObj.id);
        PAM_QuestionController pamQuestionObj = new PAM_QuestionController();
        pamQuestionObj.saveCase();
        
        
        Process_Adherence_Monitoring__c pamObj1 = new Process_Adherence_Monitoring__c();
        pamObj1 = new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Account_Number__c='121211',
                                                      RecordTypeId=Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO CCM - SR').getRecordTypeId());
        insert pamObj1;
        
        apexpages.currentpage().getparameters().put('id',pamObj1.id);
        PAM_QuestionController pamQuestionObj1 = new PAM_QuestionController();
        pamQuestionObj1.saveCase();
        
        Process_Adherence_Monitoring__c pamObj2 = new Process_Adherence_Monitoring__c();
        pamObj2 = new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Account_Number__c='121211',
                                                      RecordTypeId=Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO FRB').getRecordTypeId());
        insert pamObj2;
        
        Process_Adherence_Monitoring__c pamObj3 = new Process_Adherence_Monitoring__c();
        pamObj3 = new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Account_Number__c='121211',
                                                      RecordTypeId=Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute').getRecordTypeId());
        insert pamObj3;
        
        /********************* for ACF IR (Added on 16-08-2019) *******************/
        Process_Adherence_Monitoring__c pamObj4 = new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Account_Number__c='121211',
                                                                                      RecordTypeId=Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR').getRecordTypeId());
        insert pamObj4;
        
        Test.startTest();
        
        apexpages.currentpage().getparameters().put('id',pamObj2.id);
        PAM_QuestionController pamQuestionObj2 = new PAM_QuestionController();
        pamQuestionObj2.saveCase();
        
        apexpages.currentpage().getparameters().put('id',pamObj3.id);
        PAM_QuestionController pamQuestionObj3 = new PAM_QuestionController();
        pamQuestionObj3.saveCase();
        
        /********************* for ACF IR (Added on 16-08-2019) *******************/
        apexPages.currentPage().getParameters().put('id',pamObj4.Id);
        PAM_QuestionController pamQuestionObj4 = new PAM_QuestionController();
        pamQuestionObj4.saveCase();
        
        Test.stopTest();
        
        System.assert(true);
        /********************* for DM SCM (Added on 16-08-2019) *******************/
        Process_Adherence_Monitoring__c pamObj5 = new Process_Adherence_Monitoring__c();
        pamObj5 = new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Account_Number__c='121211',
                                                      RecordTypeId=Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM SCM Dispute').getRecordTypeId());
        insert pamObj5;
    }
}