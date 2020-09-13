/*
 * Class Name : IR_DM_RecordCreationScheduler
 * Developer : Shivangi Srivastava
 * Description : This scheduler class will run on 24th of every month for DM IR record type. 
 */
global class IR_DM_RecordCreationScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        database.executeBatch(new IR_DM_MonthlyRecordCreationBatch());
    }
}