public class IR_ACF_UnmatchedService {
    public Static OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'acf-looperational@mcmcg.com'];
    //public static final Integer pamUnmatchedLimit = 9999;
    
    public static void processUnmatched(List<Process_Adherence_Monitoring__c> pamList){
        Map<Id,List<Process_Adherence_Monitoring__c>> acctIdByPamList = new Map<Id,List<Process_Adherence_Monitoring__c>>();
        Set<Id> accIds = new Set<Id>();
        List<PAM_Unmatched__c> unmatchedPamList = new List<PAM_Unmatched__c>();
        
        List<Contact> contList = new List<Contact>();
        for(Process_Adherence_Monitoring__c pam : pamList){
            accIds.add(pam.Organization_Name__c);
            
            /***************Map filling of account Id and List of PAM**********************/
            
            List<Process_Adherence_Monitoring__c> temp = new List<Process_Adherence_Monitoring__c>();
            if(acctIdByPamList.get(pam.Organization_Name__c) != null){
                temp = acctIdByPamList.get(pam.Organization_Name__c);
            }
            temp.add(pam);
            acctIdByPamList.put(pam.Organization_Name__c, temp);
            /*****************************************************************************/
            
            /***************To fill the unmatched List*******************************/
            if(pam.PAM_Unmatched__r.size() > 0){
                unmatchedPamList.add(pam.PAM_Unmatched__r[0]);
            }
            /*********************************************************/
        }
        if(accIds.size() > 0){
            contList = fetchContacts(accIds);
        }
        
        if(contList.size() > 0 && acctIdByPamList.keySet().size() > 0 && unmatchedPamList.size() > 0 && pamList.size() > 0){
            sendCreationNotification(contList,acctIdByPamList,unmatchedPamList,pamList);
        }        
    }
    public static void processReminderPam(List<Process_Adherence_Monitoring__c> pamList){
        Set<Id> pamIdSet = new Set<Id>();
        List<Contact> contList = new List<Contact>();
        Map<Id,List<Process_Adherence_Monitoring__c>> accIdToPAMListMap = new Map<Id,List<Process_Adherence_Monitoring__c>>();
        
        Set<Id> accountIdSet = new Set<Id>();
        for(Process_Adherence_Monitoring__c pam : pamList){
            List<Process_Adherence_Monitoring__c> temp = new List<Process_Adherence_Monitoring__c>();
            if(accIdToPAMListMap.get(pam.Organization_Name__c) != null){
                temp = accIdToPAMListMap.get(pam.Organization_Name__c);
            }
            temp.add(pam);
            accIdToPAMListMap.put(pam.Organization_Name__c, temp);
        }
        if(accIdToPAMListMap.keySet().size() > 0){
            contList = fetchContacts(accIdToPAMListMap.keySet()); 
        }
        if(contList.size() > 0 && !accIdToPAMListMap.isEmpty()){
            sendReminderNotification(contList,accIdToPAMListMap);
        }
        
    }
    
    public static void processEscalationPam(List<Process_Adherence_Monitoring__c> pamList, String ProcessName){
        Set<Id> pamIdSet = new Set<Id>();
        List<Contact> contList = new List<Contact>();
        Map<Id,List<Process_Adherence_Monitoring__c>> accIdToPAMListMap = new Map<Id,List<Process_Adherence_Monitoring__c>>();
        
        Set<Id> accountIdSet = new Set<Id>();
        for(Process_Adherence_Monitoring__c pam : pamList){
            List<Process_Adherence_Monitoring__c> temp = new List<Process_Adherence_Monitoring__c>();
            if(accIdToPAMListMap.get(pam.Organization_Name__c) != null){
                temp = accIdToPAMListMap.get(pam.Organization_Name__c);
            }
            temp.add(pam);
            accIdToPAMListMap.put(pam.Organization_Name__c, temp);
        }
        if(accIdToPAMListMap.keySet().size() > 0){
            contList = fetchContacts(accIdToPAMListMap.keySet()); 
        }
        
        if(ProcessName == 'Final Escalation'){
            if(contList.size() > 0 && !accIdToPAMListMap.isEmpty()){
                List<PAM_Unmatched__c> recordsToUpdate = updateUnmatchedForFinalEscalation(pamList);
                if(!recordsToUpdate.isEmpty()){
                    update recordsToUpdate;
                }
                sendFinalEscalation(contList,accIdToPAMListMap);
            }
        }
        
        
        if(ProcessName == 'First Escalation'){
            if(contList.size() > 0 && !accIdToPAMListMap.isEmpty()){
                List<PAM_Unmatched__c> recordsToUpdate = updateUnmatchedForFirstEscalation(pamList);
                if(!recordsToUpdate.isEmpty()){
                    update recordsToUpdate;
                }
                sendFirstEscalation(contList,accIdToPAMListMap);
            }
        }
    }
    private static List<PAM_Unmatched__c> updateUnmatchedForFirstEscalation(List<Process_Adherence_Monitoring__c> pamList){
        //Date reportingDate = System.today();
        String statusNew = 'New';
        
        /*string month = string.valueOf(reportingDate.month());// change month to the previous one
        if(month.length() == 1){
            month = '0'+month;
        }
        string ReportingPeriod = reportingDate.year()+'-'+month;*/
        
        Date todaysDate = System.today().addMonths(-1);
    	String month = String.valueOf(todaysDate.month());
        
        if(month.length() == 1){
        	month = '0' + month; // format month
        }
        String ReportingPeriod = todaysDate.year() +'-'+ month;
        Set<Id> pamIdSet = new Set<Id>();
        for(Process_Adherence_Monitoring__c pam : pamList){
            pamIdSet.add(pam.Id);
        }
        List<PAM_Unmatched__c> umPamStatus = [SELECT Id, Name, PAMUM_Status__c 
                                              FROM PAM_Unmatched__c 
                                              WHERE SCMDUM_Reporting_Period__c = :reportingPeriod 
                                              AND PAMUM_Status__c = :statusNew 
                                              AND PAMUM_Process_Adherence_Monitoring__c IN :pamIdSet];
        
        for(PAM_Unmatched__c pamUm : umPamStatus){
            pamUm.PAMUM_Status__c = 'First Escalation';
        }
        return umPamStatus;
    }
    
    private static List<PAM_Unmatched__c> updateUnmatchedForFinalEscalation(List<Process_Adherence_Monitoring__c> pamList){
        //Date reportingDate = System.today();
        String statusFirst = 'First Escalation';
        
        /*string month = string.valueOf(reportingDate.month());// change month to the previous one
        if(month.length() == 1){
            month = '0'+month;
        }
        string ReportingPeriod = reportingDate.year()+'-'+month;*/
        Date todaysDate = System.today().addMonths(-1);
        String month = String.valueOf(todaysDate.month());
        
        if(month.length() == 1){
            month = '0' + month; // format month
        }
        String ReportingPeriod = todaysDate.year() +'-'+ month;
        
        Set<Id> pamIdSet = new Set<Id>();
        for(Process_Adherence_Monitoring__c pam : pamList){
            pamIdSet.add(pam.Id);
        }
        List<PAM_Unmatched__c> umPamStatus = [SELECT Id, Name, PAMUM_Status__c 
                                              FROM PAM_Unmatched__c 
                                              WHERE SCMDUM_Reporting_Period__c = :reportingPeriod 
                                              AND PAMUM_Status__c = :statusFirst
                                              AND PAMUM_Process_Adherence_Monitoring__c IN :pamIdSet];
        
        for(PAM_Unmatched__c pamUm : umPamStatus){
            pamUm.PAMUM_Status__c = 'Final Escalation';
        }
        return umPamStatus;
    }
    
    /*public static void processNoResponsePam(List<PAM_Unmatched__c> umpamList){
        Set<Id> pamIdSet = new Set<Id>();
        List<Process_Adherence_Monitoring__c> pamLists = new List<Process_Adherence_Monitoring__c>();
        for(PAM_Unmatched__c pamUM : umpamList){
            if(pamUM.PAMUM_Process_Adherence_Monitoring__c != null){
                pamIdSet.add(pamUM.PAMUM_Process_Adherence_Monitoring__c); 
            }
        }
        
        if(pamIdSet.size() > 0){
            pamLists = [SELECT Id, Organization_Name__r.Firm_Id__c, Name,SCMD_Reporting_Period__c, Organization_Name__r.Owner.Email
                        FROM Process_Adherence_Monitoring__c
                        WHERE Id IN: pamIdSet];
        }
       
        if(pamLists.size() > 0){
            sendNoResponse(pamLists);
        }
    }  */   
    /************************************ Creation Notification Email Template *******************************************/
    
    public static void sendCreationNotification(List<Contact> contList, Map<Id,List<Process_Adherence_Monitoring__c>> acctIdByPamList,List<PAM_Unmatched__c> unmatchedPamList,List<Process_Adherence_Monitoring__c> pamLists){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        List<PAM_Unmatched__c> unPamListUpdated = new List<PAM_Unmatched__c>();
        
        
        for(Process_Adherence_Monitoring__c pam : pamLists){
            if(acctIdByPamList.get(pam.Organization_Name__c ) != NULL){
                for(Contact con : contList){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new List<String>{con.email});
                    if(owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail.SetSubject(con.Account.Firm_Id__c + ' ACF Monthly Inventory Reconciliation '+pam.SCMD_Reporting_Period__c);
                    String htmlBody = '<p>Hello '+con.FirstName+',</p>';
                    htmlBody += '<p>ACF identified discrepancies with the identified account(s) that require the Firm&rsquo;s remediation.</p>';
                    htmlBody += '<p>To reconcile our records, access the account information within the "Process Adherence Monitoring" ';
                    htmlBody += 'tab of the LC Partner Access Site or by selecting this link ';
                    htmlBody += '<a href="'+label.LC_Partner_URL+ pam.Id+'">'+pam.Name+'</a></u>, ';
                    htmlBody += 'locate the accounts with discrepancies in the &ldquo;IR &ndash; Unmatched&rdquo; section and follow the ';
                    htmlBody += '<strong><u>required actions</u></strong> below:&nbsp;</p>';
                    htmlBody += '<ul>';
                    htmlBody += '<li>Review the account discrepancy description within the record</li>';
                    htmlBody += '<li>ACF Open/Firm Closed:</li>';
                    htmlBody += '</ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<li>Open with firm</li>';
                    htmlBody += '<li>Timing</li>';
                    htmlBody += '<li>Inactive close code used</li>';
                    htmlBody += '<li>Close code re-sent</li>';
                    htmlBody += '</ul>';
                    htmlBody += '</ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<li>Firm Open/ACF Closed:</li>';
                    htmlBody += '</ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<li>Legal obligation</li>';
                    htmlBody += '<li>Sent reopen request to <a href="mailto:acf-looperational@mcmcg.com">acf-looperational@mcmcg.com</a></li>';
                    htmlBody += '<li>Reopened in error &ndash; now closed</li>';
                    htmlBody += '<li>Closed with Firm</li>';
                    htmlBody += '</ul>';
                    htmlBody += '</ul>';
                    htmlBody += '<p>As a reminder the resolution of all action items needs to be completed by the 10<sup>th</sup> of the month.&nbsp;</p>';
                    htmlBody += '<p>For any questions, contact <a href="mailto:acf-looperational@mcmcg.com">acf-looperational@mcmcg.com</a>.</p>';
                    htmlBody += '<p>&nbsp;</p>';
                    htmlBody += '<p>Thank you,</p>';
                    htmlBody += '<p>ACF Inventory Recon</p>';
                    mail.setHtmlBody(htmlBody);
                    emails.add(mail);
                 }
            }
        }
        if(!test.isRunningTest()){
            Messaging.sendEmail(emails);
        }
        //update check box field
        for(PAM_Unmatched__c unPam : unmatchedPamList){
            unPam.SCMDUM_Record_Creation_Notification_Sent__c = true;
            unPamListUpdated.add(unPam);
        }
        if(unPamListUpdated.size() > 0)
            update unPamListUpdated;
        
        
    }
    /************************************ Reminder Notification Email Template *******************************************/
    
    private static void sendReminderNotification(List<Contact> contList, Map<Id,List<Process_Adherence_Monitoring__c>> accIdToPAMListMap){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Contact con : contList){
            if(accIdToPAMListMap.get(con.AccountId) != NULL){
                for(Process_Adherence_Monitoring__c pam : accIdToPAMListMap.get(con.AccountId)){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new List<String>{con.email});
                    if(owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail.SetSubject(con.Account.Firm_Id__c + ' ACF Monthly Inventory Reconciliation - Reminder Communication '+pam.SCMD_Reporting_Period__c);
                    String htmlBody = '<p>Hello '+con.FirstName+',</p>';
                    htmlBody += '<p>ACF identified discrepancies with the identified account(s) that require the Firm&rsquo;s remediation.</p>';
                    htmlBody += '<p>To reconcile our records, access the account information within the "Process Adherence Monitoring" ';
                    htmlBody += 'tab of the LC Partner Access Site or by selecting this link ';
                    htmlBody += '<a href="'+label.LC_Partner_URL+ pam.Id+'">'+pam.Name+'</a></u>, ';
                    htmlBody += 'locate the accounts with discrepancies in the &ldquo;IR &ndash; Unmatched&rdquo; section and follow the ';
                    htmlBody += '<strong><u>required actions</u></strong> below:&nbsp;</p>';
                    htmlBody += '<ul>';
                    htmlBody += '<li>Review the account discrepancy description within the record</li>';
                    htmlBody += '<li>ACF Open/Firm Closed:</li>';
                    htmlBody += '</ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<li>Open with firm</li>';
                    htmlBody += '<li>Timing</li>';
                    htmlBody += '<li>Inactive close code used</li>';
                    htmlBody += '<li>Close code re-sent</li>';
                    htmlBody += '</ul>';
                    htmlBody += '</ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<li>Firm Open/ACF Closed:</li>';
                    htmlBody += '</ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<li>Legal obligation</li>';
                    htmlBody += '<li>Sent reopen request to <a href="mailto:acf-looperational@mcmcg.com">acf-looperational@mcmcg.com</a></li>';
                    htmlBody += '<li>Reopened in error &ndash; now closed</li>';
                    htmlBody += '<li>Closed with Firm</li>';
                    htmlBody += '</ul>';
                    htmlBody += '</ul>';
                    htmlBody += '<p>As a reminder the resolution of all action items needs to be completed by the 10<sup>th</sup> of the month.&nbsp;</p>';
                    htmlBody += '<p>For any questions, contact <a href="mailto:acf-looperational@mcmcg.com">acf-looperational@mcmcg.com</a>.</p>';
                    htmlBody += '<p>&nbsp;</p>';
                    htmlBody += '<p>Thank you,</p>';
                    htmlBody += '<p>ACF Inventory Recon</p>';
                    mail.setHtmlBody(htmlBody);
                    emails.add(mail);
                }
            }
        }
        
        if(!test.isRunningTest()){
            Messaging.sendEmail(emails);
        }
    }
    /************************************ First Escalation Email Template *******************************************/
    
    private static void sendFirstEscalation(List<Contact> contList, Map<Id,List<Process_Adherence_Monitoring__c>> accIdToPAMListMap){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        List<PAM_Unmatched__c> unPamListUpdated = new List<PAM_Unmatched__c>();
        
        for(Contact con : contList){
            if(accIdToPAMListMap.get(con.AccountId) != NULL){
                for(Process_Adherence_Monitoring__c pam : accIdToPAMListMap.get(con.AccountId)){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new List<String>{con.email});
                    if(owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail.SetSubject(con.Account.Firm_Id__c + ' ACF Monthly Inventory Reconciliation - First Escalation '+pam.SCMD_Reporting_Period__c);
                    String htmlBody = '<p>Hello '+con.FirstName+',</p>';
                    htmlBody += '<p>ACF identified discrepancies with the identified account(s) that require the Firm&rsquo;s remediation.</p>';
                    htmlBody += '<p>To reconcile our records, access the account information within the "Process Adherence Monitoring" ';
                    htmlBody += 'tab of the LC Partner Access Site or by selecting this link ';
                    htmlBody += '<a href="'+label.LC_Partner_URL+ pam.Id+'">'+pam.Name+'</a></u>, ';
                    htmlBody += 'locate the accounts with discrepancies in the &ldquo;IR &ndash; Unmatched&rdquo; section and follow the ';
                    htmlBody += '<strong><u>required actions</u></strong> below:&nbsp;</p>';
                    htmlBody += '<ul>';
                    htmlBody += '<li>Review the account discrepancy description within the record</li>';
                    htmlBody += '<li>ACF Open/Firm Closed:</li>';
                    htmlBody += '</ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<li>Open with firm</li>';
                    htmlBody += '<li>Timing</li>';
                    htmlBody += '<li>Inactive close code used</li>';
                    htmlBody += '<li>Close code re-sent</li>';
                    htmlBody += '</ul>';
                    htmlBody += '</ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<li>Firm Open/ACF Closed:</li>';
                    htmlBody += '</ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<li>Legal obligation</li>';
                    htmlBody += '<li>Sent reopen request to <a href="mailto:acf-looperational@mcmcg.com">acf-looperational@mcmcg.com</a></li>';
                    htmlBody += '<li>Reopened in error &ndash; now closed</li>';
                    htmlBody += '<li>Closed with Firm</li>';
                    htmlBody += '</ul>';
                    htmlBody += '</ul>';
                    htmlBody += '<p>Resolution of action items is now <b>past due</b>.</p>';
                    htmlBody += '<p>For any questions, contact <a href="mailto:acf-looperational@mcmcg.com">acf-looperational@mcmcg.com</a>.</p>';
                    htmlBody += '<p>&nbsp;</p>';
                    htmlBody += '<p>Thank you,</p>';
                    htmlBody += '<p>ACF Inventory Recon</p>';
                    mail.setHtmlBody(htmlBody);
                    emails.add(mail);
                }
            }
        }
        if(!test.isRunningTest()){
            Messaging.sendEmail(emails);
        }  
    }
    /************************************ Final Escalation Email Template *******************************************/
    
    private static void sendFinalEscalation(List<Contact> contList, Map<Id,List<Process_Adherence_Monitoring__c>> accIdToPAMListMap){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        List<PAM_Unmatched__c> unPamListUpdated = new List<PAM_Unmatched__c>();
        
        for(Contact con : contList){
            if(accIdToPAMListMap.get(con.AccountId) != NULL){
                for(Process_Adherence_Monitoring__c pam : accIdToPAMListMap.get(con.AccountId)){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new List<String>{con.email});
                    if(owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail.SetSubject(con.Account.Firm_Id__c + ' ACF Monthly Inventory Reconciliation - Final Escalation '+pam.SCMD_Reporting_Period__c);
                    String htmlBody = '<p>Hello '+con.FirstName+',</p>';
                    htmlBody += '<p>ACF identified discrepancies with the identified account(s) that require the Firm&rsquo;s remediation.</p>';
                    htmlBody += '<p>To reconcile our records, access the account information within the "Process Adherence Monitoring" ';
                    htmlBody += 'tab of the LC Partner Access Site or by selecting this link ';
                    htmlBody += '<a href="'+label.LC_Partner_URL+ pam.Id+'">'+pam.Name+'</a></u>, ';
                    htmlBody += 'locate the accounts with discrepancies in the &ldquo;IR &ndash; Unmatched&rdquo; section and follow the ';
                    htmlBody += '<strong><u>required actions</u></strong> below:&nbsp;</p>';
                    htmlBody += '<ul>';
                    htmlBody += '<li>Review the account discrepancy description within the record</li>';
                    htmlBody += '<li>ACF Open/Firm Closed:</li>';
                    htmlBody += '</ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<li>Open with firm</li>';
                    htmlBody += '<li>Timing</li>';
                    htmlBody += '<li>Inactive close code used</li>';
                    htmlBody += '<li>Close code re-sent</li>';
                    htmlBody += '</ul>';
                    htmlBody += '</ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<li>Firm Open/ACF Closed:</li>';
                    htmlBody += '</ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<ul>';
                    htmlBody += '<li>Legal obligation</li>';
                    htmlBody += '<li>Sent reopen request to <a href="mailto:acf-looperational@mcmcg.com">acf-looperational@mcmcg.com</a></li>';
                    htmlBody += '<li>Reopened in error &ndash; now closed</li>';
                    htmlBody += '<li>Closed with Firm</li>';
                    htmlBody += '</ul>';
                    htmlBody += '</ul>';
                    htmlBody += '<p>Resolution of action items is now <b>past due</b>.</p>';
                    htmlBody += '<p>For any questions, contact <a href="mailto:acf-looperational@mcmcg.com">acf-looperational@mcmcg.com</a>.</p>';
                    htmlBody += '<p>&nbsp;</p>';
                    htmlBody += '<p>Thank you,</p>';
                    htmlBody += '<p>ACF Inventory Recon</p>';
                    mail.setHtmlBody(htmlBody);
                    emails.add(mail);
                    System.debug('mail sent');
                }
            }
        }
        if(!test.isRunningTest()){
            Messaging.sendEmail(emails);
        }
    }
    /************************************ No Response Email Template *******************************************/
    public static void sendNoResponse(List<Process_Adherence_Monitoring__c> pamLists){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Process_Adherence_Monitoring__c pam : pamLists){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            mail.setToAddresses(new List<String>{pam.Organization_Name__r.Owner.Email,'Acf-looperational@mcmcg.com'}); // Acf-looperational@mcmcg.com
            mail.Setsubject(pam.Organization_Name__r.Firm_ID__c+ ' ACF Monthly Inventory Reconciliation '+pam.SCMD_Reporting_Period__c);//' – No Response From Firm '
            String htmlBody = '<p>Hello,</p>';
            htmlBody += '<p>Be advised that your firm has not reconciled the discrepancies identified in the monthly ';
            htmlBody += 'inventory reconciliation.&nbsp; At this time, a Vendor Specialist will be setting up a meeting with ';
            htmlBody += 'you and the Firm for further discussion and resolution.</p>';
            htmlBody += '<p>&nbsp;</p>';
            htmlBody += '<p>Thank you,</p>';
            htmlBody += '<p>ACF Inventory Recon</p>';
            mail.setHtmlBody(htmlBody);
            emails.add(mail);
        }
        if(!test.isRunningTest()){
            Messaging.sendEmail(emails);
        }
    }
    private static List<contact> fetchContacts(Set<Id> acctIdByPamList){
        return [SELECT Id,FirstName,Email,AccountId,Contact_Type_SME__c,Account.Firm_Id__c,Community_User__c 
                FROM Contact 
                WHERE AccountId IN :acctIdByPamList
                AND Contact_Type_SME__c INCLUDES ('Inventory Reconciliation')
                AND Inactive_Contact__c = false];
    }
}