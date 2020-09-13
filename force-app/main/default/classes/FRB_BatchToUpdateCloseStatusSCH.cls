global class FRB_BatchToUpdateCloseStatusSCH implements Schedulable {

  global Database.Batchable<SObject> batchClass{get;set;}

  global Integer batchSize{get;set;} {batchSize = 500;}

  global void execute(SchedulableContext sc) {
        if(!Test.isRunningTest()){
        FRB_BatchToUpdateCloseStatus b = new FRB_BatchToUpdateCloseStatus(); 

        //Parameters of ExecuteBatch        
        database.executebatch(b,500);
        }
  } 

}