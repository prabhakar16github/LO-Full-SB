/*
 * Class Name : IR_DM_MonthlyFinalEscalationBatch
 * Developer : Shivangi Srivastava
 * Description : This batch class will run for three consecutive days after 28th for DM IR record type.
 */
global class IR_DM_MonthlyFinalEscalationBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        Id DM_IRRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM IR').getRecordTypeId();
        string statusNew = 'New'; // check wheather attachment has been added or not
        //string statusFinal = 'Final Escalation';
        
        Date today_date = System.today();
        String month = String.valueOf(today_date.month());
        if(month.length() == 1){
            month = '0'+month;
        }
        string reportingPeriod = today_date.year()+'-'+month;
        
        string query = 'SELECT Id, Name, Organization_Name__c, Organization_Name__r.Firm_ID__c , RecordTypeId,';
        query += 'RecordType.Name,Status__c , SCMD_Reporting_Period__c ';
        query += 'FROM Process_Adherence_Monitoring__c ';
        query += 'WHERE RecordTypeId =: DM_IRRecordTypeId AND (Status__c =: statusNew )'; //OR Status__c =: statusFinal
        query += ' AND SCMD_Reporting_Period__c =: reportingPeriod';
        
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){
        IR_DM_Service.processPamDM(pamList, 'Monthly Escalation');
    }
    global void finish(Database.BatchableContext bc){}
    
}