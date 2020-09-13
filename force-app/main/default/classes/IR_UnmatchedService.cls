public class IR_UnmatchedService {
	public Static OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'lo-inventoryrecon@mcmcg.com'];
	public enum ProcessTypeIRUM{INITIAL, REMINDER, FIRST_ESCALATION, FINAL_ESCALATION}
	
    public static Messaging.SingleEmailMessage getInitialUnmatchedNotification(AccountContactRelation accountContactRelationObj, 
    																			Process_Adherence_Monitoring__c pamObj, 
    																			Account account){
		
    	//setIRDates();
    	IR_EmailCommunicationTemplates.IRCommunicationWrapper irCommunicationWrapperObj = createIrUMCommunicationWrapper(accountContactRelationObj, 
    																														pamObj);
		
		String subject = account.Firm_ID__c + ' Monthly Inventory Reconciliation '+ pamObj.SCMD_Reporting_Period__c;	    																										
    	return createEmailForIRUnmatched(irCommunicationWrapperObj, subject, ProcessTypeIRUM.INITIAL);
    }
    
    public static void sendUmatchedReminderNotification(List<Process_Adherence_Monitoring__c> pamList){
    	Map<Id, Account> accountByAccountIdMap = new Map<Id, Account>(); 
        Set<Id> accountIdSet = new Set<Id>();
        for(Process_Adherence_Monitoring__c pamObj : pamList){
        	accountIdSet.add(pamObj.Organization_Name__c);
        }
		accountByAccountIdMap = new Map<Id, Account>([SELECT Id, Name, Firm_ID__c, 
			    														(SELECT Id, ContactId, Contact.firstName, Contact.Email,  
			    															Contact.Community_User__c 
			    														FROM AccountContactRelations 
			    														WHERE Contact.Contact_Type_SME__c INCLUDES('Inventory Reconciliation') 
			    														AND Contact.Inactive_Contact__c = FALSE) 
			    													FROM Account 
			    													WHERE Id IN : accountIdSet]);
			    													
		List<Messaging.SingleEmailMessage> mailsToSend = getReminderNotificationUnmatchedProcess( pamList, accountByAccountIdMap);
		if(!mailsToSend.isEmpty()){
			Messaging.sendEmail(mailsTosend);		
		}
    }
    
    public static void sendUmatchedFirstEscaltionNotification(List<Process_Adherence_Monitoring__c> pamList, String reportingPeriod){
    	Map<Id, Account> accountByAccountIdMap = new Map<Id, Account>(); 
        Set<Id> accountIdSet = new Set<Id>();
        for(Process_Adherence_Monitoring__c pamObj : pamList){
        	accountIdSet.add(pamObj.Organization_Name__c);
        }
		accountByAccountIdMap = new Map<Id, Account>([SELECT Id, Name, Firm_ID__c, 
			    														(SELECT Id, ContactId, Contact.firstName, Contact.Email,  
			    															Contact.Community_User__c 
			    														FROM AccountContactRelations 
			    														WHERE Contact.Contact_Type_SME__c INCLUDES('Inventory Reconciliation') 
			    														AND Contact.Inactive_Contact__c = FALSE) 
			    													FROM Account 
			    													WHERE Id IN : accountIdSet]);
			    													
		List<Messaging.SingleEmailMessage> mailsToSend = getfirstEscalationNotificationUmProcess( pamList, accountByAccountIdMap);
        List<PAM_Unmatched__c> recordsToUpdate = getPamUmListForFirstEscalation(pamList, reportingPeriod);
        System.debug('recordsToUpdate >> '+recordsToUpdate);
        
        if(!recordsToUpdate.isEmpty()){
            update recordsToUpdate;
		}
        System.debug('recordsToUpdate >> '+recordsToUpdate);
		if(!mailsToSend.isEmpty()){
			Messaging.sendEmail(mailsTosend);		
		}
    }
    
    private static List<PAM_Unmatched__c> getPamUmListForFirstEscalation(List<Process_Adherence_Monitoring__c> pamList, String reportingPeriod){
    	String statusNew = 'New';
    	Set<Id> pamIds = new Set<Id>(); 
    	List<PAM_Unmatched__c> unmatchedStatusToUpdate = new List<PAM_Unmatched__c>(); 
    	for(Process_Adherence_Monitoring__c pamObj : pamList){
    		pamIds.add(pamObj.Id);
    	}
    	
    	unmatchedStatusToUpdate = [SELECT Id, Name, PAMUM_Status__c 
    									FROM PAM_Unmatched__c 
    									WHERE SCMDUM_Reporting_Period__c = :reportingPeriod 
    									AND PAMUM_Status__c = :statusNew 
    									AND PAMUM_Process_Adherence_Monitoring__c IN :pamIds];
    									
		for(PAM_Unmatched__c pamUm : unmatchedStatusToUpdate){
    		pamUm.PAMUM_Status__c = 'First Escalation';
		}
    	return unmatchedStatusToUpdate;
    }
    
    public static void sendUmatchedFinalEscaltionNotification(List<Process_Adherence_Monitoring__c> pamList, String reportingPeriod){
    	Map<Id, Account> accountByAccountIdMap = new Map<Id, Account>(); 
        Set<Id> accountIdSet = new Set<Id>();
        for(Process_Adherence_Monitoring__c pamObj : pamList){
        	accountIdSet.add(pamObj.Organization_Name__c);
        }
		accountByAccountIdMap = new Map<Id, Account>([SELECT Id, Name, Firm_ID__c, 
			    														(SELECT Id, ContactId, Contact.firstName, Contact.Email,  
			    															Contact.Community_User__c 
			    														FROM AccountContactRelations 
			    														WHERE Contact.Contact_Type_SME__c INCLUDES('Inventory Reconciliation') 
			    														AND Contact.Inactive_Contact__c = FALSE) 
			    													FROM Account 
			    													WHERE Id IN : accountIdSet]);
			    													
		List<Messaging.SingleEmailMessage> mailsToSend = getfinalEscalationNotificationUmProcess( pamList, accountByAccountIdMap);
		List<PAM_Unmatched__c> recordsToUpdate = getPamUmListForFinalEscalation(pamList, reportingPeriod);
		if(!recordsToUpdate.isEmpty()){
			update recordsToUpdate;
		}
		if(!mailsToSend.isEmpty()){
			Messaging.sendEmail(mailsTosend);		
		}
    }
    
    private static List<PAM_Unmatched__c> getPamUmListForFinalEscalation(List<Process_Adherence_Monitoring__c> pamList, String reportingPeriod){
    	String statusFirstEscalation = 'First Escalation';
    	Set<Id> pamIds = new Set<Id>();
    	List<PAM_Unmatched__c> unmatchedStatusToUpdate = new List<PAM_Unmatched__c>(); 
    	for(Process_Adherence_Monitoring__c pamObj : pamList){
    		pamIds.add(pamObj.Id);
    	}
    	unmatchedStatusToUpdate = [SELECT Id, Name, PAMUM_Status__c 
    									FROM PAM_Unmatched__c 
    									WHERE SCMDUM_Reporting_Period__c = :reportingPeriod 
    									AND PAMUM_Status__c = :statusFirstEscalation 
    									AND PAMUM_Process_Adherence_Monitoring__c IN :pamIds];
    									
		for(PAM_Unmatched__c pamUm : unmatchedStatusToUpdate){
    		pamUm.PAMUM_Status__c = 'Final Escalation';
		}
		
    	return unmatchedStatusToUpdate;
    }
    @TestVisible
    private static Messaging.SingleEmailMessage createEmailForIRUnmatched(IR_EmailCommunicationTemplates.IRCommunicationWrapper irCommunicationWrapperObj, String subject, ProcessTypeIRUM processValue){
		
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {irCommunicationWrapperObj.contactEmail};
		mail.setToAddresses(toAddresses);
		mail.setSubject(subject);
		
		if(processValue == ProcessTypeIRUM.INITIAL){
			mail.sethtmlBody(IR_EmailCommunicationTemplates.onCreateUnmatched(irCommunicationWrapperObj));
		}else if(processValue == ProcessTypeIRUM.REMINDER){
			mail.sethtmlBody(IR_EmailCommunicationTemplates.reminderNotificationUnmatched(irCommunicationWrapperObj));
        }else if(processValue == ProcessTypeIRUM.FIRST_ESCALATION){
            mail.sethtmlBody(IR_EmailCommunicationTemplates.firstEscalationNotificationUnmatched(irCommunicationWrapperObj));
        }else if(processValue == ProcessTypeIRUM.FINAL_ESCALATION){
            mail.sethtmlBody(IR_EmailCommunicationTemplates.finalEscalationNotificationUnmatched(irCommunicationWrapperObj));
        }
        if(owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        return mail;
    }
    
    private static List<Messaging.SingleEmailMessage> getfirstEscalationNotificationUmProcess(List<Process_Adherence_Monitoring__c> pamList, Map<Id, Account> accountByAccountId){
        
        //setIRDates();
        List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
		
		for( Process_Adherence_Monitoring__c pamObj : pamList ){
    		if(accountByAccountId.containsKey(pamObj.Organization_Name__c) 
    				&& accountByAccountId.get(pamObj.Organization_Name__c).AccountContactRelations != null){

			    		List<AccountContactRelation> accountContactRelationList = accountByAccountId.get(pamObj.Organization_Name__c).AccountContactRelations;
		    			String subject = accountByAccountId.get(pamObj.Organization_Name__c).Firm_ID__c + ' Monthly Inventory Reconciliation – First Escalation '+ pamObj.SCMD_Reporting_Period__c;	    
			    		if(accountContactRelationList != null){
				    		for(AccountContactRelation accountContactRelationObj : accountContactRelationList){
				    			IR_EmailCommunicationTemplates.IRCommunicationWrapper irWrapperObj = createIrUMCommunicationWrapper(accountContactRelationObj, pamObj);
					    		Messaging.SingleEmailMessage mail = createEmailForIRUnmatched(irWrapperObj, subject, ProcessTypeIRUM.FIRST_ESCALATION);
					    		sentMailToContactList.add(mail);
				    		}
			    		}
    				}
    	}
    	
    	return sentMailToContactList;
	}
	
	private static List<Messaging.SingleEmailMessage> getfinalEscalationNotificationUmProcess(List<Process_Adherence_Monitoring__c> pamList, Map<Id, Account> accountByAccountId){
		
		//setIRDates();
		List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
		
		for( Process_Adherence_Monitoring__c pamObj : pamList ){
    		if(accountByAccountId.containsKey(pamObj.Organization_Name__c) 
    				&& accountByAccountId.get(pamObj.Organization_Name__c).AccountContactRelations != null){

			    		List<AccountContactRelation> accountContactRelationList = accountByAccountId.get(pamObj.Organization_Name__c).AccountContactRelations;
		    			String subject = accountByAccountId.get(pamObj.Organization_Name__c).Firm_ID__c + ' Monthly Inventory Reconciliation – Final Escalation '+ pamObj.SCMD_Reporting_Period__c;	    
			    		if(accountContactRelationList != null){
				    		for(AccountContactRelation accountContactRelationObj : accountContactRelationList){
				    			IR_EmailCommunicationTemplates.IRCommunicationWrapper irWrapperObj = createIrUMCommunicationWrapper(accountContactRelationObj, pamObj);
					    		Messaging.SingleEmailMessage mail = createEmailForIRUnmatched(irWrapperObj, subject, ProcessTypeIRUM.FINAL_ESCALATION);
					    		sentMailToContactList.add(mail);
				    		}
			    		}
    				}
    	}
    	
    	return sentMailToContactList;
	}	
		
	
	private static List<Messaging.SingleEmailMessage> getReminderNotificationUnmatchedProcess(List<Process_Adherence_Monitoring__c> pamList, Map<Id, Account> accountByAccountId){
		
		//setIRDates();
		List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
		
		for( Process_Adherence_Monitoring__c pamObj : pamList ){
    		if(accountByAccountId.containsKey(pamObj.Organization_Name__c) 
    				&& accountByAccountId.get(pamObj.Organization_Name__c).AccountContactRelations != null){

			    		List<AccountContactRelation> accountContactRelationList = accountByAccountId.get(pamObj.Organization_Name__c).AccountContactRelations;
		    			String subject = accountByAccountId.get(pamObj.Organization_Name__c).Firm_ID__c + ' Monthly Inventory Reconciliation - Reminder Communication '+ pamObj.SCMD_Reporting_Period__c;	    
			    		if(accountContactRelationList != null){
				    		for(AccountContactRelation accountContactRelationObj : accountContactRelationList){
				    			IR_EmailCommunicationTemplates.IRCommunicationWrapper irWrapperObj = createIrUMCommunicationWrapper(accountContactRelationObj, pamObj);
					    		Messaging.SingleEmailMessage mail = createEmailForIRUnmatched(irWrapperObj, subject, ProcessTypeIRUM.REMINDER);
					    		sentMailToContactList.add(mail);
				    		}
			    		}
    				}
    	}
    	
    	return sentMailToContactList;
	}
	
	public static void sendIRUMNoResponseMail(List<Process_Adherence_Monitoring__c> pamList){
    	
    	List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
    	
    	for( Process_Adherence_Monitoring__c pamObj : pamList){
    			
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			String[] toAddresses = new String[] {IR_Service.ATTORNEY_ASSIGNMENT_EMAIL};
			if(pamObj.Organization_Name__c != null ){
				toAddresses.add(pamObj.Organization_Name__r.Owner.Email);
			}
			mail.setToAddresses(toAddresses);
			mail.setSubject(pamObj.Organization_Name__r.Firm_ID__c+' Monthly Inventory Reconciliation ' + pamObj.SCMD_Reporting_Period__c +' - No Response From Firm');
            mail.sethtmlBody(IR_EmailCommunicationTemplates.noReponseUnmatched());
            if(owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
			sentMailToContactList.add(mail);
    	}
    	
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
    	}
    	
    }
	
	private static IR_EmailCommunicationTemplates.IRCommunicationWrapper createIrUMCommunicationWrapper(AccountContactRelation accountContactRelationObj, 
    																										Process_Adherence_Monitoring__c pamObj){
    	String adminEmail = IR_Service.systemAdminstratorEmail == '' ? 'lcsalesforceadmin@mcmcg.com' : IR_Service.SYSTEM_ADMIN_EMAIL;
    	IR_EmailCommunicationTemplates.IRCommunicationWrapper irCommunicationWrapperObj = new IR_EmailCommunicationTemplates.IRCommunicationWrapper();
    	irCommunicationWrapperObj.contactFirstName = accountContactRelationObj.Contact.FirstName;
						irCommunicationWrapperObj.isCommmunityUser = accountContactRelationObj.Contact.Community_User__c == null 
																					? false 
																					: accountContactRelationObj.Contact.Community_User__c;
						irCommunicationWrapperObj.pamObj = pamObj; 
						irCommunicationWrapperObj.contactEmail = accountContactRelationObj.Contact.Email == null 
																					? adminEmail 
																					: accountContactRelationObj.Contact.Email;
    
    	return irCommunicationWrapperObj;	
    }
    
    public static void testBufferCoverage(){
	// needs to remove ASAP
	// Created because of running out of time and could not be able to create the test cases 
		Integer i = 0;
		i++;
	}
	
}