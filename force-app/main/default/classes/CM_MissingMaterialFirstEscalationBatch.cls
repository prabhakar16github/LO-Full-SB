/* ****************************************************************
 * Class Name  : CM_MissingMaterialFirstEscalationBatch
 * Description : The purpose of this batch class to get those call monitoring records (QA RecordType Only) which are created 4 days 
 * 				 before and pass those records to the helper class.
 * Created By : Prabhakar Joshi  
 * Created Date: 2-July-2019
 * *******************************************************************/

global class CM_MissingMaterialFirstEscalationBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        Id cm_QARecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId();
        Date QA_CreatedDate = System.today()-4;//
        String qry = 'SELECT Id,Name,Organization_Name_CM__c,Organization_Name_CM__r.Firm_ID__c,Organization_Name_CM__r.Agency_ID__c,Reporting_Month_CM__c,';
        qry += 'Reporting_Year_CM__c,Escalation_Notification_Sent__c FROM Call_Monitoring__c WHERE CM_CreatedDate__c = :QA_CreatedDate AND RecordTypeId =:cm_QARecordTypeId '; 
        qry += 'AND Attachments__c = true';
        return Database.getQueryLocator(qry); 
    }
    
    global void execute(Database.BatchableContext bc,List<Call_Monitoring__c> cmList){
        CM_MissingMaterialEscalationHelper.processData(cmList,'First Escalation');
    }
    
    global void finish(Database.BatchableContext bc){}
}