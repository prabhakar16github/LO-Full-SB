public without sharing class LinkedAccountAddRemoveController {
    
   	public String navigateAddNewCadUrl{set;get;}
    public String navigate_LC_AddNewCadUrl{set;get;}
   	public String cadId {set;get;}
    
   	public LinkedAccountAddRemoveController(ApexPages.StandardController controller){
    	
    	String baseUrl = String.valueOf(System.Url.getSalesforceBaseUrl().toExternalForm());
    	//System.debug('baseUrl >>  '+baseUrl);
    	String profileName = [Select Id, Name from Profile where Id =: userinfo.getProfileId() LIMIT 1].Name;
    	
    	if(profileName == 'CC - User Access'){
    		
    		baseUrl = baseUrl+'/LCPartnerAccess';
    	}
    	 
    	Consumer_Account_Details__c cadObj = (Consumer_Account_Details__c)controller.getRecord();
    	cadId = cadObj.Id;
        system.debug('cadId >> '+cadId);
    	
    	cadObj = [SELECT Id, Name, Consumer_Master_File_Record__c, Consumer_Master_File_Record__r.Name, Organization_name__c, Organization_name__r.Name,
    				CAD_Credit_Card__c, CAD_Consumer_Loan__c  
    				From Consumer_Account_Details__c WHERE Id = :cadId];
    	
    	String cadPrefixKey = '';
    	
    	Schema.DescribeSObjectResult sobjectCadDescribe = Consumer_Account_Details__c.sObjectType.getDescribe();
    	String recordTypeId = Schema.SObjectType.Consumer_Account_Details__c.getRecordTypeInfosByName().get('CAD: MCM Linked Account Details').getRecordTypeId();
    	
    	if(sobjectCadDescribe != null){
    		
    		cadPrefixKey = sobjectCadDescribe.getKeyPrefix();
            system.debug('cadPrefixKey >> '+cadPrefixKey);
    	}

    	 
    	List<Metadata_Id__c> metadataList = Metadata_Id__c.getall().values();
    	system.debug('metadataList--------->'+metadataList);
    	
    	String cadObjMetaId = '';
    	String cadObjFieldLinkedAccountMetaId = '';
    	String cadObjFieldConsumerMasterFileMetaId = '';
    	String cadObjFieldLinkedAccountCheckboxMetaId = '';
    	String cadObjFieldLinkedAccountOrganizationName = '';
    	String cadObjFieldLinkedAccountCC = '';
    	String cadObjFieldLinkedAccountCL = '';
    	
    	for(Metadata_Id__c metadataCustomSettingObj : metadataList){
    		
    		if(metadataCustomSettingObj.API_Name__c == 'Consumer_Account_Details__c'){
    			cadObjMetaId = metadataCustomSettingObj.Id_of_Metadata__c;
    		}
    		
    		if(metadataCustomSettingObj.API_Name__c == 'Linked_Master_CAD_Account__c'){
    			cadObjFieldLinkedAccountMetaId = metadataCustomSettingObj.Id_of_Metadata__c;
    		}
    		
    		if(metadataCustomSettingObj.API_Name__c == 'Consumer_Master_File_Record__c'){
    			cadObjFieldConsumerMasterFileMetaId = metadataCustomSettingObj.Id_of_Metadata__c;
    		}
    		
    		if(metadataCustomSettingObj.API_Name__c == 'CAD_Linked_Account__c'){
    			cadObjFieldLinkedAccountCheckboxMetaId = metadataCustomSettingObj.Id_of_Metadata__c;
    		}
    		
    		if(metadataCustomSettingObj.API_Name__c == 'Organization_name__c'){
    			cadObjFieldLinkedAccountOrganizationName = metadataCustomSettingObj.Id_of_Metadata__c;
    		}
    		if(metadataCustomSettingObj.API_Name__c == 'CAD_Credit_Card__c'){
    			cadObjFieldLinkedAccountCC = metadataCustomSettingObj.Id_of_Metadata__c;
    		}
    		if(metadataCustomSettingObj.API_Name__c == 'CAD_Consumer_Loan__c'){
    			cadObjFieldLinkedAccountCL = metadataCustomSettingObj.Id_of_Metadata__c;
    		}
    	}
    	
    	
    	navigateAddNewCadUrl = baseUrl + '/' + cadPrefixKey + '/e?CF' + cadObjFieldLinkedAccountMetaId + '=' + cadObj.Name + '&RecordType=' 
    					+ recordTypeId + '&CF'+cadObjFieldLinkedAccountMetaId+'_lkid=' + cadId +'&ent=' + cadObjMetaId 
    					+ '&CF'+cadObjFieldConsumerMasterFileMetaId+'=' +cadObj.Consumer_Master_File_Record__r.Name 
    					+ '&CF'+cadObjFieldConsumerMasterFileMetaId+'_lkid=' + cadObj.Consumer_Master_File_Record__c
    					+ '&'+cadObjFieldLinkedAccountCheckboxMetaId +'=1'
    					+ '&CF'+cadObjFieldLinkedAccountOrganizationName + '=' + cadObj.Organization_name__r.Name
    					+ '&CF'+cadObjFieldLinkedAccountOrganizationName +'_lkid =' + cadObj.Organization_name__c;
        
        
    	if(cadObj.CAD_Credit_Card__c){
    		navigateAddNewCadUrl += '&'+cadObjFieldLinkedAccountCC +'=1';
    	}
    	
    	if(cadObj.CAD_Consumer_Loan__c){
    		navigateAddNewCadUrl += '&'+cadObjFieldLinkedAccountCL +'=1';
    	} 
    }
    
    /* Method Added for Lightning. */
    @AuraEnabled
    public static Consumer_Account_Details__c fetchMasterCadRecords(Id MasterId, string selectedRecTypeId){
        List<Consumer_Account_Details__c> cadList = [SELECT Id,Consumer_Master_File_Record__c,Linked_Master_CAD_Account__c,
                                                     Organization_name__c,CAD_Credit_Card__c,CAD_Consumer_Loan__c,
                                                     CAD_Linked_Account__c,RecordType.Name
                                                     FROM Consumer_Account_Details__c 
                                                     WHERE Id=: MasterId];
        
        List<RecordType> rectype = [select Id,Name from RecordType where name='CAD: MCM Linked Account Details'];
        
        Consumer_Account_Details__c cad = new Consumer_Account_Details__c();
        cad.Consumer_Master_File_Record__c = cadList[0].Consumer_Master_File_Record__c;
        cad.Linked_Master_CAD_Account__c = MasterId;//cadList[0].Id;
        cad.Organization_name__c = cadList[0].Organization_name__c;
        cad.CAD_Credit_Card__c = cadList[0].CAD_Credit_Card__c;
        cad.CAD_Consumer_Loan__c = cadList[0].CAD_Consumer_Loan__c;
        
        
        if(string.isNotBlank(selectedRecTypeId)){
           cad.RecordTypeId = selectedRecTypeId;
        }else{
            cad.RecordTypeId = rectype[0].Id;
        }
        
       
        /*if(cadList[0].RecordType.Name == 'CAD: MCM Account Details')
            cad.CAD_Linked_Account__c = false;*/
         if(string.isNotBlank(selectedRecTypeId)){
            cad.CAD_Linked_Account__c = false;
        }
        else
            cad.CAD_Linked_Account__c = true;
        System.debug('cad >>>  '+cad);
        
        return cad;
    }
    
    /* Method Added for Lightning. */
    @AuraEnabled
     public static Map<Id,String> getListOfRecordType(){
        Map<Id,String> recordTypeMap = new Map<Id,String>();
        List<Schema.RecordTypeInfo> recordTypeInfoList = Consumer_Account_Details__c.SObjectType.getDescribe().getRecordTypeInfos();
        for(RecordTypeInfo rt: recordTypeInfoList) {
            if(rt.isAvailable()) {
               recordTypeMap.put(rt.getRecordTypeId(),rt.getName()); 
            }
        }    
        return recordTypeMap; 
    }
}