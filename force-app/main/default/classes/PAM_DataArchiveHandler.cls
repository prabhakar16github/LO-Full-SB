public with sharing class PAM_DataArchiveHandler{
	private Set<String> recordTypeNameSet = new Set<String>{'LO IR - Account #\'s Sent'};
	private Date sixMonthBeforeDate = System.today().addMonths(-6);
	public PAM_DataArchiveHandler(){
	}

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
	}
}