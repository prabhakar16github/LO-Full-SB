global class IRUM_ACF_FinalEscalationScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        Database.executeBatch(new IRUM_ACF_FinalEscalationBatch());
    }

}