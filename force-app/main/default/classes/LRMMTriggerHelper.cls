public class LRMMTriggerHelper{
    
    @future
    public static void populateResolutionFields(List<String> sourceIdList,String oldStatus, String newStatus){
        system.debug('oldStatus ' + oldStatus);
        system.debug('newStatus ' + newStatus);
        
        List<sObject> sourceList = new List<sObject>();
        List<String> objectList = new List<String>{'Appeal__c','Counterclaim__c','Escalated_Contested_Matters__c','Trial_Witness_Request__c',
                                                    'Settlement_Approval__c','Purchase_and_Sales_Agreement__c'};
        Map<String,String> LRMMObjShortDescMap = new Map<String,String>{'Appeal__c'=>'AP_;AP_Appeal_Status__c;AP_Consumer_Account_Record__c',
                                                                        'Counterclaim__c'=>'CC_;CC_Counterclaim_Status__c;CC_Consumer_Account_Detail_Name__c',
                                                                        'Escalated_Contested_Matters__c'=>'ECM_;ECM_Status__c;ECM_Consumer_Account_Detail_Name__c',
                                                                        'Settlement_Approval__c'=>'SA_;Settlement_Approval_Status__c;SA_Consumer_Account_Details__c',
                                                                        'Purchase_and_Sales_Agreement__c'=>'PSA_;PSA_PSA_Status__c;PSA_Consumer_Account_Detail_Name__c',
                                                                        'Trial_Witness_Request__c'=>'LW_;Status__c;TW_Consumer_Account_Records__c'};
        List<String> fieldsList = new List<String>{'Resolution_Amount__c','Resolution_Date__c','Resolution_Notes__c','Resolution_Payment_To__c',
                                                    'Resolution_Type__c'};


        Map<String,String> StatusFieldMap = new Map<String,String>();
        Map<String,String> CADFieldMap = new Map<String,String>();
        Map<String,String> LRMMObjectAPINameMap = new Map<String,String>();
        Map<String,String> LRMMFieldPrefixMap = new Map<String,String>();
        
        for(String objectName : objectList){
            LRMMObjectAPINameMap.put(schema.getGlobalDescribe().get(objectName).getDescribe().getKeyPrefix(),objectName);
            String prefix = LRMMObjShortDescMap.get(objectName).substringBefore(';');
            String statusField = LRMMObjShortDescMap.get(objectName).substringAfter(';').substringBefore(';');
            String cadField = LRMMObjShortDescMap.get(objectName).substringAfterLast(';');
            LRMMFieldPrefixMap.put(schema.getGlobalDescribe().get(objectName).getDescribe().getKeyPrefix(),prefix);
            StatusFieldMap.put(schema.getGlobalDescribe().get(objectName).getDescribe().getKeyPrefix(),statusField);
            CADFieldMap.put(schema.getGlobalDescribe().get(objectName).getDescribe().getKeyPrefix(),cadField);
        }
        
        for(String sourceId : sourceIdList){
            String sourceObjectName = LRMMObjectAPINameMap.get(sourceId.substring(0,3));
            String prefix = LRMMObjShortDescMap.get(sourceObjectName).substringBefore(';');
            String statusField = LRMMObjShortDescMap.get(sourceObjectName).substringAfter(';').substringBefore(';');
            String cadField = LRMMObjShortDescMap.get(sourceObjectName).substringAfterLast(';');
            
            String fieldNames = '';
            for(String field : fieldsList){
                fieldNames += prefix + field + ', ';
            }
            fieldNames += statusField + ', ';
            fieldNames += cadField + ', ';
            fieldNames = fieldNames.removeEnd(', ');
            
            String query = 'SELECT ' + fieldNames + ' FROM ' + sourceObjectName + ' WHERE id in: sourceIdList';
            sourceList.addAll(Database.query(query));
        }
        
        List<String> cadIdList = new List<String>();
        for(sObject sourceObj : sourceList){
            String keyPrefix = String.valueOf(sourceObj.id).substring(0,3);
            cadIdList.add(sourceObj.get(CADFieldMap.get(keyPrefix)) + '');
        }
        
        Map<String,List<sObject>> cadRecordsMap = new Map<String,List<sObject>>();
        for(String objectName : objectList){
            String prefix = LRMMObjShortDescMap.get(objectName).substringBefore(';');
            String statusField = LRMMObjShortDescMap.get(objectName).substringAfter(';').substringBefore(';');
            String cadField = LRMMObjShortDescMap.get(objectName).substringAfterLast(';');
            
            String fieldNames = '';
            for(String field : fieldsList){
                fieldNames += prefix + field + ', ';
            }
            fieldNames += statusField + ', ';
            fieldNames += cadField + ', ';
            fieldNames = fieldNames.removeEnd(', ');
            
            String query = 'SELECT ' + fieldNames + ' FROM ' + objectName + ' WHERE ' + statusField + '=: oldStatus AND ' + 
                            cadField + ' in: cadIdList AND id not in: sourceIdList';
            
            if(objectName == 'Trial_Witness_Request__c'){
                String TWRRecTypeId = Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName().get('Live Witness Request Step III').getRecordTypeId();
                query += ' AND Recordtypeid =: TWRRecTypeId';
            }
            
            for(sObject targetObj : Database.query(query)){
                List<sObject> tempList = cadRecordsMap.get(targetObj.get(cadField) + '');
                if(tempList == null) tempList = new List<sObject>();
                tempList.add(targetObj);
                cadRecordsMap.put(targetObj.get(cadField) + '',tempList);
            }
        }
        
        List<sObject> updateLRMMList = new List<sObject>();
        for(sObject sourceObj : sourceList){
            String keyPrefix = String.valueOf(sourceObj.id).substring(0,3);
            String fieldPrefix = LRMMFieldPrefixMap.get(keyPrefix);
            if(cadRecordsMap.get(sourceObj.get(CADFieldMap.get(keyPrefix))+ '') == null) continue;
            for(sObject targetObj : cadRecordsMap.get(sourceObj.get(CADFieldMap.get(keyPrefix))+ '')){
                String targetKeyPrefix = String.valueOf(targetObj.id).substring(0,3);
                String targetFieldPrefix = LRMMFieldPrefixMap.get(targetKeyPrefix);
                for(String field : fieldsList){
                    system.debug('source ' + sourceObj.get(fieldPrefix + field));
                    targetObj.put(targetFieldPrefix + field,sourceObj.get(fieldPrefix + field));
                    system.debug('target ' + targetObj.get(targetFieldPrefix + field));
                }
                targetObj.put(StatusFieldMap.get(targetKeyPrefix),newStatus);
                updateLRMMList.add(targetObj);
            }
        }
        system.debug(updateLRMMList);
        update updateLRMMList;
    }
}