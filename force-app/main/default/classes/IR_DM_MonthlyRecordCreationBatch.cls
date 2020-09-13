/*
 * Class Name : IR_DM_MonthlyRecordCreationBatch
 * Developer : Shivangi Srivastava
 * Description : This batch class will run on 24th of every month for DM IR record type. 
 */
global class IR_DM_MonthlyRecordCreationBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc){
        Id IR_DMRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('In Network').getRecordTypeId();
        
        String qry = 'SELECT Id,Firm_Id__c,(SELECT Id,FirstName,Email, Distribution_Contact__c, '; 
        qry += 'Community_User__c FROM Contacts '; 
        qry += 'WHERE (Distribution_Contact__c = true OR Community_User__c = true) ';
        qry += 'AND Inactive_Contact__c = FALSE) FROM Account WHERE Firm_Id__c != NULL AND RecordTypeId =:IR_DMRecordTypeId ';
        qry += 'AND (Firm_Status_IN__c = \'Active\' OR Firm_Status_IN__c = \'Inactive\') ';
        //System.debug('>>>>>>>'+database.query(qry));
        
		/*String qry = 'SELECT Id,Firm_Id__c,(SELECT Id,FirstName,Email, Contact_Type_SME__c,'; 
        qry += 'Community_User__c FROM Contacts '; 
        qry += 'WHERE (Contact_Type_SME__c INCLUDES(\'Inventory Reconciliation\') OR Community_User__c = true) ';
        qry += 'AND Inactive_Contact__c = FALSE) FROM Account WHERE Firm_Id__c != NULL AND RecordTypeId =:IR_DMRecordTypeId ';
        qry += 'AND (Firm_Status_IN__c = \'Active\' OR Firm_Status_IN__c = \'Inactive\')';
        System.debug('>>>>>>>'+database.query(qry).size());*/
        return Database.getQueryLocator(qry);
    }
    global void execute(Database.BatchableContext bc, List<Account> accountList){
        IR_DM_Service.createDMRecord(accountList);
    }
    global void finish(Database.BatchableContext bc){}

}