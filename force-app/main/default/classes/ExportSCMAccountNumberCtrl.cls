public class ExportSCMAccountNumberCtrl{
   
    public List<SCM_Account_Numbers__c> scmAccList{get;set;}
    public List<wrapperClass> wrapperClassList{get;set;}
    
       public ExportSCMAccountNumberCtrl(){
         wrapperClassList = new List<wrapperClass>();
         
         String ScmIdStr = apexPages.currentPage().getParameters().get('Id');
           if(ScmIdStr != null && ScmIdStr != ''){
               String tempScmId = ScmIdStr.trim().removeEnd('-');
               List<String> pamIdList = new List<String>(tempScmId.split('-'));
                        if(pamIdList != null && pamIdList.size() > 0){
                          scmAccList = [select id,Answer_Filed_Account_s__c,Cease_Desist_Account_s__c,Consumer_Rep_by_Counsel_Account_s__c,
                                        Counter_Claim_Account_s__c , Dismissed_w_out_Predudice_Account_s__c , Dismissed_with_Prejudice_Account_s__c,
                                        Do_Not_Call_Account_s__c , Hardship_End_Account_s__c , Judgment_Account_s__c , Judgment_Satisfied_Account_s__c,
                                        Judgment_Vacated_Account_s__c , Mail_Out_Validation_of_Debt_Account_s__c , 
                                        Oral_Dispute_Account_s__c , Process_Adherence_Monitoring_Record__c,
                                        Return_Mail_on_Disclosure_Account_s__c , Substantiation_Request_Account_s__c , 
                                        Suit_Filed_Account_s__c , Temp_Hardship_Account_s__c,
                                        Written_Dispute_Account_s__c,Process_Adherence_Monitoring_Record__r.Id , Process_Adherence_Monitoring_Record__r.Organization_Name__c
                                        from SCM_Account_Numbers__c where Process_Adherence_Monitoring_Record__c IN :pamIdList ];
                                        
                                      
                           if(scmAccList != null && scmAccList.size() > 0){
                            Map<Id,List<SCM_Account_Numbers__c >> scmAccountGroupMap = new Map<Id,List<SCM_Account_Numbers__c>>();               
                            
                                for(SCM_Account_Numbers__c scmacc: scmAccList){
                                  if(!scmAccountGroupMap.containsKey(scmacc.Process_Adherence_Monitoring_Record__c)){
                                   scmAccountGroupMap.put(scmacc.Process_Adherence_Monitoring_Record__c,new List<SCM_Account_Numbers__c>()); 
                                   }
                                   scmAccountGroupMap.get(scmacc.Process_Adherence_Monitoring_Record__c).add(scmacc);
                                }
                                
                              List<Process_Adherence_Monitoring__c> pamList = [select id , name ,Organization_Name__r.name, Date_Dispute_Account_s_Sent__c,SCMD_Date_Account_Numbers_Received__c,
                                                                               SCMD_NoPCodes_Sent_This_Reporting_Period__c,No_Dispute_Codes_Sent_in_Report_Period__c,
                                                                               SCMD_Date_Dispute_AccountNumbersReceived__c,Account_Resolution_Date__c
                                                                               from Process_Adherence_Monitoring__c 
                                                                               Where id IN:scmAccountGroupMap.keySet() and status__c = 'Account Numbers Added'];  
                                
                                    for(Process_Adherence_Monitoring__c pam : pamList){
                                      if(pam.SCMD_Date_Dispute_AccountNumbersReceived__c != null || pam.SCMD_Date_Account_Numbers_Received__c != null){
                                         wrapperClass wc = new wrapperClass();
                                         wc.accName = pam.Organization_Name__r.name;
                                         wc.dispute    = pam.SCMD_Date_Dispute_AccountNumbersReceived__c != null ? (pam.Date_Dispute_Account_s_Sent__c == null ? true : false) : false;
                                         wc.nonDispute = pam.SCMD_Date_Account_Numbers_Received__c != null ? true : false;
                                         wc.scmAccList = scmAccountGroupMap.containsKey(pam.id) ? scmAccountGroupMap.get(pam.id) : new List<SCM_Account_Numbers__c>();
                                         wrapperClassList.add(wc); 
                                      }
                                    }
                          }   
                      }
            }
       } 
       
   public class wrapperClass{
      public boolean dispute{get;set;}
      public boolean nonDispute{get;set;}
      public String accName{get;set;}
      public List<SCM_Account_Numbers__c> scmAccList{get;set;}
   }    
       
}