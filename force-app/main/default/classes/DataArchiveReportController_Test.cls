/***********************************************************************************
 * Class Name  : DataArchiveReportController_Test
 * Description : Test class for DataArchiveReportController
 * Created By  : Prabhakar Joshi
 * Created Date: 16-Apr-2020
 * *******************************************************************************/

@isTest
public class DataArchiveReportController_Test{
    @TestSetup
    static void testsetup() {
       Trigger_Setting__c ts = new Trigger_Setting__c();
        ts.Name = 'AttachmentTrigger';
        ts.Active__c = true;
        insert ts;
    }
    
	@isTest
	static void test1(){
        List<Trigger_Setting__c> tsList = [SELECT Name,Active__c FROM Trigger_Setting__c];
        DateTime lastDate = LRMM_DataArchiveHandler.lastDate;
        DateTime sixMonthBeforeDate = System.today().addMonths( - 7);
        DateTime oneYearBeforeDate = System.today().addMonths( - 13);

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
		ap.CreatedDate = lastDate.addDays( - 1);
		ap.LastModifiedDate = lastDate.addDays( - 1);
        insert ap;
        
		Call_Monitoring__c cm = new Call_Monitoring__c();
		cm.RecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId();
		cm.Organization_Name_CM__c = accObj.id;
		cm.Account_Type_CM__c = 'MCM';
        cm.createdDate = sixMonthBeforeDate;
        cm.lastModifiedDate = sixMonthBeforeDate;
        insert cm;
        
        Process_Adherence_Monitoring__c pam = new Process_Adherence_Monitoring__c();
        pam.RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR - Account #\'s Sent').getRecordTypeId();
        pam.Status__c = 'Closed';
        pam.Organization_Name__c = accObj.Id;
        pam.CreatedDate = sixMonthBeforeDate;
        pam.LastModifiedDate = sixMonthBeforeDate;
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
		att.CreatedDate = lastDate.addDays( - 1);
		att.LastModifiedDate = lastDate.addDays( - 1);
        insert att;

        Attachment attForCM = new Attachment();
		attForCM.ParentId = cm.Id;
		attForCM.Name = 'testAtt';
		attForCM.body = Blob.valueOf('testing');
		attForCM.CreatedDate = sixMonthBeforeDate;
		attForCM.LastModifiedDate = sixMonthBeforeDate;
        insert attForCM;
        
        Attachment attForPAM = new Attachment();
		attForPAM.ParentId = pam.Id;
		attForPAM.Name = 'testAtt';
		attForPAM.body = Blob.valueOf('testing');
		attForPAM.CreatedDate = sixMonthBeforeDate;
		attForPAM.LastModifiedDate = sixMonthBeforeDate;
        insert attForPAM;
        
        Attachment attForCase = new Attachment();
		attForCase.ParentId = cs.Id;
		attForCase.Name = 'testAtt';
		attForCase.body = Blob.valueOf('testing');
		attForCase.CreatedDate = Case_DataArchiveHandler.eighteenMonthBeforeDate.addDays(-1);
		attForCase.LastModifiedDate = Case_DataArchiveHandler.eighteenMonthBeforeDate.addDays(-1);
        insert attForCase;
        
        
		
        DataArchiveReportController obj = new DataArchiveReportController();
        obj.tabName = 'CM_Tab';
        obj.init();
        Id jobId = DataArchiveReportController.archiveData('CM_Tab','1000');
        DataArchiveReportController.updateProgress(jobId);
        
        obj.tabName = 'PAM_Tab';
        obj.init();
        Id jobId2 = DataArchiveReportController.archiveData('PAM_Tab','1000');
        DataArchiveReportController.updateProgress(jobId2);
        
        obj.tabName = 'Case_Tab';
        obj.selectedLimit = '1000';
        obj.init();
        obj.getItems();
        Id jobId3 = DataArchiveReportController.archiveData('Case_Tab','1000');
        DataArchiveReportController.updateProgress(jobId3);
        
        
        
	}
}