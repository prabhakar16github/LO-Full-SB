public class DataArchiveHandler{
	/**  Map of all the LRMM Objects and their status field  */
	public static FINAL Map<String, String> statusFieldMap = new Map<String, String>{'Appeal__c' => 'AP_Appeal_Status__c', 'Counterclaim__c' => 'CC_Counterclaim_Status__c', 'Business_Record_Affidavit__c' => 'BRA_BRA_Status__c', 'Discovery__c' => 'DY_Discovery_Status__c', 'Escalated_Contested_Matters__c' => 'ECM_Status__c', 'Purchase_and_Sales_Agreement__c' => 'PSA_PSA_Status__c', 'Settlement_Approval__c' => 'Settlement_Approval_Status__c', 'Trial_Witness_Request__c' => 'Trial_Status__c'};
	/** Last Modified Date  */
	public static FINAL Date lastDate = System.today().addDays( - 30);
	/** Status Value */
	public static FINAL String STATUS_CLOSED = 'Closed';
    
    
	/** Method to get the LRMM Records */
	public List<Sobject> getLRMMRecords(String sobj){
		return String.isNotBlank(sobj) && statusFieldMap.get(sobj) != NULL ? Database.query('SELECT Id,Name,' + statusFieldMap.get(sobj) + ' FROM ' + sobj + ' WHERE LastModifiedDate < :lastDate AND ' + statusFieldMap.get(sobj) + ' =:STATUS_CLOSED') : NULL;
	}

	/** Method to get the attachments from all LRMM objects records */
	public Integer processParentIds(Set<Id> parentIdSet){
		if (parentIdSet.size() > 0){
			List<Attachment> attList = [SELECT 
			                                  Id, 
			                                  ParentId
			                            FROM Attachment
			                            WHERE ParentId IN :parentIdSet];
			return attList.size();
		} else{
			return 0;
		}
	}

	//Database.executeBatch(new DataArchiveBatch());
}