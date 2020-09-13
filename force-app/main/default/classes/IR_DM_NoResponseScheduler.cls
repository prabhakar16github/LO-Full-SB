/*
 * Class Name : IR_DM_NoResponseScheduler
 * Developer : Shivangi Srivastava
 * Description : This scheduler class will for the 4th day of 28th of each month.
*/
global class IR_DM_NoResponseScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        Database.executeBatch(new IR_DM_MonthlyNoResponseBatch());
    }
}