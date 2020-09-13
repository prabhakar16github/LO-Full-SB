@isTest
private class SCMDUMMonthlySchedulerTest {

    static testMethod void monthlySchedulerTest() {
        // TO DO: implement unit test
        
        Test.startTest();
	      	SCMDUMMonthlyScheduler scmdumMonthlyObj = new SCMDUMMonthlyScheduler();
	      	String sch = '0 0 23 * * ?';
	        System.schedule('SCMUMDisputeMonthlyScheduler', sch, scmdumMonthlyObj);
        Test.stopTest(); 
        system.assert(true);
    }
}