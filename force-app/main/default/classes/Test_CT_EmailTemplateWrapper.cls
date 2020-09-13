@isTest
public class Test_CT_EmailTemplateWrapper{
    public static testMethod void test_NewWrapper_Attachment() {
 
        EmailTemplate et = new EmailTemplate();
        Map<Id, EmailTemplate> testmap = new Map<Id, EmailTemplate>();
       // CT_EmailTemplateWrapper obj = new CT_EmailTemplateWrapper();
        CT_EmailTemplateWrapper aw = CT_EmailTemplateWrapper.NewWrapper(et); 
        CT_EmailTemplateWrapper.NewWrapperList(testMap);
        system.assert(aw != null);
        system.assertEquals(aw.selected,false);
 
    }
}