/* ****************************************************************
* Class Name  : CM_MissingMaterialEscalationHelper
* Description : This class is the helper class of CM_MissingMaterialFirstEscalationBatch which is used to get the Call Monitoring
* 				 records(CM Materials Results 20180701 or Call Monitoring Materials or Call Monitoring Remediation recordType) 
				 with the same month and year of call Monitoring records which are coming from batch class. 
				 If the 'CM Materials Results 20180701','Call Monitoring Materials' and 'Call Monitoring Remediation' 
				 not found then it will send a notification mail to all the active community users(Contact mail). 
* Created Date: 2-July-2019
* Created By : Prabhakar Joshi
* Last Modified Date : 25-May-2020
* *******************************************************************/

public class CM_MissingMaterialEscalationHelper {
    public static List<OrgWideEmailAddress> orgWideEmail = [SELECT Id,DisplayName FROM OrgWideEmailAddress 
                                                            WHERE DisplayName = 'Firm Management'];
    public static void processData(List<Call_Monitoring__c> cmList,String processName){
        Set<String> monthSet = new Set<String>();
        Set<String> yearSet = new Set<String>();
        Set<Id> firmIdSet = new Set<Id>();
        
        Map<String,Call_Monitoring__c> cm_QAMap = new Map<String,Call_Monitoring__c>();
        Map<String,Call_Monitoring__c> cm_materialMap = new Map<String,Call_Monitoring__c>();
        
        for(Call_Monitoring__c cm : cmList){
            monthSet.add(cm.Reporting_Month_CM__c);
            yearSet.add(cm.Reporting_Year_CM__c);
            firmIdSet.add(cm.Organization_Name_CM__c);
            
            String uniqueKey = cm.Organization_Name_CM__c + '@@' + cm.Reporting_Year_CM__c + '@@' + cm.Reporting_Month_CM__c;
            cm_materialMap.put(uniqueKey, NULL);
            cm_QAMap.put(uniqueKey,cm);
        }
        System.debug('cm_materialMap>>>>>>>'+cm_materialMap);
        if(cm_materialMap.keySet().size() > 0){
            
            Set<Id> recordTypeIdSet = new Set<Id>();
            Id cm_MaterialRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('CM Materials Results 20180701').getRecordTypeId();
            recordTypeIdSet.add(cm_MaterialRecordTypeId);
            Id cm_MatRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Materials').getRecordTypeId();
            recordTypeIdSet.add(cm_MatRecordTypeId);
            Id cm_RemdRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('CM Remediation 20180701').getRecordTypeId();
            recordTypeIdSet.add(cm_RemdRecordTypeId);
            
            for(Call_Monitoring__c cm : [SELECT Id,Name,Organization_Name_CM__c,Reporting_Month_Materials__c,Reporting_Year_CM__c,
                                         Escalation_Notification_Sent__c
                                         FROM Call_Monitoring__c 
                                         WHERE RecordTypeId IN :recordTypeIdSet
                                         AND Organization_Name_CM__c IN :firmIdSet
                                         AND Reporting_Year_CM__c IN :yearSet
                                         AND Reporting_Month_Materials__c IN :monthSet]){
                                             
                                             String uniqueKey = cm.Organization_Name_CM__c + '@@' + cm.Reporting_Year_CM__c + '@@' + cm.Reporting_Month_Materials__c;
                                             if(cm_materialMap.containsKey(uniqueKey)){
                                                 cm_materialMap.put(uniqueKey,cm);
                                             }
                                         }
            List<Call_Monitoring__c> finalCMList = new  List<Call_Monitoring__c>();
            for(String key : cm_materialMap.keySet()){
                if(cm_materialMap.get(key) == NULL){
                    finalCMList.add(cm_QAMap.get(key));
                }
            }
            System.debug('testList>>>>>'+finalCMList);
            if(finalCMList.size() > 0){
                findContactList(finalCMList,processName);
            }
        }
    }
    
    /*********************** To find the contact List for send the Escalation Notification************************/
    
