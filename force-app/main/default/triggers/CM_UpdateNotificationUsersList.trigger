/*
##############################################################################################################################################
# Project Name..........: LO - Call Monitoring  
# File..................: Class : "Utility" Trigger: CM_UpdateNotificationUsersList
# Version...............: 1.0
# Created by............: Sunny Kumar   
# Created Date..........: 03-Mar-2016                      
# Description...........: This trigger will send notification to all Active Firm/Organization users whenever a Call Montioring QA record type record has been inserted and updated by owner. The content will be send by code only.
# Last Modified By......: sakshi Gandhi
# Last Modified date....: 4-4-2016
# Description...........:a) Update Notification template text.
:b) Update code for QA notificationto address each individual user who will recieve the notification.
# Last Modified by......: Shivangi Srivastava
# Last Modified Date....: 27-Jun-2019    
# Description...........:a) Update Notification template text.
:b) Update code for QA notificationtion so that attachment should not be sent with an email.
##############################################################################################################################################
*/

trigger CM_UpdateNotificationUsersList on Call_Monitoring__c (before Update) {//before insert
    
    // List to capture record
    List<Call_Monitoring__c> lstCallMonitoring= new List<Call_Monitoring__c>();
    
    lstCallMonitoring.add(Trigger.new[0]); // to send mail on one record only not work for bulk
    
    
    Map<ID,ID> mapCallMonitoringWithFirm = new Map<ID,ID>(); // call monitoring id as a key and account id as values 
    List<ID> CMlst =new List<ID>(); 
    string emailIdUSer;
    String CM_Month = '';
    String CM_Year = '';
    String CM_Name = '';
    String CM_Id = '';
    
    Map<Id, Account> cmOrgMap = new Map<Id, account>();
    Map<ID,List<Attachment>> mapCMWithAttachments =new Map<ID,List<Attachment>>(); 
    for(Call_Monitoring__c CM:lstCallMonitoring){
        CM_Month = CM.Reporting_Month_CM__c;
        CM_Year = CM.Reporting_Year_CM__c;
        CM_Name = CM.Name;
        CM_Id = CM.Id;
       
        
        if(Utility.getCMRecordType(CM.RecordTypeID).contains('QA') !=null &&
           Utility.getCMRecordType(CM.RecordTypeID).contains('QA') && CM.Attachments__c             
           && (CM.CM_Org_Month_Year_del__c != Trigger.oldMap.get(CM.Id).CM_Org_Month_Year_del__c
               || CM.Most_Recent_Attachment_Date__c != Trigger.oldMap.get(CM.Id).Most_Recent_Attachment_Date__c)) 
            
            mapCallMonitoringWithFirm.put(CM.ID,CM.Organization_Name_CM__c);   
        
        cmOrgMap.put(CM.Organization_Name_CM__c, null);
        CMlst.add(CM.ID);      // put all call monitoring id here  
    }
    if(!mapCallMonitoringWithFirm.isEmpty()){ 
        String TWUserProfileName = Utility.getTrialWitnessProfileLabel();   
        Map<ID,List<String>> mapOrgAndActiveReceivers = new Map<ID,List<String>>(); // map of account id with related email ids of string 
        Map<string,string> mapOrgAndActiveReceiversName = new Map<string,string>(); 
        Map<ID,List<String>> mapUserName  = new Map<ID,List<String>>(); // account id key associated with there name and email as value
        
        for(User u:[SELECT AccountId,Email,UserName,FirstName,Id,IsActive,IsPortalEnabled,LastName,ManagerId,Name,
                    ProfileId,Profile.Name FROM User where AccountId =: mapCallMonitoringWithFirm.Values()
                    and IsActive=true and Profile.Name!=:TWUserProfileName]){
                        
                        
                        if(!mapOrgAndActiveReceivers.containsKey(u.AccountId)){
                            mapOrgAndActiveReceivers.put(u.AccountId,new list<String>{String.ValueOF(u.Email)});
                            mapUserName.put(u.AccountId,new list<String>{String.ValueOF(u.userName)+','+String.ValueOF(u.Email)});
                        } 
                        else{
                            mapOrgAndActiveReceivers.get(u.AccountId).add(String.ValueOF(u.Email)); 
                            mapUserName.get(u.AccountId).add(String.ValueOF(u.username)+','+String.ValueOF(u.Email));        
                        } 
                        
                        mapOrgAndActiveReceiversName.put(u.UserName+','+u.email,u.FirstName);
                        
                    }
        
        if(!mapOrgAndActiveReceivers.isEmpty()){
            mapCMWithAttachments.put(CMlst[0],new list<Attachment>([
                SELECT Body,BodyLength,ContentType,CreatedById,CreatedDate,Description,Id,IsDeleted,
                LastModifiedById,LastModifiedDate,Name,OwnerId,ParentId 
                FROM Attachment where ParentId IN: mapCallMonitoringWithFirm.Keyset()
            ]));
        }  
        
        /************Account Map*******************/
        for(Account acc : [select Firm_ID__c from Account where ID IN:cmOrgMap.keySet()]){
            cmOrgMap.put(acc.Id, acc);
        }
        
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'firmmanagement@mcmcg.com'];
        for(Call_Monitoring__c CM : lstCallMonitoring){
            if(Utility.getCMRecordType(CM.RecordTypeID).contains('QA') && CM.Attachments__c)
            {
                if(CM.Organization_Name_CM__c!=null && mapOrgAndActiveReceivers.containsKey(CM.Organization_Name_CM__c))
                {
                    List<String> emailst = mapOrgAndActiveReceivers.get(CM.Organization_Name_CM__c);
                    List<String> userlst = mapUserName.get(CM.Organization_Name_CM__c); 
                    CM.CM_Notification_Receiver__c ='';
                    
                    for(String s: emailst) 
                        
                        CM.CM_Notification_Receiver__c +=s+',';            
                    
                    String s =CM.CM_Notification_Receiver__c;
                    CM.CM_Notification_Receiver__c= s.removeEnd(','); 
                    s= s.removeEnd(',');
                    
                    List<String> emailIdsList = new List<String>();
                    for(String s1: s.split(','))                    
                        emailIdsList.add(s1.trim()); 
                    
                    //.................Get API NAME OF ALL Account Number + Call Date FIELDS.............
                    String type='Call_Monitoring__c';
                    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                    Schema.SObjectType leadSchema = schemaMap.get(type);
                    Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                    List<String> lstAccountAPI = new List<String>();
                    List<String> lstCallDate = new List<String>();
                    
                    for (String fieldName : fieldMap.keySet()){                     
                        if(fieldMap.get(fieldName).getDescribe().getLabel().contains('Account Number')){
                            if(fieldName!='Account_Number_CM__c') //Account_Number_CM__c
                                lstAccountAPI.add(fieldName);
                        }   
                        if(fieldMap.get(fieldName).getDescribe().getLabel().contains('Call Date'))
                            lstCallDate.add(fieldName);
                    }
                    
                    lstAccountAPI.sort();lstCallDate.sort();
                    map<String,String> mapaccountCallDate =new map<String,String>();
                    integer k;
                    String getTemplateField;
                    Map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();  
                    Schema.sObjectType sObjType = globalDescription.get('Call_Monitoring__c');  
                    sObject sObjectToBind = sObjType.newSObject(); 
                    System.debug('sObjectToBind --==  '+sObjectToBind);
                    sObjectToBind = CM; // assign the CM Variable to SObject
                    for(k=0;k<lstAccountAPI.size();k++){
                        mapaccountCallDate.put(lstAccountAPI[k],lstCallDate[k]);                        
                        
                        String accountNumber = String.ValueOf(sObjectToBind.get(String.ValueOf(lstAccountAPI[k])));
                        String CallDate = String.ValueOf(sObjectToBind.get(String.ValueOf(lstCallDate[k])));
                       
                        if(CallDate!=null) 
                            CallDate =Date.ValueOf(CallDate).format();
                        else
                            CallDate =null;
                        if(accountNumber!='' && accountNumber!=null)
                            getTemplateField+='Account#: '+accountNumber+','+' Date: '+CallDate+ '<br/>';
                    } 
                    
                    // Create mailBody to send to all recepients
                    string ContactName = null; 
                    List<String> emailIdsList1 = new List<String>();
                    for(string email1 : userlst){ 
                        string lengthbeforeEmail = email1.substring(0, email1.indexOf(',')); 
                        string email2 = '';
                        if(email1.contains(',')){
                            email2 = email1.remove(lengthbeforeEmail + ','); 
                        }else{
                            email2 = email1.remove(lengthbeforeEmail);
                        }
                        if(email2.length()>2)
                        emailIdsList1.add(email2);
                        //emailIdsList1.add('shivangisrs1220@gmail.com');
                        if(email2.length()==1)
                            //emailIdsList1.add('shivangi9320@gmail.com');
                           emailIdsList1.add(lengthbeforeEmail);
                        
                        if(mapOrgAndActiveReceiversName.Containskey(email1)){
                            ContactName = mapOrgAndActiveReceiversName.get(email1);
                        }
                        
                        
                        
                        
                        // creating message here to send email text
                        
                       /* String mailBody = 'Dear ' + ContactName+ ':'+ '<br/><br/>';                    
                        mailBody = mailBody + 'The attached report contains the collection calls from your Firm/Agency selected for QA review.'+'<br/><br/>'; 
                        if(getTemplateField!=null)
                            mailBody = mailBody+getTemplateField.removeStart('null')+ '<br/>';                    
                            mailBody = mailBody +
                            
                            'Please log into the Consumer Inquiries System (CIS) and enter a <b>Call Monitoring Materials</b> record for each call and attach the call recording and account notes.<br/><br/>'+'Please contact FirmManagement@mcmcg.com  with any questions or concerns'+ '<br/><br/>'+'Firm/Agency Management Teams'+'<br/><br/>';                    
                        */
                        
                        // Updated text of email body - 28/6/2019
                        String mailBody = 'Dear ' + ContactName+ ':'+ '<br/><br/>';                    
                        mailBody = mailBody + 'A list of the collection calls selected for ' + CM_Month + ' - ' + CM_Year + ' QA Review are now accessible in the Record '+ CM.Name + ' attachment.' +'<br/><br/>'
                                                +'<a href = "https://full-encorecapitalgroup.cs95.force.com/LCPartnerAccess/'+CM_Id+ '"> '+CM.Name+' </a>' + '<br/><br/>';
                        mailBody = mailBody +
                            
                           'Call Materials are due within <b> 3 </b> calendar days of the creation of the QA record selection.<br/><br/>'+'Please log into the LC Partner Access Site and enter a <b>Call Monitoring Materials</b> Record for each <u>individual</u> call and attach <u>both</u> the call recording and associated account notes.<br/><br/>'+ 'If you have any questions regarding this process or the requirement, first reference the LC Partner Access Site Procedures Manual.  Email FirmManagement@mcmcg.com with any follow-up questions.<br/><br/>'+'Firm/Agency Management Teams'+'<br/><br/>';                    
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        if ( owea.size() > 0 ) {
                            mail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }     
                        System.debug('********************sending email****************');
                                       
                        mail.setSaveAsActivity(false); 
                        mail.setToAddresses(emailIdsList1);
                        //email.setToAddresses(new List<String>{emailIdsList1});
                        String[] replyToAddresses = new String[] {'FirmManagement@mcmcg.com'};
                        //String[] replyToAddresses = new String[] {'shivangisrs1220@gmail.com'};    
                        mail.setReplyTo(replyToAddresses[0]);
                        mail.setPlainTextBody('Hello');
                        mail.setHtmlBody(mailBody);
                        mail.setSubject(cmOrgMap.get(lstCallMonitoring[0].Organization_Name_CM__c).Firm_ID__c+'Action Required : Call Monitoring Materials Submission');
                        mail.setUseSignature(false); 
                        /*
                            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                            for (Attachment a : mapCMWithAttachments.get(CMlst[0]))//[select Name, Body, BodyLength from Attachment where ParentId = :temp.Id]
                            {
                            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                            efa.setFileName(a.Name);
                            efa.setBody(a.Body);
                            fileAttachments.add(efa);
                            }
                            mail.setFileAttachments(fileAttachments);
                         */
                        if(!test.isrunningTest()){          
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        }
                    }
                }
            }
        }
   }   
}