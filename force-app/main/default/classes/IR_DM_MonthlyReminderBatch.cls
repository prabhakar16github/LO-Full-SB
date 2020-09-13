/*
 * Class Name : IR_DM_MonthlyReminderBatch
 * Developer : Shivangi Srivastava
 * Description : This batch class will run on 27th and 28th of each month for DM IR records.
 */

global class IR_DM_MonthlyReminderBatch implements Database.Batchable<sObject> {
    // this code is scheduled to be run 2days, that is , on 27th and 28th
    // their templates are diffrent based on the date, which is done in template.
    
    
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        Id DM_IRRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM IR').getRecordTypeId();
        string statusNew = 'New'; // check wheather attachment has been added or not
        
        Date today_date = System.today();
        String month = String.valueOf(today_date.month());
        if(month.length() == 1){
            month = '0'+month;
        }
        string reportingPeriod = today_date.year()+'-'+month;
        
        string query = 'SELECT Id, Name,Organization_Name__c,Organization_Name__r.Firm_ID__c,RecordTypeId, ';
        query +='RecordType.Name,Status__c,SCMD_Reporting_Period__c ';
        query +='FROM Process_Adherence_Monitoring__c ';
        query +='WHERE RecordTypeId =: DM_IRRecordTypeId AND Status__c =: statusNew AND SCMD_Reporting_Period__c =: reportingPeriod';
       // System.debug('query >>>>'+Database.query(query));
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){
        IR_DM_Service.processPamDM(pamList,'Monthly Reminder');
    }
    global void finish(Database.BatchableContext bc){}

}