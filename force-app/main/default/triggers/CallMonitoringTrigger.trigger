/*
	* @ Trigger Name 	: 	CallMonitoringTrigger
 	* @ Description 	: 	Trigger on Call_Monitoring__c Object.
 	* @ Created By 		: 	Prabhakar Joshi
 	* @ Created Date	: 	25-May-2020 
*/

trigger CallMonitoringTrigger on Call_Monitoring__c (before insert,before update,before delete,after insert,after update,after delete,after undelete) {
    Boolean triggerActive = Trigger_Setting__c.getValues('CallMonitoringTrigger') != NULL ? Trigger_Setting__c.getValues('CallMonitoringTrigger').Active__c : false;
    if(triggerActive){
        CallMonitoringTriggerHandler handler = new CallMonitoringTriggerHandler();
        if(trigger.isBefore){
            if(trigger.isInsert){
                handler.beforeInsert(trigger.new);
            }
            if(trigger.isUpdate){
                handler.beforeUpdate(trigger.new,trigger.oldMap);
            }
            if(trigger.isDelete){
                /* This method will add in handler when something need to happen in before delete event. */
                /* handler.beforeDelete(trigger.old); */
            }
        }
        if(trigger.isAfter){
            if(trigger.isInsert){
                handler.afterInsert(trigger.new);
            }
            if(trigger.isUpdate){
                handler.afterUpdate(trigger.new,trigger.oldMap);
            }
            if(trigger.isDelete){
                /* This method will add in handler when something need to happen in after delete event. */
                /* handler.afterDelete(trigger.old); */
            }
            if(trigger.isUndelete){
                /* This method will add in handler when something need to happen in after undelete event. */
                /* handler.afterUndelete(trigger.new); */
            }
        }
    }
}