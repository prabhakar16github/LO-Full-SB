global class FRB_BatchToUpdateExceptionFields implements Database.Batchable<SObject>{
global database.querylocator start(Database.BatchableContext bc)
{  
   string FRBRecordTypeID = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO FRB').getRecordTypeId();
   string query= 'select id,Account_Standing__c,Organization_Name__c,Organization_Name__r.Number_of_exceptions_under_4_6_bucket__c,Organization_Name__r.Number_of_Exception__c,Organization_Name__r.Number_of_exceptions_under_7_10_bucket__c,Organization_Name__r.Number_of_exceptions_under_11_19_bucket__c from Process_Adherence_Monitoring__c WHERE  REcordtypeId =: FRBRecordTypeID ';
   return Database.getQueryLocator(query);
}
global void execute(Database.BatchableContext bc,Process_Adherence_Monitoring__c [] pList1)
 { 
    List<Account> accList = new List<Account>();
    set<id>accIdSet = new set<id>();

    string FRBRecordTypeID = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO FRB').getRecordTypeId();

    for(Process_Adherence_Monitoring__c  p:pList1){
        accIdSet.add(p.Organization_Name__c);
       
    } 
  accList = [select id,Number_of_Exception__c,Number_of_exceptions_under_7_10_bucket__c,
                              Number_of_exceptions_under_4_6_bucket__c,FRB_Firm_Check__c,
                              Number_of_exceptions_under_11_19_bucket__c 
                       from Account where id In :accIdset];
    for(Account a : accList){
         a.Number_of_exceptions_under_4_6_bucket__c =0;
        a.Number_of_Exception__c =0;
        a.Number_of_exceptions_under_7_10_bucket__c =0;
        a.Number_of_exceptions_under_11_19_bucket__c =0;
    }                
    //Use Advance For Loop which retrives records using query More.
   for(AggregateResult ar: [Select Account_Standing__c,Organization_Name__c, Count(Id) From Process_Adherence_Monitoring__c Where Organization_Name__c IN: accIdSet AND 
                                (Account_Standing__c = '0-3 Days (Green - New Exception)' OR Account_Standing__c = '4-6 Days (Yellow - Outside Correction Timeframe)' OR
                                 Account_Standing__c = '7-10 Days (Orange - Approaching Critical Timeframe)' OR
                                 Account_Standing__c = '11-19 Days (Red - Immediate Correction Required)' ) AND 
                                 Status__c != 'Closed' AND RecordtypeId =:FRBRecordTypeID  Group By Organization_Name__c,Account_Standing__c ]){
       for(Account  p:accList ){
           
           if(ar.get('Organization_Name__c') == p.Id){
                p.FRB_Firm_Check__c= true;
               if(ar.get('Account_Standing__c') == '0-3 Days (Green - New Exception)'){
                p.Number_of_Exception__c = Decimal.ValueOf(String.ValueOf(ar.get('expr0')));
               }
              
               if(ar.get('Account_Standing__c') == '4-6 Days (Yellow - Outside Correction Timeframe)'){
                p.Number_of_exceptions_under_4_6_bucket__c= Decimal.ValueOf(String.ValueOf(ar.get('expr0')));
               }
             
               if(ar.get('Account_Standing__c') == '7-10 Days (Orange - Approaching Critical Timeframe)'){
                p.Number_of_exceptions_under_7_10_bucket__c= Decimal.ValueOf(String.ValueOf(ar.get('expr0')));
               }
               
               if(ar.get('Account_Standing__c') == '11-19 Days (Red - Immediate Correction Required)'){
                p.Number_of_exceptions_under_11_19_bucket__c = Decimal.ValueOf(String.ValueOf(ar.get('expr0')));
               }
               
               
               
           }
      }

   }

   if(!accList.isEmpty()){
      update(accList);
   }

 }
    global void finish(Database.BatchableContext bc)
  {
      //FRB_UpdateExceptionsforBatch.FRB_Exceptions();
      Database.executeBatch(new PAM_SendFRBNotificationBatch(),1);
  }
  }