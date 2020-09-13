global with sharing class PAM_SendCCMNotificationBatch implements Database.Batchable<SObject>{
	
	private static String communityLcPartnerBaseUrl;
    
    global database.querylocator start(Database.BatchableContext bc){
        String query= 'Select Name,Firm_ID__c,FRB_Firm_Check__c,CCM_Exceptions_0_30__c,CCM_Exceptions_31_60__c,CCM_Exceptions_61__c, (SELECT id FROM Process_Adherence_Monitoring__r WHERE Status__c != \'Closed\' AND Status__c != \'Excluded\' LIMIT 1) FROM Account WHERE (CCM_Exceptions_0_30__c!= 0 AND CCM_Exceptions_0_30__c!= null) OR (CCM_Exceptions_31_60__c!= 0 AND CCM_Exceptions_31_60__c!= null) OR (CCM_Exceptions_61__c!= 0 AND CCM_Exceptions_61__c!= null)';
        return Database.getQueryLocator(query); 
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accList){
        if(accList[0].Process_Adherence_Monitoring__r.size() != 0){
        	
        	if(!Test.isRunningTest()){
            	
	            communityLcPartnerBaseUrl = Utils.getCommunityBaseUrl();
	            
            }else{
            	
            	communityLcPartnerBaseUrl = '';
            }
            
        	
            //String baseURL = URL.getSalesforceBaseUrl()+'';
            //baseURL = baseURL.substringAfter('=').substringBefore(']');
            
            Database.QueryLocator ql = Database.getQueryLocator('SELECT id FROM Process_Adherence_Monitoring__c LIMIT 1');
            ApexPages.StandardSetController setController = new ApexPages.StandardSetController(ql);
            System.SelectOption[] listViews = setController.getListViewOptions();
            Map<String,String> listViewMap = new Map<String,String>();
            for(System.SelectOption listView : listViews){
                if(listView.getLabel() == 'CCM1: 0-30 Days' || listView.getLabel() == 'CCM2: 31-60 Days' || 
                   listView.getLabel() == 'CCM3: 61+ Days'){
                    listViewMap.put(listView.getLabel(),listView.getValue().substring(0,15));
                }
            }
            
            List<String> contactList = new List<String>(FetchNotificationUser(accList[0].id));
            List<Messaging.SingleEmailMessage> messagingList = new List<Messaging.SingleEmailMessage>();
            
            Blob pdfBody;
                
            if(!Test.isRunningTest()){
                PageReference pdf = Page.CCMPDFReport;
                pdf.getParameters().put('id',accList[0].id);
                pdf.getParameters().put('name',accList[0].Name);
                pdfBody = pdf.getContent();
            }else{
                pdfBody = Blob.toPDF('Test PDF');
            }
            
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('Court Cost Monitoring Exception - ' + String.valueOf(system.today()) + '.pdf');
            efa.setBody(pdfBody);
            system.debug('Account ' + accList[0].Name);
            if(accList[0].CCM_Exceptions_0_30__c == null) accList[0].CCM_Exceptions_0_30__c = 0;
            if(accList[0].CCM_Exceptions_31_60__c == null) accList[0].CCM_Exceptions_31_60__c = 0;
            if(accList[0].CCM_Exceptions_61__c == null) accList[0].CCM_Exceptions_61__c = 0;
            
            for(String contactVar : contactList){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                string body =   '<html lang="ja"><body>'+
                                    'Hello  '+contactVar.substringAfter(',')+
                                    '<br><br>'+'Below are links to the Court Cost Monitoring exception lists. Click on each link or log into'+
                                    '<br><br>'+'Salesforce accessing the Process Adherence Monitoring Object list views to see a list of'+
                                    '<br><br>'+'accounts for each timeframe bucket.'+
                                    '<br><br><a href="' + communityLcPartnerBaseUrl + '/a0s?fcf=' + listViewMap.get('CCM1: 0-30 Days') + '">0-30 Days (New Exception)</a>     '+
                                     +Integer.valueOf(accList[0].CCM_Exceptions_0_30__c)+
                                    '<br><br><a href="' + communityLcPartnerBaseUrl + '/a0s?fcf=' + listViewMap.get('CCM2: 31-60 Days') + '">31-60 Days (Approaching Critical Timeframe)</a>     '+
                                     +Integer.valueOf(accList[0].CCM_Exceptions_31_60__c)+
                                    '<br><br><a href="' + communityLcPartnerBaseUrl + '/a0s?fcf=' + listViewMap.get('CCM3: 61+ Days') + '">61+ Days (Immediate Correction Required)</a>     '+
                                     +Integer.valueOf(accList[0].CCM_Exceptions_61__c)+
                                     '<br><br>To clear the exceptions please submit one of the following:'+
                                     '<br><br>Suit:'+
                                     '<br><br><ul><li>Record 41 with Suit Date populated</li><li>Record 39 with*CC:P110 PCode</li><li>Record 39 with*CC:L134 PCode</li></ul>'+
                                     '<br><br>Judgment:'+
                                     '<br><br><ul><li>Record 41 with Judgment Date populated</li><li>Record 39 with*CC:J100 PCode</li><li>Record 39 with*CC:L129 PCode</li></ul>'+
                                     '<br><br>'+'For Questions, please select the question button on any active Court Cost Monitoring record and complete the editable fields or email LO-Operational@mcmcg.com with general questions not related to a specific record.'+
                                     '<br><br>'+'Thanks'+
                                    '<br><br>'+'Court Cost Monitoring Team';               
                mail.setSubject(accList[0].Firm_ID__c + ' Court Cost Monitoring Exceptions');
                mail.sethtmlBody(body); 
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'lo-operational@mcmcg.com'];
                if ( owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                mail.setReplyTo('LO-Operational@mcmcg.com');
                mail.setToAddresses(new List<String>{contactVar.substringBefore(',')});
                //mail.setToAddresses(new List<String>{'neeraj.patni@mcmcg.com'});
                
                mail.setSaveAsActivity(false);
                
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                messagingList.add(mail);
            }
            system.debug(Messaging.sendEmail(messagingList));
        }
    }
    
    global void finish(Database.BatchableContext bc){
    	
    	List<Case> caseList = [SELECT Id, Outcome_FTR__c FROM Case WHERE Outcome_FTR__c = 'Scripts - CCM running in progress'];
    	
    	for(Case caseObj : caseList){
			caseObj.Outcome_FTR__c = 'Completed.';    		
    	}
    	
    	update caseList;
    	
    	AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
						      TotalJobItems, CreatedBy.Email
						      FROM AsyncApexJob 
						      WHERE Id = :BC.getJobId()];
						      
	   // Send an email to the Apex job's submitter notifying of job completion.
	   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	   String[] toAddresses = new String[] {'lcsalesforceadmin@mcmcg.com'};
	   mail.setToAddresses(toAddresses);
	   mail.setSubject('Apex Sharing Recalculation ' + a.Status);
	   mail.setPlainTextBody('The PAM_SendCCMNotificationBatch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
	   
	   if(!Test.isRunningTest()){
	   		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	   }
    	
    }
    
    private List<String> FetchNotificationUser(Id accountId){
    	
        List<String> tempList = new List<String>();
        Set<String> duplicateEmails = new Set<String>();
        
        for(Contact conVar : [SELECT FirstName, Email FROM Contact WHERE AccountId =: accountId AND Inactive_Contact__c = FALSE AND 
                                (Contact_Type_SME__c INCLUDES ('Financial Exceptions/Court Costs') OR Contact_Type_SME__c = 'Financial Exceptions/Court Costs')]){
           
			if(conVar.Email != null && conVar.FirstName != null){
			
	            duplicateEmails.add(conVar.Email);
	            String tempStr = conVar.Email + ',' + conVar.FirstName;
	            tempList.add(tempStr);
			}
        }
        
        for(Process_Adherence_Monitoring__c pamObj : [SELECT OwnerId FROM Process_Adherence_Monitoring__c WHERE 
                                                        Status__c != 'Closed' AND Status__c != 'Excluded' AND Organization_Name__c =: accountId LIMIT 1]){
            
            
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