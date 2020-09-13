global class IR_ACF_MonthlyRecordCreationBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        Id IR_ACFRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('In Network').getRecordTypeId();
        
              
       String qry = 'SELECT Id,Firm_Id__c,(SELECT Id,FirstName,Email, Contact_Type_SME__c,'; 
        qry += 'Community_User__c FROM Contacts '; 
        qry += 'WHERE (Contact_Type_SME__c INCLUDES(\'Inventory Reconciliation\') OR Community_User__c = true) ';//Inventory Reconciliation
        qry += 'AND Inactive_Contact__c = FALSE) FROM Account WHERE Firm_Id__c != NULL AND RecordTypeId =:IR_ACFRecordTypeId ';
        qry += 'AND (Firm_Status_IN_ACF__c = \'Active\' OR Firm_Status_IN_ACF__c = \'Inactive\')';
        //System.debug('>>>>>>>'+database.query(qry).size());
        return Database.getQueryLocator(qry);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accountList){
        IR_ACF_Service.createIR_ACFRecords(accountList);
    }
    
    global void finish(Database.BatchableContext bc){}
}