global class IRUM_ACF_FirstEscalationScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        Database.executeBatch(new IRUM_ACF_FirstEscalationBatch());
    }
}