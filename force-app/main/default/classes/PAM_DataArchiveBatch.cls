/*
 * @ Class Name      :     PAM_DataArchiveBatch
 * @ Description     :     Batch Class for PAM Data Archive Process.
 * @ Created By      :     Prabhakar Joshi
 * @ Created Date    :     2-Feb-2021
 * @ Last Modified   :     2-Feb-2021
 */
global class PAM_DataArchiveBatch implements Database.Batchable<sobject>, Database.Stateful{
    /* To Create a instance of the Handler Class. */
    PAM_DataArchiveHandler handler = new PAM_DataArchiveHandler();
    /* To hold the count of total deleted records. */
    Integer deleteCount;
    /* To hold the count of total failed records. */
    Integer failCount;
    /* Map to hold the record Id and error in record deletion which has been failed.  */
    Map<Id,String> recordIdToErrorMap;
    
    /* @ Consturctor */
    public PAM_DataArchiveBatch(){
        this.deleteCount = 0;
        this.failCount = 0;
        this.recordIdToErrorMap = new Map<Id,String>();
    }
    
    global Iterable<sobject> start(Database.BatchableContext bc){
        return handler.getPAMAttachments();
    }
    
    
    global void execute(Database.BatchableContext bc, List<Sobject> recordList){
        System.debug('recordList>>>>>>>>'+recordList.size());
        /*
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
*/
    }
    
    global void finish(Database.BatchableContext bc){
        DataArchiveReportController.sendNotificationAfterDataArchive(this.deleteCount,this.failCount,recordIdToErrorMap, 'PAM Data Archive Notification');
    }
}