public with sharing class CT_SendEmailOverride
{
    public CT_SendEmailOverride(ApexPages.StandardController controller)
    {}
    
    public PageReference redirect() 
    {
        PageReference customPage;
        String sobjectId = ApexPages.currentPage().getParameters().get('id');
        customPage = Page.SendEmail;
        customPage.setRedirect(true);
        customPage.getParameters().put('id', sobjectId);
        return customPage;
    }
 /*
    public static testMethod void test_CT_SendEmailOverride_constructor() {
        ApexPages.StandardController controller = new ApexPages.StandardController(new Account(name='TEST ACCOUNT'));
        CT_SendEmailOverride attach = new CT_SendEmailOverride(controller);
        system.assert(attach != null);
    }

   public static testMethod void test_CT_SendEmailOverride_redirect() {
        ApexPages.StandardController controller = new ApexPages.StandardController(new Account(name='TEST ACCOUNT'));
        CT_SendEmailOverride attach = new CT_SendEmailOverride(controller);
        PageReference pr = attach.redirect();
        system.assert(pr != null);
    }*/

}