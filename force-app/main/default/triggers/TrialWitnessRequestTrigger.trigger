/*
	* @ Trigger Name 		: 	TrialWitnessRequestTrigger
 	* @ Description 		: 	Trigger on Trial_Witness_Request__c Object.
 	* @ Modified By			: 	Prabhakar Joshi
 	* @ LastModifiedDate 	: 	23-July-2020 
*/

trigger TrialWitnessRequestTrigger on Trial_Witness_Request__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    Boolean triggerActive = Trigger_Setting__c.getValues('TrialWitnessRequestTrigger') != NULL ? Trigger_Setting__c.getValues('TrialWitnessRequestTrigger').Active__c : false;
    if(triggerActive){
        TrialWitnessRequestTriggerHelper handler = new TrialWitnessRequestTriggerHelper();
        if(trigger.isBefore){
            if(trigger.isInsert){
                handler.beforeInsert(trigger.new);
            }
            if(trigger.isUpdate){
                handler.beforeUpdate(trigger.new, trigger.oldMap);
            }
        }
        if(trigger.isAfter){
            if(trigger.isInsert){
                handler.afterInsert(trigger.new, trigger.newMap);
            }
            if(trigger.isUpdate){
                handler.afterUpdate(trigger.new, trigger.oldMap);
            }
            if(trigger.isDelete){
                
            }
        }
    }
}