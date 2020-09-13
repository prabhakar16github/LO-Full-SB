trigger PAM_UnmatchedTrigger on PAM_Unmatched__c (before insert, before update, after insert, after update,after delete) {
    
    if(trigger.isBefore){
    	
    	if(trigger.isInsert){
    	
		    PAM_UnmatchedTriggerHelper.beforeInsertPamUnmatched(trigger.new);
    	}
    	
    	if(trigger.isUpdate){
    		
    		PAM_UnmatchedTriggerHelper.beforeUpdatePamUnmatched(trigger.new, trigger.oldMap);
    	}
    }
    
    if(trigger.isAfter){
    	
    	if(trigger.isInsert){
    	
		    PAM_UnmatchedTriggerHelper.afterInsertPamUnmatched(trigger.new);
    	}
    	
    	if(trigger.isUpdate){
    		
    		PAM_UnmatchedTriggerHelper.afterUpdatePamUnmatched(trigger.new, trigger.oldMap);
    	}
    	
    	if(trigger.isDelete){
    		//System.debug('delete called');
    		PAM_UnmatchedTriggerHelper.afterDeletePamUnmatched(trigger.oldMap);
    	}
    	
    }
    
    
}