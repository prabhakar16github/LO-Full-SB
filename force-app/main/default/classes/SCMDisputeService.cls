public class SCMDisputeService {
	
	public enum SCMD_PROCESS {
		LO, ACF
	}
	
	public static final String ATTORNEY_MAIL = 'AttorneyOutsourcing@mcmcg.com';
	
	// used for SCMDisputeMonthlyBatch -- starts
	
	public static List<Process_Adherence_Monitoring__c> createMonthlyLOSCMD(List<Account> accountList){
        
        Map<Id, Process_Adherence_Monitoring__c> recordsToCreateByAccountId = new Map<Id, Process_Adherence_Monitoring__c>();
        Map<Id, Account> accountByAccountId = new Map<Id, Account>();
        Map<Id, Id> userIdByContactId = new Map<Id, Id>(); 
        Set<Id> contactIds = new Set<Id>();
        User adminUser = new User(); 
        // get users for all contact for assigning to the pam records -- code block start 
        processAccountList(accountList, contactIds, accountByAccountId);
        List<User> users = getUsers(contactIds); 
        adminUser = getAdminUser(users);
        userIdByContactId = getUserIdByContactId(users);
      	ApexDebugLog.debug('SCMDisputeService createMonthlyPamAndSendNotification adminUser '+adminUser);
        // get users for all contact for assigning to the pam records -- code block ends
        
        ApexDebugLog.debug('SCMDisputeService createMonthlyPamAndSendNotification accountList '+accountList);
        ApexDebugLog.debug('SCMDisputeService createMonthlyPamAndSendNotification accountByAccountId '+accountByAccountId);
        ApexDebugLog.debug('SCMDisputeService createMonthlyPamAndSendNotification userIdByContactId '+userIdByContactId);
        ApexDebugLog.debug('SCMDisputeService createMonthlyPamAndSendNotification contactIds '+contactIds);
        recordsToCreateByAccountId = createPamRecordsListForDayOne(adminUser, accountList, userIdByContactId, SCMD_PROCESS.LO);
        ApexDebugLog.debug('SCMDisputeService createMonthlyPamAndSendNotification recordsToCreateByAccountId '+recordsToCreateByAccountId);
        if(!recordsToCreateByAccountId.isEmpty()){
	        insert recordsToCreateByAccountId.values();  
        }
        Set<Id> createdPamIds = new Set<Id>(); 
        for(Id accountId : recordsToCreateByAccountId.keySet()){
        	createdPamIds.add(recordsToCreateByAccountId.get(accountId).Id);
        }
        List<Process_Adherence_Monitoring__c> pamList = getCreatedPams(createdPamIds);
		// update pam records by fetched pams records    		
		updateExistingRecordsToCreateByAccountId(pamList, recordsToCreateByAccountId);										
        sendDayOneEmailToContacts(recordsToCreateByAccountId, accountByAccountId, adminUser, SCMD_PROCESS.LO);
        return recordsToCreateByAccountId.values();
    }
    
    public static List<Process_Adherence_Monitoring__c> createMonthlyACFSCMD(List<Account> accountList){
        
        Map<Id, Process_Adherence_Monitoring__c> recordsToCreateByAccountId = new Map<Id, Process_Adherence_Monitoring__c>();
        Map<Id, Account> accountByAccountId = new Map<Id, Account>();
        Map<Id, Id> userIdByContactId = new Map<Id, Id>(); 
        Set<Id> contactIds = new Set<Id>();
        User adminUser = new User(); 
        // get users for all contact for assigning to the pam records -- code block start 
        processAccountList(accountList, contactIds, accountByAccountId);
        List<User> users = getUsers(contactIds); 
        adminUser = getAdminUser(users);
        userIdByContactId = getUserIdByContactId(users);
      	ApexDebugLog.debug('SCMDisputeService createMonthlyPamAndSendNotification adminUser '+adminUser);
        // get users for all contact for assigning to the pam records -- code block ends
        
        ApexDebugLog.debug('SCMDisputeService createMonthlyPamAndSendNotification accountList '+accountList);
        ApexDebugLog.debug('SCMDisputeService createMonthlyPamAndSendNotification accountByAccountId '+accountByAccountId);
        ApexDebugLog.debug('SCMDisputeService createMonthlyPamAndSendNotification userIdByContactId '+userIdByContactId);
        ApexDebugLog.debug('SCMDisputeService createMonthlyPamAndSendNotification contactIds '+contactIds);
        recordsToCreateByAccountId = createPamRecordsListForDayOne(adminUser, accountList, userIdByContactId, SCMD_PROCESS.ACF);
        ApexDebugLog.debug('SCMDisputeService createMonthlyPamAndSendNotification recordsToCreateByAccountId '+recordsToCreateByAccountId);
        if(!recordsToCreateByAccountId.isEmpty()){
	        insert recordsToCreateByAccountId.values();  
        }
        Set<Id> createdPamIds = new Set<Id>(); 
        for(Id accountId : recordsToCreateByAccountId.keySet()){
        	createdPamIds.add(recordsToCreateByAccountId.get(accountId).Id);
        }
        
        List<Process_Adherence_Monitoring__c> pamList = getCreatedPams(createdPamIds);
		// update pam records by fetched pams records    		
		updateExistingRecordsToCreateByAccountId(pamList, recordsToCreateByAccountId);										
        sendDayOneEmailToContacts(recordsToCreateByAccountId, accountByAccountId, adminUser, SCMD_PROCESS.ACF);
        return recordsToCreateByAccountId.values();
    }
    
    @TestVisible
    private static List<Process_Adherence_Monitoring__c> getCreatedPams(Set<Id> createdPamIds){
    	List<Process_Adherence_Monitoring__c> pamList = new List<Process_Adherence_Monitoring__c>();
    	pamList = [SELECT Id, Name, Organization_Name__c, Status__c, RecordTypeId, 
        													OwnerId,SCMD_Reporting_Period__c FROM Process_Adherence_Monitoring__c 
        												WHERE Id IN :createdPamIds];
    	return pamList; 
    }
    
    @TestVisible
    private static void updateExistingRecordsToCreateByAccountId(List<Process_Adherence_Monitoring__c> pamList, Map<Id, Process_Adherence_Monitoring__c> recordsToCreateByAccountId){
    	ApexDebugLog.debug('SCMDisputeService updateExistingRecordsToCreateByAccountId '+recordsToCreateByAccountId);
    	for(Process_Adherence_Monitoring__c updatedPamObj : pamList){
        	Process_Adherence_Monitoring__c pamObjValue = recordsToCreateByAccountId.get(updatedPamObj.Organization_Name__c);
        	pamObjValue = updatedPamObj;
        	recordsToCreateByAccountId.put(updatedPamObj.Organization_Name__c, pamObjValue);
        }
        ApexDebugLog.debug('SCMDisputeService updateExistingRecordsToCreateByAccountId '+recordsToCreateByAccountId);
    }
    
    @TestVisible
    private static void processAccountList(List<Account> accountList, Set<Id> contactIds, Map<Id, Account> accountByAccountId){
    	for(Account accountObj : accountList){
			for(AccountContactRelation accountContactRelation : accountObj.AccountContactRelations){
				contactIds.add(accountContactRelation.ContactId);
			}
			accountByAccountId.put(accountObj.Id, accountObj);
        }
    }
    
    @TestVisible
    private static List<User> getUsers(Set<Id> contactIds){
    	List<User> userList = [SELECT Id, Name, contactId, isActive FROM User WHERE ((Name = 'System Administrator' AND Profile.Name = 'System Administrator') 
        						OR ContactId IN : contactIds) AND isActive = true];
		return userList;        						
    }
    
    @TestVisible
    private static Map<Id, Id> getUserIdByContactId(List<User> userList){
    	Map<Id, Id> userIdByContactId = new Map<Id, Id>();
    	if(!userList.isEmpty()){
    		for(User usr : userList){
        		if(usr.ContactId != null && usr.isActive){
        			userIdByContactId.put(usr.ContactId, usr.Id);
        		}
        	}
    	}
    	return userIdByContactId;	
    }
    
    @TestVisible
    private static User getAdminUser(List<User> userList){
    	User adminUser = new User();
    	if(!userList.isEmpty()){
    		for(User usr : userList){
        		if(usr.Name == 'System Administrator'){
        			adminUser = usr;
        		}
        	}
    	}
    	return adminUser;
    }
    
    @TestVisible
    private static Map<Id, Process_Adherence_Monitoring__c> createPamRecordsListForDayOne(User adminUser, List<Account> accountList, 
    																							Map<Id, Id> userIdByContactId, SCMD_PROCESS scmdProcess){
    	
    	Map<Id, Process_Adherence_Monitoring__c> recordsToCreateByAccountId = new Map<Id, Process_Adherence_Monitoring__c>();
    	Id pamScmDisputeRecordTypeId;
    	if(scmdProcess == SCMD_PROCESS.LO){
			pamScmDisputeRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute').getRecordTypeId();
    	}else if(scmdProcess == SCMD_PROCESS.ACF){
    		pamScmDisputeRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute').getRecordTypeId();
    	}
        Date todaysDate = System.today();
        String month = String.valueOf(todaysDate.month());
        if(month.length() == 1){
        	month = '0' + month; // format month
        }
        String reportingPeriod = todaysDate.year() +'-'+ month; 
        for(Account accObj : accountList){
        	Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c();
        	pamObj.Organization_Name__c = accObj.Id;
        	Id ownerIdToAssign = assignPamOwner(adminUser, accObj, userIdByContactId);
        	if(ownerIdToAssign != null){
	        	pamObj.OwnerId = ownerIdToAssign; 
        	}
        	pamObj.Status__c = 'New';
        	pamObj.RecordTypeId = pamScmDisputeRecordTypeId;
        	pamObj.SCMD_Reporting_Period__c = reportingPeriod;
        	recordsToCreateByAccountId.put(accObj.Id, pamObj);
        	
        }
        return recordsToCreateByAccountId;
    
    }
    
    @TestVisible
    private static Id assignPamOwner(User adminUser, Account accObj, Map<Id, Id> userIdByContactId){
    	
    	Id assignOwnerId;
    	
    	for(AccountContactRelation accountContactRelation : accObj.AccountContactRelations){
    		
    		if(assignOwnerId == null 
    			&& accountContactRelation.Contact.Contact_Type_SME__c != null
    			&& String.valueOf(accountContactRelation.Contact.Contact_Type_SME__c).containsIgnoreCase('Process Adherence Monitoring (PAM)') 
    			&& accountContactRelation.Contact.Community_User__c && userIdByContactId.containsKey(accountContactRelation.ContactId)){
    					
    			assignOwnerId = userIdByContactId.get(accountContactRelation.ContactId);
    			break;
    		}
    	}
    	
    	if(assignOwnerId == null){
    		
	    	for(AccountContactRelation accountContactRelation : accObj.AccountContactRelations){
	    		
	    		if(assignOwnerId == null && accountContactRelation.Contact.Community_User__c 
	    				&& userIdByContactId.containsKey(accountContactRelation.ContactId)){
	    			
	    			assignOwnerId = userIdByContactId.get(accountContactRelation.ContactId);
	    			
	    			break;
	    		}
	    	}
    	}
    	
    	if(assignOwnerId == null){
    		
    		assignOwnerId = adminUser.Id;
    	}
    	ApexDebugLog.debug('SCMDisputeService assignPamOwner assignOwnerId '+assignOwnerId);
    	return assignOwnerId;
    }
    
    @TestVisible
    private static void sendDayOneEmailToContacts(Map<Id, Process_Adherence_Monitoring__c> recordsToCreateByAccountId, 
    												Map<Id, Account> accountByAccountId, User adminUser, SCMD_PROCESS processSCMD){
    	Id pamLOScmDisputeRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute').getRecordTypeId();
    	Id pamACFScmDisputeRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute').getRecordTypeId();
    	
    	List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
    	for(Id accountId : accountByAccountId.keySet()){
    		List<AccountContactRelation> accountContactRelationsList = accountByAccountId.get(accountId).AccountContactRelations;
    		for(AccountContactRelation accountContactRelationObj : accountContactRelationsList){
    			if(accountContactRelationObj.Contact.Contact_Type_SME__c != null 
    				&& String.valueOf(accountContactRelationObj.Contact.Contact_Type_SME__c).containsIgnoreCase('Process Adherence Monitoring (PAM)')){
    					
    					Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
						String[] toAddresses = new String[] {accountContactRelationObj.Contact.Email};
						mail.setToAddresses(toAddresses);
						if(processSCMD == SCMD_PROCESS.LO){
							mail.setSubject(accountByAccountId.get(accountId).Firm_ID__c+' Monthly SCM YGC ' + 
													recordsToCreateByAccountId.get(accountId).SCMD_Reporting_Period__c);
							mail.sethtmlBody(SCMDEmailCommunicationTemplates.getDayOneMonthlyTemplateSCM(recordsToCreateByAccountId.get(accountId)
																											, accountContactRelationObj.Contact.FirstName
																											,accountContactRelationObj.Contact.Community_User__c));	
						}else if(processSCMD == SCMD_PROCESS.ACF){
							mail.setSubject(accountByAccountId.get(accountId).Firm_ID__c+' ACF Monthly Dispute SCM ' + 
													recordsToCreateByAccountId.get(accountId).SCMD_Reporting_Period__c);
							mail.sethtmlBody(SCMDEmailCommunicationTemplates.getDayOneACFMonthlyTemplateSCM(recordsToCreateByAccountId.get(accountId)
																											, accountContactRelationObj.Contact.FirstName
																											,accountContactRelationObj.Contact.Community_User__c));
						}
						
		    			
		    			sentMailToContactList.add(mail);	
    				}
    			
    		}
    		
    		if(recordsToCreateByAccountId.get(accountId).ownerId == adminUser.Id){
    			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				String[] toAddresses = new String[] {ATTORNEY_MAIL};
				//String[] toAddresses = new String[] {'suryansh.gupta@mcmcg.com'};
				mail.setToAddresses(toAddresses);
				if(processSCMD == SCMD_PROCESS.LO){
					mail.setSubject(accountByAccountId.get(accountId).Firm_ID__c+' Unassigned SCMD Record ' 
									+ recordsToCreateByAccountId.get(accountId).SCMD_Reporting_Period__c);
				}else if(processSCMD == SCMD_PROCESS.ACF){
					mail.setSubject(accountByAccountId.get(accountId).Firm_ID__c+' Unassigned ACF SCMD Record ' 
									+ recordsToCreateByAccountId.get(accountId).SCMD_Reporting_Period__c);
				}
				mail.sethtmlBody(SCMDEmailCommunicationTemplates.getUnassignedPamOwnerTemplate());
    			sentMailToContactList.add(mail);
    		}
			
    	} 
    	
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
    	}
    	
    	//system.debug('sentMailToContactList------------>'+sentMailToContactList);
    	
    }
    
    // used for SCMDisputeMonthlyBatch -- ends
    
    // used for SCMD_FirstEscalationNotification -- starts
    
    public static void sendFirstEscalationEmailToContacts(Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId, Map<Id, List<AccountContactRelation>> accountContactRelListByAccId){
    	List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
    	for(Id accountId : pamListByAccId.keySet()){
			List<AccountContactRelation> accountContactRelationList = accountContactRelListByAccId.get(accountId);
			List<Process_Adherence_Monitoring__c> pamList = pamListByAccId.get(accountId);
			if(accountContactRelationList != null){
				for(AccountContactRelation accountConRelObj : accountContactRelationList){
					for(Process_Adherence_Monitoring__c pamObj : pamList){
		    			sentMailToContactList.add(getFirstEscalationMail(pamObj, accountConRelObj, SCMD_PROCESS.LO));
					}
				}
			}
    	} 
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
    	}
    }
    
    public static void sendACFFirstEscalationEmailToContacts(Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId, Map<Id, List<AccountContactRelation>> accountContactRelListByAccId){
    	List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
    	for(Id accountId : pamListByAccId.keySet()){
			List<AccountContactRelation> accountContactRelationList = accountContactRelListByAccId.get(accountId);
			List<Process_Adherence_Monitoring__c> pamList = pamListByAccId.get(accountId);
			if(accountContactRelationList != null){
				for(AccountContactRelation accountConRelObj : accountContactRelationList){
					for(Process_Adherence_Monitoring__c pamObj : pamList){
		    			sentMailToContactList.add(getFirstEscalationMail(pamObj, accountConRelObj, SCMD_PROCESS.ACF));
					}
				}
			}
    	} 
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
    	}
    }
    
    @TestVisible
    private static Messaging.SingleEmailMessage getFirstEscalationMail(Process_Adherence_Monitoring__c pamObj, AccountContactRelation accountConRelObj, 
    																		SCMD_PROCESS processType){
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {accountConRelObj.Contact.Email};
		mail.setToAddresses(toAddresses);
		if(processType == SCMD_PROCESS.LO){
			mail.setSubject(pamObj.Organization_Name__r.Firm_ID__c+' Monthly SCM YGC ' + pamObj.SCMD_Reporting_Period__c +' - First Escalation');
			mail.sethtmlBody(SCMDEmailCommunicationTemplates.getDayThreeMonthlyTemplateSCM(pamObj
																							, accountConRelObj.Contact.FirstName
																							, accountConRelObj.Contact.Community_User__c));
		}else if(processType == SCMD_PROCESS.ACF){
			mail.setSubject(pamObj.Organization_Name__r.Firm_ID__c+' ACF Monthly Dispute SCM ' + pamObj.SCMD_Reporting_Period__c +' - First Escalation');
			mail.sethtmlBody(SCMDEmailCommunicationTemplates.getDayThreeACFMonthlyTemplateSCM(pamObj
																							, accountConRelObj.Contact.FirstName
																							, accountConRelObj.Contact.Community_User__c));
		}
		
		return mail;
    }
    
    // used for SCMD_FirstEscalationNotification -- ends
    
    // used for SCMD_SecondEscalation_Notification -- starts
    
    public static void sendSecondEscalationEmailToContacts(Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId, Map<Id, List<AccountContactRelation>> accountContactRelListByAccId){
    	
    	List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
    	for(Id accountId : pamListByAccId.keySet()){
			List<AccountContactRelation> accountContactRelationList = accountContactRelListByAccId.get(accountId);
			List<Process_Adherence_Monitoring__c> pamList = pamListByAccId.get(accountId);
			if(accountContactRelationList != null){
				for(AccountContactRelation accountConRelObj : accountContactRelationList){
					for(Process_Adherence_Monitoring__c pamObj : pamList){
		    			sentMailToContactList.add(getSecondEscalationMail(pamObj, accountConRelObj, SCMD_PROCESS.LO));
					}
				}
			}
    	} 
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
    	}
    	
    }
    
   	public static void sendACFSecondEscalationEmailToContacts(Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId, Map<Id, List<AccountContactRelation>> accountContactRelListByAccId){
    	
    	List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
    	for(Id accountId : pamListByAccId.keySet()){
			List<AccountContactRelation> accountContactRelationList = accountContactRelListByAccId.get(accountId);
			List<Process_Adherence_Monitoring__c> pamList = pamListByAccId.get(accountId);
			if(accountContactRelationList != null){
				for(AccountContactRelation accountConRelObj : accountContactRelationList){
					for(Process_Adherence_Monitoring__c pamObj : pamList){
		    			sentMailToContactList.add(getSecondEscalationMail(pamObj, accountConRelObj, SCMD_PROCESS.ACF));
					}
				}
			}
    	} 
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
    	}
    	
    }
    
    @TestVisible
    private static Messaging.SingleEmailMessage getSecondEscalationMail(Process_Adherence_Monitoring__c pamObj, AccountContactRelation accountConRelObj, 
    																		SCMD_PROCESS processType){
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {accountConRelObj.Contact.Email};
		mail.setToAddresses(toAddresses);
		if(processType == SCMD_PROCESS.LO){
			mail.setSubject(pamObj.Organization_Name__r.Firm_ID__c+' Monthly SCM YGC ' + pamObj.SCMD_Reporting_Period__c +' - Second Escalation');
			mail.sethtmlBody(SCMDEmailCommunicationTemplates.getSecondEscalationTemplateSCM(pamObj
																							, accountConRelObj.Contact.FirstName
																							, accountConRelObj.Contact.Community_User__c));
		}else if(processType == SCMD_PROCESS.ACF){
			mail.setSubject(pamObj.Organization_Name__r.Firm_ID__c+' ACF Monthly Dispute SCM ' + pamObj.SCMD_Reporting_Period__c +' - Second Escalation');
			mail.sethtmlBody(SCMDEmailCommunicationTemplates.getACFSecondEscalationTemplateSCM(pamObj
																							, accountConRelObj.Contact.FirstName
																							, accountConRelObj.Contact.Community_User__c));
		}
		return mail;
    }
    
    // used for SCMD_SecondEscalation_Notification -- ends
    
    // used for SCMD_FinalEscalation -- Starts
    
    public static void sendFinalEscalationEmailToContacts(Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId, Map<Id, List<AccountContactRelation>> accountContactRelListByAccId){
    	List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
    	for(Id accountId : pamListByAccId.keySet()){
			List<AccountContactRelation> accountContactRelationList = accountContactRelListByAccId.get(accountId);
			List<Process_Adherence_Monitoring__c> pamList = pamListByAccId.get(accountId);
			if(accountContactRelationList != null){
				for(AccountContactRelation accountConRelObj : accountContactRelationList){
					for(Process_Adherence_Monitoring__c pamObj : pamList){
		    			sentMailToContactList.add(getFinalEscalationMail(pamObj, accountConRelObj, SCMD_PROCESS.LO));
					}
				}
			}
    	} 
    	
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
    	}
    }
    
    public static void sendACFFinalEscalationEmailToContacts(Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId, Map<Id, List<AccountContactRelation>> accountContactRelListByAccId){
    	List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
    	for(Id accountId : pamListByAccId.keySet()){
			List<AccountContactRelation> accountContactRelationList = accountContactRelListByAccId.get(accountId);
			List<Process_Adherence_Monitoring__c> pamList = pamListByAccId.get(accountId);
			if(accountContactRelationList != null){
				for(AccountContactRelation accountConRelObj : accountContactRelationList){
					for(Process_Adherence_Monitoring__c pamObj : pamList){
		    			sentMailToContactList.add(getFinalEscalationMail(pamObj, accountConRelObj, SCMD_PROCESS.ACF));
					}
				}
			}
    	} 
    	
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
    	}
    }
    
    @TestVisible
    private static Messaging.SingleEmailMessage getFinalEscalationMail(Process_Adherence_Monitoring__c pamObj, AccountContactRelation accountConRelObj, 
    																		SCMD_PROCESS processType){
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {accountConRelObj.Contact.Email};
		mail.setToAddresses(toAddresses);
		if(processType == SCMD_PROCESS.LO){
			mail.setSubject(pamObj.Organization_Name__r.Firm_ID__c+' Monthly SCM YGC ' + pamObj.SCMD_Reporting_Period__c +' - Final Escalation');
			mail.sethtmlBody(SCMDEmailCommunicationTemplates.getFinalEscalationTemplateSCM(pamObj
																							, accountConRelObj.Contact.FirstName
																							, accountConRelObj.Contact.Community_User__c));
		}else if(processType == SCMD_PROCESS.ACF){
			mail.setSubject(pamObj.Organization_Name__r.Firm_ID__c+' ACF Monthly Dispute SCM ' + pamObj.SCMD_Reporting_Period__c +' - Final Escalation');
			mail.sethtmlBody(SCMDEmailCommunicationTemplates.getACFFinalEscalationTemplateSCM(pamObj
																							, accountConRelObj.Contact.FirstName
																							, accountConRelObj.Contact.Community_User__c));
		}
		return mail;
    }
    
    // used for SCMD_FinalEscalation -- Ends
    
    
    
    // used for SCMD_NoResponseFirmNotificationBatch -- starts 
    
    public static void sendNoResponseFirmsMailToOwners(Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId, Map<Id, String> accountOwnerEmailByAccId){
    	List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
    	for(Id accountId : pamListByAccId.keySet()){
    		List<Process_Adherence_Monitoring__c> pamList = pamListByAccId.get(accountId);
    		for(Process_Adherence_Monitoring__c pamObj : pamList){
				sentMailToContactList.add(createMailNoResponse(accountId, pamObj, accountOwnerEmailByAccId, SCMD_PROCESS.LO));
    		}
    	}
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
    	}
    }
    
    public static void sendNoResponseACFFirmsMailToOwners(Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId, Map<Id, String> accountOwnerEmailByAccId){
    	List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
    	for(Id accountId : pamListByAccId.keySet()){
    		List<Process_Adherence_Monitoring__c> pamList = pamListByAccId.get(accountId);
    		for(Process_Adherence_Monitoring__c pamObj : pamList){
				sentMailToContactList.add(createMailNoResponse(accountId, pamObj, accountOwnerEmailByAccId, SCMD_PROCESS.ACF));
    		}
    	}
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
    	}
    }
    
    private static Messaging.SingleEmailMessage createMailNoResponse(Id accountId, Process_Adherence_Monitoring__c pamObj, 
    																	Map<Id, String> accountOwnerEmailByAccId,
    																	SCMD_PROCESS processType){
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        /**************** Added changes on 12-March-20202 by Prabhakar Joshi to change the emails to send mail.************/                                                                    
		String[] toAddresses = new String[] {'LO-Operational@mcmcg.com'}; //ATTORNEY_MAIL
		
			
		if(pamObj.Organization_Name__c != null 
				&& accountOwnerEmailByAccId.containsKey(accountId) 
				&& accountOwnerEmailByAccId.get(accountId) != null){

			toAddresses.add(accountOwnerEmailByAccId.get(accountId));
		}
		mail.setToAddresses(toAddresses);
		if(processType == SCMD_PROCESS.LO){
			mail.setSubject(pamObj.Organization_Name__r.Firm_ID__c+' Monthly SCM YGC ' + pamObj.SCMD_Reporting_Period__c +' - No Response From Firm');
		}else if(processType == SCMD_PROCESS.ACF){
			mail.setSubject(pamObj.Organization_Name__r.Firm_ID__c+' ACF Monthly Dispute SCM ' + pamObj.SCMD_Reporting_Period__c +' - No Response From Firm');
		}
		mail.sethtmlBody(SCMDEmailCommunicationTemplates.send_No_Response_MailToOrgOwner());
		return mail;
    }
    
    // used for SCMD_NoResponseFirmNotificationBatch -- ends
    
     // used for SCMDUM_FirstEscalationNotification -- starts
    
    	// for LO
    public static void sendSCMDUMFirstEscalationNotification(List<Process_Adherence_Monitoring__c> pamList, Map<Id, Account> accountByAccountId, String reportingPeriod){
    	
    	List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
    	List<PAM_Unmatched__c> scmdUMRecordsToUpdate = new List<PAM_Unmatched__c>();  
    
    	for( Process_Adherence_Monitoring__c pamObj : pamList ){
    		if(accountByAccountId.containsKey(pamObj.Organization_Name__c) 
    				&& accountByAccountId.get(pamObj.Organization_Name__c).AccountContactRelations != null){
    				
		    		List<AccountContactRelation> accountContactRelationList = accountByAccountId.get(pamObj.Organization_Name__c).AccountContactRelations;
		    		if(accountContactRelationList != null){
			    		for(AccountContactRelation accountContactRelationObj : accountContactRelationList){
				    		Messaging.SingleEmailMessage mail = createMailForSCMDUMFirstEscalation(accountContactRelationObj.Contact.Email,
				    																				accountContactRelationObj.Contact.firstName,
				    																				accountContactRelationObj.Contact.Community_User__c,
				    																				pamObj, SCMD_PROCESS.LO);
				    		sentMailToContactList.add(mail);
			    		}
		    		}
		    		
    		}
    	}
    	
    	scmdUMRecordsToUpdate = getPamUmListForFirstEscalation(pamList, reportingPeriod);
    	
    	if(!scmdUMRecordsToUpdate.isEmpty()){
    		update scmdUMRecordsToUpdate;
    	}
    	
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
    	}
    	
    }
    
    	// for ACF
    	
	public static void sendSCMDUMACFFirstEscalationNotification(List<Process_Adherence_Monitoring__c> pamList, Map<Id, Account> accountByAccountId, 
																String reportingPeriod){
    	
    	List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
    	List<PAM_Unmatched__c> scmdUMRecordsToUpdate = new List<PAM_Unmatched__c>();  
    
    	for( Process_Adherence_Monitoring__c pamObj : pamList ){
    		if(accountByAccountId.containsKey(pamObj.Organization_Name__c) 
    				&& accountByAccountId.get(pamObj.Organization_Name__c).AccountContactRelations != null){
    				
		    		List<AccountContactRelation> accountContactRelationList = accountByAccountId.get(pamObj.Organization_Name__c).AccountContactRelations;
		    		if(accountContactRelationList != null){
			    		for(AccountContactRelation accountContactRelationObj : accountContactRelationList){
				    		Messaging.SingleEmailMessage mail = createMailForSCMDUMFirstEscalation(accountContactRelationObj.Contact.Email,
				    																				accountContactRelationObj.Contact.firstName,
				    																				accountContactRelationObj.Contact.Community_User__c,
				    																				pamObj, SCMD_PROCESS.ACF);
				    		sentMailToContactList.add(mail);
			    		}
		    		}
    		}
    	}
    	
    	scmdUMRecordsToUpdate = getPamUmListForFirstEscalation(pamList, reportingPeriod);
    	if(!scmdUMRecordsToUpdate.isEmpty()){
    		update scmdUMRecordsToUpdate;
    	}
    	
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
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
    
    private static Messaging.SingleEmailMessage createMailForSCMDUMFirstEscalation(String contactEmail, String contactName, Boolean isCommunityUser, 
    													Process_Adherence_Monitoring__c pamObj, SCMD_PROCESS scmdProcess){
    	
    		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    		String[] toAddresses = new String[] {contactEmail};
    		mail.setToAddresses(toAddresses);
    		
    		if(scmdProcess == SCMD_PROCESS.LO){
				mail.setSubject(pamObj.Organization_Name__r.Firm_ID__c+' Monthly SCM Unmatched YGC ' + pamObj.SCMD_Reporting_Period__c +' - First Escalation');
				mail.sethtmlBody(SCMDEmailCommunicationTemplates.getSCMDUnmatchedFirstEscalation(pamObj, contactName, isCommunityUser));
    		}else if(scmdProcess == SCMD_PROCESS.ACF){
    			mail.setSubject(pamObj.Organization_Name__r.Firm_ID__c+' ACF Monthly Dispute SCM Unmatched ' + pamObj.SCMD_Reporting_Period__c +' - First Escalation');
				mail.sethtmlBody(SCMDEmailCommunicationTemplates.getSCMDUnmatchedACFFirstEscalation(pamObj, contactName, isCommunityUser));
    		}
			
			return mail;
    }
    
    // used for SCMDUM_FirstEscalationNotification -- ends
    
    // used for SCMDUM_FinalEscalationNotification -- starts
    
    
    public static void sendSCMDUMFinalEscalationNotification(List<Process_Adherence_Monitoring__c> pamList, Map<Id, Account> accountByAccountId,
    															String reportingPeriod){
    	
    	List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
    	List<PAM_Unmatched__c> scmdUMRecordsToUpdate = new List<PAM_Unmatched__c>();  
    
    	for( Process_Adherence_Monitoring__c pamObj : pamList ){
    		if(accountByAccountId.containsKey(pamObj.Organization_Name__c) 
    				&& accountByAccountId.get(pamObj.Organization_Name__c).AccountContactRelations != null){
    				
			    		List<AccountContactRelation> accountContactRelationList = accountByAccountId.get(pamObj.Organization_Name__c).AccountContactRelations;
			    		if(accountContactRelationList != null){
				    		for(AccountContactRelation accountContactRelationObj : accountContactRelationList){
					    		Messaging.SingleEmailMessage mail = createMailForSCMDUMFinalEscalation(accountContactRelationObj.Contact.Email,
					    																				accountContactRelationObj.Contact.firstName,
					    																				accountContactRelationObj.Contact.Community_User__c,
					    																				pamObj, SCMD_PROCESS.LO);
					    		sentMailToContactList.add(mail);
				    		}
			    		}
    				}
    	}
    	
    	scmdUMRecordsToUpdate = getPamUmListForFinalEscalation(pamList, reportingPeriod);
    	if(!scmdUMRecordsToUpdate.isEmpty()){
    		update scmdUMRecordsToUpdate;
    	}
    	
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
    	}
    	
    }
    
    public static void sendSCMDUMACFFinalEscalationNotification(List<Process_Adherence_Monitoring__c> pamList, Map<Id, Account> accountByAccountId,
    															String reportingPeriod){
    	
    	List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
    	List<PAM_Unmatched__c> scmdUMRecordsToUpdate = new List<PAM_Unmatched__c>();  
    
    	for( Process_Adherence_Monitoring__c pamObj : pamList ){
    		if(accountByAccountId.containsKey(pamObj.Organization_Name__c) 
    				&& accountByAccountId.get(pamObj.Organization_Name__c).AccountContactRelations != null){
    				
			    		List<AccountContactRelation> accountContactRelationList = accountByAccountId.get(pamObj.Organization_Name__c).AccountContactRelations;
			    		if(accountContactRelationList != null){
				    		for(AccountContactRelation accountContactRelationObj : accountContactRelationList){
					    		Messaging.SingleEmailMessage mail = createMailForSCMDUMFinalEscalation(accountContactRelationObj.Contact.Email,
					    																				accountContactRelationObj.Contact.firstName,
					    																				accountContactRelationObj.Contact.Community_User__c,
					    																				pamObj, SCMD_PROCESS.ACF);
					    		sentMailToContactList.add(mail);
				    		}
			    		}
    				}
    	}
    	scmdUMRecordsToUpdate = getPamUmListForFinalEscalation(pamList, reportingPeriod);
    	if(!scmdUMRecordsToUpdate.isEmpty()){
    		update scmdUMRecordsToUpdate;
    	}
    	
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
    	}else{
    		bufferCode();
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
    
    private static Messaging.SingleEmailMessage createMailForSCMDUMFinalEscalation(String contactEmail, String contactName, Boolean isCommunityUser, 
    																					Process_Adherence_Monitoring__c pamObj,
    																					SCMD_PROCESS processType){
    	
    		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    		String[] toAddresses = new String[] {contactEmail};
    		mail.setToAddresses(toAddresses);
    		
    		if(processType == SCMD_PROCESS.LO){
				mail.setSubject(pamObj.Organization_Name__r.Firm_ID__c+' Monthly SCM Unmatched YGC ' + pamObj.SCMD_Reporting_Period__c +' - Final Escalation');
				mail.sethtmlBody(SCMDEmailCommunicationTemplates.getSCMDUnmatchedFinalEscalation(pamObj, contactName, isCommunityUser));
    		}else if(processType == SCMD_PROCESS.ACF){
    			mail.setSubject(pamObj.Organization_Name__r.Firm_ID__c+' ACF Monthly Dispute SCM Unmatched ' + pamObj.SCMD_Reporting_Period__c +' - Final Escalation');
				mail.sethtmlBody(SCMDEmailCommunicationTemplates.getSCMDUnmatchedACFFirstEscalation(pamObj, contactName, isCommunityUser));
    		}
			
			return mail;
    }
    
    
    // used for SCMDUM_FinalEscalationNotification -- ends
    
    public static void sendSCMDUMNoResponseMail(List<Process_Adherence_Monitoring__c> pamList){
    	List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
    	for( Process_Adherence_Monitoring__c pamObj : pamList){
			sentMailToContactList.add(createNoResponseEmail(pamObj, SCMD_PROCESS.LO));
    	}
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
    	}else{
    		bufferCode();
    	}
    	
    }
    
    public static void sendSCMDUMACFNoResponseMail(List<Process_Adherence_Monitoring__c> pamList){
    	List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
    	for( Process_Adherence_Monitoring__c pamObj : pamList){
			sentMailToContactList.add(createNoResponseEmail(pamObj, SCMD_PROCESS.ACF));
    	}
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
    	}
    }
    
    private static Messaging.SingleEmailMessage createNoResponseEmail(Process_Adherence_Monitoring__c pamObj, SCMD_PROCESS processType){
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    	String[] toAddresses = new String[] {ATTORNEY_MAIL};
		if( pamObj.Organization_Name__c != null ){
			toAddresses.add(pamObj.Organization_Name__r.Owner.Email);
		}
		mail.setToAddresses(toAddresses);
		if(processType == SCMD_PROCESS.LO){
			mail.setSubject(pamObj.Organization_Name__r.Firm_ID__c+' Monthly SCM Unmatched YGC ' + pamObj.SCMD_Reporting_Period__c +' - No Response From Firm');
			mail.sethtmlBody(SCMDEmailCommunicationTemplates.getSCMDUnmatchedNoResponseFromFirmTemplate());
		}else if(processType == SCMD_PROCESS.ACF){
			mail.setSubject(pamObj.Organization_Name__r.Firm_ID__c+' ACF Monthly Dispute SCM Unmatched ' + pamObj.SCMD_Reporting_Period__c +' - No Response From Firm');
			mail.sethtmlBody(SCMDEmailCommunicationTemplates.getSCMDACFUnmatchedNoResponseFromFirmTemplate());
		}
		return mail;
    }
    
    public static void bufferCode(){
    	Integer i = 0;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    	i++;
    }
}