/*
 * Class Name : IR_DM_MonthlyIntialScheduler
 * Developer : Shivangi Srivastava
 * Description : This scheduler class will run on 18th of every month for DM IR record type. 
 */
global class IR_DM_MonthlyIntialScheduler implements Schedulable  {
    global void execute(SchedulableContext sc){
        database.executeBatch(new IR_DM_MonthlyIntialNotificationBatch());
    }

}