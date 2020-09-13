@isTest(seealldata=true)
private class Test_LC_SendAttachmentsWSDL {

    static testMethod void myUnitTest() {
        
        list<Account> accList = new list<Account>();
        list<Case> caseList = new list<Case>();
    list<Consumer_Inquiries__c> ciList = new list<Consumer_Inquiries__c>(); 
    list<Attachment> AttachmentList = new list<Attachment>();
    list<Box_Folder_ID_Map__c> BoxFolderIDList = new list<Box_Folder_ID_Map__c>();
    
    accList = LC_TestDataUtility.createAccounts(1);
    caseList = LC_TestDataUtility.createCases(1);
    
    system.assertEquals(1, accList.size());
    system.assertEquals(1, caseList.size());
      
    ciList = LC_TestDataUtility.createConsumerInquiries(accList);
    BoxFolderIDList = LC_TestDataUtility.createCIBoxFolderIDs(ciList,'Consumer Inquiry',true);
    
    system.assertEquals(1, ciList.size());
    system.assertEquals(1, BoxFolderIDList.size());
    
    Firm_Dates__c fd = new Firm_Dates__c();
    fd.Box_Folder_ID_Map__c = BoxFolderIDList[0].id;
    fd.Folder_ID__c = '098766542';
    insert fd;
    //list<Firm_s_Child__c> fcList = [select Reference_ID__c from Firm_s_Child__c where Box_Folder_ID__c != null and Type__c = 'Consumer Inquiry' and Reference_ID__c != null];
    
    Firm_s_Child__c fc = new Firm_s_Child__c();
    fc.Box_Folder_ID__c = '237126786';
    fc.Case_Reference__c = caseList[0].id;
    fc.Consumer_Inquiries_Reference__c = ciList[0].id;
    fc.Firm_Date__c = fd.id;
    fc.Reference_ID__c =ciList[0].id;
    fc.Type__c = 'Consumer Inquiry';
    insert fc;
    
    set<Id> parentIds = new set<Id>();
    parentIds.add(ciList[0].Id);
    parentIds.add(caseList[0].Id);
    AttachmentList = LC_TestDataUtility.createAttachments(parentIds);
        
    LC_SendAttachmentsWSDL LC_SAWSDL = new LC_SendAttachmentsWSDL();
    
    LC_SendAttachmentsWSDL.Build('Historical');
    LC_SendAttachmentsWSDL.Build('DaytoDay');
    LC_SendAttachmentsWSDL.SendAttachments();

    }
}