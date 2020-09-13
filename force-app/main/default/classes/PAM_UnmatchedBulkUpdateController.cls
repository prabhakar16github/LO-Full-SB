/********************************************************************************************************
 * Class Name       : PAM_UnmatchedBulkUpdateController
 * Description      : To do the bulk update in 'Reason for discrepancy' field in 'Pam Unmatched' Records.
 * Created By       : Prabhakar Joshi
 * Created on       : 9 Sept 2019
 * Last Modified By : Prabhakar Joshi on 11-Nov-2019
 * ******************************************************************************************************/
public class PAM_UnmatchedBulkUpdateController {
    public Id pamId;
    public Process_Adherence_Monitoring__c pamRec{get;set;}
    public List<umWrapper> unMatchedWrapList{get;set;}
    public String selectedDescStr{get;set;}
    public string colName{get;set;}
    public String pcodeStr{get;set;}
    public String accNoStr{get;set;}
    public String recordTypeStr{get;set;}
    public Integer pcodeSortingNum{get;set;}
    public Integer accNoSortingNum{get;set;}
    public Integer recordTypeSortingNum{get;set;}
    public String descReasonComment{get;set;}
    public String correctAccNo{get;set;}
    public String correctPcodeSelected{get;set;}
    public String errorMsg{get;private set;}
    public String jsonMap{get;private set;}
    public Integer offSet{get;set;}
    public Integer recordCount{get;private set;}
    public boolean showNext{get;private set;}
    public boolean chkAll{get;set;}
    public Integer recordLimit{get;private set;} 
    public String infoMsg{get;private set;}
    
    /******************************** Constructor of class *************************************/
    public PAM_UnmatchedBulkUpdateController(ApexPages.StandardController sc){
        Integer labelValue = Integer.valueOf(label.PAMUM_Record_Limit);
        if(labelValue > 1000)
            recordLimit = 1000;
        else
            recordLimit = labelValue;
        infoMsg = (2000+recordLimit)+' Records available; '+recordLimit+' Per page,and will refresh as records are processed. ';
        offSet = 0;
        pamId = sc.getId();
        pamRec = new Process_Adherence_Monitoring__c();
        pcodeSortingNum = 0;
        accNoSortingNum = 0;
        recordTypeSortingNum = 0;
        jsonMap = '';
        fetchPcodes();
        errorMsg = '';
        
        init();
    }
    
    /************************** Method to get the list of records ************************************/
    public void init(){
        showNext = false;
        chkAll = false;
        unMatchedWrapList = new List<umWrapper>();
        pamRec = [SELECT Id,Name,RecordType.Name FROM Process_Adherence_Monitoring__c WHERE Id =:pamId LIMIT 1];
        
        for(PAM_Unmatched__c um :  getUnmatchedList(pamRec.recordType.Name)){ 
            unMatchedWrapList.add(new umWrapper(false,um));
        } 
        Integer remainingRecords = recordCount - (unMatchedWrapList.size() + offSet);
        if(remainingRecords > 0){
            showNext = true;
        }
    }
    
    /************** Method for get the Unmatched record List according to PAM RecordType *************/
    private List<PAM_Unmatched__c> getUnmatchedList(String recordType){
        
        String query = 'SELECT Id,Name,RecordTypeId,RecordType.Name,PAMUM_Organization_Name__c,';
        query += 'PAMUM_Organization_Name__r.Name,PAMUM_Account_Number__c,PAMUM_Status__c,';
        query += 'PAMUM_Process_Adherence_Monitoring__c,SCMDUM_Reason_for_Discrepancy__c,SCMDUM_PCode_Sent__c ';
        query += 'FROM PAM_Unmatched__c WHERE PAMUM_Process_Adherence_Monitoring__c =:pamId AND SCMDUM_Reason_for_Discrepancy__c = NULL ';
        
        if(recordType.contains('SCM Dispute')){
            if(pcodeStr != NULL && String.isNotBlank(pcodeStr) ){
                query += 'AND SCMDUM_PCode_Sent__c =:pcodeStr ';
            }
        }
        else if(recordType.contains('LO IR') || recordType.contains('ACF IR')){
            Set<String> umRecordTypeSet = new Set<String>{'LO IRUM - Firm Open','LO IRUM - Firm Closed',
                'ACF IRUM - Firm Open','ACF IRUM - Firm Closed'};
                    
                    query += 'AND PAMUM_Process_Adherence_Monitoring__r.Status__c =\'Accounts Sent To ISeries\' AND RecordType.Name IN :umRecordTypeSet ';
        }
        
        if(accNoStr != NULL && String.isNotBlank(accNoStr)){
            String accStr = '%'+accNoStr+'%';
            query += 'AND PAMUM_Account_Number__c LIKE :accStr ';
        }
        
        if(recordTypeStr != NULL && String.isNotBlank(recordTypeStr)){
            String rtStr = '%'+recordTypeStr+'%';
            query += 'AND RecordType.Name LIKE :rtStr ';
        }
        
        query += 'ORDER BY ';
        
        if(colName != NULL){
            if(colName == 'pcodeSent'){
                accNoSortingNum = 0;
                recordTypeSortingNum = 0;
                query += ' SCMDUM_PCode_Sent__c ';
                pcodeSortingNum++;
                if(Math.mod(pcodeSortingNum, 2) == 0){
                    query += 'DESC';
                }
            }
            else if(colName == 'accountNo'){
                pcodeSortingNum = 0;
                recordTypeSortingNum = 0;
                query += ' PAMUM_Account_Number__c ';
                accNoSortingNum++;
                if(Math.mod(accNoSortingNum, 2) == 0){
                    query += 'DESC ';
                }
            }
            else if(colName == 'recordType'){
                pcodeSortingNum = 0;
                accNoSortingNum = 0;
                query += ' RecordType.Name ';
                recordTypeSortingNum++;
                if(Math.mod(recordTypeSortingNum, 2) == 0){
                    query += 'DESC ';
                }
            }
        }else{
            query += ' Name';
        }
        recordCount = Database.query(query).size();
        if(recordCount > 1000){
            query += ' LIMIT :recordLimit';
            query += ' OFFSET :offSet';
        }
        
        return Database.query(query);
    }
    
