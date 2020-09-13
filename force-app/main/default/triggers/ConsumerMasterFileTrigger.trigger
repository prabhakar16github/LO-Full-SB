/*
	* @ Trigger Name 	: 	ConsumerMasterFileTrigger
	* @ Description 	: 	Trigger on Consumer_Master_File__c Object.
	* @ Created By 		: 	Vaibhav Jain
	* @ Created Date	: 	31-July-2020 
*/

trigger ConsumerMasterFileTrigger on Consumer_Master_File__c (before insert){
	Boolean triggerActive = Trigger_Setting__c.getValues('ConsumerMasterFileTrigger') != NULL ? Trigger_Setting__c.getValues('ConsumerMasterFileTrigger').Active__c : false;
    if(triggerActive){
        ConsumerMasterFileTriggerHandler handler = new ConsumerMasterFileTriggerHandler();
        if(trigger.isBefore){
            if(trigger.isInsert){
                handler.beforeInsert(trigger.new);
            }
        }
    }
}