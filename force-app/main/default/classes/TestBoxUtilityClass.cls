/*
##########################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: class : "TestBoxUtilityClass"
# Version...............: 1.0
# Created by............: 
# Created Date..........: 
# Last Modified by......:  
# Last Modified Date....: 
# Description...........: This class is used to test LC_Box_Utility code
# BOX Sequence..........:   
###############################################################################################################################################
*/

@isTest(seealldata=true)
public class TestBoxUtilityClass{   
    
    //This method will cover createFolder2 method in LC_Box_Utility class (success response)
    public static testMethod void TestCreateFolderSuccessResponse(){
        
        LC_Box_Utility pc =new LC_Box_Utility();
        
        list<Account> accList = new list<Account>();
        
        accList = LC_TestDataUtility.createAccounts(1);
        
        system.assertEquals(1, accList.size());
        list<Box_Folder_ID_Map__c> BoxFolderIDList = [select id,Firm_ID__c from Box_Folder_ID_Map__c where Reference_ID__c =: accList[0].Id];
        string a = 'test';
        string b = 'test3';
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       // LC_ScheduleConsumerInquiryCreation objScheduler = new LC_ScheduleConsumerInquiryCreation();
        SchedulableContext sc=null;
       // objScheduler.execute(sc);
        LC_Box_Utility.createFolder2(a,BoxFolderIDList[0].id,b);
        test.stopTest();
        
    }
    
    //This method will cover createFolder2 method in LC_Box_Utility class (failure response)
    public static testMethod void TestCreateFolderErrorResponse(){
        
        LC_Box_Utility pc =new LC_Box_Utility();
        
        list<Account> accList = new list<Account>();
        
        accList = LC_TestDataUtility.createAccounts(1);
        
        system.assertEquals(1, accList.size());
        list<Box_Folder_ID_Map__c> BoxFolderIDList = [select id,Firm_ID__c from Box_Folder_ID_Map__c where Reference_ID__c =: accList[0].Id];
        string a = 'test';
        string b = 'test3';
        
        test.startTest();       
        Test.setMock(HttpCalloutMock.class, new MockHTTPforItemInUse());
       // LC_ScheduleConsumerInquiryCreation objScheduler = new LC_ScheduleConsumerInquiryCreation();
        SchedulableContext sc=null;
       // objScheduler.execute(sc);
        LC_Box_Utility.createFolder2(a,BoxFolderIDList[0].id,b);
        test.stopTest();
        
    }
    
    //This method will cover the createFolder3 method in LC_Box_Utility class (success response)
    
    public static testMethod void TestCreateFolder3SuccessResponse(){
        
        LC_Box_Utility pc =new LC_Box_Utility();
        
        list<Account> accList = new list<Account>();
        
        accList = LC_TestDataUtility.createAccounts(1);
        string a = 'test';
        string b = 'test3';
        system.assertEquals(1, accList.size());
        list<Box_Folder_ID_Map__c> BoxFolderIDList = [select id,Firm_ID__c from Box_Folder_ID_Map__c where Reference_ID__c =: accList[0].Id];
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        //LC_ScheduleConsumerInquiryCreation objScheduler = new LC_ScheduleConsumerInquiryCreation();
        //SchedulableContext sc=null;
       // objScheduler.execute(sc);
        LC_Box_Utility LC_BU = new LC_Box_Utility();
        LC_Box_Utility.createFolder3(a,BoxFolderIDList[0].id,b);
        test.stopTest();
        
    }
    
