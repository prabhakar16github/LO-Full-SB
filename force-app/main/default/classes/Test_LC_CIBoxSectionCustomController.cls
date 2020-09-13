/*
##########################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: class : "Test_LC_CIBoxSectionCustomController"
# Version...............: 1.0
# Created by............: 
# Created Date..........: 
# Last Modified by......:  
# Last Modified Date....: 
# Description...........: This class is used to test LC_CIBoxSectionCustomController code
# BOX Sequence..........: 
###############################################################################################################################################
*/

@isTest(SeeAllData= true)
private class Test_LC_CIBoxSectionCustomController {

    static testMethod void testMe_LC_CIBoxSectionCustomController() {
        
        list<Account> accList = new list<Account>();
        list<Consumer_Inquiries__c> ciList = new list<Consumer_Inquiries__c>(); 
        //list<Box_Folder_ID_Map__c> BoxFolderIDList = new list<Box_Folder_ID_Map__c>();
        
        accList = LC_TestDataUtility.createAccounts(1);
        
        system.assertEquals(1, accList.size());
            
        ciList = LC_TestDataUtility.createConsumerInquiries(accList);
        //BoxFolderIDList = LC_TestDataUtility.createBoxFolderIDs(accList,'Consumer Inquiry',true);
        
        system.assertEquals(1, ciList.size());
        //system.assertEquals(1, BoxFolderIDList.size()); 
                
        test.startTest();
        Apexpages.currentPage().getParameters().put('ID',accList[0].Id);
        Test.setMock(HttpCalloutMock.class, new Test_MockHttpResGen_CIBoxSection());
        Apexpages.standardController sc = new Apexpages.standardController(ciList[0]);
        LC_CIBoxSectionCustomController LC_CIBSCC = new LC_CIBoxSectionCustomController(sc);
        test.stopTest();
        

    }
}