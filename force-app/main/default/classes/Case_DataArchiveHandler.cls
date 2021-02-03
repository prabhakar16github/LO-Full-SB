/*
 * @ Class Name      :     Case_DataArchiveHandler
 * @ Description     :     Handler Class for Case_DataArchiveBatch Class.
 * @ Created By      :     Prabhakar Joshi
 * @ Created Date    :     15-July-2020
 * @ Last Modified   :     19-Jan-2021
 */
public class Case_DataArchiveHandler{
	/* To hold the date of 18 months before */
	public static FINAL Date eighteenMonthBeforeDate = System.today().addMonths(-18);
	
	public static FINAL Set<Id> recordTypeIdSet = getCaseRecordTypeIdSet();

	/* @ Method Definition to get the list of Case records. */
	/* @ Calling from Case_DataArchiveBatch & DataArchiveReportController.*/
	public List<Attachment> getCaseAttachments(){

		if (recordTypeIdSet.isEmpty()){
			return new List<Attachment>();
		}

		List<Attachment> attList = [SELECT Id, ParentId
		                            FROM Attachment
		                            WHERE ParentId IN (SELECT Id
		                                               FROM Case
		                                               WHERE Status = 'Closed' AND RecordTypeId IN :recordTypeIdSet AND Contact.Inactive_Contact__c = false AND LastmodifiedDate < :eighteenMonthBeforeDate) AND LastModifiedDate < :eighteenMonthBeforeDate
		                            ORDER BY LastmodifiedDate
		                            LIMIT 50];

		return attList;
	}

	public Map<String,Integer> getCaseDataCountMap(){

		
        Map<String, Integer> dataMap = new Map<String, Integer>{'Attachment' => 0, 'EmailMessage' => 0};
        for(String objType : dataMap.keySet()){
            String query = 'SELECT COUNT(Id) dataCount FROM '+objType+' WHERE ParentId IN ';
            query += '(SELECT Id FROM Case WHERE Status = \'Closed\' AND RecordTypeId IN :recordTypeIdSet AND Contact.Inactive_Contact__c = false AND LastmodifiedDate < :eighteenMonthBeforeDate) AND LastModifiedDate < :eighteenMonthBeforeDate';
            dataMap.put(objType,(Integer)Database.query(query)[0].get('dataCount'));
        }
        
		return dataMap;
	}

	public List<EmailMessage> getEmailMessages(){

		if (recordTypeIdSet.isEmpty()){
			return new List<EmailMessage>();
		}

		List<EmailMessage> emailList = [SELECT Id, ParentId
		                                FROM EmailMessage
		                                WHERE ParentId IN (SELECT Id
		                                                   FROM Case
		                                                   WHERE Status = 'Closed' AND RecordTypeId IN :recordTypeIdSet AND Contact.Inactive_Contact__c = false AND LastmodifiedDate < :eighteenMonthBeforeDate) AND LastModifiedDate < :eighteenMonthBeforeDate
		                                ORDER BY LastmodifiedDate
		                                LIMIT 100];
		return emailList;
	}

	public Integer getEmailMessagesCount(){
		if (recordTypeIdSet.isEmpty()){
			return 0;
		}
		Integer emailCount = 0;
		for (AggregateResult agg : [SELECT COUNT(Id)emailCount
		                            FROM EmailMessage
		                            WHERE ParentId IN (SELECT Id
		                                               FROM Case
		                                               WHERE Status = 'Closed' AND RecordTypeId IN :recordTypeIdSet AND Contact.Inactive_Contact__c = false AND LastmodifiedDate < :eighteenMonthBeforeDate) AND LastModifiedDate < :eighteenMonthBeforeDate]){
			emailCount += (Integer)agg.get('emailCount');
		}

		return emailCount;
	}

	/* @ Method Definition to get the Record Type Ids of Case. */
	/* @ Calling from getCaseRecords method.*/
	public static Set<Id> getCaseRecordTypeIdSet(){
		Set<Id> recordTypeIdSet = new Set<Id>();
		for (RecordType rt : [SELECT Id, Name, SobjectType
		                      FROM RecordType
		                      WHERE SobjectType = 'Case' AND Name IN ('Operations', 'Operations - AA', 'Operations - ACF', 'Operations - Account Inquiry', 'Operations - CAO', 'Operations - IR', 'Operations - PAM', 'Operations - QA Case', 'Operations - YGC Reject Report')]){
			recordTypeIdSet.add(rt.Id);
		}
		return recordTypeIdSet;
	}

	/* @ Method definition to send the email notification with Number of deleted Attachments */
	/* @ Calling from Case_DataArchiveBatch. */
	public void sendNotificationAfterDataArchive(Integer deleteCount, Integer failCount, Map<Id, String> recordIdToErrorMap, String subject){
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		email.setSubject(subject);
		String htmlBody = deleteCount + ' Attachment / EmailMessage record has been deleted from Case Records.<br/><br/>';

		if (failCount > 0){
			htmlBody += failCount + ' Attachment deletion has been failed. The Details are as follows -<br/><br/>';
			htmlBody += '<table border="1" cellspacing="2" cellpadding="5">';
			htmlBody += '<thead><tr><th>Record Id</th><th>Error</th></tr></thead><tbody>';

			for (Id recId : recordIdToErrorMap.keySet()){
				htmlBody += '<tr><td>' + recId + '</td><td>' + recordIdToErrorMap.get(recId)+'</td></tr>';
			}
			htmlBody += '</tbody></table>';
		}
		email.setHtmlBody(htmlBody);
		email.toaddresses = new List<String>{DataArchiveReportController.LCAdminEmail, 'prabhakar.joshi@mcmcg.com'};

		if (!test.isRunningTest()){
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
		}
	}
}