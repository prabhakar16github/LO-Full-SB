@isTest
public class PCodesSentDetailsPageNewCtrl_Test{
     
    public static SCM_Account_Numbers__c accountNumber(){
        SCM_Account_Numbers__c acc = new SCM_Account_Numbers__c();
        acc.Answer_Filed_Account_s__c ='11';
        acc.Cease_Desist_Account_s__c = '11';
        acc.Consumer_Rep_by_Counsel_Account_s__c='11';
        acc.Counter_Claim_Account_s__c='11';
        acc.Dismissed_w_out_Predudice_Account_s__c='11';
        acc.Dismissed_with_Prejudice_Account_s__c='11';
        acc.Do_Not_Call_Account_s__c='11';
        acc.Hardship_End_Account_s__c='11';
        acc.Judgment_Account_s__c='11';
        acc.Judgment_Satisfied_Account_s__c='11';
        acc.Judgment_Vacated_Account_s__c='11';
        acc.Mail_Out_Validation_of_Debt_Account_s__c='11';
        acc.Oral_Dispute_Account_s__c='11';
        acc.Return_Mail_on_Disclosure_Account_s__c='11';
        acc.Substantiation_Request_Account_s__c='11';
        acc.Suit_Filed_Account_s__c='11';
        acc.Temp_Hardship_Account_s__c='11';
        acc.Written_Dispute_Account_s__c='11';
        return acc;
    }
     public static testMethod void testCase(){
       Process_Adherence_Monitoring__c pc = new Process_Adherence_Monitoring__c();
       Id recordtypeid = schema.sobjecttype.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute').getRecordTypeId();
       pc.recordtypeid = recordtypeid;
       pc.SCMD_Reporting_Period__c = '2020-02';
       insert pc;
         SCM_Account_Numbers__c scm=accountNumber();
         scm.Process_Adherence_Monitoring_Record__c=pc.id;
         insert scm;
       PAM_SCM_PCodesSentDetailsPageNewCtrl.getFirstHalfAccountNumberInfo(pc.id);
       PAM_SCM_PCodesSentDetailsPageNewCtrl.getSecondHalfAccountNumberInfo(pc.id); 
         PAM_SCM_PCodesSentDetailsPageNewCtrl.saveRecordBtn('Written_Dispute_Account_s__c',new List<String>{'11','22'},pc.id); 
       PAM_SCM_PCodesSentDetailsPageNewCtrl.getFieldMapingToCount();  
       PAM_SCM_PCodesSentDetailsPageNewCtrl.deleteChildRecord(pc.id);
         
     }

}