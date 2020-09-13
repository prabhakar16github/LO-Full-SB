public class LRMM_AddExistingCadController {
	
	public String availableConsumerAccountDetailListJson {set; get;}
	public Id cadId {set; get;}
	public String baseUrl{
		get{
			return String.valueOf(System.Url.getSalesforceBaseUrl().toExternalForm());
		}
		set;
	}
	
	public void init(){
		
		List<CounsumerAccountDetailWrapper> availableConsumerAccountDetailList = new List<CounsumerAccountDetailWrapper>(); 
		
		cadId = apexpages.currentpage().getparameters().get('cadId');
		
		system.debug('cadId----->'+cadId);
		
		List<Consumer_Account_Details__c> availableCADList = LRMM_AddExistingCadController.getUnassignedAvailableCadRecords(cadId);
		
		for(Consumer_Account_Details__c consumerAcountObj : availableCADList){
			
			availableConsumerAccountDetailList.add(new CounsumerAccountDetailWrapper(consumerAcountObj));
		}
		
		availableConsumerAccountDetailListJson = JSON.serialize(availableConsumerAccountDetailList);
	}
	
	@RemoteAction
	public static ResponseWrapper initRemote(String masterCadId){
		
		ResponseWrapper res = new ResponseWrapper();
		
		List<CounsumerAccountDetailWrapper> availableConsumerAccountDetailList = new List<CounsumerAccountDetailWrapper>();
		
		try{
			List<Consumer_Account_Details__c> availableCADList = getUnassignedAvailableCadRecords(masterCadId);
			
			for(Consumer_Account_Details__c consumerAcountObj : availableCADList){
				
				availableConsumerAccountDetailList.add(new CounsumerAccountDetailWrapper(consumerAcountObj));
			}
			
			res.resultObj = availableConsumerAccountDetailList;
			res.response = 'Ok';
			res.statusCode = 200;
			
			return res;
		
		}catch(Exception ex){
			
			system.debug('Exception in LRMM_AddExistingCadController.initRemote '+ex);
			
			res.resultObj = ex;
			res.response = 'Error';
			res.statusCode = 500;
			return res;
		} 
		
	}
	
	@RemoteAction
	public static ResponseWrapper assignCadToMasterCad(String selectedCadJson){
		
		system.debug('selectedCadJson---------->'+selectedCadJson);
		
		ResponseWrapper res = new ResponseWrapper();
		
		try{
			SelectedCounsumerAccountDetailWrapper selectedIdObj = (SelectedCounsumerAccountDetailWrapper) JSON.deserialize(selectedCadJson, SelectedCounsumerAccountDetailWrapper.class);
			
			system.debug('selectedIdObj--------------------->'+selectedIdObj);
			
			Set<Id> selectedIds  = new Set<Id>();
			  
			for(String selectedId : selectedIdObj.selectedCadIds){
				selectedIds.add(selectedId);
			}
			
			Map<Id, Consumer_Account_Details__c> consumerAccountDetailsMap = new Map<Id, Consumer_Account_Details__c>([SELECT Id, Name, Account_Balance__c, 
																				Account_Number__c, Consumer_Master_File_Record__c, Last_4_of_CC_Number__c, 
																				Organization_name__c, Original_Creditor_Account_Number__c, 
																				Original_Creditor__c, Portfolio__c, CAD_Consumer_Loan__c, CAD_Credit_Card__c, 
																				CAD_Linked_Account_Balance__c, 
																				CAD_Linked_Account__c, CAD_Linked_Master_CAD__c, Placement_Date__c, 
																				Linked_Master_CAD_Account__c, RecordTypeId  
																			FROM Consumer_Account_Details__c
																			WHERE Id IN :selectedIds OR Id = :selectedIdObj.masterCadId]);
			
			system.debug('consumerAccountDetailsMap----------->'+consumerAccountDetailsMap);
			
			Consumer_Account_Details__c masterCadObj = consumerAccountDetailsMap.get(selectedIdObj.masterCadId);
			
			String linkedRecordTypeId = Schema.SObjectType.Consumer_Account_Details__c.getRecordTypeInfosByName().get('CAD: MCM Linked Account Details').getRecordTypeId();
			
			consumerAccountDetailsMap.remove(selectedIdObj.masterCadId);
			
			if(masterCadObj != null){
				
				for(Consumer_Account_Details__c cadObj : consumerAccountDetailsMap.values()){
					
					Consumer_Account_Details__c tempObj = cadObj;
					tempObj.Consumer_Master_File_Record__c = masterCadObj.Consumer_Master_File_Record__c;
					tempObj.Linked_Master_CAD_Account__c = masterCadObj.Id;
					tempObj.RecordTypeId = linkedRecordTypeId;
					tempObj.CAD_Linked_Account__c = true;
					cadObj = tempObj;
				}
				
			}
			
			if(consumerAccountDetailsMap != Null && consumerAccountDetailsMap.size() > 0){
			
				update consumerAccountDetailsMap.values();
			}
		
			res.response = 'Ok';
			res.statusCode = 200;
			res.resultObj = selectedIdObj.masterCadId;
			return res;
		}catch(Exception ex){
			system.debug('ex---------------->'+ex);
			res.response = 'Error';
			res.resultObj = ex;
			res.errorMessage = 'Error in linking account\'s.';
			res.statusCode = 500;
			return res;
		}
		
	}
	
	private static List<Consumer_Account_Details__c> getUnassignedAvailableCadRecords(String masterCadId){
		
		List<Consumer_Account_Details__c> getCadRecord = [SELECT Id, Name, Consumer_Master_File_Record__c, CAD_Credit_Card__c, CAD_Consumer_Loan__c,
															Organization_name__c 
															FROM Consumer_Account_Details__c 
															WHERE Id =:masterCadId LIMIT 1];
		
		Consumer_Account_Details__c cadCurrentRecord = new Consumer_Account_Details__c();
		
		if(!getCadRecord.isEmpty()){
			cadCurrentRecord = getCadRecord.get(0);
		}
		
		String masterFileVal = cadCurrentRecord.Consumer_Master_File_Record__c;
		String masterOganization = cadCurrentRecord.Organization_name__c;
		String recordTypeId = Schema.SObjectType.Consumer_Account_Details__c.getRecordTypeInfosByName().get('CAD: MCM Individual Account Details').getRecordTypeId();
		
		String query = 'SELECT Id, Name, Account_Balance__c, Account_Number__c, Organization_name__c,Organization_name__r.Name,'+
						+'Consumer_Master_File_Record__r.Name, Consumer_Master_File_Record__c, Original_Creditor__c, Original_Creditor_Account_Number__c,'+ 
						+'CAD_Consumer_Loan__c, CAD_Credit_Card__c, CAD_Linked_Account_Balance__c, CAD_Linked_Account__c, '+
						+'CAD_Linked_Master_CAD__c, Linked_Master_CAD_Account__c,Placement_Date__c FROM Consumer_Account_Details__c '+
						+'WHERE Consumer_Master_File_Record__c = :masterFileVal AND RecordTypeId = :recordTypeId '
						+'AND CAD_Linked_Account__c = false AND Organization_name__c = :masterOganization'; 
																 
		if(cadCurrentRecord.CAD_Credit_Card__c){
			query += ' AND CAD_Credit_Card__c = true';
		}else if(cadCurrentRecord.CAD_Consumer_Loan__c){
			query += ' AND CAD_Consumer_Loan__c = true';
		}												
		
		List<Consumer_Account_Details__c> availableCADList = Database.query(query);
															
		
		system.debug('availableCADList------------->'+availableCADList);
		
		return availableCADList;
		
	}
	
	public class SelectedCounsumerAccountDetailWrapper{
		
		public String masterCadId {set;get;}
		public List<String> selectedCadIds {set;get;}
	
	}
	
	public class ResponseWrapper{
		
		public object resultObj {set;get;}
		public String response{set; get;}
		public String errorMessage{set; get;} 
		public Integer statusCode{set; get;} 
	}
	
	
	public class CounsumerAccountDetailWrapper{
		
		public String id {set;get;}
		public String name {set;get;}
		public String consumerMaterFile {set;get;}
		public String consumerMasterFileName {set;get;}
		public String loanType {set;get;}
		public String organization {set;get;}
		public String organizationName {set;get;}
		public String orignalCreditor {set;get;}
		public String orignalCreditorAccountNumber {set;get;}
		public String mcmAccountNo{set;get;}
		public String placementDate{set;get;}
		public Decimal accountBalance{set;get;}
		
		public CounsumerAccountDetailWrapper(){
			id = '';
			name = '';
			consumerMaterFile = '';
			consumerMasterFileName = '';
			loanType = '';
			organization = '';
			organizationName = '';
			orignalCreditor = '';
			orignalCreditorAccountNumber = '';
			mcmAccountNo = '';
			accountBalance = 0.00;
			placementDate = '';
		}
		
		public CounsumerAccountDetailWrapper(Consumer_Account_Details__c cadObj){
			
			this();
			
			id = cadObj.id;
			name = cadObj.name;
			consumerMaterFile = cadObj.Consumer_Master_File_Record__c == null ? '' : cadObj.Consumer_Master_File_Record__c;
			consumerMasterFileName = cadObj.Consumer_Master_File_Record__c == null ? '' : cadObj.Consumer_Master_File_Record__r.Name;
			
			if(cadObj.CAD_Credit_Card__c){
				loanType = 'Credit Card';
			}else if(cadObj.CAD_Consumer_Loan__c){
				loanType = 'Consumer Loan';
			}
			
			organization = cadObj.Organization_name__c == null ? '' : cadObj.Organization_name__c;
			organizationName = cadObj.Organization_name__c == null ? '' : cadObj.Organization_name__r.Name;
			orignalCreditor = cadObj.Original_Creditor__c == null ? '' : cadObj.Original_Creditor__c;
			orignalCreditorAccountNumber = cadObj.Original_Creditor_Account_Number__c == null ? '' : cadObj.Original_Creditor_Account_Number__c;
			mcmAccountNo = cadObj.Account_Number__c == null ? '' : cadObj.Account_Number__c;
			accountBalance = cadObj.Account_Balance__c == null ? 0.00 : cadObj.Account_Balance__c;
			placementDate = cadObj.Placement_Date__c == null ? '' : String.valueOf(cadObj.Placement_Date__c);
		}
	}
}