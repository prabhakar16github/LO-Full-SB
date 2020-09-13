public class LRMM_CADRelatedRecordsController{
    
    public Consumer_Account_Details__c cadObj{get;set;}
    public sObject sObjLRMM{get;set;}
    public String recordLabel{get;set;}
    public String objectLabel{get;set;}
    public String selectedObject{get;set;}
    public Boolean hasRecord{get;set;}
    public Boolean priorExperience{get;set;}
    public List<String> sectionList{get;set;}
    public List<String> selectedContactList{get;set;}
    public List<SelectOption> contactList{get;set;}
    public Map<String,List<String>> fieldsSectionMap{get;set;}
    
    private Map<String,String> LRMMObjShortDescMap = new Map<String,String>{'Appeal__c'=>'AP_','Business_Record_Affidavit__c'=>'BRA_',
                                                                            'Counterclaim__c'=>'CC_','Discovery__c'=>'DY_','Escalated_Contested_Matters__c'=>'ECM_',
                                                                            'Settlement_Approval__c'=>'SA_','Purchase_and_Sales_Agreement__c'=>'PSA_',
                                                                            'Trial_Witness_Request__c'=>''};
    
    public LRMM_CADRelatedRecordsController(){
        String recordId = apexpages.currentpage().getparameters().get('id');
        String objectType = apexpages.currentpage().getparameters().get('objectType');
        cadObj = new Consumer_Account_Details__c();
        contactList = new List<SelectOption>();
        selectedContactList = new List<String>();
        cadObj = [SELECT Name, Organization_name__c, Account_Number__c, Original_Creditor__c, Chain_of_Title__c, Portfolio__c 
                    FROM Consumer_Account_Details__c WHERE id =: recordId];
        hasRecord = false;
        priorExperience = false;
         for(String objectName : LRMMObjShortDescMap .keyset()){
            if(objectType.equals(Schema.getGlobalDescribe().get(objectName).getDescribe().getKeyPrefix())){
                selectedObject = Schema.getGlobalDescribe().get(objectName).getDescribe().getLocalName();
                objectLabel = Schema.getGlobalDescribe().get(objectName).getDescribe().getLabel();
                sObjLRMM = Schema.getGlobalDescribe().get(objectName).newSObject();
                recordLabel = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get('Name').getDescribe().getLabel();
            }
        }
        sectionList = new List<String>{'General Matter Information','Assigned Attorney and Opposing Counsel'};
        String fieldsPrefix = LRMMObjShortDescMap.get(selectedObject);
        populateFields(fieldsPrefix);
        List<String> objectList = new List<String>{'Trial_Witness_Request__c','Counterclaim__c','Appeal__c','Business_Record_Affidavit__c',
                                                    'Discovery__c','Escalated_Contested_Matters__c','Purchase_and_Sales_Agreement__c',
                                                    'Settlement_Approval__c'};
        List<sObject> sObjList;
        String sourceFieldsPrefix = '';
        for(String objectName : objectList){
            String query = 'SELECT ' + fetchFieldsToQuery(objectName) + ' FROM ' + objectName + ' WHERE ' + retrieveCADField(objectName) + ' =: recordId ';
            if(objectName == 'Trial_Witness_Request__c'){
                Map<String,Schema.RecordTypeInfo> recordTypeMap = Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName();
                String TWRRecTypeId = recordTypeMap.get('Telephonic Witness Request').getRecordTypeId();
                String TWRRecTypeSMId = recordTypeMap.get('Telephonic Witness Request San Marcos').getRecordTypeId();
                query += ' AND Recordtypeid !=: TWRRecTypeId AND Recordtypeid !=: TWRRecTypeSMId ';
            }
            query = query + ' LIMIT 1';
            sObjList = Database.query(query);
            if(sObjList != null && !sObjList.isEmpty()){
                sourceFieldsPrefix = LRMMObjShortDescMap.get(objectName);
                break;
            }
        }
        
        if(sObjList != null && !sObjList.isEmpty()){
            hasRecord = true;
            try{
                for(String fieldName : fieldsSectionMap.get('General Matter Information')){
                    if(fieldName == 'Blank') continue;
                    
                    if(((sourceFieldsPrefix == 'CC_' || sourceFieldsPrefix == 'DY_' || sourceFieldsPrefix == 'PSA_' || sourceFieldsPrefix == 'SA_' || sourceFieldsPrefix == 'ECM_') && 
                            fieldName == 'County_Filed__c') || ((sourceFieldsPrefix == 'AP_' || sourceFieldsPrefix == 'CC_' || sourceFieldsPrefix == 'DY_' ||
                            sourceFieldsPrefix == 'SA_' || sourceFieldsPrefix == '' || sourceFieldsPrefix == 'ECM_') && fieldName == 'Original_Creditor__c') || 
                            fieldName == 'Date_Counterclaim_Filed__c' || fieldName == 'Date_Counterclaim_Response_Due_by__c' ||
                            fieldName == 'Appearance_Type__c' || fieldName == 'Defendant_Name__c' || fieldName == 'Date_of_Appearance__c' ||
                            fieldName == 'Time_of_Appearance__c' || fieldName == 'AM_PM__c' || fieldName == 'Time_Zone__c' ||
                            fieldName == 'Days_Appearance_Is_Expected_To_Last__c' || fieldName == 'LW_Settlement_Authority_Needed__c' || fieldName == 'Chain_of_Title__c' || fieldName == 'Portfolio__c') continue;
                    
                    system.debug(sourceFieldsPrefix +  ' -- ' + fieldName);
                    
                    if((sourceFieldsPrefix == 'BRA_' || sourceFieldsPrefix == 'PSA_' || sourceFieldsPrefix == 'ECM_') && fieldName == 'IfPriorExperience_with_Judge_Comments__c'){
                        sObjLRMM.put(fieldsPrefix + fieldName,sObjList[0].get(sourceFieldsPrefix + 'IfPriorExperiencewith_Judge_Comments__c'));
                    }else if((sourceFieldsPrefix == 'AP_' || sourceFieldsPrefix == 'CC_' || sourceFieldsPrefix == 'DY_' || sourceFieldsPrefix == 'SA_') 
                                && fieldName == 'IfPriorExperiencewith_Judge_Comments__c'){
                        sObjLRMM.put(fieldsPrefix + fieldName,sObjList[0].get(sourceFieldsPrefix + 'IfPriorExperience_with_Judge_Comments__c'));
                    }else if(sourceFieldsPrefix == '' && (fieldName == 'Matter_Name__c' || fieldName == 'Organization_Name__c' || 
                                fieldName == 'State_Filed__c' || fieldName == 'IfPriorExperience_with_Judge_Comments__c' || fieldName == 'IfPriorExperiencewith_Judge_Comments__c')){
                        if(fieldName == 'Matter_Name__c'){
                            sObjLRMM.put(fieldsPrefix + fieldName,sObjList[0].get('LW_Matter_Name__c'));
                        }else if(fieldName == 'Organization_Name__c'){
                            sObjLRMM.put(fieldsPrefix + fieldName,sObjList[0].get(sourceFieldsPrefix + 'OrganizationName__c'));
                        }else if(fieldName == 'State_Filed__c'){
                            sObjLRMM.put(fieldsPrefix + fieldName,sObjList[0].get(sourceFieldsPrefix + 'State_Filed_State_Profile__c'));
                        }else if(fieldName == 'IfPriorExperience_with_Judge_Comments__c' || fieldName == 'IfPriorExperiencewith_Judge_Comments__c'){
                            sObjLRMM.put(fieldsPrefix + fieldName,sObjList[0].get(sourceFieldsPrefix + 'If_Prior_Experience_with_Judge_Comments__c'));
                        }
                    }else if(fieldsPrefix == '' && sourceFieldsPrefix == '' && (fieldName == 'LW_Matter_Name__c' || fieldName == 'OrganizationName__c' || 
                                fieldName == 'State_Filed_State_Profile__c')){
                        if(fieldName == 'LW_Matter_Name__c'){
                            sObjLRMM.put(fieldsPrefix + fieldName,sObjList[0].get('LW_Matter_Name__c'));
                        }else if(fieldName == 'OrganizationName__c'){
                            sObjLRMM.put(fieldsPrefix + fieldName,sObjList[0].get(sourceFieldsPrefix + 'OrganizationName__c'));
                        }else if(fieldName == 'State_Filed_State_Profile__c'){
                            sObjLRMM.put(fieldsPrefix + fieldName,sObjList[0].get(sourceFieldsPrefix + 'State_Filed_State_Profile__c'));
                        }
                    }else if(fieldsPrefix == '' && sourceFieldsPrefix != '' && (fieldName == 'LW_Matter_Name__c' || fieldName == 'OrganizationName__c' || 
                                fieldName == 'State_Filed_State_Profile__c' || fieldName == 'If_Prior_Experience_with_Judge_Comments__c')){
                        if(fieldName == 'LW_Matter_Name__c'){
                            sObjLRMM.put(fieldsPrefix + fieldName,sObjList[0].get(sourceFieldsPrefix + 'Matter_Name__c'));
                        }else if(fieldName == 'OrganizationName__c'){
                            sObjLRMM.put(fieldsPrefix + fieldName,sObjList[0].get(sourceFieldsPrefix + 'Organization_Name__c'));
                        }else if(fieldName == 'State_Filed_State_Profile__c'){
                            sObjLRMM.put(fieldsPrefix + fieldName,sObjList[0].get(sourceFieldsPrefix + 'State_Filed__c'));
                        }else if(fieldName == 'If_Prior_Experience_with_Judge_Comments__c'){
                            if(sourceFieldsPrefix == 'AP_' || sourceFieldsPrefix == 'CC_' || sourceFieldsPrefix == 'DY_' || sourceFieldsPrefix == 'SA_'){
                                sObjLRMM.put(fieldsPrefix + fieldName,sObjList[0].get(sourceFieldsPrefix + 'IfPriorExperience_with_Judge_Comments__c'));
                            }else if(sourceFieldsPrefix == 'BRA_' || sourceFieldsPrefix == 'PSA_' || sourceFieldsPrefix == 'ECM_'){
                                sObjLRMM.put(fieldsPrefix + fieldName,sObjList[0].get(sourceFieldsPrefix + 'IfPriorExperiencewith_Judge_Comments__c'));
                            }
                        }
                    }
                    else{
                        sObjLRMM.put(fieldsPrefix + fieldName,sObjList[0].get(sourceFieldsPrefix + fieldName));
                    }
                    
                    if(String.valueOf(sObjList[0].get(sourceFieldsPrefix + 'Prior_Experience_with_Judge__c')) == 'Yes'){
                        priorExperience = true;
                    }
                }
                
                for(String fieldName : fieldsSectionMap.get('Assigned Attorney and Opposing Counsel')){
                    if(fieldName == 'Blank') continue;
                    sObjLRMM.put(fieldsPrefix + fieldName,sObjList[0].get(sourceFieldsPrefix + fieldName));
                }
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: ' + e.getMessage()));
                system.debug('Error : ' + e + ' Line Number: ' + e.getLineNumber());
            }
        }
        
        if(fieldsPrefix == '') sObjLRMM.put(fieldsPrefix + 'Organizationname__c',cadObj.Organization_name__c);
        if(fieldsPrefix != '') sObjLRMM.put(fieldsPrefix + 'Organization_name__c',cadObj.Organization_name__c);
        sObjLRMM.put(fieldsPrefix + 'Account_Number__c',cadObj.Account_Number__c);
        sObjLRMM.put(fieldsPrefix + 'Original_Creditor__c',cadObj.Original_Creditor__c);
        
        if(fieldsPrefix == 'BRA_'){
            sObjLRMM.put('RecordTypeId',Schema.SObjectType.Business_Record_Affidavit__c.getRecordTypeInfosByName().get('BRA: Record Type').getRecordTypeId());
        }else if(fieldsPrefix == ''){
            sObjLRMM.put('RecordTypeId',Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName().get('Live Witness Request Step I').getRecordTypeId());
        }else if(fieldsPrefix == 'PSA_'){
            sObjLRMM.put(fieldsPrefix + 'Chain_of_Title__c',cadObj.Chain_of_Title__c);
            sObjLRMM.put(fieldsPrefix + 'Portfolio__c',cadObj.Portfolio__c);
        }
        sObjLRMM.put(retrieveCADField(selectedObject),recordId);
        sObjLRMM.put('OwnerId',UserInfo.getUserId());
        
        for(String sectionName : fieldsSectionMap.keyset()){
            List<String> fieldsList = fieldsSectionMap.get(sectionName);
            List<String> tempList = new List<String>();
            for(String fieldName : fieldsList){
                if(fieldName == 'Blank') {
                    tempList.add(fieldName);
                }else{
                    tempList.add(fieldsPrefix + fieldName);
                }
            }
            fieldsSectionMap.put(sectionName,tempList);
        }
        system.debug(fieldsSectionMap);
        
        if(selectedObject == 'Appeal__c'){
            fieldsSectionMap.put('System Information',new List<String>{retrieveCADField(selectedObject),'AP_Appeal_Status__c','Blank','OwnerId'});
        }else if(selectedObject == 'Business_Record_Affidavit__c'){
            fieldsSectionMap.put('System Information',new List<String>{retrieveCADField(selectedObject),'BRA_BRA_Status__c','Blank','OwnerId'});
        }else if(selectedObject == 'Counterclaim__c'){
            fieldsSectionMap.put('System Information',new List<String>{retrieveCADField(selectedObject),'CC_Counterclaim_Status__c','Blank','OwnerId'});
        }else if(selectedObject == 'Discovery__c'){
            fieldsSectionMap.put('System Information',new List<String>{retrieveCADField(selectedObject),'DY_Discovery_Status__c','Blank','OwnerId'});
        }else if(selectedObject == 'Escalated_Contested_Matters__c'){
            fieldsSectionMap.put('System Information',new List<String>{retrieveCADField(selectedObject),'ECM_Status__c','Blank','OwnerId'});
        }else if(selectedObject == 'Trial_Witness_Request__c'){
            fieldsSectionMap.put('System Information',new List<String>{retrieveCADField(selectedObject),'RecordTypeId','Blank','OwnerId'});
        }else if(selectedObject == 'Purchase_and_Sales_Agreement__c'){
            fieldsSectionMap.put('System Information',new List<String>{retrieveCADField(selectedObject),'PSA_PSA_Status__c','Blank','OwnerId'});
        }else if(selectedObject == 'Settlement_Approval__c'){
            fieldsSectionMap.put('System Information',new List<String>{retrieveCADField(selectedObject),'Settlement_Approval_Status__c','Blank','OwnerId'});
        }
        
        //Additional Contacts
        for(Contact conObj : [SELECT Name, Email FROM Contact WHERE Inactive_Contact__c = false AND AccountId =: cadObj.Organization_name__c Order By Name]){
            String email = conObj.Name + '<' + conobj.Email + '>';
            contactList.add(new SelectOption(email,email));
        }
    }
    
    public PageReference saveRecord(){
        try{
            String additionalContacts = '';
            for(String email : selectedContactList){
                additionalContacts += email + ';';
            }
            additionalContacts = additionalContacts.removeEnd(';');
            String fieldsPrefix = LRMMObjShortDescMap.get(selectedObject);
            sObjLRMM.put(fieldsPrefix + 'Additional_Contacts__c',additionalContacts);
            insert sObjLRMM;
            return new PageReference('/'+sObjLRMM.id);
        }catch(DMLException e){
            Integer numErrors = e.getNumDml();
            System.debug('getNumDml=' + numErrors);
            for(Integer i=0;i<numErrors;i++) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getDMLMessage(i)));
                System.debug('getDmlFieldNames=' + e.getDmlFieldNames(i));
                System.debug('getDmlMessage=' + e.getDmlMessage(i));
            }
        }
        return null;
    }
    
    public void populateFields(String fieldsPrefix){
        fieldsSectionMap = new Map<String,List<String>>();
        if(selectedObject == 'Appeal__c'){
            fieldsSectionMap.put('General Matter Information',new List<String>{'Matter_Name__c','Court_File__c','Organization_Name__c',
                                    'County_Court_Name__c','Original_Creditor__c','Account_Number__c','Judge_Name__c','State_Filed__c','Prior_Experience_with_Judge__c',
                                    'County_Filed__c','IfPriorExperience_with_Judge_Comments__c','Suit_Balance__c'});
            
            fieldsSectionMap.put(objectLabel + ' Information',new List<String>{'Type_of_Appeal__c','Could_this_Matter_Impact_Precedent__c',
                                    'Date_Notice_of_Appeal_Filed__c','Blank','Blank','Summary_of_Precedential_Impact__c','Name_of_Lower_Court__c',
                                    'Blank','Name_of_Higher_Court_for_this_Appeal__c','Firm_Recommendation_for_Client__c','Amount_of_Judgement__c','Blank',
                                    'Judgment_Entered_in_Favor_of__c'});
        }else if(selectedObject == 'Business_Record_Affidavit__c'){
            fieldsSectionMap.put('General Matter Information',new List<String>{'Matter_Name__c','State_Filed__c','Organization_Name__c','Court_File__c',
                                    'Account_Number__c','County_Filed__c','Original_Creditor__c','County_Court_Name__c','Judge_Name__c',
                                    'Blank','Prior_Experience_with_Judge__c','Blank','IfPriorExperiencewith_Judge_Comments__c','Suit_Balance__c'});
            
            fieldsSectionMap.put(objectLabel + ' Details',new List<String>{'Why_is_BRA_Needed__c','BRA_Attached__c','Blank'});
        }else if(selectedObject == 'Counterclaim__c'){
            fieldsSectionMap.put('General Matter Information',new List<String>{'Matter_Name__c','State_Filed__c','Organization_Name__c','Court_File__c',
                                    'Account_Number__c','County_Court_Name__c','Original_Creditor__c','Date_Counterclaim_Filed__c','Judge_Name__c',
                                    'Date_Counterclaim_Response_Due_by__c','Prior_Experience_with_Judge__c','Blank'
                                    ,'IfPriorExperience_with_Judge_Comments__c','Suit_Balance__c'});
            
            fieldsSectionMap.put(objectLabel + ' Details',new List<String>{'Litigation_Type__c','Discovery_Propounded_on_MCM__c',
                                    'Allegation_Summary_From_Firm__c','Discovery_Documents_Attached__c','State_Suit_Theory__c',
                                    'If_Yes_Discovery_Propounded_Due_Date__c','Firm_Recommedation__c','Blank','Chain_of_Title_Summary__c',
                                    'Motion_to_Compel_DEF_Filed__c','NOA_Sent_to_Consumer_State_Dependent__c','Motion_to_Compel_PLTF_Filed__c',
                                    'Terms_Conditions__c','Blank','Blank','Business_Record_Affidavit_Requested__c','Statements_in_Possession__c',
                                    'One_Off_Affidavit_Requested__c','Additional_Statements_Requested__c','Blank','Blank','MSJ_Recommended__c',
                                    'Media_Chain_of_Title_Notes__c','If_Yes_MSJ_Due_Date__c','Complaint_Attached__c'});
        }else if(selectedObject == 'Discovery__c'){
            fieldsSectionMap.put('General Matter Information',new List<String>{'Matter_Name__c','State_Filed__c','Account_Number__c','Court_File__c',
                                    'Organization_Name__c','County_Court_Name__c','Original_Creditor__c','Judge_Name__c','Blank','Prior_Experience_with_Judge__c',
                                    'Blank','IfPriorExperience_with_Judge_Comments__c','Suit_Balance__c'});
            
            fieldsSectionMap.put('Type of Discovery',new List<String>{'Request_For_Admissions__c','Other__c','Request_For_Production__c',
                                    'Other_Discovery_Type_Comments__c','Interrogatories__c'});   
            
            fieldsSectionMap.put(objectLabel + ' Details',new List<String>{'New_Request_or_for_Amendment__c','Date_Discovery_Served__c',
                                    'Amended_Responses_Due_to_Court_Order__c','Date_Discovery_Response_Due__c','Amended_Responses_Due_to_Stipulation__c',
                                    'Firm_Requested_Response_Date__c','Blank','Date_Discovery_Responses_Served__c','Was_an_Extension_Requested__c','Blank',
                                    'Extension_Granted__c','Discovery_Notes__c','Extension_Date_Discovery_Response_Due__c'});
        }else if(selectedObject == 'Escalated_Contested_Matters__c'){
            fieldsSectionMap.put('General Matter Information',new List<String>{'Matter_Name__c','State_Filed__c','Organization_Name__c','Court_File__c',
                                    'Account_Number__c','County_Court_Name__c','Original_Creditor__c','Judge_Name__c','Blank','Prior_Experience_with_Judge__c',
                                    'Blank','IfPriorExperiencewith_Judge_Comments__c','Suit_Balance__c'});
            
            fieldsSectionMap.put(objectLabel + ' Details',new List<String>{'Litigation_Type__c','Discovery_Propounded_on_MCM__c',
                                    'Allegation_Summary_From_Firm__c','Discovery_Documents_Attached__c','State_Suit_Theory__c',
                                    'If_Yes_Discovery_Propounded_Due_Date__c','Firm_Recommedation__c','Blank','Chain_of_Title_Summary__c','Motion_to_Compel_DEF_Filed__c',
                                    'NOA_Sent_to_Consumer_State_Dependent__c','Motion_to_Compel_PLTF_Filed__c','Terms_Conditions__c','Blank','Blank',
                                    'Business_Record_Affidavit_Requested__c','Statements_in_Possession__c','One_Off_Affidavit_Requested__c',
                                    'Additional_Statements_Requested__c','Blank','Blank','MSJ_Recommended__c','Media_Chain_of_Title_Notes__c',
                                    'If_Yes_MSJ_Due_Date__c','Complaint_Attached__c','Blank','Transfer_to_Outside_Counsel__c'});
        }else if(selectedObject == 'Trial_Witness_Request__c'){
            fieldsSectionMap.put('General Matter Information',new List<String>{'LW_Matter_Name__c','State_Filed_State_Profile__c','OrganizationName__c',
                                    'County_Filed__c','Appearance_Type__c','Court_File__c','Account_Number__c','County_Court_Name__c','Original_Creditor__c',
                                    'Defendant_Name__c','Judge_Name__c','Date_of_Appearance__c','Prior_Experience_with_Judge__c','Time_of_Appearance__c',
                                    'If_Prior_Experience_with_Judge_Comments__c','AM_PM__c','Suit_Balance__c','Time_Zone__c',
                                    'Days_Appearance_Is_Expected_To_Last__c', 'LW_Settlement_Authority_Needed__c'});
            
            fieldsSectionMap.put('Step I',new List<String>{'Settlement_Attempted__c','LW_Witness_Subpoenaed__c','Last_Settlement_Offer_by__c',
                                    'LW_Subpoenaed_Witness_Name__c','Settlement_Offer_Type__c','Blank','Settlement_Offer_Amount__c','Discovery_Status__c',
                                    'Settlement_Chance_Prior_to_Hearing__c','Blank','Post_Judgment_Collectability__c','Chance_Of_Success_if_We_Appear__c',
                                    'Settlement_Attempted_Comments__c','Blank','Blank','Potential_Issues_or_Limitations__c','Counterclaim__c','Blank',
                                    'Allegations__c','Subject_Matter_to_be_Covered__c','Factual_Basis_of_Allegations__c','Blank','Brief_History__c',
                                    'Other_Considerations__c','Hardship__c','Blank','Hardship_Documents_Attached__c','Blank','Hardship_Solution__c','Blank',
                                    'Dispute__c','Blank','Dispute_Documents_Attached__c','Blank','Dispute_Solution__c'});
            
            fieldsSectionMap.put(objectLabel + ' Information',new List<String>{'Witness_Determination__c','Original_Creditor_Witness_Needed__c', 'Status__c'});
        }else if(selectedObject == 'Purchase_and_Sales_Agreement__c'){
            fieldsSectionMap.put('General Matter Information',new List<String>{'Matter_Name__c','State_Filed__c','Organization_Name__c','Court_File__c',
                                    'Account_Number__c','County_Court_Name__c','Original_Creditor__c','Judge_Name__c','Chain_of_Title__c',
                                    'Prior_Experience_with_Judge__c','Portfolio__c','IfPriorExperiencewith_Judge_Comments__c','Suit_Balance__c'});
            
            fieldsSectionMap.put(objectLabel + ' Details',new List<String>{'Why_Is_PSA_Needed__c','Is_There_a_Motion_to_Compel_PSA__c',
                                    'Blank','Has_Court_Issued_Order_On_Motion__c','Blank','Motion_and_Response_Attached__c',
                                    'Blank','Order_on_Motion_Attached__c','Blank','Protective_Order_Draft_Attached__c','Blank'});
        }else if(selectedObject == 'Settlement_Approval__c'){
            fieldsSectionMap.put('General Matter Information',new List<String>{'Matter_Name__c','State_Filed__c','Organization_Name__c','Court_File__c',
                                    'Account_Number__c','County_Court_Name__c','Original_Creditor__c','Judge_Name__c','Blank',
                                    'Prior_Experience_with_Judge__c','Blank','IfPriorExperience_with_Judge_Comments__c','Suit_Balance__c'});
            
            fieldsSectionMap.put(objectLabel + ' Details',new List<String>{'Threat_of_litigation__c','Amount_of_Offer__c','Type_of_Threat__c',
                                    'Amount_of_Prior_Offers__c','Basis_of_threat__c','Blank','Demand_Date__c','Firm_Recommendation__c',
                                    'Demand_Response_Date__c','Blank','Next_action__c'});
        }
        
        fieldsSectionMap.put('Assigned Attorney and Opposing Counsel',new List<String>{'Assigned_Attorney__c','Pro_Se__c','Assigned_Attorney_Email__c',
                                'Opposing_Counsel__c','Assigned_Attorney_Cell_Phone__c','Opposing_Counsel_Firm_Name__c','Assigned_Attorney_Direct_Line__c',
                                'Opposing_Counsel_Email__c','Blank','Opposing_counsel_Phone__c','Blank','Opposing_Counsel_Comments__c'});
    }
    
    public String fetchFieldsToQuery(String objectName){
        String fieldNames = '';
        for(SObjectField  fieldVal : Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().values()){
            fieldNames += fieldVal.getDescribe().getLocalName() + ',';
        }
        fieldNames = fieldNames.removeEnd(',');
        return fieldNames;
    }
    
    public String retrieveCADField(String objectName){
        String fieldName = '';
        for(sObjectField fieldVal : schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().values()){
            if(String.valueOf(fieldVal.getDescribe().getReferenceTo()).equalsIgnoreCase('(Consumer_Account_Details__c)')){
                fieldName = fieldVal.getDescribe().getLocalName();
                break;
            }
        }
        return fieldName;
    }
}