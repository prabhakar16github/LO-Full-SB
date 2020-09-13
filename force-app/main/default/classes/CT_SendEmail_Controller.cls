public with sharing class CT_SendEmail_Controller extends CT_PageControllerBase
{
    private final String CLASSNAME = '\n\n**** CT_SendEmail_Controller.@@METHODNAME()';
    public CT_SendEmail_Model model{get;set;}

    private String sourceId;
    
    //  @author : CloudTrigger, Inc.
    //  @date : 1/23/2012
    //  @description :  this method is the constructor for the controller
    //  @paramaters : none
    //  @returns : nothing
    public CT_SendEmail_Controller()
    {
        String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'CT_SendEmail_Controller') + ' - constructor';
        system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + '\n\n');
        sourceId = ApexPages.currentPage().getParameters().get('id');
        //if(CT_Utility.StringIsNullOrEmpty(sourceId))
        // WHAT TO DO?
        model  = new CT_SendEmail_Model(UserInfo.getUserId(), sourceId);
    }
    
    //@author : CloudTrigger, Inc.
    //@date : 1/23/2012
    //@description : method to handle the button-click event when a user
    //@paramaters : none
    //@returns : nothing
    public void ButtonClickEventAttachNewFile()
    {
        String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'ButtonClickEventAttachNewFile');
        try{
            model.AttachFileToEmailAndParentRecord();
            
            model.EmailAttachmentSource = '';
        }
        catch(Exception ex)
        {
            if(ex instanceof CT_BaseApplicationException)
                this.ErrorMessageFatal(((CT_BaseApplicationException)ex).UserFriendlyMessage);
            else
                this.ErrorMessageFatal(ex.getMessage());
        }
    }
    
    //@author : CloudTrigger, Inc.
    //@date : 1/23/2012
    //@description : method to handle the button-click event when a user  
    //@paramaters : none
    //@returns : nothing
    public void ButtonClickEventAttachSelectedExistingAttachments()
    {
        String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'ButtonClickEventAttachSelectedExistingAttachments');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + '\n\n');
        try{
            Set<Id> AttachmentIds = new Set<Id>();
            for(CT_AttachmentWrapper wrapper:model.ExistingAttachments){
                if(wrapper.selected){
                    AttachmentIds.add(wrapper.attach.Id);
                }
            }
            if(AttachmentIds.size()>0)
                model.AttachExistingFileToEmail(AttachmentIds);
            else
                this.ErrorMessageInfo('You need to Select an existing attachment in order to send it with the email.');
                
            model.EmailAttachmentSource = '';
        }
        catch(Exception ex)
        {
            if(ex instanceof CT_BaseApplicationException)
                this.ErrorMessageFatal(((CT_BaseApplicationException)ex).UserFriendlyMessage);
            else
                this.ErrorMessageFatal(ex.getMessage());
        }

    }
     
    //@author : CloudTrigger, Inc.
    //@date : 1/23/2012
    //@description : method to handle the button-click event when a user clicks the "Cancel" button
    //@paramaters : none
    //@returns : PageReference
    public PageReference ButtonClickEventCancel()
    {
        PageReference pr = new PageReference('/'+sourceId);
        pr.setRedirect(true);
        return pr;
    }

    //@author : CloudTrigger, Inc.
    //@date : 1/23/2012
    //@description : method to handle the button-click event when a user sends the outgoing email
    //@paramaters : none
    //@returns : PageReference
    public PageReference ButtonClickEventSendEmail()
    {
        String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'ButtonClickEventSendEmail');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + '\n\n');
        try{
            if(CT_Utility.StringIsNullOrEmpty(model.EmailTo))
                throw CT_BaseApplicationException.NewException(METHODNAME, 'Exception Caught!','Must have at least one \'To\' address.');
            model.SendEmail();
            PageReference pr = new PageReference('/'+sourceId);
            pr.setRedirect(true);
            return pr;
        }
        catch(Exception ex)
        {
            if(ex instanceof CT_BaseApplicationException)
                this.ErrorMessageFatal(((CT_BaseApplicationException)ex).UserFriendlyMessage);
            else
                this.ErrorMessageFatal(ex.getMessage());
            return null;
        }
    }
    
    //@author : CloudTrigger, Inc.
    //@date : 1/23/2012
    //@description : method to ___
    //@paramaters : none
    //@returns : nothing
    public void EventEmailAdditionalToChanged()
    {
        String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'EventEmailBccChanged');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' \n\n');
        model.AdditionalToChanged();
    }
    
    //@author : CloudTrigger, Inc.
    //@date : 1/23/2012
    //@description : method to ___
    //@paramaters : none
    //@returns : nothing
    public void EventEmailBccChanged()
    {
        String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'EventEmailBccChanged');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' \n\n');
        model.BccChanged();
    }
    
    //@author : CloudTrigger, Inc.
    //@date : 1/23/2012
    //@description : method to ___
    //@paramaters : none
    //@returns : nothing
    public void EventEmailCcChanged()
    {
        String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'EventEmailCcChanged');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' \n\n');
        model.CcChanged();
    }
    
    //@author : CloudTrigger, Inc.
    //@date : 1/23/2012
    //@description : method to ___
    //@paramaters : none
    //@returns : nothing
    public void EventEmailToChanged()
    {
        String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'EventEmailToChanged');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' \n\n');
        model.ToChanged();
    }

    //@author : CloudTrigger, Inc.
    //@date : 1/23/2012
    //@description : method to handle the OnChange event when a user selects a source from the picklist for the attachmnet s/he wants  
    //@paramaters : none
    //@returns : nothing
    public void EventSelectedAttachmentSourceChanged()
    {
        //String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'EventSelectedAttachmentSourceChanged');
        //system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' :: EmailAttachmentSource = '+ model.EmailAttachmentSource +' \n\n');

    }
    
    //@author : CloudTrigger, Inc.
    //@date : 1/23/2012
    //@description : method to get a list of SelectOptions from model values
    //@paramaters : none
    //@returns : a list of SelectOptions for a select list
    public list<SelectOption> GetEmailAttachmentSources()
    {
        String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'GetEmailAttachmentSources');

        list<SelectOption> options = new list<SelectOption>();
        options.add(new SelectOption('','- SELECT -'));
        options.add(new SelectOption('local','My Computer'));
         
        if(model.ExistingAttachments.size()>0)
            options.add(new SelectOption('existing','Existing Attachment'));

        return options;
    }
    
    //@author : CloudTrigger, Inc.
    //@date : 1/23/2012
    //@description : method to get a list of SelectOptions from model values
    //@paramaters : none
    //@returns : a list of SelectOptions for a select list
    public list<SelectOption> GetRecipientOptions()
    {
        String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'GetRecipientOptions');

        list<SelectOption> options = new list<SelectOption>();
        for(Contact cont : model.ContactsWithStoredEmailAddresses)
        options.add(new SelectOption(cont.Id,cont.Name));

        return options;
    }

