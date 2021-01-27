trigger CaseTrigger on Case (before insert, after insert, after update,before update) {
    system.debug('Executing trigger case ');

    /*
    When getting a case from Email to Case after BI team completes the upload of PAm records for FRB Record Type, we identify it by the Description field
    in Case and add values to few fields and run the FRB Batches.
    */
    if(trigger.isbefore){
        
        if(trigger.isInsert){
            CaseTriggerHelper.FRBCaseandBatchRun();
            CaseTriggerHelper.PAMCaseAndBatchRun(trigger.new);
        }
        /* @ Added on 15-Sept-2020 by Prabhakar Joshi. */
        if(trigger.isUpdate){
            /*@ Calling method on before update trigger operation to update the status to closed according to outcome FTR details. */
            CaseTriggerHelper.updateStatusClosed(trigger.new,trigger.oldMap);
        }
        
    }
    
    if(trigger.isAfter){
        if(trigger.isInsert){
            CaseTriggerHelper.updateFirmDuringEmail2Case(trigger.new); 
            /* On Hold */
            //CaseTriggerHelper.sendDataToDM(trigger.new);
        }
        
        if(trigger.isUpdate){
            if(checkRecursive.runOnce()){
                CaseTriggerHelper.YGC_RejectReportonCase(trigger.new, trigger.oldMap);
            }
        }
        
    }
    
}