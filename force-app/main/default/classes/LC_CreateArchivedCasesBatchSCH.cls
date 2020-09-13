global class LC_CreateArchivedCasesBatchSCH implements Schedulable {// for testing purpose - Ishan Kashyap
  global Database.Batchable<SObject> batchClass{get;set;}
  global Integer batchSize{get;set;} {batchSize = 500;}
 
  global void execute(SchedulableContext sc) {
        LC_CreateArchivedCasesBatch b = new LC_CreateArchivedCasesBatch(); 
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b,500);
  } 
}