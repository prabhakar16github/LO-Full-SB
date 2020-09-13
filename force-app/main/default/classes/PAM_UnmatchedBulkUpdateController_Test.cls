@isTest
public class PAM_UnmatchedBulkUpdateController_Test {
	@isTest
    static void test1(){
        Account acc = new Account();
        acc.Name = 'TestAcc';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('In Network').getRecordTypeId();
        acc.Firm_Status_IN_ACF__c = 'Active';
        acc.Firm_ID__c = '123';
        insert acc; 
        
        Process_Adherence_Monitoring__c pam1 = new Process_Adherence_Monitoring__c();
        pam1.RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute').getRecordTypeId();
        pam1.Status__c = 'New';
        pam1.Organization_Name__c = acc.Id;
        //pam1.Status__c = 'Accounts Sent To ISeries';
        insert pam1;
        
        PAM_Unmatched__c pamUmObj = new PAM_Unmatched__c();
		pamUmObj.PAMUM_Process_Adherence_Monitoring__c = pam1.Id;
		pamUmObj.PAMUM_Account_Number__c = '1223456789';
        pamUmObj.PAMUM_Status__c = 'New';
        pamUmObj.RecordTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId();
		insert pamUmObj;
        
        PAM_Unmatched__c pamUmObj2 = new PAM_Unmatched__c();
		pamUmObj2.PAMUM_Process_Adherence_Monitoring__c = pam1.Id;
		pamUmObj2.PAMUM_Account_Number__c = '1223456789';
        pamUmObj2.PAMUM_Status__c = 'New';
        pamUmObj2.RecordTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId();
		insert pamUmObj2;
        
        PAM_UnmatchedBulkUpdateController.umWrapper wrp1 = new PAM_UnmatchedBulkUpdateController.umWrapper(true,pamUmObj);
        PAM_UnmatchedBulkUpdateController.umWrapper wrp2 = new PAM_UnmatchedBulkUpdateController.umWrapper(true,pamUmObj2);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(pam1);
        PAM_UnmatchedBulkUpdateController obj = new PAM_UnmatchedBulkUpdateController(sc);
        obj.unMatchedWrapList = new List<PAM_UnmatchedBulkUpdateController.umWrapper>{wrp1,wrp2};
        obj.colName = 'pcodeSent';
        obj.init();
        obj.colName = 'accountNo';
        obj.init();
        obj.colName = 'recordType';
        obj.init();
        obj.selectedDescStr = 'Incorrect Account Number';
        obj.showNext();
        obj.showPrev();
        obj.getRecordTypePickList();
        obj.getItems();
        obj.unMatchedWrapList = new List<PAM_UnmatchedBulkUpdateController.umWrapper>{new PAM_UnmatchedBulkUpdateController.umWrapper(true,pamUmObj)};
        obj.checkSelected();
        obj.updateUMRecords();
        obj.selectedDescStr = 'Account submitted for wrong PCode';
        obj.updateUMRecords();
        obj.selectedDescStr = 'Process Error';
        obj.updateUMRecords();
    }
    
    @isTest
    static void test2(){
        Account acc = new Account();
        acc.Name = 'TestAcc';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('In Network').getRecordTypeId();
        acc.Firm_Status_IN_ACF__c = 'Active';
        acc.Firm_ID__c = '123';
        insert acc; 
        
        Process_Adherence_Monitoring__c pam1 = new Process_Adherence_Monitoring__c();
        pam1.RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR').getRecordTypeId();
        pam1.Status__c = 'New';
        pam1.Organization_Name__c = acc.Id;
        //pam1.Status__c = 'Accounts Sent To ISeries';
        insert pam1;
        
        PAM_Unmatched__c pamUmObj = new PAM_Unmatched__c();
		pamUmObj.PAMUM_Process_Adherence_Monitoring__c = pam1.Id;
		pamUmObj.PAMUM_Account_Number__c = '1223456789';
        pamUmObj.PAMUM_Status__c = 'New';
        pamUmObj.RecordTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
		insert pamUmObj;
        
        PAM_Unmatched__c pamUmObj2 = new PAM_Unmatched__c();
		pamUmObj2.PAMUM_Process_Adherence_Monitoring__c = pam1.Id;
		pamUmObj2.PAMUM_Account_Number__c = '1223456789';
        pamUmObj2.PAMUM_Status__c = 'New';
        pamUmObj2.RecordTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
		insert pamUmObj2;
        
        PAM_UnmatchedBulkUpdateController.umWrapper wrp1 = new PAM_UnmatchedBulkUpdateController.umWrapper(true,pamUmObj);
        PAM_UnmatchedBulkUpdateController.umWrapper wrp2 = new PAM_UnmatchedBulkUpdateController.umWrapper(true,pamUmObj2);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(pam1);
        PAM_UnmatchedBulkUpdateController obj = new PAM_UnmatchedBulkUpdateController(sc);
        
        
        obj.colName = 'recordType';
        obj.init();
        obj.selectedDescStr = 'Legal Obligation';
        obj.showNext();
        obj.showPrev();
        obj.getRecordTypePickList();
        obj.getItems();
        obj.unMatchedWrapList = new List<PAM_UnmatchedBulkUpdateController.umWrapper>{wrp1,wrp2};
        obj.checkSelected();
        obj.updateUMRecords();
    }
}