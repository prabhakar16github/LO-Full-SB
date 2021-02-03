/* 
 	* @ Class Name  			: 		LRMM_DataArchiveBatch
 	* @ Description 			: 		This class is for archive the LRMM Objects Data.
 	* @ Created By  			: 		Prabhakar Joshi
 	* @ Created Date			: 		19-Mar-2020
 	* @ Last Modified Date 		: 		27-Jan-2021
 */

global class LRMM_DataArchiveBatch implements Database.Batchable<sobject>, Database.Stateful{
    /** Instance of the handler class. */
    LRMM_DataArchiveHandler handler = new LRMM_DataArchiveHandler();
    /** To hold the count of total deleted records. */
    global Integer deleteCount;
    /** To hold the count of total failed records. */
    global Integer failCount;
    /** Map of failed recordId and the error. */
    Map<Id,String> recordIdToErrorMap;

    /** Constructor */
	public LRMM_DataArchiveBatch(){
		this.deleteCount = 0;
        this.failCount = 0;
        this.recordIdToErrorMap = new Map<Id,String>();
	}/** END */

    global Iterable<sobject> start(Database.batchableContext bc){
        return handler.getLRMMAttachments();
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
		DataArchiveReportController.sendNotificationAfterDataArchive(this.deleteCount,this.failCount,recordIdToErrorMap, 'LRMM Data Archive Notification');
	}/** END */
}