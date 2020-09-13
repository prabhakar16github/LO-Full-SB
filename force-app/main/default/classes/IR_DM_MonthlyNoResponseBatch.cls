/*
 * Class Name : IR_DM_MonthlyNoResponseBatch
 * Developer : Shivangi Srivastava
 * Description : This batch class will run for 4th day after 28th for DM IR process for Internal user.
*/
global class IR_DM_MonthlyNoResponseBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc){
        Id DM_IRRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM IR').getRecordTypeId();
        string statusNew = 'New';
        string statusFinalEsc = 'Final Escalation';
        
        Date today_date = System.today();
        String month = String.valueOf(today_date.month());
        if(month.length() == 1){
            month = '0'+month;
        }
        string reportingPeriod = today_date.year()+'-'+month;
        
        string query = 'SELECT Id, Name,Organization_Name__c,Organization_Name__r.Firm_ID__c,RecordTypeId,';
        query += 'RecordType.Name,Status__c,SCMD_Reporting_Period__c,Organization_Name__r.OwnerId,';
        query += 'Organization_Name__r.Owner.FirstName, Organization_Name__r.Owner.Email ';
        query += 'FROM Process_Adherence_Monitoring__c ';
        query += 'WHERE RecordTypeId =: DM_IRRecordTypeId AND (Status__c =: statusNew OR Status__c =:statusFinalEsc) ';
        query += 'AND SCMD_Reporting_Period__c =: reportingPeriod';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){
        IR_DM_Service.processPamDM(pamList,'No Response');
    }
    global void finish(Database.BatchableContext bc){
        
    }
}