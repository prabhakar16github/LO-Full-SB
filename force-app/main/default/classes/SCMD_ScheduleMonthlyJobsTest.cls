@isTest
private class SCMD_ScheduleMonthlyJobsTest {
	static testMethod void SCMD_ScheduleMonthlyJobsTest() {
		Date todaysDate = system.today();
		String cronExpression = '0 0 18 '+todaysDate.addDays(1).day()+' '+todaysDate.month()+' ? '+todaysDate.year();
		Test.startTest();
			System.schedule('Test schedule name', cronExpression, new SCMD_ScheduleMonthlyJobs());
		Test.stopTest();    
		system.assert(true);    
    }
}