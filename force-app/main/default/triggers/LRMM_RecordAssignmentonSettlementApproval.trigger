trigger LRMM_RecordAssignmentonSettlementApproval on Settlement_Approval__c (before insert, before update, after update) {
    
    if(Trigger.isUpdate && Trigger.isAfter && !System.isFuture()){
        List<String> saIdFillList = new List<String>();
        List<String> saIdBlankList = new List<String>();
        Set<String> CADIdFillSet = new Set<String>();
        Set<String> CADIdBlankSet = new Set<String>();
        
        for(Settlement_Approval__c saObj : Trigger.new){
            Settlement_Approval__c oldSAObj = Trigger.oldMap.get(saObj.id);
            if(oldSAObj.Settlement_Approval_Status__c == 'Pending Resolution' && saObj.Settlement_Approval_Status__c == 'Closed'){
                if(!CADIdFillSet.contains(saObj.SA_Consumer_Account_Details__c)){
                    CADIdFillSet.add(saObj.SA_Consumer_Account_Details__c);
                    saIdFillList.add(saObj.id);
                }
            }else if(oldSAObj.Settlement_Approval_Status__c == 'Closed' && saObj.Settlement_Approval_Status__c == 'Pending Resolution' &&
                     saObj.SA_Resolution_Amount__c == null && saObj.SA_Resolution_Date__c == null && 
                     (saObj.SA_Resolution_Notes__c == null || saObj.SA_Resolution_Notes__c == '') && 
                     saObj.SA_Resolution_Payment_To__c == null && saObj.SA_Resolution_Type__c == null){
                         if(!CADIdBlankSet.contains(saObj.SA_Consumer_Account_Details__c)){
                             CADIdBlankSet.add(saObj.SA_Consumer_Account_Details__c);
                             saIdBlankList.add(saObj.id);
                         }
                     }
        }
        
        if(!saIdFillList.isEmpty()) LRMMTriggerHelper.populateResolutionFields(saIdFillList,'Pending Resolution','Closed');
        if(!saIdBlankList.isEmpty()) LRMMTriggerHelper.populateResolutionFields(saIdBlankList,'Closed','Pending Resolution');
    }
    
    if((Trigger.isUpdate || Trigger.isInsert) && Trigger.isBefore){
        List<Settlement_Approval__c> Claimlist = new List<Settlement_Approval__c>();
        List<Task> tasklist1 = new List<Task>();
        Set<Id> userid = new Set<Id>();
        Set<Id> userid1 = new Set<Id>();
        List<Account> accountList = new List<Account>();
        List<State_Profile__c> stateList = new List<State_Profile__c>();
        Map<Id,String> mapAccount = new Map<Id,String>();
        
        for(Settlement_Approval__c counter : Trigger.new){
            if(trigger.isInsert){
                userid.add(counter.SA_Organization_Name__c);
                userid1.add(counter.SA_State_Filed__c);
            }
            /**************Added on 7-Nov-2019 by Prabhakar Joshi ************************/
            if(trigger.isUpdate){
                if(counter.SA_Attorney_Approval_Needed__c){
                    if(trigger.oldMap.get(counter.Id).SA_Attorney_Assignment__c == NULL){
                        userid.add(counter.SA_Organization_Name__c);
                        userid1.add(counter.SA_State_Filed__c);
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
                for(Settlement_Approval__c cclaim : Trigger.new){
                    for(Account acList :accountList){
                        if(!mapAccount.get(cclaim.SA_Organization_Name__c).contains('CA137') 
                           || !mapAccount.get(cclaim.SA_Organization_Name__c).contains('NY64')){
                               cclaim.SA_Paralegal_Assignment__c  = acList.Paralegal__c;
                               if(cclaim.SA_Attorney_Approval_Needed__c == true){
                                   cclaim.SA_Attorney_Assignment__c = acList.MCM_Attorney__c;
                               }
                           }
                    }
                    for(State_Profile__c state : stateList){
                        if(mapAccount.get(cclaim.SA_Organization_Name__c).contains('CA137') 
                           || mapAccount.get(cclaim.SA_Organization_Name__c).contains('NY64')){
                               cclaim.SA_Paralegal_Assignment__c  = state.SP_Paralegal__c;
                               if(cclaim.SA_Attorney_Approval_Needed__c == true){
                                   cclaim.SA_Attorney_Assignment__c = state.SP_MCM_Attorney__c;
                               }
                           }
                    }
                }
        }
    }
}