    //This method will cover the createFolder3 method in LC_Box_Utility class (failure response)
    public static testMethod void TestCreateFolder3ErrorResponse(){
        
        LC_Box_Utility pc =new LC_Box_Utility();
        
        list<Account> accList = new list<Account>();
        
        accList = LC_TestDataUtility.createAccounts(1);
        
        system.assertEquals(1, accList.size());
        list<Box_Folder_ID_Map__c> BoxFolderIDList = [select id,Firm_ID__c from Box_Folder_ID_Map__c where Reference_ID__c =: accList[0].Id];
        string a = 'test';
        string b = 'test3';
        
        test.startTest();       
        Test.setMock(HttpCalloutMock.class, new MockHTTPforItemInUse());
        //LC_ScheduleConsumerInquiryCreation objScheduler = new LC_ScheduleConsumerInquiryCreation();
       // SchedulableContext sc=null;
       // objScheduler.execute(sc);
        LC_Box_Utility.createFolder3(a,BoxFolderIDList[0].id,b);
        test.stopTest();
        
    }
    
    //This method will cover createFolder method in LC_Box_Utility class
    public static testMethod void TestCreateFolderMethod(){
        
        LC_Box_Utility pc =new LC_Box_Utility();
        
        list<Account> accList = new list<Account>();
        //list<Box_Folder_ID_Map__c> BoxFolderIDList = new list<Box_Folder_ID_Map__c>();
        
        accList = LC_TestDataUtility.createAccounts(1);
        
        system.assertEquals(1, accList.size());
        
        //BoxFolderIDList = LC_TestDataUtility.createBoxFolderIDs(accList,'Consumer Inquiry',true);
        
        //system.assertEquals(1, BoxFolderIDList.size()); 
        list<Box_Folder_ID_Map__c> BoxFolderIDList = [select id,Firm_ID__c,Folder_ID__c from Box_Folder_ID_Map__c where Reference_ID__c =: accList[0].Id and Firm_ID__c =: accList[0].Firm_ID__c];
        test.startTest();       
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        LC_Box_Utility LC_BU = new LC_Box_Utility();
        LC_BU.createFolder(BoxFolderIDList[0].Folder_ID__c);
        test.stopTest();
        
    }
    
