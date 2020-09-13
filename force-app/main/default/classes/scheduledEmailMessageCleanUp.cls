/*
##########################################################################################################################################
# Project Name..........: LO - Email message Data Stroage Clean Up
# File..................: Class : "scheduledMonthlyEmailReminderCleanUp"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 13-June-2014
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 13-June-2014
# Description...........: It will Control the "LC_ArchivedCaseEmailMessagesBatchJob " batch job and schedule it on every approx 15th of each month
                          where LC_ArchivedCaseEmailMessagesBatchJob  class will start its job accordingly.
###############################################################################################################################################
*/

global class scheduledEmailMessageCleanUp implements Schedulable {
   
    global void execute(SchedulableContext sc) {
        
        BatchJobDetails__c myBatchSize = BatchJobDetails__c.getInstance('scheduledEmailMessageCleanUp_BatchSize');
        Integer BS;
        if(!Test.isRunningTest())
            BS = Integer.ValueOf(myBatchSize.Size__c);
        else         
          BS = 1;
          System.debug('======='+BS);
        LC_ArchivedCaseEmailMessagesBatchJob LC_CCRCBC = new LC_ArchivedCaseEmailMessagesBatchJob();
 
        Database.executeBatch(LC_CCRCBC,BS);
    }
    
     
    //LC_ArchivedCaseEmailMessagesBatchJob LC_CCRCBC = new LC_ArchivedCaseEmailMessagesBatchJob();
//Database.executeBatch(LC_CCRCBC,180);
/*

    String CRON_EXP = '0 30 14 15W * ? *';
    scheduledEmailMessageCleanUp semcu = new scheduledEmailMessageCleanUp();
    System.schedule('15th Working Day Email Reminder Clean Job-->'+system.now(), CRON_EXP, semcu);
     
*/

}