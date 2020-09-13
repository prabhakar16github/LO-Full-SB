/***********************************************************************************
 * Class Name  : DM_SCMD_FinalEscalation
 * Description : This batch class will run from 6th to 9th day of record creation.
 * Created By  : Shivangi Srivastava
 * *******************************************************************************/ 
global class DM_SCMD_FinalEscalation implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        String recordTypeScmDispute = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM SCM Dispute').getRecordTypeId();
        String secondEscalationStatus = 'Second Escalation';
        String finalEscalationStatus = 'Final Escalation';
        
        Date today_date = System.today();
        String month = String.valueOf(today_date.month());
        if(month.length() == 1){
            month = '0'+month;
        }
        string reportingPeriod = today_date.year()+'-'+month;
        
        String query = 'SELECT Id, Name, Organization_Name__c, Organization_Name__r.Name, Organization_Name__r.Firm_ID__c, RecordTypeId, RecordType.Name,'
            +' Status__c , SCMD_Reporting_Period__c '
            +'FROM Process_Adherence_Monitoring__c ' 
            +'WHERE RecordTypeId = :recordTypeScmDispute AND (Status__c = :secondEscalationStatus OR Status__c = :finalEscalationStatus) '
            +'AND SCMD_Reporting_Period__c = :reportingPeriod';
        
        System.debug('query >> '+Database.query(query).size()); 				
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){
        try{
            Map<Id, List<Process_Adherence_Monitoring__c>> accountIdByPamList = new Map<Id, List<Process_Adherence_Monitoring__c>>();
            for(Process_Adherence_Monitoring__c pam : pamList){
                pam.Status__c = 'Final Escalation';
                
                if(pam.Organization_Name__c != NULL){
                    List<Process_Adherence_Monitoring__c> tempList = new List<Process_Adherence_Monitoring__c>();
                    if(accountIdByPamList.get(pam.Organization_Name__c) != NULL){
                        tempList = accountIdByPamList.get(pam.Organization_Name__c);
                    } 
                    tempList.add(pam);
                    accountIdByPamList.put(pam.Organization_Name__c, tempList);
                }
            }
            if(!accountIdByPamList.isEmpty()){
                
                update pamList;
                DM_SCMDisputeService.sendEmailNotification(accountIdByPamList,'Final Escalation');
            }
        }catch(Exception ex){
            system.debug('Exception in SCMD_FinalEscalationNotification-->'+ex);
            throw ex; 
        }
    }
    public void finish(Database.BatchableContext bc){}
    
}