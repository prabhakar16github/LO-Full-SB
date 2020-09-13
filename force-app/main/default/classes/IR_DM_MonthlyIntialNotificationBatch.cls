/*
 * Class Name : IR_DM_MonthlyIntialNotificationBatch
 * Developer : Shivangi Srivastava
 * Description : This batch class will run on 18th of every month for DM IR record type. 
 */
global class IR_DM_MonthlyIntialNotificationBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        Id Org_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('In Network').getRecordTypeId();
        String qry = 'SELECT Id, Name, Firm_ID__c ';
        qry += 'FROM Account ';
        qry += 'WHERE Firm_ID__c != null AND RecordTypeId =: Org_RecordTypeId ';
        qry += 'AND (Firm_Status_IN__c = \'Inactive\' OR Firm_Status_IN__c = \'Active\') ';
        System.debug('qry : '+qry);
        System.debug('query >> '+Database.query(qry).size());
        return Database.getQueryLocator(qry);
     }
    global void execute(Database.BatchableContext bc, List<Account> accountList){
        IR_DM_Service.processInitialNotification(accountList);
    }
    global void finish(Database.BatchableContext bc){
        
    }
    
}