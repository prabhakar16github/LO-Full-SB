public class IRUM_SendCreationHandlerUtility {
	
	public static final Integer pamUnmatchedLimit = 9999;
	public static final String CHECKBOX_SCHEDULER_NAME = 'IRUM_SendCreationHandleScheduler';
	public static void processPam(List<Process_Adherence_Monitoring__c> irPamList){
		List<Messaging.SingleEmailMessage> sendMailToContactList = new List<Messaging.SingleEmailMessage>();
		Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccountId = new Map<Id, List<Process_Adherence_Monitoring__c>>();
    	Map<Id, Account> accountByAccountId = new Map<Id, Account>();
		Set<Id> pamIds = new Set<Id>();
		for(Process_Adherence_Monitoring__c pamObj : irPamList){
			if(pamObj.PAM_Unmatched__r.size() > 0 ){
				pamIds.add(pamObj.Id);
			}
		}
		List<Process_Adherence_Monitoring__c> pamList = getPamList(pamIds);
		List<PAM_Unmatched__c> pamUnmatchedList = getUMPamList(pamIds);
		Map<Id, List<PAM_Unmatched__c>> irUmListByPamId = getListPamUmByPamId(pamUnmatchedList);
    	if(!pamList.isEmpty()){
	    	mapValuesByAccount(pamListByAccountId, pamList);
    	}
    	accountByAccountId = getAccountRecordsIrMap(pamListByAccountId.keySet());
    	sendMailToContactList = createUnmatchedCreationEmails(accountByAccountId, pamListByAccountId);
    	if(!sendMailToContactList.isEmpty()){
	    	sendMail(sendMailToContactList);
    	}
    	updateIrUmRecords(pamUnmatchedList);
	}
	
	@TestVisible
	private static void updateIrUmRecords(List<PAM_Unmatched__c> pamUnmatchedList){
		List<PAM_Unmatched__c> recordsToUpdate = new List<PAM_Unmatched__c>();
		for(PAM_Unmatched__c irUmObj : pamUnmatchedList){
			irUmObj.SCMDUM_Record_Creation_Notification_Sent__c = true;
			recordsToUpdate.add(irUmObj);
    	}
    	if(!recordsToUpdate.isEmpty()){
	    	update recordsToUpdate;
    	}
	}
	
	@TestVisible
	private static Map<Id, List<PAM_Unmatched__c>> getListPamUmByPamId(List<PAM_Unmatched__c> pamUnmatchedList){
		Map<Id, List<PAM_Unmatched__c>> irUmListByPamId = new Map<Id, List<PAM_Unmatched__c>>();
		for(PAM_Unmatched__c pamUnmatched : pamUnmatchedList){
			if(irUmListByPamId.containsKey(pamUnmatched.PAMUM_Process_Adherence_Monitoring__c)){
				List<PAM_Unmatched__c> pamUmTemp = irUmListByPamId.get(pamUnmatched.PAMUM_Process_Adherence_Monitoring__c);
				pamUmTemp.add(pamUnmatched);
				irUmListByPamId.put(pamUnmatched.PAMUM_Process_Adherence_Monitoring__c, pamUmTemp);
			}else{
				irUmListByPamId.put(pamUnmatched.PAMUM_Process_Adherence_Monitoring__c, new List<PAM_Unmatched__c> {pamUnmatched});
			}
		}
		return irUmListByPamId;  
	}
	
	@TestVisible
	private static List<Messaging.SingleEmailMessage> createUnmatchedCreationEmails(Map<Id, Account> accountByAccountId, 
																		Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccountId){
		List<Messaging.SingleEmailMessage> sendMailToContactList = new List<Messaging.SingleEmailMessage>();
		for( Id accountId : accountByAccountId.keySet() ){
    		List<String> address = new List<String>();
    		List<AccountContactRelation> accountContactRelationList = accountByAccountId.get(accountId).AccountContactRelations;
    		List<Process_Adherence_Monitoring__c> pamTempList = new List<Process_Adherence_Monitoring__c>(); 
    		if( pamListByAccountId.containsKey(accountId) ){
    			pamTempList = pamListByAccountId.get(accountId);
    		}
    		for( Process_Adherence_Monitoring__c pamObj : pamTempList ){
	    		for( AccountContactRelation accountContactRelationObj : accountContactRelationList ){
					Messaging.SingleEmailMessage mail = IR_UnmatchedService.getInitialUnmatchedNotification(accountContactRelationObj, pamObj
																								, accountByAccountId.get(accountId));
	    			sendMailToContactList.add(mail);   			
	    		}
    		}
    	}
    	return sendMailToContactList;
	}
	
	@TestVisible
    private static void sendMail(List<Messaging.SingleEmailMessage> sendMailToContactList){
    	Messaging.sendEmail(sendMailToContactList);
    }
    
    @TestVisible
    private static Map<Id, Account> getAccountRecordsIrMap(Set<Id> accountIdSet){
    	Map<Id, Account> accountByAccountId = new Map<Id, Account>([SELECT Id, Name, Firm_ID__c, 
			    														(SELECT Id, ContactId, Contact.firstName, Contact.Email,  
			    															Contact.Community_User__c 
			    														FROM AccountContactRelations 
			    														WHERE Contact.Contact_Type_SME__c INCLUDES('Inventory Reconciliation') 
			    														AND Contact.Inactive_Contact__c = FALSE) 
			    													FROM Account 
			    													WHERE Id IN : accountIdSet]);
			    													
		return accountByAccountId;
    }
    
    @TestVisible
    private static void mapValuesByAccount(Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccountId,
    											List<Process_Adherence_Monitoring__c> pamList){
    	
    	for(Process_Adherence_Monitoring__c pamObj : pamList){ 
			if(pamListByAccountId.get(pamObj.Organization_Name__c) != null){
    			List<Process_Adherence_Monitoring__c> pamTempList = pamListByAccountId.get(pamObj.Organization_Name__c);
    			pamTempList.add(pamObj);
    			pamListByAccountId.put(pamObj.Organization_Name__c, pamTempList);
    		
    		}else{
    			pamListByAccountId.put(pamObj.Organization_Name__c, new List<Process_Adherence_Monitoring__c>{pamObj});
    		} 
    	}
    }
    
    @TestVisible
    private static List<PAM_Unmatched__c> getUMPamList(Set<Id> pamIdsSet){
    	
    	Id irOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
		Id irClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Closed').getRecordTypeId();
        
        List<PAM_Unmatched__c> unmatchedPamList = [SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, 
														SCMDUM_Record_Creation_Notification_Sent__c 
													FROM PAM_Unmatched__c 
													WHERE SCMDUM_Record_Creation_Notification_Sent__c = false 
													AND (RecordTypeId = :irOpenRecType OR RecordTypeId = :irClosedRecType) 
													AND PAMUM_Process_Adherence_Monitoring__c IN :pamIdsSet 
													LIMIT :pamUnmatchedLimit];
		return unmatchedPamList;
    }
    
    @TestVisible
    private static List<Process_Adherence_Monitoring__c> getPamList(Set<Id> pamIdsSet){
    	List<Process_Adherence_Monitoring__c> pamList = [SELECT Id, Name, SCMD_Day_Counter__c, Organization_Name__c, Organization_Name__r.Name,
    														SCMD_Reporting_Period__c FROM Process_Adherence_Monitoring__c
    														WHERE Id IN :pamIdsSet]; 
    	
    	return pamList;
    }
    
    public static void scheduleIRUM_SendCreationHandleScheduler(){
    	
    	List<CronTrigger> cronTriggers = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = :CHECKBOX_SCHEDULER_NAME];
    	if(!cronTriggers.isEmpty()){
    		System.abortJob(cronTriggers.get(0).Id);
    	}
    	
    	Datetime currentDate = Datetime.now();
		String currentDateString = currentDate.format('dd MMM ? yyyy');
    	String cronExpresion = '0 0 23 '+ currentDateString;
    	
    	if(!Test.isRunningTest()){
    		System.schedule(CHECKBOX_SCHEDULER_NAME, cronExpresion, new IRUM_SendCreationHandleScheduler());
    	}
    }    
}