    /************************************** Method for Next page Button ********************************/
    public void showNext(){
        offSet = offSet + recordLimit;
        init();
    }
    
    /************************************** Method for Previous page Button ********************************/
    public void showPrev(){
        offSet = offSet - recordLimit;
        init();
    }
    
    /********** Method to get the recordType picklist values according to PAM RecordType ***********/
    public List<SelectOption> getRecordTypePickList(){
        List<SelectOption> recTypePicklist = new List<SelectOption>();
        Set<String> recTypeSet = new Set<String>();
        
        if(pamRec.recordType.Name.contains('LO IR')){
            recTypeSet = new Set<String>{'LO IRUM - Firm Open','LO IRUM - Firm Closed'};
        }
        else if(pamRec.recordType.Name.contains('ACF IR')){
            recTypeSet = new Set<String>{'ACF IRUM - Firm Open','ACF IRUM - Firm Closed'};
        }
        
        recTypePicklist.add(new SelectOption('','All'));
        for(String str : recTypeSet){
            recTypePicklist.add(new SelectOption(str,str));
        }
        return recTypePicklist;
    }

    /**************************** Function for getting the values of Discrepancy reason ********************/
    public List<SelectOption> getItems(){
        List<SelectOption> itemList = new List<SelectOption>();
        Set<String> requiredValuesSetforSCMD = new Set<String>{'Account submitted for wrong PCode','Account submitted in error',
            'Incorrect Account Number','Mapping or coding matrix error','Process Error'};
                
        List<Schema.PicklistEntry> pickListVal = PAM_Unmatched__c.SCMDUM_Reason_for_Discrepancy__c.getDescribe().getPicklistValues();
        itemList.add(new SelectOption('','--None--'));
        
        for(Schema.PicklistEntry val : pickListVal){
            if(pamRec.RecordType.Name.contains('SCM Dispute')){
                if(requiredValuesSetforSCMD.contains(val.getLabel())){
                    itemList.add(new SelectOption(val.getLabel(),val.getValue()));
                }
            }else if(pamRec.recordType.Name.contains('IR')){
                if(!requiredValuesSetforSCMD.contains(val.getLabel())){
                    itemList.add(new SelectOption(val.getLabel(),val.getValue()));
                }
            }
        }
        return itemList;
    }
    
    /*************** Method to get the Pcode values for the dynamic Pcode picklist*********************/
    private void fetchPcodes(){
        Map<String,String> itemMap = new Map<String,String>();
        List<Schema.PicklistEntry> pickListVal = PAM_Unmatched__c.SCMDUM_Correct_PCode__c.getDescribe().getPicklistValues();
        itemMap.put('--None--','');
        for(Schema.PicklistEntry val : pickListVal){
            itemMap.put(val.getLabel(),val.getValue());
        }
        
        if(itemMap.keySet().size() > 0){
            jsonMap = JSON.serialize(itemMap);
        }
    }
    
