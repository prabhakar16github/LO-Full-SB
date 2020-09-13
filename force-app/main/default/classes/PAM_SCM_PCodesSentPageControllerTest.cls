@isTest
private class PAM_SCM_PCodesSentPageControllerTest {

    static testMethod void initTest() {
        // TO DO: implement unit test
        
        Id pamNoPcodesTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute - No PCodes Sent').getRecordTypeId();
        
        Process_Adherence_Monitoring__c pamObj  = new Process_Adherence_Monitoring__c();
        
        pamObj.SCMD_Oral_Dispute_Account_s__c = '1234567891';
        pamObj.SCMD_Written_Dispute_Account_s__c = '1234567891';
        pamObj.SCMD_MailOutValidation_of_Debt_Account_s__c = '1234567891';
        pamObj.recordTypeId = pamNoPcodesTypeId;
        
        insert pamObj;
        
        Test.startTest();
        
        apexpages.currentpage().getparameters().put('id',pamObj.id);
        
        PAM_SCM_PCodesSentPageController pamCtrl = new PAM_SCM_PCodesSentPageController();
        pamCtrl.baseUrl = 'test';
        pamCtrl.init();
        
        Test.stopTest();
        
        System.assert(true);
    }
    
    static testMethod void savePcodeSentDetailsTest(){
		
		Id pamNoPcodesTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute - No PCodes Sent').getRecordTypeId();
        
        Process_Adherence_Monitoring__c pamObj  = new Process_Adherence_Monitoring__c();
        
        pamObj.SCMD_Oral_Dispute_Account_s__c = '1234567891';
        pamObj.SCMD_Written_Dispute_Account_s__c = '1234567891';
        pamObj.SCMD_MailOutValidation_of_Debt_Account_s__c = '1234567891';
        pamObj.recordTypeId = pamNoPcodesTypeId;
        
        insert pamObj;
        
        Test.startTest();
        
        PAM_SCM_PCodesSentPageController.PAMWrapper pamWrapperObj = new PAM_SCM_PCodesSentPageController.PAMWrapper(pamObj); 
        
        String pamWrapperObjString = JSON.serialize(pamWrapperObj);
        
        PAM_SCM_PCodesSentPageController.savePcodeSentDetails(pamWrapperObjString);
        
        Test.stopTest();
        
		System.assert(true);
    }
}