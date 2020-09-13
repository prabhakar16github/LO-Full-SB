@isTest
public class SOLUpdateExceptionFieldsBatch_Test{
    
    public static testMethod void unitTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
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
        
        Account acc = new Account();
        acc.Firm_ID__c ='test';
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        acc.Paralegal__c = u.id;
        acc.MCM_Attorney__c = u.id;
        insert acc;   
        
        Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c();
        pamObj = new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Account_Number__c='121211',SOL_Firm_Date_Filed_Suit__c=system.today(),
                                                        SOL_Firm_SOL_Date__c=system.today(),SOL_Firm_SOL_Process__c='Test',SOL_State_Where_Firm_Filed_Suit__c='AK',
                                                        RecordTypeId=Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SOL').getRecordTypeId(),
                                                        Account_Standing__c='0-4 Days (New Exception)');
        insert pamObj;
        
        Database.executeBatch(new SOLUpdateExceptionFieldsBatch(),1);
    }
}