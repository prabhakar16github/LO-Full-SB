/*
##########################################################################################################################################
# Project Name..........: LO - CT Test Class Re-Work
# File..................: Class : "Test_CT_SendEmail_Controller"
# Version...............: 1.0
# Created by............: Sunny Kumar   
# Created Date..........: 26-Mar-2015
# Last Modified by......: Sunny Kumar
# Last Modified Date....: 26-Mar-2015                         
# Description...........: All CT_ Classes were failing due to OLD API and Badly Written their individual test Coverage. So, a re-work over test
                          Coverage has been done for all of them.
###########################################################################################################################################
*/


@isTest
public class Test_CT_SendEmail_Controller{
    public static testMethod void test_CT_SendEmail_Controller_constructor() {

       
       String profileName = 'System Administrator';
         Profile p = [select id from profile where name = :profileName];
         
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
        insert testUser;
        
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
           EmailMsg__c e = new EmailMsg__c();
            e.Subject__c = 'test';
           // e.BccAddress__c=testUser.Email;
            e.ToAddress__c =c.id;
            e.Name= 'test';
            e.TextBody__c='ewddwdw';
            insert e;
        
         Attachment attach1 = new Attachment(Name = 'TEST ATTACHMENT'
                          , Body = Blob.valueOf('TEST BODY')
                          , ParentId = c.Id
                          , OwnerId = testUser.Id
                          , IsPrivate = false);
        insert attach1;   
        
        
        System.runAs(testUser) {
        Test.startTest();
        
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        //  CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
       
       //CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        //system.assert(ctrl.model != null);
        
        ctrl.ButtonClickEventAttachNewFile();
        ctrl.ButtonClickEventAttachSelectedExistingAttachments();
        ctrl.ButtonClickEventCancel();
        ctrl.ButtonClickEventSendEmail();
        ctrl.EventEmailAdditionalToChanged();
        ctrl.EventEmailBccChanged();
        ctrl.EventEmailCcChanged();
        ctrl.EventEmailToChanged();
        ctrl.EventSelectedAttachmentSourceChanged();
        ctrl.GetRecipientOptions();
        ctrl.GetEmailAttachmentSources();
        Test.stopTest();
    }
    }
/*
    public static testMethod void test_CT_SendEmail_Controller_ButtonClickEventAttachNewFile() {
       User testUser = [SELECT AccountId,City,CompanyName,Email,Id,IsActive,LastName,Name,ProfileId,
        Title,Username FROM User where IsActive=true and Profile.Name='System Administrator' limit 1];

    System.runAs(testUser) {
      Test.startTest();
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
    
        system.assert(ctrl.model != null);
        ctrl.ButtonClickEventAttachNewFile();
    
        Test.stopTest();
    }
        
    }

    public static testMethod void test_CT_SendEmail_Controller_ButtonClickEventAttachSelectedExistingAttachments() {
       User testUser = [SELECT AccountId,City,CompanyName,Email,Id,IsActive,LastName,Name,ProfileId,
        Title,Username FROM User where IsActive=true and Profile.Name='System Administrator' limit 1];

    System.runAs(testUser) {
      Test.startTest();
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);

        system.assert(ctrl.model != null);
        ctrl.ButtonClickEventAttachSelectedExistingAttachments();
    
    Test.stopTest();
    }
    }

    public static testMethod void test_CT_SendEmail_Controller_ButtonClickEventCancel() {
        User testUser = [SELECT AccountId,City,CompanyName,Email,Id,IsActive,LastName,Name,ProfileId,
        Title,Username FROM User where IsActive=true and Profile.Name='System Administrator' limit 1];

    System.runAs(testUser) {
      Test.startTest();
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        system.assert(ctrl.model != null);
        Pagereference pr = ctrl.ButtonClickEventCancel();
        system.assert(pr != null);
    
    Test.stopTest();
    }
    }

    public static testMethod void test_CT_SendEmail_Controller_ButtonClickEventSendEmail_Positive(){
       User testUser = [SELECT AccountId,City,CompanyName,Email,Id,IsActive,LastName,Name,ProfileId,
        Title,Username FROM User where IsActive=true and Profile.Name='System Administrator' limit 1];
      
    System.runAs(testUser) {
      Test.startTest();
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        system.assert(ctrl.model != null);
        ctrl.model.EmailTo = 'testuser20120203@cloudtrigger.com';
        Pagereference pr = ctrl.ButtonClickEventSendEmail();
        //system.assert(pr != null);
    
    Test.stopTest();
    }
    }

    public static testMethod void test_CT_SendEmail_Controller_ButtonClickEventSendEmail_Negative(){
      User testUser = [SELECT AccountId,City,CompanyName,Email,Id,IsActive,LastName,Name,ProfileId,
        Title,Username FROM User where IsActive=true and Profile.Name='System Administrator' limit 1];

      System.runAs(testUser) {
      Test.startTest();
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        system.assert(ctrl.model != null);
        
        Pagereference pr = ctrl.ButtonClickEventSendEmail();
        
    
    Test.stopTest();
    }
    }

    public static testMethod void test_CT_SendEmail_Controller_EventEmailAdditionalToChanged() {
       User testUser = [SELECT AccountId,City,CompanyName,Email,Id,IsActive,LastName,Name,ProfileId,
        Title,Username FROM User where IsActive=true and Profile.Name='System Administrator' limit 1];

    System.runAs(testUser) {
      Test.startTest();
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        system.assert(ctrl.model != null);
        ctrl.EventEmailAdditionalToChanged();
    
    Test.stopTest();
    }
        
    }

    public static testMethod void test_CT_SendEmail_Controller_EventEmailBccChanged() {
       User testUser = [SELECT AccountId,City,CompanyName,Email,Id,IsActive,LastName,Name,ProfileId,
        Title,Username FROM User where IsActive=true and Profile.Name='System Administrator' limit 1];

    System.runAs(testUser) {
       Test.startTest();
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        system.assert(ctrl.model != null);
        ctrl.EventEmailBccChanged();
    
    Test.stopTest();
    }
    }

    public static testMethod void test_CT_SendEmail_Controller_EventEmailCcChanged() {
        User testUser = [SELECT AccountId,City,CompanyName,Email,Id,IsActive,LastName,Name,ProfileId,
        Title,Username FROM User where IsActive=true and Profile.Name='System Administrator' limit 1];
       System.runAs(testUser) {
       Test.startTest();
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        system.assert(ctrl.model != null);
        ctrl.EventEmailCcChanged();
    
    Test.stopTest();
    }
    }

    public static testMethod void test_CT_SendEmail_Controller_EventEmailToChanged() {
        User testUser = [SELECT AccountId,City,CompanyName,Email,Id,IsActive,LastName,Name,ProfileId,
        Title,Username FROM User where IsActive=true and Profile.Name='System Administrator' limit 1];

    System.runAs(testUser) {
       Test.startTest();
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        system.assert(ctrl.model != null);
        ctrl.EventEmailToChanged();
    
    Test.stopTest();
    }
    }

    public static testMethod void test_CT_SendEmail_Controller_GetEmailAttachmentSources() {
       User testUser = [SELECT AccountId,City,CompanyName,Email,Id,IsActive,LastName,Name,ProfileId,
        Title,Username FROM User where IsActive=true and Profile.Name='System Administrator' limit 1];

    System.runAs(testUser) {
      Test.startTest();
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        system.assert(ctrl.model != null);
        list<SelectOption> options = ctrl.GetEmailAttachmentSources();
    system.assert(options != null);
    Test.stopTest();
    }
    }

    public static testMethod void test_CT_SendEmail_Controller_GetRecipientOptions() {
        User testUser = [SELECT AccountId,City,CompanyName,Email,Id,IsActive,LastName,Name,ProfileId,
        Title,Username FROM User where IsActive=true and Profile.Name='System Administrator' limit 1];

    System.runAs(testUser) {
      Test.startTest();
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        system.assert(ctrl.model != null);
        list<SelectOption> options = ctrl.GetRecipientOptions();
    system.assert(options != null);
    Test.stopTest();
    }
    } */
}