/*
 * Class Name : DM_SCMD_NoResponse
 * Developer  : Shivangi Srivastava
 * Description : This batch class will run on 10th day of record creation.
 */
global class DM_SCMD_NoResponse implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        String recordTypeScmDispute = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM SCM Dispute').getRecordTypeId();
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
            +'WHERE RecordTypeId = :recordTypeScmDispute AND Status__c = :finalEscalationStatus '
            +'AND SCMD_Reporting_Period__c = :reportingPeriod';
        
        //System.debug('query >> '+Database.query(query).size()); 				
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){
        DM_SCMDisputeService.sendNoResponseEmailNotification(pamList);
    }
    public void finish(Database.BatchableContext bc){}
    
}