public class IR_DM_UnmatchedService {
    public static OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'LO-InventoryRecon@mcmcg.com']; 
    public static Date today_date = System.today();
    public static string TenthDate = Date.newInstance(today_date.year(), today_date.month(), 10).format();
    
    
    public static void creationNotification(List<Process_Adherence_Monitoring__c> pamList){
        List<Contact> contactList = new List<Contact>();
        List<PAM_Unmatched__c> umPamList = new List<PAM_Unmatched__c>();
        Set<Id> acctIdSet = new Set<Id>();
        Map<Id,List<Process_Adherence_Monitoring__c>> acctIdByPamList = new Map<Id,List<Process_Adherence_Monitoring__c>>();
        
        
        for(Process_Adherence_Monitoring__c pam : pamList){
            acctIdSet.add(pam.Organization_Name__c);
            List<Process_Adherence_Monitoring__c> tempList = new List<Process_Adherence_Monitoring__c>();
            if(acctIdByPamList.get(pam.Organization_Name__c) != null){
                tempList = acctIdByPamList.get(pam.Organization_Name__c);
            }
            tempList.add(pam);
            acctIdByPamList.put(pam.Organization_Name__c, tempList);
            
            if(pam.PAM_Unmatched__r.size() > 0){
                umPamList.add(pam.PAM_Unmatched__r[0]);
            }
        }  
        if(acctIdSet.size() > 0){
            contactList = fetchContacts(acctIdSet);  
        }
        if(contactList.size() > 0 && acctIdByPamList.size() > 0 && umPamList.size() > 0 && pamList.size() > 0){
            sendCreationNotification(contactList,acctIdByPamList,umPamList,pamList);
        }
    }
    
    /*********************** Reminder Notification ***************************/
    public static void reminderNotification(List<Process_Adherence_Monitoring__c> pamList){
        List<Contact> conList = new List<Contact>();
        Map<Id,List<Process_Adherence_Monitoring__c>> acctIdByPamList = new Map<Id,List<Process_Adherence_Monitoring__c>>();
        
        for(Process_Adherence_Monitoring__c pam : pamList){
            List<Process_Adherence_Monitoring__c> temp = new List<Process_Adherence_Monitoring__c>();
            if(acctIdByPamList.get(pam.Organization_Name__c) != null){
                temp = acctIdByPamList.get(pam.Organization_Name__c);
            }
            temp.add(pam);
            acctIdByPamList.put(pam.Organization_Name__c, temp);
        }
        if(acctIdByPamList.keySet().size() > 0){
            conList = fetchContacts(acctIdByPamList.keySet());
        }
        if(conList.size() > 0 && !acctIdByPamList.isEmpty()){
            sendReminderNotification(conList,acctIdByPamList);
        }
    }
    /************************ PAM Escalation ******************************/
    public static void processEscalationDM(List<Process_Adherence_Monitoring__c> pamList, string processName){
        List<Contact> conList = new List<Contact>();
        Map<Id,List<Process_Adherence_Monitoring__c>> acctIdByPamList = new Map<Id,List<Process_Adherence_Monitoring__c>>();
        
        for(Process_Adherence_Monitoring__c pam : pamList){
            List<Process_Adherence_Monitoring__c> temp = new List<Process_Adherence_Monitoring__c>();
            if(acctIdByPamList.get(pam.Organization_Name__c) != null){
                temp = acctIdByPamList.get(pam.Organization_Name__c);
            }
            temp.add(pam);
            acctIdByPamList.put(pam.Organization_Name__c, temp);
        }
        if(acctIdByPamList.keySet().size() > 0){
            conList = fetchContacts(acctIdByPamList.keySet());
        }
        
        if(processName == 'First Escalation'){
            if(conList.size() > 0 && !acctIdByPamList.isEmpty()){
               List<PAM_Unmatched__c> umFirstEscPAM = updateUMPAMForFirstEsc(pamList);
                if(umFirstEscPAM.size() > 0){
                    update umFirstEscPAM;
                }
                sendFirstNotification(conList,acctIdByPamList);
            }  
        }
        if(processName == 'Final Escalation'){
          if(conList.size() > 0 && !acctIdByPamList.isEmpty()){
               List<PAM_Unmatched__c> umFinalEscPAM = updateUMPAMForFinalEsc(pamList);
                if(umFinalEscPAM.size() > 0){
                    update umFinalEscPAM;
                }
                sendFinalNotification(conList,acctIdByPamList);
            }  
        }
        
    }
    /************ Initial Notification ****************/
    public static void sendCreationNotification(List<Contact> contactList,Map<Id,List<Process_Adherence_Monitoring__c>> acctIdByPamList,List<PAM_Unmatched__c> umPamList,List<Process_Adherence_Monitoring__c> pamList){
        List<Messaging.SingleEmailMessage> email = new List<Messaging.SingleEmailMessage>();
        List<PAM_Unmatched__c> unPamListUpdated = new List<PAM_Unmatched__c>();
        
        for(Process_Adherence_Monitoring__c pam : pamList){
            if(acctIdByPamList.get(pam.Organization_Name__c) != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                for(Contact con : contactList){
                    if(owea.size() > 0){
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail.setToAddresses(new List<String> {con.Email});  
                    mail.setSubject(con.Account.Firm_Id__c+' Monthly Inventory Reconciliation – vX – Remediation '+pam.SCMD_Reporting_Period__c);
                    
                    string htmlBody = '<p>Dear '+con.FirstName+',</p>';
                    htmlBody += '<p>MCM identified potential discrepancies with the placement information submitted by the Firm.';
                    htmlBody +=' To remediate, the Firm must adhere to the process outlined below to enable MCM to reconcile the information against its records.</p>';
                    htmlBody += '<p><b> Required Action </b></p>';
                    htmlBody += '<p>1. Select the link to access the Inventory Reconciliation (IR) record within the LC Partner Access Site: ';
                    htmlBody += '<a href='+label.LC_Partner_URL+pam.Id+'>'+pam.Name+'</a><br/>';
                    htmlBody += '<p>2. Locate the accounts with discrepancies in the “IR – Unmatched” section</p>';
                    htmlBody += '<p>3. Review the account discrepancy description within each record: &nbsp;</p>';
                    htmlBody += '<ol type="a"> <li>	MCM Open/Firm Closed: </li>';
                    htmlBody += '<ul style="list-style-type:disc;"><li>Currently Open with Firm</li>';
                    htmlBody += '<li>Currently Open with Firm</li>';
                    htmlBody += '<li>Inactive close code used</li>';
                    htmlBody += '<li>Close code re-sent</li></ul>';
                    
                    htmlBody += '<li>Firm Open/MCM Closed: </li>';
                    htmlBody += '<ul style="list-style-type:disc;"><li>Timing – Account closed same day as cut off</li>';
                    htmlBody += '<li>Legal obligation</li>';
                    htmlBody += '<li>Reopen Request Sent</li>';
                    htmlBody += '<li>Account is currently Closed</li></ul></ol>';
                    htmlBody += '<p>4. Select the description of the variation from the drop-down list in the "Discrepancy Detail" section.</p>';
                    
                    htmlBody += '<p><b>The Firm must respond by providing the required information by '+TenthDate+'</b>. For any questions, contact ';
                    htmlBody += '<p> <a href="mailto:LO-InventoryRecon@mcmcg.com">aLO-InventoryRecon@mcmcg.com</a>.</p>';
                    htmlBody += '<p>&nbsp;</p>';
                    htmlBody += '<p>Thank you,</p>';
                    htmlBody += '<p>Inventory Reconciliation Specialist</p>';
                    mail.setHtmlBody(htmlBody);
                    email.add(mail);
                }
            }
        }
        if(!test.isRunningTest()){
            Messaging.sendEmail(email);
        }
        //update check box field
        for(PAM_Unmatched__c unPam : umPamList){
            unPam.SCMDUM_Record_Creation_Notification_Sent__c = true;
            unPamListUpdated.add(unPam);
        }
        if(unPamListUpdated.size() > 0)
            update unPamListUpdated;
    } 
    /*********************** Send Reminder Notification **************************/
    public static void sendReminderNotification(List<Contact> conList, Map<Id,List<Process_Adherence_Monitoring__c>> acctIdByPamList){
        List<Messaging.SingleEmailMessage> email = new List<Messaging.SingleEmailMessage>();
        
        for(Contact con : conList){
            if(acctIdByPamList.get(con.AccountId) != null){
                for(Process_Adherence_Monitoring__c pam : acctIdByPamList.get(con.AccountId)){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    if(owea.size() > 0){
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail.setToAddresses(new List<String> {con.Email});  
                    mail.setSubject(con.Account.Firm_Id__c+' Monthly Inventory Reconciliation – vX – Remediation Reminder '+pam.SCMD_Reporting_Period__c);
                    
                    string htmlBody = '<p>Dear '+con.FirstName+',</p>';
                    htmlBody += '<p>MCM has not received the information requested below. The Firm must respond by providing the required information by '+TenthDate+'.</p>';
                    htmlBody += '</hr>';
                    htmlBody += '<p>MCM identified potential discrepancies with the placement information submitted by the Firm.';
                    htmlBody +=' To remediate, the Firm must adhere to the process outlined below to enable MCM to reconcile the information against its records.</p>';
                    htmlBody += '<p><b> Required Action </b></p>';
                    htmlBody += '<p>1. Select the link to access the Inventory Reconciliation (IR) record within the LC Partner Access Site: ';
                    htmlBody += '<a href='+label.LC_Partner_URL+pam.Id+'>'+pam.Name+'</a><br/>';
                    htmlBody += '<p>2. Locate the accounts with discrepancies in the “IR – Unmatched” section</p>';
                    htmlBody += '<p>3. Review the account discrepancy description within each record: &nbsp;</p>';
                    htmlBody += '<ol type="a"> <li>	MCM Open/Firm Closed: </li>';
                    htmlBody += '<ul style="list-style-type:disc;"><li>Currently Open with Firm</li>';
                    htmlBody += '<li>Currently Open with Firm</li>';
                    htmlBody += '<li>Inactive close code used</li>';
                    htmlBody += '<li>Close code re-sent</li></ul>';
                    
                    htmlBody += '<li>Firm Open/MCM Closed: </li>';
                    htmlBody += '<ul style="list-style-type:disc;"><li>Timing – Account closed same day as cut off</li>';
                    htmlBody += '<li>Legal obligation</li>';
                    htmlBody += '<li>Reopen Request Sent</li>';
                    htmlBody += '<li>Account is currently Closed</li></ul></ol>';
                    htmlBody += '<p>4. Select the description of the variation from the drop-down list in the "Discrepancy Detail" section.</p>';
                    
                    htmlBody += '<p><b>The Firm must respond by providing the required information by '+TenthDate+'</b>. For any questions, contact ';
                    htmlBody += '<p> <a href="mailto:LO-InventoryRecon@mcmcg.com">aLO-InventoryRecon@mcmcg.com</a>.</p>';
                    htmlBody += '<p>&nbsp;</p>';
                    htmlBody += '<p>Thank you,</p>';
                    htmlBody += '<p>Inventory Reconciliation Specialist</p>';
                    mail.setHtmlBody(htmlBody);
                    email.add(mail);
                }
            }
        }
        if(!test.isRunningTest()){
            Messaging.sendEmail(email);
        }
    }
    /*********************** Send First Escalation **************************/
    public static void sendFirstNotification(List<Contact> conList, Map<Id,List<Process_Adherence_Monitoring__c>> acctIdByPamList){
        List<Messaging.SingleEmailMessage> email = new List<Messaging.SingleEmailMessage>();
        
        for(Contact con : conList){
            if(acctIdByPamList.get(con.AccountId) != null){
                for(Process_Adherence_Monitoring__c pam : acctIdByPamList.get(con.AccountId)){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    if(owea.size() > 0){
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail.setToAddresses(new List<String> {con.Email});  
                    mail.setSubject(con.Account.Firm_Id__c+' Monthly Inventory Reconciliation – vX – Remediation First Escalation '+pam.SCMD_Reporting_Period__c);
                    
                    string htmlBody = '<p>Dear '+con.FirstName+',</p>';
                    htmlBody += '<p>MCM has not received the information requested below. Be advised that the Firm\'s response is now <b><u>past due</u></b>. This is time sensitive. Please provide your response <b><u>today</u></b>.</p>';
                    htmlBody += '</hr>';
                    htmlBody += '<p>MCM identified potential discrepancies with the placement information submitted by the Firm.';
                    htmlBody +=' To remediate, the Firm must adhere to the process outlined below to enable MCM to reconcile the information against its records.</p>';
                    htmlBody += '<p><b> Required Action </b></p>';
                    htmlBody += '<p>1. Select the link to access the Inventory Reconciliation (IR) record within the LC Partner Access Site: ';
                    htmlBody += '<a href='+label.LC_Partner_URL+pam.Id+'>'+pam.Name+'</a><br/>';
                    htmlBody += '<p>2. Locate the accounts with discrepancies in the “IR – Unmatched” section</p>';
                    htmlBody += '<p>3. Review the account discrepancy description within each record: &nbsp;</p>';
                    htmlBody += '<ol type="a"> <li>	MCM Open/Firm Closed: </li>';
                    htmlBody += '<ul style="list-style-type:disc;"><li>Currently Open with Firm</li>';
                    htmlBody += '<li>Currently Open with Firm</li>';
                    htmlBody += '<li>Inactive close code used</li>';
                    htmlBody += '<li>Close code re-sent</li></ul>';
                    
                    htmlBody += '<li>Firm Open/MCM Closed: </li>';
                    htmlBody += '<ul style="list-style-type:disc;"><li>Timing – Account closed same day as cut off</li>';
                    htmlBody += '<li>Legal obligation</li>';
                    htmlBody += '<li>Reopen Request Sent</li>';
                    htmlBody += '<li>Account is currently Closed</li></ul></ol>';
                    htmlBody += '<p>4. Select the description of the variation from the drop-down list in the "Discrepancy Detail" section.</p>';
                    
                    htmlBody += '<p><b>The Firm must respond by providing the required information by '+TenthDate+'</b>. For any questions, contact ';
                    htmlBody += '<p> <a href="mailto:LO-InventoryRecon@mcmcg.com">aLO-InventoryRecon@mcmcg.com</a>.</p>';
                    htmlBody += '<p>&nbsp;</p>';
                    htmlBody += '<p>Thank you,</p>';
                    htmlBody += '<p>Inventory Reconciliation Specialist</p>';
                    mail.setHtmlBody(htmlBody);
                    email.add(mail);
                }
            }
        }
        if(!test.isRunningTest()){
            Messaging.sendEmail(email);
        }
    }
     /*********************** Send Final Escalation **************************/
    public static void sendFinalNotification(List<Contact> conList, Map<Id,List<Process_Adherence_Monitoring__c>> acctIdByPamList){
        List<Messaging.SingleEmailMessage> email = new List<Messaging.SingleEmailMessage>();
        
        for(Contact con : conList){
            if(acctIdByPamList.get(con.AccountId) != null){
                for(Process_Adherence_Monitoring__c pam : acctIdByPamList.get(con.AccountId)){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    if(owea.size() > 0){
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail.setToAddresses(new List<String> {con.Email});  
                    mail.setSubject(con.Account.Firm_Id__c+' Monthly Inventory Reconciliation – vX – Remediation Final Escalation '+pam.SCMD_Reporting_Period__c);
                    
                    string htmlBody = '<p>Dear '+con.FirstName+',</p>';
                    htmlBody += '<p>Be advised that the Firm\'s response to the information requested below is past due. MCM will schedule a call with the Firm and MCM Firm Manager to discuss and resolve.</p>';
                    htmlBody += '</hr>';
                    htmlBody += '<p>MCM identified potential discrepancies with the placement information submitted by the Firm.';
                    htmlBody +=' To remediate, the Firm must adhere to the process outlined below to enable MCM to reconcile the information against its records.</p>';
                    htmlBody += '<p><b> Required Action </b></p>';
                    htmlBody += '<p>1. Select the link to access the Inventory Reconciliation (IR) record within the LC Partner Access Site: ';
                    htmlBody += '<a href='+label.LC_Partner_URL+pam.Id+'>'+pam.Name+'</a><br/>';
                    htmlBody += '<p>2. Locate the accounts with discrepancies in the “IR – Unmatched” section</p>';
                    htmlBody += '<p>3. Review the account discrepancy description within each record: &nbsp;</p>';
                    htmlBody += '<ol type="a"> <li>	MCM Open/Firm Closed: </li>';
                    htmlBody += '<ul style="list-style-type:disc;"><li>Currently Open with Firm</li>';
                    htmlBody += '<li>Currently Open with Firm</li>';
                    htmlBody += '<li>Inactive close code used</li>';
                    htmlBody += '<li>Close code re-sent</li></ul>';
                    
                    htmlBody += '<li>Firm Open/MCM Closed: </li>';
                    htmlBody += '<ul style="list-style-type:disc;"><li>Timing – Account closed same day as cut off</li>';
                    htmlBody += '<li>Legal obligation</li>';
                    htmlBody += '<li>Reopen Request Sent</li>';
                    htmlBody += '<li>Account is currently Closed</li></ul></ol>';
                    htmlBody += '<p>4. Select the description of the variation from the drop-down list in the "Discrepancy Detail" section.</p>';
                    
                    htmlBody += '<p><b>The Firm must respond by providing the required information by '+TenthDate+'</b>. For any questions, contact ';
                    htmlBody += '<p> <a href="mailto:LO-InventoryRecon@mcmcg.com">aLO-InventoryRecon@mcmcg.com</a>.</p>';
                    htmlBody += '<p>&nbsp;</p>';
                    htmlBody += '<p>Thank you,</p>';
                    htmlBody += '<p>Inventory Reconciliation Specialist</p>';
                    mail.setHtmlBody(htmlBody);
                    email.add(mail);
                }
            }
        }
        if(!test.isRunningTest()){
            Messaging.sendEmail(email);
        }
    }
     /************************************ No Response Email Template *******************************************/
    // need to create batch class for all.
    public static void sendNoResponse(List<Process_Adherence_Monitoring__c> pamLists){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Process_Adherence_Monitoring__c pam : pamLists){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            mail.setToAddresses(new List<String>{pam.Organization_Name__r.Owner.Email,'LO-InventoryRecon@mcmcg.com'}); // o	LO-InventoryRecon@mcmcg.com
            mail.Setsubject(pam.Organization_Name__r.Firm_ID__c+ ' Monthly Inventory Reconciliation – vX – No Response from Firm '+pam.SCMD_Reporting_Period__c);
            String htmlBody = '<p>Hello,</p>';
            htmlBody += '<p>Be advised that the Firm identified above has not provided the required monthly inventory ';
            htmlBody += 'reconciliation file of open vX accounts after <b>nine (9)</b> notifications.  To remediate, the Vendor  ';
            htmlBody += 'Specialist team is scheduling a call with you and the Firm to discuss and resolve.</p>';
            htmlBody += '<p>&nbsp;</p>';
            htmlBody += '<p>Thank you,</p>';
            htmlBody += '<p>Inventory Reconciliation Specialist</p>';
            mail.setHtmlBody(htmlBody);
            emails.add(mail);
        }
        if(!test.isRunningTest()){
            Messaging.sendEmail(emails);
        }
    }

    
    /**************************** Update Status for First Escalation ***************************/
    private static List<PAM_Unmatched__c> updateUMPAMForFirstEsc(List<Process_Adherence_Monitoring__c> pamList){
        string statusNew = 'New';
        Date dt = system.today().addMonths(-1);
        string month = string.valueOf(dt);
        if(month.length() == 1){
            month = '0'+month;
        }
        string ReportingPeriod = dt.year()+'-'+month;
        Set<Id> pamIdSet = new Set<Id>();
        for(Process_Adherence_Monitoring__c pm : pamList){
            pamIdSet.add(pm.Id);
        }
        List<PAM_Unmatched__c> umPamList = [SELECT Id, Name, PAMUM_Status__c 
                                              FROM PAM_Unmatched__c 
                                              WHERE SCMDUM_Reporting_Period__c = :reportingPeriod 
                                              AND PAMUM_Status__c = :statusNew 
                                              AND PAMUM_Process_Adherence_Monitoring__c IN :pamIdSet];
        for(PAM_Unmatched__c un : umPamList){
             un.PAMUM_Status__c = 'First Escalation';
        }
        return umPamList;
    }
    /**************************** Update Status for Final Escalation ***************************/
    private static List<PAM_Unmatched__c> updateUMPAMForFinalEsc(List<Process_Adherence_Monitoring__c> pamList){
        string statusFinal = 'First Escalation';
        Date dt = system.today().addMonths(-1);
        string month = string.valueOf(dt);
        if(month.length() == 1){
            month = '0'+month;
        }
        string ReportingPeriod = dt.year()+'-'+month;
        Set<Id> pamIdSet = new Set<Id>();
        for(Process_Adherence_Monitoring__c pm : pamList){
            pamIdSet.add(pm.Id);
        }
        List<PAM_Unmatched__c> umPamList = [SELECT Id, Name, PAMUM_Status__c 
                                              FROM PAM_Unmatched__c 
                                              WHERE SCMDUM_Reporting_Period__c = :reportingPeriod 
                                              AND PAMUM_Status__c = :statusFinal 
                                              AND PAMUM_Process_Adherence_Monitoring__c IN :pamIdSet];
        for(PAM_Unmatched__c un : umPamList){
             un.PAMUM_Status__c = 'Final Escalation';
        }
        return umPamList;
    }
    /*********************** Fetch Contacts ********************/
    private static List<Contact> fetchContacts(Set<Id> acctIdSet){
        return [SELECT Id,FirstName,Email,AccountId,Contact_Type_SME__c,Account.Firm_Id__c,Community_User__c 
                FROM Contact 
                WHERE AccountId IN :acctIdSet
                AND Distribution_Contact__c = true
                AND Inactive_Contact__c = false];//  AND (Community_User__c = true OR Contact_Type_SME__c INCLUDES ('Inventory Reconciliation'))
    }
    
}