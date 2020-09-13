/*
##########################################################################################################################################
# Project Name..........: LO - CT Test Class Re-Work
# File..................: Class : "CT_EmailTemplateWrapper"
# Version...............: 1.0
# Created by............: Sunny Kumar   
# Created Date..........: 26-Mar-2015
# Last Modified by......: Sunny Kumar
# Last Modified Date....: 26-Mar-2015                         
# Description...........: All CT_ Classes were failing due to OLD API and Badly Written their individual test Coverage. 
                          So, a re-work over test coverage has been done for all of them.
###########################################################################################################################################
*/


public with sharing class CT_EmailTemplateWrapper
{
    private final String CLASSNAME = '\n\n**** CT_EmailTemplateWrapper.METHODNAME()';
    public Boolean selected{get;set;}
    public EmailTemplate template{get;set;}

    //@author : CloudTrigger, Inc.
    //@date : 1/25/2011
    //@description : static method to create a CT_EmailTemplateWrapper object
    //@paramaters : an EmailTemplate
    //@returns : an instance of the CT_EmailTemplateWrapper class
    public static CT_EmailTemplateWrapper NewWrapper(EmailTemplate pEmailTemplate)
    {
        return new CT_EmailTemplateWrapper(pEmailTemplate);
    }
    
    //@author : CloudTrigger, Inc.
    //@date : 1/25/2011
    //@description : static method to create a list of CT_AttachmentWrapper objects from a list of Attachment objects
    //@paramaters : a list of Attachment objects
    //@returns : a list of CT_AttachmentWrapper objects
    public static list<CT_EmailTemplateWrapper> NewWrapperList(map<Id, EmailTemplate> pEmailTemplateMap)
    {
        list<CT_EmailTemplateWrapper> newWrappers = new list<CT_EmailTemplateWrapper>();
        for(EmailTemplate a:pEmailTemplateMap.values()){
            CT_EmailTemplateWrapper newWrapper = new CT_EmailTemplateWrapper(a);
            newWrappers.add(newWrapper);
        }

        return newWrappers;
    }

    //@author : CloudTrigger, Inc.
    //@date : 1/25/2011
    //@description : constructor method to create a CT_EmailTemplateWrapper object
    //@paramaters : an EmailTemplate object
    //@returns : an instance of the CT_EmailTemplateWrapper class
    private CT_EmailTemplateWrapper(EmailTemplate pEmailTemplate)
    {
        selected = false;
        template = pEmailTemplate;
    }


    /*public static testMethod void test_NewWrapper_Attachment() {
 
        EmailTemplate et = new EmailTemplate();
        CT_EmailTemplateWrapper aw = CT_EmailTemplateWrapper.NewWrapper(et);
        system.assert(aw != null);
        system.assertEquals(aw.selected,false);
 
    }*/
}