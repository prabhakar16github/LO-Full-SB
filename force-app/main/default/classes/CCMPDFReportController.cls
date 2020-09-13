public class CCMPDFReportController{
    
    public String orgName{get;set;}
    public List<String> keyList{get;set;}
    
    public Transient  Map<String,Map<String,List<Process_Adherence_Monitoring__c>>> pamRecordsMap{get;set;}
    
    public CCMPDFReportController(){
        orgName = apexpages.currentpage().getparameters().get('name');
        String orgId = apexpages.currentpage().getparameters().get('id');
        pamRecordsMap = new Map<String,Map<String,List<Process_Adherence_Monitoring__c>>>();
        keyList = new List<String>();
        
        Integer i = 1;
        String currentStanding = '';
        
        for(Process_Adherence_Monitoring__c pam : [SELECT RecordType.Name, Account_Number__c, Exception_Due_Date__c, Account_Standing__c FROM Process_Adherence_Monitoring__c 
                                                    WHERE Status__c != 'Closed' AND Status__c != 'Excluded' AND Organization_Name__c =: orgId AND ((Organization_Name__r.CCM_Exceptions_0_30__c != 0 AND 
                                                    Organization_Name__r.CCM_Exceptions_0_30__c != null) OR (Organization_Name__r.CCM_Exceptions_31_60__c != 0 AND 
                                                    Organization_Name__r.CCM_Exceptions_31_60__c != null) OR (Organization_Name__r.CCM_Exceptions_61__c != 0 AND 
                                                    Organization_Name__r.CCM_Exceptions_61__c != null)) AND Account_Standing__c in 
                                                    ('0-30 Days (New Exception)','31-60 Days (Approaching Critical Timeframe)','61+ Days (Immediate Correction Required)') 
                                                    ORDER BY RecordType.Name,Exception_Due_Date__c ASC LIMIT 50000]){
            if(currentStanding != pam.Account_Standing__c){
                i = 1;
                currentStanding = pam.Account_Standing__c;
            }
            Map<String,List<Process_Adherence_Monitoring__c>> tempMap = pamRecordsMap.get(pam.Account_Standing__c);
            if(tempMap == null) tempMap = new Map<String,List<Process_Adherence_Monitoring__c>>();
            List<Process_Adherence_Monitoring__c> tempList = tempMap.get(String.valueOf(i));
            if(tempList == null) tempList = new List<Process_Adherence_Monitoring__c>();
            tempList.add(pam);
            tempMap.put(String.valueOf(i),tempList);
            pamRecordsMap.put(pam.Account_Standing__c,tempMap);
            if(tempList.size() == 10000) i++;
        }
        
        if(pamRecordsMap.get('0-30 Days (New Exception)') != null) keyList.add('0-30 Days (New Exception)');
        if(pamRecordsMap.get('31-60 Days (Approaching Critical Timeframe)') != null) keyList.add('31-60 Days (Approaching Critical Timeframe)');
        if(pamRecordsMap.get('61+ Days (Immediate Correction Required)') != null) keyList.add('61+ Days (Immediate Correction Required)');
    }
}