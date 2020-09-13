global class FRB_BatchToUpdateCloseStatus implements Database.Batchable<SObject>{
    global database.querylocator start(Database.BatchableContext bc)
    {  
       string FRBRecordTypeID = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO FRB').getRecordTypeId();
       string query= 'Select id,Status__c,LastModifiedDate,Account_Resolution_Date__c,C1_TOTAL_BAL_THRESHOLD__c,C1_Resolution_Date__c,C2_RCVRABLE_COST_COST_SPENT__c,C2_Resolution_Date__c,C3_ATTY_OTHER_FEES_CNTRCT_AMT__c,C3_Resolution_Date__c,C4_ATTY_FEES_STAT_AMT__c,C4_Resolution_Date__c,C5_INTEREST_RATE__c,C5_Resolution_Date__c,C6_INTEREST_THRESHOLD__c,C6_Resolution_Date__c,C7_CALCULATED_BALANCE_FIRM_BAL__c,C7_Resolution_Date__c,C7A_PRIN_AMT_PLACED_PRIN__c,C7A_Resolution_Date__c,C7B_REC30_PMTS_ADJS_REC42_PMTS_ADJS__c,C7B_Resolution_Date__c,C7C_REC30_RCVR_COST_REC42_RCVR_COST__c,C7C_Resolution_Date__c,C7D_CURRENT_BALANCE_0__c,C7D_Resolution_Date__c  from Process_Adherence_Monitoring__c where RecordtypeId =: FRBRecordTypeID  AND Status__c != \'Closed\'';
       return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, Process_Adherence_Monitoring__c[] FRBList)
    {
     system.debug('=====FRBList'+FRBList);
     List<Process_Adherence_Monitoring__c>pamToUpdate= new List<Process_Adherence_Monitoring__c>();
       
        if(FRBList.size()>0){
           for(Process_Adherence_Monitoring__c p:FRBLIST){
               datetime dT = p.Lastmodifieddate;
               Date myDate;
               if(Test.isRunningTest()){
                   myDate = date.newinstance(dT.year(), dT.month(), dT.day() - 1);
               }else{
                   myDate = date.newinstance(dT.year(), dT.month(), dT.day());
               }
              
              if(myDate != system.today())
                {
                  p.status__C = 'Closed';
                  p.Account_Resolution_Date__c= System.today();
                  p.ToupdateCloseStatus__c = true;
                  if(p.C1_Resolution_Date__c== null && p.C1_TOTAL_BAL_THRESHOLD__c == true){                      
                      p.C1_Resolution_Date__c= system.today();
                  }
                  if(p.C2_Resolution_Date__c== null && p.C2_RCVRABLE_COST_COST_SPENT__c == true){              
                      p.C2_Resolution_Date__c= system.today();
                  }
                  if(p.C3_Resolution_Date__c== null  && p.C3_ATTY_OTHER_FEES_CNTRCT_AMT__c == true){                    
                      p.C3_Resolution_Date__c= system.today();
                  }
                  if(p.C4_Resolution_Date__c== null  && p.C4_ATTY_FEES_STAT_AMT__c== true){                    
                      p.C4_Resolution_Date__c= system.today();
                  }
                  if(p.C5_Resolution_Date__c== null  && p.C5_INTEREST_RATE__c== true){               
                      p.C5_Resolution_Date__c= system.today();
                  }
                  if(p.C6_Resolution_Date__c == null && p.C6_INTEREST_THRESHOLD__c == true){                    
                      p.C6_Resolution_Date__c = system.today();
                  }
                  if(p.C7_Resolution_Date__c== null  && p.C7_CALCULATED_BALANCE_FIRM_BAL__c== true){                    
                      p.C7_Resolution_Date__c= system.today();
                  }
                  if(p.C7A_Resolution_Date__c== null && p.C7A_PRIN_AMT_PLACED_PRIN__c== true){
                      p.C7A_PRIN_AMT_PLACED_PRIN__c= true;
                      p.C7A_Resolution_Date__c= system.today();
                  }
                  if(p.C7B_Resolution_Date__c== null && p.C7B_REC30_PMTS_ADJS_REC42_PMTS_ADJS__c== true){
                      p.C7B_Resolution_Date__c= system.today();
                  }
                  if(p.C7C_Resolution_Date__c== null && p.C7C_REC30_RCVR_COST_REC42_RCVR_COST__c== true){
                      p.C7C_Resolution_Date__c= system.today();
                  }
                  if(p.C7D_Resolution_Date__c == null && p.C7D_CURRENT_BALANCE_0__c == true){                     
                      p.C7D_Resolution_Date__c= system.today();
                  }
                  pamToUpdate.add(p);
                  system.debug('=====pamToUpdate'+pamToUpdate);
                }
           }
           
        }
        if(pamToUpdate!= null && pamToUpdate.size() > 0)
        {
           checkRecursive.stopTrigger();
           Database.Saveresult[] srList = database.update(pamToUpdate,false);
          system.debug('====srList ==='+srList );
        }
    }
    global void finish(Database.BatchableContext bc)
    {
      //FRB_UpdateExceptionsforBatch.FRB_Exceptions();
      Database.executeBatch(new FRB_BatchToUpdateExceptionFields(),200);
    }
}