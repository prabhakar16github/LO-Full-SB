global class SCUM_CreationNotificationBatch  implements Database.Batchable<Sobject>,Database.stateful{
   
    public final string recordTypeName;
    public Set<Id> pamObjIdSet;
    
    global SCUM_CreationNotificationBatch(String recordTypeName){
      this.recordTypeName = recordTypeName;    // ACF SCMDUM and LO SCMDUM
      this.pamObjIdSet = new Set<Id>();
    }  
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
      Id pamUnmatchedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
            
       String query = 'SELECT id , Name,SCMDUM_Record_Creation_Notification_Sent__c,PAMUM_Process_Adherence_Monitoring__c from PAM_Unmatched__c where recordtypeid =:pamUnmatchedRecType and SCMDUM_Record_Creation_Notification_Sent__c=false and createdDate = today';
     return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<PAM_Unmatched__c> scope){
        
       Set<Id> pamIdsSet = new Set<Id>();
       for(PAM_Unmatched__c pu : scope){
         if(pu.PAMUM_Process_Adherence_Monitoring__c != null )
         pamIdsSet.add(pu.PAMUM_Process_Adherence_Monitoring__c);
       }
       if(recordTypeName =='LO SCMDUM'){
         SCUM_CreationNotificationBatchHelper.sendSCMDUMEmailFuture(pamIdsSet ,'SCMD-LO',pamObjIdSet);
       }else if(recordTypeName =='ACF SCMDUM'){ //SCMD-ACF
         SCUM_CreationNotificationBatchHelper.sendSCMDUMEmailFuture(pamIdsSet ,'SCMD-ACF',pamObjIdSet);
       }
    }
        
    public void finish(Database.BatchableContext bc){
       if(pamObjIdSet.size() >0){
       
         List<Process_Adherence_Monitoring__c> pamObjList = [select id , name,Batch_SCUM_Notification_Sent_Flag__c from Process_Adherence_Monitoring__c where id In :pamObjIdSet ];
         for(Process_Adherence_Monitoring__c pam: pamObjList ){
           pam.Batch_SCUM_Notification_Sent_Flag__c = true;
         }
         
         if(pamObjList.size() >0)
         update pamObjList;
       }
     
    } 
    
}