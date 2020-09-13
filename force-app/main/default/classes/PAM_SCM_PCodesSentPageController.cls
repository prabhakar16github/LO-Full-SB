public class PAM_SCM_PCodesSentPageController{
	
	public transient String pamValues {set; get;}
	public Boolean disableEditSaveMode {set; get;}
	public Id pamId {set; get;}
	
	public String baseUrl{
		get{
			return String.valueOf(System.Url.getSalesforceBaseUrl().toExternalForm());
		}
		set;
	}
	
	public void init(){
		try{
			disableEditSaveMode = false;
			pamId = ApexPages.currentPage().getParameters().get('id');
			PAMWrapper pamWrapObj =  PAM_SCM_PCodesSentPageController.getPamValues(pamId);
			
			// for LO
			Id pamLOAccountSentRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute - Account #s Sent').getRecordTypeId();
			Id pamLONoPcodesTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute - No PCodes Sent').getRecordTypeId();
			
			// for ACF
			Id pamACFAccountSentRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute - Account #s Sent').getRecordTypeId();
			Id pamACFNoPcodesTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute - No PCodes Sent').getRecordTypeId();
			
			if(pamLOAccountSentRecordTypeId.equals(pamWrapObj.recordtypeId) || pamLONoPcodesTypeId.equals(pamWrapObj.recordtypeId) 
				|| pamACFAccountSentRecordTypeId.equals(pamWrapObj.recordtypeId) || pamACFNoPcodesTypeId.equals(pamWrapObj.recordtypeId)){
					
				disableEditSaveMode = true;
			}
			ApexDebugLog.debug('PAM_SCM_PCodesSentPageController init pamWrapObj '+JSON.serialize(pamWrapObj));
			pamValues = JSON.serialize(pamWrapObj);	
		}catch(Exception ex){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
		}
		
	}
	
	private static PAMWrapper getPamValues(Id pamId){
		Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c(); 
		pamObj = [SELECT Id, Name, recordTypeId, SCMD_Written_Dispute_Account_s__c, SCMD_Oral_Dispute_Account_s__c, 
						SCMD_MailOutValidation_of_Debt_Account_s__c
					FROM Process_Adherence_Monitoring__c 
					WHERE Id = :pamId LIMIT 1];
		
		ApexDebugLog.debug('PAM_SCM_PCodesSentPageController getPamValues pamObj '+JSON.serialize(pamObj));					
		PAMWrapper pamWrapObj = new PAMWrapper(pamObj); 
		return pamWrapObj;
	}
	
	@RemoteAction
	public static ResponseWrapper savePcodeSentDetails(String pcodeSentValues){
		ResponseWrapper response = new ResponseWrapper();
		try{
			response.isError = false;
			PAMWrapper pamObj = (PAMWrapper)JSON.deserialize(pcodeSentValues, PAMWrapper.class);
			ApexDebugLog.debug('PAM_SCM_PCodesSentPageController savePcodeSentDetails pamObj '+JSON.serialize(pamObj));
			Process_Adherence_Monitoring__c pamRecordToSave = new Process_Adherence_Monitoring__c(); 
			pamRecordToSave.Id = pamObj.id;
			pamRecordToSave.SCMD_Oral_Dispute_Account_s__c = EncodingUtil.urlDecode(pamObj.oralDisputeAccounts,'UTF-8');
			pamRecordToSave.SCMD_OralDispAcc_Vol__c = countAccountNumbers(String.valueOf(pamRecordToSave.SCMD_Oral_Dispute_Account_s__c));
			pamRecordToSave.SCMD_Written_Dispute_Account_s__c = EncodingUtil.urlDecode(pamObj.writtenDisputeAccounts,'UTF-8');
			pamRecordToSave.SCMD_WrittenDispAccVol__c = countAccountNumbers(String.valueOf(pamRecordToSave.SCMD_Written_Dispute_Account_s__c));
			pamRecordToSave.SCMD_MailOutValidation_of_Debt_Account_s__c = EncodingUtil.urlDecode(pamObj.mailedOutValidationAccounts,'UTF-8');
			pamRecordToSave.SCMD_MailOutValidDebt_Acc_Vol__c = countAccountNumbers(String.valueOf(pamRecordToSave.SCMD_MailOutValidation_of_Debt_Account_s__c));
			
			ApexDebugLog.debug('PAM_SCM_PCodesSentPageController savePcodeSentDetails pamRecordToSave '+JSON.serialize(pamRecordToSave));
			update pamRecordToSave;
			response.response = getPamValues(pamObj.Id);
		}catch(DmlException ex){
			response.isError = true;
			response.errorMessage = ex.getDmlMessage(0);
		}catch(Exception ex){
			response.isError = true;
			response.errorMessage = ex.getMessage();
			ApexDebugLog.debug('PAM_SCM_PCodesSentPageController savePcodeSentDetails ex.getMessage() '+ex.getMessage()); 
		}
		return response;
	}
	
	private static Integer countAccountNumbers(String accountNumbersStr){
		
		Integer countValue = 0;
		if(accountNumbersStr == null){
			return countValue;
		}
		accountNumbersStr = accountNumbersStr.trim().toLowerCase();
		List<String> accountNumbers;
		accountNumbers = accountNumbersStr.replaceAll('(\r\n|\n|\r)', ',').split(',');
		if(accountNumbersStr != '' && accountNumbers != null && accountNumbers.size() != 0){
			countValue = accountNumbers.size();
		} 
		return countValue;
	}
	
	
	public class ResponseWrapper{
		object response {set; get;}
		String errorMessage {set; get;}
		Boolean isError {set; get;}
	}
	
	
	public class PAMWrapper{
		public Id id {set; get;}
		public Id recordtypeId {set; get;}
		public String oralDisputeAccounts {set; get;}
		public List<String> oralDisputeAccountsList {set; get;}
		public String writtenDisputeAccounts{set; get;}
		public List<String> writtenDisputeAccountsList{set; get;}
		public String mailedOutValidationAccounts {set; get;}
		public List<String> mailedOutValidationAccountsList{set; get;}
		
		public PAMWrapper(){
			id = null;
			recordtypeId = null;
			oralDisputeAccounts = '';
			oralDisputeAccountsList = new List<String>();
			writtenDisputeAccounts = '';
			writtenDisputeAccountsList = new List<String>();
			mailedOutValidationAccounts = '';
			mailedOutValidationAccountsList = new List<String>();
		}
		
		public PAMWrapper(Process_Adherence_Monitoring__c pamObj){
			this();
			id = pamObj.Id;
			recordtypeId = pamObj.recordTypeId;
			oralDisputeAccounts = pamObj.SCMD_Oral_Dispute_Account_s__c == null ? '' 
									: EncodingUtil.urlEncode(String.valueOf(pamObj.SCMD_Oral_Dispute_Account_s__c), 'UTF-8');
			if(pamObj.SCMD_Oral_Dispute_Account_s__c != null){
				oralDisputeAccountsList = String.valueOf(pamObj.SCMD_Oral_Dispute_Account_s__c).replaceAll('(\r\n|\n|\r)', ',').split(',');
			}
			writtenDisputeAccounts = pamObj.SCMD_Written_Dispute_Account_s__c == null ? '' 
									: EncodingUtil.urlEncode(String.valueOf(pamObj.SCMD_Written_Dispute_Account_s__c), 'UTF-8');
			if(pamObj.SCMD_Written_Dispute_Account_s__c != null){
				writtenDisputeAccountsList = String.valueOf(pamObj.SCMD_Written_Dispute_Account_s__c).replaceAll('(\r\n|\n|\r)', ',').split(',');
			}
			mailedOutValidationAccounts = pamObj.SCMD_MailOutValidation_of_Debt_Account_s__c == null ? '' 
											: EncodingUtil.urlEncode(String.valueOf(pamObj.SCMD_MailOutValidation_of_Debt_Account_s__c), 'UTF-8');
			if(pamObj.SCMD_MailOutValidation_of_Debt_Account_s__c != null){
				mailedOutValidationAccountsList = String.valueOf(pamObj.SCMD_MailOutValidation_of_Debt_Account_s__c).replaceAll('(\r\n|\n|\r)', ',').split(',');
			}
		}
	}
}