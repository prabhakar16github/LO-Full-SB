public class PNA_Service {
	
	private static String baseUrl = String.valueOf(System.Url.getSalesforceBaseUrl().toExternalForm());
	private static String communityLcPartnerBaseUrl;
	private static String pamObjectPrefix = Schema.SObjectType.Process_Adherence_Monitoring__c.getKeyPrefix();
	
	static{
		
		if( communityLcPartnerBaseUrl == null && !Test.isRunningTest()){
			
			communityLcPartnerBaseUrl = Utils.getCommunityBaseUrl();
		}
		
	}
	
	public static void sendReportnotificationToContacts(List<Account> accountList){
        
        Map<String,String> listViewMap = new Map<String,String>();
        
        Database.QueryLocator ql = Database.getQueryLocator('SELECT id FROM Process_Adherence_Monitoring__c LIMIT 1');
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(ql);
        System.SelectOption[] listViews = setController.getListViewOptions();
        
        for(System.SelectOption listView : listViews){
            if(listView.getLabel() == 'PNA : 0-3 Days' || listView.getLabel() == 'PNA : 4-6 Days' || 
               listView.getLabel() == 'PNA : 7+ Days'){
               	
               listViewMap.put(listView.getLabel(),listView.getValue().substring(0,15));
            }
        }
        
		Map<Id, Account> accountByAccountId = new Map<Id, Account>(accountList);
        
        Map<Id, List<Contact>> contactListByAccountId = new Map<Id, List<Contact>>();
        
        List<Messaging.SingleEmailMessage> sendEmailToContacts = new List<Messaging.SingleEmailMessage>();  
        
        List<Contact> pnaContactsList = [SELECT Id, Name, FirstName, Email, AccountId, Community_User__c FROM Contact 
        									WHERE accountId IN : accountByAccountId.keySet() 
        										AND Contact_Type_SME__c INCLUDES ('Placement Acknowledgment')
        										AND Inactive_Contact__c != True];
        										
        										 
        
        for(Contact contactObj : pnaContactsList){
        	
        	if(contactListByAccountId.containsKey(contactObj.accountId)){
        		
        		List<Contact> temp = contactListByAccountId.get(contactObj.accountId);
        		temp.add(contactObj);  
        		contactListByAccountId.put(contactObj.accountId, temp);	
        		
        	}else{
        		
        		contactListByAccountId.put(contactObj.accountId, new List<Contact> {contactObj});
        	}
        	
        	
        }  
		
		OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'lo-operational@mcmcg.com'];
		
        
        for(Id accountId : accountByAccountId.keySet()){
			
			Blob pdfBody;
			        	
            PageReference pdf = Page.PNA_PDFReport;
            pdf.getParameters().put('id',accountId);
                
        	if(!Test.isRunningTest()){

	            pdfBody = pdf.getContent();
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
	            efa.setFileName('Placement Acknowledgment Exception - ' + String.valueOf(system.today()) + '.pdf');
	            efa.setBody(pdfBody);
                
                if(contactListByAccountId.get(accountId) == null){
                	
                	continue;
                }
                
                for(Contact contactObj : contactListByAccountId.get(accountId)){
					
					if(contactObj.Email != null && contactObj.Email != ''){
					
						Messaging.SingleEmailMessage singleEmailObj = new Messaging.SingleEmailMessage();
		                
		                singleEmailObj.setSubject(accountByAccountId.get(accountId).Firm_ID__c + ' Placement Acknowledgment Exceptions');
					    singleEmailObj.sethtmlBody(createEmailBodyForPDFNotification(contactObj.FirstName, contactObj.Community_User__c, accountByAccountId.get(accountId) , listViewMap));
					    
					    if ( owea.size() > 0 ) {
                    
						    singleEmailObj.setOrgWideEmailAddressId(owea.get(0).Id);
		                }
					    
					    singleEmailObj.setReplyTo('LO-Operational@mcmcg.com');
                		singleEmailObj.setToAddresses(new List<String>{contactObj.Email});
                		singleEmailObj.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                		
                		sendEmailToContacts.add(singleEmailObj);     		
					}
                }
	                
		    }else{
		    	
		        pdfBody = Blob.toPDF('Test PDF');
		        createEmailBodyForPDFNotification('Test', true, accountByAccountId.get(accountId) , listViewMap);
		    }
        }
        
        Messaging.sendEmail(sendEmailToContacts);
	}
    
    private static String createEmailBodyForPDFNotification(String contactName, Boolean isCommunityUser, Account accountObj, Map<String,String> listViewMap){
		
		String urlToListViews = baseUrl + '/' + pamObjectPrefix + '?fcf=';
		
		if(isCommunityUser){
			
			urlToListViews = communityLcPartnerBaseUrl + '/' + pamObjectPrefix + '?fcf=';
		}
		
		String htmlBody = '';
		       htmlBody = '<p>Hello ' +contactName+',</p>';
							
							htmlBody += '<p>The attached PDF contains a list of all open records for accounts that were placed to the Firm, ';
							htmlBody += 'but not acknowledged by the Firm. Please review the list and submit a Record 39 with ';
							htmlBody += 'the *CC:S101 pcode for each account to acknowledge the placement.</p>';
							
							htmlBody += '<p>LC Partner Access users may also click the links below to review the records in Salesforce:</p>';
							
								
							htmlBody += '<p><a href="'+urlToListViews + listViewMap.get('PNA : 0-3 Days')+'">';
							htmlBody += '<span style="color: #0070c0;">0-3 Days (Green - New Exception) - </span></a> ';
							htmlBody += String.valueOf(accountObj.PNA_Exceptions_0_3_bucket__c == null ? 0 : accountObj.PNA_Exceptions_0_3_bucket__c)+'</p>';
							
							htmlBody += '<p><a href="'+urlToListViews + listViewMap.get('PNA : 4-6 Days')+'">';
							htmlBody += '<span style="color: #0070c0;">4-6 Days (Yellow - Outside Correction Timeframe) - </span></a>';
							htmlBody += String.valueOf(accountObj.PNA_Exceptions_4_6_bucket__c == null ? 0 : accountObj.PNA_Exceptions_4_6_bucket__c)+'</p>';
							
							htmlBody += '<p><a href="'+urlToListViews + listViewMap.get('PNA : 7+ Days')+'">';
							htmlBody += '<span style="color: #0070c0;">7+  Days (Red - Immediate Correction Required) - </span></a>';
							htmlBody += String.valueOf(accountObj.PNA_Exceptions7Plusbucket__c == null ? 0 : accountObj.PNA_Exceptions7Plusbucket__c)+'</p>';
							
							htmlBody += '<p>If the Firm is unable to send the *CC:S101 pcode for an account, the LC Partner Access user must ';
							htmlBody += 'log into the LC Partner Access Site and search for the specific account number.&nbsp; ';
							htmlBody += 'Within each Salesforce record, select the appropriate reason from the dropdown list indicating ';
							htmlBody += 'why the pcode cannot be submitted.&nbsp;</p>';
							
							htmlBody += '<p>For any questions related to an individual account record, ';
							htmlBody += 'please utilize the question button, which will generate an inquiry to <a href="mailto:LO-Operational@mcmcg.com">';
							htmlBody += 'LO-Operational@mcmcg.com</a>.</p>';
							
							htmlBody += '<p>Thank you,</p>';
							htmlBody += '<p>LO Operations</p>';
							
		return htmlBody;
    }
}