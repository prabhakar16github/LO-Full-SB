public class IR_ACF_Service {
    
    public Static Date today_date = System.today();
    public Static String currentMonth = String.valueOf(today_date.month());
    
    public Static String cutOffDate = Date.newInstance(today_date.year(), today_date.month(), 25).format();
    public Static String fileDueToACF = Date.newInstance(today_date.year(), today_date.month(), 28).format();
    public Static String actionItemCompleted = Date.newInstance(today_date.year(), today_date.addMonths(1).month(), 10).format();
    
    public Static OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'acf-looperational@mcmcg.com'];
    
    /********************************** Method to Send the Initial Communication **********************************/
    
    public static void processNotification(List<Account> accountList){
        Set<Id> accIdSet = new Set<Id>();
        List<Contact> contList = new List<Contact>();
        for(Account acc : accountList){
            accIdSet.add(acc.Id);
        }
        
        if(accIdSet.size() > 0)
            contList = getContacts(accIdSet);
        
        if(contList.size() > 0){
            sendInitialNotification(contList);
        }
    }
    
    /******************************** Email Template for Initial Communication***************************/
    
    private static void sendInitialNotification(List<contact> contList){
        string month = string.valueOf(today_date.month());
        if(month.length() == 1){
            month = '0'+month;
        }
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(Contact con : contList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{con.email});
            
            if(owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            
            mail.Setsubject(con.Account.Firm_ID__c+ ' ACF Monthly Inventory Reconciliation – Initial Communication '+today_date.year()+'-'+month);
            String htmlBody = '<p>Hello '+con.FirstName+',</p>';
            htmlBody +=	'<p>*Cut-off date - '+cutOffDate+'<br /> ';
            htmlBody += '<br />*File Due to ACF - '+fileDueToACF+'<br />';
            htmlBody += ' <br />*Action Item Completed - '+actionItemCompleted+'<br />';
            htmlBody += '<br />For your convenience, we will always accept your file prior to the File Due ';
            htmlBody += 'to ACF due date.<br /> <br />For any questions, contact ';
            htmlBody += ' <a href="mailto:acf-looperational@mcmcg.com">acf-looperational@mcmcg.com</a>.</p>';
            htmlBody += '<p>Thank you,</p>';
            htmlBody += '<p>ACF Inventory Recon</p>';
            mail.setHtmlBody(htmlBody);
            emails.add(mail);
        }
        Messaging.sendEmail(emails);
    }
    
    
    
    /******************************** Method to Create PAM(ACF IR) Records********************************/
    
    public static void createIR_ACFRecords(List<Account> accountList){
        Map<Id,Account> accountByAccountId = new Map<Id,Account>();
        Set<Id> contactIds = new Set<Id>();
        
        for(Account accountObj : accountList){
            for(Contact con : accountObj.Contacts){
                contactIds.add(con.Id);
            }
            accountByAccountId.put(accountObj.Id, accountObj);
        }
        
        List<User> userList = [SELECT Id, Name, contactId, isActive 
                               FROM User 
                               WHERE ((Name = 'System Administrator' 
                                       AND Profile.Name = 'System Administrator') 
                                      OR ContactId IN : contactIds) 
                               AND isActive = true];
        User adminUser = new User();
        Map<Id,Id> conIdToUserMap = new Map<Id,Id>();
        if(userList.size() > 0){
            for(User usr : userList){
                if(usr.Name == 'System Administrator'){
                    adminUser = usr;
                }
                if(usr.ContactId != NULL && usr.IsActive == true){
                    conIdToUserMap.put(usr.ContactId, usr.Id);
                }
            }
        }
        List<Process_Adherence_Monitoring__c> pamListToInsert = new List<Process_Adherence_Monitoring__c>();
        for(Account acc : accountList){
            Date currentDay = System.today();
            String currentMonth = String.valueOf(currentDay.month());
            if(currentMonth.length() == 1)
                currentMonth = '0'+currentMonth;
            Process_Adherence_Monitoring__c pamIR_ACF = new Process_Adherence_Monitoring__c();
            pamIR_ACF.RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR').getRecordTypeId();
            pamIR_ACF.SCMD_Reporting_Period__c = currentDay.year()+'-'+currentMonth;
            pamIR_ACF.Organization_Name__c = acc.Id;
            pamIR_ACF.Status__c = 'New';
            //pamIR_ACF.OwnerId = assignPamOwner(adminUser,acc,conIdToUserMap);
            pamListToInsert.add(pamIR_ACF);
        }
        
        
        if(pamListToInsert.size() > 0){
            insert pamListToInsert;
            Set<Id> newPamIdSet = new Set<Id>();
            for(Process_Adherence_Monitoring__c pam : pamListToInsert){
                newPamIdSet.add(pam.Id);
            }
            if(newPamIdSet.size() > 0)
                sendFirstReminder(accountByAccountId,newPamIdSet);
        }
    }
    
    /***********************************Method for PAM (ACF IR) owner assignment*************************************/
    
    /*private static Id assignPamOwner(User adminUser, Account accObj, Map<Id, Id> userIdByContactId){
        
        Id assignOwnerId;
        for(Contact con : accObj.Contacts){
            if(assignOwnerId == null 
               && con.Contact_Type_SME__c != null
               && String.valueOf(con.Contact_Type_SME__c).containsIgnoreCase('Inventory Reconciliation') ///Inventory Reconciliation
               && con.Community_User__c 
               && userIdByContactId.containsKey(con.Id)){
                   
                   assignOwnerId = userIdByContactId.get(con.Id);
                   break;
               }
        }
        if(assignOwnerId == null){
            
            for(Contact con : accObj.Contacts){
                if(assignOwnerId == null 
                   && con.Community_User__c 
                   && userIdByContactId.containsKey(con.Id)){
                       
                       assignOwnerId = userIdByContactId.get(con.Id);
                       break;
                   }
            }
        }
        if(assignOwnerId == null){
            assignOwnerId = adminUser.Id;
        }
        return assignOwnerId;
    }*/
    
    /**************************** Method for send the First Reminder notification************************/
    
    private static void sendFirstReminder(Map<Id,Account> accountByAccountId,Set<Id> newPamIdSet){
        List<Process_Adherence_Monitoring__c> pamListToInsert = [SELECT Id,Name,Organization_Name__c,SCMD_Reporting_Period__c
                                                                 FROM Process_Adherence_Monitoring__c
                                                                 WHERE Id IN :newPamIdSet];
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(Process_Adherence_Monitoring__c pam : pamListToInsert){
            if(accountByAccountId.get(pam.Organization_Name__c ) != NULL){
                for(Contact con : accountByAccountId.get(pam.Organization_Name__c).contacts){
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    String subjectLine = accountByAccountId.get(pam.Organization_Name__c).Firm_Id__c+' ACF Monthly ';
                    subjectLine += 'Inventory Reconciliation - Reminder Communication '+pam.SCMD_Reporting_Period__c;
                    email.setSubject(subjectLine);
                    
                    if(owea.size() > 0 ) {
                        email.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    email.setToAddresses(new List<String>{con.Email});
                    String htmlBody = 'Hello '+con.FirstName+',<br/><br/>';
                    htmlBody +=	'<p>*Cut-off date - '+cutOffDate+ '<br /> ';
                    htmlBody += '<br />*File Due to ACF - '+fileDueToACF+'<br />';
                    htmlBody += ' <br />*Action Item Completed - '+actionItemCompleted+'<br /><br/>';
                    htmlBody += 'Select the link below to access the Inventory Reconciliation (IR) record ';
                    htmlBody += 'within the LC Partner Access Site. Provide a list of ACF account numbers for all ';
                    htmlBody += 'open inventory.  It is critical that the Firm provides accurate information as this ';
                    htmlBody += 'may impact the resolution of the reconciliation.<br/><br/>';
                    htmlBody += '<a href='+label.LC_Partner_URL+pam.Id+'>'+pam.Name+'</a><br/><br/>';
                    htmlBody += 'The Firm must provide responses by filling in the required information by '+fileDueToACF+'<br/><br/>';
                    htmlBody += 'For any questions, contact <a href="mailto:acf-looperational@mcmcg.com">acf-looperational@mcmcg.com</a>.<br/><br/>Thank you,<br/><br/>ACF Inventory Recon';
                    email.setHtmlBody(htmlBody);
                    emails.add(email); 
                }
            }
        }
        Messaging.sendEmail(emails);
    }
    
    
    /******************************** Method to process the PAM(ACF IR) records**********************************/
    
    public static void processPam(List<Process_Adherence_Monitoring__c> pamList,String processName){
        Map<Id,List<Process_Adherence_Monitoring__c>> pamACFIRMap = new  Map<Id,List<Process_Adherence_Monitoring__c>>();
        List<Contact> contList = new List<Contact>();
        
        for(Process_Adherence_Monitoring__c pamObj : pamList){
            if(pamObj.Organization_Name__c != null){
                List<Process_Adherence_Monitoring__c> tempList = new List<Process_Adherence_Monitoring__c>();
                if(pamACFIRMap.get(pamObj.Organization_Name__c) != NULL){
                    tempList = pamACFIRMap.get(pamObj.Organization_Name__c);
                }
                tempList.add(pamObj);
                pamACFIRMap.put(pamObj.Organization_Name__c, tempList);
            }
        }
        if(processName == 'Monthly Reminder' || processName == 'Monthly Escalation'){
            if(pamACFIRMap.keySet().size() > 0){
                contList = getContacts(pamACFIRMap.keySet());
            }
            
            if(contList.size() > 0){
                if(processName == 'Monthly Reminder'){
                    sendReminderNotification(contList, pamACFIRMap);
                }
                if(processName == 'Monthly Escalation'){
                    Date dt = Date.newInstance(today_date.year(), today_date.month(), 28);
                    //if(today_date.day() == dt.addDays(3).day()){
                        List<Process_Adherence_Monitoring__c> pamListToUpdate = new List<Process_Adherence_Monitoring__c>();
                        for(Id key : pamACFIRMap.keySet()){
                            for(Process_Adherence_Monitoring__c pam : pamACFIRMap.get(key)){
                                pamListToUpdate.add(pam);
                            }
                        }
                        if(pamListToUpdate.size() > 0)
                            updatePamStatus(pamListToUpdate);
                    //}
                    sendFinalEscalationNotification(contList, pamACFIRMap);
                }
            }
        }
        if(processName == 'No Response'){
           sendInternalEscalationNotification(pamList);
        }
    }
    
    /************************************* Update Pam Status on final Escalation*********************************/
    
    private static void updatePamStatus(List<Process_Adherence_Monitoring__c> pamList){
        for(Process_Adherence_Monitoring__c pam : pamList){
            pam.Status__c = 'Final Escalation';
        }
        update pamList;
    }
    
    /**************************************** Notification for Reminder *******************************************/
    private static void sendReminderNotification(List<contact> contList, Map<Id,List<Process_Adherence_Monitoring__c>> pamACFIRMap){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Contact con : contList){
            if(pamACFIRMap.get(con.AccountId) != NULL){
                for(Process_Adherence_Monitoring__c pam : pamACFIRMap.get(con.AccountId)){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new List<String>{con.email});
                    if(owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    String htmlBody = '<p>Hello '+con.FirstName+',</p>';
                    htmlBody += '<p>*Cut-off date - '+cutOffDate+'<br /> ';
                    htmlBody += '<br />*File Due to ACF - '+ fileDueToACF+'<br /> ';
                    htmlBody += '<br />*Action Item Completed - '+actionItemCompleted+'</p>';
                    
                    if(today_date.day() == 28){ //28
                        mail.Setsubject(con.Account.Firm_ID__c+ ' ACF Monthly Inventory Reconciliation – Final Reminder '+pam.SCMD_Reporting_Period__c);
                        htmlBody +='<p>As a reminder the below information is due <b><u>today</u></b>.</p>';
                    }
                    
                    else if(today_date.day() == 27){ // 27
                        mail.Setsubject(con.Account.Firm_ID__c+ ' ACF Monthly Inventory Reconciliation – Reminder Communication '+pam.SCMD_Reporting_Period__c);
                        htmlBody += '<p>As a reminder the below information is due tomorrow.</p>';
                    }
                    
                    htmlBody += '<p>Select the link below to access the Inventory Reconciliation (IR) record within ';
                    htmlBody += 'the LC Partner Access Site.&nbsp; Provide a list of ACF account numbers for all ';
                    htmlBody += 'open inventory.&nbsp; It is critical that the Firm provides accurate information as this ';
                    htmlBody += 'may impact the resolution of the reconciliation.</p>';
                    htmlBody += '<p><u><a href="'+label.LC_Partner_URL+ pam.Id+'">'+pam.Name+'</a></u></p>';
                    htmlBody += '<p>The Firm must provide responses by filling in the required information ';
                    htmlBody += 'by '+fileDueToACF+'.</p>';
                    htmlBody += '<p>For any questions, contact ';
                    htmlBody += '<a href="mailto:acf-looperational@mcmcg.com">acf-looperational@mcmcg.com</a>.</p>';
                    htmlBody += '<p></p>';
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
    
    
    /*************************************** Notification for Escalation ********************************************/
    private static void sendFinalEscalationNotification(List<Contact> contList, Map<Id,List<Process_Adherence_Monitoring__c>> pamListByAccId){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Contact con : contList){
            if(pamListByAccId.get(con.AccountId) != NULL){
                for(Process_Adherence_Monitoring__c pam : pamListByAccId.get(con.AccountId)){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new List<String>{con.email});
                    if(owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail.Setsubject(con.Account.Firm_ID__c+ ' ACF Monthly Inventory Reconciliation – Final Escalation '+pam.SCMD_Reporting_Period__c);
                    String htmlBody = '<p>Hello '+con.FirstName+',</p>';
                    htmlBody += '<p>*Cut-off date - '+cutOffDate+'<br /> ';
                    htmlBody += '<br />*File Due to ACF - '+ fileDueToACF+'<br /> ';
                    htmlBody += '<br />*Action Item Completed - '+actionItemCompleted+'</p><br/><br/>';
                    htmlBody +='<p>Be advised that the Firm\'s\' response to the request below is now <b>past due</b>.';
                    htmlBody +=  ' This is time sensitive. Please provide your response <b><u>today</u></b>.</p>';
                    htmlBody += '<p>Select the link below to access the Inventory Reconciliation (IR) record within ';
                    htmlBody += 'the LC Partner Access Site.&nbsp; Provide a list of ACF account numbers for all ';
                    htmlBody += 'open inventory.&nbsp; It is critical that the Firm provides accurate information as this ';
                    htmlBody += 'may impact the resolution of the reconciliation.</p>';
                    htmlBody += '<p><u><a href="'+label.LC_Partner_URL+pam.Id+'">'+pam.Name+'</a></u></p>';
                    htmlBody += '<p>The Firm must provide responses by filling in the required information ';
                    htmlBody += 'by '+fileDueToACF+'.</p>';
                    htmlBody += '<p>For any questions, contact ';
                    htmlBody += '<a href="mailto:acf-looperational@mcmcg.com">acf-looperational@mcmcg.com</a>.</p>';
                    htmlBody += '<p></p>';
                    htmlBody += '<p>Thank you,</p>';
                    htmlBody += '<p>ACF Inventory Recon</p>';
                    mail.setHtmlBody(htmlBody);
                    emails.add(mail);
                }
            }
        }
        Messaging.sendEmail(emails);
    }
    
    
    /*************************************** Notification for No Response ********************************************/
    
    private static void sendInternalEscalationNotification(List<Process_Adherence_Monitoring__c> pamList){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        
        for(Process_Adherence_Monitoring__c pam : pamList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            mail.setToAddresses(new List<String>{pam.Organization_Name__r.Owner.Email,'Acf-looperational@mcmcg.com'}); //	Acf-looperational@mcmcg.com // User1.FirmB@MCMCG.COM
            mail.Setsubject(pam.Organization_Name__r.Firm_ID__c+ ' ACF Monthly Inventory Reconciliation '+pam.SCMD_Reporting_Period__c+' – No Response From Firm ');
            String htmlBody = '<p>Hello '+pam.Organization_Name__r.owner.firstName+',</p>';
            htmlBody += '<p>Be advised that your Firm has not provided the required monthly Inventory reconciliation ';
            htmlBody += 'open file after <strong>seven (7)</strong> notifications. At this time, the ';
            htmlBody += 'Vendor Specialist will be setting up a meeting with you and the Firm for further discussion and resolution.</p>';
            htmlBody += '<p>Thank you,</p>';
            htmlBody += '<p>ACF Inventory Recon</p>';
            mail.setHtmlBody(htmlBody);
            emails.add(mail);
        }
        
        Messaging.sendEmail(emails);
    }
    
    /***************************************** To get the contacts *******************************************/
    
    private static List<Contact> getContacts(Set<Id> accIdSet){//Inventory Reconciliation
        return [SELECT Id,FirstName,Email,AccountId,Contact_Type_SME__c,Account.Firm_Id__c,Community_User__c 
                FROM Contact 
                WHERE AccountId IN :accIdSet
                AND (Community_User__c = true 
                     OR Contact_Type_SME__c INCLUDES ('Inventory Reconciliation'))
                AND Inactive_Contact__c = false];
    }
}