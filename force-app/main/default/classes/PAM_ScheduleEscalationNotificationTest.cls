@isTest
public class PAM_ScheduleEscalationNotificationTest {

    static testMethod void PAM_ScheduleEscalationNotificationTest() {
      Test.startTest();
        EmailTemplate template = [SELECT id,Name FROM EmailTemplate WHERE DeveloperName = 'PAM_Status_Second_Escalation'];
        system.debug('template-->'+template);
        Datetime dt = Datetime.now().addMinutes(1);
        PAM_ScheduleEscalationNotification sche = new PAM_ScheduleEscalationNotification();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        Id rtLeadID =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Operations - PAM').getRecordTypeId();
        
        Account acc = new Account();
        acc.Firm_ID__c ='test';
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        //acc.Paralegal__c = u.id;
        //acc.MCM_Attorney__c = u.id;
        insert acc;  
        
        User u = new User();
        u.Alias = 'ssa';
        u.Email='standarduser11sak@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingsak';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='sak1@salesforce.com';
        insert u; 
        
        List<Process_Adherence_Monitoring__c> pamList = new List<Process_Adherence_Monitoring__c>();
        
        pamList.add(new Process_Adherence_Monitoring__c(OwnerId=u.id,Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-2)));
        pamList.add(new Process_Adherence_Monitoring__c(OwnerId=u.id,Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-5)));
        pamList.add(new Process_Adherence_Monitoring__c(OwnerId=u.id,Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-8)));
        pamList.add(new Process_Adherence_Monitoring__c(OwnerId=u.id,Organization_Name__c = acc.id,Exception_Date__c=system.today().addDays(-13)));
        insert pamList;
        
        
        String sch = '0 0 23 * * ?';
        String jobId = System.schedule('Sample_Heading',sch,sche);   
        Process_Adherence_Monitoring__c pam = new Process_Adherence_Monitoring__c();
        Test.stopTest();
            
     
    }
}