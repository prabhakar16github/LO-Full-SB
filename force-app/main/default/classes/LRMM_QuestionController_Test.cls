@isTest
public class LRMM_QuestionController_Test{
    
    public static testMethod void AppealUnitTest(){
        Appeal__c appealObj = new Appeal__c();
        appealObj.AP_Organization_Name__c = Test_Utility.CreateOrganization();
        appealObj.AP_Account_Number__c = '123456789';
        appealObj.OwnerId = UserInfo.getUserId();
        appealObj.AP_Opposing_Counsel__c = '23523';
        appealObj.AP_Opposing_Counsel_Comments__c = 'test';
        appealObj.AP_Opposing_Counsel_Email__c = 'test@gmail.com';
        appealObj.AP_Opposing_Counsel_Firm_Name__c = 'test';
        appealObj.AP_Opposing_counsel_Phone__c = '12412';
        insert appealObj;
        
        ApexPages.currentPage().getParameters().put('id',appealObj.id);
        //Creating Question
        LRMM_QuestionController questionObj = new LRMM_QuestionController();
        questionObj.caseObj.Subject = 'Short Description';
        questionObj.caseObj.Description = 'Description';
        questionObj.saveCase();
        
        Case caseObj = [SELECT Subject FROM Case WHERE Appeal_Record__c =: appealObj.id];
        system.assertEquals('Short Description',caseObj.Subject);
    }
    
    public static testMethod void TrialWitnessUnitTest(){
        Trial_Witness_Request__c twObj = new Trial_Witness_Request__c();
        twObj.OrganizationName__c = Test_Utility.CreateOrganization();
        twObj.Account_Number__c = '123456789';
        twObj.LW_Paralegal_Assignment__c = UserInfo.getUserId();
        insert twObj;
        
        ApexPages.currentPage().getParameters().put('id',twObj.id);
        //Creating Question
        LRMM_QuestionController questionObj = new LRMM_QuestionController();
        questionObj.caseObj.Subject = 'Short Description';
        questionObj.caseObj.Description = 'Description';
        questionObj.saveCase();
        
        Case caseObj = [SELECT Subject FROM Case WHERE Trial_Witness_Request__c =: twObj.id];
        system.assertEquals('Short Description',caseObj.Subject);
    }
}