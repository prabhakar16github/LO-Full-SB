/*
 * Class Name : IR_DM_FinalEscalationScheduler
 * Developer : Shivangi Srivastava
 * Description : This scheduler class will run for three consecutive days after 28th for DM IR record type.
 */
global class IR_DM_FinalEscalationScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        Database.executeBatch(new IR_DM_MonthlyFinalEscalationBatch());
    }
}