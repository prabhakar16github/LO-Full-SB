trigger LRMM_LiveWitnessAttorneyAssignment on Trial_Witness_Request__c (before insert, before update, after update) {
    /* Need to Depricate.Need to Inactive.*/
    /* Code has been merged in TrialWitnessRequestTrigger. */
    if(Trigger.isUpdate && Trigger.isAfter && !System.isFuture()){
        List<String> lwIdFillList = new List<String>();
        List<String> lwIdBlankList = new List<String>();
        Set<String> CADIdFillSet = new Set<String>();
        Set<String> CADIdBlankSet = new Set<String>();
        
        for(Trial_Witness_Request__c lwObj : Trigger.new){
            Trial_Witness_Request__c oldLWObj = Trigger.oldMap.get(lwObj.id);
            if(oldLWObj.Status__c == 'Pending Resolution' && lwObj.Status__c == 'Closed'){
                if(!CADIdFillset.contains(lwObj.TW_Consumer_Account_Records__c)){
                    CADIdFillset.add(lwObj.TW_Consumer_Account_Records__c);
                    lwIdFillList.add(lwObj.id);
                }
            }else if(oldLWObj.Status__c == 'Closed' && lwObj.Status__c == 'Pending Resolution' &&
                    lwObj.LW_Resolution_Amount__c == null && lwObj.LW_Resolution_Date__c == null && 
                    (lwObj.LW_Resolution_Notes__c == null || lwObj.LW_Resolution_Notes__c == '') && 
                    lwObj.LW_Resolution_Payment_To__c == null && lwObj.LW_Resolution_Type__c == null){
                if(!CADIdBlankSet.contains(lwObj.TW_Consumer_Account_Records__c)){
                    CADIdBlankSet.add(lwObj.TW_Consumer_Account_Records__c);
                    lwIdBlankList.add(lwObj.id);
                }
            }
        }
        
        if(!lwIdFillList.isEmpty()) LRMMTriggerHelper.populateResolutionFields(lwIdFillList,'Pending Resolution','Closed');
        if(!lwIdBlankList.isEmpty()) LRMMTriggerHelper.populateResolutionFields(lwIdBlankList,'Closed','Pending Resolution');
    }
    
    if((Trigger.isUpdate || Trigger.isInsert) && Trigger.isBefore){
        
        List<Trial_Witness_Request__c> Claimlist = new List<Trial_Witness_Request__c>();
        Set<Id> userid = new Set<Id>();
        Set<Id> userid1 = new Set<Id>();
        List<Account> accountList = new List<Account>();
        List<State_Profile__c> stateList = new List<State_Profile__c>();
        Map<Id,String> mapAccount = new Map<Id,String>();
        Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName();
        Set<Id> recTypeLiveWitness = new Set<Id>(); 
        recTypeLiveWitness.add(rtMap.get('Live Witness Request Step I').getRecordTypeId());
        recTypeLiveWitness.add(rtMap.get('Live Witness Request Step II').getRecordTypeId());
        recTypeLiveWitness.add(rtMap.get('Live Witness Request Step III').getRecordTypeId());
        
        for(Trial_Witness_Request__c counter : Trigger.new){
            if(trigger.isInsert){
                userid.add(counter.OrganizationName__c);
                userid1.add(counter.State_Filed_State_Profile__c);
            }
            /**************Added on 7-Nov-2019 by Prabhakar Joshi ************************/
            if(trigger.isUpdate){
                if(counter.LW_Attorney_Approval_Needed__c){
                    if(trigger.oldMap.get(counter.Id).LW_Attorney_Assignment__c == NULL){
                        userid.add(counter.OrganizationName__c);
                        userid1.add(counter.State_Filed_State_Profile__c);
                    }
                }
            }
            /*****************************************************************************/
        }
        
        
        system.debug('userid-->'+userid);
        if(userId.size() > 0 || userid1.size() > 0){
            
            accountList = [Select id,Name,Paralegal__c,MCM_Attorney__c FROM Account WHERE Id IN: userid];
            stateList = [Select id,SP_Paralegal__c,SP_MCM_Attorney__c FROM State_Profile__c WHERE Id IN: userid1];
            system.debug('accountList-->'+accountList);
            
            for(Account acc : accountList){
                
                mapAccount.put(acc.id,acc.Name);
            }
            
            if(mapAccount.size() >0)
            
            for(Trial_Witness_Request__c twitness : Trigger.new){
                
                for(Account acList :accountList){
                    if(!mapAccount.get(twitness.OrganizationName__c).contains('CA137') || !mapAccount.get(twitness.OrganizationName__c).contains('NY64')){
                        
                       if(twitness.LW_Attorney_Approval_Needed__c == true 
                            && recTypeLiveWitness.contains(twitness.RecordTypeId) 
                            && (twitness.LW_Attorney_Assignment__c == null)){
                          
                          twitness.LW_Attorney_Assignment__c = acList.MCM_Attorney__c;
                       }
                    }
                }
               
               for(State_Profile__c state : stateList){
                    if(mapAccount.get(twitness.OrganizationName__c).contains('CA137') || mapAccount.get(twitness.OrganizationName__c).contains('NY64')){
                        
                       if(twitness.LW_Attorney_Approval_Needed__c == true 
                            && recTypeLiveWitness.contains(twitness.RecordTypeId) 
                            && (twitness.LW_Attorney_Assignment__c == null)){
                        
                          twitness.LW_Attorney_Assignment__c = state.SP_MCM_Attorney__c;
                       }
                    }
               }
            }
         }
    }
}