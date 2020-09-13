@isTest
public class IR_MonthlyDayBeforeCutOffTest {
	@isTest
    static void unitTest1(){
        Account acc = new Account();
        acc.Name = 'TestAcc';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('In Network').getRecordTypeId();
        acc.Firm_Status_IN__c = 'Active';
        acc.Firm_ID__c = '123';
        insert acc;    
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'testCon';
        con.Contact_Type_SME__c = 'Inventory Reconciliation';
        con.Inactive_Contact__c = false;
        insert con;
        
        EmailNotification__c em = new EmailNotification__c();
        em.Name = 'System Admin';
        em.Email__c = 'test@abc.com';
        insert em;
        
        Database.executeBatch(new IR_MonthlyDayBeforeCutOff());
    }
}