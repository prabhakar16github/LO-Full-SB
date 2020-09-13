global class IR_DayBeforeCutOffScheduler implements Schedulable {

    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new IR_MonthlyDayBeforeCutOff(), 10);
    }
    
}