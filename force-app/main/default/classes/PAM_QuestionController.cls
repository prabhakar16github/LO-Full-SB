public class PAM_QuestionController{
    
    public Case caseObj{get;set;}
    public Process_Adherence_Monitoring__c pamObj{get;set;}
    public Boolean isScmdView {get; set;} 
    public Boolean isIrView {get; set;}
    
    public PAM_QuestionController(){
        caseObj = new Case();
        pamObj = new Process_Adherence_Monitoring__c();
        isScmdView = false;
        isIrView = false;
        String recordId = apexpages.currentpage().getparameters().get('id');
        Set<Id> scmdRecordstypeIds = new Set<Id>();
        Set<Id> scmdACFRecordstypeIds = new Set<Id>(); 
        //Added on 03-Feb-2020
        Set<Id> scmdDMRecordstypeIds = new Set<Id>();
        
        pamObj = [SELECT Name, OwnerId, Account_Number__c, Organization_Name__c, Organization_Name__r.Firm_Specialist__c, 
                  RecordTypeId, RecordType.Name,Organization_Name__r.Firm_Specialist_ACF__c	
                  FROM Process_Adherence_Monitoring__c 
                  WHERE id =: recordId];
        
        caseObj.AccountId  = pamObj.Organization_Name__c;
        caseObj.Status = 'New';
        caseObj.Reason = 'Process Adherence Monitoring (PAM)';
        
        scmdRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute').getRecordTypeId());
        scmdRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute - Account #s Sent').getRecordTypeId());
        scmdRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute - No PCodes Sent').getRecordTypeId());
        
        scmdACFRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute').getRecordTypeId());
        scmdACFRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute - Account #s Sent').getRecordTypeId());
        scmdACFRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute - No PCodes Sent').getRecordTypeId());
        
        // Added on 03-Feb-2020 for DM SCM process
        scmdDMRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM SCM Dispute').getRecordTypeId());
        scmdDMRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM SCM Dispute - Account #s Sent').getRecordTypeId());
        scmdDMRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM SCM Dispute - No PCodes Sent').getRecordTypeId());
        
        
        
        String userName = '';
        if(pamObj.RecordType.Name == 'LO FRB'){
            caseObj.Subcategories__c = 'FRB';
        //    userName = 'Sara Christopherson';
        }else if(pamObj.RecordType.Name == 'LO CCM - JR' || pamObj.RecordType.Name == 'LO CCM - SR'){
            caseObj.Subcategories__c = 'Court Cost Monitoring';
        //    userName = 'Brittany Tholund-Schafer';
        }else if(pamObj.RecordType.Name == 'LO SOL'){
            caseObj.Subcategories__c = 'SOL';
        //    userName = 'Alisha Schuldt';
        }else if(pamObj.RecordType.Name == 'LO PNA'){
            caseObj.Subcategories__c = 'PNA';
            
        }else if(pamObj.RecordType.Name == 'LO PSNM' || pamObj.RecordType.Name == 'DM PSNM'){
        	caseObj.Subcategories__c = 'PSNM';
        }
        /************ Added on 16/Aug/2019 (for ACF IR) ********************/
        else if(pamObj.RecordType.Name == 'ACF IR'){
            caseObj.Subcategories__c = 'IR';
        }
        /************ Added on 21/Jan/2019 (for DM IR) ********************/
        else if(pamObj.RecordType.Name == 'DM IR'){
            caseObj.Subcategories__c = 'IR';
        }
        /*****************Added on 25-NOV-2019*************************/
        else if(pamObj.RecordType.Name == 'LO RSNM' || pamObj.RecordType.Name == 'DM RSNM'){
            caseObj.Subcategories__c = 'RSNM';
        }
        
        
        //changed on 30-10-2019
        if(pamObj.RecordType.Name == 'ACF IR' || pamObj.RecordType.Name == 'ACF IR - Account #\'s Sent'){
            if(pamObj.Organization_Name__c != null && pamObj.Organization_Name__r.Firm_Specialist_ACF__c != null ){
                caseObj.OwnerId = pamObj.Organization_Name__r.Firm_Specialist_ACF__c;
                System.debug('caseObj.OwnerId >>>   '+caseObj.OwnerId);
                caseObj.Subcategories__c = 'IR';
                caseObj.MCM_Account__c = null;
                isIrView = true;
            }
        }
        else{
            if(pamObj.Organization_Name__c != null && pamObj.Organization_Name__r.Firm_Specialist__c != null){
                caseObj.OwnerId = pamObj.Organization_Name__r.Firm_Specialist__c;
                System.debug('caseObj.OwnerId >>>   '+caseObj.OwnerId);
            }  
        }
        
        //Last Modified on 20/mar/2020
        if(pamObj.RecordType.Name == 'DM IR' || pamObj.RecordType.Name == 'DM IR - Account #\'s Sent'){
            if(pamObj.Organization_Name__c != null && pamObj.Organization_Name__r.Firm_Specialist_ACF__c != null ){
                caseObj.OwnerId = pamObj.Organization_Name__r.Firm_Specialist_ACF__c;
                System.debug('caseObj.OwnerId >>>   '+caseObj.OwnerId);
                caseObj.Subcategories__c = 'IR';
                caseObj.MCM_Account__c = null;
                isIrView = true;
            }
        }
        else{
            if(pamObj.Organization_Name__c != null && pamObj.Organization_Name__r.Firm_Specialist__c != null){
                caseObj.OwnerId = pamObj.Organization_Name__r.Firm_Specialist__c;
                System.debug('caseObj.OwnerId >>>   '+caseObj.OwnerId);
            }  
        }
        
        if(pamObj.RecordType.Name.contains('ACF SCM Dispute') && pamObj.Organization_Name__c != null
           && pamObj.Organization_Name__r.Firm_Specialist_ACF__c != NULL){
            caseObj.OwnerId = pamObj.Organization_Name__r.Firm_Specialist_ACF__c;
        }
        
        
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Operations - PAM').getRecordTypeId();
        caseObj.Process_Adherence_Monitoring__c = pamObj.id;
        caseObj.MCM_Account__c = pamObj.Account_Number__c;
        caseObj.Turn_Off_Auto_response__c = false;
        
        if( scmdRecordstypeIds.contains(pamObj.recordTypeId) || scmdACFRecordstypeIds.contains(pamObj.recordTypeId) || scmdDMRecordstypeIds.contains(pamObj.recordTypeId)){ // used only for the scmd dispute process
        	
        	isScmdView = true;
        	
        	caseObj.Subcategories__c = 'SCMD';
        	caseObj.Type = 'SME';
        	caseObj.Origin = 'Email - Ext';
        	caseObj.MCM_Account__c = null;
        	
        }else if(pamObj.RecordType.Name == 'LO IR' || pamObj.RecordType.Name == 'LO IR - Account #\'s Sent'){
        	
            caseObj.Subcategories__c = 'IR';
            caseObj.MCM_Account__c = null;
            isIrView = true;
        }
        
    }
    
    public PageReference saveCase(){
        try{
        	
            insert caseObj;
            return new PageReference('/'+pamObj.id);
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
        return null;
    }
   
}