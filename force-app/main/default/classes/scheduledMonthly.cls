/*
##########################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: Class : "scheduledMonthly"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 02-June-2014
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 19-June-2014
# Description...........: It will Control the "EmailReminderBatch" batch job and schedule it on every Last 
#                         Business working day of every Month to send common alert to all active portal User.

Last Modified Date....: 06-April-2016 This Scheduler will help un CIS and CM Notifications
Last Modified Date... : remove the cm process for call log creation and notification
###############################################################################################################################################
*/

// JOB name --- Monthly Reminder

global class scheduledMonthly implements Schedulable {
    /**
    * Builds up all of the new Objects
    *
    * @param sc The schedulable context
    */
    global void execute(SchedulableContext sc) {
        //Code goes here
        String currentMonth = String.valueOf(System.Today().month());
        String currentYear = String.valueOf(System.Today().Year());
        String currentday = String.valueOf(System.Today().Day());
       
       
        // Batch for CIS Job 
       Database.executeBatch( new EmailReminderBatch(currentYear, currentMonth, true, true, false), 1);
       
       // Batch for CM Job     
       // the bellow line is commented by Avaneesh Singh 7/18/2019  
      // Database.executeBatch( new CM_FollowUPMonthlyNotification(currentYear, currentMonth, true, true, false), 1);
        
    }
    
     /*
    
      //String CRON_EXP = '0 30 13 17 6 ? 2014';
            //       scheduledFollowUpEmailReminder sm = new scheduledFollowUpEmailReminder();                  
                 //  System.schedule('Business Day Followup_'+system.now(), CRON_EXP, sm);
 
             String CRON_EXP = '0 30 14 LW * ? *';
             scheduledMonthly sm = new scheduledMonthly();
             System.schedule('Monthly Reminder_'+system.now(), CRON_EXP, sm);

    */
}