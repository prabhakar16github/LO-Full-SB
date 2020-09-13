global class IR_ACF_MonthlyNoResponseBatch implements database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        Id ACF_IRRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR').getRecordTypeId();
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
        query += 'WHERE RecordTypeId =: ACF_IRRecordTypeId AND (Status__c =: statusNew OR Status__c =:statusFinalEsc) ';
        query += 'AND SCMD_Reporting_Period__c =: reportingPeriod';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){
        IR_ACF_Service.processPam(pamList,'No Response');
    }
    global void finish(Database.BatchableContext bc){
        
    }
}