public class RelatedCADForLRMMObjController {
	
	public List<Consumer_Account_Details__c> childCads {set; get;}
    
    public RelatedCADForLRMMObjController(ApexPages.StandardController controller){
    	
    	SObject lrmmSobject = controller.getRecord();
    	
    	String sObjectRecordId = controller.getRecord().Id;
    	
    	if(sObjectRecordId != null && sObjectRecordId != ''){
    	
	    	String sobjectName = lrmmSobject.getSObjectType().getDescribe().getName();
	    	
	    	Map<String, Schema.SObjectField> sobjectFieldsMap = lrmmSobject.getSObjectType().getDescribe().fields.getMap(); 
	    	
	    	String queryField = '';
	    	
	    	for(String fieldName : sobjectFieldsMap.keySet()){
	    		
	    		List<Schema.sObjectType> refrenceToList = sobjectFieldsMap.get(fieldName).getDescribe().getReferenceTo();
	    		
	    		if(!refrenceToList.isEmpty() && String.valueOf(sobjectFieldsMap.get(fieldName).getDescribe().getType()) == 'REFERENCE'
	    			&& String.valueOf(refrenceToList.get(0)) == 'Consumer_Account_Details__c'){
	    				
	    			queryField = String.valueOf(sobjectFieldsMap.get(fieldName).getDescribe().getName());
	    			
	    			
	    		}
	    	}
	    	
	    	String query = 'SELECT Id, Name ,'+queryField+' FROM '+sobjectName +' WHERE Id = \''+sObjectRecordId+'\' LIMIT 1';
	    	
	    	
	    	List<Sobject> lrmmSobjectList = Database.query(query);
	    	
	    	if(!lrmmSobjectList.isEmpty()){
	    		
	    		lrmmSobject = lrmmSobjectList.get(0);
	    	}
	    	
	    	String masterCadId = String.valueOf(lrmmSobject.get(queryField)) == null ? '' : String.valueOf(lrmmSobject.get(queryField));
	    	
	    	List<Consumer_Account_Details__c> childConsumerAccountDetailsList = [SELECT Id, Name, Account_Balance__c, 
																					Account_Number__c, Consumer_Master_File_Record__c, Last_4_of_CC_Number__c, 
																					Organization_name__c, Original_Creditor_Account_Number__c, 
																					Original_Creditor__c, Portfolio__c, CAD_Consumer_Loan__c, 
																					CAD_Credit_Card__c, CAD_Linked_Account_Balance__c, 
																					CAD_Linked_Account__c, CAD_Linked_Master_CAD__c, Placement_Date__c, 
																					Linked_Master_CAD_Account__c,RecordTypeId,Consumer_Master_File_Record__r.name   
																				FROM Consumer_Account_Details__c
																				WHERE Linked_Master_CAD_Account__c = :masterCadId];
																				
			
			childCads = childConsumerAccountDetailsList;
    	}
    	
    }
}