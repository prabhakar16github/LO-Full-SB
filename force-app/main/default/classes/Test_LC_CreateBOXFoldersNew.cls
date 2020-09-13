@isTest(SeeAllData=true)
private class Test_LC_CreateBOXFoldersNew{
    static testMethod void myUnitTest(){
        list<Account> accList = new list<Account>();
        list<Consumer_Inquiries__c> ciList = new list<Consumer_Inquiries__c>();
        list<Case> caseList = new list<Case>(); 
        //list<Box_Folder_ID_Map__c> BoxFolderIDList = new list<Box_Folder_ID_Map__c>();
        
         accList = LC_TestDataUtility.createAccounts(1);
      //  accList = [select id, Name, Firm_ID__c from Account limit 1];
        caseList = LC_TestDataUtility.createCases(1);
        system.assertEquals(1, accList.size());
        system.assertEquals(1, caseList.size());
         
        ciList = LC_TestDataUtility.createConsumerInquiries(accList);
        list<Box_Folder_ID_Map__c> BoxFolderIDList = [select id,Firm_ID__c from Box_Folder_ID_Map__c where Reference_ID__c =: accList[0].Id and Type__c = 'Account' and Actual_Firm__c =: accList[0].id];
        system.debug('BOX Folder ID Map Value --->'+BoxFolderIDList);
        BoxFolderIDList = LC_TestDataUtility.createCIBoxFolderIDs(ciList,'Consumer Inquiry',true);
         
        system.assertEquals(1, ciList.size());
        system.assertEquals(1, BoxFolderIDList.size());
        
        Firm_Dates__c fd = new Firm_Dates__c();
        fd.Box_Folder_ID_Map__c = BoxFolderIDList[0].id;
        fd.Folder_ID__c = '0123456789';
        fd.Name__c = 'test';
        insert fd;
        
        Firm_s_Child__c fc = new Firm_s_Child__c();
        fc.Firm_Date__c = fd.id;
        fc.Box_Folder_ID__c = '09875432587';
        fc.Case_Reference__c = caseList[0].id;
        fc.Consumer_Inquiries_Reference__c = ciList[0].id;
        fc.Box_CI_Case_Name__c = 'testname';
        fc.Reference_ID__c = caseList[0].id;
        fc.Type__c = 'Case';
        insert fc;
        
        /* This will also covered test coverage for "LC_DeleteArchivedEmailMessage	" Trigger through below lines
        
        Added on 19-05-2015 By Sunny Kumar 
        
        for Data Strorage Automation Process*/
       
        Processed_Archived_Case_Email_Message__c pa = new Processed_Archived_Case_Email_Message__c();
        pa.Email_Message_Reference_Id__c =[select id from EmailMessage limit 1].id;
        pa.Firm_s_Child__c = fc.id;
        insert pa;
        
        // Modified Above code by Sunny Kumar on 19-05-2015....
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        LC_CreateBOXFoldersNew obj = new LC_CreateBOXFoldersNew();
        LC_CreateBOXFoldersNew.createFirmBoxFolder(); 
       // LC_CreateBOXFoldersNew.createFirmDatesBoxFolder();
       // LC_CreateBOXFoldersNew.createCIBoxFolder();
        
        // Not Needed..
       /* LC_CreateBOXFoldersNew.createCaseBoxFolder();
        LC_CreateBOXFoldersNew.createCaseEmailMessagesBoxFolder();*/
    }
}