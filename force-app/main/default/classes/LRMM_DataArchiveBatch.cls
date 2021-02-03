/* 
 	* @ Class Name  			: 		LRMM_DataArchiveBatch
 	* @ Description 			: 		This class is for archive the LRMM Objects Data.
 	* @ Created By  			: 		Prabhakar Joshi
 	* @ Created Date			: 		19-Mar-2020
 	* @ Last Modified Date 		: 		27-Jan-2021
 */

global class LRMM_DataArchiveBatch implements Database.Batchable<sobject>, Database.Stateful{
	LRMM_DataArchiveHandler handler = new LRMM_DataArchiveHandler();
	global Integer deleteCount;
    global Integer failCount;
    Map<Id,String> recordIdToErrorMap;

	public LRMM_DataArchiveBatch(){
		this.deleteCount = 0;
        this.failCount = 0;
        this.recordIdToErrorMap = new Map<Id,String>();
	}

    global Iterable<sobject> start(Database.batchableContext bc){
        return handler.getLRMMAttachments();
    }

    global void execute(Database.BatchableContext bc, List<Sobject> recordList){
        System.debug('>>>recordList'+recordList.size());
        /*
        if (recordList.size() > 0){
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
		*/
    }

	global void finish(Database.BatchableContext bc){ 
		DataArchiveReportController.sendNotificationAfterDataArchive(this.deleteCount,this.failCount,recordIdToErrorMap, 'LRMM Data Archive Notification');
	}
}