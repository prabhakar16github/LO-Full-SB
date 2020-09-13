global class IR_ACF_NoReponseScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        Database.executeBatch(new IR_ACF_MonthlyNoResponseBatch());
    }

}