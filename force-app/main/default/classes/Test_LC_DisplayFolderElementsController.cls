@isTest(seealldata=true)
private class Test_LC_DisplayFolderElementsController{
     static testMethod void myUnitTest(){
        List<Account> accList = new list<Account>();
        Account a = new Account();
        a.Name = 'TestAcc';
        a.Firm_ID__c = 'Test';
        insert a;
        accList.add(a);
        
        list<Attachment> AttachmentList = new list<Attachment>();
        list<Consumer_Inquiries__c> ciList = new list<Consumer_Inquiries__c>();
        
        ciList = LC_TestDataUtility.createConsumerInquiries(accList);
        system.assertEquals(1, ciList.size());

        
        List<Firm_s_Child__c> fcList1 = [select Id, Name, Box_Folder_ID__c from Firm_s_Child__c Where Reference_ID__c =: ciList[0].id and Type__c = 'Consumer Inquiry'];
        system.debug('list value------->' +fcList1);
        set<Id> parentIds = new set<Id>();
        parentIds.add(ciList[0].Id);
        AttachmentList = LC_TestDataUtility.createAttachments(parentIds);
        system.debug('consumer inquiry value-->'+ciList);
        system.debug('Attchments value-->'+AttachmentList);
        
        Test.startTest();
        Apexpages.currentPage().getParameters().put('ID',ciList[0].Id);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Apexpages.standardController sc = new Apexpages.standardController(fcList1[0]);
        
        LC_DisplayFolderElementsController obj = new LC_DisplayFolderElementsController(sc);
        obj.displayFolderElements(fcList1[0].Box_Folder_ID__c);
        LC_DisplayFolderElementsController.displayAttachments obj1 = new LC_DisplayFolderElementsController.displayAttachments();
        LC_DisplayFolderElementsController.captureFileElements obj2 = new LC_DisplayFolderElementsController.captureFileElements();
        LC_DisplayFolderElementsController.FileEntries obj3 = new LC_DisplayFolderElementsController.FileEntries();
        LC_DisplayFolderElementsController.orders obj4 = new LC_DisplayFolderElementsController.orders();
        LC_DisplayFolderElementsController.displayAttachments obj5 = new LC_DisplayFolderElementsController.displayAttachments();
        Test.stopTest();
     }
}