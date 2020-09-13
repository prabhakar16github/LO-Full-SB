@isTest
private class PAM_UnmatchedTriggerHelperTest {
	
	@testSetup
	private static void testSetup(){
		
		String reportingPeriod = '';
    	Date dateToday = System.today();
    	String month = String.valueOf(dateToday.month());
		if(month.length() == 1){
			month = '0' + month; // format month
		}
    	reportingPeriod = dateToday.year() +'-'+ month; 
		
		Datetime createdDate = System.now();
        createdDate = createdDate.addDays(-5);
		Id pamScmDisputeTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute').getRecordTypeId();
		Id pamACFTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR - Account #\'s Sent').getRecordTypeId();

            
		PCodeSetting__c pcodeSetting = new PCodeSetting__c();
        pcodeSetting.PcodeValue__c = 'S441';
        pcodeSetting.Name = 'Oral dispute'; 
        insert pcodeSetting;
        
        PCodeSetting__c pcodeSetting1 = new PCodeSetting__c();
        pcodeSetting1.PcodeValue__c = 'S442';
        pcodeSetting1.Name = 'Written dispute'; 
        insert pcodeSetting1;
        
        PCodeSetting__c pcodeSetting2 = new PCodeSetting__c();
        pcodeSetting2.PcodeValue__c = 'M058';
        pcodeSetting2.Name = 'Mailed out validation'; 
        insert pcodeSetting2;
        
        Account accountObj = new Account();
        accountObj.Firm_ID__c = 'UT-11';
        accountObj.Firm_Status_IN__c = 'Active';
        accountObj.Name = 'Test Organisation';
        insert accountObj;
        Test.setCreatedDate(accountObj.id, createdDate);
        
        Contact contactObj = new Contact();
        contactObj.Contact_Type_SME__c = 'Process Adherence Monitoring (PAM)'; 
        contactObj.AccountId = accountObj.Id;
        contactObj.FirstName = 'Test';
        contactObj.LastName = 'Test Value User No Duplicate';
        contactObj.Email = 'test@123.com';
        contactObj.Community_User__c = true;
        contactObj.Inactive_Contact__c = False;
        insert contactObj;
        Test.setCreatedDate(contactObj.id, createdDate);
		
		Process_Adherence_Monitoring__c scmd = new Process_Adherence_Monitoring__c();
		scmd.SCMD_Reporting_Period__c = reportingPeriod;
        scmd.Organization_Name__c = accountObj.Id;
        scmd.Status__c = 'New';
        scmd.recordTypeId = pamScmDisputeTypeId;
        insert scmd;
        Test.setCreatedDate(scmd.id, createdDate); 
        
        Id scmdPamUmRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId();
        PAM_Unmatched__c pamUmSCMD = new PAM_Unmatched__c();
		pamUmSCMD.recordTypeId = scmdPamUmRecType;
        pamUmSCMD.SCMDUM_PCode_Sent__c = 'S441';
        pamUmSCMD.PAMUM_Status__c = 'New';
        pamUmSCMD.PAMUM_Account_Number__c = '1234567891';
        pamUmSCMD.SCMDUM_Correct_PCode__c = 'S441';
        pamUmSCMD.SCMDUM_Reason_for_Discrepancy__c ='Account Submitted For Wrong PCode';
        pamUmSCMD.PAMUM_Process_Adherence_Monitoring__c = scmd.id;
        insert pamUmSCMD;
        
        Process_Adherence_Monitoring__c acf = new Process_Adherence_Monitoring__c();
		acf.SCMD_Reporting_Period__c = reportingPeriod;
        acf.Organization_Name__c = accountObj.Id;
        acf.Status__c = 'New';
        acf.recordTypeId = pamACFTypeId;
        insert acf;
        Test.setCreatedDate(acf.id, createdDate); 
        
        Id acfPamUmRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Closed').getRecordTypeId();
		PAM_Unmatched__c pamUmACF = new PAM_Unmatched__c();
		pamUmACF.recordTypeId = acfPamUmRecType;
        pamUmACF.PAMUM_Status__c = 'Closed';
        pamUmACF.PAMUM_Account_Number__c = '1234567891';
        pamUmACF.PAMUM_Process_Adherence_Monitoring__c = acf.id;
        insert pamUmACF;
	}
	
