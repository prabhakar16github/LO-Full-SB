global class IR_ACF_FinalScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        Database.executeBatch(new IR_ACF_MonthlyFinalEscalationBatch());
    }
}