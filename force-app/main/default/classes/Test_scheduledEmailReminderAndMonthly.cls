/*
##########################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: It is a Test Class for "scheduledFollowUpEmailReminder and scheduledMonthly" Classes
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 23-May-2014
# Last Modified by......: Sunny Kumar
# Last Modified Date....: 19-Jan-2016
# Description...........: It will cover the Test Coverage for scheduledFollowUpEmailReminder and scheduledMonthly Scheduler Classes.
###########################################################################################################################################
*/
/**  @isTest
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.

Classes Covered : scheduledFollowUpEmailReminder , scheduledMonthly
*/   

@isTest
private class Test_scheduledEmailReminderAndMonthly {
    //public static String CRON_EXP = '0 0 0 25 5 ? 2014';
     
    static testMethod void myUnitTest(){
        Test.startTest();
        
         //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        scheduledFollowUpEmailReminder objScheduler = new scheduledFollowUpEmailReminder();             
        SchedulableContext sc=null;
        objScheduler.execute(sc);
       /* String mn = String.ValueOf(System.Today().month());
        String dy = String.ValueOf(System.Today().day());
        String yr= String.ValueOf(System.Today().year());
        
        objScheduler.startBatch(mn,yr,dy);
        //  objScheduler.startBatch('08','2014','1');
       // objScheduler.startBatch(mn,yr,dy);
         
          //objScheduler.execute(sc);  */
         
           scheduledFollowUpEmailReminder objScheduler1 = new scheduledFollowUpEmailReminder();   
           objScheduler1.startBatch('10','2016','3');   
           
            scheduledFollowUpEmailReminder objScheduler2 = new scheduledFollowUpEmailReminder();  
            objScheduler2.startBatch('','','4');  
       
        Test.stopTest();
        
        
    }
    
     static testMethod void scheduledMonthlyTest(){
        Test.startTest();
        
         //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        scheduledMonthly obj= new scheduledMonthly();             
        SchedulableContext sc=null;
        obj.execute(sc);
        Test.stopTest();
    }
    
   
    
}