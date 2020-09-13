/*
 * Class Name : IR_DM_ReminderScheduler
 * Developer : Shivangi Srivastava
 * Description : This scheduler class will run on 27th, 28th, three consecutive days after 28th and for the 4th day of 28th of current
 *  month for DM IR record type.
 * This scheduler class also scheduler other scheduler classes.
 */
global class IR_DM_ReminderScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        Date today_Date;
        if(!Test.isRunningTest()){
            today_Date = System.today();
        }
        today_Date = Date.newInstance(system.today().year(), system.today().month(), 28);
        
        Database.executeBatch(new IR_DM_MonthlyReminderBatch());
        if(today_Date.day() == 28){// runs only when batch running for 28th day.
            scheduleNextBatchs(today_Date);
        }
    }
    public void scheduleNextBatchs(Date DmDate){// for 3 consecutive days and for 4th day after 28th
        Date dayOne = DmDate.addDays(1);
        Date dayTwo = DmDate.addDays(2);
        Date dayThree = DmDate.addDays(3);
        Date dayFour = DmDate.addDays(4);
        
        string dayOneEscalation = '0 0 0 ' + dayOne.day() + ' * ' + ' ? ' + dayOne.year();
        string dayTwoEscalation = '0 0 0 '+ dayTwo.day() + ' * ' + ' ? ' + dayTwo.year();
        string dayThreeEscalation = '0 0 0 '+ dayThree.day() + ' * ' + ' ? ' + dayThree.year();
        string dayFourEscalation = '0 0 0 '+ dayFour.day() + ' * ' + ' ? ' + dayFour.year();
        
        IR_DM_FinalEscalationScheduler finalEsc = new IR_DM_FinalEscalationScheduler();
        IR_DM_NoResponseScheduler noResponse = new IR_DM_NoResponseScheduler();
        
        system.schedule('Day 1 Escalation (1st day after 28th)'+System.today(), dayOneEscalation, finalEsc);
        system.schedule('Day 2 Escalation (2nd day after 28th)'+System.today(), dayTwoEscalation, finalEsc);
        system.schedule('Day 3 Escalation (3rd day after 28th)'+System.today(), dayThreeEscalation, finalEsc);
        system.schedule('Day 4 Escalation (4th day after 28th)'+System.today(), dayFourEscalation, noResponse);
    }

}