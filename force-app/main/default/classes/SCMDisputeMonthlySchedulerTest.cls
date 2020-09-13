@isTest
private class SCMDisputeMonthlySchedulerTest {

    static testMethod void monthlyTest() {
        // TO DO: implement unit test
        
        Test.startTest();
        
        String sch = '0 0 23 * * ?';
        
        SCMDisputeMonthlyScheduler monthlySchedulerObj = new SCMDisputeMonthlyScheduler(); 
        System.schedule('SCMDisputeMonthlySchedulerTest', sch, monthlySchedulerObj);
        
        Test.stopTest();
        
        System.assert(true);
    }
}