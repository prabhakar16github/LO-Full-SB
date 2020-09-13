/*
##########################################################################################################################################
# Project Name..........: LO -CT Test Class Re-Work
# File..................: Class : "CT_AttachmentWrapper"
# Version...............: 1.0
# Created by............: Sunny Kumar   
# Created Date..........: 26-Mar-2015
# Last Modified by......: Sunny Kumar
# Last Modified Date....: 26-Mar-2015                         
# Description...........: All CT_ Classes were failing due to OLD API and Badly Written their individual test Coverage. 
                          So, a re-work over test coverage has been done for all of them.
###########################################################################################################################################
*/


public with sharing class CT_AttachmentWrapper
{    
    @TestVisible
    private final String CLASSNAME = '\n\n**** CT_AttachmentWrapper.METHODNAME()';
    public Boolean selected{get;set;}
    public Attachment attach{get;set;}

    //@author : CloudTrigger, Inc.
    //@date : 1/25/2011
    //@description : static method to create a CT_AttachmentWrapper object
    //@paramaters : an Attachment
    //@returns : an instance of the CT_AttachmentWrapper class
    public static CT_AttachmentWrapper NewWrapper(Attachment pAttachment)
    {
        return new CT_AttachmentWrapper(pAttachment);
    }

    //@author : CloudTrigger, Inc.
    //@date : 1/25/2011
    //@description : static method to create a CT_AttachmentWrapper object
    //@paramaters : an Attachment
    //@returns : an instance of the CT_AttachmentWrapper class
    public static CT_AttachmentWrapper NewWrapper(Messaging.EmailFileAttachment pEFA)
    {
        return new CT_AttachmentWrapper(pEFA);
    }

    //@author : CloudTrigger, Inc.
    //@date : 1/25/2011
    //@description : static method to create a CT_AttachmentWrapper object
    //@paramaters : an Attachment ID
    //@returns : an instance of the CT_AttachmentWrapper class
    public static CT_AttachmentWrapper NewWrapper(String pAttachmentId)
    {
        return new CT_AttachmentWrapper(pAttachmentId);
    }
    
    //@author : CloudTrigger, Inc.
    //@date : 1/25/2011
    //@description : static method to create a list of CT_AttachmentWrapper objects from a list of Attachment objects
    //@paramaters : a list of Attachment objects
    //@returns : a list of CT_AttachmentWrapper objects
    public static list<CT_AttachmentWrapper> NewWrapperList(list<Attachment> pAttachmentList)
    {
        list<CT_AttachmentWrapper> newWrappers = new list<CT_AttachmentWrapper>();
        for(Attachment a:pAttachmentList){
            CT_AttachmentWrapper newWrapper = new CT_AttachmentWrapper(a);
            newWrappers.add(newWrapper);
        }

        return newWrappers;
    }
    
    //@author : CloudTrigger, Inc.
    //@date : 1/25/2011
    //@description : static method to create a list of CT_AttachmentWrapper objects from a map of Attachment objects
    //@paramaters : a map of Attachment objects
    //@returns : a list of CT_AttachmentWrapper objects
    public static list<CT_AttachmentWrapper> NewWrapperList(map<Id, Attachment> pAttachmentMap)
    {
        list<CT_AttachmentWrapper> newWrappers = new list<CT_AttachmentWrapper>();
        for(Attachment a:pAttachmentMap.values()){
            CT_AttachmentWrapper newWrapper = new CT_AttachmentWrapper(a);
            newWrappers.add(newWrapper);
        }

        return newWrappers;
    }

    //@author : CloudTrigger, Inc.
    //@date : 1/25/2011
    //@description : constructor method to create a CT_AttachmentWrapper object
    //@paramaters : an Messaging.EmailFileAttachment object
    //@returns : an instance of the CT_AttachmentWrapper class
    @TestVisible
    private CT_AttachmentWrapper(Messaging.EmailFileAttachment pEFA)
    {
        Attachment att = new Attachment ();
        att.Body = pEFA.getBody();
        att.Name = pEFA.getFileName();
        
        selected = false;
        attach = att;
    }

    //@author : CloudTrigger, Inc.
    //@date : 1/25/2011
    //@description : constructor method to create a CT_AttachmentWrapper object
    //@paramaters : an Attachment object
    //@returns : an instance of the CT_AttachmentWrapper class
    @TestVisible
    private CT_AttachmentWrapper(Attachment pAttachment)
    {
        selected = false;
        attach = pAttachment;
    }

    //@author : CloudTrigger, Inc.
    //@date : 1/25/2011
    //@description : constructor method to create a CT_AttachmentWrapper object
    //@paramaters : an Attachment ID
    //@returns : an instance of the CT_AttachmentWrapper class
    @TestVisible
    private CT_AttachmentWrapper(String pAttachmentId)
    {
        selected = false;
        attach = new Attachment();
        attach = [SELECT Id, Name FROM Attachment WHERE Id = :pAttachmentId];
    }

    //@author : CloudTrigger, Inc.
    //@date : 1/25/2011
    //@description : constructor method to create a CT_AttachmentWrapper object
    //@paramaters : an Attachment ID
    //@returns : an instance of the CT_AttachmentWrapper class
    @TestVisible
    private CT_AttachmentWrapper(Id pAttachmentId)
    {
        selected = false;
        attach = new Attachment();
        attach = [SELECT Id, Name FROM Attachment WHERE Id = :pAttachmentId];
    }

/*=======================================================================
*
*                           TEST METHODS
*
=======================================================================*/

  /*  public static testMethod void test_NewWrapper_Attachment() {
 
        Attachment attach = new Attachment();
        CT_AttachmentWrapper aw = CT_AttachmentWrapper.NewWrapper(attach);
        system.assert(aw != null);
        system.assertEquals(aw.selected,false);
 
    }
    public static testMethod void test_NewWrapper_String() {
 
        String profileName = 'System Administrator';
        Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
        insert testUser;
            
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        Attachment attach = new Attachment(Name = 'TEST ATTACHMENT'
                                            , Body = Blob.valueOf('TEST BODY')
                                            , ParentId = c.Id
                                            , OwnerId = testUser.Id
                                            , IsPrivate = false);
        insert attach;
        String attachId = attach.Id;
        CT_AttachmentWrapper aw = CT_AttachmentWrapper.NewWrapper(attachId);
        system.assert(aw != null);
        system.assertEquals(aw.selected,false);
 
    }
    public static testMethod void test_NewWrapper_EmailFileAttachment() {
 
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        CT_AttachmentWrapper aw = CT_AttachmentWrapper.NewWrapper(attach);
        system.assert(aw != null);
        system.assertEquals(aw.selected,false);
 
    }
    public static testMethod void test_NewWrapper_NewWrapperList() {
 
        String profileName = 'System Administrator';
        Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
        insert testUser;
            
        Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        Attachment attach1 = new Attachment(Name = 'TEST ATTACHMENT 1'
                                            , Body = Blob.valueOf('TEST BODY 1')
                                            , ParentId = c.Id
                                            , OwnerId = testUser.Id
                                            , IsPrivate = false);
        insert attach1;
        Attachment attach2 = new Attachment(Name = 'TEST ATTACHMENT 2'
                                            , Body = Blob.valueOf('TEST BODY 2')
                                            , ParentId = c.Id
                                            , OwnerId = testUser.Id
                                            , IsPrivate = false);
        insert attach2;
        
        list<Attachment> AttachmentList = new list<Attachment> ();
        AttachmentList.add(attach1);
        AttachmentList.add(attach2);
        list<CT_AttachmentWrapper> NewWrapperList = CT_AttachmentWrapper.NewWrapperList(AttachmentList);
        system.assert(NewWrapperList != null);
        system.assert(NewWrapperList.size()>1);
 
    } */
}