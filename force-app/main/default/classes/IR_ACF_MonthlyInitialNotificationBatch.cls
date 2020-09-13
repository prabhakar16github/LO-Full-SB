global class IR_ACF_MonthlyInitialNotificationBatch implements Database.Batchable<sObject> {
    global database.QueryLocator start(Database.BatchableContext bc){
        
        Id Org_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('In Network').getRecordTypeId();
        //need to add contact type sme
        String query = 'SELECT Id, Name, Firm_ID__c ';
        query+='From Account WHERE Firm_ID__c != null AND RecordTypeId =: Org_RecordTypeId ';
        query+='AND ( Firm_Status_IN_ACF__c = \'Inactive\' OR Firm_Status_IN_ACF__c = \'Active\')';
        
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext bc, List<Account> accountList){
        IR_ACF_Service.processNotification(accountList);
    }
    global void finish(Database.BatchableContext bc){
        
    }
}