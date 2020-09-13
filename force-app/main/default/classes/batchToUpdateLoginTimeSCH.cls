global class batchToUpdateLoginTimeSCH implements Schedulable {

  global Database.Batchable<SObject> batchClass{get;set;}

  global Integer batchSize{get;set;} {batchSize = 500;}

  global void execute(SchedulableContext sc) {
        if(!Test.isRunningTest()){
        batchToUpdateLoginTime b = new batchToUpdateLoginTime(); 

        //Parameters of ExecuteBatch        
        database.executebatch(b,500);
        }
  } 

}