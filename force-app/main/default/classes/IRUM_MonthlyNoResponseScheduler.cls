global class IRUM_MonthlyNoResponseScheduler implements Schedulable {

    global void execute(SchedulableContext ctx) {
    	
    	Date todaysDate = System.today().addDays(-1);
    	String month = String.valueOf(todaysDate.month());
        
        if(month.length() == 1){
        	month = '0' + month; // format month
        }
        String reportingPeriod = todaysDate.year() +'-'+ month;
        Database.executeBatch(new IRUM_MonthlyNoResponseBatch(reportingPeriod), 10);
    }
    
}