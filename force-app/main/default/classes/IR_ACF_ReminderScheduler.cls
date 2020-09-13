global class IR_ACF_ReminderScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        Date today_date;
        if(!test.isRunningTest())
            today_date = System.today();
        else
            today_date = Date.newInstance(System.today().year(),System.today().month() , 28);
        
        Database.executeBatch(new IR_ACF_MonthlyReminderBatch());
        
        if(today_date.day() == 28) // runs only when batch running for 28th day.
            schedulerBatches(today_date);
    }
    public static void schedulerBatches(Date acfDate){// for 3 consecutive days and for 4th day after 28th
        
        Date dayOne = acfDate.addDays(1);
        Date dayTwo = acfDate.addDays(2);
        Date dayThree = acfDate.addDays(3);
        Date dayFour = acfDate.addDays(4);
        
        String finalEscalationCronExpresionDayOne = '0 0 0 ' + dayOne.day() + ' * ' + ' ? ' + dayOne.year();
        String finalEscalationCronExpresionDayTwo = '0 0 0 ' + dayTwo.day() + ' * ' + ' ? ' + dayOne.year();
        String finalEscalationCronExpresionDayThree = '0 0 0 ' + dayThree.day() + ' * ' + ' ? ' + dayOne.year();
        String finalEscalationCronExpresionDayFour = '0 0 0 ' + dayFour.day() + ' * ' + ' ? ' + dayOne.year();
        
        IR_ACF_FinalScheduler monthlyEscalationJob = new IR_ACF_FinalScheduler();
        IR_ACF_NoReponseScheduler noResponseJob = new IR_ACF_NoReponseScheduler(); 
        
        system.schedule('Day 1 Escalation (1st day after 28th)'+System.today(), finalEscalationCronExpresionDayOne, monthlyEscalationJob);
        system.schedule('Day 2 Escalation (2nd day after 28th)'+System.today(), finalEscalationCronExpresionDayTwo, monthlyEscalationJob);
        system.schedule('Day 3 Escalation (3rd day after 28th)'+System.today(), finalEscalationCronExpresionDayThree, monthlyEscalationJob);
        system.schedule('Internal Escalation(4th day after 28th)'+System.today(), finalEscalationCronExpresionDayFour, noResponseJob);
    }
}