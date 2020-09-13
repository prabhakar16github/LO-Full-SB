global with sharing class PAM_SendFRBNotificationScheduler implements Schedulable
{
  global Database.Batchable<SObject> batchClass{get;set;}
  global Integer batchSize{get;set;} {batchSize = 500;}

  global void execute(SchedulableContext sc) {
       // if(!Test.isRunningTest()){
        PAM_SendFRBNotificationBatch  b = new PAM_SendFRBNotificationBatch(); 

        //Parameters of ExecuteBatch        
        database.executebatch(b,500);
       // }
  } 

}