    private static void findContactList(List<Call_Monitoring__c> finalCMList,String processName){
        Map<Id,Call_Monitoring__c> callMonitoringMap = new  Map<Id,Call_Monitoring__c>();
        for(Call_Monitoring__c cm : finalCMList){
            callMonitoringMap.put(cm.Organization_Name_CM__c , cm);
        }
        
        if(processName != 'No Response'){
            List<Contact> contList = [SELECT Id,FirstName,Email,AccountId FROM Contact 
                                      WHERE AccountId IN :callMonitoringMap.keySet()
                                      AND Community_User__c = true
                                      AND Inactive_Contact__c = false];
            
            if(callMonitoringMap.keySet().size() > 0 && contList.size() > 0){
                if(processName == 'First Escalation'){
                    sendFirstEscalationNotification(callMonitoringMap,contList);
                }else if(processName == 'Second Escalation'){
                    sendSecondEscalationNotification(callMonitoringMap,contList);
                }
            }
        }else if(processName == 'No Response'){
            if(callMonitoringMap.keySet().size() > 0){
                sendNoResponseNotification(callMonitoringMap);
            }
        }
    }
    
    
    /******************************* To Send the First Escalation Notification ********************************/
    
    private static void sendFirstEscalationNotification(Map<Id,Call_Monitoring__c> callMonitoringMap,List<Contact> contList){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        List<Call_Monitoring__c> cmListToUpdate = new List<Call_Monitoring__c>();
        List<String> emailList = new List<String>();
        for(Contact cont : contList){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{cont.Email});
            String firmId = callMonitoringMap.get(cont.AccountId).Organization_Name_CM__r.Firm_ID__c;
            String agencyId = callMonitoringMap.get(cont.AccountId).Organization_Name_CM__r.Agency_ID__c;
            if(firmId != NULL){
                email.setSubject(firmId+' Action Required: Missing Call Monitoring Material Records – First Escalation');
            }else if(agencyId != NULL){
                email.setSubject(agencyId+' Action Required: Missing Call Monitoring Material Records – First Escalation');
            }
            String htmlBody = 'Dear '+cont.FirstName+'<br/><br/>Our Records indicate the Firm/Agency has not submitted Call Materials ';
            htmlBody += 'as requested in QA Record <a href='+label.LC_Partner_URL+callMonitoringMap.get(cont.AccountId).Id+'>'+callMonitoringMap.get(cont.AccountId).Name+'</a>. Call Materials are due within <b>3</b> ';
            htmlBody += 'calendar days of the creation of the QA record selection.<br/><br/>';
            htmlBody += 'Immediately log into the LC Partner Access Site and enter a <b>Call Monitoring Materials</b> Record for ';
            htmlBody += 'each <u>individual</u> call and attach <u>both</u> the call recording and associated account notes. <br/><br/>';
            htmlBody += 'If you have any questions regarding this process or the requirement, first reference the LC Partner Access';
            htmlBody += 'Site Procedures Manual. Email <a href = "mailto:FirmManagement@mcmcg.com">FirmManagement@mcmcg.com<a/> with any follow-up questions.<br/><br/>Firm/Agency Management';
            email.setHtmlBody(htmlBody);
            if(orgWideEmail.size() > 0)
                email.setOrgWideEmailAddressId(orgWideEmail[0].Id);
            emails.add(email);
            
            if(callMonitoringMap.get(cont.AccountId).Escalation_Notification_Sent__c){
                continue;
            }
            /* Added on 26-May-2020 to update the checbox on QA record that will identify that Escalation Notification has been sent. */
            /* Added By Prabhakar Joshi */
            Call_Monitoring__c cmToUpdate = callMonitoringMap.get(cont.AccountId);
            cmToUpdate.Escalation_Notification_Sent__c = true;
            cmListToUpdate.add(cmToUpdate);
            
        }
        if(!Test.isRunningTest())
            Messaging.sendEmail(emails);
        
