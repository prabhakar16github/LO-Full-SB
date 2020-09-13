@isTest
private class CustomReportSCMDControllerTest {

    static testMethod void scmdReportTest() {
        // TO DO: implement unit test
        
        Id pamScmDisputeTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute').getRecordTypeId();
        
        
        String reportingPeriod = '';
    	  
    	Date dateToday = System.today();
    	  
    	String month = String.valueOf(dateToday.month());
        
		if(month.length() == 1){
				
			month = '0' + month; // format month
		}
    	  
    	reportingPeriod = dateToday.year() +'-'+ month; 
    	
    	Account accountObj = new Account();
        
        accountObj.Firm_ID__c = 'UT-11';
        accountObj.Firm_Status_IN__c = 'Active';
        accountObj.Name = 'Test Organisation';
        
        insert accountObj;
        
        Process_Adherence_Monitoring__c pamObj  = new Process_Adherence_Monitoring__c();
        
        pamObj.recordTypeId = pamScmDisputeTypeId;
        pamObj.SCMD_Reporting_Period__c = reportingPeriod;
        pamObj.Organization_Name__c = accountObj.Id;
        pamObj.Status__c = 'Account Numbers Added';
        
        
        insert pamObj;
        
        Test.startTest();
        	
        	CustomReportSCMDController ctrlObj = new CustomReportSCMDController();
        	//ctrlObj.init();  
        	//ctrlObj.exportToExcel();
        	
        Test.stopTest();
    }
}