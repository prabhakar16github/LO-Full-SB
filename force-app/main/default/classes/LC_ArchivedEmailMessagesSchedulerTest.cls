@isTest
private class LC_ArchivedEmailMessagesSchedulerTest {

    static testMethod void LC_ArchivedEmailMessagesSchedulerTest(){
        Test.startTest();
        LC_ArchivedCaseEmailMessagesScheduler objScheduler = new LC_ArchivedCaseEmailMessagesScheduler();             
        SchedulableContext sc=null;
        objScheduler.execute(sc); 
       
        Test.stopTest();
}
}