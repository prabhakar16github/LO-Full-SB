trigger ConsumerAccountDetailTrigger on Consumer_Account_Details__c (after delete, after insert, after update, before insert, before update) {
    
    if(trigger.isBefore){
        
        system.debug('Executing ConsumerAccountDetailTrigger before Insert =========>');
        if(trigger.isInsert){
            
            system.debug('Executing ConsumerAccountDetailTrigger before Insert =========>');
            ConsumerAccountDetailTriggerHelper.beforeInsertConsumerAccountDetail(trigger.new);
        }
        
        if(trigger.IsUpdate){
            ConsumerAccountDetailTriggerHelper.beforeUpdateConsumerAccountDetail(trigger.new, trigger.oldMap);
        }
    
    }
    
    if(trigger.isAfter){
        
        if(trigger.isInsert){
            ConsumerAccountDetailTriggerHelper.afterInsertConsumerAccountDetail(trigger.new);
        }
        
        if(trigger.IsUpdate){
            ConsumerAccountDetailTriggerHelper.afterUpdateConsumerAccountDetail(trigger.new, trigger.oldMap);
            List<Consumer_Account_Details__c> cadInfoList = new List<Consumer_Account_Details__c>();
            for(Consumer_Account_Details__c cad : trigger.new){
                if(cad.Master_Activated__c) cadInfoList.add(cad);
            }
            if(cadInfoList.size() > 0)
            ConsumerAccountDetailTriggerHelper.updateResolutionField(cadInfoList);
        }
        
        if(trigger.IsDelete){
            ConsumerAccountDetailTriggerHelper.afterDeleteConsumerAccountDetail(trigger.old);
        }
    }
}