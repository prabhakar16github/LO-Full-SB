global with sharing class PAM_SendSOLNotificationBatch implements Database.Batchable<SObject>{
	
	private static String communityLcPartnerBaseUrl;
    
    global database.querylocator start(Database.BatchableContext bc){
        String query= 'Select Name,Firm_ID__c,FRB_Firm_Check__c,SOL_Exceptions_0_4__c,SOL_Exceptions_5_9__c,SOL_Exceptions_10__c, ' +
                        '(SELECT id FROM Process_Adherence_Monitoring__r WHERE Status__c != \'Closed\' LIMIT 1) FROM Account WHERE ' +
                        '(SOL_Exceptions_0_4__c != 0 AND SOL_Exceptions_0_4__c != null)';
        /*
        String query= 'Select Name,Firm_ID__c,FRB_Firm_Check__c,SOL_Exceptions_0_4__c,SOL_Exceptions_5_9__c,SOL_Exceptions_10__c, ' +
                        '(SELECT id FROM Process_Adherence_Monitoring__r WHERE Status__c != \'Closed\' LIMIT 1) FROM Account WHERE id = \'001U000000iHD6vIAG\'';
        */
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accList){
        if(accList[0].Process_Adherence_Monitoring__r.size() != 0){
            
            if(!Test.isRunningTest()){
            	
	            communityLcPartnerBaseUrl = Utils.getCommunityBaseUrl();
	            
            }else{
            	
            	communityLcPartnerBaseUrl = '';
            }
            
        	
            String baseURL = URL.getSalesforceBaseUrl()+'';
            baseURL = baseURL.substringAfter('=').substringBefore(']');
            
            Database.QueryLocator ql = Database.getQueryLocator('SELECT id FROM Process_Adherence_Monitoring__c LIMIT 1');
            ApexPages.StandardSetController setController = new ApexPages.StandardSetController(ql);
            System.SelectOption[] listViews = setController.getListViewOptions();
            Map<String,String> listViewMap = new Map<String,String>();
            for(System.SelectOption listView : listViews){
                if(listView.getLabel() == 'SOL1: 0-4 Days' || listView.getLabel() == 'SOL2: 5-9 Days' || 
                   listView.getLabel() == 'SOL3: 10+ Days'){
                    listViewMap.put(listView.getLabel(),listView.getValue().substring(0,15));
                }
            }
            
            List<String> contactList = new List<String>(FetchNotificationUser(accList[0].id));
            List<Messaging.SingleEmailMessage> messagingList = new List<Messaging.SingleEmailMessage>();
            
            Blob pdfBody;
                
            if(!Test.isRunningTest()){
                PageReference pdf = Page.SOLPDFReport;
                pdf.getParameters().put('id',accList[0].id);
                pdf.getParameters().put('name',accList[0].Name);
                pdfBody = pdf.getContent();
            }else{
                pdfBody = Blob.toPDF('Test PDF');
            }
            
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('Statute of Limitations Exception - ' + String.valueOf(system.today()) + '.pdf');
            efa.setBody(pdfBody);
            
            if(accList[0].SOL_Exceptions_0_4__c == null) accList[0].SOL_Exceptions_0_4__c = 0;
            if(accList[0].SOL_Exceptions_5_9__c == null) accList[0].SOL_Exceptions_5_9__c = 0;
            if(accList[0].SOL_Exceptions_10__c == null) accList[0].SOL_Exceptions_10__c = 0;
            
            List<Document> documentsList = [SELECT Id, Name, DeveloperName FROM Document WHERE DeveloperName = 'Encore_Corporate_Logo_png'];
            
            String documentId = documentsList.isEmpty() == true ? '' : documentsList.get(0).Id; 
            String orgId = UserInfo.getOrganizationId(); 
            
            for(String contactVar : contactList){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String body = getHtmlEmailBody(contactVar, accList[0], listViewMap, baseURL, documentId, orgId);
                mail.setSubject(accList[0].Firm_ID__c + ' SOL Observations Outstanding (' + system.today().month() + '/' + system.today().year() + ')');
                mail.sethtmlBody(body); 
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'lo-operational@mcmcg.com'];
                if ( owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                mail.setReplyTo('LO-Operational@mcmcg.com');
                mail.setToAddresses(new List<String>{contactVar.substringBefore(',')});
                //mail.setToAddresses(new List<String>{'suryansh.gupta@mcmcg.com'});
                mail.setSaveAsActivity(false);
                
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                messagingList.add(mail);
            }
            system.debug(Messaging.sendEmail(messagingList));
        }
    }
    
    global void finish(Database.BatchableContext bc){
    	
    	List<Case> caseList = [SELECT Id, Outcome_FTR__c FROM Case WHERE Outcome_FTR__c = 'Scripts - SOL running in progress'];
    	
    	for(Case caseObj : caseList){
			caseObj.Outcome_FTR__c = 'Completed.';    		
    	}
    	
    	try{
	    	update caseList;
    	}catch(Exception ex){
    		system.debug('Exception Occurs in updating case list in PAM_sendSolNotification Batch. '+ex);
    		throw ex;
    	}
    	
    	
    	AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
						      TotalJobItems, CreatedBy.Email
						      FROM AsyncApexJob 
						      WHERE Id = :BC.getJobId()];
						      
	   // Send an email to the Apex job's submitter notifying of job completion.
	   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	   String[] toAddresses = new String[] {'lcsalesforceadmin@mcmcg.com'};
	   mail.setToAddresses(toAddresses);
	   mail.setSubject('Apex Sharing Recalculation ' + a.Status);
	   mail.setPlainTextBody('The PAM_SendSOLNotificationBatch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
	   
	   if(!Test.isRunningTest()){
		   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	   }
	   
    }
    
    private String getHtmlEmailBody(String contactVar, Account account, Map<String,String> listViewMap, String baseURL, String documentId, String orgId){
    	
    	String emailBody = '<html lang="ja"><body>';
    	emailBody += '<p align="center"><img src="'+baseURL+'/servlet/servlet.ImageServer?id='+documentId+'&oid='+orgId+'"/></p>';
		emailBody += 'Hello  '+contactVar.substringAfter(',')+',';
		emailBody += '<p>&nbsp;</p>';
		emailBody += '<p>MCM has identified accounts that require the Firm\'s review and response.'; 
		emailBody += '<strong> Our records indicate that there may be discrepancies with the account information provided by the Firm, ';
		emailBody += 'impacting Statute of Limitations (SOL). </strong>In order to reconcile our records, please follow the required actions below.</p>';
		emailBody += '<p>&nbsp;</p>';
		emailBody += '<p><strong><u>Required Actions</u></strong></p>';
		emailBody += '<p>&nbsp;</p>';
		emailBody += '<ul>';
		emailBody += '<li>Access and review account information within the "Process Adherence Monitoring" tab of the LC Partner Access Site.</li>';
		emailBody += '<li>Within each account record, provide required information under the "Observation Details" section.';
		emailBody += '<ul>';
		emailBody += '<li>It is critical that the Firm provide accurate dates and state information, as this may impact the resolution of the account.</li>';
		emailBody += '<li>Review the SOL process generating data for each field, and confirm that the process is working correctly.</li>';
		emailBody += '<li>Provide a thorough explanation of the Firm&rsquo;s SOL process, detailing the SOL calculation utilized for each account.';
		emailBody += ' <em>The Firm must provide an explanation on ALL accounts. </em></li>';
		emailBody += '</ul>';
		emailBody += '</li>';
		emailBody += '</ul>';
		emailBody += '<p>&nbsp;</p>';
		emailBody += '<p>For your convenience, links to the account records are below, including the volume of records in each category:</p>';
		emailBody += '<p>&nbsp;</p>';
		emailBody += '<p><a href="' + communityLcPartnerBaseUrl + '/a0s?fcf=' + listViewMap.get('SOL1: 0-4 Days') + '">0-4 Days (New) - </a>'+Integer.valueOf(account.SOL_Exceptions_0_4__c)+'</p>';
		emailBody += '<p><a href="' + communityLcPartnerBaseUrl + '/a0s?fcf=' + listViewMap.get('SOL2: 5-9 Days') + '">5-9 Days (Approaching Critical Timeframe) - </a>'+Integer.valueOf(account.SOL_Exceptions_5_9__c)+'</p>';
		emailBody += '<p><a href="' + communityLcPartnerBaseUrl + '/a0s?fcf=' + listViewMap.get('SOL3: 10+ Days') + '">10+ Days (Immediate Correction Required) - </a>'+Integer.valueOf(account.SOL_Exceptions_10__c)+'</p>';
		emailBody += '<p>&nbsp;</p>';
		emailBody += '<p>The Firm must provide responses by submitting all required information for each account within <strong>';
		emailBody += '<u>three</u></strong><u> <strong>(3) business days</strong></u>.</p>';
		emailBody += '<p>&nbsp;</p>';
		emailBody += '<p>For any questions related to an individual account record, please utilize the question button, ';
		emailBody += 'which will generate an inquiry to <a href="mailto:LO-Operational@mcmcg.com">LO-Operational@mcmcg.com</a>.</p>';
		emailBody += '<p>&nbsp;</p>';
		emailBody += '<p>Thank you,</p>';
		emailBody += '<p>LO-Operational (SOL)</p>';

		return emailBody;
    }
    
    private List<String> FetchNotificationUser(Id accountId){
    	
        List<String> tempList = new List<String>();
        Set<String> duplicateEmails = new Set<String>();
        
        for(Contact conVar : [SELECT FirstName, Email FROM Contact WHERE AccountId =: accountId AND Inactive_Contact__c = FALSE AND 
                                (Contact_Type_SME__c INCLUDES ('SOL') OR Contact_Type_SME__c = 'SOL')]){
            duplicateEmails.add(conVar.Email);
            String tempStr = conVar.Email + ',' + conVar.FirstName;
            tempList.add(tempStr);
        }
        
        for(Process_Adherence_Monitoring__c pamObj : [SELECT OwnerId FROM Process_Adherence_Monitoring__c WHERE 
                                                        Status__c != 'Closed' AND Organization_Name__c =: accountId LIMIT 1]){
            
            List<User> userList = [SELECT FirstName, Email FROM User WHERE id =: pamObj.OwnerId AND IsActive = true];
            
            if(userList.size() > 0){
            	
	            User userObj = new User();
	            
	            userObj = userList.get(0);
	            
	            String tempStr = userObj.Email + ',' + userObj.FirstName;
	            if(!duplicateEmails.contains(userObj.Email)) tempList.add(tempStr);
            }
            
        }
        
        return tempList;
    }
}