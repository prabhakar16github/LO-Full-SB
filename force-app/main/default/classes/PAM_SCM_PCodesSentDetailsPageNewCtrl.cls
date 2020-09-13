public class PAM_SCM_PCodesSentDetailsPageNewCtrl{
    
    public Boolean flag {get;set;}
    public WrapperClass wc{get;set;}
    
    
    @RemoteAction
    
    public static wrapperClass getFirstHalfAccountNumberInfo(String objId ){
        WrapperClass wc= new WrapperClass();
        if(objId != null && objId != ''){
            
            List<Process_Adherence_Monitoring__c> pamObjList = [select id , name,SCMD_NoPCodes_Sent_This_Reporting_Period__c,
                                                                No_Dispute_Codes_Sent_in_Report_Period__c,SCMD_MailOutValidDebt_Acc_Vol__c,
                                                                SCMD_OralDispAcc_Vol__c,SCMD_WrittenDispAccVol__c from Process_Adherence_Monitoring__c 
                                                                where id=:objId];
            
            if(pamObjList[0].SCMD_MailOutValidDebt_Acc_Vol__c != null || pamObjList[0].SCMD_OralDispAcc_Vol__c!= null 
                            || pamObjList[0].SCMD_WrittenDispAccVol__c != null){
              wc.conditionalMessage = true;
            }
            
            List<SCM_Account_Numbers__c> scmAccountNumberList = [select id ,S_No__c,Answer_Filed_Account_s__c,Cease_Desist_Account_s__c,
                                                                 Consumer_Rep_by_Counsel_Account_s__c,Counter_Claim_Account_s__c,Dismissed_w_out_Predudice_Account_s__c,
                                                                 Dismissed_with_Prejudice_Account_s__c,Do_Not_Call_Account_s__c,Hardship_End_Account_s__c,
                                                                 Judgment_Account_s__c,Judgment_Satisfied_Account_s__c,Judgment_Vacated_Account_s__c,
                                                                 Mail_Out_Validation_of_Debt_Account_s__c,Oral_Dispute_Account_s__c,Process_Adherence_Monitoring_Record__c,
                                                                 Return_Mail_on_Disclosure_Account_s__c,Substantiation_Request_Account_s__c,Suit_Filed_Account_s__c,
                                                                 Temp_Hardship_Account_s__c,Written_Dispute_Account_s__c from SCM_Account_Numbers__c 
                                                                 where Process_Adherence_Monitoring_Record__c =: objId order by S_No__c];
            
            
            if(pamObjList != null && pamObjList.size() > 0){
                wc.first_halfToShow = pamObjList[0].SCMD_NoPCodes_Sent_This_Reporting_Period__c;
                wc.second_halfToShow = pamObjList[0].No_Dispute_Codes_Sent_in_Report_Period__c; 
            }
            
            
            
            
            if(scmAccountNumberList != null && scmAccountNumberList.size() > 0){
                
                for(SCM_Account_Numbers__c san : scmAccountNumberList){
                    if(san.Answer_Filed_Account_s__c != null)
                        wc.AnswerFiledAccount  += san.Answer_Filed_Account_s__c+'\n';
                    if(san.Judgment_Vacated_Account_s__c!= null)
                        wc.judgmentVacatedAccount += san.Judgment_Vacated_Account_s__c+'\n';
                    if(san.Mail_Out_Validation_of_Debt_Account_s__c!= null)
                        wc.mailOutValidation += san.Mail_Out_Validation_of_Debt_Account_s__c+'\n';
                    if(san.Cease_Desist_Account_s__c!= null)
                        wc.CeaseDesistAccount += san.Cease_Desist_Account_s__c+'\n';
                    if(san.Oral_Dispute_Account_s__c!= null)
                        wc.OralDisputeAccount += san.Oral_Dispute_Account_s__c+'\n';
                    if(san.Consumer_Rep_by_Counsel_Account_s__c!= null)
                        wc.ConsumerRepByConsuel += san.Consumer_Rep_by_Counsel_Account_s__c+'\n';
                    if(san.Return_Mail_on_Disclosure_Account_s__c!= null)
                        wc.returnMailOnDisclouser += san.Return_Mail_on_Disclosure_Account_s__c+'\n';
                    if(san.Counter_Claim_Account_s__c!= null)
                        wc.counterClaimAccount += san.Counter_Claim_Account_s__c+'\n';
                    if(san.Suit_Filed_Account_s__c!= null)
                        wc.suitFieldAccount += san.Suit_Filed_Account_s__c+'\n';
                    
                }
            }                 
        }
        return wc;
    }
    
    @RemoteAction
    public static wrapperClass getSecondHalfAccountNumberInfo(String objId ){
        WrapperClass wc = new WrapperClass();
        if(objId != null && objId != ''){
            List<SCM_Account_Numbers__c> scmAccountNumberList = [select id ,S_No__c,Answer_Filed_Account_s__c,Cease_Desist_Account_s__c,
                                                                 Consumer_Rep_by_Counsel_Account_s__c,Counter_Claim_Account_s__c,Dismissed_w_out_Predudice_Account_s__c,
                                                                 Dismissed_with_Prejudice_Account_s__c,Do_Not_Call_Account_s__c,Hardship_End_Account_s__c,
                                                                 Judgment_Account_s__c,Judgment_Satisfied_Account_s__c,Judgment_Vacated_Account_s__c,
                                                                 Mail_Out_Validation_of_Debt_Account_s__c,Oral_Dispute_Account_s__c,Process_Adherence_Monitoring_Record__c,
                                                                 Return_Mail_on_Disclosure_Account_s__c,Substantiation_Request_Account_s__c,Suit_Filed_Account_s__c,
                                                                 Temp_Hardship_Account_s__c,Written_Dispute_Account_s__c from SCM_Account_Numbers__c 
                                                                 where Process_Adherence_Monitoring_Record__c =: objId order by S_No__c];
            
            if(scmAccountNumberList != null && scmAccountNumberList.size() > 0){
                
                
                for(SCM_Account_Numbers__c san : scmAccountNumberList){
                    if(san.Dismissed_with_Prejudice_Account_s__c!= null)
                        wc.dismissedWithPrejudice+= san.Dismissed_with_Prejudice_Account_s__c+'\n';
                    if(san.Temp_Hardship_Account_s__c!= null)
                        wc.tempHardshipAccount += san.Temp_Hardship_Account_s__c+'\n';
                    if(san.Dismissed_w_out_Predudice_Account_s__c!= null)
                        wc.dismissedWOPrejudice += san.Dismissed_w_out_Predudice_Account_s__c+'\n';
                    if(san.Written_Dispute_Account_s__c!= null)
                        wc.writtenDisputeAccount += san.Written_Dispute_Account_s__c+'\n';
                    if(san.Do_Not_Call_Account_s__c!= null)
                        wc.doNotCall += san.Do_Not_Call_Account_s__c+'\n';
                    if(san.Hardship_End_Account_s__c!= null)
                        wc.hardshipEndAccount += san.Hardship_End_Account_s__c+'\n';
                    if(san.Judgment_Account_s__c!= null)
                        wc.judgementAccount += san.Judgment_Account_s__c+'\n';
                    if(san.Judgment_Satisfied_Account_s__c!= null)
                        wc.JudgmentSatisfiedAccou += san.Judgment_Satisfied_Account_s__c+'\n';
                    if(san.Substantiation_Request_Account_s__c!= null)
                        wc.SubstantiationReqAcco += san.Substantiation_Request_Account_s__c+'\n';
                }
            }                 
        }
        return wc;
    }
    
    
    
    
    @RemoteAction
    
    public static void deleteChildRecord(String sobjectId){
        if(sobjectId != null && sobjectId != ''){
            List<SCM_Account_Numbers__c> scmAccountInfoList  = [select id , name from SCM_Account_Numbers__c where Process_Adherence_Monitoring_Record__c =: sobjectId ];
            if(scmAccountInfoList  != null && scmAccountInfoList.size() > 0){
                delete scmAccountInfoList  ;
                // update the parent result with zero
                Map<String,String> allFieldApiMap = getFieldMapingToCount();
                if(allFieldApiMap != null && allFieldApiMap.size() > 0){
                    Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c(id=sobjectId);
                    for(String str : allFieldApiMap.values()){
                        pamObj.put(str.trim() , 0);
                    }
                    update pamObj;
                }
            }
        }
    }
    
    
    @RemoteAction
    
    public static void saveRecordBtn(String fieldApiName , List<String> fieldInfoData, String sobjectId){
        Set<String> ScmAccountNumberFieldSet = new Set<String>{'mail_out_validation_of_debt_account_s__c','oral_dispute_account_s__c','written_dispute_account_s__c'};
            
            if(fieldApiName != null  && fieldApiName != '' && fieldInfoData != null && 
               sobjectId != null  && sobjectId != '' ){
                   
                   List<Process_Adherence_Monitoring__c> pamObjList = [select id , name , SCMD_AnswerFiledActVolume__c,SCMD_CeaseDesistActVolume__c,
                                                                       SCMD_ConsumerRepbyCounselActVolume__c,SCMD_CounterClaimActVolume__c,SCMD_DismissedwoutPrejudiceActVolume__c,
                                                                       SCMD_DismissedwithPrejudiceActVolume__c,SCMD_DoNotCallActVolume__c,SCMD_Hardship_End_Act_Volume__c,
                                                                       SCMD_JudgmentActVolume__c,SCMD_JudgmentSatisfiedActVolume__c,SCMD_JudgmentVacatedActVolume__c,
                                                                       SCMD_MailOutValidDebt_Acc_Vol__c,SCMD_OralDispAcc_Vol__c,SCMD_ReturnMailonDisclosureActVolume__c,
                                                                       SCMD_SubstantiationRequestActVolume__c,SCMD_SuitFiledActVolume__c,SCMD_TempHardshipActVolume__c,SCMD_WrittenDispAccVol__c
                                                                       from Process_Adherence_Monitoring__c where id = : sobjectId];
                   
                   String parentFieldApiName = getFieldMapingToCount().containsKey(fieldApiName.trim()) ? getFieldMapingToCount().get(fieldApiName.trim()) : '';
                   if(parentFieldApiName != null && parentFieldApiName != '' ){
                       Decimal num =  pamObjList[0].get(parentFieldApiName) != null ? (Decimal)pamObjList[0].get(parentFieldApiName) : 0 ;
                       
                       Decimal counterVal = 0.0;
                       for(String st : fieldInfoData){
                           List<String> tempStrList = st.split('\n');
                           counterVal += tempStrList.size();
                       }
                       
                       num += counterVal;
                       
                       Process_Adherence_Monitoring__c pam = new Process_Adherence_Monitoring__c(id=sobjectId);
                       pam.put(parentFieldApiName , num);
                       if(counterVal >=1){
                           if(ScmAccountNumberFieldSet.contains(fieldApiName.trim().toLowerCase())){
                               
                               pam.put('Status__c','Account Numbers Added');
                               pam.put('SCMD_Date_Dispute_AccountNumbersReceived__c',Date.today());
                           }else{
                               pam.put('Status__c','Account Numbers Added');
                               pam.put('SCMD_Date_Account_Numbers_Received__c',Date.today());
                               
                           }
                       }
                       update pam;
                       
                   }
                   
                   
                   
                   List<SCM_Account_Numbers__c> scmAccountNumberList = [select id , name,S_No__c from SCM_Account_Numbers__c 
                                                                        where Process_Adherence_Monitoring_Record__c =: sobjectId order by S_No__c Asc];
                   
                   if(scmAccountNumberList.size() > 0){
                       if( fieldInfoData.size() > 0 && fieldInfoData.size() <= scmAccountNumberList.size()){
                           
                           Integer counter = 0;
                           List<SCM_Account_Numbers__c > scmAccTempList = new List<SCM_Account_Numbers__c >();
                           
                           for(String str :  fieldInfoData){
                               SCM_Account_Numbers__c tempAcc = scmAccountNumberList[counter];  
                               tempAcc.put(fieldApiName.trim() , str);
                               scmAccTempList.add(tempAcc);
                               counter ++;
                               
                           } 
                           
                           if(scmAccTempList.size() >0){
                               update scmAccTempList;
                           }
                           
                       }else if(fieldInfoData.size() > 0 && fieldInfoData.size() > scmAccountNumberList.size()){
                           List<SCM_Account_Numbers__c> tempRecordAccountNumberList = new List<SCM_Account_Numbers__c>();
                           Integer counter = 0;
                           
                           for(String str : fieldInfoData){
                               if(counter <= scmAccountNumberList.size()-1){
                                   
                                   SCM_Account_Numbers__c tempAcc = scmAccountNumberList[counter];
                                   tempAcc.put(fieldApiName.trim() , str);
                                   tempRecordAccountNumberList.add(tempAcc);
                                   
                               }else{
                                   
                                   SCM_Account_Numbers__c san = new SCM_Account_Numbers__c();
                                   san.put(fieldApiName.trim() , str);
                                   san.put('S_No__c',counter);
                                   san.put('Process_Adherence_Monitoring_Record__c',sobjectId);
                                   tempRecordAccountNumberList.add(san);
                                   
                               }
                               counter ++ ;
                           }
                           upsert tempRecordAccountNumberList;
                           
                       }
                       
                   }else{
                       List<SCM_Account_Numbers__c> scmAccList = new List<SCM_Account_Numbers__c>();
                       Integer counter = 0;
                       
                       for(String str : fieldInfoData){
                           SCM_Account_Numbers__c sa = new SCM_Account_Numbers__c();
                           sa.put(fieldApiName.trim() , str);
                           sa.put('S_No__c',counter);
                           sa.put('Process_Adherence_Monitoring_Record__c',sobjectId);
                           scmAccList.add(sa);
                           counter ++;
                       }
                       insert scmAccList;
                   }          
               }
    }
    
    public static Map<String,String> getFieldMapingToCount(){
        
        Map<String,String> childToParentFieldMap = new Map<String,String>();
        childToParentFieldMap.put('Answer_Filed_Account_s__c','SCMD_AnswerFiledActVolume__c'); 
        childToParentFieldMap.put('Cease_Desist_Account_s__c','SCMD_CeaseDesistActVolume__c'); 
        childToParentFieldMap.put('Consumer_Rep_by_Counsel_Account_s__c','SCMD_ConsumerRepbyCounselActVolume__c'); 
        childToParentFieldMap.put('Counter_Claim_Account_s__c','SCMD_CounterClaimActVolume__c'); 
        childToParentFieldMap.put('Dismissed_w_out_Predudice_Account_s__c','SCMD_DismissedwoutPrejudiceActVolume__c'); 
        childToParentFieldMap.put('Dismissed_with_Prejudice_Account_s__c','SCMD_DismissedwithPrejudiceActVolume__c'); 
        childToParentFieldMap.put('Do_Not_Call_Account_s__c','SCMD_DoNotCallActVolume__c'); 
        childToParentFieldMap.put('Hardship_End_Account_s__c','SCMD_Hardship_End_Act_Volume__c'); 
        childToParentFieldMap.put('Judgment_Account_s__c','SCMD_JudgmentActVolume__c'); 
        childToParentFieldMap.put('Judgment_Satisfied_Account_s__c','SCMD_JudgmentSatisfiedActVolume__c'); 
        childToParentFieldMap.put('Judgment_Vacated_Account_s__c','SCMD_JudgmentVacatedActVolume__c'); 
        childToParentFieldMap.put('Mail_Out_Validation_of_Debt_Account_s__c','SCMD_MailOutValidDebt_Acc_Vol__c'); 
        childToParentFieldMap.put('Oral_Dispute_Account_s__c','SCMD_OralDispAcc_Vol__c'); 
        childToParentFieldMap.put('Return_Mail_on_Disclosure_Account_s__c','SCMD_ReturnMailonDisclosureActVolume__c'); 
        childToParentFieldMap.put('Substantiation_Request_Account_s__c','SCMD_SubstantiationRequestActVolume__c'); 
        childToParentFieldMap.put('Suit_Filed_Account_s__c','SCMD_SuitFiledActVolume__c'); 
        childToParentFieldMap.put('Temp_Hardship_Account_s__c','SCMD_TempHardshipActVolume__c'); 
        childToParentFieldMap.put('Written_Dispute_Account_s__c','SCMD_WrittenDispAccVol__c'); 
        
        return childToParentFieldMap;
    }
    
    
    public class WrapperClass{
        public String AnswerFiledAccount{get;set;}
        public String judgmentVacatedAccount{get;set;}
        public String mailOutValidation{get;set;}
        public String CeaseDesistAccount{get;set;} 
        public String OralDisputeAccount{get;set;}
        public String ConsumerRepByConsuel{get;set;}
        public String returnMailOnDisclouser{get;set;}
        public String counterClaimAccount{get;set;}
        public String suitFieldAccount{get;set;}
        public String dismissedWithPrejudice{get;set;}
        public String tempHardshipAccount{get;set;}
        public String dismissedWOPrejudice{get;set;}
        public String writtenDisputeAccount{get;set;}
        public String doNotCall{get;set;}
        public String hardshipEndAccount{get;set;}
        public String judgementAccount{get;set;} 
        public String JudgmentSatisfiedAccou{get;set;}
        public String SubstantiationReqAcco{get;set;}
        public boolean first_halfToShow{get;set;}
        public boolean second_halfToShow{get;set;}
        public boolean conditionalMessage{get;set;}
        
        public WrapperClass(){
            this.conditionalMessage = false;
            this.first_halfToShow = false;
            this.second_halfToShow = false;
            this.AnswerFiledAccount ='';
            this.judgmentVacatedAccount ='';
            this.mailOutValidation ='';
            this.CeaseDesistAccount='';
            this.OralDisputeAccount='';
            this.ConsumerRepByConsuel='';
            this.returnMailOnDisclouser='';
            this.counterClaimAccount='';
            this.suitFieldAccount='';
            this.dismissedWithPrejudice='';
            this.tempHardshipAccount='';
            this.dismissedWOPrejudice='';
            this.writtenDisputeAccount='';
            this.doNotCall='';
            this.hardshipEndAccount='';
            this.judgementAccount='';
            this.JudgmentSatisfiedAccou = '';
            this.SubstantiationReqAcco = '';
        }
        
        
    }
    
}