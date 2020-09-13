global class ClosePamUnmatchedRecord implements Database.Batchable<sObject>{

  global final Id recordTypeId ;
  global final String recordTypeName;
  global final String statusType;
  
   global ClosePamUnmatchedRecord (String recordTypeName){
  
     if(recordTypeName != null && recordTypeName!= ''){
       this.recordTypeName = recordTypeName;
       System.debug('======'+recordTypeName);
       this.statusType = 'Accounts Sent To ISeries';
       this.recordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get(recordTypeName.trim()).getRecordTypeId();
      }
      
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      String Query = 'select id , name,(select id , name,PAMUM_Status__c from PAM_Unmatched__r) ,SCMDUM_No_Of_closed_Unmatched__c,SCMDUM_Total_No_Of_Unmatched__c,recordtypeid from Process_Adherence_Monitoring__c where recordtypeid =: recordTypeId AND status__c =:statusType ';
      return Database.getQueryLocator(Query);
   }

   global void execute(Database.BatchableContext BC, List<Process_Adherence_Monitoring__c> scope){
      System.debug('=========scope===='+scope);
      
      List<Process_Adherence_Monitoring__c> pamList = new List<Process_Adherence_Monitoring__c>();
            /*For close the unmatched record here 
            requirement name : scm unmatched process 20200217
            Developer Name   : Avaneesh Singh 
            createDate       : 05/03/2020 
            */ 
      
            for(Process_Adherence_Monitoring__c pam : scope){
                  if(pam.SCMDUM_No_Of_closed_Unmatched__c != null && pam.SCMDUM_Total_No_Of_Unmatched__c != null
                     && pam.SCMDUM_No_Of_closed_Unmatched__c == 0 && pam.SCMDUM_Total_No_Of_Unmatched__c == 0){
                       
                       pam.SCMD_No_Unmatched_This_Reporting_Period__c = true;
                       pamList.add(pam);
                       
                  }
                  
                  if(pam.PAM_Unmatched__r != null && pam.PAM_Unmatched__r.size() > 0){
                     Boolean flag = false;
                     for(PAM_Unmatched__c um : pam.PAM_Unmatched__r){
                        if(um.PAMUM_Status__c != 'Closed'){
                          flag = true;
                        }
                     }
                     if(flag==false){
                      pam.Status__c = 'Closed';   
                     }
                  }else{
                      pam.Status__c = 'Closed';
                  }
                  
            }
      
         if(pamList.size() > 0){
           update pamList;
         }
      
        
       
       /*Map<id,Process_Adherence_Monitoring__c> processAdherenceMap = new Map<Id,Process_Adherence_Monitoring__c>(scope); 
       List<PAM_Unmatched__c> pamUnmatchedList = [select id , name from PAM_Unmatched__c where 
                                                       PAMUM_Process_Adherence_Monitoring__c In :processAdherenceMap.keySet()]; */
   }

   global void finish(Database.BatchableContext BC){
   
   }
}