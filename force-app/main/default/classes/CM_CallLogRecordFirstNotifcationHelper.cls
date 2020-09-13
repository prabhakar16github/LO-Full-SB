public class CM_CallLogRecordFirstNotifcationHelper{

   public static CM_CallLogRecordFirstNotifcationHelper instance = null;
   public Integer notificationNo;
   public Map<Id,Contact> allContactRelatedToAccountMap;
   
   private CM_CallLogRecordFirstNotifcationHelper(Integer notificationNo){this.notificationNo = notificationNo;}
   
   public void runBatch(List<Call_Monitoring__c> callMonitoringList){
       Map<Id,Call_Monitoring__c> accountCallMonintoringMap = new Map<Id,Call_Monitoring__c>(); // account as a key and call monitoring as value
       for(Call_Monitoring__c cm : callMonitoringList){
         if(cm.Organization_Name_CM__c != null) accountCallMonintoringMap.put(cm.Organization_Name_CM__c,cm);
       }
       Map<Id,List<User>> allAccountWithThereUserMap = getUserInformation(accountCallMonintoringMap);
       sendEmailNotification(accountCallMonintoringMap , allAccountWithThereUserMap ); // send email notification here 
   }
   
   private void sendEmailNotification(Map<Id,Call_Monitoring__c> callMonitoringGroupMap , Map<Id,List<User>> allAccountWithThereUserMap){
    final string subjectStr  = 'Action Required: Missing Call Monitoring Log Record – First Reminder';
    final string subjectStr1  = 'Action Required: Missing Call Monitoring Log Record – Final Reminder';
    final string subjectStr2 = 'Follow-Up Required: Missing Call Monitoring Logs – No Response from ';
       String subjectToEmail;
    
      if(notificationNo == 1) subjectToEmail = subjectStr ;
      else if(notificationNo == 2) subjectToEmail = subjectStr1 ;
      else if(notificationNo == 3) subjectToEmail = subjectStr2 ;
      
   Map<Id,Account> accountInfosMap = new Map<Id,Account>([SELECT id , name,Agency_ID__c,Firm_ID__c,owner.name,owner.email,FM_Process_Manager__r.email
                                                              from account where id In :callMonitoringGroupMap.keySet()]);
                                                              
      List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
      // sending email to for first notification and final notification   
      if(notificationNo == 1 || notificationNo == 2){  
        for(Id accid : allAccountWithThereUserMap.keyset()){
            for(user user : allAccountWithThereUserMap.get(accid)){
              Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                
                 emailToSend.setToAddresses(new List<String>{allContactRelatedToAccountMap.get(user.contactid).email});
                String monthstr = callMonitoringGroupMap.containsKey(accid) ? callMonitoringGroupMap.get(accid).Reporting_Month_CM__c : ''; 
                String yearStr = callMonitoringGroupMap.containsKey(accid) ? callMonitoringGroupMap.get(accid).Reporting_Year_CM__c: '';
                String firmName = accountInfosMap.containsKey(accid) ? (accountInfosMap.get(accid).Agency_ID__c != null ? accountInfosMap.get(accid).Agency_ID__c : (accountInfosMap.get(accid).Firm_ID__c!= null ? accountInfosMap.get(accid).Firm_ID__c: '')) : '';
                List<network> ll = [select id , name,UrlPathPrefix ,status from network where name='LC Partner Access'];
                String networkLoginUrl = Network.getLoginUrl(ll[0].id).trim().removeEndIgnoreCase('login');
                if(notificationNo == 1) emailToSend.setHTMLBody(emailTemplateInitialFirstNotification(user.firstname,monthstr +'/'+yearStr,networkLoginUrl ,callMonitoringGroupMap.get(accid)));
                else if(notificationNo == 2) emailToSend.setHTMLBody(emailTemplateInitialSecondNotification(user.firstname,monthstr +'/'+yearStr,networkLoginUrl ,callMonitoringGroupMap.get(accid)));
                emailToSend.setSubject(firmName +' '+subjectToEmail);
                lstMsgsToSend.add(emailToSend);
            }
        }
       } 
       
       // Internal escalation notification 
        if(notificationNo == 3){  
                for(account acc : accountInfosMap.values()){
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    List<String> sendEmailTo = new List<String>();
                     
                     if(acc.owner.email != null) sendEmailTo.add(acc.owner.email);
                     if(acc.FM_Process_Manager__r.email != null) sendEmailTo.add(acc.FM_Process_Manager__r.email);
                     
                    emailToSend.setToAddresses(sendEmailTo);
                    
                    String monthstr = callMonitoringGroupMap.containsKey(acc.id) ? callMonitoringGroupMap.get(acc.id).Reporting_Month_CM__c : ''; 
                    String yearStr = callMonitoringGroupMap.containsKey(acc.id) ? callMonitoringGroupMap.get(acc.id).Reporting_Year_CM__c: '';
                    String firmName = accountInfosMap.containsKey(acc.id) ? (accountInfosMap.get(acc.id).Agency_ID__c != null ? accountInfosMap.get(acc.id).Agency_ID__c : (accountInfosMap.get(acc.id).Firm_ID__c!= null ? accountInfosMap.get(acc.id).Firm_ID__c: '')) : '';
                    List<network> ll = [select id , name,UrlPathPrefix ,status from network where name='LC Partner Access'];
                    String networkLoginUrl = Network.getLoginUrl(ll[0].id);
                    emailToSend.setHTMLBody(emailTemplateInitialInternalNotification(acc.owner.name,monthstr +'/'+yearStr,networkLoginUrl,callMonitoringGroupMap.get(acc.id) )); 
                    emailToSend.setSubject(firmName +' '+subjectToEmail);
                    lstMsgsToSend.add(emailToSend);
               }
        } 
         
        try{
          Messaging.sendEmail(lstMsgsToSend);
          System.debug('----- Sending email is here ----');
        }catch(Exception e){
          system.debug('error message ---'+e.getMessage());
        }                                              
   }
   /* Email Template for the first Notification is here */
   private String emailTemplateInitialFirstNotification(String communityUserName,String monthyear,String recordlinkUrl,Call_Monitoring__c cm){
      String links = '<a href="'+recordlinkUrl+''+cm.id+'">'+cm.Name+'</a>';          
      String body ='Dear '+ communityUserName +':<br/><br/>';
             body += 'Our records indicate that your Firm/Agency has not submitted a Call Monitoring Log on MCM accounts for '+monthYear;
             body += '. This item is now <b><u>past due</u></b>. Immediately log into the LC Partner Access Site and take the following actions:<br/><br/>';
             body += '<b>CALL MONITORING REPORTING (MCM Only):</b><br/>';
             body += '•  If your Firm/Agency made any collection calls on MCM accounts in';
             body += monthYear+',attach a <b>Call Log</b> containing relevant call data to the Call Monitoring Log Record on the LC Partner Access Site.';
             body += '<br/>•  If your Firm/Agency did not make any collection calls on MCM accounts in <br/>';
             body += monthYear +', access the <b>Call Monitoring Log</b> record,'+links+',  on the LC Partner Access Site and check the "No Calls This Month" box indicating there were no collection calls made by the Firm/Agency.';
             body +='<br/><br/>Please note: The "Reporting Month" and "Reporting Year" should reflect'+monthYear+',.';
             body +='<br/><br/>It is critical the Firm/Agency submit the requested Call Monitoring Log in an accurate and timely manner. ';
             body +=' As a reminder, Call Logs are due by the 3rd calendar day of the month.<br/><br/>';
             body +='If you have any questions regarding this process or the requirement, first reference the LC Partner Access Site Procedures Manual. ';
             body +=' Email FirmManagement@mcmcg.com with any follow-up questions.<br/><br/>';
             body +='Firm/Agency Management';
     return body;
   }
   
   /* Email Template for the final Notification is here */
   private string emailTemplateInitialSecondNotification(String communityUserName,String monthyear,String recordlinkUrl,Call_Monitoring__c cm){
  String links = '<a href="'+recordlinkUrl+''+cm.id+'">'+cm.Name+'</a>';
     String body  = 'Dear '+ communityUserName +':<br/><br/>';
            body += 'Our records indicate that your Firm/Agency has not submitted a Call Monitoring Log attachment on MCM accounts for '+monthYear;
            body += ', .  This item is now <b><u>past due</u></b>.<br/><br/>';
            body +='Immediately log into the LC Partner Access Site and submit the appropriate Call Monitoring Log.<br/><br/>';
            body +='If the Firm/Agency did not make or receive any collections calls on MCM accounts in '+monthYear+', ';
            body +='access the Call Monitoring Log record, '+ links +', on the LC Partner Access Site and check the "No Calls This Month" box indicating there were no collection calls made by the Firm/Agency.';
            body +='<br/><br/>Please note: The "Reporting Month" and "Reporting Year" should reflect '+monthYear+', .';
            body +='<br/><br/>It is critical the Firm/Agency submit requested Call Monitoring Log in an accurate and timely manner. ';
            body +=' As a reminder, Call Logs are due by the 3rd calendar day of the month.<br/>';
            body +='<br/>If you have any questions regarding this process or the requirement, first reference the LC Partner Access Site Procedures Manual.  Email FirmManagement@mcmcg.com with any follow-up questions<br/>';
            body +='<br/>Firm/Agency Management';
    return body;
   }
   
   /* Email Template for the Internal Escalation notification is here */
   
   private string emailTemplateInitialInternalNotification(String communityUserName,String monthyear,String recordlinkUrl,Call_Monitoring__c cm){
     
      String body  = 'Dear '+ communityUserName +':<br/><br/>';
             body += 'Be advised your Firm/Agency has not submitted a Call Monitoring Log attachments on MCM accounts as requested for '+monthyear;
             body += ' after, <b><u>2 requests</u></b>.  <br/><br/>';
             String links = '<a href="'+recordlinkUrl+''+cm.id+'">'+cm.Name+'</a>';
             body += 'The Firm/Agency is at risk of not having Calls Selected and Scored for '+monthYear+',. ';
             body += 'Please follow-up with the Firm/Agency to ensure submission of the required Call Log Record.<br/><br/>';
             body += 'As a reminder, Call Logs are due by the 3rd calendar day of the month.<br/><br/>';
             body += 'If you have questions email <a>FirmManagement@mcmcg.com.</a><br/><br/> ';
             body += 'Thank you,<br/>';
             body += 'LO QA Team';
     return body;
   }
   private Map<Id,List<User>> getUserInformation(Map<Id,Call_Monitoring__c> accountCallMonintoringMap){
      if(accountCallMonintoringMap.size() > 0){
           allContactRelatedToAccountMap = new Map<Id,Contact>([SELECT Id,Name,accountid,email from contact where Community_User__c=true and accountid 
                                                          In : accountCallMonintoringMap.keySet()]);
                Map<Id,List<User>> allAccountWithThereUserMap = new Map<Id,List<User>>();                                          
                 if(allContactRelatedToAccountMap != null && allContactRelatedToAccountMap.size() > 0){
                    
                     for(user user : [select id , name,contactId,email ,firstname from user where contactId In : allContactRelatedToAccountMap.keyset() 
                                             AND Profile.Name='CC - User Access' AND isActive=true]){
                              Id accountId =  allContactRelatedToAccountMap.get(user.contactId).accountId;
                              if(!allAccountWithThereUserMap.containsKey(accountId))
                                 allAccountWithThereUserMap.put(accountId , new List<User>());   
                              allAccountWithThereUserMap.get(accountid).add(user);              
                     }
                 }
                 return allAccountWithThereUserMap ;      
      }
      return  new Map<Id,List<User>>();
   }
   
   
   public static CM_CallLogRecordFirstNotifcationHelper createInstance(Integer notificationNo){
    if(instance == null){ 
        instance = new CM_CallLogRecordFirstNotifcationHelper(notificationNo);
    }   
    return instance;
   }

}