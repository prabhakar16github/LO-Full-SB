global class CM_DataArchiveScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        database.executeBatch(new CM_DataArchiveBatch(),100);
    }

}