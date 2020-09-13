public class LRMM_UpdateAdditionalContactsCtrl{
    
    public sObject sObjLRMM{get;set;}
    public String recordLabel{get;set;}
    public String selectedObject{get;set;}
    public Boolean isAddition{get;set;}
    public List<SelectOption> availableFieldSOList{get;set;}
    public List<SelectOption> selectedFieldSOList{get;set;}
    public List<String> availableFieldsList{get;set;}
    public List<String> selectedFieldsList{get;set;}
    
    private Map<String,String> LRMMObjShortDescMap = new Map<String,String>{'Appeal__c'=>'AP_','Business_Record_Affidavit__c'=>'BRA_',
                                                                            'Counterclaim__c'=>'CC_','Discovery__c'=>'DY_',
                                                                            'Escalated_Contested_Matters__c'=>'ECM_','Settlement_Approval__c'=>'SA_',
                                                                            'Purchase_and_Sales_Agreement__c'=>'PSA_','Trial_Witness_Request__c'=>''};
    
    public LRMM_UpdateAdditionalContactsCtrl(){
        String recordId = apexpages.currentpage().getparameters().get('id');
        for(String objectName : LRMMObjShortDescMap.keyset()){
            if(recordId.startsWith(Schema.getGlobalDescribe().get(objectName).getDescribe().getKeyPrefix())){
                selectedObject = Schema.getGlobalDescribe().get(objectName).getDescribe().getLocalName();
                recordLabel = Schema.getGlobalDescribe().get(objectName).getDescribe().getLabel();
            }
        }
        String fieldsPrefix = LRMMObjShortDescMap.get(selectedObject);
        String fieldNames = 'Name, Additional_Contacts__c, Organization_Name__c';
        String organizatonField = 'Organization_Name__c';
        if(selectedObject != 'Trial_Witness_Request__c'){
            fieldNames = fieldNames.replace('Organization_Name__c', fieldsPrefix + 'Organization_Name__c');
            organizatonField = organizatonField.replace('Organization_Name__c', fieldsPrefix + 'Organization_Name__c');
        }
        if(selectedObject == 'Trial_Witness_Request__c'){
            fieldNames = fieldNames.replace('Organization_Name__c', 'OrganizationName__c');
            organizatonField = organizatonField.replace('Organization_Name__c', 'OrganizationName__c');
        }
        fieldNames = fieldNames.replace('Additional_Contacts__c', fieldsPrefix + 'Additional_Contacts__c');
        sObjLRMM = Database.query('SELECT ' + fieldNames + ' FROM ' + selectedObject + ' WHERE id =: recordId');
        availableFieldSOList = new List<SelectOption>();
        selectedFieldSOList = new List<SelectOption>();
        availableFieldsList = new List<String> ();
        selectedFieldsList = new List<String>();
        
        String contactsAdded = '';
        if(sObjLRMM.get(fieldsPrefix + 'Additional_Contacts__c') != null) contactsAdded = sObjLRMM.get(fieldsPrefix + 'Additional_Contacts__c') + '';
        if(contactsAdded.trim() != ''){
            for(String contactEmail : contactsAdded.split(';')){
                selectedFieldSOList.add(new SelectOption(contactEmail,contactEmail));
            }
        }
        
        for(Contact conObj : [SELECT Name, Email FROM Contact WHERE Inactive_Contact__c = false AND AccountId =: sObjLRMM.get(organizatonField)+'' Order By Name]){
            String email = conObj.Name + '<' + conobj.Email + '>';
            if(!contactsAdded.contains(email)){
                availableFieldSOList.add(new SelectOption(email,email));
            }
        }
    }
    
     public pageReference addRemoveEmails(){
        List<Integer> indexList = new List<Integer>();
        List<SelectOption> fromList = new List<SelectOption>();
        List<SelectOption> toList = new List<SelectOption>();
        Set<String> tempSet = new Set<String>();
        
        if(isAddition){
            if(availableFieldsList.isEmpty() || availableFieldSOList.isEmpty()) return null;
                tempSet.addAll(availableFieldsList);
                fromList.addAll(availableFieldSOList);
                toList.addAll(selectedFieldSOList);
        }else{
            if(selectedFieldsList.isEmpty() || selectedFieldSOList.isEmpty()) return null;
            tempSet.addAll(selectedFieldsList);
            fromList.addAll(selectedFieldSOList);
            toList.addAll(availableFieldSOList);
        }
        Integer i = 0;
        for(SelectOption temp:fromList){
            if(tempSet.contains(temp.getValue())){
                indexList.add(i - indexList.size());
            }
            i++;
        }
        
        for(Integer index:indexList){
            toList.add(fromList[index]);
            fromList.remove(index);
        }
        
        if(!toList.isEmpty()){
            availableFieldSOList.clear();
            selectedFieldSOList.clear();
            if(isAddition){
                availableFieldSOList.addAll(fromList);
                selectedFieldSOList.addAll(toList);
            }else{
                selectedFieldSOList.addAll(fromList);
                availableFieldSOList.addAll(toList);
                SortSOList();
            }
        }
        return null;
    }
    
    private void SortSOList(){
        List<String> sortList = new List<String>();
        for(SelectOption email : availableFieldSOList){
            sortList.add(email.getValue());
        }
        sortList.sort();
        availableFieldSOList.clear();
        for(String email : sortList){
            availableFieldSOList.add(new SelectOption(email,email));
        }
    }
    
    public PageReference saveDetails(){
        try{
            String emailsList = '';
            for(SelectOption email : selectedFieldSOList){
                emailsList += email.getValue() + ';';
            }
            emailsList = emailsList.removeEnd(';');
            String fieldsPrefix = LRMMObjShortDescMap.get(selectedObject);
            sObjLRMM.put(fieldsPrefix + 'Additional_Contacts__c',emailsList);
            update sObjLRMM;
            return new PageReference('/'+sObjLRMM.id);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            system.debug('Error: ' + e.getMessage());
        }
        return null;
    }
}