global class IRUM_ACF_NoResponseScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        Database.executeBatch(new IRUM_ACF_NoResponseBatch());
    }
}