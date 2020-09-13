@isTest(SeeAllData= true)
private class Test_LC_ScheduleBOXFolderCreation {
    static testMethod void myUnitTest(){
        Integer a = LC_CreateBOXFoldersNew.createFirmBoxFolder();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        LC_ScheduleBOXFolderCreation objScheduler = new LC_ScheduleBOXFolderCreation();
        SchedulableContext sc=null;
        objScheduler.execute(sc);
        
      //  LC_ScheduleBOXFolderCreation objScheduler1 = new LC_ScheduleBOXFolderCreation();
       // objScheduler1.execute(sc);   
        Test.stopTest();
    }
}