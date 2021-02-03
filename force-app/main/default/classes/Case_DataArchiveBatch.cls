/*
    * @ Class Name  	: 	Case_DataArchiveBatch
    * @ Description 	: 	Batch Class for Archive the Email Messages & Attachments of Case Object.
    * @ Created By  	: 	Prabhakar Joshi
    * @ Created Date	: 	14-July-2020
    * @ Last Modified   :   20-Jan-2021
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
    
    /* @ Constructor */
    public Case_DataArchiveBatch(){
        this.deleteCount = 0;
        this.failCount = 0;
        this.recordIdToErrorMap = new Map<Id,String>();
    }/** END */
    
    global Iterable<sobject> start(Database.BatchableContext bc){
        
        Map<Id,Sobject> objMap = new Map<Id,Sobject>();
        objMap.putAll(handler.getCaseAttachments());
        objMap.putAll(handler.getEmailMessages());
        return objMap.values();
    }/** END */
    
    
    global void execute(Database.BatchableContext bc, List<Sobject> recordList){
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
    }/** END */
    
    global void finish(Database.BatchableContext bc){
        /** Calling method to send the notification after data archived. */
        handler.sendNotificationAfterDataArchive(this.deleteCount,this.failCount,recordIdToErrorMap, 'Case Data Archive Notification');
    }/** END */
}