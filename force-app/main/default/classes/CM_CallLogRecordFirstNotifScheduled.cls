global class CM_CallLogRecordFirstNotifScheduled implements Schedulable {
  global final integer notificationNo;
  
   global CM_CallLogRecordFirstNotifScheduled(integer notificationNo){
    this.notificationNo = notificationNo;
   }
   
   global void execute(SchedulableContext SC) {
      CM_CallLogRecordFirstNotificationBatch clf = new CM_CallLogRecordFirstNotificationBatch(notificationNo); 
   }
}