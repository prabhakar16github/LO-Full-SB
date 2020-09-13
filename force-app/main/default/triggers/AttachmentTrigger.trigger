trigger AttachmentTrigger on Attachment (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Boolean triggerActive = Trigger_Setting__c.getValues('AttachmentTrigger').Active__c;
    if(triggerActive){
        AttachmentTriggerHandler handler = new AttachmentTriggerHandler();
        if(trigger.isBefore){
            if(trigger.isInsert){
                handler.beforeInsert(trigger.new);
            }
            if(trigger.isDelete){
                handler.beforeDelete(trigger.old);
            }
        }
        if(trigger.isAfter){
            if(trigger.isInsert){
                handler.afterInsert(trigger.new);
            }
            if(trigger.isDelete){
                handler.afterDelete(trigger.old);
            }
            if(trigger.isUndelete){
                handler.afterUndelete(trigger.new);
            }
        }
    }
}