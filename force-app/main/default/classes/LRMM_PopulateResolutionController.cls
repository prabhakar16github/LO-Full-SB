/* *********************************************************
 * Class Name : LRMM_PopulateResolutionController
 * Description: This is the controller class for LRMM_PopulateResolution VF page which is population the 
 * 				Resolution fields value. 
 * Created Date : 4-Sept-2019
 * Creted By : Prabhakar Joshi
 * *********************************************************/
public class LRMM_PopulateResolutionController { 
    public Id recordId;
    public String cadId;
    public String sobjectName{get;private set;}
    public Sobject currentObj{get;private set;}
    public boolean disableSave{get;private set;}
    public Map<String,List<String>> objFieldsMap{get;set;}
    public String errorMsg{get;set;}
    public Map<String,String> objToParentFieldMap;
    
    public LRMM_PopulateResolutionController(Apexpages.StandardController sc){
        disableSave = false;
        objToParentFieldMap = getParentFieldMap();
        objFieldsMap = getObjFieldsMap();
        recordId = sc.getId();
        sobjectName = recordId.getSobjectType().getDescribe().getName();
        String fieldsForQry = String.join(objFieldsMap.get(sobjectName), ',');
        String query = 'SELECT '+fieldsForQry+','+objToParentFieldMap.get(sobjectName)+' FROM '+sobjectName+' WHERE Id =:recordId LIMIT 1';
        currentObj = Database.query(query)[0];
        cadId = String.valueOf(currentObj.get(objToParentFieldMap.get(sobjectName)));
        errorMsg = '';
        init();
    }
    
    public void init(){
        Map<Id,Sobject> recIdToChildObjToMap = new Map<Id,Sobject>();
        
        List<Consumer_Account_Details__c> cadList = [SELECT Id,Name,Master_Activated__c 
                                                     FROM Consumer_Account_Details__c
                                                     WHERE Id =:cadId
                                                     AND Master_Activated__c = true 
                                                     LIMIT 1];
        if(cadList.size() > 0){
            for(String obj : objFieldsMap.keySet()){
                if(obj != sobjectName && objFieldsMap.get(obj) != NULL){
                    String qry = 'SELECT Id,';
                    qry += String.join(objFieldsMap.get(obj), ',');
                    qry += ' FROM '+obj+' WHERE '+objToParentFieldMap.get(obj)+'=:cadId';
                    List<sobject> objectList = Database.query(qry);
                    if(objectList.size() > 0){
                        for(sobject childObj : objectList){
                            for(String field : objFieldsMap.get(obj)){
                                if(childObj.get(field) != NULL){
                                   
                                    recIdToChildObjToMap.put(recordId,childObj);
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            if(recIdToChildObjToMap.keySet().size() > 0){
                Map<String, Schema.SObjectField> fieldSchema = Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap();
                sObject sObj = Schema.getGlobalDescribe().get(sobjectName).newSObject();
                sObj.put('Id', recordId);
                for(String field : objFieldsMap.get(sobjectName)){
                    sObject sObjWithVal = recIdToChildObjToMap.get(recordId);
                    String sObjWithValName = String.valueOf(sObjWithVal.getSObjectType());
                    for(String valField : objFieldsMap.get(sObjWithValName)){
                        if(field.split('_',2)[1] == valField.split('_',2)[1]){
                            sObj.put(field, sObjWithVal.get(valField));
                        }
                    }
                }
                currentObj = sObj;
            }
        }else{
            errorMsg = 'CAD is not Activated or any internal issue with CAD.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,errorMsg));
            disableSave = true;
        }
    }
    
    public pageReference doSave(){
        try{
            update currentObj;
            return new pageReference('/'+currentObj.get('Id'));
        }catch(Exception e){
            errorMsg = 'Error : '+e.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,errorMsg));
            return NULL;
        }
    }
    
    /**************************** Method to get the Object and Fields Mapping *****************************/
    
    private static Map<String,List<String>> getObjFieldsMap(){
        return new Map<String,List<String>>
        {'Appeal__c'=>new List<String>{'AP_Resolution_Type__c','AP_Variance_From_Established_Process__c','AP_Resolution_Date__c','AP_Variance_From_Process_Other__c','AP_Resolution_Amount__c','AP_Resolution_Notes__c','AP_Resolution_Payment_To__c'},
            'Counterclaim__c'=>new List<String>{'CC_Resolution_Type__c','CC_Variance_From_Established_Process__c','CC_Resolution_Date__c','CC_Variance_From_Process_Other__c','CC_Resolution_Amount__c','CC_Resolution_Notes__c','CC_Resolution_Payment_To__c'},
                'Purchase_and_Sales_Agreement__c'=>new List<String>{'PSA_Resolution_Type__c','PSA_Variance_From_Established_Process__c','PSA_Resolution_Date__c','PSA_Variance_From_Process_Other__c','PSA_Resolution_Amount__c','PSA_Resolution_Notes__c','PSA_Resolution_Payment_To__c'},
                    'Trial_Witness_Request__c'=>new List<String>{'LW_Resolution_Type__c','LW_Variance_From_Established_Process__c','LW_Resolution_Date__c','LW_Variance_From_Process_Other__c','LW_Resolution_Amount__c','LW_Resolution_Notes__c','LW_Resolution_Payment_To__c'},
                        'Escalated_Contested_Matters__c'=>new List<String>{'ECM_Resolution_Type__c','ECM_Variance_From_Established_Process__c','ECM_Resolution_Date__c','ECM_Variance_From_Process_Other__c','ECM_Resolution_Amount__c','ECM_Resolution_Notes__c','ECM_Resolution_Payment_To__c'},
                            'Settlement_Approval__c'=>new List<String>{'SA_Resolution_Type__c','SA_Variance_From_Established_Process__c','SA_Resolution_Date__c','SA_Variance_From_Process_Other__c','SA_Resolution_Amount__c','SA_Resolution_Notes__c','SA_Resolution_Payment_To__c'}};
                                }
    
    
    /************************** Method to get the object and CAD lookup field Mapping********************************/
    
    private Map<String,String> getParentFieldMap(){
        return new Map<String,String>{'Appeal__c'=>'AP_Consumer_Account_Record__c',
            'Counterclaim__c'=>'CC_Consumer_Account_Detail_Name__c',
            'Purchase_and_Sales_Agreement__c'=>'PSA_Consumer_Account_Detail_Name__c',
            'Trial_Witness_Request__c'=>'TW_Consumer_Account_Records__c',
            'Escalated_Contested_Matters__c'=>'ECM_Consumer_Account_Detail_Name__c',
            'Settlement_Approval__c'=>'SA_Consumer_Account_Details__c'};
                }
}