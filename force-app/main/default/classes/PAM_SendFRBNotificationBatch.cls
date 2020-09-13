global with sharing class PAM_SendFRBNotificationBatch implements Database.Batchable<SObject>{
	
	private static String communityLcPartnerBaseUrl;
	
    global database.querylocator start(Database.BatchableContext bc){
        String query= 'Select Name,Firm_ID__c,FRB_Firm_Check__c,Number_of_Exception__c,Number_of_exceptions_under_4_6_bucket__c,Number_of_exceptions_under_7_10_bucket__c,Number_of_exceptions_under_11_19_bucket__c, (SELECT id FROM Process_Adherence_Monitoring__r WHERE Status__c != \'Closed\' LIMIT 1) FROM Account WHERE (Number_of_Exception__c!= 0 AND Number_of_Exception__c!= null) OR (Number_of_exceptions_under_4_6_bucket__c != 0 AND Number_of_exceptions_under_4_6_bucket__c != null) OR (Number_of_exceptions_under_7_10_bucket__c != 0 AND Number_of_exceptions_under_7_10_bucket__c != null) OR (Number_of_exceptions_under_11_19_bucket__c != 0 AND Number_of_exceptions_under_11_19_bucket__c != null)';
        //String query= 'Select Name,Firm_ID__c,FRB_Firm_Check__c,Number_of_Exception__c,Number_of_exceptions_under_4_6_bucket__c,Number_of_exceptions_under_7_10_bucket__c,Number_of_exceptions_under_11_19_bucket__c, (SELECT id FROM Process_Adherence_Monitoring__r WHERE Status__c != \'Closed\' LIMIT 1) FROM Account WHERE id = \'001U000000BGeODIA1\'';
        return Database.getQueryLocator(query); 
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accList){
    	
        if(accList[0].Process_Adherence_Monitoring__r.size() != 0){
            //String baseURL = String.valueOf(System.Url.getSalesforceBaseUrl().toExternalForm());
            
            if(!Test.isRunningTest()){
            	
	            communityLcPartnerBaseUrl = Utils.getCommunityBaseUrl();
	            
            }else{
            	
            	communityLcPartnerBaseUrl = '';
            }
            
            
            
            Database.QueryLocator ql = Database.getQueryLocator('SELECT id FROM Process_Adherence_Monitoring__c LIMIT 1');
            ApexPages.StandardSetController setController = new ApexPages.StandardSetController(ql);
            System.SelectOption[] listViews = setController.getListViewOptions();
            Map<String,String> listViewMap = new Map<String,String>();
            
            for(System.SelectOption listView : listViews){
            	
                if(listView.getLabel() == 'FRB1: 0-3 Days' || listView.getLabel() == 'FRB2: 4-6 Days' || 
                   listView.getLabel() == 'FRB3: 7-10 Days' || listView.getLabel() == 'FRB4: 11-19 Days'){
                    listViewMap.put(listView.getLabel(),listView.getValue().substring(0,15));
                }
            }
            
            List<String> contactList = new List<String>(FetchNotificationUser(accList[0].id));
            List<Messaging.SingleEmailMessage> messagingList = new List<Messaging.SingleEmailMessage>();
            
            Blob pdfBody;
                
            if(!Test.isRunningTest()){
                PageReference pdf = Page.FRBPDFReport;
                pdf.getParameters().put('id',accList[0].id);
                pdf.getParameters().put('name',accList[0].Name);
                pdfBody = pdf.getContent();
            }else{
                pdfBody = Blob.toPDF('Test PDF');
            }
            
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('Firm Reported Balance Exception - ' + String.valueOf(system.today()) + '.pdf');
            efa.setBody(pdfBody);
            system.debug('Account ' + accList[0].Name);
            for(String contactVar : contactList){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                string body =   '<html lang="ja"><body>'+
                                    'Hello  '+ contactVar.substringAfter(',')  +
                                    '<br><br>'+'Below are links to the firm reported balance exception lists. Click on each link or log into'+
                                    '<br><br>'+'Salesforce accessing the Process Adherence Monitoring Object list views to see a list of'+
                                    '<br><br>'+'accounts for each timeframe bucket.'+
                                     '<br><br>'+'Please review each exception and submit a new record 42 with corrections.'+
                                    '<br><br><a href="' + communityLcPartnerBaseUrl + '/a0s?fcf=' + listViewMap.get('FRB1: 0-3 Days') + '">0-3 Days (Green – New Exception)</a>     '+
                                     +Integer.valueOf(accList[0].Number_of_Exception__c)+
                                    '<br><br><a href="' + communityLcPartnerBaseUrl + '/a0s?fcf=' + listViewMap.get('FRB2: 4-6 Days') + '">4-6 Days (Yellow – Outside Correction Timeframe)</a>     '+
                                     +Integer.valueOf(accList[0].Number_of_exceptions_under_4_6_bucket__c)+
                                    '<br><br><a href="' + communityLcPartnerBaseUrl + '/a0s?fcf=' + listViewMap.get('FRB3: 7-10 Days') + '">7-10 Days (Orange – Approaching Critical Timeframe)</a>     '+
                                     +Integer.valueOf(accList[0].Number_of_exceptions_under_7_10_bucket__c)+
                                    '<br><br><a href="' + communityLcPartnerBaseUrl + '/a0s?fcf=' + listViewMap.get('FRB4: 11-19 Days') + '">11-19 Days (Red – Immediate Correction Required)</a>     '+
                                     +Integer.valueOf(accList[0].Number_of_exceptions_under_11_19_bucket__c)+
                                     '<br><br>'+'For Questions, please select the question button on any active Court Cost Monitoring record and complete the editable fields or email LO-Operational@mcmcg.com with general questions not related to a specific record.'+
                                     '<br><br>'+'Thanks'+
                                    '<br><br>'+'Firm Reported Balance Team';               
                mail.setSubject(accList[0].Firm_ID__c + ' Firm Reported Balance Exceptions');
                mail.sethtmlBody(body); 
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'lo-operational@mcmcg.com'];
                if ( owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                mail.setReplyTo('LO-Operational@mcmcg.com');
                mail.setToAddresses(new List<String>{contactVar.substringBefore(',')});
                //mail.setToAddresses(new List<String>{'neeraj.patni@mcmcg.com'});
                
                mail.setSaveAsActivity(false);
                
                system.debug('Contact Detail: ' + contactVar);
                
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                
                messagingList.add(mail);
            }
            system.debug(Messaging.sendEmail(messagingList));
        }
    }
    
    global void finish(Database.BatchableContext bc){
        List<Case> caseList = [SELECT Status FROM Case WHERE Status = 'New' AND Subject = 'PAM - BI Enterprise Data Integration Load Completed'];
        for(Case caseObj : caseList){
            caseObj.Status = 'Closed';
        }
        update caseList;
    }
    
    private List<String> FetchNotificationUser(Id accountId){
    	
        List<String> tempList = new List<String>();
        Set<String> duplicateEmails = new Set<String>();
        
        for(Contact conVar : [SELECT FirstName, Email FROM Contact WHERE AccountId =: accountId AND Inactive_Contact__c = FALSE AND 
                                (Contact_Type_SME__c INCLUDES ('FRB') OR Contact_Type_SME__c = 'FRB')]){
            
            if(conVar.Email != null && conVar.FirstName != null){

	            duplicateEmails.add(conVar.Email);
	            String tempStr = conVar.Email + ',' + conVar.FirstName;
	            tempList.add(tempStr);
            
            }
            	
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