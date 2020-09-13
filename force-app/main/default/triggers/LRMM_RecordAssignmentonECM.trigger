trigger LRMM_RecordAssignmentonECM on Escalated_Contested_Matters__c (before insert, before update, after update) {
    
    if(Trigger.isUpdate && Trigger.isAfter && !System.isFuture()){
        List<String> ecmIdFillList = new List<String>();
        List<String> ecmIdBlankList = new List<String>();
        Set<String> CADIdFillSet = new Set<String>();
        Set<String> CADIdBlankSet = new Set<String>();
        
        for(Escalated_Contested_Matters__c ecmObj : Trigger.new){
            Escalated_Contested_Matters__c oldECMObj = Trigger.oldMap.get(ecmObj.id);
            if(oldECMObj.ECM_Status__c == 'Pending Resolution' && ecmObj.ECM_Status__c == 'Closed'){
                if(!CADIdFillSet.contains(ecmObj.ECM_Consumer_Account_Detail_Name__c)){
                    CADIdFillSet.add(ecmObj.ECM_Consumer_Account_Detail_Name__c);
                    ecmIdFillList.add(ecmObj.id);
                }
            }else if(oldECMObj.ECM_Status__c == 'Closed' && ecmObj.ECM_Status__c == 'Pending Resolution' &&
                    ecmObj.ECM_Resolution_Amount__c == null && ecmObj.ECM_Resolution_Date__c == null && 
                    (ecmObj.ECM_Resolution_Notes__c == null || ecmObj.ECM_Resolution_Notes__c == '') && 
                    ecmObj.ECM_Resolution_Payment_To__c == null && ecmObj.ECM_Resolution_Type__c == null){
                if(!CADIdBlankSet.contains(ecmObj.ECM_Consumer_Account_Detail_Name__c)){
                    CADIdBlankSet.add(ecmObj.ECM_Consumer_Account_Detail_Name__c);
                    ecmIdBlankList.add(ecmObj.id);
                }
            }
        }
        
        if(!ecmIdFillList.isEmpty()) LRMMTriggerHelper.populateResolutionFields(ecmIdFillList,'Pending Resolution','Closed');
        if(!ecmIdBlankList.isEmpty()) LRMMTriggerHelper.populateResolutionFields(ecmIdBlankList,'Closed','Pending Resolution');
    }
    
    if((Trigger.isUpdate || Trigger.isInsert) && Trigger.isBefore){
        List<Escalated_Contested_Matters__c> Claimlist = new List<Escalated_Contested_Matters__c>();
        List<Task> tasklist1 = new List<Task>();
        Set<Id> userid = new Set<Id>();
        Set<Id> userid1 = new Set<Id>();
        List<Account> accountList = new List<Account>();
        List<State_Profile__c> stateList = new List<State_Profile__c>();
        Map<Id,String> mapAccount = new Map<Id,String>();
        
        for(Escalated_Contested_Matters__c counter : Trigger.new){
            if(trigger.isInsert){
                userid.add(counter.ECM_Organization_Name__c);
                userid1.add(counter.ECM_State_Filed__c);
            }
            /**************Added on 7-Nov-2019 by Prabhakar Joshi ************************/
            if(trigger.isUpdate){
                if(counter.ECM_Attorney_Approval_Needed__c){
                    if(trigger.oldMap.get(counter.Id).ECM_Attorney_Assignment__c == NULL){
                        userid.add(counter.ECM_Organization_Name__c);
                        userid1.add(counter.ECM_State_Filed__c);
                    }
                }
            }
            /*****************************************************************************/
        }
        
        if(userId.size() > 0 || userid1.size() > 0){
            accountList = [Select id,Name,Paralegal__c,MCM_Attorney__c FROM Account WHERE Id IN: userid];
            stateList = [Select id,SP_Paralegal__c,SP_MCM_Attorney__c FROM State_Profile__c WHERE Id IN: userid1];
            for(Account acc : accountList){
                mapAccount.put(acc.id,acc.Name);
            }
            
            if(mapAccount.size() >0){
                for(Escalated_Contested_Matters__c ecmObj : Trigger.new){
                    for(Account acList :accountList){
                        if(!mapAccount.get(ecmObj.ECM_Organization_Name__c).contains('CA137') || 
                            !mapAccount.get(ecmObj.ECM_Organization_Name__c).contains('NY64')){
                            ecmObj.ECM_Paralegal_Assignment__c  = acList.Paralegal__c;
                            
                                if(ecmObj.ECM_Attorney_Approval_Needed__c == true){
                                ecmObj.ECM_Attorney_Assignment__c = acList.MCM_Attorney__c;
                            }
                        }
                    }
                    for(State_Profile__c state : stateList){
                        if(mapAccount.get(ecmObj.ECM_Organization_Name__c).contains('CA137') || 
                            mapAccount.get(ecmObj.ECM_Organization_Name__c).contains('NY64')){
                            ecmObj.ECM_Paralegal_Assignment__c  = state.SP_Paralegal__c;
                            
                            if(ecmObj.ECM_Attorney_Approval_Needed__c == true){
                                ecmObj.ECM_Attorney_Assignment__c = state.SP_MCM_Attorney__c;
                            }
                        }
                    }
                }
            }
        }
    }
}