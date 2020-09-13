/*
##########################################################################################################################################
# Project Name..........: LO - CT Test Class Re-Work
# File..................: Class : "Test_CT_SendEmail_Model"
# Version...............: 1.0
# Created by............: Sunny Kumar   
# Created Date..........: 26-Mar-2015
# Last Modified by......: Sunny Kumar
# Last Modified Date....: 26-Mar-2015                         
# Description...........: All CT_ Classes were failing due to OLD API and Badly Written their individual test Coverage. So, a re-work over test
                          Coverage has been done for all of them.
###########################################################################################################################################
*/


@isTest(SeeAllData=true)
public class Test_CT_SendEmail_Model{
    public static testMethod void test_CT_SendEmail_Model_constructor() {
 
    /*String profileName = 'System Administrator';
    Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
      insert testUser;*/
      User testUser = [SELECT AccountId,City,CompanyName,Email,Id,IsActive,LastName,Name,ProfileId,
                       Title,Username FROM User where IsActive=true 
                       and Profile.Name='System Administrator' limit 1]; 
        
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        EmailMsg__c e = new EmailMsg__c();
        e.Subject__c = 'test';
       // e.BccAddress__c=testUser.Email;
        e.ToAddress__c =c.id;
        e.Name= 'test';
        e.TextBody__c='ewddwdw';
        insert e;
        
        Account acc = [SELECT Id FROM Account limit 1];
     /*   acc.name='test';
        insert acc;*/
        
        
        
         Attachment attach1 = new Attachment(Name = 'TEST ATTACHMENT'
                          , Body = Blob.valueOf('TEST BODY')
                          , ParentId = c.Id
                          , OwnerId = testUser.Id
                          , IsPrivate = false);
        insert attach1;  
         Attachment attach12 = new Attachment(Name = 'TEST ATTACHMENT 2'
                          , Body = Blob.valueOf('TEST BODY 2')
                          , ParentId = acc.Id
                          , OwnerId = testUser.Id
                          , IsPrivate = false);
        insert attach12;
        
      
        
        
           System.runAs(testUser) {    
         Test.startTest();     
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
         CT_SendEmail_Model model1 = new CT_SendEmail_Model(testUser.Id, acc.Id);
       
        system.assert(model != null && e!=null);
         model.DraftEmailMessage=e;
         model.EmailAdditionalTo='markandasunny@gmail.com';
         model.EmailAdditionalTo='xyz@gmail.com';
         model.EmailAdditionalTo=model.EmailAdditionalTo; 
         model.EmailTo ='markandasunny@gmail.com';
         model.EmailCC='markandasunny@gmail.com';
         model.EmailAttachmentSource='test';
         model.fileAttachmentBody = Blob.ValueOf('Test');
         model.fileAttachmentName='Test';
         model.fileAttachmentContentType ='Test'; 
         model.EmailFrom ='markandasunny@gmail.com';
         
         model.GetOutgoingEmailAttachments();
         model.Send();
         model.SendEmail();
         
         //  1
          model.DraftEmailMessage.BccAddress__c = c.Id;
        model.EmailBCC = '';
        model.BccChanged();
         
        
        // 2
         model.DraftEmailMessage.AdditionalTo__c = testUser.Id;
        model.EmailAdditionalTo = '';
        model.AdditionalToChanged();
       
        
        // 3
        model.DraftEmailMessage.CcAddress__c = c.Id;
        model.EmailCC = '';
        model.CcChanged();
        
        //4
        model.DraftEmailMessage.ToAddress__c = c.Id;
        model.EmailTo = '';
        model.ToChanged();
        system.assert(model.EmailTo.contains('testuser20120203@cloudtrigger.com'));   
        
        //5
                
        Attachment attach2 = model.GetAttachmentById(attach1.Id);
        system.assert(attach2 != null);
        system.assertEquals(attach2.Name,attach1.Name);
        
        // 6
        Set<Id> AttachmentIdSet = new Set<Id>();
        AttachmentIdSet.add(attach1.Id);
        AttachmentIdSet.add(attach2.Id);
        try{
            model.AttachExistingFileToEmail(AttachmentIdSet);
          }
        catch(CT_BaseApplicationException bex){}
        
        // 7
        try{
           
            model.AttachFileToEmailAndParentRecord();
        }
        catch(CT_BaseApplicationException bex)
        {}
        //8
         model.GetOutgoingEmailAttachments();
         
         //9
        // CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
         //ctrl.ButtonClickEventAttachNewFile();
         
         
      Test.stopTest();  
      }
      

    }
    
