/*
 * Class Name : DM_SCMD_Monthly_CreationBatch
 * Developer : Shivangi Srivastava
 * Description : This batch class will on 1st of each month and create SCM DM records.
 */
global class DM_SCMD_Monthly_CreationBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc){
        Id IN_NetworkOrgRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('In Network').getRecordTypeId();
        String query = 'SELECT Id, Name, Firm_ID__c, (SELECT Id, FirstName,LastName, Email, Contact_Type_SME__c, OwnerId, ' 
            +'Community_User__c FROM Contacts ' 
            + 'WHERE (Contact_Type_SME__c INCLUDES(\'Process Adherence Monitoring (PAM)\') OR Community_User__c = true) '
            + ' AND Inactive_Contact__c = FALSE)'
            +' From Account WHERE RecordTypeId =:IN_NetworkOrgRecordTypeId ' 
            +'AND (Firm_Status_IN__c = \'Inactive\' OR Firm_Status_IN__c = \'Active\' )';//
       // System.debug('query >> '+Database.query(query));
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Account> accountList){
        DM_SCMDisputeService.createMonthlyDMSCMD(accountList);
    }
    global void finish(Database.BatchableContext bc){}

}