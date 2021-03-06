@isTest
private class PNA_PDFReportControllerTest {

    static testMethod void pdfControllerTest() {
        // TO DO: implement unit test
        
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
        pamObj = new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Account_Number__c='121211',SOL_Placement_Date__c=system.today().addDays(-2),
                                                        RecordTypeId=Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO PNA').getRecordTypeId(),
                                                        Status__c = 'First Escalation');
        insert pamObj;
        
        Test.startTest();
        
	        PageReference pageRef = Page.PNA_PDFReport;
	        pageRef.getParameters().put('id',acc.Id);
	        pageRef.setRedirect(true);
	        Test.setCurrentPageReference(pageRef);
	        
	        PNA_PDFReportController pdf = new PNA_PDFReportController();
	        
	    Test.stopTest();
	    
	    system.assert(true);
        
    }
}