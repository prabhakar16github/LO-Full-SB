/*
 * @ Class Name      :     DataArchiveReportController_Test
 * @ Description     :     Test Class for DataArchiveReportController
 * @ Created By      :     Prabhakar Joshi
 * @ Created Date    :     16-Apr-2020
 * @ Last Modified   :     3-Feb-2021
 */

@isTest
public class DataArchiveReportController_Test{
    @TestSetup
    static void testsetup() {
        
        Trigger_Setting__c ts = new Trigger_Setting__c();
        ts.Name = 'AttachmentTrigger';
        ts.Active__c = true;
        insert ts;
        
        Account accObj = new Account();
		accObj.Firm_ID__c = 'test';
		accObj.Name = 'CA137';
        insert accObj;
        
		Consumer_Account_Details__c cadObj = new Consumer_Account_Details__c();
		cadObj.Organization_name__c = accObj.id;
		cadObj.Account_Number__c = '111';
        insert cadObj;
        
		Appeal__c ap = new Appeal__c();
		ap.AP_Appeal_Status__c = 'Closed';
		ap.AP_Pro_Se__c = true;
		ap.AP_Consumer_Account_Record__c = cadObj.Id;
		
        insert ap;
        
		Call_Monitoring__c cm = new Call_Monitoring__c();
		cm.RecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId();
		cm.Organization_Name_CM__c = accObj.id;
		cm.Account_Type_CM__c = 'MCM';
        
        insert cm;
        
        Process_Adherence_Monitoring__c pam = new Process_Adherence_Monitoring__c();
        pam.RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR - Account #\'s Sent').getRecordTypeId();
        pam.Status__c = 'Closed';
        pam.Organization_Name__c = accObj.Id;
        
        insert pam;
        
        Case cs = new Case();
        cs.AccountId = accObj.Id;
        cs.Status = 'Closed';
        cs.Data_Archived_Date__c = Case_DataArchiveHandler.eighteenMonthBeforeDate.addDays(-1);
        insert cs;
        
		Attachment att = new Attachment();
		att.ParentId = ap.Id;
		att.Name = 'testAtt';
		att.body = Blob.valueOf('testing');
		
        insert att;

        Attachment attForCM = new Attachment();
		attForCM.ParentId = cm.Id;
		attForCM.Name = 'testAtt';
		attForCM.body = Blob.valueOf('testing');
		insert attForCM;
        
        Attachment attForPAM = new Attachment();
		attForPAM.ParentId = pam.Id;
		attForPAM.Name = 'testAtt';
		attForPAM.body = Blob.valueOf('testing');
		insert attForPAM;
        
        Attachment attForCase = new Attachment();
		attForCase.ParentId = cs.Id;
		attForCase.Name = 'testAtt';
		attForCase.body = Blob.valueOf('testing');
		insert attForCase;
    }
    
	@isTest
	static void test1(){
        List<Trigger_Setting__c> tsList = [SELECT Name,Active__c FROM Trigger_Setting__c];
        List<Appeal__c> apList = [SELECT Id,AP_Appeal_Status__c FROM Appeal__c LIMIT 1];
        List<Attachment> LRMM_Att_List = [SELECT Id,ParentId FROM Attachment WHERE ParentId = :apList[0].Id];
        System.assertEquals(apList[0].Id, LRMM_Att_List[0].ParentId);
        DataArchiveReportController obj = new DataArchiveReportController();
        
         
        Id jobId = DataArchiveReportController.archiveData('LRMM_Tab');
        DataArchiveReportController.updateProgress(jobId);
        DataArchiveReportController.toggleAttachmentTrigger();
        
        obj.tabName = 'PAM_Tab';
        obj.init();
        DataArchiveReportController.archiveData('PAM_Tab');
        DataArchiveReportController.toggleAttachmentTrigger();
        
        obj.tabName = 'CS_Tab';
        obj.init();
        DataArchiveReportController.archiveData('CS_Tab');
        DataArchiveReportController.toggleAttachmentTrigger();
        
        obj.tabName = 'CM_Tab';
        obj.init();
        DataArchiveReportController.archiveData('CM_Tab');
        DataArchiveReportController.toggleAttachmentTrigger();
    }
}