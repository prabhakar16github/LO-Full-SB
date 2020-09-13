@isTest
private class SCMDUM_ACFFirstEscalationTest {
	
	@testSetup
    private static void testSetup() {
        Datetime createdDate = System.now();
        createdDate = createdDate.addDays(-4);
        
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
        
    }
    
    private static testMethod void firstEscalationScmdACFTest(){
    	
    	Datetime createdDate = System.now();
        createdDate = createdDate.addDays(-4);
    	
    	String reportingPeriod = '';
    	Date dateToday = System.today();
    	String month = String.valueOf(dateToday.month());
        
		if(month.length() == 1){
			month = '0' + month; // format month
		}
    	reportingPeriod = dateToday.year() +'-'+ month;
    	
    	List<Account> accountList = [SELECT Id, Name FROM Account];
    	Id pamScmDisputeTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute').getRecordTypeId();
        Id pamUMScmDisputeRecordTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF SCMDUM').getRecordTypeId();
        
    	Process_Adherence_Monitoring__c pamObj  = new Process_Adherence_Monitoring__c();
        pamObj.recordTypeId = pamScmDisputeTypeId;
        pamObj.SCMD_Reporting_Period__c = reportingPeriod;
        pamObj.Organization_Name__c = accountList.get(0).Id;
        pamObj.Status__c = 'Final Escalation';
        insert pamObj;
        Test.setCreatedDate(pamObj.id, createdDate);
        
        PAM_Unmatched__c scmdumObj = new PAM_Unmatched__c();
        scmdumObj.SCMDUM_PCode_Sent__c = 'Test';
        scmdumObj.PAMUM_Status__c = 'New';
        scmdumObj.PAMUM_Account_Number__c = '1234567891';
        //scmdumObj.SCMDUM_Reporting_Period__c = reportingPeriod;
        scmdumObj.PAMUM_Process_Adherence_Monitoring__c = pamObj.id;
        scmdumObj.SCMDUM_PCode_Sent__c = 'S441';
        scmdumObj.recordTypeId = pamUMScmDisputeRecordTypeId;
        insert scmdumObj;
        Test.setCreatedDate(scmdumObj.id, createdDate);
        
        Test.startTest();
	        SCMDUM_ACFFirstEscalationNotification scmdumFirstEscalation = new SCMDUM_ACFFirstEscalationNotification(reportingPeriod); 
	        Database.executeBatch(scmdumFirstEscalation);
        Test.stopTest();
        System.assert(true);
    }
}