global class IR_InitialCommunicationScheduler implements Schedulable {

    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new IR_MonthlyInitialNotificationBatch(), 10);
    }
    
}