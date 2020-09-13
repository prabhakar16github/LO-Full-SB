public class DM_SCMDisputeService {
    public static Date todays_Date = System.today();
    public Static OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'LO-Operational@mcmcg.com'];
    //public static final String ATTORNEY_MAIL = 'AttorneyOutsourcing@mcmcg.com';
    
    // Create DM SCM records on 1st  of every month
    public static void createMonthlyDMSCMD(List<Account> accountList){
        Set<Id> contactIdSet = new Set<Id>();
        Map<Id,Account> accountByAccountId = new Map<Id,Account>();
        
        for(Account acc : accountList){
            for(Contact con : acc.Contacts){
                contactIdSet.add(con.Id);
            }
            accountByAccountId.put(acc.Id, acc);
        }
        
        //System.debug('>>>>>contactIdSet>>>>>'+contactIdSet);
        List<User> userList = [SELECT Id, Name, ContactId, isActive FROM User 
                               WHERE((Name = 'System Administrator'
                                      AND Profile.Name = 'System Administrator') 
                                     OR ContactId IN: contactIdSet)
                               AND isActive = true];
        //system.debug('userList >> '+userList);
        
        User adminUser = new User();
        Map<Id,Id> contactIdByUserId = new Map<Id,Id>();
        
        if(userList.size() > 0){
            for(User usr : userList){
                if(usr.Name == 'System Administrator'){
                    adminUser = usr;
                }
                else if(usr.ContactId != NULL && usr.IsActive == True){
                    contactIdByUserId.put(usr.ContactId, usr.Id);
                    //System.debug('contactIdByUserId >> '+contactIdByUserId);
                } 
            } 
        }
        List<Process_Adherence_Monitoring__c> pamList = new List<Process_Adherence_Monitoring__c>();
        for(Account acc : accountList){
            Date currentDate = system.today();
            string currentMonth = String.valueOf(currentDate.month());
            if(currentMonth.length() == 1){
                currentMonth = '0'+currentMonth;
            }
            Process_Adherence_Monitoring__c pam = new Process_Adherence_Monitoring__c();
            pam.Status__c = 'New';
            pam.RecordTypeId  = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM SCM Dispute').getRecordTypeId();
            pam.SCMD_Reporting_Period__c = currentDate.year()+'-'+currentMonth;
            pam.OwnerId = AssignOwner(adminUser,acc,contactIdByUserId);
            pam.Organization_Name__c = acc.Id;
            pamList.add(pam);
        }
        if(pamList.size() > 0){
            insert pamList;
           // System.debug('pamList[0].OwnerId '+pamList[0].OwnerId);
            Set<Id> pamIdSet = new Set<Id>();
            for(Process_Adherence_Monitoring__c pam : pamList){
                pamIdSet.add(pam.Id);
            }
            if(!pamIdSet.isEmpty()){
                sendRecordCreationNotification(pamIdSet,accountByAccountId);
            }
        }
    }  
   private static Id AssignOwner(User adminUser,Account acc,Map<Id,Id> contactIdByUserId){
        Id assignOwnerId;
        for(Contact con : acc.Contacts){
            if(assignOwnerId == NULL
               && con.Contact_Type_SME__c != NULL
               && string.valueOf(con.Contact_Type_SME__c).containsIgnoreCase('Process Adherence Monitoring (PAM)')
               && contactIdByUserId.containsKey(con.Id)){
                   
                   assignOwnerId =  contactIdByUserId.get(con.Id);
                   break;
               }
            
        }
       if(assignOwnerId == null){
            
            for(Contact cont : acc.Contacts){
                if(assignOwnerId == null 
                   && cont.Community_User__c 
                   && contactIdByUserId.containsKey(cont.Id)){
                       
                       assignOwnerId = contactIdByUserId.get(cont.Id);
                       break;
                   }
            }
        }
        if(assignOwnerId == null){
            assignOwnerId = adminUser.Id;
        }
       // System.debug('assignOwnerId >> '+assignOwnerId);
        return assignOwnerId;
    }
    /****************************** creation notification **************************/
    public static void sendRecordCreationNotification(Set<Id> pamIdSet,Map<Id,Account> accountByAccountId){
        List<Process_Adherence_Monitoring__c> pamList = [SELECT Id,Name,Organization_Name__c,SCMD_Reporting_Period__c, OwnerId,Owner.Name 
                                                         FROM Process_Adherence_Monitoring__c WHERE Id IN: pamIdSet];
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Process_Adherence_Monitoring__c pam : pamList){
            if(accountByAccountId.get(pam.Organization_Name__c) != NULL){
                for(Contact con : accountByAccountId.get(pam.Organization_Name__c).Contacts){
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    String subjectLine = accountByAccountId.get(pam.Organization_Name__c).Firm_Id__c+' Monthly SCM vX ';
                    subjectLine += pam.SCMD_Reporting_Period__c;
                    email.setSubject(subjectLine);
                    
                    if(owea.size() > 0 ) {
                        email.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    email.setToAddresses(new List<String>{con.Email});
                    
                    //If Pam owner is administrator then send it to ‘AttorneyOutsourcing@mcmcg.com’.
                   /* if(pam.Owner.Name ==  'System Administrator' ){
                        //String[] toAddresses = new String[] {ATTORNEY_MAIL};
                        String[] toAddresses = new String[] {'shailja.singhtomar@mcmcg.com'};
                            }*/
                    
                    String emailMessageBody = ''; 
                    
                    emailMessageBody = '<p>Hello '+con.FirstName+ ',</p>'
                        
                        + '<p> MCM monitors status codes communicated by Firms to ensure accounts are handled in accordance with the MCM Firm Manual. '
                        + 'Firms must adhere to the process outlined below to enable MCM to reconcile information received from Firms against its records.  '
                        + '<p><b> Required Action</b></p>'
                        + '<p>1. Select the link to access the Status Code Monitoring (SCM) record within the LC Partner Access Site: '
                        +  '<a href="'+label.LC_Partner_URL+pam.Id+'">'+pam.Name+'</a> </p>'
                        + '<p>2. Prioritize and submit account numbers for ALL open and closed accounts on which the Firm sent the dispute status codes identified below within the previous month (e.g., January 1 – January 31) </p>'
                        + '<ul>'
                        + '<li>Oral Dispute&nbsp;</li>'
                        + '<li>Written Dispute&nbsp;</li>'
                        + '<li>Mail Out Validation of Debt&nbsp;</li>'	
                        + '</ul>'
                        +  '<p>3. Submit account numbers for ALL open and closed accounts on which the Firm sent the remaining 15 status codes within the previous month (e.g., January 1 – January 31) </p>'
                        
                        +'<p>The Firm must respond by providing the required information within '
                        +'<strong><span style="text-decoration: underline;">three (3) business days.</span></strong></p>'
                        +'<p>For any questions, contact <a href="mailto:LO-Operational@mcmcg.com">LO-Operational@mcmcg.com</a>.</p>'
                        +'<p>Thank you,</p>'
                        +'<p>LO-Operational</p>';	
                    email.setHtmlBody(emailMessageBody);
                    emails.add(email);
                }
            }
        }
        Messaging.sendEmail(emails);
    }
    
    /*********************** send notifications for 3-10th day of every month ************************/
    public static void sendEmailNotification(Map<Id, List<Process_Adherence_Monitoring__c>> accountIdByPamList, String ProcessName){
        List<Contact> contactList = new List<Contact>();
        if(ProcessName == 'First Escalation' || ProcessName == 'Second Escalation' || ProcessName == 'Final Escalation'){
            if(accountIdByPamList.keySet().size() > 0){
                contactList = fetchContacts(accountIdByPamList.keySet()); 
            }
        }
        if(ProcessName == 'First Escalation'){
            if(contactList.size() > 0 && !accountIdByPamList.isEmpty()){
                sendFirstEscalation(contactList,accountIdByPamList);
            }
        }
        if(ProcessName == 'Second Escalation'){
            if(contactList.size() > 0 && !accountIdByPamList.isEmpty()){
                sendSecondEscalation(contactList,accountIdByPamList);
            }
        }
        if(ProcessName == 'Final Escalation'){
            if(contactList.size() > 0 && !accountIdByPamList.isEmpty()){
                sendFinalEscalation(contactList,accountIdByPamList);
            }
        }
    }
    
    /*************** Send First Escalation Notification *************************/
    public static void sendFirstEscalation(List<contact> contactList,Map<Id, List<Process_Adherence_Monitoring__c>> accountIdByPamList){
        List<Messaging.SingleEmailMessage> email = new List<Messaging.SingleEmailMessage>();
        for(Contact con : contactList){
            for(Process_Adherence_Monitoring__c pam : accountIdByPamList.get(con.AccountId)){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String subjectLine = pam.Organization_Name__r.Firm_Id__c+' Monthly SCM vX ';
                subjectLine += pam.SCMD_Reporting_Period__c +'- First Escalation';
                mail.setSubject(subjectLine);
                
                if(owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                mail.setToAddresses(new List<String>{con.Email});
                String emailMessageBody = ''; 
                
                emailMessageBody = '<p>Hello '+con.FirstName+',</p>'
                    +'<p>As a reminder, the information requested below is due <strong><u>today.</u></strong></p>'
                    +'<hr>'
                    + '<p> MCM monitors status codes communicated by Firms to ensure accounts are handled in accordance with the MCM Firm Manual. '
                    + 'Firms must adhere to the process outlined below to enable MCM to reconcile information received from Firms against its records.  '
                    + '<p><b> Required Action</b></p>'
                    + '<p>1. Select the link to access the Status Code Monitoring (SCM) record within the LC Partner Access Site: '
                    +  '<a href="'+label.LC_Partner_URL+pam.Id+'">'+pam.Name+'</a> </p>'
                    + '<p>2. Prioritize and submit account numbers for ALL open and closed accounts on which the Firm sent the dispute status codes identified below within the previous month (e.g., January 1 – January 31) </p>'
                    + '<ul>'
                    + '<li>Oral Dispute&nbsp;</li>'
                    + '<li>Written Dispute&nbsp;</li>'
                    + '<li>Mail Out Validation of Debt&nbsp;</li>'	
                    + '</ul>'
                    +  '<p>3. Submit account numbers for ALL open and closed accounts on which the Firm sent the remaining 15 status codes within the previous month (e.g., January 1 – January 31) </p>'
                    + '<p>The Firm must respond by providing the required information by end of business today.</p>'
                    +'<p>For any questions, contact <a href="mailto:LO-Operational@mcmcg.com">LO-Operational@mcmcg.com</a>.</p>'
                    +'<p>Thank you,</p>'						
                    +'<p>LO-Operational</p>';
                mail.setHtmlBody(emailMessageBody);
                email.add(mail);
            }
        }
        Messaging.sendEmail(email);
    }
    /*********************** Send Second Escalation Notification **********************/
    public static void sendSecondEscalation(List<contact> contactList,Map<Id, List<Process_Adherence_Monitoring__c>> accountIdByPamList){
        List<Messaging.SingleEmailMessage> email = new List<Messaging.SingleEmailMessage>();
        for(Contact con : contactList){
            for(Process_Adherence_Monitoring__c pam : accountIdByPamList.get(con.AccountId)){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String subjectLine = pam.Organization_Name__r.Firm_Id__c+' Monthly SCM vX ';
                subjectLine += pam.SCMD_Reporting_Period__c +'- Second Escalation';
                mail.setSubject(subjectLine);
                
                if(owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                mail.setToAddresses(new List<String>{con.Email});
                String emailMessageBody = ''; 
                
                emailMessageBody = '<p>Hello '+con.FirstName+',</p>'
                    +'<p>Be advised that the Firm\'s\' response to the request below is now <b>past due</b>. This is time sensitive. Please provide your response <b><u>today</u></b>. </p>'
                    +'<hr>'
                    + '<p> MCM monitors status codes communicated by Firms to ensure accounts are handled in accordance with the MCM Firm Manual. '
                    + 'Firms must adhere to the process outlined below to enable MCM to reconcile information received from Firms against its records.  '
                    + '<p><b> Required Action</b></p>'
                    + '<p>1. Select the link to access the Status Code Monitoring (SCM) record within the LC Partner Access Site: '
                    +  '<a href="'+label.LC_Partner_URL+pam.Id+'">'+pam.Name+'</a> </p>'
                    + '<p>2. Prioritize and submit account numbers for ALL open and closed accounts on which the Firm sent the dispute status codes identified below within the previous month (e.g., January 1 – January 31) </p>'
                    + '<ul>'
                    + '<li>Oral Dispute&nbsp;</li>'
                    + '<li>Written Dispute&nbsp;</li>'
                    + '<li>Mail Out Validation of Debt&nbsp;</li>'	
                    + '</ul>'
                    +  '<p>3. Submit account numbers for ALL open and closed accounts on which the Firm sent the remaining 15 status codes within the previous month (e.g., January 1 – January 31) </p>'
                    + '<p>The Firm must respond by providing the required information by end of business today.</p>'
                    +'<p>For any questions, contact <a href="mailto:LO-Operational@mcmcg.com">LO-Operational@mcmcg.com</a>.</p>'
                    +'<p>Thank you,</p>'						
                    +'<p>LO-Operational</p>';
                mail.setHtmlBody(emailMessageBody);
                email.add(mail);
            }
        }
        Messaging.sendEmail(email);
    }
    /********************** Send Final Escalation Notification ********************/
    public static void sendFinalEscalation(List<contact> contactList,Map<Id, List<Process_Adherence_Monitoring__c>> accountIdByPamList){
        List<Messaging.SingleEmailMessage> email = new List<Messaging.SingleEmailMessage>();
        for(Contact con : contactList){
            for(Process_Adherence_Monitoring__c pam : accountIdByPamList.get(con.AccountId)){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String subjectLine = pam.Organization_Name__r.Firm_Id__c+' Monthly SCM vX ';
                subjectLine += pam.SCMD_Reporting_Period__c +'- Final Escalation';
                mail.setSubject(subjectLine);
                
                if(owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                mail.setToAddresses(new List<String>{con.Email});
                String emailMessageBody = ''; 
                
                emailMessageBody = '<p>Hello '+con.FirstName+',</p>'
                    +'<p>Be advised that MCM has not received the Firm\'s\' response to request below. This is time sensitive; therefore, it is critical that we receive the response <b><u>today</u></b>. Failure to provide responses may result in further escalation. </p>'
                    +'<hr>'
                    + '<p> MCM monitors status codes communicated by Firms to ensure accounts are handled in accordance with the MCM Firm Manual. '
                    + 'Firms must adhere to the process outlined below to enable MCM to reconcile information received from Firms against its records.  '
                    + '<p><b> Required Action</b></p>'
                    + '<p>1. Select the link to access the Status Code Monitoring (SCM) record within the LC Partner Access Site: '
                    +  '<a href="'+label.LC_Partner_URL+pam.Id+'">'+pam.Name+'</a> </p>'
                    + '<p>2. Prioritize and submit account numbers for ALL open and closed accounts on which the Firm sent the dispute status codes identified below within the previous month (e.g., January 1 – January 31) </p>'
                    + '<ul>'
                    + '<li>Oral Dispute&nbsp;</li>'
                    + '<li>Written Dispute&nbsp;</li>'
                    + '<li>Mail Out Validation of Debt&nbsp;</li>'	
                    + '</ul>'
                    +  '<p>3. Submit account numbers for ALL open and closed accounts on which the Firm sent the remaining 15 status codes within the previous month (e.g., January 1 – January 31) </p>'
                    + '<p>The Firm must respond by providing the required information by end of business today.</p>'
                    +'<p>For any questions, contact <a href="mailto:LO-Operational@mcmcg.com">LO-Operational@mcmcg.com</a>.</p>'
                    +'<p>Thank you,</p>'						
                    +'<p>LO-Operational</p>';
                mail.setHtmlBody(emailMessageBody);
                email.add(mail);
            }
        }
        Messaging.sendEmail(email);
    }
    /************************ No Response *****************************/
    public static void sendNoResponseEmailNotification(List<Process_Adherence_Monitoring__c> pamList){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Process_Adherence_Monitoring__c pam : pamList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            mail.setToAddresses(new List<String>{pam.Organization_Name__r.Owner.Email,'LO-Operational@mcmcg.com'});// LO-Operational@mcmcg.com and org's owner
                
            String subjectLine = pam.Organization_Name__r.Firm_Id__c+' Monthly SCM vX ';
            subjectLine += pam.SCMD_Reporting_Period__c +'- No Response From Firm';
            mail.setSubject(subjectLine); 
            
            String emailMessageBody = '';
            emailMessageBody = '<p>Hello,</p>'
                +'<p>Be advised that the Firm identified above has not provided the required monthly status code '
                +'information after <strong><u>nine (9)</u></strong> notifications.&nbsp; To remediate, the '
                +'Vendor Specialist team is scheduling a call with the Firm and Firm Manager to discuss and resolve. '
                +'<p>&nbsp;</p>'
                +'<p>Thank you,</p>'
                +'<p>LO-Operational&nbsp;</p>';
            mail.setHtmlBody(emailMessageBody);
            emails.add(mail);
        }
        if(!test.isRunningTest())
            Messaging.sendEmail(emails);
    }
    
    /**************************** Fetch Contacts *****************************/
    private static List<Contact> fetchContacts(Set<Id> accountIdSet){
        return [SELECT Id, FirstName, Email, AccountId, Contact_Type_SME__c, Account.Firm_Id__c, Community_User__c 
                FROM Contact 
                WHERE AccountId IN :accountIdSet
                AND (Community_User__c = true 
                     OR Contact_Type_SME__c INCLUDES ('Process Adherence Monitoring (PAM)'))
                AND Inactive_Contact__c = false];
    }
}