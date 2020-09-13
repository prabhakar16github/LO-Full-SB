global class IR_DataArchive_Scheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        Database.executeBatch(new IR_DataArchiveBatch(), 100);
    }

}