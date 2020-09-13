global class IR_ACF_RecordCreationScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new IR_ACF_MonthlyRecordCreationBatch());
    }
}