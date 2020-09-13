/*
##########################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: class : "Test_LC_CreateFirmonBOX"
# Version...............: 1.0
# Created by............: 
# Created Date..........: 
# Last Modified by......:  
# Last Modified Date....: 
# Description...........: This class is used to test LC_CreateFirmonBOX code
# BOX Sequence..........: 
###############################################################################################################################################
*/

@isTest(seealldata=true)
private class Test_LC_CreateFirmonBOX {

    static testMethod void main(){
        
        list<Account> accList = new list<Account>();
        //list<Box_Folder_ID_Map__c> BoxFolderIDList =new list<Box_Folder_ID_Map__c>();
        
        accList = LC_TestDataUtility.createAccounts(1);
        
        system.assertEquals(1, accList.size());
        list<Box_Folder_ID_Map__c> BoxFolderIDList = [select id,Firm_ID__c from Box_Folder_ID_Map__c where Reference_ID__c =: accList[0].Id and Firm_ID__c =: accList[0].Firm_ID__c];
        //BoxFolderIDList = LC_TestDataUtility.createBoxFolderIDs(accList,'Organization',false);
        
        //system.assertEquals(1, BoxFolderIDList.size()); 
        
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        LC_CreateFirmonBOX.createFolder(BoxFolderIDList[0].id, BoxFolderIDList[0].Firm_ID__c);
         
        
    }
    
    static testMethod void main2(){
        list<Account> accList = new list<Account>();
        //list<Box_Folder_ID_Map__c> BoxFolderIDList = new list<Box_Folder_ID_Map__c>();
        
        accList = LC_TestDataUtility.createAccounts(1);
        
        system.assertEquals(1, accList.size());
        list<Box_Folder_ID_Map__c> BoxFolderIDList = [select id,Firm_ID__c from Box_Folder_ID_Map__c where Reference_ID__c =: accList[0].Id and Firm_ID__c =: accList[0].Firm_ID__c];
        //BoxFolderIDList = LC_TestDataUtility.createBoxFolderIDs(accList,'Organization',false);
        
        //system.assertEquals(1, BoxFolderIDList.size()); 
        
        Test.setMock(HttpCalloutMock.class, new MockHTTPforItemInUse());
        LC_CreateFirmonBOX.createFolder(BoxFolderIDList[0].id, BoxFolderIDList[0].Firm_ID__c);
    }
}