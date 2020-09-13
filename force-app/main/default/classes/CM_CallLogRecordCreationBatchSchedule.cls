global class CM_CallLogRecordCreationBatchSchedule implements Schedulable {
   global void execute(SchedulableContext SC) {
      CM_CallLogRecordCreationBatch clf = new CM_CallLogRecordCreationBatch(); 
      database.executeBatch(clf);
   }
}