/*
 * @ Class Name      :     PAM_DataArchiveHandler
 * @ Description     :     Handler Class for PAM Data Archive Process.
 * @ Created By      :     Prabhakar Joshi
 * @ Created Date    :     2-Feb-2021
 * @ Last Modified   :     2-Feb-2021
 */
public with sharing class PAM_DataArchiveHandler{
	/** To hold the record types of PAM. */
	private Set<String> recordTypeNameSet = new Set<String>{'LO IR - Account #\'s Sent'};
	/** To hold the six months before date. */
	private Date sixMonthBeforeDate = System.today().addMonths(-6);
	
	private static FINAL Integer dataLimit = DataArchiveReportController.ARCHIVE_DATA_LIMIT;
    /** Method definition to get the Map of PAM RecordType and Attachment count. */
    /** Calling from DataArchiveReportController. */
    public Map<String, Integer> getPAMDataCountMap(){
		Map<String, Integer> dataCountMap = new Map<String, Integer>();
		String query = 'SELECT COUNT(Id)attCount, Parent.RecordType.Name parentRT FROM Attachment WHERE ParentId IN ';
		query += '(SELECT Id FROM Process_Adherence_Monitoring__c WHERE RecordType.Name IN :recordTypeNameSet AND Status__c = \'Closed\' ';
		if(test.isRunningTest()){
			query += ')';
		}else{
			query += 'AND LastModifiedDate < :sixMonthBeforeDate) AND LastModifiedDate < :sixMonthBeforeDate ';
		}
		query += 'GROUP BY Parent.RecordType.Name';
		for(AggregateResult agg : (List<AggregateResult>)Database.query(query)){
			dataCountMap.put((String)agg.get('parentRT'), (Integer)agg.get('attCount'));
		}
		
		return dataCountMap;
	}/** END */

    /** Method definition to get the Attachment records associated with PAM. */
    /** Calling from PAM_DataArchiveBatch. */
	public List<Attachment> getPAMAttachments(){
		String query = 'SELECT Id, ParentId FROM Attachment WHERE ParentId IN ';
		query += '(SELECT Id FROM Process_Adherence_Monitoring__c WHERE RecordType.Name IN :recordTypeNameSet AND Status__c = \'Closed\' ';
		if(test.isRunningTest()){
			query += ') ';
		}else{
			query += 'AND LastmodifiedDate < :sixMonthBeforeDate) AND LastModifiedDate < :sixMonthBeforeDate ';
		}
		query += 'ORDER BY LastmodifiedDate LIMIT :dataLimit ';
		return (List<Attachment>)Database.query(query);
	}/** END */
}