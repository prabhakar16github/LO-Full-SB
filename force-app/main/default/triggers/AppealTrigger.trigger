/*
	* @ Trigger Name 	: 	AppealTrigger
 	* @ Description 	: 	Trigger on Appeal__c Object.
 	* @ Created By 		: 	Prabhakar Joshi
 	* @ Created Date	: 	22-July-2020 
*/

trigger AppealTrigger on Appeal__c (before insert) {
    Boolean triggerActive = Trigger_Setting__c.getValues('AppealTrigger') != NULL ? Trigger_Setting__c.getValues('AppealTrigger').Active__c : false;
    if(triggerActive){
        AppealTriggerHandler handler = new AppealTriggerHandler();
        if(trigger.isBefore){
            if(trigger.isInsert){
                handler.beforeInsert(trigger.new);
            }
        }
        if(trigger.isAfter){
            if(trigger.isInsert){
                handler.afterInsert(trigger.new);
            }
        }
    }
}