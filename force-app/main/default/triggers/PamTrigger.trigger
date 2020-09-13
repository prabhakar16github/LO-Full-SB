trigger PamTrigger on Process_Adherence_Monitoring__c (before insert, before update,after update) {

    if(Trigger.isBefore){
        
       
        if(Trigger.isInsert){
            PAMTriggerHelper.beforeInsert(Trigger.New, Trigger.OldMap);
        }
        
        if(Trigger.isUpdate){
            
            PAMTriggerHelper.beforeUpdate(Trigger.New, Trigger.OldMap);
        }
        
    }
    
    if(trigger.isAfter){
        if(trigger.isUpdate){
            PAMTriggerHelper.afterUpdate(trigger.new,trigger.oldMap);
        }
    }
    
    
}