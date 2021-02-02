/*
 * @ Class Name      :     PAM_DataArchiveHandler
 * @ Description     :     Handler Class for PAM Data Archive Process.
 * @ Created By      :     Prabhakar Joshi
 * @ Created Date    :     2-Feb-2021
 * @ Last Modified   :     2-Feb-2021
 */
public with sharing class PAM_DataArchiveHandler{
	private Set<String> recordTypeNameSet = new Set<String>{'LO IR - Account #\'s Sent'};
	private Date sixMonthBeforeDate = System.today().addMonths(-6);
    
    /** Method definition to get the Map of PAM RecordType and Attachment count. */
    /** Calling from DataArchiveReportController.  */
    public Map<String, Integer> getPAMDataCountMap(){
		Map<String, Integer> dataCountMap = new Map<String, Integer>();

		for (AggregateResult agg : [SELECT COUNT(Id)attCount, Parent.RecordType.Name parentRT
		                            FROM Attachment
		                            WHERE ParentId IN (SELECT Id
		                                               FROM Process_Adherence_Monitoring__c
		                                               WHERE RecordType.Name IN :recordTypeNameSet AND Status__c = 'Closed' AND LastModifiedDate < :sixMonthBeforeDate) AND LastModifiedDate < :sixMonthBeforeDate
		                            GROUP BY Parent.RecordType.Name]){

			dataCountMap.put((String)agg.get('parentRT'), (Integer)agg.get('attCount'));
		}
		return dataCountMap;
	}/** END */

    /** Method definition to get the Attachment records associated with PAM. */
    /** Calling from PAM_DataArchiveBatch. */
	public List<Attachment> getPAMAttachments(){

		return [SELECT Id, ParentId
		        FROM Attachment
		        WHERE ParentId IN (SELECT Id
		                           FROM Process_Adherence_Monitoring__c
		                           WHERE RecordType.Name IN :recordTypeNameSet AND Status__c = 'Closed' AND LastmodifiedDate < :sixMonthBeforeDate) AND LastModifiedDate < :sixMonthBeforeDate
		        ORDER BY LastmodifiedDate
		        LIMIT 500];
	}/** END */
}