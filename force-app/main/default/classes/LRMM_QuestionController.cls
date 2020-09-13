public class LRMM_QuestionController{
    
    public Case caseObj{get;set;}
    public sObject sObjLRMM{get;set;}
    public String recordLabel{get;set;}
    public String selectedObject{get;set;}
    
    private Map<String,String> LRMMObjShortDescMap = new Map<String,String>{'Appeal__c'=>'AP_','Business_Record_Affidavit__c'=>'BRA_',
                                                                            'Counterclaim__c'=>'CC_','Discovery__c'=>'DY_',
                                                                            'Escalated_Contested_Matters__c'=>'ECM_','Settlement_Approval__c'=>'SA_',
                                                                            'Purchase_and_Sales_Agreement__c'=>'PSA_','Trial_Witness_Request__c'=>''};
    
    public LRMM_QuestionController(){
        caseObj = new Case();
        String recordId = apexpages.currentpage().getparameters().get('id');
        for(String objectName : LRMMObjShortDescMap .keyset()){
            if(recordId.startsWith(Schema.getGlobalDescribe().get(objectName).getDescribe().getKeyPrefix())){
                selectedObject = Schema.getGlobalDescribe().get(objectName).getDescribe().getLocalName();
                recordLabel = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get('Name').getDescribe().getLabel();
            }
        }
        
        String fieldsPrefix = LRMMObjShortDescMap.get(selectedObject);
        String fieldNames = 'OwnerId, Name, Paralegal_Assignment__c, Organization_Name__c, Account_Number__c';
        if(selectedObject != 'Trial_Witness_Request__c'){
            fieldNames = fieldNames.replace('Organization_Name__c', fieldsPrefix + 'Organization_Name__c');
            fieldNames = fieldNames.replace('Paralegal_Assignment__c', fieldsPrefix + 'Paralegal_Assignment__c');
        }
        if(selectedObject == 'Trial_Witness_Request__c'){
            fieldNames = fieldNames.replace('Organization_Name__c', 'OrganizationName__c');
            fieldNames = fieldNames.replace('Paralegal_Assignment__c', 'LW_Paralegal_Assignment__c');
        }
        fieldNames = fieldNames.replace('Account_Number__c', fieldsPrefix + 'Account_Number__c');
        
        system.debug('selectedObject ' + selectedObject);
        system.debug('recordId ' + recordId);
        
        sObjLRMM = Database.query('SELECT ' + fieldNames + ' FROM ' + selectedObject + ' WHERE id =: recordId');
        User userObj = [SELECT ContactId FROM User WHERE id =: sObjLRMM.get('OwnerId')+''];
        
        caseObj.Status = 'New';
        caseObj.Reason = selectedObject.remove('__c').replace('_',' ');
        caseObj.Turn_Off_Auto_response__c = false;
        caseObj.Privileged__c = true;
        caseObj.Priority = 'Normal';
        caseObj.Type = 'LRMM - Question';
        caseObj.MCM_Account__c = sObjLRMM.get(fieldsPrefix  + 'Account_Number__c') + '';
        if(selectedObject != 'Trial_Witness_Request__c'){
            if(sObjLRMM.get(fieldsPrefix  + 'Organization_Name__c') != null) caseObj.AccountId = sObjLRMM.get(fieldsPrefix  + 'Organization_Name__c') + '';
            if(sObjLRMM.get(fieldsPrefix  + 'Paralegal_Assignment__c') != null){
                caseObj.OwnerId = sObjLRMM.get(fieldsPrefix  + 'Paralegal_Assignment__c') + '';
            }else{
                List<User> userList = [SELECT id FROM User WHERE Name = 'Ashley Escobar'];
                if(!userList.isEmpty()) caseObj.OwnerId = userList[0].id;
            }
        }
        if(selectedObject == 'Trial_Witness_Request__c'){
            if(sObjLRMM.get(fieldsPrefix  + 'OrganizationName__c') != null) caseObj.AccountId = sObjLRMM.get('OrganizationName__c') + '';
            if(sObjLRMM.get(fieldsPrefix  + 'LW_Paralegal_Assignment__c') != null){
                caseObj.OwnerId = sObjLRMM.get('LW_Paralegal_Assignment__c') + '';
            }else{
                List<User> userList = [SELECT id FROM User WHERE Name = 'Ashley Escobar'];
                if(!userList.isEmpty()) caseObj.OwnerId = userList[0].id;
            }
        }
        String recordTypeName = 'Legal Review - ' + fieldsPrefix.removeEnd('_');
        if(selectedObject == 'Trial_Witness_Request__c') recordTypeName = 'Trial Witness - Live';
        caseObj.RecordTypeId = [SELECT id FROM RecordType WHERE sObjectType = 'Case' ANd Name =: recordTypeName].id;
        String referenceField = selectedObject.removeEnd('__c');
        if(selectedObject != 'Trial_Witness_Request__c') referenceField = referenceField + '_Record__c';
        if(selectedObject == 'Trial_Witness_Request__c') referenceField = referenceField + '__c';
        caseObj.put(referenceField,sObjLRMM.id);
    }
    
    public PageReference saveCase(){
        try{
            system.debug('Before: ' + caseObj);
            insert caseObj;
            system.debug('After: ' + caseObj);
            return new PageReference('/'+sObjLRMM.id);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
        return null;
    }
}