public class IR_CustomDownloadAttachmentsController { 
    
    public List<PAMAttachmentWrapper> pamWraps {set; get;}
    public String SelectedRecordType{get; set;}
    public Boolean isFromUpdateStatus = false;
    public String sfbaseUrl{
        get{
            return sfbaseUrl == null ? String.valueOf(System.Url.getSalesforceBaseUrl().toExternalForm()) : sfbaseUrl;  
        }set;
    }
    
    public void init(){
        Map<Id, Process_Adherence_Monitoring__c> pamByPamId = new Map<Id, Process_Adherence_Monitoring__c>();
        Map<Id, List<Attachment>> attachmentsByPamId = new Map<Id, List<Attachment>>(); 
        
        Id lo_IRRecorTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR').getRecordTypeId();
        Id acf_IRRecorTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR').getRecordTypeId();
        
        Set<Id> recTypeIdSet = new Set<Id>{lo_IRRecorTypeId,acf_IRRecorTypeId};
            String statusAccountNoAdded = 'Account Numbers Added';
        pamWraps = new List<PAMAttachmentWrapper>();  
        
        
        string query = 'SELECT Id, Name, Organization_Name__r.Name, Status__c,IR_Open_Inventory_Act_Volume__c, ';
        query += 'IR_Excluded_From_Status_Update__c, IR_Is_Attachment_Downloaded__c ';
        query += 'FROM Process_Adherence_Monitoring__c WHERE Status__c = :statusAccountNoAdded';
        
        if(SelectedRecordType != null ){
            String pamIrRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get(SelectedRecordType).getRecordTypeId();
            query += ' AND recordTypeId = :pamIrRecordTypeId ';
            if(SelectedRecordType == 'LO IR'){
                query += ' AND Account_Type__c  = \'Legacy\'';
            }
        }else{
            query += ' AND ((recordTypeId =: lo_IRRecorTypeId AND Account_Type__c  = \'Legacy\') OR recordTypeId =: acf_IRRecorTypeId)';
        }
        List<Process_Adherence_Monitoring__c> pamRecordsList = Database.query(query);
        if(pamRecordsList.size() > 0){
            pamByPamId.putAll(pamRecordsList);  
            List<Attachment> attachmentsList = [SELECT Id, Name, ParentId FROM Attachment WHERE ParentId IN :pamByPamId.keySet()];
            
            for(Attachment attachment : attachmentsList){
                if(attachmentsByPamId.containsKey(attachment.ParentId)){
                    List<Attachment> temp = attachmentsByPamId.get(attachment.ParentId);
                    temp.add(attachment);
                    attachmentsByPamId.put(attachment.ParentId, temp);
                }else{
                    attachmentsByPamId.put(attachment.ParentId, new List<Attachment> {attachment});
                }
            }
            
            for(Id pamId : pamByPamId.keySet()){
                PAMAttachmentWrapper pamWrap = new PAMAttachmentWrapper();
                pamWrap.pam = pamByPamId.get(pamId);
                List<Attachment> attachments = new List<Attachment>();
                if(attachmentsByPamId.containsKey(pamId)){
                    attachments = attachmentsByPamId.get(pamId); 
                }
                pamWrap.attachments = attachments;
                pamWraps.add(pamWrap);  
            }
            
            if(pamWraps.isEmpty() && isFromUpdateStatus == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'No Records Found.'));
            }
        }
        else{
            pamWraps.clear();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'No Records Found.'));
        }
    }
    
    public List<SelectOption> getPAMRecordTypeList(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','All'));
        options.add(new SelectOption('LO IR','Legacy'));
        options.add(new SelectOption('ACF IR','ACF'));
        return options;
    }
    
    public void updateStatus(){
        try{
            List<Process_Adherence_Monitoring__c> listToUpdate = new List<Process_Adherence_Monitoring__c>(); 
            for(PAMAttachmentWrapper pamWrap : pamWraps){
                if(!pamWrap.pam.IR_Excluded_From_Status_Update__c){
                    pamWrap.pam.Status__c = 'Accounts Sent To ISeries';
                }else{
                    pamWrap.pam.IR_Excluded_From_Status_Update__c = true;
                }
                listToUpdate.add(pamWrap.pam);
            }
            update listToUpdate;
            isFromUpdateStatus = true;
            init();
            isFromUpdateStatus = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Successfully Updated.'));
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, ex.getMessage()));
        }
    }
    
    @RemoteAction
    public static void updateIsDownloaded(String pamId){
        
        Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c();
        pamObj.Id = pamId;
        pamObj.IR_Is_Attachment_Downloaded__c = true;
        update pamObj;       
    }
    
    public class PAMAttachmentWrapper{
        public List<Attachment> attachments {set; get;}
        public Process_Adherence_Monitoring__c pam {set; get;}
    }
    
}