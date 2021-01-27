/*
	* @ Class Name 		    : 	    LW_Re_Request_Controller
 	* @ Description 	    : 	    Controller for LW_Re_Request VF Page & LW_ReRequest_Comp Aura Component.
 	* @ Created By 		    : 	    Prabhakar Joshi
    * @ Created Date	    : 	    1-July-2020 
    * @ Last Modified Date  :       11-Sept-2020
*/

public class LW_Re_Request_Controller {
    /* To hold the current Record Id. */
    public Id recordId{get;set;}
    /* To hold the current record. */
    public Trial_Witness_Request__c oldRecord{get;set;}
    /* To hold the new record which will create from cloning the current record. */ 
    public Trial_Witness_Request__c newRecord{get;set;}
    /* Map of Object Name and CAD lookup field.*/
    public static FINAL Map<String,String> objToCADFieldMap = new Map<String,String>{'Counterclaim__c'=>'CC_Consumer_Account_Detail_Name__c','Escalated_Contested_Matters__c'=>'ECM_Consumer_Account_Detail_Name__c','Discovery__c'=>'DY_Consumer_Account_Details__c'};
        
        /*  Constructor*/
        public LW_Re_Request_Controller(){
            recordId = ApexPages.currentPage().getParameters().get('recordId');
            DataWrapper dw = getData(recordId);
            oldRecord = dw.oldRecord;
            newRecord = dw.newRecord;
        }
    
    /* Method to get the current record and new record.  */
    /* Calling from constructor and JS Controller of LW_ReRequest_Comp Aura Component. */
	@AuraEnabled
    public static DataWrapper getData(String recordId){
        DataWrapper dw = new DataWrapper();
        Trial_Witness_Request__c newTempRecord = new Trial_Witness_Request__c();
        List<Trial_Witness_Request__c> oldRecordList = Database.query('SELECT '+getFieldsForQuery()+',RecordType.Name FROM Trial_Witness_Request__c WHERE Id =:recordId LIMIT 1');
        if(!oldRecordList.isEmpty()){
            dw.oldRecord = oldRecordList[0];
            dw.newRecord = oldRecordList[0].clone(false,false,false,false);
            dw.newRecord.Re_Requested_Record__c = true;
            if(dw.oldRecord.Status__c == 'Scheduled'){
                dw.newRecord.Status__c = 'Re-Schedule Required';
            }
            if(dw.newRecord.Trial_Witness_Name__c != NULL){
                dw.newRecord.Trial_Witness_Name__c = NULL;
            }
            if(dw.newRecord.TW_Consumer_Account_Records__c != NULL){
                dw.newRecord.Counterclaim_Record__c =  getRelatedLRMMRecord('Counterclaim__c',dw.newRecord.TW_Consumer_Account_Records__c);
            	dw.newRecord.Escalated_Contested_Matter_Record__c = getRelatedLRMMRecord('Escalated_Contested_Matters__c',dw.newRecord.TW_Consumer_Account_Records__c);
            	dw.newRecord.Discovery_Name__c = getRelatedLRMMRecord('Discovery__c',dw.newRecord.TW_Consumer_Account_Records__c);
            }
            
            for(String blankField : label.LW_Re_Request_Blank_Fields.split(',')){
                dw.newRecord.put(blankField,NULL);
            }
        }
        return dw;
    }
    
    /* Method to get the Id of related Counterclaim,ECM & Discovery record with related CAD Record. */
    /* Calling from getData method. */
    private static Id getRelatedLRMMRecord(String objName,Id cadId){
        String query = 'SELECT Id,Name FROM '+objName+' WHERE '+objToCADFieldMap.get(objName)+' =:cadId ORDER BY CreatedDate DESC LIMIT 1' ;
        List<Sobject> objList = Database.query(query);
        if(objList.isEmpty()){
            return NULL;
        }
        return objList[0].Id;
    }
    
    /* Method to get the list of fields for query. */
    /* Calling from getData method. */
    private static String getFieldsForQuery(){
        List<String> fieldList = new List<String>();
        Map<String, Schema.SObjectField> objFieldMap = Trial_Witness_Request__c.sObjectType.getDescribe().fields.getMap(); 
       
        for(Schema.sObjectField field : objFieldMap.values()){ 
            fieldList.add(field.getDescribe().getName());
        }
        return String.join(fieldList, ',');
    }
    
    
    /* Method to save the cloned record. */
    /* Calling from JS controller of LW_ReRequest_Comp Aura Component. */
    @AuraEnabled
    public static String saveNewRecord(String newRecordStr,String oldRecordId){
        if(String.isBlank(newRecordStr)){
            return 'Error : Internal Data Issue.';
        }
        
        Trial_Witness_Request__c newLWRecord = (Trial_Witness_Request__c)JSON.deserialize(newRecordStr, Trial_Witness_Request__c.class);
        return saveData(newLWRecord,oldRecordId);
    }
    
    /* Method to save the cloned record. */
    /* Calling from LW_Re_Request VF Page. */
    public PageReference SaveNew(){
        String result = saveData(newRecord,recordId);
        if(result.contains('Error')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,result));
            return NULL;
        }
            
        return new PageReference('/'+result);
    }
    
    /* Common method to save the new cloned Live Witness record */
    /* Calling from  saveNewRecord & SaveNew method. */
    private static String saveData(Trial_Witness_Request__c newRecordToSave,String oldRecordId){
        Savepoint sp = Database.setSavepoint();

        try{
            insert newRecordToSave;
            List<Attachment> newAttList = new List<Attachment>();
            for(Attachment att : [SELECT Body,ParentId,Name FROM Attachment WHERE ParentId = :oldRecordId]){
                Attachment attNew = new Attachment();
                attNew = att.clone(false,false,false,false);
                attNew.ParentId = newRecordToSave.Id;
                newAttList.add(attNew);
            }
            if(!newAttList.isEmpty()){
                insert newAttList;
            }
            Trial_Witness_Request__c oldRecToUpdate = new Trial_Witness_Request__c();
            oldRecToUpdate.Id = oldRecordId;
            oldRecToUpdate.Re_Request_Submitted__c = true;
            oldRecToUpdate.Status__c = 'Closed';
            update oldRecToUpdate;

            return newRecordToSave.Id;
        }catch(Exception e){
            Database.rollback(sp);
			return 'Error : '+e.getMessage();
        }
    }
    
    /* Wrapper class to bind the current Record & new Cloned Record. */
    public class DataWrapper{
        /* To bind the current Record. */
        @AuraEnabled
        public Trial_Witness_Request__c oldRecord;
        /* To bind the new cloned record. */
        @AuraEnabled
        public Trial_Witness_Request__c newRecord;
        
        public DataWrapper(){
            oldRecord = new Trial_Witness_Request__c();
            newRecord = new Trial_Witness_Request__c();
        }
    }
}