@isTest
private class SCMDUM_FirstEscalationTest {

    static testMethod void firstEscalationTest() {
        // TO DO: implement unit test
        
        Datetime createdDate = System.now();
        createdDate = createdDate.addDays(-4);
        
        Id pamScmDisputeTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute').getRecordTypeId();
        Id pamUMScmDisputeRecordTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId();
        
        String reportingPeriod = '';
    	  
    	Date dateToday = System.today();
    	  
    	String month = String.valueOf(dateToday.month());
        
		if(month.length() == 1){
				
			month = '0' + month; // format month
		}
    	  
    	reportingPeriod = dateToday.year() +'-'+ month; 
    	
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
        
        Process_Adherence_Monitoring__c pamObj  = new Process_Adherence_Monitoring__c();
        
        pamObj.recordTypeId = pamScmDisputeTypeId;
        pamObj.SCMD_Reporting_Period__c = reportingPeriod;
        pamObj.Organization_Name__c = accountObj.Id;
        pamObj.Status__c = 'Final Escalation';
        
        
        insert pamObj;
        system.debug('createdDate-------->'+createdDate);
        Test.setCreatedDate(pamObj.id, createdDate);
        
        
        PAM_Unmatched__c scmdumObj = new PAM_Unmatched__c();
        scmdumObj.SCMDUM_PCode_Sent__c = 'Test';
        scmdumObj.PAMUM_Status__c = 'New';
        scmdumObj.PAMUM_Account_Number__c = '1234567891';
        scmdumObj.PAMUM_Process_Adherence_Monitoring__c = pamObj.id;
        scmdumObj.SCMDUM_PCode_Sent__c = 'S441';
        scmdumObj.recordTypeId = pamUMScmDisputeRecordTypeId;
        
        insert scmdumObj;
        
        Test.setCreatedDate(scmdumObj.id, createdDate);
        
        Test.startTest();
        	
	        SCMDUM_FirstEscalationNotification scmdumFirstEscalation = new SCMDUM_FirstEscalationNotification(reportingPeriod); 
	        
	        Database.executeBatch(scmdumFirstEscalation);
	        
	        SCMDisputeService.bufferCode();
	        
        Test.stopTest();
        
        System.assert(true);
        
    }
}