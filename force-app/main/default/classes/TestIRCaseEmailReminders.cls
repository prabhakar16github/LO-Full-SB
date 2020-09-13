@isTest(seeAllData = true)
public class TestIRCaseEmailReminders {
    public static testMethod void TestIRCaseEmailRemindersWithCutOffDateTomorrow(){
        Account a1 = new Account();
        a1.Name = 'TestAcc';
        a1.Firm_ID__c = 'Test';
        insert a1;
        Contact c = new Contact(AccountId = a1.id,LastName = 'abc',FirstName='aa',Inactive_Contact__c = false,Email ='aa@gmail.com',Contact_Type_SME__c  = 'Inventory Reconciliation');
        insert c;
        CutOffDate__c cutOffDate1 = new CutOffDate__c (Name = 'test', Cut_Off_Date__c = system.today()+1,Month__C = system.today().month());
        insert cutOffDate1;
        IRCaseEmailReminders sb=new IRCaseEmailReminders();
        Database.executeBatch(sb,500);
       
       
    }
    public static testMethod void TestIRCaseEmailRemindersWithCutOffafterSevendys(){
        Account a1 = new Account();
        a1.Name = 'TestAcc';
        a1.Firm_ID__c = 'Test';
        insert a1;
        Contact c = new Contact(AccountId = a1.id,LastName = 'abc',FirstName='aa',Inactive_Contact__c = false,Email ='aa@gmail.com',Contact_Type_SME__c  = 'Inventory Reconciliation');
        insert c;
        CutOffDate__c cutOffDate2 = new CutOffDate__c (Name = 'test1', Cut_Off_Date__c = system.today()+7,Month__C = system.today().month());
        insert cutOffDate2;
        system.debug('====cutOffDate2 =='+cutOffDate2 );
        IRCaseEmailReminders sb1=new IRCaseEmailReminders();
        Database.executeBatch(sb1,500);
    }
}