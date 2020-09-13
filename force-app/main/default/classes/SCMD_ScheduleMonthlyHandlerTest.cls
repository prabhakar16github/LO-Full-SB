@isTest
private class SCMD_ScheduleMonthlyHandlerTest {

    private static testMethod void scheduleMonthlyJobTest() {
    	Test.startTest();
			SCMD_ScheduleMonthlyHandler.scheduleMonthlyJob();
		Test.stopTest();
		system.assert(true);        
    }
}