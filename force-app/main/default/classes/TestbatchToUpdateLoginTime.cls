@isTest(seeAllData = true)
public class TestbatchToUpdateLoginTime {
    public static testMethod void TestbatchToUpdateLoginTime(){
      
        Account a1 = new Account();
        a1.Name = 'TestAcc';
        a1.Firm_ID__c = 'Test';
        insert a1;
        Contact c = new Contact(AccountId = a1.id,LastName = 'abc',FirstName='aa');
        insert c;
        Profile p = [SELECT Id FROM Profile WHERE Name='CC - User Access' limit 1];
        User u2 = new User(Alias = 'newUser1', Username='test1@gmail.com.full',CommunityNickname='ann',Email='newuser@testorg.com',TimeZoneSidKey = 'Asia/Kuala_Lumpur',
        EmailEncodingKey='UTF-8', LastName='Testing',ContactId=c.id, LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id);
         System.runAs(u2) {
        Contact c1= new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c1;
      }
        
       
     
        Test.startTest();
        batchToUpdateLoginTime sb=new batchToUpdateLoginTime();
        Database.executeBatch(sb,500);
        Test.stopTest();
         
    }
}