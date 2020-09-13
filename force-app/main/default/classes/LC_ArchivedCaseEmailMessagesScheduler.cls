global class LC_ArchivedCaseEmailMessagesScheduler implements Schedulable {// for testing purpose - Ishan Kashyap
  global Database.Batchable<SObject> batchClass{get;set;}
  global Integer batchSize{get;set;} {batchSize = 500;}
 
  global void execute(SchedulableContext sc) {
        LC_CreateArchivedEmailMessagesBatch b = new LC_CreateArchivedEmailMessagesBatch(); 
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b,500);
  } 
}