@isTest
private class MonthlyNotificationtoProfileUsersTest {

    static testMethod void MonthlyNotificationtoProfileUsersTest() {
        Test.startTest();
        User pam = new User();
        Datetime dt = Datetime.now().addMinutes(1);
        MonthlyNotificationtoProfileUsers sche = new MonthlyNotificationtoProfileUsers();
        String sch = '0 0 23 * * ?';
        String jobId = System.schedule('Sample_Heading',sch,sche);   
        MonthlyNotificationtoProfileUsers.scheduleit();
        Test.stopTest();
        
    }
}