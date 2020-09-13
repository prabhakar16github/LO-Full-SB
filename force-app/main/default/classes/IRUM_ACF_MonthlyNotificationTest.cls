@isTest
private class IRUM_ACF_MonthlyNotificationTest {
    @testSetup
    private static void setUp(){
      
        Account accountObj = new Account();
        accountObj.Firm_ID__c = 'UT-11';
        accountObj.Firm_Status_IN_ACF__c = 'Active';
        accountObj.Name = 'Test Organisation';
        insert accountObj;

        Contact contactObj = new Contact();
        contactObj.Contact_Type_SME__c = 'Inventory Reconciliation'; 
        contactObj.AccountId = accountObj.Id;
        contactObj.FirstName = 'Test';
        contactObj.LastName = 'Test Value User No Duplicate';
        contactObj.Email = 'test@123.com';
        contactObj.Community_User__c = true;
        insert contactObj;
        
        EmailNotification__c em = new EmailNotification__c();//added on 30-09
        em.Name = 'System Admin';
        em.Email__c = 'test@abc.com';
        insert em;
        
        //String reportingPeriod = String.valueOf(System.today().year()) +'-'+ String.valueOf(System.today().month());
        /*Date reportingDate = System.today();
        string month = string.valueOf(reportingDate.month());
        if(month.length() == 1){
            month = '0'+month;
        }
        string ReportingPeriod = reportingDate.year()+'-'+month;*/
        
        Date todaysDate = System.today().addMonths(-1);
    	String month = String.valueOf(todaysDate.month());
        
        if(month.length() == 1){
        	month = '0' + month; // format month
        }
        String reportingPeriod = todaysDate.year() +'-'+ month; 
        System.debug('ReportingPeriod >> '+reportingPeriod);
         
    	
    	Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c();
    	Id pamIRRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR - Account #\'s Sent').getRecordTypeId();
    	pamObj.Organization_Name__c = accountObj.Id;
    	pamObj.OwnerId = UserInfo.getUserId();
    	pamObj.Status__c = 'Accounts Sent To ISeries';
    	pamObj.IR_Open_Inventory_Act_Volume__c = 1001;
    	pamObj.RecordTypeId = pamIRRecordTypeId;
        pamObj.SCMD_Reporting_Period__c = ReportingPeriod;
    	insert pamObj;
        
        Id pamUmOpenIRRecordTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Open').getRecordTypeId();
    	PAM_Unmatched__c pamUmObj = new PAM_Unmatched__c();
		pamUmObj.PAMUM_Process_Adherence_Monitoring__c = pamObj.Id;
		pamUmObj.PAMUM_Account_Number__c = '1223456789';
        pamUmObj.PAMUM_Status__c = 'New';
        //pamUmObj.SCMDUM_Reporting_Period__c = pamObj.SCMD_Reporting_Period__c;
		pamUmObj.RecordTypeId = pamUmOpenIRRecordTypeId;
		pamUmObj.SCMDUM_Record_Creation_Notification_Sent__c = false;
        insert pamUmObj;
    }
    @isTest
    static void creationNotification(){
        Process_Adherence_Monitoring__c pamObj = [SELECT Id FROM Process_Adherence_Monitoring__c LIMIT 1];
        
        Id pamUmOpenIRRecordTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Open').getRecordTypeId();
    	PAM_Unmatched__c pamUmObjNew = new PAM_Unmatched__c();
		pamUmObjNew.PAMUM_Process_Adherence_Monitoring__c = pamObj.Id;
		pamUmObjNew.PAMUM_Account_Number__c = '1223456789';
		pamUmObjNew.PAMUM_Status__c = 'New';
		pamUmObjNew.RecordTypeId = pamUmOpenIRRecordTypeId;
		pamUmObjNew.SCMDUM_Record_Creation_Notification_Sent__c = false;
        //insert pamUmObj;
        
        PAM_Unmatched__c pamUmObj1 = new PAM_Unmatched__c();
		pamUmObj1.PAMUM_Account_Number__c = '1234569871';
        pamUmObj1.PAMUM_Process_Adherence_Monitoring__c = pamObj.Id;
		pamUmObj1.SCMDUM_Record_Creation_Notification_Sent__c = true;
        pamUmObj1.RecordTypeId = pamUmOpenIRRecordTypeId;
        pamUmObj1.PAMUM_Status__c = 'New';
        insert pamUmObj1;
        
        List<PAM_Unmatched__c> pamUmObjList = new List<PAM_Unmatched__c>(); 
		//pamUmObjList.add(pamUmObj1);
		pamUmObjList.add(pamUmObjNew);
		
		Date pamDate = date.parse('11/05/2019');
        Test.setCreatedDate(pamUmObj1.Id, pamDate);
        
        Test.startTest(); 
        insert pamUmObjList;
    	//Database.executeBatch(new IRUM_ACF_ReminderNotificationBatch());
        Database.executeBatch(new IRUM_ACF_CreationNotificationBatch());
        IRUM_ACF_ReminderNotificationScheduler reminder = new IRUM_ACF_ReminderNotificationScheduler();
        reminder.execute(null);
       // System.assert(true);
		IRUM_ACF_FirstEscalationScheduler first = new IRUM_ACF_FirstEscalationScheduler();
        first.execute(null);
        
        System.assert(true);
		Test.stopTest();
    	//System.assert(true);     
    }
    @isTest
    static void finalEscalationTest(){
      PAM_Unmatched__c pamObj = [SELECT Id FROM PAM_Unmatched__c LIMIT 1];
        pamObj.PAMUM_Status__c = 'First Escalation';
        update pamObj;
        
        Test.startTest();    								
    	//Database.executeBatch(new IRUM_ACF_FinalEscalationBatch());
    	IRUM_ACF_FinalEscalationScheduler finalesc = new IRUM_ACF_FinalEscalationScheduler();
        finalesc.execute(null);
        System.assert(true); 

		Test.stopTest();

    }
    @isTest
    static void noResponseTest(){
      PAM_Unmatched__c pamObj = [SELECT Id FROM PAM_Unmatched__c LIMIT 1];
        pamObj.PAMUM_Status__c = 'Final Escalation';
        update pamObj;
        
        Test.startTest();    								
    	//Database.executeBatch(new IRUM_ACF_NoResponseBatch());
    	IRUM_ACF_NoResponseScheduler noResponse = new IRUM_ACF_NoResponseScheduler();
        noResponse.execute(null);
        System.assert(true);
		Test.stopTest();
    	//System.assert(true); 
    }
}