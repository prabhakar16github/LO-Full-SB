/*
 * @ Class Name  : LRMM_DataArchiveBatch
 * 
 * @ Description : This is the handler class LRMM_DataArchiveBatch.
 * 
 * @ Created By  : Prabhakar Joshi
 * 
 * @ Created Date: 19-Mar-2020
 */

public class LRMM_DataArchiveHandler{
	/* Map of all the LRMM Objects and their status field  */
	public static FINAL Map<String, String> statusFieldMap = new Map<String, String>{'Appeal__c' => 'AP_Appeal_Status__c', 'Counterclaim__c' => 'CC_Counterclaim_Status__c', 'Business_Record_Affidavit__c' => 'BRA_BRA_Status__c', 'Discovery__c' => 'DY_Discovery_Status__c', 'Escalated_Contested_Matters__c' => 'ECM_Status__c', 'Purchase_and_Sales_Agreement__c' => 'PSA_PSA_Status__c', 'Settlement_Approval__c' => 'Settlement_Approval_Status__c', 'Trial_Witness_Request__c' => 'Status__c'};
	/* Last Modified Date  */
	public static FINAL Date lastDate = System.today().addDays( - 30);
	/* Status Value */
	public static FINAL String STATUS_CLOSED = 'Closed';
	public static FINAL String STATUS_COMPLETED = 'Completed';
	/* Method to get the Parent Record Ids */
	public Set<Id> getParentIds(){
        Map<Id,Sobject> sobjectMap = new Map<Id,Sobject>();
		for (String obj : statusFieldMap.keySet()){
            sobjectMap.putAll(this.getLRMMRecords(obj));
		}
        return sobjectMap.keySet();
	}

	/* Method to get the LRMM Records */
	private List<Sobject> getLRMMRecords(String sobj){
		String query = 'SELECT Id,Name,' + statusFieldMap.get(sobj) + ' FROM ' + sobj + ' WHERE LastModifiedDate < :lastDate AND ';//
		if (sobj != 'Trial_Witness_Request__c')
			query += statusFieldMap.get(sobj) + ' =:STATUS_CLOSED';
		else{
			query += '((RecordType.Name LIKE \'%Telephonic%\' AND ' + statusFieldMap.get(sobj) + '=:STATUS_COMPLETED) OR (RecordType.Name LIKE \'%Live%\' AND ' + statusFieldMap.get(sobj) + '=:STATUS_CLOSED))';
		}
		return String.isNotBlank(sobj) && statusFieldMap.get(sobj) != NULL ? Database.query(query) : new List<Sobject>();
	}

	/* Method to send the email notification with Number of deleted Attachments */
	public void sendNotificationAfterAttachmentDelete(Integer deleteCount,Integer failCount,Map<Id,String> recordIdToErrorMap, String subject){
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		email.setSubject(subject);
		String htmlBody = deleteCount + ' Attachment record has been deleted from LRMM Objects.<br/><br/>';
        
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
		email.toaddresses = new List<String>{'lcsalesforceadmin@mcmcg.com'};
        
		if (!test.isRunningTest())
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
	}
}