        /* Added on 26-May-2020 */
        if(!cmListToUpdate.isEmpty())
            update cmListToUpdate;
    }
    
    /******************************* To Send the Second Escalation Notification ********************************/
    
    private static void sendSecondEscalationNotification(Map<Id,Call_Monitoring__c> callMonitoringMap,List<Contact> contList){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        List<String> emailList = new List<String>();
        for(Contact cont : contList){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{cont.Email});
            String firmId = callMonitoringMap.get(cont.AccountId).Organization_Name_CM__r.Firm_ID__c;
            String agencyId = callMonitoringMap.get(cont.AccountId).Organization_Name_CM__r.Agency_ID__c;
            if(firmId != NULL)
                email.setSubject(firmId+' Action Required: Missing Call Monitoring Material Records – Final Escalation');
            else if(agencyId != NULL)
                email.setSubject(agencyId+' Action Required: Missing Call Monitoring Material Records – Final Escalation');
            String htmlBody = 'Dear '+cont.FirstName+'<br/><br/>Our Records indicate the Firm/Agency has not submitted Call Materials ';
            htmlBody += 'as requested in QA Record <a href='+label.LC_Partner_URL+callMonitoringMap.get(cont.AccountId).Id+'>'+callMonitoringMap.get(cont.AccountId).Name+'</a>. These items are now <b><u>past due</u>.</b><br/><br/> ';
            htmlBody += 'Immediately log into the LC Partner Access Site and enter a <b>Call Monitoring Materials</b> Record for ';
            htmlBody += 'each <u>individual</u> call and attach <u>both</u> the call recording and associated account notes.<br/><br/>';
            htmlBody += 'It is critical the Firm/Agency submit requested Call Materials in an accurate and timely manner. As a reminder, ';
            htmlBody += 'Call Materials are due within 3 calendar days of the creation of the QA record.<br/><br/>';
            htmlBody += 'If you have any questions regarding this process or the requirement, first reference the LC Partner Access ';
            htmlBody += 'Site Procedures Manual. Email <a href = "mailto:FirmManagement@mcmcg.com">FirmManagement@mcmcg.com</a> with any follow-up questions.<br/><br/>Firm/Agency Management';
            email.setHtmlBody(htmlBody);
            if(orgWideEmail.size() > 0)
                email.setOrgWideEmailAddressId(orgWideEmail[0].Id);
            emails.add(email); 
        }
        Messaging.sendEmail(emails);
    }
    
    /******************************* To Send the No Response Notification ********************************/
    
    private static void sendNoResponseNotification(Map<Id,Call_Monitoring__c> callMonitoringMap){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        List<String> emailList = new List<String>();
        for(Call_Monitoring__c cm : callMonitoringMap.values()){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{cm.Organization_Name_CM__r.Owner.Email,cm.Organization_Name_CM__r.FM_Process_Manager__r.Email}); //'prabhakar.joshi@mcmcg.com'
            String firmId = cm.Organization_Name_CM__r.Firm_ID__c;
            String agencyId = cm.Organization_Name_CM__r.Agency_ID__c;
            if(firmId != NULL)
                email.setSubject(firmId+' Follow-Up Required: Missing Call Monitoring Material Records – No Response from Firm/Agency');
            else if(agencyId != NULL)
                email.setSubject(agencyId+' Follow-Up Required: Missing Call Monitoring Material Records – No Response from Firm/Agency');
            String htmlBody = 'Dear '+cm.Organization_Name_CM__r.Owner.FirstName+'/'+cm.Organization_Name_CM__r.FM_Process_Manager__r.FirstName+'<br/><br/> ';
            htmlBody += 'Please be advised your Firm/Agency has not submitted Call Materials ';
            htmlBody += 'as requested in QA Record <a href='+label.Internal_URL+cm.Id+'>'+cm.Name+'</a> after <u><b>3 requests</b></u>.<br/><br/> ';
            htmlBody += 'The Firm/Agency  is at risk of not having Calls Scored for '+cm.Reporting_Month_CM__c+'-'+cm.Reporting_Year_CM__c +'. Please follow-up with ';
            htmlBody += 'the Firm/Agency to ensure submission of the required materials.<br/><br/>';
            htmlBody += 'As a reminder, Call Materials are due within <b>3</b> calender days of the creation of the QA record selection.<br/><br/>';
            htmlBody += 'If you have any questions Email <a href = "mailto:FirmManagement@mcmcg.com">FirmManagement@mcmcg.com<a/>.<br/><br/>Thank you,<br/>LO QA Team';
            email.setHtmlBody(htmlBody);
            if(orgWideEmail.size() > 0)
                email.setOrgWideEmailAddressId(orgWideEmail[0].Id);
            emails.add(email); 
        }
        Messaging.sendEmail(emails);
    }
}