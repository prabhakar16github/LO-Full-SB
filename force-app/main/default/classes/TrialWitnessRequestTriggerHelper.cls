/*
	* @ Class Name 			: 	TrialWitnessRequestTriggerHelper
 	* @ Description 		: 	Handler Class for TrialWitnessRequestTrigger.
 	* @ Modified By			: 	Prabhakar Joshi
 	* @ LastModifiedDate 	: 	23-July-2020 
*/

public without sharing class TrialWitnessRequestTriggerHelper {
	/* @ Method definition which invoke on before Insert. */
    public void beforeInsert(List<Trial_Witness_Request__c> newList){
        /* @ Added on 29-July-2020 By Prabhakar Joshi. */
        /* @ Calling method to populate Attorney Assignment. */
        this.populateAttorneyAssignment(newList,NULL);
    }
    
    /* @ Method definition which invoke on before Update. */
    public void beforeUpdate(List<Trial_Witness_Request__c> newList,Map<Id,Trial_Witness_Request__c> oldMap){
        /* @ Added on 29-July-2020 By Prabhakar Joshi. */
        /* @ Calling method to populate Attorney Assignment. */
        this.populateAttorneyAssignment(newList,oldMap);
    }
    /* @ Method definition which invoke on after Insert. */
    public void afterInsert(List<Trial_Witness_Request__c> newList, Map<Id, Trial_Witness_Request__c> newMap){
    	this.updateTrialWitnessSubmitted(newList);
    }
    
    /* @ Method definition which invoke on after Update. */
    public void afterUpdate(List<Trial_Witness_Request__c> triggerNew, Map<Id, Trial_Witness_Request__c> oldMap){
        /* @ Added on 23-July-2020 By Prabhakar Joshi. */
        /* @ Calling method to send the notification. */
        this.sendMissingAttachmentNotificationForLW(triggerNew,oldMap);
        /* @ Added on 29-July-2020 By Prabhakar Joshi. */
        /* @ Calling method to populate the recolution fields on CAD. */
        this.populateResolutionFields(triggerNew,oldMap);
    }
    
    private void updateTrialWitnessSubmitted(List<Trial_Witness_Request__c> trialWitnessRequests){
    	Set<Id> cadIds = new Set<Id>(); 
    	for(Trial_Witness_Request__c trialWitnessRequest : trialWitnessRequests){
			cadIds.add(trialWitnessRequest.TW_Consumer_Account_Records__c);	
    	}
    	
    	List<Consumer_Account_Details__c> consumerAccountDetails = [SELECT Id, Name, (SELECT Id FROM Appeals__r LIMIT 1), 
    																	(SELECT Id FROM Settlement_Approval__r LIMIT 1),
    																	(SELECT Id FROM Business_Record_Affidavit__r LIMIT 1),
    																	(SELECT Id FROM Purchase_and_Sales_Agreement__r LIMIT 1),
    																	(SELECT Id FROM Escalated_Contested_Matters__r LIMIT 1),
    																	(SELECT Id FROM Counterclaims__r LIMIT 1),
    																	(SELECT Id FROM Discoverys__r LIMIT 1) 
    																FROM Consumer_Account_Details__c 
    																WHERE Id IN :cadIds];
		
		for(Consumer_Account_Details__c consumerAccountDetail : consumerAccountDetails){
			if(this.isExistingLrmmRecordExist(consumerAccountDetail)){
				consumerAccountDetail.Trial_Witness_Submitted__c = true;
			}
		}
		
		update consumerAccountDetails;    																
    }
    
    private Boolean isExistingLrmmRecordExist(Consumer_Account_Details__c consumerAccountDetail){
    	Boolean foundLRMMRecord = false;
			if((consumerAccountDetail.Appeals__r != null && consumerAccountDetail.Appeals__r.size() > 0) 
				|| (consumerAccountDetail.Settlement_Approval__r != null && consumerAccountDetail.Settlement_Approval__r.size() > 0)
				|| (consumerAccountDetail.Business_Record_Affidavit__r != null && consumerAccountDetail.Business_Record_Affidavit__r.size() > 0)
				|| (consumerAccountDetail.Purchase_and_Sales_Agreement__r != null && consumerAccountDetail.Purchase_and_Sales_Agreement__r.size() > 0)
				|| (consumerAccountDetail.Escalated_Contested_Matters__r != null && consumerAccountDetail.Escalated_Contested_Matters__r.size() > 0)
				|| (consumerAccountDetail.Counterclaims__r != null && consumerAccountDetail.Counterclaims__r.size() > 0)
				|| (consumerAccountDetail.Discoverys__r != null && consumerAccountDetail.Discoverys__r.size() > 0)){
					foundLRMMRecord = true;
				}
		return foundLRMMRecord;				
    }
    
    /* @ Added on 23-July-2020 By Prabhakar Joshi. */
    /* @ Calling from afterUpdate. */
    /* @ Method definition to send the notification. */
    private void sendMissingAttachmentNotificationForLW(List<Trial_Witness_Request__c> triggerNew, Map<Id, Trial_Witness_Request__c> oldMap){
        Set<Id> recordIdSet = new Set<Id>();
        for(Trial_Witness_Request__c tw : triggerNew){
            if(LW_MissingAttNotificationScheduler.isDataValid(tw, oldMap.get(tw.Id))){
                recordIdSet.add(tw.Id);
            }
        }
        if(recordIdSet.isEmpty()){
            return;
        }
        
        /* For sending & scheduling the notifications. */
        LW_MissingAttNotificationScheduler.scheduleNotification(recordIdSet);
    }
    
    /* @ Added on 29-July-2020 By Prabhakar Joshi. */ 
    /* @ Calling from beforeInsert & beforeUpdate. */
    /* @ Method definition to populate Attorney Assignment. */
    private void populateAttorneyAssignment(List<Trial_Witness_Request__c> triggerNew,Map<Id,Trial_Witness_Request__c> oldMap){
        Map<String,Schema.RecordTypeInfo> recordTypeMap = Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName();
        
        Set<Id> recordTypeIdSet = new Set<Id>();
        recordTypeIdSet.add(recordTypeMap.get('Live Witness Request Step I').getRecordTypeId());
        recordTypeIdSet.add(recordTypeMap.get('Live Witness Request Step II').getRecordTypeId());
        recordTypeIdSet.add(recordTypeMap.get('Live Witness Request Step III').getRecordTypeId());
        
        if(trigger.isUpdate && oldMap != NULL){
            List<Trial_Witness_Request__c> filteredList = new List<Trial_Witness_Request__c>();
            for(Trial_Witness_Request__c tw : triggerNew){
                if(tw.LW_Attorney_Approval_Needed__c && oldMap.get(tw.Id).LW_Attorney_Assignment__c ==  NULL){
                    filteredList.add(tw);
                }
            }
            triggerNew = filteredList;
        }
        Map<Id,Account> orgMap = new Map<Id,Account>();
        Map<Id,State_Profile__c> stateProfileMap = new Map<Id,State_Profile__c>();
        
        for(Trial_Witness_Request__c tw : triggerNew){
            if(!recordTypeIdSet.contains(tw.RecordTypeId) && !tw.LW_Attorney_Approval_Needed__c){
                continue;
            }
            if(tw.OrganizationName__c == NULL && tw.State_Filed_State_Profile__c == NULL){
                continue;
            }
            if(tw.OrganizationName__c != NULL){
                orgMap.put(tw.OrganizationName__c,NULL);
            }
            if(tw.State_Filed_State_Profile__c !=  NULL){
                stateProfileMap.put(tw.State_Filed_State_Profile__c,NULL);
            }
        }
        
        if(orgMap.keySet().isEmpty() && stateProfileMap.keySet().isEmpty()){
            return;
        }
        
        
        
        if(!orgMap.keySet().isEmpty()){
            for(Account acc : [SELECT Id,Name,Paralegal__c,MCM_Attorney__c 
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
        
        for(Trial_Witness_Request__c tw : triggerNew){
            if(tw.OrganizationName__c == NULL && tw.State_Filed_State_Profile__c == NULL){
                continue;
            }
            if(!recordTypeIdSet.contains(tw.RecordTypeId) || !tw.LW_Attorney_Approval_Needed__c || tw.LW_Attorney_Assignment__c != NULL){
                continue;
            }
            
            Id paralegalId;
            Id attorneyId;
            if(orgMap.get(tw.OrganizationName__c).Name.contains('CA137') || orgMap.get(tw.OrganizationName__c).Name.contains('NY64')){
                attorneyId = stateProfileMap.get(tw.State_Filed_State_Profile__c).SP_MCM_Attorney__c;
                
            }else{
                attorneyId = orgMap.get(tw.OrganizationName__c).MCM_Attorney__c;
            }
            tw.LW_Attorney_Assignment__c = attorneyId;
        }
    }

    /* @ Added on 29-July-2020 By Prabhakar Joshi. */
    /* @ Calling from afterUpdate. */
    /* @ Method definition to populate the resolution fields on CAD. */
    private void populateResolutionFields(List<Trial_Witness_Request__c> triggerNew,Map<Id,Trial_Witness_Request__c> oldMap){
        List<String> lwIdFillList = new List<String>();
        List<String> lwIdBlankList = new List<String>();
        Set<String> CADIdFillSet = new Set<String>();
        Set<String> CADIdBlankSet = new Set<String>();
        
        for(Trial_Witness_Request__c lwObj : triggerNew){
            Trial_Witness_Request__c oldLWObj = oldMap.get(lwObj.id);
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
        
        if(!lwIdFillList.isEmpty()){
            LRMMTriggerHelper.populateResolutionFields(lwIdFillList,'Pending Resolution','Closed');
        }
            
        if(!lwIdBlankList.isEmpty()) {
            LRMMTriggerHelper.populateResolutionFields(lwIdBlankList,'Closed','Pending Resolution');
        }
    }
}