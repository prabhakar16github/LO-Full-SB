@isTest(SeeAllData= true)
public with sharing class Test_UpdateFirmDuringEmail2Case{
    static testMethod void UpdateFirmDuringEmail2Case(){
    
        list<Account> accList = new list<Account>();
        list<Account> accList1 = new list<Account>();
        Account a = new Account();
        a.Name = 'TestAcc';
        a.Firm_ID__c = 'Test';
        insert a;
        accList.add(a);
        
        Account a1 = new Account();
        a1.Name = 'TestAcc';
        a1.Firm_ID__c = 'CA20';
        insert a1;
        accList1.add(a1);
        
        Case c = new Case();
        c.subject='AK5 AAA ABA @9 dcwdd ed dddewew d w 12 32 1312 31312 4325 35543534##$$# 3#';
		c.Mapped_Organization_Value__c = null;
		c.AccountID = a1.id;
        insert c;
		
		Case c4 = new Case();
        c4.subject='AK3 AAA ABA @9 dcwdd ed dddewew d w 12 32 1312 31312 4325 35543534##$$# 3#';
		c4.Mapped_Organization_Value__c = null;
		c4.AccountID = a1.id;
        insert c4;
        
        Case c2 = new Case();
        c2.subject='';
        c2.AccountID = a1.id;
        insert c2;
        
        Case c1 = new Case();
        c1.subject='CA20 ss ss  ss';
        insert c1;
        
     }
       
             
    }