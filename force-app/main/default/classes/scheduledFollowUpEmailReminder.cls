/*
##########################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: Class : "scheduledFollowUpEmailReminder"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 02-June-2014
# Last Modified by......: Sunny Kumar
# Last Modified Date....: 08-May-2015
# Description...........: It will Control the "EmailReminderBatch" batch job and schedule 
#                          for Every Second Business Day for each Month to send CI Follow-Ups

Mofication History:

08-May-2015 - > Change in scheduler fire date from 2nd of each month to 4th of each month and if 4th is on sat-sun then we will shift fire date on 
next upcoming Monday

19-Jan-2016 --> Change code for New year Month - Year combination automation purpoes

04-April-2016 --> This scheduler will help to schedule another batch job for CM: Follow Up Notifications
###########################################################################################################################################
*/
 
global class scheduledFollowUpEmailReminder implements Schedulable{  
    
     /**
    * Builds up all of the new Objects
    *
    * @param sc The schedulable context
    */
   // public Boolean isTestCall=false;
    global void execute(SchedulableContext sc) {
        //Code goes here
        String currentMonth;
        String NewYear;
        
        // For 12 Month
        if(System.Today().month() != 1){
            currentMonth=String.valueOf(System.Today().month()-1);  
        }
        else{
            System.debug('Else--For JANUARY--currentMonth >>>'+currentMonth);   
            currentMonth='12'; // Its new year and calculation needs to be done on previous month for all notifications
        }
        
        String currentYear;
        
        if(currentMonth!='12'){
            currentYear=String.valueOf(System.Today().Year());
        }else{
            currentYear=String.valueOf(System.Today().Year()-1);    
        }
        
       String currentday=String.valueOf(System.Today().Day());
       System.debug('currentday >>>'+currentday); 
       
       startBatch(currentMonth,currentYear,currentday);
       
   }
     public void startBatch(String currentMonth,String currentYear,String currentday){
        
            if(Integer.valueOf(currentday) == 3){    
                             
                   //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
                    currentMonth = String.valueOf(System.Today().month());
                    String CRON_EXP = '0 30 14 ' + (Integer.valueOf(currentday) + 3) + ' ' + currentMonth + ' ? ' + currentYear;
                    scheduledFollowUpEmailReminder sm = new scheduledFollowUpEmailReminder();
                    
                    if(!test.isrunningTest()){
                        System.schedule('Postponed CIS&CM : Followup_ to 4th working Business Day==> '+system.now(), CRON_EXP, sm);              
                    }
                    
            }else{ 
                    //FOR CIS: FOLLOW UP PROCESS
                    Database.executeBatch(new EmailReminderBatch(currentYear,currentMonth,true,true,true),1);
                    //FOR CM: FOLLOW UP PROCESS
                   // Database.executeBatch( new CM_FollowUPMonthlyNotification(currentYear,currentMonth,true,true,true),1);
                 
            }  
                       
      }
    
}