    //This method will cover searchFolder method in LC_Box_Utility class
    public static testMethod void TestSearchFolderMethod(){
        
        LC_Box_Utility pc =new LC_Box_Utility();
        
        list<Account> accList = new list<Account>();
        //list<Box_Folder_ID_Map__c> BoxFolderIDList = new list<Box_Folder_ID_Map__c>();
        
        accList = LC_TestDataUtility.createAccounts(2);
        
        system.assertEquals(2, accList.size());
        Set<Id> accIds = new Set<Id>();
        accIds.add(accList[0].id);
        accIds.add(accList[1].id);
        //BoxFolderIDList = LC_TestDataUtility.createBoxFolderIDs(accList,'Consumer Inquiry',true);
        
        //system.assertEquals(2, BoxFolderIDList.size()); 
        list<Box_Folder_ID_Map__c> BoxFolderIDList = [select id,Firm_ID__c,Folder_ID__c from Box_Folder_ID_Map__c where Reference_ID__c IN: accIds];
        BoxFolderIDList[0].Folder_ID__c = '0987654321';
        BoxFolderIDList[1].Folder_ID__c = '0987654321';
        test.startTest();       
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse_SearchFolder());
        LC_Box_Utility LC_BU = new LC_Box_Utility();
        LC_BU.SearchFolder(BoxFolderIDList[0].Folder_ID__c,BoxFolderIDList[1].Folder_ID__c);
        test.stopTest();
        
    }
    
    //This method will cover CopyFolderElements method in LC_Box_Utility class
    public static testMethod void TestCopyFolderElementsMethod(){
        
        LC_Box_Utility pc =new LC_Box_Utility();
        
        list<Account> accList = new list<Account>();
        //list<Box_Folder_ID_Map__c> BoxFolderIDList = new list<Box_Folder_ID_Map__c>();
        
        accList = LC_TestDataUtility.createAccounts(2);
        
        system.assertEquals(2, accList.size());
        Set<Id> accIds = new Set<Id>();
        accIds.add(accList[0].id);
        accIds.add(accList[1].id);
        //BoxFolderIDList = LC_TestDataUtility.createBoxFolderIDs(accList,'Consumer Inquiry',true);
        list<Box_Folder_ID_Map__c> BoxFolderIDList = [select id,Firm_ID__c,Folder_ID__c from Box_Folder_ID_Map__c where Reference_ID__c IN: accIds];
        BoxFolderIDList[0].Folder_ID__c = '0987654321';
        BoxFolderIDList[1].Folder_ID__c = '0987654321';
        //system.assertEquals(2, BoxFolderIDList.size()); 
        
        test.startTest();       
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse_SearchFolder());
        //LC_Box_Utility LC_BU = new LC_Box_Utility();
        LC_Box_Utility.CopyFolderElements(BoxFolderIDList[0].Folder_ID__c,BoxFolderIDList[1].Folder_ID__c,'Copy');
        test.stopTest();
        
    }
    
    //This method will cover changeParentIDS method in LC_Box_Utility class
    public static testMethod void TestchangeParentIDSMethod(){
        
        LC_Box_Utility pc =new LC_Box_Utility();
        
        list<Account> accList = new list<Account>();
        //list<Box_Folder_ID_Map__c> BoxFolderIDList = new list<Box_Folder_ID_Map__c>();
        
        accList = LC_TestDataUtility.createAccounts(2);
        
        system.assertEquals(2, accList.size());
        Set<Id> accIds = new Set<Id>();
        accIds.add(accList[0].id);
        accIds.add(accList[1].id);
        
        //BoxFolderIDList = LC_TestDataUtility.createBoxFolderIDs(accList,'Consumer Inquiry',true);
        
        list<Box_Folder_ID_Map__c> BoxFolderIDList = [select id,Firm_ID__c,Folder_ID__c from Box_Folder_ID_Map__c where Reference_ID__c IN: accIds];
        BoxFolderIDList[0].Folder_ID__c = '0987654321';
        BoxFolderIDList[1].Folder_ID__c = '0987654321';
        
        //system.assertEquals(2, BoxFolderIDList.size()); 

        test.startTest();       
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse_SearchFolder());
        //LC_Box_Utility LC_BU = new LC_Box_Utility();
        LC_Box_Utility.changeParentIDS(BoxFolderIDList[0].Folder_ID__c,BoxFolderIDList[1].Folder_ID__c,'test access token');
        test.stopTest();
        
    }
    
    //This method will cover changeFolderDestination method in LC_Box_Utility class
    public static testMethod void TestchangeFolderDestinationMethod(){
        
        LC_Box_Utility pc =new LC_Box_Utility();
        
        list<Account> accList = new list<Account>();
        //list<Box_Folder_ID_Map__c> BoxFolderIDList = new list<Box_Folder_ID_Map__c>();
        
        accList = LC_TestDataUtility.createAccounts(2);
        
        system.assertEquals(2, accList.size());
        Set<Id> accIds = new Set<Id>();
        accIds.add(accList[0].id);
        accIds.add(accList[1].id);
        //BoxFolderIDList = LC_TestDataUtility.createBoxFolderIDs(accList,'Consumer Inquiry',true);
        
        //system.assertEquals(2, BoxFolderIDList.size()); 
        
        list<Box_Folder_ID_Map__c> BoxFolderIDList = [select id,Firm_ID__c,Folder_ID__c from Box_Folder_ID_Map__c where Reference_ID__c IN: accIds];
        BoxFolderIDList[0].Folder_ID__c = '0987654321';
        BoxFolderIDList[1].Folder_ID__c = '0987654321';
        
        test.startTest();       
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse_SearchFolder());
        //LC_Box_Utility LC_BU = new LC_Box_Utility();
        LC_Box_Utility.changeFolderDestination(BoxFolderIDList[0].Folder_ID__c,BoxFolderIDList[1].Folder_ID__c);
        test.stopTest();
        
    }
    
    //This method will cover DeleteParentIDS method in LC_Box_Utility class
    public static testMethod void TestDeleteParentIDSMethod(){
        
        LC_Box_Utility pc =new LC_Box_Utility();
        
        list<Account> accList = new list<Account>();
        //list<Box_Folder_ID_Map__c> BoxFolderIDList = new list<Box_Folder_ID_Map__c>();
        
        accList = LC_TestDataUtility.createAccounts(2);
        
        system.assertEquals(2, accList.size());
        
        Set<Id> accIds = new Set<Id>();
        accIds.add(accList[0].id);
        accIds.add(accList[1].id);
        //BoxFolderIDList = LC_TestDataUtility.createBoxFolderIDs(accList,'Consumer Inquiry',true);
        
        list<Box_Folder_ID_Map__c> BoxFolderIDList = [select id,Firm_ID__c,Folder_ID__c from Box_Folder_ID_Map__c where Reference_ID__c IN: accIds];
        BoxFolderIDList[0].Folder_ID__c = '0987654321';
        BoxFolderIDList[1].Folder_ID__c = '0987654321';
        
        //BoxFolderIDList = LC_TestDataUtility.createBoxFolderIDs(accList,'Consumer Inquiry',true);
        
        //system.assertEquals(2, BoxFolderIDList.size()); 
        test.startTest();       
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse_SearchFolder());
        //LC_Box_Utility LC_BU = new LC_Box_Utility();
        LC_Box_Utility.DeleteParentIDS(BoxFolderIDList[0].Folder_ID__c,BoxFolderIDList[1].Folder_ID__c,'test access token');
        test.stopTest();
        
    }
    
    //This method will cover CollabirateFolder method in LC_Box_Utility class
    public static testMethod void TestCollabirateFolderMethod(){
        
        LC_Box_Utility pc =new LC_Box_Utility();
        
        list<Account> accList = new list<Account>();
        //list<Box_Folder_ID_Map__c> BoxFolderIDList = new list<Box_Folder_ID_Map__c>();
        
        accList = LC_TestDataUtility.createAccounts(1);
        
        system.assertEquals(1, accList.size());
        
        //BoxFolderIDList = LC_TestDataUtility.createBoxFolderIDs(accList,'Consumer Inquiry',true);
        
        //system.assertEquals(1, BoxFolderIDList.size()); 
        list<Box_Folder_ID_Map__c> BoxFolderIDList = [select id,Firm_ID__c,Folder_ID__c from Box_Folder_ID_Map__c where Reference_ID__c =: accList[0].Id and Firm_ID__c =: accList[0].Firm_ID__c];
        test.startTest();       
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse_SearchFolder());
        //LC_Box_Utility LC_BU = new LC_Box_Utility();
        LC_Box_Utility.CollabirateFolder(BoxFolderIDList[0].Folder_ID__c,'test access token');
        test.stopTest();
        
    }
    
    //This method will cover ChangeFileName method in LC_Box_Utility class
    public static testMethod void TestChangeFileNameMethod(){
        
        LC_Box_Utility pc =new LC_Box_Utility();
        
        list<Account> accList = new list<Account>();
        //list<Box_Folder_ID_Map__c> BoxFolderIDList = new list<Box_Folder_ID_Map__c>();
        
        accList = LC_TestDataUtility.createAccounts(1);
        
        system.assertEquals(1, accList.size());
        
        //BoxFolderIDList = LC_TestDataUtility.createBoxFolderIDs(accList,'Consumer Inquiry',true);
        
        //system.assertEquals(1, BoxFolderIDList.size()); 
        list<Box_Folder_ID_Map__c> BoxFolderIDList = [select id,Firm_ID__c,Folder_ID__c from Box_Folder_ID_Map__c where Reference_ID__c =: accList[0].Id and Firm_ID__c =: accList[0].Firm_ID__c];
        test.startTest();       
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse_SearchFolder());
        //LC_Box_Utility LC_BU = new LC_Box_Utility();
        LC_Box_Utility.ChangeFileName(BoxFolderIDList[0].Folder_ID__c,'test file name');
        test.stopTest();
        
    }
}