trigger LRMM_RecordAssignmentonAppeal on Appeal__c (before insert, before update, after update) {
    
    if(Trigger.isUpdate && Trigger.isAfter && !System.isFuture()){
        List<String> appealIdFillList = new List<String>();
        List<String> appealIdBlankList = new List<String>();
        Set<String> CADIdFillSet = new Set<String>();
        Set<String> CADIdBlankSet = new Set<String>();
        
        for(Appeal__C appealObj : Trigger.new){
            Appeal__C oldAppealObj = Trigger.oldMap.get(appealObj.id);
            if(oldAppealObj.AP_Appeal_Status__c == 'Pending Resolution' && appealObj.AP_Appeal_Status__c == 'Closed'){
                if(!CADIdFillSet.contains(appealObj.AP_Consumer_Account_Record__c)){
                    CADIdFillSet.add(appealObj.AP_Consumer_Account_Record__c);
                    appealIdFillList.add(appealObj.id);
                }
            }else if(oldAppealObj.AP_Appeal_Status__c == 'Closed' && appealObj.AP_Appeal_Status__c == 'Pending Resolution' &&
                     appealObj.AP_Resolution_Amount__c == null && appealObj.AP_Resolution_Date__c == null && 
                     (appealObj.AP_Resolution_Notes__c == null || appealObj.AP_Resolution_Notes__c == '') && 
                     appealObj.AP_Resolution_Payment_To__c == null && appealObj.AP_Resolution_Type__c == null){
                         if(!CADIdBlankSet.contains(appealObj.AP_Consumer_Account_Record__c)){
                             CADIdBlankSet.add(appealObj.AP_Consumer_Account_Record__c);
                             appealIdBlankList.add(appealObj.id);
                         }
                     }
        }
        
        if(!appealIdFillList.isEmpty()) LRMMTriggerHelper.populateResolutionFields(appealIdFillList,'Pending Resolution','Closed');
        if(!appealIdBlankList.isEmpty()) LRMMTriggerHelper.populateResolutionFields(appealIdBlankList,'Closed','Pending Resolution');
    }
    
    if((Trigger.isUpdate || Trigger.isInsert) && Trigger.isBefore){
        List<Appeal__c> Claimlist = new List<Appeal__c>();
        List<Task> tasklist1 = new List<Task>();
        Set<Id> userid = new Set<Id>();
        Set<Id> userid1 = new Set<Id>();
        List<Account> accountList = new List<Account>();
        List<State_Profile__c> stateList = new List<State_Profile__c>();
        Map<Id,String> mapAccount = new Map<Id,String>();
        
        for(Appeal__c counter : Trigger.new)
        {
            if(trigger.isInsert){
                userid.add(counter.AP_Organization_Name__c);
                userid1.add(counter.AP_State_Filed__c);
            }
            
            /**************Added on 6-Nov-2019 by Prabhakar Joshi ************************/
            if(trigger.isUpdate){
                if(counter.AP_Attorney_Approval_Needed__c){
                    if(trigger.oldMap.get(counter.Id).AP_Attorney_Assignment__c == NULL){
                        userid.add(counter.AP_Organization_Name__c);
                        userid1.add(counter.AP_State_Filed__c);
                    }
                }
            }
            /*****************************************************************************/
        }
        system.debug('userid-->'+userid);
        if(userId.size() > 0 || userid1.size() > 0)
        {
            accountList = [Select id,Name,Paralegal__c,MCM_Attorney__c FROM Account WHERE Id IN: userid];
            stateList = [Select id,SP_Paralegal__c,SP_MCM_Attorney__c FROM State_Profile__c WHERE Id IN: userid1];
            system.debug('accountList-->'+accountList);
            for(Account acc : accountList)
            {
                mapAccount.put(acc.id,acc.Name);
            }
            if(mapAccount.size() >0)
                for(Appeal__c cclaim : Trigger.new)
            {
                for(Account acList :accountList)
                {
                    if(!mapAccount.get(cclaim.AP_Organization_Name__c).contains('CA137') || !mapAccount.get(cclaim.AP_Organization_Name__c).contains('NY64'))
                    {
                        cclaim.AP_Paralegal_Assignment__c  = acList.Paralegal__c;
                        if(cclaim.AP_Attorney_Approval_Needed__c == true)
                        {
                            cclaim.AP_Attorney_Assignment__c = acList.MCM_Attorney__c;
                        }
                    }
                }
                for(State_Profile__c state : stateList)
                {
                    if(mapAccount.get(cclaim.AP_Organization_Name__c).contains('CA137') || mapAccount.get(cclaim.AP_Organization_Name__c).contains('NY64'))
                    {
                        cclaim.AP_Paralegal_Assignment__c  = state.SP_Paralegal__c;
                        if(cclaim.AP_Attorney_Approval_Needed__c == true)
                        {
                            cclaim.AP_Attorney_Assignment__c = state.SP_MCM_Attorney__c;
                        }
                    }
                }
            }
        }
    }
}