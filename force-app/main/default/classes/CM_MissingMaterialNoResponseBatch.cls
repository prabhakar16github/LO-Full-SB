/* ****************************************************************
 * Class Name  : CM_MissingMaterialSecondEscalationBatch
 * Description : The purpose of this batch class to get those call monitoring records (QA RecordType Only) 
 * 				 which are created 6 days before and pass those records to the helper class.
 * Created By : Prabhakar Joshi
 * Created Date: 3-July-2019
 * *******************************************************************/

global class CM_MissingMaterialNoResponseBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        Id cm_QARecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId();
        Date QA_CreatedDate = System.today()-6;//
        String qry = 'SELECT Id,Name,Organization_Name_CM__c,Organization_Name_CM__r.Firm_ID__c,Organization_Name_CM__r.Agency_ID__c,Reporting_Month_CM__c,';
        qry += 'Reporting_Year_CM__c,Organization_Name_CM__r.Owner.Email,Organization_Name_CM__r.FM_Process_Manager__r.Email, ';
        qry += 'Organization_Name_CM__r.Owner.FirstName,Organization_Name_CM__r.FM_Process_Manager__r.FirstName ';
        qry += 'FROM Call_Monitoring__c WHERE CM_CreatedDate__c =:QA_CreatedDate AND RecordTypeId =:cm_QARecordTypeId ';
        qry += 'AND Attachments__c = true';
        return Database.getQueryLocator(qry);
    }
    
    global void execute(Database.BatchableContext bc,List<Call_Monitoring__c> cmList){
        CM_MissingMaterialEscalationHelper.processData(cmList,'No Response');
    }
    
    global void finish(Database.BatchableContext bc){}

}