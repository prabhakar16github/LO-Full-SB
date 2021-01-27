/*
	* @ Class Name 		: CallMonitoringTriggerHandler
 	* @ Description 	: Handler Class for CallMonitoringTrigger
 	* @ Created By 		: Prabhakar Joshi
 	* @ Created Date	: 25-May-2020 
*/
public class CallMonitoringTriggerHandler {
    /* Method to process the before Insert operations. */
    public void beforeInsert(List<Call_Monitoring__c> triggerNew){
        /* Calling the Method to Prevent the duplicate Call Monitoring records with combination of same Firm+ Month+year. */
        this.preventDuplicateCMRecords(triggerNew,NULL);
        /* Calling the Method to populate the Organization Name on Call Monitoring (Materials) Records only. */
        this.populateOrgNameOnCM(triggerNew);
    }
     /* Method to process the before Update operations. */
    public void beforeUpdate(List<Call_Monitoring__c> triggerNew,Map<Id,Call_Monitoring__c> oldMap){
        /* Calling the Method with old Values to Prevent the duplicate Call Monitoring records with combination of same Firm+ Month+year. */
        this.preventDuplicateCMRecords(triggerNew,oldMap);
    }
    
   
    /* Method to process the after Insert operations. */
    public void afterInsert(List<Call_Monitoring__c> triggerNew){
        this.updateMaterialResultFound(triggerNew);
    }
    
    /* Method to process the after Update operations. */
    public void afterUpdate(List<Call_Monitoring__c> triggerNew,Map<Id,Call_Monitoring__c> oldMap){
        
    }
    
    /* @ Definition of the Method to Prevent the duplicate Call Monitoring records with combination of same Firm+ Month+year. 
	   @ Calling from before insert and before Update. */
    private void preventDuplicateCMRecords(List<Call_Monitoring__c> triggerNew,Map<Id,Call_Monitoring__c> oldMap){
        
        if(trigger.isBefore && trigger.isUpdate && oldMap != NULL){
            List<Call_Monitoring__c> filteredRecords = new List<Call_Monitoring__c>();
            for(Call_Monitoring__c cm : triggerNew){
                if(cm.Organization_Name_CM__c != oldMap.get(cm.Id).Organization_Name_CM__c
                   || cm.Reporting_Year_CM__c != oldMap.get(cm.Id).Reporting_Year_CM__c
                   || cm.Reporting_Month_CM__c != oldMap.get(cm.Id).Reporting_Month_CM__c){
                       filteredRecords.add(cm);
                   }
            }
            triggerNew = filteredRecords;
        }
        
        if(triggerNew.isEmpty()){
            return;
        }
        
        Id cmQARecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId();
        Id cmLogRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Log').getRecordTypeId();
        
        Set<Id> recordTypeIdSet = new Set<Id>{cmQARecordTypeId,cmLogRecordTypeId};
        
        Set<Id> firmIdSet = new Set<Id>();
        Map<String,Call_Monitoring__c> uniqueKeyMAP = new Map<String,Call_Monitoring__c>();
        
        for(Call_Monitoring__c cm : triggerNew){
            if(!recordTypeIdSet.contains(cm.RecordTypeId) || cm.Organization_Name_CM__c == NULL || cm.Reporting_Year_CM__c == NULL || cm.Reporting_Month_CM__c == NULL){
                continue;
            }
            
            firmIdSet.add(cm.Organization_Name_CM__c);
            String uniqueKey = cm.RecordTypeId+'@@'+cm.Organization_Name_CM__c + '@@' + cm.Reporting_Year_CM__c + '@@' + cm.Reporting_Month_CM__c;
            uniqueKeyMAP.put(uniqueKey, NULL);
        }
        
        if(firmIdSet.isEmpty() || uniqueKeyMAP.keySet().isEmpty()){
            return;
        }
        for(Call_Monitoring__c cm : [SELECT Id,Organization_Name_CM__c,Reporting_Year_CM__c,Reporting_Month_CM__c,
                                     RecordTypeId
                                     FROM Call_Monitoring__c
                                     WHERE recordTypeId IN :recordTypeIdSet
                                     AND Organization_Name_CM__c IN :firmIdSet
                                     AND Id NOT IN :triggerNew]){
                                         
                                         String uniqueKey = cm.RecordTypeId+'@@'+cm.Organization_Name_CM__c + '@@' + cm.Reporting_Year_CM__c + '@@' + cm.Reporting_Month_CM__c;
                                         if(uniqueKeyMAP.containsKey(uniqueKey)){
                                             uniqueKeyMAP.put(uniqueKey,cm);
                                         }
                                     }
        for(Call_Monitoring__c cm : triggerNew){
            if(!recordTypeIdSet.contains(cm.RecordTypeId) || cm.Organization_Name_CM__c == NULL || cm.Reporting_Year_CM__c == NULL || cm.Reporting_Month_CM__c == NULL){
                continue;
            }
            String uniqueKey = cm.RecordTypeId+'@@'+cm.Organization_Name_CM__c + '@@' + cm.Reporting_Year_CM__c + '@@' + cm.Reporting_Month_CM__c;
            if(uniqueKeyMAP.containsKey(uniqueKey) && uniqueKeyMAP.get(uniqueKey) != NULL){
                cm.addError('Only one record can be created for each month/year combination related to this Organization.');
            }
        }
        
    }
    
