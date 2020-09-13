/* 
  Description : First(1st) day of each month Call Log Record is created for the Call Log Record Creation/Follow-Up Automation
  Created date : 28/06/2019 
  @uthor : Avaneesh Singh 
*/
global class CM_CallLogRecordCreationBatch implements Database.Batchable<sObject>{

 
   global Database.QueryLocator start(Database.BatchableContext BC){
   /* fetch the record type of firm and agency from account */
   Id firmRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('In Network').getRecordTypeId();
   Id agencyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('In Network - CAO').getRecordTypeId();
   List<String> picklistValuesList = new List<String>{'Active','Inactive'};
   final string EXEMPT = 'Exempt';
   String Query = 'select id , name from account where (RecordTypeId =: firmRecordTypeId OR RecordTypeId =: agencyRecordTypeId) AND ';
          Query += ' (Firm_Status_IN__c IN : picklistValuesList  OR Agency_Status_IN__c IN :picklistValuesList OR Firm_Status_IN_PR__c IN : picklistValuesList) AND VO_Tier__c != null AND VO_Tier__c !=:EXEMPT';
         
            
      return Database.getQueryLocator(Query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
   
     if(scope.size() >0){
       CM_CallLogRecordCreationBatchHelper.createInstance().executeBatch(scope); // passing all account data to handler method 
     }
   }

   global void finish(Database.BatchableContext BC){
   
   }
}