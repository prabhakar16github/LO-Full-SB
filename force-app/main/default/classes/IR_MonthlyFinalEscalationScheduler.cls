global class IR_MonthlyFinalEscalationScheduler implements Schedulable {

    global void execute(SchedulableContext ctx) {
    	
    	Date todaysDate = System.today();
    	String month = String.valueOf(todaysDate.month());
        
        if(month.length() == 1){
        	month = '0' + month; // format month
        }
        String reportingPeriod = todaysDate.year() +'-'+ month;
        Database.executeBatch(new IR_MonthlyFinalEscalation(reportingPeriod), 10);
    }
    
}