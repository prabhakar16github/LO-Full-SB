global class DM_SCMD_Integration_Batch implements Database.Batchable<sobject> {
    global Database.QueryLocator start(Database.BatchableContext bc){
        Id DM_SCM_ReccordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM SCM Dispute').getRecordTypeId();
        String qry = 'SELECT Id,Name,Account_Type__c,RecordTypeId FROM Process_Adherence_Monitoring__c WHERE RecordTypeId = :DM_SCM_ReccordTypeId ';
        qry += 'AND SCMD_NoPCodes_Sent_This_Reporting_Period__c = false AND No_Dispute_Codes_Sent_in_Report_Period__c = false ';
        qry += 'AND Status__c = \'Account Numbers Added\' AND Account_Type__c = \'DM\' ';
        qry += 'AND Id = \'a0sm0000003JcdA\' ';
            return Database.getQueryLocator(qry);
    }
    global void execute(Database.BatchableContext bc,List<Process_Adherence_Monitoring__c> recordList){
        System.debug('>>>>>recordList>>>>'+recordList);
    }
    global void finish(Database.BatchableContext bc){
        
    }
}