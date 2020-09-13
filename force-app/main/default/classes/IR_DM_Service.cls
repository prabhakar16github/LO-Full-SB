public class IR_DM_Service {
    public Static OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'LO-InventoryRecon@mcmcg.com'];//lo-operational@mcmcg.com
    public static Date today_date = System.today();
    public static string creationDate = Date.newInstance(today_date.year(), today_date.month(), 24).format();
    public Static String cutOffDate = Date.newInstance(today_date.year(), today_date.month(), 25).format();
    public Static String fileDueToDM = Date.newInstance(today_date.year(), today_date.month(), 28).format();
    public Static String actionItemCompleted = Date.newInstance(today_date.year(), today_date.addMonths(1).month(), 10).format();
    
    
    public static void processInitialNotification(List<Account> accountList){
        Set<Id> acctIdSet = new Set<Id>();
        List<Contact> contactList = new List<Contact>();
        for(Account acc : accountList){
            acctIdSet.add(acc.Id);
        }
        if(acctIdSet.size() > 0){
            contactList = fetchContacts(acctIdSet);
        }
        if(!contactList.isEmpty()){
            //System.debug('contactList > '+contactList.size());
            sendInitialNotification(contactList);
        }
    }
    
    /********************* Record Creation ******************************/
    public static void createDMRecord(List<Account> accountList){
        Set<Id> contactIds = new Set<Id>();
        Map<Id,Account> accountByAccountId = new Map<Id,Account>();
        set<Id> accountIds = new Set<Id>();
        
        for(Account acc : AccountList){
            for(Contact con : Acc.contacts){
                contactIds.add(con.Id);
            }
            accountByAccountId.put(acc.Id, acc);
            accountIds.add(acc.Id);
        }
        System.debug('contactIds >> '+contactIds);
        // system.debug('accountIds >> '+accountIds);
        Map<Id, Account> accountByaccountIdMap = new Map<Id, Account>([SELECT Id, Name, Firm_ID__c,
                                                                       
                                                                       (SELECT Id, ContactId, Contact.FirstName, Contact.Email, 
                                                                        Contact.Distribution_Contact__c , Contact.Community_User__c 
                                                                        FROM AccountContactRelations 
                                                                        WHERE Contact.Distribution_Contact__c = true 
                                                                        OR Contact.Community_User__c = true)
                                                                       
                                                                       From Account WHERE Id IN :accountIds]);
        
        List<User> userList = [SELECT Id, ContactId, isActive, Name FROM User 
                               WHERE (Name = 'System Administrator' 
                                      AND Profile.Name = 'System Administrator' 
                                      AND isActive = True ) 
                               OR Contact.accountId IN : accountIds];
       // system.debug('userList >> '+userList.size());
        
        User adminUser = new User();
        Map<Id,Id> contactIdByUserId = new Map<Id,Id>();
        
        if(userList.size() > 0){
            for(User usr : userList){
                if(usr.Name == 'System Administrator'){
                    adminUser = usr;
                }
                if(usr.ContactId != Null && usr.IsActive == True){
                    contactIdByUserId.put(usr.ContactId, usr.Id);
                }
            }
        }
        
        
        List<Process_Adherence_Monitoring__c> pamList = new List<Process_Adherence_Monitoring__c>();
        for(Account acct : accountList){
            Date currentDate = System.today();
            String CurrentMonth = String.valueOf(currentDate.month());
            if(CurrentMonth.length() == 1){
                CurrentMonth = '0'+CurrentMonth;
            }
            Process_Adherence_Monitoring__c pamRecord = new Process_Adherence_Monitoring__c();
            Account accobj = accountByaccountIdMap.get(acct.Id);
           // System.debug('accObj  in DM_IR_Service >>>>   '+accobj);
            pamRecord.RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM IR').getRecordTypeId();
            pamRecord.SCMD_Reporting_Period__c = currentDate.year()+'-'+CurrentMonth;
            pamRecord.Organization_Name__c = acct.Id;
            pamRecord.Status__c = 'New';
            pamRecord.ownerId = assignPamOwner(adminUser,accobj,contactIdByUserId);
            pamList.add(pamRecord);
        } 
        
        if(pamList.size() > 0){
            insert pamList;
           // system.debug('pamList >> '+pamList);
            //System.debug('pamList[0].OwnerId '+pamList[0].OwnerId);
            Set<Id> pamIdSet = new Set<Id>();
            for(Process_Adherence_Monitoring__c pam : pamList){
                pamIdSet.add(pam.Id);
            }
            if(!pamIdSet.isEmpty()){
                sendRecordCreationNotification(pamIdSet,accountByAccountId);
            }
        }
    }
    /********************** Reminder Notification ************************************/
    public static void processPamDM(List<Process_Adherence_Monitoring__c> pamList,String ProcessName){
        List<Contact> contactList = new List<Contact>();
        Map<Id, List<Process_Adherence_Monitoring__c>> accountIdByPamList = new Map<Id, List<Process_Adherence_Monitoring__c>>();
        
        for(Process_Adherence_Monitoring__c pam : pamList){
            if(pam.Organization_Name__c != NULL){
                List<Process_Adherence_Monitoring__c> tempList = new List<Process_Adherence_Monitoring__c>();
                if(accountIdByPamList.get(pam.Organization_Name__c) != NULL){
                    tempList = accountIdByPamList.get(pam.Organization_Name__c);
                }
                tempList.add(pam);
                accountIdByPamList.put(pam.Organization_Name__c, tempList);
            }
        }  
        if(ProcessName == 'Monthly Reminder' || ProcessName == 'Monthly Escalation'){
            if(accountIdByPamList.keySet().size() > 0){
                contactList = fetchContacts(accountIdByPamList.keySet());
            } 
            if(contactList.size() > 0){
                sendReminderNotification(contactList, accountIdByPamList);
            }  
            if(ProcessName == 'Monthly Escalation'){
                Date dt = Date.newInstance(today_date.year(), today_date.month(), 28);
                List<Process_Adherence_Monitoring__c> pamListToUpdate = new List<Process_Adherence_Monitoring__c>();
                for(Id key : accountIdByPamList.keyset()){
                    for(Process_Adherence_Monitoring__c pamUpdate : accountIdByPamList.get(key)){
                        pamListToUpdate.add(pamUpdate);
                    }
                }
                if(pamListToUpdate.size() > 0){
                    updateFinalPam(pamListToUpdate);
                }
                SendFinalEscalation(contactList,accountIdByPamList);
            }
        }
        if(ProcessName == 'No Response'){
            sendInternalEscalation(pamList);
        }
    }
    
    /*********************** Send Initial Notification *************************************/
    private static void sendInitialNotification(List<Contact> contactList){
        String month = string.valueOf(today_date.month());
        if(month.length() == 1){
            month = '0'+month;
        }
        List<Messaging.SingleEmailMessage> msg = new List<Messaging.SingleEmailMessage>();
        for(Contact con : contactList){ 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<string>{con.Email});
            
            if(owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            mail.Setsubject(con.Account.Firm_ID__c+ ' Monthly Inventory Reconciliation - vX – Initial Communication - Upcoming Request '+today_date.year()+'-'+month);
            String htmlBody = '<p>Hello '+con.FirstName+',</p>';
            htmlBody += '<p>MCM monitors its inventory to ensure its records accurately reflect the placement status of vX accounts. </p> ';
            htmlBody += 'On '+creationDate+', MCM will provide a link to access the Inventory Reconciliation (IR) record within the LC Partner Access Site for the Firm to submit account numbers for al l<b open vX accounts placed to the Firm</b>, enabling MCM to reconcile the information against its records.';
            htmlBody += ' Upon receipt of the link, Firms will be able to provide the requested information.';
            
            htmlBody += '<ul><li>Cut-off date - '+cutOffDate+'</li>';
            htmlBody += '<li>File Due to MCM - '+fileDueToDM+'</li>';
            htmlBody += '<li>Action Item Completed - '+actionItemCompleted+'</li></ul>';
            htmlBody += '<br />*Note that Firms will not be able to provide the requested information before '+creationDate+'. For any questions, contact LO-InventoryRecon@mcmcg.com. ';
            htmlBody += '<br /> <br />For any questions, contact ';
            htmlBody += ' <a href="mailto:LO-InventoryRecon@mcmcg.com">LO-InventoryRecon@mcmcg.com</a>.</p>';
            htmlBody += '<p>Thank you,</p>';
            htmlBody += '<p>Inventory Reconciliation Specialist</p>';
            mail.setHtmlBody(htmlBody);
            msg.add(mail);
        }
        Messaging.sendEmail(msg);
    }
    /***************************** Send Creation Notification **********************/
    public static void sendRecordCreationNotification(Set<Id> pamIdSet,Map<Id,Account> accountByAccountId ){
        List<Process_Adherence_Monitoring__c> pamListToInsert = [SELECT Id,Name,Organization_Name__c,SCMD_Reporting_Period__c
                                                                 FROM Process_Adherence_Monitoring__c
                                                                 WHERE Id IN :pamIdSet];
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(Process_Adherence_Monitoring__c pam : pamListToInsert){
            if(accountByAccountId.get(pam.Organization_Name__c ) != NULL){
                for(Contact con : accountByAccountId.get(pam.Organization_Name__c).contacts){
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    String subjectLine = accountByAccountId.get(pam.Organization_Name__c).Firm_Id__c;
                    subjectLine += ' Monthly Inventory Reconciliation - vX  – Reminder Communication  '+pam.SCMD_Reporting_Period__c;
                    email.setSubject(subjectLine);
                    
                    if(owea.size() > 0 ) {
                        email.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    email.setToAddresses(new List<String>{con.Email}); //
                    String htmlBody = 'Hello '+con.FirstName+',<br/><br/>';
                    htmlBody += '<p>MCM monitors its inventory to ensure its records accurately reflect the placement status of vX accounts.  Firms must adhere to the process outlined below and provide accurate information to enable MCM to reconcile the information against its records. </p>';
                    
                    htmlBody += '<p><b> Required Action </b></p>';
                    htmlBody += '<p>1. Select the link to access the Inventory Reconciliation (IR) record within the LC Partner Access Site: ';
                    htmlBody += '<a href='+label.LC_Partner_URL+pam.Id+'>'+pam.Name+'</a><br/>';
                    htmlBody += '<p>2. Submit a text file attachment containing the account numbers for all open vX accounts placed to the Firm:</p>';
                    htmlBody += '<ul><li>Cut-off date - '+cutOffDate+'</li>';
                    htmlBody += '<li>File Due to MCM - '+fileDueToDM+'</li>';
                    htmlBody += '<li>Action Item Completed - '+actionItemCompleted+'</li></ul>';
                    htmlBody += '<br />For your convenience, Firms may provide the requested information prior to the File Due date.  ';
                    htmlBody += '<br /> <br />For any questions, contact ';
                    htmlBody += ' <a href="mailto:LO-InventoryRecon@mcmcg.com">LO-InventoryRecon@mcmcg.com</a>.</p>';
                    htmlBody += '<p>Thank you,</p>';
                    htmlBody += '<p>Inventory Reconciliation Specialist</p>';
                    
                    email.setHtmlBody(htmlBody);
                    emails.add(email); 
                }
            }
        }
          Messaging.sendEmail(emails);
    }
    /**************************** Reminder Notification *********************************/
    public static void sendReminderNotification(List<Contact> contactList,  Map<Id,List<Process_Adherence_Monitoring__c>> accountIdByPamList){
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for(Contact con : contactList){
            if(accountIdByPamList.get(con.AccountId) != NULL){
                for(Process_Adherence_Monitoring__c pamObj : accountIdByPamList.get(con.AccountId)){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new List<String>{con.Email}); //con.Email
                    if(owea.size() > 0){
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    String htmlBody = '<p>Hello '+con.FirstName+',</p>';
                    
                    if(today_date.day() == 28){ //28
                        mail.Setsubject(con.Account.Firm_ID__c+ ' Monthly Inventory Reconciliation - vX – Final Reminder '+pamObj.SCMD_Reporting_Period__c);
                        htmlBody +='<p>As a reminder, the information requested below is due <b><u>today</u></b>.</p>';
                    }
                    
                    else if(today_date.day() == 27){ // 27
                        mail.Setsubject(con.Account.Firm_ID__c+ ' Monthly Inventory Reconciliation - vX – Reminder Communication '+pamObj.SCMD_Reporting_Period__c);
                        htmlBody += '<p>As a reminder, the information requested below is due <b><u>tomorrow</u></b>.</p>';
                    }
                    
                    htmlBody +='<hr>';
                    htmlBody += '<p>MCM monitors its inventory to ensure its records accurately reflect the placement status of vX accounts. Firms must adhere to the process outlined below and provide accurate information to enable MCM to reconcile the information against its records.</p>';
                    htmlBody += '<p><b> Required Action </b></p>';
                    htmlBody += '<p>1. Select the link to access the Inventory Reconciliation (IR) record within the LC Partner Access Site: ';
                    htmlBody += '<a href='+label.LC_Partner_URL+pamObj.Id+'>'+pamObj.Name+'</a><br/>';
                    htmlBody += '<p>2. Submit a text file attachment containing the account numbers for all open vX accounts placed to the Firm:</p>';
                    htmlBody += '<ul><li>Cut-off date - '+cutOffDate+'</li>';
                    htmlBody += '<li>File Due to MCM - '+fileDueToDM+'</li>';
                    htmlBody += '<li>Action Item Completed - '+actionItemCompleted+'</li></ul>';
                    htmlBody += '<br />For your convenience, Firms may provide the requested information prior to the File Due date.  ';
                    htmlBody += '<br /> <br />For any questions, contact ';
                    htmlBody += ' <a href="mailto:LO-InventoryRecon@mcmcg.com">LO-InventoryRecon@mcmcg.com.</a>.</p>';
                    htmlBody += '<p>Thank you,</p>';
                    htmlBody += '<p>Inventory Reconciliation Specialist</p>';
                    mail.setHtmlBody(htmlBody);
                    emailList.add(mail);
                }
            }
        }
        Messaging.sendEmail(emailList);
    }
    /******************* update pam status to final **************************/
    private static void updateFinalPam(List<Process_Adherence_Monitoring__c> pamListToUpdate){
        for(Process_Adherence_Monitoring__c pam : pamListToUpdate){
            pam.Status__c = 'Final Escalation';
        }
        update pamListToUpdate;
    }
    /********************************* SendFinalEscalation *******************************/
    private static void SendFinalEscalation(List<Contact> contactList, Map<Id,List<Process_Adherence_Monitoring__c>> accountIdByPamList){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Contact con : contactList){
            if(accountIdByPamList.get(con.AccountId) != NULL){
                for(Process_Adherence_Monitoring__c pam : accountIdByPamList.get(con.AccountId)){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new List<String>{con.email});
                    if(owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail.Setsubject(con.Account.Firm_ID__c+ ' Monthly Inventory Reconciliation - vX – Escalation '+pam.SCMD_Reporting_Period__c);
                    String htmlBody = '<p>Hello '+con.FirstName+',</p>';
                    htmlBody +='<p>Be advised that the Firm\'s\' response to the information requested below is now <b><u>past due</u></b>.';
                    htmlBody +=  ' This is time sensitive. Please provide your response <b><u>today</u></b>.</p>';
                    htmlBody +='<hr>';
                    htmlBody += '<p>MCM monitors its inventory to ensure its records accurately reflect the placement status of vX accounts.  Firms must adhere to the process outlined below and provide accurate information to enable MCM to reconcile the information against its records.</p>';
                    htmlBody += '<p><b> Required Action </b></p>';
                    htmlBody += '<p>1. Select the link to access the Inventory Reconciliation (IR) record within the LC Partner Access Site: ';
                    htmlBody += '<a href='+label.LC_Partner_URL+pam.Id+'>'+pam.Name+'</a><br/>';
                    htmlBody += '<p>2. Submit a text file attachment containing the account numbers for all open vX accounts placed to the Firm:</p>';
                    htmlBody += '<ul><li>Cut-off date - '+cutOffDate+'</li>';
                    htmlBody += '<li>File Due to MCM - '+fileDueToDM+'</li>';
                    htmlBody += '<li>Action Item Completed - '+actionItemCompleted+'</li></ul>';
                    htmlBody += '<br />For your convenience, Firms may provide the requested information prior to the File Due date.  ';
                    htmlBody += '<br /> <br />For any questions, contact ';
                    htmlBody += ' <a href="mailto:LO-InventoryRecon@mcmcg.com">LO-InventoryRecon@mcmcg.com.</a>.</p>';
                    htmlBody += '<p>Thank you,</p>';
                    htmlBody += '<p>Inventory Reconciliation Specialist</p>';
                    
                    mail.setHtmlBody(htmlBody);
                    emails.add(mail);
                }
            }
        }
        Messaging.sendEmail(emails);
    }
    /************************** Send Internal Escalation ***********************************/
    public static void sendInternalEscalation(List<Process_Adherence_Monitoring__c> pamList){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for(Process_Adherence_Monitoring__c pam : pamList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            mail.setToAddresses(new List<String>{pam.Organization_Name__r.Owner.Email,'Shailja.SinghTomar@MCMCG.COM'}); //LO-InventoryRecon@mcmcg.com // User1.FirmB@MCMCG.COM
            mail.Setsubject(pam.Organization_Name__r.Firm_ID__c+ '  Monthly Inventory Reconciliation - vX  '+pam.SCMD_Reporting_Period__c+' – No Response From Firm ');
            String htmlBody = '<p>Hello '+pam.Organization_Name__r.owner.firstName+',</p>';
            htmlBody += '<p>Be advised that the Firm identified above has not provided the required monthly inventory reconciliation file of ';
            htmlBody += 'open vX accounts after <strong>seven (7)</strong> notifications.To remediate, the ';
            htmlBody += 'Vendor Specialist team is scheduling a call with you and the Firm to discuss and resolve. </p>';
            htmlBody += '<p>Thank you,</p>';
            htmlBody += '<p>Inventory Reconciliation Specialist</p>';
            mail.setHtmlBody(htmlBody);
            emails.add(mail);
        }
        
        Messaging.sendEmail(emails);
    }
    
    /*********************** Fetch Contacts *************************************/
    private static List<Contact> fetchContacts(Set<Id> acctIdSet){
        return [SELECT Id,FirstName,Email,AccountId,Contact_Type_SME__c,Distribution_Contact__c,Account.Firm_Id__c,Community_User__c 
                FROM Contact 
                WHERE AccountId IN :acctIdSet
                AND Distribution_Contact__c = true
                AND Inactive_Contact__c = false];//  AND (Community_User__c = true OR Contact_Type_SME__c INCLUDES ('Inventory Reconciliation'))
    }
    
    /******************** Assign Owner **************************/
    private static Id assignPamOwner(User adminUser, Account accObj, Map<Id, Id> userIdByContactId){
        Id assignOwnerId;
        
        for(AccountContactRelation accountContactRelation : accObj.AccountContactRelations){
            system.debug('@@@@');
            if(assignOwnerId == null 
               && accountContactRelation.Contact.Distribution_Contact__c 
               && userIdByContactId.containsKey(accountContactRelation.ContactId)){
                   system.debug('###');
                   assignOwnerId = userIdByContactId.get(accountContactRelation.ContactId);
                   system.debug('for distribution con >> '+ assignOwnerId);
                   break;
               }
        }
        
        if(assignOwnerId == null){
            for(AccountContactRelation accountContactRelation : accObj.AccountContactRelations){
                if(assignOwnerId == null 
                   && accountContactRelation.Contact.Community_User__c 
                   && userIdByContactId.containsKey(accountContactRelation.ContactId)){
                       
                       assignOwnerId = userIdByContactId.get(accountContactRelation.ContactId);
                       
                       break;
                   }
            }
        }
        
        if(assignOwnerId == null){
            assignOwnerId = adminUser.Id;
        }
       // system.debug('pam owner assignmnt line in IR_DM_service >> '+assignOwnerId);
        return assignOwnerId;
    }
    
}