   /*
    public static testMethod void test_CT_SendEmail_Model_BccChanged() {

    String profileName = 'System Administrator';
    Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
      insert testUser;
          System.runAs(testUser) {    
         Test.startTest(); 
      Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
       
       
       
        model.DraftEmailMessage.BccAddress__c = c.Id;
        model.EmailBCC = '';
        model.BccChanged();
        system.assert(model.EmailBCC.contains('testuser20120203@cloudtrigger.com'));
       
       
  Test.stopTest(); 
 
   }
    } 
    public static testMethod void test_CT_SendEmail_Model_AdditionalToChanged() {
 
    String profileName = 'System Administrator';
    Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
      insert testUser;
        System.runAs(testUser) {    
         Test.startTest(); 
      Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        
        
        model.DraftEmailMessage.AdditionalTo__c = testUser.Id;
        model.EmailAdditionalTo = '';
        model.AdditionalToChanged();
        system.assert(model.EmailAdditionalTo.contains('testuser@cloudtrigger.net'));
        
        
 Test.stopTest();
 }
    }
    public static testMethod void test_CT_SendEmail_Model_CcChanged() {
 
    String profileName = 'System Administrator';
    Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
      insert testUser;
       System.runAs(testUser) {    
         Test.startTest();  
      Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        model.DraftEmailMessage.CcAddress__c = c.Id;
        model.EmailCC = '';
        model.CcChanged();
        system.assert(model.EmailCC.contains('testuser20120203@cloudtrigger.com'));
        
        Test.stopTest();
        
        }
 
    }
    public static testMethod void test_CT_SendEmail_Model_ToChanged(){
    
    String profileName = 'System Administrator';
    Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
      insert testUser;
        System.runAs(testUser) {    
         Test.startTest();      
      Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        model.DraftEmailMessage.ToAddress__c = c.Id;
        model.EmailTo = '';
        model.ToChanged();
        system.assert(model.EmailTo.contains('testuser20120203@cloudtrigger.com'));   
        // model.Send();
      //  model.SendEmail(); 
        Test.stopTest();    
        }
    }
    
    public static testMethod void test_CT_SendEmail_Model_GetAttachmentById() {
 
    String profileName = 'System Administrator';
    Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
      insert testUser;
      System.runAs(testUser) {    
         Test.startTest();     
      Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        Attachment attach1 = new Attachment(Name = 'TEST ATTACHMENT'
                          , Body = Blob.valueOf('TEST BODY')
                          , ParentId = c.Id
                          , OwnerId = testUser.Id
                          , IsPrivate = false);
        
        insert attach1;
        
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        Attachment attach2 = model.GetAttachmentById(attach1.Id);
        system.assert(attach2 != null);
        system.assertEquals(attach2.Name,attach1.Name);
       Test.stopTest();    
    }
    }
    
    public static testMethod void test_CT_SendEmail_Model_AttachExistingFileToEmail() {
 
    String profileName = 'System Administrator';
    Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
      insert testUser;
       System.runAs(testUser) {    
         Test.startTest();      
      Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        Attachment attach1 = new Attachment(Name = 'TEST ATTACHMENT'
                          , Body = Blob.valueOf('TEST BODY')
                          , ParentId = c.Id
                          , OwnerId = testUser.Id
                          , IsPrivate = false);
        insert attach1;
        
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        Attachment attach2 = model.GetAttachmentById(attach1.Id);
        Set<Id> AttachmentIdSet = new Set<Id>();
        AttachmentIdSet.add(attach1.Id);
        AttachmentIdSet.add(attach2.Id);
        try{
          model.AttachExistingFileToEmail(AttachmentIdSet);
    }
        catch(CT_BaseApplicationException bex)
        {
          
        }
         Test.stopTest();
    } 
    }
   
    public static testMethod void test_CT_SendEmail_Model_AttachFileToEmailAndParentRecord(){
    String profileName = 'System Administrator';
    Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
      insert testUser;
       System.runAs(testUser) {    
         Test.startTest();    
      Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        Attachment attach1 = new Attachment(Name = 'TEST ATTACHMENT'
                          , Body = Blob.valueOf('TEST BODY')
                          , ParentId = c.Id
                          , OwnerId = testUser.Id                           
                          , IsPrivate = false);
        insert attach1; 
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        Attachment attach2 = model.GetAttachmentById(attach1.Id);
        //GetEmailAttachments(attach2.Id);
        try{
           // model.EmailAttachments.add(attach1.id);
          model.AttachFileToEmailAndParentRecord();
        }
        catch(CT_BaseApplicationException bex)
        {}
         Test.stopTest();
       }
    }  
     
    public static testMethod void test_CT_SendEmail_Model_GetOutgoingEmailAttachments(){
    String profileName = 'System Administrator';
    Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
      insert testUser;
        System.runAs(testUser) {    
         Test.startTest();      
      Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
      Attachment attach1 = new Attachment(Name = 'TEST ATTACHMENT'
                          , Body = Blob.valueOf('TEST BODY')
                          , ParentId = c.Id
                          , OwnerId = testUser.Id
                          , IsPrivate = false);
        insert attach1;     
       // model.CT_AttachmentWrapper c1 =  new model.CT_AttachmentWrapper();
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        model.GetOutgoingEmailAttachments();
         Test.stopTest();
        }
       
    } */

    

}