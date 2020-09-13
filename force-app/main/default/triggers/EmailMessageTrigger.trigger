/* 
    * @ Trigger Name    :       EmailMessageTrigger
    * @ Description     :       Trigger on EmailMessage Sobject
    * @ Created By      :       Prabhakar Joshi
    * @ Created Date    :       11-Sept-2020
*/

trigger EmailMessageTrigger on EmailMessage (before insert,after insert,before update,after update) {
    Boolean triggerActive = Trigger_Setting__c.getValues('EmailMessageTrigger') != NULL ? Trigger_Setting__c.getValues('EmailMessageTrigger').Active__c : false;
    if(triggerActive){
        EmailMessageTriggerHandler handler = new EmailMessageTriggerHandler();
        if(trigger.isAfter){
            if(trigger.isInsert){
                handler.afterInsert(trigger.New);
            }
        }
    }
}