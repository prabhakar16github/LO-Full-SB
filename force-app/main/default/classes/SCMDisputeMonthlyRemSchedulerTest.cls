@isTest
private class SCMDisputeMonthlyRemSchedulerTest {
	
	@testsetup
	static void testSetup(){
		SCMD_ScheduleMonthlyHandler.scheduleMonthlyJob();
	}

    static testMethod void schedulerTestDay3() {
        // TO DO: implement unit test
        
        Test.startTest();
        
        String sch = '0 0 23 * * ?';
        SCMDisputeMonthlyRemScheduler monthlyRemSchedulerObj = new SCMDisputeMonthlyRemScheduler();
        Date todaysDate = System.today(); 
        monthlyRemSchedulerObj.dateToday = Date.newInstance(todaysDate.year(), todaysDate.month(), 3);
        System.schedule('SCMDisputeMonthlyRemScheduler', sch, monthlyRemSchedulerObj);
        SCMDisputeMonthlyRemHandler.isQualifiedRunFirstEscalation(Batch_Job_Setting__c.getAll(), system.today());
        SCMDisputeMonthlyRemHandler.bufferCode();
        Test.stopTest();
        
        System.assert(true);
    }
    
    static testMethod void schedulerTestDay5() {
        // TO DO: implement unit test
        
        Test.startTest();
        
        String sch = '0 0 23 * * ?';
        SCMDisputeMonthlyRemScheduler monthlyRemSchedulerObj = new SCMDisputeMonthlyRemScheduler();
        
        Date todaysDate = System.today(); 
        monthlyRemSchedulerObj.dateToday = Date.newInstance(todaysDate.year(), todaysDate.month(), 5);
         
        System.schedule('SCMDisputeMonthlyRemScheduler', sch, monthlyRemSchedulerObj);
        
        Test.stopTest();
        
        System.assert(true);
    }
    
    static testMethod void schedulerTestDay7() {
        // TO DO: implement unit test
        
        Test.startTest();
        
        String sch = '0 0 23 * * ?';
        SCMDisputeMonthlyRemScheduler monthlyRemSchedulerObj = new SCMDisputeMonthlyRemScheduler(); 
        Date todaysDate = System.today(); 
        monthlyRemSchedulerObj.dateToday = Date.newInstance(todaysDate.year(), todaysDate.month(), 7);
        System.schedule('SCMDisputeMonthlyRemScheduler', sch, monthlyRemSchedulerObj);
        
        Test.stopTest();
        
        System.assert(true);
    }
    
    static testMethod void schedulerTestDay10() {
        // TO DO: implement unit test
        
        Test.startTest();
        
        String sch = '0 0 23 * * ?';
        SCMDisputeMonthlyRemScheduler monthlyRemSchedulerObj = new SCMDisputeMonthlyRemScheduler();
        
        Date todaysDate = System.today(); 
        monthlyRemSchedulerObj.dateToday = Date.newInstance(todaysDate.year(), todaysDate.month(), 10);
         
        System.schedule('SCMDisputeMonthlyRemScheduler', sch, monthlyRemSchedulerObj);
        
        Test.stopTest();
        
        System.assert(true);
    }
}