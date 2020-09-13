/*
	* @ Class Name 		: 	AppealTriggerHandler
	* @ Description 	: 	Handler class for Appeal Trigger
	* @ Created By 		: 	Prabhakar Joshi
	* @ Created Date	: 	22-July-2020 
*/

public class AppealTriggerHandler {
    /* @ Method to process the before Insert operations. */
    public void beforeInsert(List<Appeal__c> triggerNew){
        this.populateAttorneyAssignmentOnAppeal(triggerNew,NULL);
    }
    /* @ Method to process the before Update operations. */
    public void beforeUpdate(List<Appeal__c> triggerNew,Map<Id,Appeal__c> oldMap){
        this.populateAttorneyAssignmentOnAppeal(triggerNew,oldMap);
    }
    
    
    /* @ Method to process the after Insert operations. */
    public void afterInsert(List<Appeal__c> triggerNew){
        
    }
    
    /* @ Method to process the after Update operations. */
    public void afterUpdate(List<Appeal__c> triggerNew,Map<Id,Appeal__c> oldMap){
        this.populateResolutionFields(triggerNew,oldMap);
    }
    
    private void populateAttorneyAssignmentOnAppeal(List<Appeal__c> triggerNew,Map<Id,Appeal__c> oldMap){
        Map<Id,Account> orgMap = new Map<Id,Account>();
        Map<Id,State_Profile__c> stateProfileMap = new Map<Id,State_Profile__c>();
        for(Appeal__c ap : triggerNew){
            if(ap.AP_Organization_Name__c == NULL && ap.AP_State_Filed__c == NULL){
                continue;
            }
            if(ap.AP_Organization_Name__c != NULL){
                orgMap.put(ap.AP_Organization_Name__c,NULL);
            }
            if(ap.AP_State_Filed__c !=  NULL){
                stateProfileMap.put(ap.AP_State_Filed__c,NULL);
            }
        }
        
        if(orgMap.keySet().isEmpty() && stateProfileMap.keySet().isEmpty()){
            return;
        }
        
        
        
        if(!orgMap.keySet().isEmpty()){
            for(Account acc : [SELECT id,Name,Paralegal__c,MCM_Attorney__c 
                               FROM Account 
                               WHERE Id IN: orgMap.keySet()]){
                                   if(orgMap.containsKey(acc.Id)){
                                       orgMap.put(acc.Id, acc);
                                   }
                               }
        }
        
        
        
        if(!stateProfileMap.keySet().isEmpty()){
            for(State_Profile__c state : [SELECT Id,SP_Paralegal__c,SP_MCM_Attorney__c 
                                          FROM State_Profile__c 
                                          WHERE Id IN: stateProfileMap.keySet()]){
                                              if(stateProfileMap.containsKey(state.Id)){
                                                  stateProfileMap.put(state.Id, state);
                                              }
                                          }
        }
        
        if(orgMap.keySet().isEmpty() && stateProfileMap.keySet().isEmpty()){
            return;
        }
        
        for(Appeal__c ap : triggerNew){
            if(ap.AP_Organization_Name__c == NULL && ap.AP_State_Filed__c == NULL){
                continue;
            }
            Id paralegalId;
            Id attorneyId;
            if(orgMap.get(ap.AP_Organization_Name__c).Name.contains('CA137') || orgMap.get(ap.AP_Organization_Name__c).Name.contains('NY64')){
                paralegalId = stateProfileMap.get(ap.AP_State_Filed__c).SP_Paralegal__c;
                if(ap.AP_Attorney_Approval_Needed__c){
                    attorneyId = stateProfileMap.get(ap.AP_State_Filed__c).SP_MCM_Attorney__c;
                }
            }else{
                paralegalId = orgMap.get(ap.AP_Organization_Name__c).Paralegal__c;
                if(ap.AP_Attorney_Approval_Needed__c){
                    attorneyId = orgMap.get(ap.AP_Organization_Name__c).MCM_Attorney__c;
                }
            }
            ap.AP_Paralegal_Assignment__c = paralegalId;
            ap.AP_Attorney_Assignment__c = attorneyId;
        }
    }
    
    
    private void populateResolutionFields(List<Appeal__C> triggerNew,Map<Id,Appeal__C> oldMap){
        List<String> appealIdFillList = new List<String>();
        List<String> appealIdBlankList = new List<String>();
        Set<String> CADIdFillSet = new Set<String>();
        Set<String> CADIdBlankSet = new Set<String>();
        
        for(Appeal__C appealObj : triggerNew){
            Appeal__C oldAppealObj = oldMap.get(appealObj.id);
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
        
        if(!appealIdFillList.isEmpty()){
            LRMMTriggerHelper.populateResolutionFields(appealIdFillList,'Pending Resolution','Closed');
        } 
        if(!appealIdBlankList.isEmpty()){
            LRMMTriggerHelper.populateResolutionFields(appealIdBlankList,'Closed','Pending Resolution');
        } 
    }
}