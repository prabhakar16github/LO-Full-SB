trigger CaseTrigger on Case (before insert, after insert, after update) {
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
        
    }
    
    if(trigger.isAfter){
        
        if(trigger.isInsert){
            
            CaseTriggerHelper.updateFirmDuringEmail2Case(trigger.new); 
            CaseTriggerHelper.sendDataToDM(trigger.new);
        }
        
        if(trigger.isUpdate){
            
            if(checkRecursive.runOnce()){
                CaseTriggerHelper.YGC_RejectReportonCase(trigger.new, trigger.oldMap);
            }
        }
        
    }
    
}