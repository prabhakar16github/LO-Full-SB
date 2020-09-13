@isTest
public class LRMM_Response_InquiryController_Test{
    
    public static testMethod void AppealUnitTest(){
        Account acc = new Account();
        acc.name = 'test';
        insert acc; 
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'test';
        con.Email = 'test@gmail.com';
        insert con;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'CC - User Access'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'dsddsdjs@gmail.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ContactId = con.Id
        );
        
        insert u;
        
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Paralegal'].Id,
            LastName = 'last',
            Email = 'puser00@amamama.com',
            Username = 'dsddsdj@gmail.com' + System.currentTimeMillis(),
            CompanyName = 'TEST1',
            Title = 'Paralegal',
            Alias = 'alias1',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        
        insert u1;
        
        Appeal__c appealObj = new Appeal__c();
        appealObj.AP_Organization_Name__c = Test_Utility.CreateOrganization();
        appealObj.AP_Account_Number__c = '123456789';
        appealObj.OwnerId = u.Id;
        appealObj.AP_Opposing_Counsel__c = '23523';
        appealObj.AP_Opposing_Counsel_Comments__c = 'test';
        appealObj.AP_Opposing_Counsel_Email__c = 'test@gmail.com';
        appealObj.AP_Opposing_Counsel_Firm_Name__c = 'test';
        appealObj.AP_Opposing_counsel_Phone__c = '12412';
        appealObj.AP_Paralegal_Assignment__c = u1.Id;
        insert appealObj;
        
        ApexPages.currentPage().getParameters().put('id',appealObj.id);
        //Sending Email for Response
        LRMM_Response_InquiryController responseObj = new LRMM_Response_InquiryController();
        responseObj.isResponse = true;
        responseObj.changeQuestionLabel();
        system.assertEquals('Response Details',responseObj.questionLabel);
        responseObj.saveCase();
        
        //Sending Email for Inquiry
        LRMM_Response_InquiryController inquiryObj = new LRMM_Response_InquiryController();
        inquiryObj.changeQuestionLabel();
        inquiryObj.isInquiry = true;
        inquiryObj.changeQuestionLabel();
        system.assertEquals('Inquiry Details',inquiryObj.questionLabel);
        inquiryObj.saveCase();
        
        //Sending Email without Inquiry or Response
        LRMM_Response_InquiryController ctrlObj = new LRMM_Response_InquiryController();
        ctrlObj.saveCase();
    }
    
    public static testMethod void TrialWitnessUnitTest(){
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc; 
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'test';
        con.Email = 'test@gmail.com';
        insert con;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'CC - User Access'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'dsddsdjs@gmail.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ContactId = con.Id
        );
        
        insert u;
        
        Trial_Witness_Request__c twObj = new Trial_Witness_Request__c();
        twObj.OrganizationName__c = Test_Utility.CreateOrganization();
        twObj.Account_Number__c = '123456789';
        twObj.LW_Paralegal_Assignment__c = u.Id;
        insert twObj;
        
        ApexPages.currentPage().getParameters().put('id',twObj.id);
        //Sending Email for Response
        LRMM_Response_InquiryController responseObj = new LRMM_Response_InquiryController();
        responseObj.isResponse = true;
        responseObj.changeQuestionLabel();
        system.assertEquals('Response Details',responseObj.questionLabel);
        responseObj.attList[0].body = Blob.valueOf('Test');
        responseObj.attList[0].Name = 'Sample Test';
        responseObj.saveCase();
    }
    
}