    /* @ Definition of the Method to populate the Organization Name on Call Monitoring (Materials) Records only. 
	   @ Calling from before insert. */
    private void populateOrgNameOnCM(List<Call_Monitoring__c> triggerNew){
        List<User> currentUser = [SELECT Id,Name,ContactId,IsPortalEnabled 
                                  FROM User
                                  WHERE Id =:UserInfo.getUserId()
                                  LIMIT 1];
        if(!currentUser[0].IsPortalEnabled || currentUser[0].ContactId == NULL){
            return;
        }
        Map<Id,Id> conIdToAccIdMap = new Map<Id,Id>();
        for(Contact con : [SELECT Id,Name,Community_User__c,AccountId
                           FROM Contact
                           WHERE Id =:currentUser[0].ContactId 
                           AND Community_User__c = true]){
                               conIdToAccIdMap.put(con.Id,con.AccountId);
                           }
        
        Id cmMaterialRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Materials').getRecordTypeId();
        for(Call_Monitoring__c cm : triggerNew){
            if(cm.RecordTypeId != cmMaterialRecordTypeId){
                continue;
            }
            cm.Organization_Name_CM__c = conIdToAccIdMap.get(currentUser[0].ContactId);
        }
    }
    
    /* @ Definition of the Method to Update the 'Material_Record_Received__c' checkbox on the CM QA record if the CM Material record found for that QA record. 
	   @ Calling from after insert. */
    private void updateMaterialResultFound(List<Call_Monitoring__c> triggerNew){
        
        Id cm_MatRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Materials').getRecordTypeId();
            
            Map<String,Call_Monitoring__c> uniqueKeyToQAMap = new Map<String,Call_Monitoring__c>();
        Set<Id> firmIdSet = new Set<Id>();
        Set<String> yearSet = new Set<String>();
        Set<String> monthSet = new Set<String>();
        
        
        
        for(Call_Monitoring__c cm : triggerNew){
            if(cm.RecordTypeId != cm_MatRecordTypeId || cm.Organization_Name_CM__c == NULL || cm.Reporting_Year_CM__c == NULL || cm.Reporting_Month_Materials__c == NULL){
                continue;
            }
            firmIdSet.add(cm.Organization_Name_CM__c);
            yearSet.add(cm.Reporting_Year_CM__c);
            monthSet.add(cm.Reporting_Month_Materials__c);
            
            String uniqueKey = cm.Organization_Name_CM__c + '@@' + cm.Reporting_Year_CM__c + '@@' + cm.Reporting_Month_Materials__c;
            uniqueKeyToQAMap.put(uniqueKey,NULL);
        }
        
        if(uniqueKeyToQAMap.keySet().isEmpty())
            return;
        
        Id QA_RecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId();
        for(Call_Monitoring__c cm : [SELECT Id,Name,Organization_Name_CM__c,Reporting_Year_CM__c,Reporting_Month_CM__c,
                                     Material_Record_Received__c,OwnerId
                                     FROM Call_Monitoring__c
                                     WHERE RecordTypeId = :QA_RecordTypeId
                                     AND Organization_Name_CM__c IN :firmIdSet
                                     AND Reporting_Year_CM__c IN :yearSet
                                     AND Reporting_Month_CM__c IN :monthSet]){
                                        
                                        String uniqueKey = cm.Organization_Name_CM__c + '@@' + cm.Reporting_Year_CM__c + '@@' + cm.Reporting_Month_CM__c;
                                        if(uniqueKeyToQAMap.containsKey(uniqueKey)){
                                            uniqueKeyToQAMap.put(uniqueKey,cm);
                                        }
            
        }
        
        List<Call_Monitoring__c> cmListToUpdate = new List<Call_Monitoring__c>();
        for(Call_Monitoring__c cm : triggerNew){
            if(cm.RecordTypeId != cm_MatRecordTypeId || cm.Organization_Name_CM__c == NULL || cm.Reporting_Year_CM__c == NULL || cm.Reporting_Month_Materials__c == NULL){
                continue;
            }
            String uniqueKey = cm.Organization_Name_CM__c + '@@' + cm.Reporting_Year_CM__c + '@@' + cm.Reporting_Month_Materials__c;
            if(uniqueKeyToQAMap.get(uniqueKey) == NULL){
                continue;
            }
            if(uniqueKeyToQAMap.get(uniqueKey).Material_Record_Received__c)
                continue;
            
            cmListToUpdate.add(uniqueKeyToQAMap.get(uniqueKey));
        }
        
        if(cmListToUpdate.isEmpty())
            return;
        
        /* Query to get the System Admin User to update the owner of the QA record when the Material_Record_Received__c will get checked. */
       /* List<Profile> adminProfileList = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        if(adminProfileList.isEmpty())
            return;
        
        Id adminProfileId = adminProfileList[0].Id;
        List<User> userList = [SELECT Id,Name,Email,ProfileId
                               FROM User 
                               WHERE Name ='System Administrator' 
                               AND ProfileId = :adminProfileId
                               LIMIT 1];
        if(userList.isEmpty())
            return;
        */
        for(Call_Monitoring__c cmUpdate : cmListToUpdate){
            /* @ Material_Record_Received__c field will get checked when the Material record will submitted by community user.*/
            cmUpdate.Material_Record_Received__c = true;
            /* @ Updating the owner as System Admin if the Material_Record_Received__c will get checked.*/
            //cmUpdate.OwnerId = userList[0].Id;
        }
        update cmListToUpdate;
        
    }
}