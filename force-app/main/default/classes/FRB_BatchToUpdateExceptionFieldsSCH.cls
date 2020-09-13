global class FRB_BatchToUpdateExceptionFieldsSCH implements Schedulable {

  global Database.Batchable<SObject> batchClass{get;set;}

  global Integer batchSize{get;set;} {batchSize = 200;}

  global void execute(SchedulableContext sc) {
        if(!Test.isRunningTest()){
        FRB_BatchToUpdateExceptionFields b = new FRB_BatchToUpdateExceptionFields(); 

        //Parameters of ExecuteBatch        
        database.executebatch(b,200);
        }
  } 

}