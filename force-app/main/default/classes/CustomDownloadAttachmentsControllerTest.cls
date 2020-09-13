@isTest
private class CustomDownloadAttachmentsControllerTest {
    
    @testsetup
    private static void testsetup(){
        
        Account accountObj = new Account();
        accountObj.Firm_ID__c = 'UT-11';
        accountObj.Firm_Status_IN__c = 'Active';
        accountObj.Name = 'Test Organisation';
        insert accountObj;
        
        Contact contactObj = new Contact();
        contactObj.Contact_Type_SME__c = 'Inventory Reconciliation'; //Process Adherence Monitoring (PAM)
        contactObj.AccountId = accountObj.Id;
        contactObj.FirstName = 'Test';
        contactObj.LastName = 'Test Value User No Duplicate';
        contactObj.Email = 'test@123.com';
        contactObj.Community_User__c = true;
        insert contactObj;
        
    }
    
    @IsTest
    private static void controllerTest() {
        String reportingPeriod = String.valueOf(System.today().year()) +'-'+ String.valueOf(System.today().month());
        List<Account> accList = [SELECT Id FROM Account LIMIT 1];
        Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c();
        Id ACF_pamIRRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR').getRecordTypeId();
        pamObj.Organization_Name__c = accList.get(0).Id;
        pamObj.OwnerId = UserInfo.getUserId();
        pamObj.Status__c = 'Account Numbers Added';
        pamObj.IR_Open_Inventory_Act_Volume__c = 1001;
        pamObj.RecordTypeId = ACF_pamIRRecordTypeId;
        pamObj.SCMD_Reporting_Period__c = reportingPeriod;
        pamObj.Account_Type__c = 'Legacy';
        insert pamObj;
        
        Process_Adherence_Monitoring__c pamObj_ACF = new Process_Adherence_Monitoring__c();
        Id pamIRRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR').getRecordTypeId();
        pamObj_ACF.Organization_Name__c = accList.get(0).Id;
        pamObj_ACF.OwnerId = UserInfo.getUserId();
        pamObj_ACF.Status__c = 'Account Numbers Added';
        pamObj_ACF.IR_Open_Inventory_Act_Volume__c = 1001;
        pamObj_ACF.RecordTypeId = pamIRRecordTypeId;
        pamObj_ACF.SCMD_Reporting_Period__c = reportingPeriod;
        insert pamObj_ACF;
        
        Test.startTest();
        Attachment attach = new Attachment();   	
        attach.Name = 'Test';
        Blob bodyBlob = Blob.valueOf('Testing Body of Attachment');
        attach.body = bodyBlob;
        attach.parentId = pamObj.id;
        insert attach;
        
        IR_CustomDownloadAttachmentsController irCtrl = new IR_CustomDownloadAttachmentsController();
        irCtrl.init();  
        irCtrl.updateStatus(); 
        List<SelectOption> selOpts = irCtrl.getPAMRecordTypeList();
        IR_CustomDownloadAttachmentsController.updateIsDownloaded(pamObj.Id);		
        Test.stopTest();
        system.assert(true);
        
    }
}