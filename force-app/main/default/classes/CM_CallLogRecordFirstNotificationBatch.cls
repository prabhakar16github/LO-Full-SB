/* 
  Description : scheduled at Fourth(4th) day of each month Attachment checkbox is False 
                NOTE ------  > FOR 4TH DAY PASS ONE IN CONSTRUCTOR 
                     ------- > FOR 5TH DAY PASS TWO IN CONSTRUCTOR 
                     ------- > FOR 6TH DAY PASS THREE IN CONSTRUCTOR 
  Created date : 28/06/2019 
  @uthor : Avaneesh Singh 
*/
global class CM_CallLogRecordFirstNotificationBatch implements Database.Batchable<sObject>{
    public final Integer notificationNo;
    
    global CM_CallLogRecordFirstNotificationBatch (Integer notificationNo){
     this.notificationNo = notificationNo;
    }
 
   global Database.QueryLocator start(Database.BatchableContext BC){
     // fetching the recordtype name call monitoring and where attachment checkbox is false
     String currentMonth = String.valueof(Date.today().Month());
     String currentYear = String.valueOf(Date.today().Year());
     Id firmRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Log').getRecordTypeId();
     String Query ='SELECT id , Name,Organization_Name_CM__c,Reporting_Month_CM__c,Reporting_Year_CM__c from Call_Monitoring__c where recordTypeId = :firmRecordTypeId  and Attachments__c=false ';
            Query += ' AND Reporting_Month_CM__c =:currentMonth And Reporting_Year_CM__c =:currentYear ';
     return Database.getQueryLocator(Query);
     
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
         CM_CallLogRecordFirstNotifcationHelper.createInstance(notificationNo).runBatch(scope);
   }

   global void finish(Database.BatchableContext BC){
   
   }
}