	private static testMethod void beforeInsertLOSCMDPamUnmatchedTest(){
		
		Id pamScmDisputeTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute').getRecordTypeId();
		List<Process_Adherence_Monitoring__c> pamList = [SELECT Id, Name, Organization_Name__c, SCMD_Reporting_Period__c, 
																Status__c FROM Process_Adherence_Monitoring__c 
														WHERE RecordTypeId = :pamScmDisputeTypeId];
		
		Id scmdPamUmRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId();
		PAM_Unmatched__c pamUm = new PAM_Unmatched__c();
		pamUm.recordTypeId = scmdPamUmRecType;
        pamUm.SCMDUM_PCode_Sent__c = 'S441';
        pamUm.PAMUM_Status__c = 'New';
        pamUm.PAMUM_Account_Number__c = '1234567891';
        pamUm.SCMDUM_Correct_PCode__c = 'S441';
        pamUm.SCMDUM_Reason_for_Discrepancy__c ='Account Submitted For Wrong PCode';
        pamUm.PAMUM_Process_Adherence_Monitoring__c = pamList.get(0).id;
        
        /*PAM_Unmatched__c pamUmSCMD = new PAM_Unmatched__c();
		pamUmSCMD.recordTypeId = scmdPamUmRecType;
        pamUmSCMD.SCMDUM_PCode_Sent__c = 'S441';
        pamUmSCMD.PAMUM_Status__c = 'New';
        pamUmSCMD.PAMUM_Account_Number__c = '1234567891';
        pamUmSCMD.SCMDUM_Correct_PCode__c = 'S441';
        pamUmSCMD.SCMDUM_Reason_for_Discrepancy__c ='Account Submitted For Wrong PCode';
        pamUmSCMD.PAMUM_Process_Adherence_Monitoring__c = pamList.get(0).id;
        insert pamUmSCMD;*/
        
        Id pamACFTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR - Account #\'s Sent').getRecordTypeId();
        List<Process_Adherence_Monitoring__c> pamList1 = [SELECT Id, Name, Organization_Name__c, SCMD_Reporting_Period__c, 
																Status__c FROM Process_Adherence_Monitoring__c 
														WHERE RecordTypeId = :pamACFTypeId];
		
		Id acfPamUmRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Closed').getRecordTypeId();
		PAM_Unmatched__c pamUm1 = new PAM_Unmatched__c();
		pamUm1.recordTypeId = acfPamUmRecType;
        pamUm1.PAMUM_Status__c = 'New';
        pamUm1.PAMUM_Account_Number__c = '1234567891';
        pamUm1.PAMUM_Process_Adherence_Monitoring__c = pamList1.get(0).id;
        
        //List<PAM_Unmatched__c> unmatchedSCMD = [SELECT Id FROM PAM_Unmatched__c  WHERE SCMDUM_PCode_Sent__c='S441' LIMIT 1];
        
        
        Test.startTest();
        insert pamUm;
        insert pamUm1;
        PAM_UnmatchedTriggerHelper.testBufferCoverage();
        Test.stopTest();
	}
    
    /*private static testMethod void afterUpdateStatus(){
        Id pamACFTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR - Account #\'s Sent').getRecordTypeId();
        List<Process_Adherence_Monitoring__c> pamList = [SELECT Id, Name, Organization_Name__c, SCMD_Reporting_Period__c, 
																Status__c FROM Process_Adherence_Monitoring__c 
														WHERE RecordTypeId = :pamACFTypeId];
		
		Id scmdPamUmRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Closed').getRecordTypeId();
		PAM_Unmatched__c pamUm = new PAM_Unmatched__c();
		pamUm.recordTypeId = scmdPamUmRecType;
        //pamUm.SCMDUM_PCode_Sent__c = 'S441';
        pamUm.PAMUM_Status__c = 'Closed';
        pamUm.PAMUM_Account_Number__c = '1234567891';
        //pamUm.SCMDUM_Correct_PCode__c = 'S441';
        //pamUm.SCMDUM_Reason_for_Discrepancy__c ='Account Submitted For Wrong PCode';
        pamUm.PAMUM_Process_Adherence_Monitoring__c = pamList.get(0).id;
        Test.startTest();
        	insert pamUm;
        //PAM_UnmatchedTriggerHelper.testBufferCoverage();
        Test.stopTest();
    }*/
}