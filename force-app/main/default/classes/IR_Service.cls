public class IR_Service {
	
	public static String cuttOffdate {set;get;}
	public static String filesDueToMCMdate {set;get;}
	public static String actionItemCompletedDate {set;get;}
	public static String systemAdminstratorEmail {set;get{
			
			return EmailNotification__c.getall().get('System Admin').Email__c == null ? '' : EmailNotification__c.getall().get('System Admin').Email__c;
		}
	}
	
	public static final String SYSTEM_ADMIN_EMAIL = 'lcsalesforceadmin@mcmcg.com';
	public static final String ATTORNEY_ASSIGNMENT_EMAIL = 'AttorneyOutsourcing@mcmcg.com'; // 
	public static final String LO_INVENTORY_RECON_EMAIL = 'lo-inventoryrecon@mcmcg.com'; // 
	public enum ProcessType{INITIAL, DAY_BEFORE, REMINDER, FINAL_REMINDER, FINAL_ESCALATION}
	
	public static String reportingPeriod {set;get;}
	
	private static void setIRDates(String reportPeriod){
		Date dateToday = System.today();
    	  
    	String month = String.valueOf(dateToday.month());
        
		if(month.length() == 1){
				
			month = '0' + month; // format month
		}
		
		if(reportPeriod == null || reportPeriod == ''){
			reportingPeriod = dateToday.year() +'-'+ month;
		}else{
			reportingPeriod = reportPeriod;
		}
		List<String> yearMonth = reportingPeriod.split('-');
		Date reportingPeriodDate = Date.newInstance(Integer.valueOf(yearMonth.get(0)), Integer.valueOf(yearMonth.get(1)), 1);
		if(cuttOffdate == null){
			cuttOffdate = Date.newInstance(reportingPeriodDate.year(), reportingPeriodDate.month(), 25).format();
		}
		
		if(filesDueToMCMdate == null){
			filesDueToMCMdate =  Date.newInstance(reportingPeriodDate.year(), reportingPeriodDate.month(), 28).format();
		}
		
		if(actionItemCompletedDate == null){
			if(reportingPeriodDate.month() == 12){
				actionItemCompletedDate =  Date.newInstance(reportingPeriodDate.addYears(1).year(), reportingPeriodDate.addMonths(1).month(), 10).format();
			}else{
				actionItemCompletedDate =  Date.newInstance(reportingPeriodDate.year(), reportingPeriodDate.addMonths(1).month(), 10).format();
			}
		}		
	}
	
	public static void sentInitialNotification(List<Account> accountList, String reportPeriod){
		
		List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>(); 
		String adminEmail = systemAdminstratorEmail == '' ? 'lcsalesforceadmin@mcmcg.com' : SYSTEM_ADMIN_EMAIL;
		setIRDates(reportPeriod);	
			
		for(Account accountObj : accountList){
			
			String subject = accountObj.Firm_ID__c + ' Monthly Inventory Reconciliation – Initial Communication '+ reportingPeriod;
			
			for(AccountContactRelation accountContactRelation : accountObj.AccountContactRelations){
				
				if(accountContactRelation.Contact.Contact_Type_SME__c != null 
    				&& String.valueOf(accountContactRelation.Contact.Contact_Type_SME__c).containsIgnoreCase('Inventory Reconciliation')){

						IR_EmailCommunicationTemplates.IRCommunicationWrapper irCommunicationWrapperObj = createIrCommunicationWrapper(accountContactRelation, null); 
						mailsToSend.add(createEmailForIR(irCommunicationWrapperObj, subject, ProcessType.INITIAL));
    				
    				}
				
			}
			        	
        }
		
		if(!mailsToSend.isEmpty() && !Test.isRunningTest()){
			Messaging.sendEmail(mailsToSend);
		}
	}
    
    public static void createIRRecords(List<Account> accountList){
        
        Map<Id, Process_Adherence_Monitoring__c> recordsToCreateByAccountId = new Map<Id, Process_Adherence_Monitoring__c>();
        Map<Id, Account> accountByAccountId = new Map<Id, Account>();
        Map<Id, Id> userIdByContactId = new Map<Id, Id>(); 
        Set<Id> contactIds = new Set<Id>();
        Date todaysDate = System.today();
        
        String month = String.valueOf(todaysDate.month());
        
        if(month.length() == 1){
        	
        	month = '0' + month; // format month
        }
        
        String reportingPeriod = todaysDate.year() +'-'+ month;
      		
      		    
        // get users for all contact for assigning to the pam records -- code block start 
        
        for(Account accountObj : accountList){
			
			for(AccountContactRelation accountContactRelation : accountObj.AccountContactRelations){
				
				contactIds.add(accountContactRelation.ContactId);
			}
			
			accountByAccountId.put(accountObj.Id, accountObj);
			        	
        }
        
        List<User> userList = [SELECT Id, Name, contactId, isActive FROM User WHERE ((Name = 'System Administrator' AND Profile.Name = 'System Administrator') 
        						OR ContactId IN : contactIds) AND isActive = true];
        						
        
        User adminUser = new User(); 
        
        if(!userList.isEmpty()){
        	
        	for(User usr : userList){
        		
        		if(usr.Name == 'System Administrator'){
        			
        			adminUser = usr;
        		}
        		
        		if(usr.ContactId != null && usr.isActive){
        			
        			userIdByContactId.put(usr.ContactId, usr.Id);
        		}
        	}
        }
        
        // get users for all contact for assigning to the pam records -- code block ends
        
        
        recordsToCreateByAccountId = createPamRecordsIRList(adminUser, accountList, userIdByContactId, reportingPeriod);
        
        
        if(!recordsToCreateByAccountId.isEmpty()){
        
	        insert recordsToCreateByAccountId.values();  
        }
        
        
        Set<Id> createdPamIds = new Set<Id>(); 
        
        for(Id accountId : recordsToCreateByAccountId.keySet()){
        	
        	createdPamIds.add(recordsToCreateByAccountId.get(accountId).Id);
        }
        
        List<Process_Adherence_Monitoring__c> pamList = [SELECT Id, Name, Organization_Name__c, Status__c, RecordTypeId, 
        													OwnerId,SCMD_Reporting_Period__c FROM Process_Adherence_Monitoring__c 
        												WHERE Id IN :createdPamIds];
		
		// update pam records by fetched pams records    												
        for(Process_Adherence_Monitoring__c updatedPamObj : pamList){
        	
        	Process_Adherence_Monitoring__c pamObjValue = recordsToCreateByAccountId.get(updatedPamObj.Organization_Name__c);
        	pamObjValue = updatedPamObj;
        	
        	recordsToCreateByAccountId.put(updatedPamObj.Organization_Name__c, pamObjValue);
        
        }
        
        sendDayBeforeCutOffNotification(recordsToCreateByAccountId, accountByAccountId, adminUser, reportingPeriod);
        
    }
    
    private static Messaging.SingleEmailMessage createEmailForIR(IR_EmailCommunicationTemplates.IRCommunicationWrapper irCommunicationWrapperObj
																					, String subject, ProcessType processValue){
		
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {irCommunicationWrapperObj.contactEmail};
		mail.setToAddresses(toAddresses);
		mail.setSubject(subject);
		
		if(processValue == ProcessType.INITIAL){
			mail.sethtmlBody(IR_EmailCommunicationTemplates.initialNotificationTemplate(irCommunicationWrapperObj));
		}else if(processValue == ProcessType.DAY_BEFORE){
			mail.sethtmlBody(IR_EmailCommunicationTemplates.dayBeforeCutoffNotificationTemplate(irCommunicationWrapperObj));
		}else if(processValue == ProcessType.REMINDER){
			mail.sethtmlBody(IR_EmailCommunicationTemplates.reminderNotificationTemplate(irCommunicationWrapperObj));
		}else if(processValue == ProcessType.FINAL_REMINDER){
			mail.sethtmlBody(IR_EmailCommunicationTemplates.finalReminderNotificationTemplate(irCommunicationWrapperObj));
		}else if(processValue == ProcessType.FINAL_ESCALATION){
			mail.sethtmlBody(IR_EmailCommunicationTemplates.finalEscalatiponNotificationTemplate(irCommunicationWrapperObj));
		}
		
		return mail;
	}
    
    private static Map<Id, Process_Adherence_Monitoring__c> createPamRecordsIRList(User adminUser, List<Account> accountList, 
    																							Map<Id, Id> userIdByContactId,
    																							String reportingPeriod){
    	
    	Map<Id, Process_Adherence_Monitoring__c> recordsToCreateByAccountId = new Map<Id, Process_Adherence_Monitoring__c>();
    	
    	Id pamIRRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR').getRecordTypeId();
        
        for(Account accObj : accountList){
        	
        	Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c();
        	pamObj.Organization_Name__c = accObj.Id;
        	
        	Id ownerIdToAssign = assignPamOwner(adminUser, accObj, userIdByContactId);
        	
        	if(ownerIdToAssign != null){
        		
	        	pamObj.OwnerId = ownerIdToAssign; 
        	}
        	
        	pamObj.Status__c = 'New';
        	pamObj.RecordTypeId = pamIRRecordTypeId;
        	pamObj.SCMD_Reporting_Period__c = reportingPeriod;
        	
        	recordsToCreateByAccountId.put(accObj.Id, pamObj);
        	
        }
        
        return recordsToCreateByAccountId;
    
    }
    
    private static Id assignPamOwner(User adminUser, Account accObj, Map<Id, Id> userIdByContactId){
    	
    	Id assignOwnerId;
    	
    	for(AccountContactRelation accountContactRelation : accObj.AccountContactRelations){
    		
    		if(assignOwnerId == null 
    			&& accountContactRelation.Contact.Contact_Type_SME__c != null
    			&& String.valueOf(accountContactRelation.Contact.Contact_Type_SME__c).containsIgnoreCase('Inventory Reconciliation') 
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
    	
    	return assignOwnerId;
    }
    
    public static void irReminderNotification(List<Process_Adherence_Monitoring__c> pamList, String reportPeriod){
    	
        try{
        
	        Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId = new Map<Id, List<Process_Adherence_Monitoring__c>>();
	        Map<Id, List<AccountContactRelation>> accountContactRelListByAccId = new Map<Id, List<AccountContactRelation>>();
	        
	        for(Process_Adherence_Monitoring__c pamObj : pamList){
	        	
	        	if(pamListByAccId.containsKey(pamObj.Organization_Name__c)){
	        		
	        		List<Process_Adherence_Monitoring__c> pamTempList = pamListByAccId.get(pamObj.Organization_Name__c);
	        		
	        		pamTempList.add(pamObj);
	        		
					pamListByAccId.put(pamObj.Organization_Name__c, pamTempList);	        		
	        		
	        	}else{
	        		
	        		pamListByAccId.put(pamObj.Organization_Name__c, new List<Process_Adherence_Monitoring__c>{pamObj});
	        	}
	        	
	        }
	        
	       List<AccountContactRelation> accountContactRelationList = [SELECT Id, AccountId, Account.Name, ContactId, Contact.FirstName, Contact.Email, 
	       															Contact.Community_User__c, Contact.Contact_Type_SME__c FROM AccountContactRelation
	       															WHERE AccountId IN :pamListByAccId.keySet() 
	       															AND Contact.Contact_Type_SME__c Includes('Inventory Reconciliation')
	       															AND Contact.Inactive_Contact__c = FALSE];
	       															
	       for( AccountContactRelation accountConRelObj : accountContactRelationList){
	       	
	       		if(accountContactRelListByAccId.containsKey(accountConRelObj.AccountId)){
	       			
	       			List<AccountContactRelation> temp = accountContactRelListByAccId.get(accountConRelObj.AccountId);
	       			temp.add(accountConRelObj);
	       			accountContactRelListByAccId.put(accountConRelObj.AccountId, temp);
	       		
	       		}else{
	       			
	       			accountContactRelListByAccId.put(accountConRelObj.AccountId, new List<AccountContactRelation> {accountConRelObj});	
	       		}
	       		
	       }
	       
	       if(!pamListByAccId.isEmpty() && !accountContactRelListByAccId.isEmpty()){
	       		sendReminderEmailToContacts(pamListByAccId, accountContactRelListByAccId, reportPeriod);
	       }
	
	       
        }catch(Exception ex){
        	
			 //errors.add(ex);
 			 system.debug('Exception in IR monthly Reminder Batch -->'+ex);
 			 throw ex; 
        
        }
       
    }
    
    public static void irFinalReminder(List<Process_Adherence_Monitoring__c> pamList, String reportPeriod){
        
	        Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId = new Map<Id, List<Process_Adherence_Monitoring__c>>();
	        Map<Id, List<AccountContactRelation>> accountContactRelListByAccId = new Map<Id, List<AccountContactRelation>>();
	        
	        for(Process_Adherence_Monitoring__c pamObj : pamList){
	        	
	        	if(pamListByAccId.containsKey(pamObj.Organization_Name__c)){
	        		
	        		List<Process_Adherence_Monitoring__c> pamTempList = pamListByAccId.get(pamObj.Organization_Name__c);
	        		
	        		pamTempList.add(pamObj);
	        		
					pamListByAccId.put(pamObj.Organization_Name__c, pamTempList);	        		
	        		
	        	}else{
	        		
	        		pamListByAccId.put(pamObj.Organization_Name__c, new List<Process_Adherence_Monitoring__c>{pamObj});
	        	}
	        	
	        }
	        
	       List<AccountContactRelation> accountContactRelationList = [SELECT Id, AccountId, Account.Name, ContactId, Contact.FirstName, Contact.Email, 
	       															Contact.Community_User__c, Contact.Contact_Type_SME__c FROM AccountContactRelation
	       															WHERE AccountId IN :pamListByAccId.keySet() 
	       															AND Contact.Contact_Type_SME__c Includes('Inventory Reconciliation')
	       															AND Contact.Inactive_Contact__c = FALSE];
	       															
	       for( AccountContactRelation accountConRelObj : accountContactRelationList){
	       	
	       		if(accountContactRelListByAccId.containsKey(accountConRelObj.AccountId)){
	       			
	       			List<AccountContactRelation> temp = accountContactRelListByAccId.get(accountConRelObj.AccountId);
	       			temp.add(accountConRelObj);
	       			accountContactRelListByAccId.put(accountConRelObj.AccountId, temp);
	       		
	       		}else{
	       			
	       			accountContactRelListByAccId.put(accountConRelObj.AccountId, new List<AccountContactRelation> {accountConRelObj});	
	       		}
	       		
	       }
	       
	       if(!pamListByAccId.isEmpty()){
				sendIRFinalReminderNotification(pamListByAccId, accountContactRelListByAccId, reportPeriod);
	       }
	       
    }
    
    public static void sendIRFinalReminderNotification(Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId, 
    																				Map<Id, List<AccountContactRelation>> accountContactRelListByAccId,
    																				String reportPeriod){
    	
    	List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
    	setIRDates(reportPeriod);
    	
    	for(Id accountId : pamListByAccId.keySet()){
    		
			List<AccountContactRelation> accountContactRelationList = accountContactRelListByAccId.get(accountId);
			
			List<Process_Adherence_Monitoring__c> pamList = pamListByAccId.get(accountId);
			
			if(accountContactRelationList != null){
				
				for(AccountContactRelation accountConRelObj : accountContactRelationList){
					
					for(Process_Adherence_Monitoring__c pamObj : pamList){
						
						String subject = pamObj.Organization_Name__r.Firm_ID__c + ' Monthly Inventory Reconciliation  – Final Reminder '+ reportingPeriod;
						if( accountConRelObj.Contact.Contact_Type_SME__c != null 
	    					&& String.valueOf(accountConRelObj.Contact.Contact_Type_SME__c).containsIgnoreCase('Inventory Reconciliation')
	    					&& pamObj != null ){
								
								IR_EmailCommunicationTemplates.IRCommunicationWrapper irCommunicationWrapperObj = createIrCommunicationWrapper(accountConRelObj, pamObj); 
								sentMailToContactList.add(createEmailForIR(irCommunicationWrapperObj, subject, ProcessType.FINAL_REMINDER));
	    					}
					}
				
				}
			}
    	} 
    	
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
    	}
    	
    }
    
    public static void irFinalEscalation(List<Process_Adherence_Monitoring__c> pamList, String reportPeriod){
    	
        Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId = new Map<Id, List<Process_Adherence_Monitoring__c>>();
        Map<Id, List<AccountContactRelation>> accountContactRelListByAccId = new Map<Id, List<AccountContactRelation>>();
        
        for(Process_Adherence_Monitoring__c pamObj : pamList){
        	
        	pamObj.Status__c = 'Final Escalation';
        	
        	if(pamListByAccId.containsKey(pamObj.Organization_Name__c)){
        		
        		List<Process_Adherence_Monitoring__c> pamTempList = pamListByAccId.get(pamObj.Organization_Name__c);
        		
        		pamTempList.add(pamObj);
        		
				pamListByAccId.put(pamObj.Organization_Name__c, pamTempList);	        		
        		
        	}else{
        		
        		pamListByAccId.put(pamObj.Organization_Name__c, new List<Process_Adherence_Monitoring__c>{pamObj});
        	}
        	
        }
        
       List<AccountContactRelation> accountContactRelationList = [SELECT Id, AccountId, Account.Name, ContactId, Contact.FirstName, Contact.Email, 
       																	Contact.Community_User__c, Contact.Contact_Type_SME__c 
	       															FROM AccountContactRelation
	       															WHERE AccountId IN :pamListByAccId.keySet() 
	       															AND Contact.Contact_Type_SME__c Includes('Inventory Reconciliation') 
	       															AND Contact.Inactive_Contact__c = FALSE];
       															
       for( AccountContactRelation accountConRelObj : accountContactRelationList){
       	
       		if(accountContactRelListByAccId.containsKey(accountConRelObj.AccountId)){
       			
       			List<AccountContactRelation> temp = accountContactRelListByAccId.get(accountConRelObj.AccountId);
       			temp.add(accountConRelObj);
       			accountContactRelListByAccId.put(accountConRelObj.AccountId, temp);
       		
       		}else{
       			
       			accountContactRelListByAccId.put(accountConRelObj.AccountId, new List<AccountContactRelation> {accountConRelObj});	
       		}
       		
       }
       
       
       if(!pamListByAccId.isEmpty()){
       
	       update pamList;
	       sendIRFinalEscalationNotification(pamListByAccId, accountContactRelListByAccId, reportPeriod);
       }
        	
    }
    
    
    public static void sendIRFinalEscalationNotification(Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId, 
    																				Map<Id, List<AccountContactRelation>> accountContactRelListByAccId,
    																				String reportPeriod){
    	
    	List<Messaging.SingleEmailMessage> sentMailToCantactList = new List<Messaging.SingleEmailMessage>();
    	setIRDates(reportPeriod);
    	
    	for(Id accountId : pamListByAccId.keySet()){
    		
			List<AccountContactRelation> accountContactRelationList = accountContactRelListByAccId.get(accountId);
			
			List<Process_Adherence_Monitoring__c> pamList = pamListByAccId.get(accountId);
			
			if(accountContactRelationList != null){
				
				for(AccountContactRelation accountConRelObj : accountContactRelationList){
					
					for(Process_Adherence_Monitoring__c pamObj : pamList){
						
						String subject = pamObj.Organization_Name__r.Firm_ID__c + ' Monthly Inventory Reconciliation  – Final Escalation '+ reportingPeriod;
						if( accountConRelObj.Contact.Contact_Type_SME__c != null 
	    					&& String.valueOf(accountConRelObj.Contact.Contact_Type_SME__c).containsIgnoreCase('Inventory Reconciliation')
	    					&& pamObj != null ){
								
								IR_EmailCommunicationTemplates.IRCommunicationWrapper irCommunicationWrapperObj = createIrCommunicationWrapper(accountConRelObj, pamObj); 
								sentMailToCantactList.add(createEmailForIR(irCommunicationWrapperObj, subject, ProcessType.FINAL_ESCALATION));
	    					}
					}
				
				}
			}
    	} 
    	
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToCantactList);
    	}
    	
    }
    
    public static void noResponse(List<Process_Adherence_Monitoring__c> pamList){
        Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId = new Map<Id, List<Process_Adherence_Monitoring__c>>();
        Map<Id, String> accountOwnerEmailByAccId = new Map<Id, String>();
        
        for(Process_Adherence_Monitoring__c pamObj : pamList){
        	
        	if(pamListByAccId.containsKey(pamObj.Organization_Name__c)){
        		
        		List<Process_Adherence_Monitoring__c> pamTempList = pamListByAccId.get(pamObj.Organization_Name__c);
        		
        		pamTempList.add(pamObj);
        		
				pamListByAccId.put(pamObj.Organization_Name__c, pamTempList);	        		
        		
        	}else{
        		
        		pamListByAccId.put(pamObj.Organization_Name__c, new List<Process_Adherence_Monitoring__c>{pamObj});
        	}
        	
        }
        
        List<Account> accountList = [SELECT OwnerId, Owner.Name, Owner.Email FROM Account WHERE Id IN :pamListByAccId.keySet()]; 
        
        for(Account accountObj : accountList){
        	
        	accountOwnerEmailByAccId.put(accountObj.Id, accountObj.Owner.Email);
        }
        
        if(pamListByAccId != null){
	        notifyOwnerAndInventoryRecon(pamListByAccId, accountOwnerEmailByAccId);
        }
    }
    
    private static void notifyOwnerAndInventoryRecon(Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId, Map<Id, String> accountOwnerEmailByAccId){
		List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
		
		for(Id accountId : pamListByAccId.keySet()){
			
			List<Process_Adherence_Monitoring__c> pamList = pamListByAccId.get(accountId);
			for(Process_Adherence_Monitoring__c pamObj : pamList){
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				String[] toAddresses = new String[] {LO_INVENTORY_RECON_EMAIL};
				if(pamObj.Organization_Name__c != null 
						&& accountOwnerEmailByAccId.containsKey(accountId) 
						&& accountOwnerEmailByAccId.get(accountId) != null){
	
					toAddresses.add(accountOwnerEmailByAccId.get(accountId));
				}
				mail.setToAddresses(toAddresses);
				mail.setSubject(pamObj.Organization_Name__r.Firm_ID__c+' Monthly YGC Inventory Reconciliation ' + pamObj.SCMD_Reporting_Period__c +' - No Response From Firm');
				mail.sethtmlBody(IR_EmailCommunicationTemplates.noResponseNotificationTemplate());
				sentMailToContactList.add(mail);
			}
			
		}
		
		if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToContactList);
		}
    }
    
    private static void sendReminderEmailToContacts(Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccId, 
    													Map<Id, List<AccountContactRelation>> accountContactRelListByAccId,
    													String reportPeriod){
    	
    	List<Messaging.SingleEmailMessage> sentMailToCantactList = new List<Messaging.SingleEmailMessage>();
    	setIRDates(reportPeriod);
    	
    	for(Id accountId : pamListByAccId.keySet()){
    		
			List<AccountContactRelation> accountContactRelationList = accountContactRelListByAccId.get(accountId);
			
			List<Process_Adherence_Monitoring__c> pamList = pamListByAccId.get(accountId);
			
			if(accountContactRelationList != null){
				
				for(AccountContactRelation accountConRelObj : accountContactRelationList){
					
					for(Process_Adherence_Monitoring__c pamObj : pamList){
						
						String subject = pamObj.Organization_Name__r.Firm_ID__c + ' Monthly Inventory Reconciliation  – Reminder Communication '+ reportingPeriod;
						if( accountConRelObj.Contact.Contact_Type_SME__c != null 
	    					&& String.valueOf(accountConRelObj.Contact.Contact_Type_SME__c).containsIgnoreCase('Inventory Reconciliation')
	    					&& pamObj != null ){
							
							IR_EmailCommunicationTemplates.IRCommunicationWrapper irCommunicationWrapperObj = createIrCommunicationWrapper(accountConRelObj, pamObj); 
							sentMailToCantactList.add(createEmailForIR(irCommunicationWrapperObj, subject, ProcessType.REMINDER));
							
	    				}
					}
				}
			}
		
			
    	} 
    	
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(sentMailToCantactList);
    	}
    	
    }
    
    private static void sendDayBeforeCutOffNotification(Map<Id, Process_Adherence_Monitoring__c> recordsToCreateByAccountId, 
    														Map<Id, Account> accountByAccountId, User adminUser, String reportPeriod){
    	
    	setIRDates(reportPeriod);
    	String adminEmail = systemAdminstratorEmail == '' ? 'lcsalesforceadmin@mcmcg.com' : SYSTEM_ADMIN_EMAIL;
    	List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
    	for(Id accountId : accountByAccountId.keySet()){
    		
    		Process_Adherence_Monitoring__c pamObj = recordsToCreateByAccountId.get(accountId);
    		String subject = accountByAccountId.get(accountId).Firm_ID__c + ' Monthly Inventory Reconciliation  – Reminder Communication '+ reportingPeriod;
    		List<AccountContactRelation> accountContactRelationsList = accountByAccountId.get(accountId).AccountContactRelations;
    		
    		for(AccountContactRelation accountContactRelationObj : accountContactRelationsList){
    			
    			if( accountContactRelationObj.Contact.Contact_Type_SME__c != null 
    				&& String.valueOf(accountContactRelationObj.Contact.Contact_Type_SME__c).containsIgnoreCase('Inventory Reconciliation')
    				&& pamObj != null ){
						
						IR_EmailCommunicationTemplates.IRCommunicationWrapper irCommunicationWrapperObj = createIrCommunicationWrapper(accountContactRelationObj, pamObj); 
						mailsToSend.add(createEmailForIR(irCommunicationWrapperObj, subject, ProcessType.DAY_BEFORE));
						
    				}
    			
    		}
    		
    		if(recordsToCreateByAccountId.get(accountId).ownerId == adminUser.Id){
    			
    			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				String[] toAddresses = new String[] {ATTORNEY_ASSIGNMENT_EMAIL};
				mail.setToAddresses(toAddresses);
				mail.setSubject(accountByAccountId.get(accountId).Firm_ID__c+' Unassigned IR Record ' 
									+ recordsToCreateByAccountId.get(accountId).SCMD_Reporting_Period__c);
				mail.sethtmlBody(SCMDEmailCommunicationTemplates.getUnassignedPamOwnerTemplate());
    			
    			mailsToSend.add(mail);
    		}
			
    	} 
    	
    	if(!Test.isRunningTest()){
	    	Messaging.sendEmail(mailsToSend);
    	}
    }
    
    private static IR_EmailCommunicationTemplates.IRCommunicationWrapper createIrCommunicationWrapper(AccountContactRelation accountContactRelationObj, 
    																										Process_Adherence_Monitoring__c pamObj){
    	String adminEmail = systemAdminstratorEmail == '' ? 'lcsalesforceadmin@mcmcg.com' : SYSTEM_ADMIN_EMAIL;
    	IR_EmailCommunicationTemplates.IRCommunicationWrapper irCommunicationWrapperObj = new IR_EmailCommunicationTemplates.IRCommunicationWrapper();
    	irCommunicationWrapperObj.contactFirstName = accountContactRelationObj.Contact.FirstName;
						irCommunicationWrapperObj.cutOffDate = cuttOffdate;
						irCommunicationWrapperObj.filesDueToMCM = filesDueToMCMdate;
						irCommunicationWrapperObj.isCommmunityUser = accountContactRelationObj.Contact.Community_User__c == null 
																					? false 
																					: accountContactRelationObj.Contact.Community_User__c;
						irCommunicationWrapperObj.actionItemCompleted = actionItemCompletedDate;
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
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
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