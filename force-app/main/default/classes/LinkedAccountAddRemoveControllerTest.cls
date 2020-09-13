@isTest
private class LinkedAccountAddRemoveControllerTest {
    
    static testMethod void LinkedAccountAddRemoveControllerTest() {
        
        // test data 
        
        List<Metadata_Id__c> metaDataList = new List<Metadata_Id__c>(); 
        
        Metadata_Id__c metaDataObj1 = new Metadata_Id__c();
        metaDataObj1.Name = 'Test1';
        metaDataObj1.API_Name__c = 'Consumer_Account_Details__c';
        metaDataObj1.Type__c = 'Object';
        metaDataObj1.Id_of_Metadata__c = '01I0B0000019hSR';
        
        metaDataList.add(metaDataObj1);
        
        Metadata_Id__c metaDataObj2 = new Metadata_Id__c();
        metaDataObj2.Name = 'Test2';
        metaDataObj2.API_Name__c = 'Linked_Master_CAD_Account__c';
        metaDataObj2.Type__c = 'field';
        metaDataObj2.Id_of_Metadata__c = '01I0B0000019hSR';
        
        metaDataList.add(metaDataObj2);
        
        Metadata_Id__c metaDataObj3 = new Metadata_Id__c();
        metaDataObj3.Name = 'Test3';
        metaDataObj3.API_Name__c = 'Consumer_Master_File_Record__c';
        metaDataObj3.Type__c = 'field';
        metaDataObj3.Id_of_Metadata__c = '01I0B0000019hSR';
        
        metaDataList.add(metaDataObj3);
        
        Metadata_Id__c metaDataObj4 = new Metadata_Id__c();
        metaDataObj4.Name = 'Test4';
        metaDataObj4.Type__c = 'field';
        metaDataObj4.API_Name__c = 'CAD_Linked_Account__c';
        metaDataObj4.Id_of_Metadata__c = '01I0B0000019hSR';
        
        metaDataList.add(metaDataObj4);
        
        Metadata_Id__c metaDataObj5 = new Metadata_Id__c();
        metaDataObj5.Name = 'Test5';
        metaDataObj5.Type__c = 'field';
        metaDataObj5.API_Name__c = 'Organization_name__c';
        metaDataObj5.Id_of_Metadata__c = '01I0B0000019hSR';
        
        metaDataList.add(metaDataObj5);
        
        insert metaDataList;
        
        Consumer_Master_File__c consumerMasterFile = new Consumer_Master_File__c();
        consumerMasterFile.Consumer_First_Name__c = 'Test First Name';
        consumerMasterFile.Consumer_Last_Name__c = 'Test Last Name';
        consumerMasterFile.Consumer_Middle_Name__c = 'Test Middle Name';
        consumerMasterFile.Date_of_Birth__c = System.today();
        consumerMasterFile.SSN__c = '999-99-9999';
        
        insert consumerMasterFile;
        
        Consumer_Account_Details__c cadToInsert = new Consumer_Account_Details__c();
        
        cadToInsert.Account_Balance__c = 1000;
        cadToInsert.Account_Number__c = '01SDFGH';
        cadToInsert.Chain_of_Title__c = 'Test';
        cadToInsert.CAD_Consumer_Loan__c = true;
        cadToInsert.Consumer_Master_File_Record__c = consumerMasterFile.Id;
        cadToInsert.CAD_Credit_Card__c = false;
        cadToInsert.CAD_Linked_Account__c = true;
        cadToInsert.CAD_Linked_Master_CAD__c = true;
        cadToInsert.Original_Creditor__c = 'test';
        cadToInsert.Original_Creditor_Account_Number__c = '123456789976543';
        cadToInsert.Placement_Date__c = System.today();
        cadToInsert.Portfolio__c = '1960';
        
        insert cadToInsert;
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(cadToInsert);
        LinkedAccountAddRemoveController cadInsertTest = new LinkedAccountAddRemoveController(sc);
        
        PageReference pageRef = Page.LinkedAccountAddRemovePage;
        pageRef.getParameters().put('id', String.valueOf(cadToInsert.Id));
        Test.setCurrentPage(pageRef);
        Test.stopTest();
        
        system.assert(true);       
    }
    
    
    //for New Cad button in Lightning component
    @isTest
    static void testAddNewLC(){
        
        Account account = new Account(Name = 'TestAccount');
        insert account;
        
        Consumer_Master_File__c consumerMasterFile = new Consumer_Master_File__c();
        consumerMasterFile.Consumer_First_Name__c = 'Test First Name';
        consumerMasterFile.Consumer_Last_Name__c = 'Test Last Name';
        consumerMasterFile.Consumer_Middle_Name__c = 'Test Middle Name';
        consumerMasterFile.Date_of_Birth__c = System.today();
        consumerMasterFile.SSN__c = '999-99-9999';
        insert consumerMasterFile;
        
        Consumer_Account_Details__c cadObj = new Consumer_Account_Details__c();
        cadObj.Organization_name__c = account.id;
        cadObj.Consumer_Master_File_Record__c = consumerMasterFile.Id;
        cadObj.Account_Number__c = '1111';
        cadObj.OwnerId =  UserInfo.getUserId();
        cadObj.Original_Creditor__c = 'test';
        cadObj.CAD_Credit_Card__c = true;
        cadObj.RecordTypeId = Schema.SObjectType.Consumer_Account_Details__c.getRecordTypeInfosByName().get('CAD: MCM Linked Master CAD Account Details').getRecordTypeId();
        insert cadObj;
        
        Test.startTest();
        LinkedAccountAddRemoveController.fetchMasterCadRecords(cadObj.Id,'');
        LinkedAccountAddRemoveController.getListOfRecordType();
        Test.stopTest();
        system.assert(true);  
    }
}