    /************** Method to validate the selected value from discrepancy picklist***********/
    public void checkSelected(){
        Integer count = 0;
        for(umWrapper wrp : unMatchedWrapList){
            if(wrp.isSelected){
                count++;
            }
        }
        if(count > 0){
            if(selectedDescStr == 'Incorrect Account Number'){
                if(count > 1){
                    errorMsg = 'Account Number Incorrect cannot be selected when processing multiple accounts because the correct account number is required.';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,errorMsg));
                }else{
                    errorMsg = '';
                }
            }else{
                Set<String> pickListValuesForIr = new Set<String>{'Currently Open with Firm','Timing – Account closed same day as cut off',
                    'Inactive close code used','Close code re-sent','Legal Obligation','Reopen Request sent',
                    'Account is currently Closed'};
                        
                        Set<Id> recordTypeSet = new Set<Id>();
                
                if(pickListValuesForIr.contains(selectedDescStr)){
                    for(umWrapper wrp : unMatchedWrapList){
                        if(wrp.isSelected){
                            recordTypeSet.add(wrp.um.RecordTypeId);
                        }
                    }
                    
                    if(recordTypeSet.size() > 1){
                        errorMsg = 'Please be sure to select only one Record Type when processing multiple records because the Reason For Discrepancies vary based on record type.';
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,errorMsg));
                    }else{
                        List<Id> tempList = new List<Id>();
                        tempList.addAll(recordTypeSet);
                        
                        Set<String> recTypeToPickValSet = getPickValFromRecType(tempList[0]);
                        if(!recTypeToPickValSet.contains(selectedDescStr)){
                            errorMsg = 'This Picklist value is not valid for selected record type.';
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,errorMsg));
                        }else{
                            errorMsg = '';
                        }
                    }
                }else{
                    errorMsg = '';
                }
            }
        }else{
            errorMsg = 'Please select any record first.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,errorMsg));
        }
        
    }
    
    /*************** Method to get the valid discrepancy values based on record type **************/
    private Set<String> getPickValFromRecType(String recordTypeId){
        
        Set<String> pickListValues = new Set<String>();
        String recordType = [SELECT Id,Name FROM RecordType WHERE Id =:recordTypeId LIMIT 1].Name;
        if(recordType.contains('Open')){
            pickListValues =  new Set<String>{'Timing – Account closed same day as cut off','Legal Obligation',
                'Reopen Request sent','Account is currently Closed'};
                    }
        else if(recordType.contains('Closed')){
            pickListValues =  new Set<String>{'Timing – Account closed same day as cut off','Currently Open with Firm',
                'Inactive close code used','Close code re-sent'};
                    }
        return pickListValues;
    }
    
    /********************************** Method to Update the records *********************************/
    public PageReference updateUMRecords(){
        if(selectedDescStr != NULL && String.isNotBlank(selectedDescStr)){
            Integer count = 0;
            List<PAM_Unmatched__c> umListToUpdate = new List<PAM_Unmatched__c>();
            for(umWrapper wrp : unMatchedWrapList){
                
                if(wrp.isSelected){
                    count++;
                    PAM_Unmatched__c umObj = new PAM_Unmatched__c();
                    umObj.Id = wrp.um.Id;
                    umObj.SCMDUM_Reason_for_Discrepancy__c = selectedDescStr;
                    if(pamRec.recordType.Name.contains('SCM Dispute')){
                        if(selectedDescStr == 'Account submitted for wrong PCode'){
                            if(correctPcodeSelected != NULL && String.isNotBlank(correctPcodeSelected)){
                                umObj.SCMDUM_Correct_PCode__c = correctPcodeSelected;
                            }else{
                                errorMsg = 'Please Select the correct PCode.';
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,errorMsg));
                                return NULL;
                            }
                        }
                        else if(selectedDescStr == 'Incorrect Account Number'){
                            if(correctAccNo != NULL && String.isNotBlank(correctAccNo)){
                                umObj.SCMDUM_Correct_Account_Number__c = correctAccNo;
                            }else{
                                errorMsg = 'Please Enter the correct Account Number.';
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,errorMsg));
                                return NULL;
                            }
                        }
                        else if(selectedDescStr == 'Process Error' || selectedDescStr == 'Mapping or coding matrix error'){
                            if(descReasonComment != NULL && String.isNotBlank(descReasonComment)){
                                umObj.SCMDUM_Reason_for_Discrepancy_Comments__c = descReasonComment;
                            }else{
                                errorMsg = 'Please Enter the comments.';
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,errorMsg));
                                return NULL;
                            }
                        }
                    }else if(pamRec.recordType.Name.contains('IR')){
                        if(descReasonComment != NULL && String.isNotBlank(descReasonComment)){
                            umObj.SCMDUM_Reason_for_Discrepancy_Comments__c = descReasonComment;
                        }
                    }
                    umListToUpdate.add(umObj);
                }
            }
            if(count > 0){
                if(umListToUpdate.size() > 0){
                    update umListToUpdate;
                    init();
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM,'Record Updated Successfully.'));
                }
            }else{
                errorMsg = 'Please Select atleast one record.';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,errorMsg));
            }
        }else{
            errorMsg = 'Please Select the Reason for Discrepancy.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,errorMsg));
        }
        return NULL;
    }
    /***************************Wrapper class for Unmatched and check box *************************************/
    public class umWrapper{
        public boolean isSelected{get;set;}
        public PAM_Unmatched__c um{get;set;}
        
        public umWrapper(boolean isSelected,PAM_Unmatched__c um){
            this.isSelected = isSelected;
            this.um = um;
        }
    }
}