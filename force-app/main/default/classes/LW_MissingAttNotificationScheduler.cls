/*
	* @ Class Name 		: 	LW_MissingAttNotificationScheduler
 	* @ Description 	: 	Scheduler class for scheduling the Missing Attachment Notifications.
 	* @ Created By 		: 	Prabhakar Joshi
 	* @ Created Date	: 	23-July-2020 
*/

public class LW_MissingAttNotificationScheduler implements Schedulable{
    /* Set to hold the Ids of records which are coming from trigger and this class. */
	public  Set<Id> recordIdSet;
    /* To hold the current Date. */
    private static FINAL Date currentDay = System.today();
    
    /* Constructor */
    public LW_MissingAttNotificationScheduler(Set<Id> recordIdSet){
        this.recordIdSet = recordIdSet;
    }
    
    /* @ Execute method of Schedulable Interface. */
    public void execute(SchedulableContext sc){
        List<Trial_Witness_Request__c> recordListToSendNotification = new List<Trial_Witness_Request__c>();
        
        for(Trial_Witness_Request__c tw : [SELECT Id,Name,Date_of_Appearance__c,OrganizationName__r.Firm_Id__c,OwnerId,
                                           Owner.Email,Owner.Name,Owner.FirstName,
                                           Documents_for_Witness_Attached__c,Is_Missing_Attachments_Notification_Sent__c,
                                           General_Overview_of_Testimony_Attached__c,Proposed_Questions_Attached__c,
                                           Expected_OC_Questions_Attached__c,Brief_Case_History_Attached__c, 
                                           Discovery_Propounded_Responses_Attached__c,RecordTypeId  
                                           FROM Trial_Witness_Request__c
                                           WHERE Id IN :recordIdSet 
                                           AND Date_of_Appearance__c != NULL]){
                                               if(isDataValid(tw,NULL)){
                                                   recordListToSendNotification.add(tw);
                                               }
                                           }
        if(recordListToSendNotification.isEmpty()){
            return;
        }
        
        this.sendNotification(recordListToSendNotification);
    }
    
     /* @ Method definition to send the notification. */
    private void sendNotification(List<Trial_Witness_Request__c> filteredList){
        List<OrgWideEmailAddress> orgWideEmail = [SELECT Id,DisplayName FROM OrgWideEmailAddress 
                                                  WHERE DisplayName = 'TW: Trial Witness'];
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        List<Trial_Witness_Request__c> recordListToUpdate = new List<Trial_Witness_Request__c>();
        List<String> emailList = new List<String>();
        for(Trial_Witness_Request__c tw : filteredList){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{tw.Owner.Email}); // 'prabhakar.joshi@mcmcg.com'
            
            email.setSubject(tw.OrganizationName__r.Firm_Id__c+' Live Witness Missing Attachments');
            
            String htmlBody = 'Dear '+tw.Owner.FirstName+'<br/><br/>Your request for a Live Witness has been approved for your upcoming hearing.  If you ';
            htmlBody += 'are receiving this message, documentation is missing.<br/><br/> ';
            htmlBody += 'Please refer to the document list checkboxes within the witness request and submit any outstanding documents as soon as possible.<br/><br/>';
            htmlBody += 'Please utilize the “Question” button on the Live Witness record to create a case if you have any questions.<br/><br/>';
            htmlBody += 'Thank you in advance for your prompt response.<br/><br/>Warm Regards,<br/>Live Witness Team';
            
            email.setHtmlBody(htmlBody);
            if(!orgWideEmail.isEmpty())
                email.setOrgWideEmailAddressId(orgWideEmail[0].Id);
            emails.add(email); 
            
            if(!tw.Is_Missing_Attachments_Notification_Sent__c){
                tw.Is_Missing_Attachments_Notification_Sent__c = true;
                recordListToUpdate.add(tw);
            }
        }
        if(!Test.isRunningTest()){
            Messaging.sendEmail(emails);
        }
        Map<Id,Trial_Witness_Request__c> recordIdMap = new Map<Id,Trial_Witness_Request__c>();
        if(!recordListToUpdate.isEmpty()){
            update recordListToUpdate;
            
            recordIdMap.putAll(recordListToUpdate);
        }else{
            recordIdMap.putAll(filteredList);
        }
        
        if(!recordIdMap.keySet().isEmpty()){
            scheduleNotification(recordIdMap.keySet());
        }
        
    }
    
    /* @ Calling from  TrialWitnessRequestTriggerHelper. */
    /* @ Method definition to validate the data coming from trigger(TrialWitnessRequestTriggerHelper). */
    public static Boolean isDataValid(Trial_Witness_Request__c newRecord, Trial_Witness_Request__c oldRecord){
        Boolean isValid = true;
        Id Step3RecordTypeId = Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName().get('Live Witness Request Step III').getRecordTypeId();
        if(newRecord.recordTypeId != Step3RecordTypeId ){
            isValid = false;
        }
        if(oldRecord != NULL){
            if(oldRecord.recordTypeId == Step3RecordTypeId){
                isValid = false;
            }
        }
        
        if(newRecord.Date_of_Appearance__c == NULL || allAttachmentAdded(newRecord) || !twoWeekPriorDate(newRecord.Date_of_Appearance__c)){
            isValid = false;
        }
        return isValid;
    }
    
    /* @ Method Definition to check that all attachment submitted or not. */
    private static Boolean allAttachmentAdded(Trial_Witness_Request__c tw){
        Boolean allAttached = false;
        if(tw.Documents_for_Witness_Attached__c && tw.General_Overview_of_Testimony_Attached__c 
           && tw.Proposed_Questions_Attached__c && tw.Expected_OC_Questions_Attached__c 
           && tw.Brief_Case_History_Attached__c && tw.Discovery_Propounded_Responses_Attached__c ){
               allAttached = true;
           }
        
        return allAttached;
    }
    
    /* @ Method definition to check the currect date is 14 days prior to Date Of Appearance. */
    private static Boolean twoWeekPriorDate(Date dateOfAppearance){
        Boolean isPrior = false;
        
        if(currentDay < dateOfAppearance.addDays( -14)){
            isPrior = true;
        }
        return isPrior;
    }
    
   /* @ Method definition to schedule the process on 3rd day of current Day.  */
    @future
    public static void scheduleNotification(Set<Id> recordIdSet){
        if(recordIdSet.isEmpty()){
            return;
        }
        
        //String tm = System.now().addMinutes(2).format('h:mm');
        //Date scheduleDate = currentDay.addDays(3);
       // String cronExp = ' 0 '+tm.split(':')[1]+'  '+tm.split(':')[0]+' '+currentDay.day()+' * ? * ';
        
        Date scheduleDate = currentDay.addDays(3);
        String cronExp = ' 0 0 1 '+scheduleDate.day()+' * ? * ';
        if(!test.isRunningTest()){
            System.schedule('Live Witness Notification Scheduler '+System.now().format(), cronExp , new LW_MissingAttNotificationScheduler(recordIdSet));
        }
        
    }
}