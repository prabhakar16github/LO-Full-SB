/*
    * @ Class Name  	: 	Case_DataArchiveBatch
    * @ Description 	: 	Batch Class for Archive the Email Messages & Attachments of Case Object.
    * @ Created By  	: 	Prabhakar Joshi
    * @ Created Date	: 	14-July-2020
*/

global class Case_DataArchiveBatch implements Database.Batchable<sobject>, Database.Stateful{
    /* To Create a instance of the Handler Class. */
    Case_DataArchiveHandler handler = new Case_DataArchiveHandler();
    /* To hold the count of total deleted records. */
    Integer deleteCount;
    /* To hold the count of total failed records. */
    Integer failCount;
    /* Map to hold the record Id and error in record deletion which has been failed.  */
    Map<Id,String> recordIdToErrorMap;
    /* To hold the Ids of Case record which has been processed. */
    Set<Id> caseIdSetToUpdate;
    /* To hold the limit value which will specify that how much case records are processing. */
    Integer limitSelected;
    
    /* @ Consturctor */
    public Case_DataArchiveBatch(String selectedLimit){
        this.deleteCount = 0;
        this.failCount = 0;
        this.recordIdToErrorMap = new Map<Id,String>();
        this.caseIdSetToUpdate = new Set<Id>();
        this.limitSelected = Integer.valueOf(selectedLimit);
    }
    
    global Iterable<Sobject> start(Database.batchableContext bc){
        List<Sobject> sobjList = new List<Sobject>();
        for(Case cs : handler.getCaseRecords(limitSelected)){
            caseIdSetToUpdate.add(cs.Id);
            sobjList.addAll(cs.Attachments);
            sobjList.addAll(cs.EmailMessages);
        }
        return sobjList;
    }
    
    
    global void execute(Database.BatchableContext bc, List<Sobject> recordList){
        if (!recordList.isEmpty()){
            List<Database.DeleteResult> result = Database.delete(recordList, false);
            for(Database.DeleteResult dr : result){
                if(dr.isSuccess()){
                    this.deleteCount ++;
                    
                }else{
                    this.failCount ++;
                    for(Database.Error err : dr.getErrors()){
                        recordIdToErrorMap.put(dr.getId(), err.getMessage());
                    }
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext bc){
        /* Calling the handler method to send the notification after archiving the data. */
        handler.sendNotificationAfterAttachmentDelete(this.deleteCount,this.failCount,recordIdToErrorMap, 'Case Data Archive Notification');
        if(!caseIdSetToUpdate.isEmpty()){
            /* Calling the handler method to update the case records which has been processed. */
            handler.updateCaseRecord(caseIdSetToUpdate);
        }

    }
}