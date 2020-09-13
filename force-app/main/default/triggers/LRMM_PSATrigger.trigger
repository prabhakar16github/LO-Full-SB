trigger LRMM_PSATrigger on Purchase_and_Sales_Agreement__c (after update) {
    
    if(Trigger.isUpdate && Trigger.isAfter && !System.isFuture()){
        List<String> psaIdFillList = new List<String>();
        List<String> psaIdBlankList = new List<String>();
        Set<String> CADIdFillSet = new Set<String>();
        Set<String> CADIdBlankSet = new Set<String>();
        
        for(Purchase_and_Sales_Agreement__c psaObj : Trigger.new){
            Purchase_and_Sales_Agreement__c oldPSAObj = Trigger.oldMap.get(psaObj.id);
            if(oldPSAObj.PSA_PSA_Status__c == 'Pending Resolution' && psaObj.PSA_PSA_Status__c == 'Closed'){
                if(!CADIdFillSet.contains(psaObj.PSA_Consumer_Account_Detail_Name__c)){
                    CADIdFillSet.add(psaObj.PSA_Consumer_Account_Detail_Name__c);
                    psaIdFillList.add(psaObj.id);
                }
            }else if(oldPSAObj.PSA_PSA_Status__c == 'Closed' && psaObj.PSA_PSA_Status__c == 'Pending Resolution' &&
                    psaObj.PSA_Resolution_Amount__c == null && psaObj.PSA_Resolution_Date__c == null && 
                    (psaObj.PSA_Resolution_Notes__c == null || psaObj.PSA_Resolution_Notes__c == '') && 
                    psaObj.PSA_Resolution_Payment_To__c == null && psaObj.PSA_Resolution_Type__c == null){
                if(!CADIdBlankSet.contains(psaObj.PSA_Consumer_Account_Detail_Name__c)){
                    CADIdBlankSet.add(psaObj.PSA_Consumer_Account_Detail_Name__c);
                    psaIdBlankList.add(psaObj.id);
                }
            }
        }
        if(!psaIdFillList.isEmpty()) LRMMTriggerHelper.populateResolutionFields(psaIdFillList,'Pending Resolution','Closed');
        if(!psaIdBlankList.isEmpty()) LRMMTriggerHelper.populateResolutionFields(psaIdBlankList,'Closed','Pending Resolution');
    }
    
}