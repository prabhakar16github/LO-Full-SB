public without sharing class IRUM_SendCreationCheckBoxHandler {
    
    public static String getQuery(){
    	String query = 'SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, SCMDUM_Record_Creation_Notification_Sent__c FROM PAM_Unmatched__c'
    					+' WHERE SCMDUM_Record_Creation_Notification_Sent__c = false'
    					+' AND PAMUM_Process_Adherence_Monitoring__r.Status__c = :accountSentToIseries'
    					+' AND PAMUM_Process_Adherence_Monitoring__r.RecordTypeId = :irAccountSentToIseriesRecType';
    	return query;
    }
    
    public static void processPamUnmatched(List<PAM_Unmatched__c> pamUnmatched){
    	List<PAM_Unmatched__c> listToUpdate = new List<PAM_Unmatched__c>(); 
        Map<Id, List<PAM_Unmatched__c>> pamUnmatchedListByPamId = getPamUnmatchedListByPamId(pamUnmatched);
        Map<Id, Process_Adherence_Monitoring__c> pamMap = getPamMap(pamUnmatchedListByPamId.keySet());
		for(Id pamId : pamMap.keySet()){
			if( pamMap.get(pamId).PAM_Unmatched__r != null && pamMap.get(pamId).PAM_Unmatched__r.size() > 0 ){
				List<PAM_Unmatched__c> pamUnmatchList = pamUnmatchedListByPamId.get(pamId);
				for(PAM_Unmatched__c pamUm : pamUnmatchList){
					pamUm.SCMDUM_Record_Creation_Notification_Sent__c = true;
					listToUpdate.add(pamUm);
				}
			}
		}
		
		update listToUpdate;        
    }
	
	@TestVisible
	private static Map<Id, List<PAM_Unmatched__c>> getPamUnmatchedListByPamId(List<PAM_Unmatched__c> pamUnmatched){
		Map<Id, List<PAM_Unmatched__c>> pamUnmatchedListByPamId = new Map<Id, List<PAM_Unmatched__c>>();
        for(PAM_Unmatched__c pamUm : pamUnmatched){
            if(pamUnmatchedListByPamId.containsKey(pamUm.PAMUM_Process_Adherence_Monitoring__c)){
               List<PAM_Unmatched__c> temp = pamUnmatchedListByPamId.get(pamUm.PAMUM_Process_Adherence_Monitoring__c);
               temp.add(pamUm);
               pamUnmatchedListByPamId.put(pamUm.PAMUM_Process_Adherence_Monitoring__c, temp);
            }else {
               pamUnmatchedListByPamId.put(pamUm.PAMUM_Process_Adherence_Monitoring__c, new List<PAM_Unmatched__c> {pamUm});
            }
        }
        return pamUnmatchedListByPamId;
	}
	
	@TestVisible
    private static Map<Id, Process_Adherence_Monitoring__c> getPamMap(Set<Id> pamIds){
        Map<Id, Process_Adherence_Monitoring__c> pamMap = new Map<Id, Process_Adherence_Monitoring__c>([SELECT Id, Name, (SELECT Id, Name FROM PAM_Unmatched__r WHERE SCMDUM_Record_Creation_Notification_Sent__c = true LIMIT 1) FROM Process_Adherence_Monitoring__c WHERE Id IN :pamIds]);
        return pamMap;
    }
    
}