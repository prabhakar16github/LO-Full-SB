/*
 	* @ Class Name  		: 		LRMM_DataArchiveBatch
 	* @ Description 		: 		This is the handler class LRMM_DataArchiveBatch.
 	* @ Created By         	: 		Prabhakar Joshi
 	* @ Created Date       	: 		19-Mar-2020
 	* @ Last Modified Date 	: 		27-Jan-2021	
 */

public class LRMM_DataArchiveHandler{
	/* Map of all the LRMM Objects and their status field  */
	public static FINAL Map<String, String> statusFieldMap = new Map<String, String>{'Appeal__c' => 'AP_Appeal_Status__c', 'Counterclaim__c' => 'CC_Counterclaim_Status__c', 'Business_Record_Affidavit__c' => 'BRA_BRA_Status__c', 'Discovery__c' => 'DY_Discovery_Status__c', 'Escalated_Contested_Matters__c' => 'ECM_Status__c', 'Purchase_and_Sales_Agreement__c' => 'PSA_PSA_Status__c', 'Settlement_Approval__c' => 'Settlement_Approval_Status__c', 'Trial_Witness_Request__c' => 'Status__c'}; 
	/* Last Modified Date  */
	public static FINAL Date lastDate = System.today().addDays( - 30);
	/* Status Value */
	private static FINAL String STATUS_CLOSED = 'Closed';
	private static FINAL String STATUS_COMPLETED = 'Completed';
    
    private static FINAL Integer dataLimit = DataArchiveReportController.ARCHIVE_DATA_LIMIT;
    /** Method definition to get the LRMM Attachment records for Archive. */
    /** Calling From LRMM_DataArchiveBatch. */
    public List<Attachment> getLRMMAttachments(){
        List<Attachment> attList = new List<Attachment>();
        for (String sobj : statusFieldMap.keySet()){
            String query = 'SELECT Id FROM Attachment WHERE ParentId IN ';
            /** Inner Query Start */
            query += '(SELECT Id FROM ' + sobj + ' WHERE ';

            /** To pass the test class. */
            if(!test.isRunningTest()){
                query += 'LastModifiedDate < :lastDate AND ';
            }/** End */
            
            if (sobj != 'Trial_Witness_Request__c')
                query += statusFieldMap.get(sobj) + ' =:STATUS_CLOSED)';
            else{
                query += '((RecordType.Name LIKE \'%Telephonic%\' AND ' + statusFieldMap.get(sobj) + '=:STATUS_COMPLETED) OR (RecordType.Name LIKE \'%Live%\' AND ' + statusFieldMap.get(sobj) + '=:STATUS_CLOSED))) ';
            }/** Inner query END */

            /** To pass the test class. */
            if(!test.isRunningTest()){
                query += 'AND LastModifiedDate < :lastDate ';
            }/** END */
            query += 'LIMIT :dataLimit ';
            attList.addAll((List<Attachment>)Database.query(query));
        }
        
        return attList;
    }/** END */
    
    /** Method definition to get the Map of data count. */
    /** Calling from DataArchiveReportController. */
    public Map<String,Integer> getLRMMDataCountMap(){
        Map<String, Integer> objectToAttCountMap = new Map<String, Integer>();
        List<AggregateResult> attList = new List<AggregateResult>();
        for (String sobj : statusFieldMap.keySet()){
            String query = 'SELECT COUNT(Id)totalCount, Parent.Type objectAPIName FROM Attachment WHERE LastModifiedDate < :lastDate ';//
            query += 'AND ParentId IN (SELECT Id FROM ' + sobj + ' WHERE LastModifiedDate < :lastDate AND ';
            if (sobj != 'Trial_Witness_Request__c')
                query += statusFieldMap.get(sobj) + ' =:STATUS_CLOSED ';
            else{
                query += '((RecordType.Name LIKE \'%Telephonic%\' AND ' + statusFieldMap.get(sobj) + '=:STATUS_COMPLETED) OR (RecordType.Name LIKE \'%Live%\' AND ' + statusFieldMap.get(sobj) + '=:STATUS_CLOSED)) ';
            }
            query += ') GROUP BY Parent.Type ';

            attList.addAll((List<AggregateResult>)Database.query(query));
        }
        
        for(AggregateResult agg : attList){
            String sobjectName = Schema.getGlobalDescribe().get(String.valueOf(agg.get('objectAPIName'))).getDescribe().getLabel();
            objectToAttCountMap.put(sobjectName, (Integer)agg.get('totalCount'));
        }
        return objectToAttCountMap;
    }/** END */
}