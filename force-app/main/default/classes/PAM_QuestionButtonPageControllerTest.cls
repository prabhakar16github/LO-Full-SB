@isTest
private class PAM_QuestionButtonPageControllerTest {

    static testMethod void PAM_QuestionButtonPageControllerTest() {  
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Case.getRecordTypeInfosByName();
        Id rtLeadID =  rtMap.get('Operations - PAM').getRecordTypeId();
        
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
        
        Process_Adherence_Monitoring__c Pam = new Process_Adherence_Monitoring__c();
        pam.Organization_Name__c = acc.id;
        
        insert Pam;
        
                
        ApexPages.StandardController sc = new ApexPages.StandardController(Pam);
        System.currentPageReference().getParameters().put('id', Pam.id);
        
        Case cas = new case();
        
        cas.Accountid = acc.id;
        cas.Process_Adherence_Monitoring__c = Pam.id;
        cas.Status = 'New';
        cas.Subcategories__c = 'FRB';
        cas.Reason = 'Process Adherence Monitoring (PAM)';
        
        insert cas;
        
        PAM_QuestionButtonPageController pamTest = new PAM_QuestionButtonPageController(sc);
        pamTest.getccLIst();
        pamTest.save();

             
    }
}