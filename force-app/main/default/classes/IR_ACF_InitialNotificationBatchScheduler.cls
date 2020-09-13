global class IR_ACF_InitialNotificationBatchScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        Database.executeBatch(new IR_ACF_MonthlyInitialNotificationBatch());
    }
}