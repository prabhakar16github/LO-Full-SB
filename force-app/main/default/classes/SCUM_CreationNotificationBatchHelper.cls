public class SCUM_CreationNotificationBatchHelper{

    public static void sendSCMDUMEmailFuture(Set<Id> pamIdsSet, String processType,Set<Id> pamObjIdSet){
    
        List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
        Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccountId = new Map<Id, List<Process_Adherence_Monitoring__c>>();
        Map<Id, List<PAM_Unmatched__c>> scmdUmListByAccountId = new Map<Id, List<PAM_Unmatched__c>>();
        Map<Id, Account> accountByAccountId = new Map<Id, Account>();
        List<PAM_Unmatched__c> recordsToUpdate = new List<PAM_Unmatched__c>(); 

        List<Process_Adherence_Monitoring__c> pamList = getPamList(pamIdsSet); 
        if(!pamList.isEmpty()){
            mapValuesByAccount(pamListByAccountId, scmdUmListByAccountId, pamList);
        }
        accountByAccountId = getAccountRecordsSCMDMap(pamListByAccountId.keySet()); 
        
        OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'lcsalesforceadmin@mcmcg.com'];
        List<Process_Adherence_Monitoring__c> pamTempUpdate = new List<Process_Adherence_Monitoring__c>();
        for( Id accountId : accountByAccountId.keySet() ){
            List<String> address = new List<String>();
            List<AccountContactRelation> accountContactRelationList = accountByAccountId.get(accountId).AccountContactRelations;
            List<Process_Adherence_Monitoring__c> pamTempList = new List<Process_Adherence_Monitoring__c>(); 
            if( pamListByAccountId.containsKey(accountId) ){
                pamTempList = pamListByAccountId.get(accountId);
            }
              

          for( Process_Adherence_Monitoring__c pamObj : pamTempList ){

                for( AccountContactRelation accountContactRelationObj : accountContactRelationList ){

                    Messaging.SingleEmailMessage mail = createMailForSCMUnmatchedRecords(accountContactRelationObj.Contact.Email, 
                                                                                        accountByAccountId.get(accountId).Firm_ID__c,
                                                                                        pamObj, 
                                                                                        accountContactRelationObj.Contact.firstName,
                                                                                        accountContactRelationObj.Contact.Community_User__c,
                                                                                        processType, owea.get(0));
                    sentMailToContactList.add(mail);            
                }
               pamObj.Batch_SCUM_Notification_Sent_Flag__c = true; 
               pamTempUpdate.add(pamObj);
               pamObjIdSet.add(pamObj.id);
            } 
            
            for(PAM_Unmatched__c scmdUmObj : scmdUmListByAccountId.get(accountId)){
                scmdUmObj.SCMDUM_Record_Creation_Notification_Sent__c = true;
                recordsToUpdate.add(scmdUmObj);
            }
        }
        Messaging.sendEmail(sentMailToContactList);
        
        if(!recordsToUpdate.isEmpty()){
            update recordsToUpdate;
        }
        
        if(pamTempUpdate.size() > 0){
          update pamTempUpdate ;
        }
        
    
    }
    
     private static List<Process_Adherence_Monitoring__c> getPamList(Set<Id> pamIdsSet){
        
        List<Process_Adherence_Monitoring__c> pamList = [SELECT Id, Name, Batch_SCUM_Notification_Sent_Flag__c,SCMD_Day_Counter__c, Organization_Name__c, Organization_Name__r.Name,
                                                            (SELECT Id, Name, SCMDUM_Record_Creation_Notification_Sent__c From PAM_Unmatched__r 
                                                                WHERE SCMDUM_Record_Creation_Notification_Sent__c != true),    
                                                            SCMD_Reporting_Period__c FROM Process_Adherence_Monitoring__c
                                                            WHERE Id IN :pamIdsSet and Batch_SCUM_Notification_Sent_Flag__c=false]; 
        
        return pamList;
        
    }
    
     private static void mapValuesByAccount(Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccountId, 
                                                Map<Id, List<PAM_Unmatched__c>> pamUmListByAccountId, 
                                                List<Process_Adherence_Monitoring__c> pamList){
        
        for(Process_Adherence_Monitoring__c pamObj : pamList){ // put values in pamListByAccountId & scmdUmListByAccountId
            
            if( pamObj.PAM_Unmatched__r != null ){ // put only those values who have umRecords
                
                
                if( pamListByAccountId.containsKey(pamObj.Organization_Name__c) ){
                
                    List<Process_Adherence_Monitoring__c> pamTempList = pamListByAccountId.get(pamObj.Organization_Name__c);
                    pamTempList.add(pamObj);
                    
                    pamListByAccountId.put(pamObj.Organization_Name__c, pamTempList);
                
                }else{
                    
                    pamListByAccountId.put(pamObj.Organization_Name__c, new List<Process_Adherence_Monitoring__c>{pamObj});
                } 
                
                if( pamUmListByAccountId.containskey(pamObj.Organization_Name__c) ){
                    
                    List<PAM_Unmatched__c> pamUmTempList = pamUmListByAccountId.get(pamObj.Organization_Name__c);
                    pamUmTempList.addAll(pamObj.PAM_Unmatched__r);
                    
                    pamUmListByAccountId.put(pamObj.Organization_Name__c, pamUmTempList);
                
                }else{
                    
                    pamUmListByAccountId.put(pamObj.Organization_Name__c, pamObj.PAM_Unmatched__r);
                }
                
            }
                
        }
    }
    
    
    private static Map<Id, Account> getAccountRecordsSCMDMap(Set<Id> accountIdSet){
        
        Map<Id, Account> accountByAccountId = new Map<Id, Account>([SELECT Id, Name, Firm_ID__c, 
                                                                        (SELECT Id, ContactId, Contact.firstName, Contact.Email,  
                                                                            Contact.Community_User__c 
                                                                        FROM AccountContactRelations 
                                                                        WHERE Contact.Contact_Type_SME__c INCLUDES('Process Adherence Monitoring (PAM)') 
                                                                        AND Contact.Inactive_Contact__c = FALSE) 
                                                                    FROM Account 
                                                                    WHERE Id IN : accountIdSet]);
                                                                    
        return accountByAccountId;
        
    }
    
     public static Messaging.SingleEmailMessage createMailForSCMUnmatchedRecords(String contactEmail, String firmId,
                                                                                Process_Adherence_Monitoring__c pamObj, String contactName,
                                                                                Boolean isCommunityUser,
                                                                                String processType, OrgWideEmailAddress owAddress){
                                                                            
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{contactEmail});
        if(processType == 'SCMD-LO'){
            mail.setSubject(firmId + ' Monthly SCM Unmatched YGC ' + pamObj.SCMD_Reporting_Period__c );
            mail.setHtmlBody(SCMDEmailCommunicationTemplates.getSCMDUnmatchedOnCreateTemplate(pamObj, contactName, isCommunityUser));
        }else{
            mail.setSubject(firmId + ' ACF Monthly Dispute SCM Unmatched ' + pamObj.SCMD_Reporting_Period__c );
            mail.setHtmlBody(SCMDEmailCommunicationTemplates.getSCMDUnmatchedACFOnCreateTemplate(pamObj, contactName, isCommunityUser));
        }
        if(owAddress != null ){
            mail.setOrgWideEmailAddressId(owAddress.Id);
        }
        mail.setReplyTo('lcsalesforceadmin@mcmcg.com');
        return mail;
        
    }
    
    
    
}