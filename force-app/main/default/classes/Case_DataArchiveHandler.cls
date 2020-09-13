/*
	* @ Class Name  	: 	Case_DataArchiveHandler
	* @ Description 	: 	Handler Class for Case_DataArchiveBatch Class.
	* @ Created By  	: 	Prabhakar Joshi
    * @ Created Date	: 	15-July-2020
*/

public class Case_DataArchiveHandler {
    /* To hold the date of 18 months before */
    public static FINAL Date eighteenMonthBeforeDate = System.today().addMonths( - 18);
    /* To hold the LC Admin Email Id to send the notification after Data Archived. */
    public static FINAL String LCAdminEmail = 'lcsalesforceadmin@mcmcg.com';
    
    /* @ Method Definition to get the list of Case records. */
    /* @ Calling from Case_DataArchiveBatch & DataArchiveReportController.*/
    public List<Case> getCaseRecords(Integer limitSelected){
        Set<Id> recordTypeIdSet = this.getCaseRecordTypeIdSet();
        if(recordTypeIdSet.isEmpty()){
            return new List<Case>();
        }
        
        List<Case> caseList = new List<Case>();
        for(Case cs : [SELECT Id,RecordType.Name,Status,LastmodifiedDate,
                       (SELECT Id  FROM EmailMessages WHERE LastModifiedDate < :eighteenMonthBeforeDate),
                       (SELECT Id FROM Attachments WHERE LastModifiedDate < :eighteenMonthBeforeDate)
                       FROM Case 
                       WHERE Status = 'Closed' AND RecordTypeId IN : recordTypeIdSet 
                       AND ((Data_Archived_Date__c != NULL AND Data_Archived_Date__c < :eighteenMonthBeforeDate) 
                            OR(Data_Archived_Date__c = NULL AND LastmodifiedDate < :eighteenMonthBeforeDate))
                       ORDER BY LastmodifiedDate
                       LIMIT :limitSelected]){
                           
                           if(cs.Attachments.size() > 0 || cs.EmailMessages.size() > 0){
                               caseList.add(cs);
                           }
                       }
       return caseList;
    }
    
    /* @ Method Definition to get the Record Type Ids of Case. */
    /* @ Calling from getCaseRecords method.*/
    private Set<Id> getCaseRecordTypeIdSet(){
        Set<Id> recordTypeIdSet = new Set<Id>();
        for(RecordType rt : [SELECT Id,Name,SobjectType 
                             FROM RecordType 
                             WHERE SobjectType = 'Case' 
                             AND Name IN ('Operations', 'Operations - AA', 'Operations - ACF', 'Operations - Account Inquiry', 'Operations - CAO', 'Operations - IR', 'Operations - PAM', 'Operations - QA Case', 'Operations - YGC Reject Report')]){
                                 recordTypeIdSet.add(rt.Id);
                             }
        return recordTypeIdSet;
    }
    
    
    /* @ Method Definition to to update the case records which has been processed. */
    /* @ Calling from Case_DataArchiveBatch. */
    public void updateCaseRecord(Set<Id> caseIdSet){
        List<Case> caseListToUpdate = new List<Case>();
        for(Id csId : caseIdSet){
            Case cs = new Case();
            cs.Id = csId;
            cs.Data_Archived_Date__c = System.today();
            caseListToUpdate.add(cs);
        }
        if(!caseListToUpdate.isEmpty()){
            update caseListToUpdate;
        }
    }
    
    /* @ Method definition to send the email notification with Number of deleted Attachments */
    /* @ Calling from Case_DataArchiveBatch. */
	public void sendNotificationAfterAttachmentDelete(Integer deleteCount,Integer failCount,Map<Id,String> recordIdToErrorMap, String subject){
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		email.setSubject(subject);
		String htmlBody = deleteCount + ' Attachment / EmailMessage record has been deleted from Case Records.<br/><br/>';
        
        if(failCount > 0){
            htmlBody += failCount + ' Attachment deletion has been failed. The Details are as follows -<br/><br/>'; 
            htmlBody += '<table border="1" cellspacing="2" cellpadding="5">';
            htmlBody += '<thead><tr><th>Record Id</th><th>Error</th></tr></thead><tbody>';
            
            for(Id recId : recordIdToErrorMap.keySet()){
                htmlBody += '<tr><td>'+recId+'</td><td>'+recordIdToErrorMap.get(recId)+'</td></tr>';
            }
            htmlBody += '</tbody></table>';
        }
		email.setHtmlBody(htmlBody);
		email.toaddresses = new List<String>{LCAdminEmail};
        
		if (!test.isRunningTest())
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
	}
}