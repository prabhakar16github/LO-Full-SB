trigger LRMM_CounterclaimTaskTrigger on Counterclaim__c (before insert,before update, after update) {
    
    if(Trigger.isUpdate && Trigger.isAfter && !System.isFuture()){
        List<String> ccIdFillList = new List<String>();
        List<String> ccIdBlankList = new List<String>();
        Set<String> CADIdFillSet = new Set<String>();
        Set<String> CADIdBlankSet = new Set<String>();
        
        for(Counterclaim__c ccObj : Trigger.new){
            Counterclaim__c oldCCObj = Trigger.oldMap.get(CCObj.id);
            if(oldCCObj.CC_Counterclaim_Status__c == 'Pending Resolution' && ccObj.CC_Counterclaim_Status__c == 'Closed'){
                if(!CADIdFillSet.contains(ccObj.CC_Consumer_Account_Detail_Name__c)){
                    CADIdFillSet.add(ccObj.CC_Consumer_Account_Detail_Name__c);
                    ccIdFillList.add(ccObj.id);
                }
            }else if(oldCCObj.CC_Counterclaim_Status__c == 'Closed' && ccObj.CC_Counterclaim_Status__c == 'Pending Resolution' &&
                    ccObj.CC_Resolution_Amount__c == null && ccObj.CC_Resolution_Date__c == null && 
                    (ccObj.CC_Resolution_Notes__c == null || ccObj.CC_Resolution_Notes__c == '') && 
                    ccObj.CC_Resolution_Payment_To__c == null && ccObj.CC_Resolution_Type__c == null){
                if(!CADIdBlankSet.contains(ccObj.CC_Consumer_Account_Detail_Name__c)){
                    CADIdBlankSet.add(ccObj.CC_Consumer_Account_Detail_Name__c);
                    ccIdBlankList.add(ccObj.id);
                }
            }
        }
        
        if(!ccIdFillList.isEmpty()) LRMMTriggerHelper.populateResolutionFields(ccIdFillList,'Pending Resolution','Closed');
        if(!ccIdBlankList.isEmpty()) LRMMTriggerHelper.populateResolutionFields(ccIdBlankList,'Closed','Pending Resolution');
    }
    
    if((Trigger.isUpdate || Trigger.isInsert) && Trigger.isBefore){
        List<Counterclaim__c> Claimlist = new List<Counterclaim__c>();
        List<Task> tasklist1 = new List<Task>();
        Set<Id> userid = new Set<Id>();
        Set<Id> userid1 = new Set<Id>();
        List<Account> accountList = new List<Account>();
        List<State_Profile__c> stateList = new List<State_Profile__c>();
        Map<Id,String> mapAccount = new Map<Id,String>();
            
        for(Counterclaim__c counter : Trigger.new){
            if(trigger.isInsert){
                userid.add(counter.CC_Organization_Name__c);
                userid1.add(counter.CC_State_Filed__c);    
            }
            /**************Added on 6-Nov-2019 by Prabhakar Joshi ************************/
            if(trigger.isUpdate){
                if(counter.CC_Attorney_Approval_Needed__c){
                    if(trigger.oldMap.get(counter.Id).CC_Attorney_Assignment__c == NULL){
                        userid.add(counter.CC_Organization_Name__c);
                        userid1.add(counter.CC_State_Filed__c);
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
            for(Counterclaim__c cclaim : Trigger.new)
            {
                for(Account acList :accountList)
                {
                    if(!mapAccount.get(cclaim.CC_Organization_Name__c).contains('CA137') || !mapAccount.get(cclaim.CC_Organization_Name__c).contains('NY64'))
                    {
                          cclaim.CC_Paralegal_Assignment__c = acList.Paralegal__c;
                       if(cclaim.CC_Attorney_Approval_Needed__c == true)
                       {
                          cclaim.CC_Attorney_Assignment__c = acList.MCM_Attorney__c;
                       }
                    }
                }
               for(State_Profile__c state : stateList)
               {
                    if(mapAccount.get(cclaim.CC_Organization_Name__c).contains('CA137') || mapAccount.get(cclaim.CC_Organization_Name__c).contains('NY64'))
                    {
                          cclaim.CC_Paralegal_Assignment__c = state.SP_Paralegal__c;
                       if(cclaim.CC_Attorney_Approval_Needed__c == true)
                       {
                          cclaim.CC_Attorney_Assignment__c = state.SP_MCM_Attorney__c;
                       }
                    }
               }
            }
          }
    }
}