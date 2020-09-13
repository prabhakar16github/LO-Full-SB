public class CM_CallLogRecordCreationBatchHelper{

   public static CM_CallLogRecordCreationBatchHelper instance = null;
   public Map<Id,Contact> allContactRelatedToAccountMap;
   private CM_CallLogRecordCreationBatchHelper(){}
   
   public void executeBatch(List<Account> accountInfosList){
      if(accountInfosList != null && accountInfosList.size() >0){
          Map<Id,Account> accountInfosMap = new Map<Id,Account>(accountInfosList);
          
           allContactRelatedToAccountMap = new Map<Id,Contact>([SELECT Id,Name,accountid,email from contact where Community_User__c=true and accountid 
                                                          In : accountInfosMap.keySet()]);
                                                          
                 if(allContactRelatedToAccountMap != null && allContactRelatedToAccountMap.size() > 0){
                    Map<Id,List<User>> allAccountWithThereUserMap = new Map<Id,List<User>>();
                     for(user user : [select id , name,contactId,email,firstname  from user where contactId In : allContactRelatedToAccountMap.keyset() 
                                             AND Profile.Name='CC - User Access' AND isActive=true]){
                              Id accountId =  allContactRelatedToAccountMap.get(user.contactId).accountId;
                              if(!allAccountWithThereUserMap.containsKey(accountId))
                                 allAccountWithThereUserMap.put(accountId , new List<User>());   
                              allAccountWithThereUserMap.get(accountid).add(user);              
                     }
                     createCallLogRecord(accountInfosMap , allAccountWithThereUserMap);
                 }                                            
      }
   }
   
   private void createCallLogRecord(Map<Id,Account> accountInfosMap , Map<Id,List<User>> allAccountWithThereUserMap){
       List<user> systemAdminUser = [select id, name, profile.name from user where name = 'system administrator' and profile.name='system administrator' and isactive=true];
       Id firmRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Log').getRecordTypeId();
       List<Call_Monitoring__c> callMonitoringInfosList = new List<Call_Monitoring__c>();
       for(Id acc : accountInfosMap.keyset()){
           Call_Monitoring__c cm = new Call_Monitoring__c();
           cm.RecordTypeId = firmRecordTypeId ;
           cm.Organization_Name_CM__c = acc;
           cm.Account_Type_CM__c = 'MCM';
           Integer num_Month = date.today().month();
           if(num_Month == 1){
            cm.Reporting_Month_CM__c = '12';
           cm.Reporting_Year_CM__c = String.valueOf(date.today().year()-1); // current year in number
           }else if(num_Month < 10){
            cm.Reporting_Month_CM__c = '0'+String.valueOf(date.today().month()-1); // current month in number because call log are created for previous month
            cm.Reporting_Year_CM__c = String.valueOf(date.today().year()); // current year in number
           }else{
            cm.Reporting_Month_CM__c = String.valueOf(date.today().month()-1);
            cm.Reporting_Year_CM__c = String.valueOf(date.today().year()); // current year in number
           }
           
           if(allAccountWithThereUserMap.containsKey(acc) && allAccountWithThereUserMap.get(acc).size() > 0)
               cm.ownerid = allAccountWithThereUserMap.get(acc)[0].id;
           else 
               cm.ownerid = systemAdminUser[0].id; 
           callMonitoringInfosList.add(cm);
       }
         if(callMonitoringInfosList.size() > 0){
           try{
           insert callMonitoringInfosList ;
           }catch(Exception e){
           System.debug('-------Exception error ----------'+e.getMessage());
           }
           sendEmailFollowUpNotification(callMonitoringInfosList , allAccountWithThereUserMap);
         }
   }
   
   public void sendEmailFollowUpNotification(List<Call_Monitoring__c> callMonitoringInfosList , Map<Id,List<User>> allAccountWithThereUserMap){
     Map<Id,Call_Monitoring__c> tempCallMonitor = new Map<Id,Call_Monitoring__c>(callMonitoringInfosList);
     Map<Id,Call_Monitoring__c> callMonitoringGroupMap = new Map<Id,Call_Monitoring__c>();
     string subjectStr = 'Action Required: Call Monitoring Log Attachment ';
     for(Call_Monitoring__c cm : [select id , name,Organization_Name_CM__c ,Account_Type_CM__c , Reporting_Year_CM__c , Reporting_Month_CM__c , ownerid  from Call_Monitoring__c
                                     where id IN : tempCallMonitor.keyset()]){
       if(cm.Organization_Name_CM__c  != null) callMonitoringGroupMap.put(cm.Organization_Name_CM__c , cm);
     }
     Map<Id,Account> accountInfosMap = new Map<Id,Account>([SELECT id , name,Agency_ID__c,Firm_ID__c
                                                              from account where id In :callMonitoringGroupMap.keySet()]);
                                                              
        List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
        List<network> ll = [select id , name,UrlPathPrefix ,status from network where name='LC Partner Access'];
                String networkLoginUrl = Network.getLoginUrl(ll[0].id).trim().removeEndIgnoreCase('login');
        for(Id accid : allAccountWithThereUserMap.keyset()){
            for(user user : allAccountWithThereUserMap.get(accid)){
              Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                emailToSend.setToAddresses(new List<String>{allContactRelatedToAccountMap.get(user.contactid).email});
                String monthstr = callMonitoringGroupMap.containsKey(accid) ? callMonitoringGroupMap.get(accid).Reporting_Month_CM__c : ''; 
                String yearStr = callMonitoringGroupMap.containsKey(accid) ? callMonitoringGroupMap.get(accid).Reporting_Year_CM__c: '';
                String firmName = accountInfosMap.containsKey(accid) ? (accountInfosMap.get(accid).Agency_ID__c != null ? accountInfosMap.get(accid).Agency_ID__c : (accountInfosMap.get(accid).Firm_ID__c!= null ? accountInfosMap.get(accid).Firm_ID__c: '')) : '';
                String substr= firmName + ' '+ subjectStr ;
                emailToSend.setHTMLBody(emailTemplateInitialNotification(user.firstname,monthstr +'/'+yearStr,networkLoginUrl ,callMonitoringGroupMap.get(accid)));
                emailToSend.setSubject(substr);
                lstMsgsToSend.add(emailToSend);
            }
        }
        
        try{
          Messaging.sendEmail(lstMsgsToSend);
        }catch(Exception e){
          system.debug('error message ---'+e.getMessage());
        }
   }
   
   public String emailTemplateInitialNotification(String communityUserName,String monthyear,String recordlinkUrl,Call_Monitoring__c cm){
      String body ='Hello '+ communityUserName +':<br/><br/>';
             body += 'This is a reminder that Call Monitoring Log information on all MCM accounts is due by the third calendar day of the month.';
             String cmUrlName = '<a href="'+recordlinkUrl+''+cm.id+'">'+cm.Name+'</a>';
             body += ' Please access '+cmUrlName+' or the LC Partner Access Site and take the following actions:';
             body +='<br/><br/>';
             
             body += '<b>CALL MONITORING REPORTING (MCM Only):</b><br/>';
             
             body += '• If your Firm/Agency made any collection calls on MCM accounts in '+monthyear;
             body += ', attach a <b>Call Log</b> containing relevant call data to the Call Monitoring Log Record on the LC Partner Access Site.<br/>';
             
             body += '•  If your Firm/Agency did not make any collection calls on MCM accounts in '+ monthyear;
             body += ', access the <b>Call Monitoring Log</b>, record '+cmUrlName+', on the LC Partner Access Site and check the “No Calls This Month” box indicating there were no collection calls made by the Firm/Agency.<br/>';
             
             body +='<br/>If you have any questions regarding this process or the requirement, first reference the LC Partner Access Site Procedures Manual.  Email <a> FirmManagement@mcmcg.com </a> with any follow-up questions.';
             body +='<br/><br/>';
             body +='Firm/Agency Management';
             
     return body;
   }
   
   public static CM_CallLogRecordCreationBatchHelper createInstance(){
     if(instance == null) instance = new CM_CallLogRecordCreationBatchHelper();
     return instance;
   } 

}