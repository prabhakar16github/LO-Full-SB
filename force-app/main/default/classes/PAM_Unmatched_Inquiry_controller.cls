public class PAM_Unmatched_Inquiry_controller {
	
	public Case caseObj{get;set;}
    public PAM_Unmatched__c pamUmObj{get;set;}
    
    Public PAM_Unmatched_Inquiry_controller(){
        
        caseObj = new Case();
        pamUmObj = new PAM_Unmatched__c();
        String recordId = apexpages.currentpage().getparameters().get('id');
        
        pamUmObj = [SELECT Id, Name, PAMUM_Account_Number__c, PAMUM_Process_Adherence_Monitoring__c, 
        				PAMUM_Process_Adherence_Monitoring__r.RecordTypeId, PAMUM_Organization_Name__c, 
        				PAMUM_Organization_Name__r.Firm_Specialist__c, RecordTypeId, RecordType.Name, PAMUM_Organization_Name__r.Firm_ID__c  
        			FROM PAM_Unmatched__c 
        			WHERE Id = :recordId];
        			
		RecordTypesWrapper recTypeWrap = setRecordTypeValues();
        caseObj.AccountId  = pamUmObj.PAMUM_Organization_Name__c;
        caseObj.PAM_Unmatched_Record__c = pamUmObj.Id;
        caseObj.Status = 'Awaiting Response';
        caseObj.Reason = 'Process Adherence Monitoring (PAM)';
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Operations - PAM').getRecordTypeId();
        caseObj.Turn_Off_Auto_response__c = true;
		caseObj.Subcategories__c = getSubcategories(recTypeWrap);
    	caseObj.Type = 'SME';
    	caseObj.Origin = 'Internal';
    	caseObj.MCM_Account__c = null;
    	caseObj.Subject = getSubject(recTypeWrap);

    	if( pamUmObj.PAMUM_Organization_Name__c != null && pamUmObj.PAMUM_Organization_Name__r.Firm_Specialist__c != null ){
        	caseObj.OwnerId = pamUmObj.PAMUM_Organization_Name__r.Firm_Specialist__c;
        }
    	
    }
    
    private String getSubject(RecordTypesWrapper recTypeWrap){
    	String subject = '';
    	
    	if( pamUmObj.PAMUM_Organization_Name__r.Firm_ID__c != null ){
        	subject = pamUmObj.PAMUM_Organization_Name__r.Firm_ID__c + ' ' + pamUmObj.PAMUM_Account_Number__c;	
    	}else{
    		subject = pamUmObj.PAMUM_Account_Number__c;
    	}
    	
    	if(recTypeWrap.scmdUmRecordType == pamUmObj.RecordTypeId){
	    	subject += ' SCMDUM Record Inquiry';
        }else if(recTypeWrap.irUmRecordTypes.contains(pamUmObj.RecordTypeId)){
        	subject += ' IRUM Record Inquiry';
        }
    	
    	return subject;
    }
    
    private String getSubcategories(RecordTypesWrapper recTypeWrap){
    	String subCategories = '';
    	if(recTypeWrap.scmdUmRecordType == pamUmObj.RecordTypeId || recTypeWrap.scmdUmACFRecordType == pamUmObj.RecordTypeId || recTypeWrap.scmdUmDMRecordType == pamUmObj.RecordTypeId){
	    	subCategories = 'SCMDUM';
        }else if(recTypeWrap.irUmRecordTypes.contains(pamUmObj.RecordTypeId)){
        	subCategories = 'IRUM';
        }
        return subCategories;
    }
    
    private RecordTypesWrapper setRecordTypeValues(){
    	RecordTypesWrapper recTypeWrap = new RecordTypesWrapper();
    	recTypeWrap.scmdUmRecordType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId();
    	recTypeWrap.scmdUmACFRecordType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF SCMDUM').getRecordTypeId();
        //Added on 24-03-2020 DM SCM
        recTypeWrap.scmdUmDMRecordType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM SCMDUM').getRecordTypeId();

    	recTypeWrap.irUmRecordTypes = new Set<Id>();
    	recTypeWrap.irUmRecordTypes.add(Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Closed').getRecordTypeId());
        recTypeWrap.irUmRecordTypes.add(Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId());
        recTypeWrap.irUmRecordTypes.add(Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Closed').getRecordTypeId());
        recTypeWrap.irUmRecordTypes.add(Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Open').getRecordTypeId());
        // created on 20/03/2020
        recTypeWrap.irUmRecordTypes.add(Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Closed').getRecordTypeId());
        recTypeWrap.irUmRecordTypes.add(Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Open').getRecordTypeId());
        
        return recTypeWrap;
    }
    
     public PageReference saveCase(){
        try{
            insert caseObj;
            return new PageReference('/'+pamUmObj.id);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
        return null;
    }
    
    public class RecordTypesWrapper{
    	Id scmdUmRecordType {set; get;}
    	Set<Id> irUmRecordTypes {set; get;}
    	Id scmdUmACFRecordType {set; get;}
        Id scmdUmDMRecordType{set;get;}
            
    }
}