@isTest
private class Test_LC_DisplayFolderElementsWizardCntrl {

    static testMethod void testMethod_LC_DisplayFOlderElementsandWizardCntrl() {
        
        list<Account> accList = new list<Account>();
    list<Consumer_Inquiries__c> ciList = new list<Consumer_Inquiries__c>(); 
    
    accList = LC_TestDataUtility.createAccounts(1);
    system.assertEquals(1, accList.size());
      
    ciList = LC_TestDataUtility.createConsumerInquiries(accList);
    system.assertEquals(1, ciList.size());
        
        Apexpages.standardController sc = new Apexpages.standardController(ciList[0]);
    LC_DisplayFOlderElementsandWizardCntrl LC_DFEWC = new LC_DisplayFOlderElementsandWizardCntrl(sc);
    
    list<User> userList = new list<User>();
    userList = [Select u.UserType From User u where UserType != 'Standard' limit 1];
    if(!userList.isEmpty()){
      system.runAs(userList[0]){
        LC_DisplayFOlderElementsandWizardCntrl LC_DFEWC1 = new LC_DisplayFOlderElementsandWizardCntrl(sc);
      }
    }
    
    userList = new list<User>();
    userList = [Select u.UserType From User u where Profile.Name != 'System Administrator' limit 1];
    if(!userList.isEmpty()){
      system.runAs(userList[0]){
        LC_DisplayFOlderElementsandWizardCntrl LC_DFEWC2 = new LC_DisplayFOlderElementsandWizardCntrl(sc);
      }
    }

    }
}