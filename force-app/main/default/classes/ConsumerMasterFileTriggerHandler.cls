/*
* @ Class Name 		: ConsumerMasterFileTriggerHandler
* @ Description 	: Handler Class for ConsumerMasterFileTrigger
* @ Created By 		: Vaibhav Jain
* @ Created Date	: 31-July-2020 
*/

public class ConsumerMasterFileTriggerHandler {
    /* Method to process the before Insert operations. */
    public void beforeInsert(List<Consumer_Master_File__c> triggerNew){
        /* Calling the Method to Prevent the duplicate Consumer Master File records with combination of same FirstName+lastName+DOB+SSN*/
        this.preventDuplicateCMRecords(triggerNew);
    }
    
    /* @ Definition of the Method to Prevent the duplicate Consumer Master File records with combination of same FirstName+lastName+DOB+SSN. */
    /* @ Calling from before insert and before Update. */
    private void preventDuplicateCMRecords(List<Consumer_Master_File__c> triggerNew){
        if(triggerNew.isEmpty()){
            return;
        }
        
        Map<String,Id> uniqueKeyMap = new Map<String,Id>();
        for(Consumer_Master_File__c cmf : triggerNew){
            if(cmf.Consumer_First_Name__c == NULL || cmf.Consumer_Last_Name__c == NULL 
               || cmf.Date_of_Birth__c == NULL || cmf.SSN__c == NULL){
                   continue;
               }
            String uniqueKey = cmf.Consumer_First_Name__c+'@@'+cmf.Consumer_Last_Name__c+'@@'+cmf.Date_of_Birth__c+'@@'+cmf.SSN__c;
            uniqueKeyMap.put(uniqueKey,NULL);
        }
        for(Consumer_Master_File__c cmf : [SELECT id,Consumer_First_Name__c,Consumer_Last_Name__c,
                                           Date_of_Birth__c,SSN__c FROM Consumer_Master_File__c 
                                           WHERE SSN__c != '000-00-0000' 
                                           AND Consumer_First_Name__c != NULL 
                                           AND Consumer_Last_Name__c != NULL 
                                           AND Date_of_Birth__c != NULL 
                                           AND SSN__c != NULL  ]){
                                               
                                               String uniqueKey = cmf.Consumer_First_Name__c+'@@'+cmf.Consumer_Last_Name__c+'@@'+cmf.Date_of_Birth__c+'@@'+cmf.SSN__c;
                                               if(uniqueKeyMap.containsKey(uniqueKey)){
                                                   uniqueKeyMap.put(uniqueKey, cmf.Id);
                                               }
                                           }
        
        for(Consumer_Master_File__c cmf : triggerNew){
            if(cmf.Consumer_First_Name__c == NULL || cmf.Consumer_Last_Name__c == NULL || cmf.Date_of_Birth__c == NULL || cmf.SSN__c == NULL){
                   continue;
               }
            
            String uniqueKey = cmf.Consumer_First_Name__c+'@@'+cmf.Consumer_Last_Name__c+'@@'+cmf.Date_of_Birth__c+'@@'+cmf.SSN__c;
            if(uniqueKeyMap.containsKey(uniqueKey) && uniqueKeyMap.get(uniqueKey) != NULL){
                cmf.addError('A Consumer Master File record already exists for a Consumer with the same first & last name, DOB and SSN.');
            }
        }
    }
}