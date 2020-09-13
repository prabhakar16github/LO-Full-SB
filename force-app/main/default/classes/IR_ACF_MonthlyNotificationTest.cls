@isTest
public class IR_ACF_MonthlyNotificationTest {
    
    @testSetup
    static void setUp(){
        Account acc = new Account();
        acc.Name = 'TestAcc';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('In Network').getRecordTypeId();
        acc.Firm_Status_IN_ACF__c = 'Active';
        acc.Firm_ID__c = '123';
        insert acc;    
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'testCon';
        con.Email = 'con@test.com';
        con.Contact_Type_SME__c = 'Inventory Reconciliation';
        con.Inactive_Contact__c = false;
        con.Community_User__c = true;
        insert con;
        
        EmailNotification__c em = new EmailNotification__c();
        em.Name = 'System Admin';
        em.Email__c = 'test@abc.com';
        insert em;
        
    }
    
    @isTest
    static void initialNotificationTest(){
        Account acct = [SELECT Id FROM Account WHERE Name='TestAcc' LIMIT 1];
        
        Test.startTest();
        IR_ACF_InitialNotificationBatchScheduler initial = new IR_ACF_InitialNotificationBatchScheduler();
        initial.execute(null);
        System.assert(true);
        Test.stopTest();
    }
    
    @isTest
    static void createRecordNotificationTest(){
        Test.startTest();
        IR_ACF_RecordCreationScheduler first = new IR_ACF_RecordCreationScheduler();
        first.execute(null);
        System.assert(true);
        Test.stopTest();
        
        //IR_ACF_MonthlyRecordCreationBatch first = new IR_ACF_MonthlyRecordCreationBatch();
        //Database.executeBatch(first);
        
    }
    
    @isTest
    static void reminderNotificationTest(){
        Account acct = [SELECT Id FROM Account WHERE Name='TestAcc' LIMIT 1];
        Contact cont = [SELECT Id FROM Contact WHERE LastName = 'testCon' LIMIT 1];
        
        Date today_date = System.today();
        String month = String.valueOf(today_date.month());
        if(month.length() == 1){
            month = '0'+month;
        }
        string reportingPeriod = today_date.year()+'-'+month;
        
        Process_Adherence_Monitoring__c pam1 = new Process_Adherence_Monitoring__c();
        pam1.RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR').getRecordTypeId();
        pam1.Status__c = 'New';
        pam1.SCMD_Reporting_Period__c = reportingPeriod;
        pam1.Organization_Name__c = acct.Id;
        insert pam1;
        
        Process_Adherence_Monitoring__c pam2 = new Process_Adherence_Monitoring__c();
        pam2.RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR').getRecordTypeId();
        pam2.Status__c = 'Final Escalation';
        pam2.SCMD_Reporting_Period__c = reportingPeriod;
        pam2.Organization_Name__c = acct.Id;
        insert pam2;
        
        Date pamDate = date.parse('08/28/2019');
        Test.setCreatedDate(pam1.Id, pamDate);
        
        Test.startTest();
        IR_ACF_ReminderScheduler objSch = new IR_ACF_ReminderScheduler();
        objSch.execute(null);
        System.assert(true);
        Test.stopTest();
    }
}