/*=======================================================================
*
*                           TEST METHODS
*
=======================================================================*/

 /*   public static testMethod void test_CT_SendEmail_Controller_constructor() {

        String profileName = 'System Administrator';
        Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
        insert testUser;

        System.runAs(testUser) {
            
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        
        Test.startTest();
        
        system.assert(ctrl.model != null);
        
        Test.stopTest();
        }
        
    }

    public static testMethod void test_CT_SendEmail_Controller_ButtonClickEventAttachNewFile() {
        String profileName = 'System Administrator';
        Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
        insert testUser;

        System.runAs(testUser) {
            
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        
        Test.startTest();
        
        system.assert(ctrl.model != null);
        ctrl.ButtonClickEventAttachNewFile();
        
        Test.stopTest();
        }
        
    }

    public static testMethod void test_CT_SendEmail_Controller_ButtonClickEventAttachSelectedExistingAttachments() {
        String profileName = 'System Administrator';
        Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
        insert testUser;

        System.runAs(testUser) {
            
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        
        Test.startTest();
        
        system.assert(ctrl.model != null);
        ctrl.ButtonClickEventAttachSelectedExistingAttachments();
        
        Test.stopTest();
        }
    }

    public static testMethod void test_CT_SendEmail_Controller_ButtonClickEventCancel() {
        String profileName = 'System Administrator';
        Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
        insert testUser;

        System.runAs(testUser) {
            
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        
        Test.startTest();
        
        system.assert(ctrl.model != null);
        Pagereference pr = ctrl.ButtonClickEventCancel();
        system.assert(pr != null);
        
        Test.stopTest();
        }
    }

    public static testMethod void test_CT_SendEmail_Controller_ButtonClickEventSendEmail_Positive(){
        String profileName = 'System Administrator';
        Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
        insert testUser;

        System.runAs(testUser) {
            
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        
        Test.startTest();
        
        system.assert(ctrl.model != null);
        ctrl.model.EmailTo = 'testuser20120203@cloudtrigger.com';
        Pagereference pr = ctrl.ButtonClickEventSendEmail();
        //system.assert(pr != null);
        
        Test.stopTest();
        }
    }

    public static testMethod void test_CT_SendEmail_Controller_ButtonClickEventSendEmail_Negative(){
        String profileName = 'System Administrator';
        Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
        insert testUser;

        System.runAs(testUser) {
            
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        
        Test.startTest();
        
        system.assert(ctrl.model != null);
        
        Pagereference pr = ctrl.ButtonClickEventSendEmail();
        
        
        Test.stopTest();
        }
    }

    public static testMethod void test_CT_SendEmail_Controller_EventEmailAdditionalToChanged() {
        String profileName = 'System Administrator';
        Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
        insert testUser;

        System.runAs(testUser) {
            
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        
        Test.startTest();
        
        system.assert(ctrl.model != null);
        ctrl.EventEmailAdditionalToChanged();
        
        Test.stopTest();
        }
        
    }

    public static testMethod void test_CT_SendEmail_Controller_EventEmailBccChanged() {
        String profileName = 'System Administrator';
        Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
        insert testUser;

        System.runAs(testUser) {
            
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        
        Test.startTest();
        
        system.assert(ctrl.model != null);
        ctrl.EventEmailBccChanged();
        
        Test.stopTest();
        }
    }

    public static testMethod void test_CT_SendEmail_Controller_EventEmailCcChanged() {
        String profileName = 'System Administrator';
        Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
        insert testUser;

        System.runAs(testUser) {
            
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        
        Test.startTest();
        
        system.assert(ctrl.model != null);
        ctrl.EventEmailCcChanged();
        
        Test.stopTest();
        }
    }

    public static testMethod void test_CT_SendEmail_Controller_EventEmailToChanged() {
        String profileName = 'System Administrator';
        Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
        insert testUser;

        System.runAs(testUser) {
            
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        
        Test.startTest();
        
        system.assert(ctrl.model != null);
        ctrl.EventEmailToChanged();
        
        Test.stopTest();
        }
    }

    public static testMethod void test_CT_SendEmail_Controller_GetEmailAttachmentSources() {
        String profileName = 'System Administrator';
        Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
        insert testUser;

        System.runAs(testUser) {
            
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        
        Test.startTest();
        
        system.assert(ctrl.model != null);
        list<SelectOption> options = ctrl.GetEmailAttachmentSources();
        system.assert(options != null);
        Test.stopTest();
        }
    }

    public static testMethod void test_CT_SendEmail_Controller_GetRecipientOptions() {
        String profileName = 'System Administrator';
        Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
        insert testUser;

        System.runAs(testUser) {
            
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        PageReference pageRef = Page.SendEmail;  // Instantiate SendEmail page
        Test.setCurrentPage(pageRef);
        
        // set the querystring 'id' value to the Contact's Id
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        //Instantiate and construct the controller class.
        CT_SendEmail_Controller ctrl = new CT_SendEmail_Controller();
        
        Test.startTest();
        
        system.assert(ctrl.model != null);
        list<SelectOption> options = ctrl.GetRecipientOptions();
        system.assert(options != null);
        Test.stopTest();
        }
    } */
}