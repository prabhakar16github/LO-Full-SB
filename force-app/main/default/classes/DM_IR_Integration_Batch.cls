global class DM_IR_Integration_Batch implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        Id pamRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM IR').getRecordTypeId();
        string pamStatus = 'Account Numbers Added';  //Account Numbers Added 
        
        Date today_date = System.today();
        String month = String.valueOf(today_date.month());
        if(month.length() == 1){
            month = '0'+month;
        }
        string reportingPeriod = today_date.year()+'-'+month;
        System.debug('DM_IR_Integration_Batch.ReportingPeriod >> '+reportingPeriod);
        
        string query = 'SELECT Id, Name, Organization_Name__c,Organization_Name__r.Firm_ID__c, SCMD_Reporting_Period__c,RecordTypeId, Status__c ';
        query += 'FROM Process_Adherence_Monitoring__c ';
        query += 'WHERE RecordTypeId =: pamRecordTypeId AND Status__c =: pamStatus AND SCMD_Reporting_Period__c =: reportingPeriodlu' ;
        
        System.debug('DM_IR_Integration_Batch.query >>>>'+Database.query(query));
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList ){
        
    }
    public void finish(Database.BatchableContext bc){}

}