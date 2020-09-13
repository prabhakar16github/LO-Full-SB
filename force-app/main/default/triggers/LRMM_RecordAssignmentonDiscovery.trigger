trigger LRMM_RecordAssignmentonDiscovery on Discovery__c (before insert,before update){
    List<Discovery__c> Claimlist = new List<Discovery__c>();
    List<Task> tasklist1 = new List<Task>();
    Set<Id> userid = new Set<Id>();
    Set<Id> userid1 = new Set<Id>();
    List<Account> accountList = new List<Account>();
    List<State_Profile__c> stateList = new List<State_Profile__c>();
    Map<Id,String> mapAccount = new Map<Id,String>();
    
    for(Discovery__c counter : Trigger.new){
        if(trigger.isInsert){
            userid.add(counter.DY_Organization_Name__c);
            userid1.add(counter.DY_State_Filed__c);
        }
        /**************Added on 7-Nov-2019 by Prabhakar Joshi ************************/
        if(trigger.isUpdate){
            if(counter.DY_Attorney_Review_Needed__c){
                if(trigger.oldMap.get(counter.Id).DY_Attorney_Assignment__c == NULL){
                    userid.add(counter.DY_Organization_Name__c);
                    userid1.add(counter.DY_State_Filed__c);
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
            for(Discovery__c cclaim : Trigger.new){
            for(Account acList :accountList){
                if(!mapAccount.get(cclaim.DY_Organization_Name__c).contains('CA137') 
                   || !mapAccount.get(cclaim.DY_Organization_Name__c).contains('NY64')){
                    cclaim.DY_Paralegal_Assignment__c = acList.Paralegal__c;
                    if(cclaim.DY_Attorney_Review_Needed__c == true){
                        cclaim.DY_Attorney_Assignment__c = acList.MCM_Attorney__c;
                    }
                }
            }
            for(State_Profile__c state : stateList){
                if(mapAccount.get(cclaim.DY_Organization_Name__c).contains('CA137') 
                   || mapAccount.get(cclaim.DY_Organization_Name__c).contains('NY64')){
                    cclaim.DY_Paralegal_Assignment__c = state.SP_Paralegal__c;
                    if(cclaim.DY_Attorney_Review_Needed__c == true){
                        cclaim.DY_Attorney_Assignment__c = state.SP_MCM_Attorney__c;
                    }
                }
            }
        }
    }
}