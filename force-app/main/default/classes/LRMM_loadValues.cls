public with sharing class LRMM_loadValues {
Public List<Trial_Witness_Request__c>trialWitnessRecordList = new list<Trial_Witness_Request__c>();
Public List<Counterclaim__c>ccRecordList = new list<Counterclaim__c>();
Public List<Discovery__c>discoveryRecordList = new list<Discovery__c>();
Public List<Appeal__c>appealRecordList = new list<Appeal__c>();
Public List<Settlement_Approval__c>settlementRecordList = new List<Settlement_Approval__c>();
Public List<Counterclaim__c>ccRecordListToDisplay = new list<Counterclaim__c>();
Public List<Appeal__c>appealRecordListToDisplay = new list<Appeal__c>();
Public List<Discovery__c>disRecordListToDisplay= new list<Discovery__c>();
Public List<Trial_Witness_Request__c>LWRecordListToDisplay= new list<Trial_Witness_Request__c>();
Public List<Settlement_Approval__c>SettlementRecordtoDisplay = new List<Settlement_Approval__c>();
Public List<Business_Record_Affidavit__c>BRAtoDisplay = new List<Business_Record_Affidavit__c>();
Public List<Business_Record_Affidavit__c> BusinessRecordList = new List<Business_Record_Affidavit__c>();
Public List<Purchase_and_Sales_Agreement__c> psarecordList = new List<Purchase_and_Sales_Agreement__c>();
Public List<Purchase_and_Sales_Agreement__c> psatoDisplay = new List<Purchase_and_Sales_Agreement__c>();
public boolean showCC{get;set;}
public boolean showCCOutput{get;set;}
public boolean showCCinput{get;set;}
public boolean Showdiscvry{get;set;}
public boolean Showappeal{get;set;}
public boolean ShowLiveWitness{get;set;}
public boolean Settle{get;set;}
public boolean Businessrecord{get;set;}
public boolean PurchaseandSales{get;set;}
public String appealid{get;set;}
public String BRAId{get;set;}
public String CounterclaimId{get;set;}
public String DiscoveryId{get;set;}
public String LiveWitnessId{get;set;}
public String SettlementId{get;set;}
public String PSAId{get;set;}

    public LRMM_loadValues(ApexPages.StandardController controller) {
        Id pageId = ApexPages.currentPage().getParameters().get('id');
        Consumer_Account_Details__c[] CADList = [select id,Organization_name__r.id,Account_Number__c,OwnerId,Name,Original_Creditor__c,Chain_of_Title__c,Portfolio__c  from Consumer_Account_Details__c where id =: pageId];
        system.debug('==pageId'+pageId);
        string shocc =ApexPages.currentPage().getParameters().get('showCC');
        string discv=ApexPages.currentPage().getParameters().get('showdisc');
        string appeals=ApexPages.currentPage().getParameters().get('showApeal');
        string livewitness = ApexPages.currentPage().getParameters().get('showlive');
        string Setlment = ApexPages.currentPage().getParameters().get('settlemnt');
        string Braffidavit = ApexPages.currentPage().getParameters().get('brecordaffidavit');
        string PurSaleAgreement = ApexPages.currentPage().getParameters().get('psagreement');
        system.debug('==pageId'+shocc );
        system.debug('==showCC '+showCC );
        if(shocc =='1'){
          showCC = true;
          system.debug('==showCC '+showCC );
        }
        if(discv=='1'){
          Showdiscvry= true;
          system.debug('==showCC '+Showdiscvry);
        }
        if(appeals=='1'){
          Showappeal= true;
          system.debug('==showCC '+Showappeal);
        }
        if(livewitness  =='1'){
          ShowLiveWitness= true;
        }
        if(Setlment == '1')
        {
            Settle = true;
        }
        if(Braffidavit == '1')
        {
            Businessrecord = true;
            system.debug('==Businessrecord '+Businessrecord);
        }
        if(PurSaleAgreement == '1')
        {
            PurchaseandSales = true;
            system.debug('==PurchaseandSales '+PurchaseandSales);
        }
        Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName();
         Id rtLeadID =  rtMap.get('Live Witness Request Step I').getRecordTypeId(); 
        Map<String,Schema.RecordTypeInfo> rtMap1 = Schema.SObjectType.Business_Record_Affidavit__c.getRecordTypeInfosByName();
         Id rtLeadID1 =  rtMap1.get('BRA: Record Type').getRecordTypeId();         
        Map<String,Schema.RecordTypeInfo> rtMap2 = Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName();
         Id rtLeadID2 =  rtMap2.get('Telephonic Witness Request').getRecordTypeId();    
        Map<String,Schema.RecordTypeInfo> rtMap3 = Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName();
         Id rtLeadID3 =  rtMap3.get('Telephonic Witness Request San Marcos').getRecordTypeId();                

         system.debug('rtMap2-->'+rtMap2);
         system.debug('rtLeadID1-->'+rtLeadID1);
         system.debug('rtMap3-->'+rtMap3);
         system.debug('rtLeadID2-->'+rtLeadID2);
         system.debug('rtLeadID3-->'+rtLeadID3);
         
            
        trialWitnessRecordList = [select Witness_Post_Trial_Review_Complete__c, Witness_Determination__c, Witness_Appeared__c, Where_will_Witness_Meet_Attorney__c, 
                                         What_Media_is_Needed_for_Trial__c, Wait_Time__c, Trial_Witness_Phone_Number__c, Trial_Witness_Name__c, Trial_Witness_Extension__c, Trial_Time__c, 
                                         Trial_Time_Remove_Colon__c, Trial_Time_Changed__c, Trial_Status__c, Trial_Outcome__c, Trial_Outcome_Comments__c, Trial_Date_7__c, Transcript_Requested__c,
                                         Transcript_Provided__c, Time_of_Trial__c, Time_of_Appearance__c, Time_Zone__c, Testimony_Time__c, Testified__c, TW_State__c, TW_Consumer_Account_Records__c, 
                                         SystemModstamp, Suit_Balance__c, Subject_Matter_to_be_Covered__c, Status__c, State_Filed_State_Profile__c, Settlement_Offer_Type__c, Settlement_Offer_Amount__c, 
                                         Settlement_Chance_Prior_to_Hearing__c, Settlement_Attempted__c, Settlement_Attempted_Comments__c, Required_Media_Obtained__c, Required_Media_Documents_Attached__c,
                                         Required_Affidavits_Obtained__c, Required_Affidavits_Attached__c, RecordTypeId, Proposed_Questions_Attached__c, Prior_Experience_with_Judge__c, Prep_Time__c,
                                         Potential_Issues_or_Limitations__c, Post_Judgment_Collectability__c, OwnerId, Other_Considerations__c, OrganizationName__c, Opposing_Counsel__c, 
                                         Opposing_Counsel_Phone__c, Opposing_Counsel_Firm_Name__c, Opposing_Counsel_Email__c, Opposing_Counsel_Comments__c, Notary__c, Notary_Name__c,
                                         Name, Motion_Granted_in_part_Defendant__c, Motion_Granted_in_Part_Plaintiff__c, Last_Settlement_Offer_by__c, LastViewedDate,
                                         LastReferencedDate, LastModifiedDate, LastModifiedById, LastActivityDate, LW_Witness_Subpoenaed__c, LW_Subpoenaed_Witness_Name__c, LW_Matter_Name__c, 
                                         LW_Closed_Date__c, LW_ClosedDate_CreatedDate__c, LW_Age__c, Judge_Name__c, Is_Missing_Attachments_Notification_Sent__c, IsDeleted, If_no_Why_Not_Plaintiff__c,
                                         If_Yes_What_part_Plaintiff__c, If_Yes_What_part_Defendant__c, If_Propounded_Date_Response_Sent__c, If_Prior_Experience_with_Judge_Comments__c, If_Discovery_Sent_When__c,
                                         Id, Has_Media_been_requested__c, Hardship__c, Hardship_Solution__c, Hardship_Documents_Attached__c, General_Overview_of_Testimony_Attached__c, 
                                         Factual_Basis_of_Allegations__c, Expected_OC_Questions_Attached__c, Estimated_Time_Frame_for_Trial__c, Documents_for_Witness_Attached__c, Dispute__c, 
                                         Dispute_Solution__c, Dispute_Documents_Attached__c, Disposition_Motion_Attempted_Plaintiff__c, Disposition_Motion_Attempted_Defendant__c, 
                                         Disp_Motion_Docs_Attached_Plaintiff__c, Disp_Motion_Docs_Attached_Defendant__c, Discovery_Status__c, Discovery_Sent_to_Defendant__c, 
                                         Discovery_Propounded_on_MCM__c, Discovery_Documents_Attached__c, Dept_Div_Room__c, Defendant_Name__c, Days_Since_Date_of_Trial__c,
                                         Days_Appearance_Is_Expected_To_Last__c, Date_of_Trial__c, Date_of_Trial_Changed__c, Date_of_Appearance__c, Date_Response_is_Needed_By__c,
                                         Date_Affidavit_s_Requested__c, CreatedDate, CreatedById, Court_Zip_Code__c, Court_Street_Address__c, Court_State__c, Court_File__c, 
                                         Court_Costs__c, Court_City__c, County_Filed__c, County_Court_Name__c, Counterclaim__c, ConnectionSentId, ConnectionReceivedId, 
                                         Chance_Of_Success_if_We_Appear__c, Central_Time__c, Central_Time_Text__c, Central_Time_Conversion__c, Case__c, Call_In__c, Brief_History__c, 
                                         Brief_Case_History_Attached__c, Attachments__c, Assigned_Attorney__c, Assigned_Attorney_Email__c, Assigned_Attorney_Direct_Line__c, Assigned_Attorney_Cell_Phone__c,
                                         Appearance_Type__c, Allegations__c, Account_Number__c, AM_PM__c,State_Filed_State_Profile__r.id,OrganizationName__r.id  from Trial_Witness_Request__c where TW_Consumer_Account_Records__c =:pageId AND Recordtypeid !=: rtLeadID2 AND Recordtypeid !=: rtLeadID3 limit 1];
                                         system.debug('==trialWitnessRecordList '+trialWitnessRecordList );
                 ccRecordList =  [Select SystemModstamp, OwnerId, Name, LastViewedDate, LastReferencedDate, LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted,
                                         Id, CreatedDate, CreatedById, ConnectionSentId, ConnectionReceivedId, CC_Terms_Conditions__c, CC_Statements_in_Possession__c, CC_State_Suit_Theory__c, 
                                         CC_State_Filed__c, CC_Purchase_and_Sale_Agreement_Requested__c, CC_Prior_Experience_with_Judge__c, CC_Paralegal_Assignment__c, 
                                         CC_Organization_Name__c, CC_Opposing_counsel_Phone__c, CC_Opposing_Counsel__c, CC_Opposing_Counsel_Firm_Name__c, CC_Opposing_Counsel_Email__c, 
                                         CC_Opposing_Counsel_Comments__c, CC_One_Off_Affidavit_Requested__c, CC_NOA_Sent_to_Consumer_State_Dependent__c, CC_Motion_to_Compel_PLTF_Filed__c, 
                                         CC_Motion_to_Compel_DEF_Filed__c, CC_Media_Chain_of_Title_Notes__c, CC_Matter_Name__c, CC_MSJ_Recommended__c, CC_Litigation_Type__c, CC_Key_Issue_PL__c,
                                         CC_Key_Issue_PL_Notes__c, CC_Key_Issue_Attorney__c, CC_Key_Issue_Attorney_Notes__c, CC_Judge_Name__c, CC_If_Yes_MSJ_Due_Date__c,
                                         CC_If_Yes_Discovery_Propounded_Due_Date__c, CC_IfPriorExperience_with_Judge_Comments__c, CC_Firm_Recommedation__c, CC_Discovery_Propounded_on_MCM__c, 
                                         CC_Discovery_Documents_Attached__c, CC_Date_Counterclaim_Response_Due_by__c, CC_Date_Counterclaim_Filed__c, CC_Court_File__c, CC_County_Court_Name__c,
                                         CC_Counterclaim_Status__c, CC_Consumer_Account_Detail_Name__c, CC_Complaint_Attached__c, CC_Closed_Date__c, CC_ClosedDate_CreatedDate__c, 
                                         CC_Chain_of_Title_Summary__c, CC_Business_Record_Affidavit_Requested__c, CC_Attorney_Recommendation_Comments__c, CC_Attorney_Assignment__c, 
                                         CC_Attorney_Approval_of_Recommendation__c, CC_Attorney_Approval_Needed__c, CC_Attachments__c, CC_Assigned_To__c, CC_Assigned_Attorney__c, 
                                         CC_Assigned_Attorney_Email__c, CC_Assigned_Attorney_Direct_Line__c, CC_Assigned_Attorney_Cell_Phone__c, CC_Allegation_Summary_From_PL__c,
                                         CC_Allegation_Summary_From_Firm__c, CC_Additional_Statements_Requested__c, CC_Account_Number__c,CC_State_Filed__r.id,CC_Organization_Name__r.id 
                                         From Counterclaim__c where CC_Consumer_Account_Detail_Name__c  =: pageId limit 1];
                                         system.debug('==ccRecordList '+ccRecordList );
           discoveryRecordList = [select DY_Account_Number__c,DY_Attorney_Assignment__c,DY_Consumer_Account_Details__r.id,DY_Paralegal_Assignment__c,DY_State_Filed__c,DY_State_Filed__r.id,DY_Matter_Name__c,DY_County_Court_Name__c,DY_Court_File__c,DY_Judge_Name__c,DY_Prior_Experience_with_Judge__c,DY_IfPriorExperience_with_Judge_Comments__c,DY_Assigned_Attorney__c,DY_Assigned_Attorney_Cell_Phone__c,DY_Assigned_Attorney_Direct_Line__c,DY_Assigned_Attorney_Email__c,
                                         DY_Opposing_Counsel__c,ownerId,DY_Organization_Name__c,DY_Organization_Name__r.id,DY_Opposing_Counsel_Comments__c,DY_Opposing_Counsel_Email__c,DY_Opposing_Counsel_Firm_Name__c,DY_Opposing_counsel_Phone__c,DY_Consumer_Account_Details__c,DY_Other__c,DY_Other_Discovery_Type_Comments__c from Discovery__c  where DY_Consumer_Account_Details__c  =: pageid limit 1];
              appealRecordList = [select AP_Account_Number__c,AP_Matter_Name__c,AP_State_Filed__c,AP_State_Filed__r.id,AP_County_Filed__c,AP_Court_File__c,AP_County_Court_Name__c,
                                         AP_Judge_Name__c,AP_Prior_Experience_with_Judge__c,AP_Assigned_Attorney__c,AP_Assigned_Attorney_Cell_Phone__c,AP_Assigned_Attorney_Direct_Line__c,
                                         AP_Assigned_Attorney_Email__c,ownerId,AP_IfPriorExperience_with_Judge_Comments__c,AP_Opposing_Counsel__c,AP_Opposing_Counsel_Comments__c,
                                         AP_Opposing_Counsel_Email__c,AP_Opposing_Counsel_Firm_Name__c,AP_Opposing_counsel_Phone__c,AP_Consumer_Account_Record__c,AP_Organization_Name__c,
                                         AP_Organization_Name__r.id from Appeal__c where AP_Consumer_Account_Record__c =: pageid limit 1];
          settlementRecordList = [select SystemModstamp, Settlement_Approval_Status__c, SA_Type_of_Threat__c, SA_Tracking_Number_of_Check_Sent__c, SA_Threat_of_litigation__c, 
                                         SA_State_Filed__c, SA_State_Filed__r.id,SA_Organization_Name__r.id,SA_Settlement_Type__c, SA_Settlement_Offer_Approval__c, SA_Settlement_Amount__c, SA_Prior_Experience_with_Judge__c, SA_Paralegal_Assignment__c, 
                                         SA_PL_Recommendation__c, SA_Organization_Name__c, SA_Opposing_counsel_Phone__c, SA_Opposing_Counsel__c, SA_Opposing_Counsel_Firm_Name__c, SA_Opposing_Counsel_Email__c, 
                                         SA_Opposing_Counsel_Comments__c, SA_Next_action__c, SA_Matter_Name__c, SA_Judge_Name__c, SA_IfPriorExperience_with_Judge_Comments__c, SA_Firm_Recommendation__c, 
                                         SA_Demand_Response_Date__c, SA_Demand_Date__c, SA_Date_Check_Sent_to_Firm__c, SA_Date_Check_Requested_from_AP__c, SA_Date_Check_Received_from_AP__c, SA_Court_File__c,
                                         SA_County_Court_Name__c, SA_Counter_offer__c, SA_Consumer_Account_Details__c, SA_Basis_of_threat__c, SA_Attorney_Comments__c, SA_Attorney_Assignment__c,
                                         SA_Attorney_Approval_Needed__c, SA_Assigned_Attorney__c, SA_Assigned_Attorney_Email__c, SA_Assigned_Attorney_Direct_Line__c, SA_Assigned_Attorney_Cell_Phone__c, 
                                         SA_Amount_of_Prior_Offers__c, SA_Amount_of_Offer__c, SA_Age__c, SA_Age_At_Close__c, SA_Account_Number__c, OwnerId, Name, LastViewedDate, LastReferencedDate,
                                         LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Id, CreatedDate, CreatedById, ConnectionSentId, ConnectionReceivedId From Settlement_Approval__c where SA_Consumer_Account_Details__c =: pageId limit 1];
            BusinessRecordList = [Select SystemModstamp, RecordTypeId, OwnerId, Name, LastViewedDate, LastReferencedDate, LastModifiedDate, LastModifiedById, LastActivityDate, 
                                         IsDeleted, Id, CreatedDate, CreatedById, ConnectionSentId, ConnectionReceivedId, BRA_Why_is_BRA_Needed__c, BRA_Tracking_Number_for_Documents_Sent__c, BRA_State_Filed__c,
                                         BRA_Sent_To_Media_Team__c, BRA_Sent_Back_to_Firm__c, BRA_Prior_Experience_with_Judge__c, BRA_Paralegal_Assignment__c, BRA_Original_Creditor__c, BRA_Organization_Name__c, 
                                         BRA_Opposing_counsel_Phone__c, BRA_Opposing_Counsel__c, BRA_Opposing_Counsel_Firm_Name__c, BRA_Opposing_Counsel_Email__c, BRA_Opposing_Counsel_Comments__c, BRA_Matter_Name__c,
                                         BRA_Judge_Name__c, BRA_IfPriorExperiencewith_Judge_Comments__c, BRA_Court_File__c, BRA_County_Filed__c, BRA_County_Court_Name__c, BRA_Consumer_Account_Details_Record__c, 
                                         BRA_Closed_Date__c, BRA_ClosedDate_Today__c, BRA_BRA_Status__c, BRA_BRA_Attached__c, BRA_Atttached_BRA_Approved__c, BRA_Attachments__c,
                                         BRA_Attachment_Modification_Provided__c, BRA_Attachment_Modification_Comments__c, BRA_Assigned_Attorney__c, BRA_Assigned_Attorney_Email__c,
                                         BRA_Assigned_Attorney_Direct_Line__c, BRA_Assigned_Attorney_Cell_Phone__c, BRA_Age__c, BRA_Account_Number__c,BRA_State_Filed__r.id,BRA_Organization_Name__r.id From Business_Record_Affidavit__c WHERE BRA_Consumer_Account_Details_Record__c =: pageId limit 1];
      
      
                 psarecordList = [Select SystemModstamp, PSA_Why_Is_PSA_Needed__c, PSA_Tracking_Number_for_Pkg_Sent__c, PSA_State_Filed__c, PSA_Resolution_Type__c, 
                                         PSA_Resolution_Payment_To__c, PSA_Resolution_Notes__c, PSA_Resolution_Date__c, PSA_Resolution_Amount__c, PSA_Protective_Order_Draft_Attached__c,
                                         PSA_Prior_Experience_with_Judge__c, PSA_Portfolio__c, PSA_Paralegal_Assignment__c, PSA_PSA_Status__c, PSA_Original_Creditor__c, PSA_Organization_Name__c, 
                                         PSA_Order_on_Motion_Attached__c, PSA_Opposing_counsel_Phone__c, PSA_Opposing_Counsel__c, PSA_Opposing_Counsel_Firm_Name__c, PSA_Opposing_Counsel_Email__c, 
                                         PSA_Opposing_Counsel_Comments__c, PSA_Motion_and_Response_Attached__c, PSA_Matter_Name__c, PSA_Judge_Name__c, PSA_Issuer_Notified_Date__c,
                                         PSA_Is_There_a_Motion_to_Compel_PSA__c, PSA_IfPriorExperiencewith_Judge_Comments__c, PSA_Has_Court_Issued_Order_On_Motion__c, PSA_Court_File__c, 
                                         PSA_County_Court_Name__c, PSA_Consumer_Account_Detail_Name__c, PSA_CompletePSAPackageSentto_Issuer_Date__c, PSA_Closed_Date__c, PSA_ClosedDate_Today__c,
                                         PSA_Chain_of_Title__c, PSA_BD_Notified_Date__c, PSA_Attorney_Approval_Attached__c, PSA_Attachment__c, PSA_Assigned_Attorney__c, PSA_Assigned_Attorney_Email__c, 
                                         PSA_Assigned_Attorney_Direct_Line__c, PSA_Assigned_Attorney_Cell_Phone__c, PSA_Age__c, PSA_Account_Number__c, OwnerId, Name, LastViewedDate, 
                                         LastReferencedDate, LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Id, CreatedDate, CreatedById, ConnectionSentId,
                                         ConnectionReceivedId,PSA_State_Filed__r.id,PSA_Organization_Name__r.id From Purchase_and_Sales_Agreement__c WHERE PSA_Consumer_Account_Detail_Name__c =: pageId limit 1];
      
      // CounterClaim button  
        if((trialWitnessRecordList.size() !=  null || trialWitnessRecordList.size() >0))
        {
          system.debug('hello===================');
            for(Trial_Witness_Request__c twr: trialWitnessRecordList)
            {
              if(twr.id != Null)
              {
                CounterclaimId = twr.id;
              }
               Counterclaim__c c = new Counterclaim__c ();
                 c.CC_Matter_Name__c = twr.LW_Matter_Name__c;
                 c.CC_State_Filed__c = twr.State_Filed_State_Profile__r.id;
                 c.OwnerId = UserInfo.getUserId();
                 c.CC_Court_File__c = twr.Court_File__c;
                 c.CC_County_Court_Name__c = twr.County_Court_Name__c;
                 c.CC_Judge_Name__c = twr.Judge_Name__c;
                 c.CC_Prior_Experience_with_Judge__c = twr.Prior_Experience_with_Judge__c;
                 c.CC_IfPriorExperience_with_Judge_Comments__c = twr.If_Prior_Experience_with_Judge_Comments__c;
                 c.CC_Assigned_Attorney__c = twr.Assigned_Attorney__c;
                 c.CC_Assigned_Attorney_Email__c = twr.Assigned_Attorney_Email__c;
                 c.CC_Assigned_Attorney_Cell_Phone__c = twr.Assigned_Attorney_Cell_Phone__c;
                 c.CC_Assigned_Attorney_Direct_Line__c = twr.Assigned_Attorney_Direct_Line__c;
                 c.CC_Opposing_Counsel__c = twr.Opposing_Counsel__c;
                 c.CC_Opposing_Counsel_Firm_Name__c = twr.Opposing_Counsel_Firm_Name__c;
                 c.CC_Opposing_Counsel_Email__c = twr.Opposing_Counsel_Email__c;
                 c.CC_Opposing_counsel_Phone__c = twr.Opposing_Counsel_Phone__c;
                 c.CC_Opposing_Counsel_Comments__c = twr.Opposing_Counsel_Comments__c;
                 c.CC_Account_Number__c = twr.Account_Number__c;
                 c.CC_Consumer_Account_Detail_Name__c = twr.TW_Consumer_Account_Records__c;
                 c.CC_Organization_Name__c = twr.OrganizationName__r.id;
                 ccRecordListToDisplay.add(c);
            }
        }
        
        if((discoveryRecordList.size()>0 || discoveryRecordList != null) && trialWitnessRecordList.size() == 0 ){
          for(Discovery__c  d: discoveryRecordList){
              if(d.id != Null)
              {
                CounterclaimId = d.id;
              }            
              Counterclaim__c c = new Counterclaim__c ();
              c.CC_Matter_Name__c = d.DY_Matter_Name__c;
              c.CC_State_Filed__c = d.DY_State_Filed__r.id;
              c.CC_Court_File__c = d.DY_Court_File__c;
              c.OwnerId = UserInfo.getUserId();
              c.CC_Consumer_Account_Detail_Name__c   = d.DY_Consumer_Account_Details__c ;
              c.CC_County_Court_Name__c = d.DY_County_Court_Name__c;
              c.CC_Judge_Name__c = d.DY_Judge_Name__c;
              c.CC_IfPriorExperience_with_Judge_Comments__c = d.DY_IfPriorExperience_with_Judge_Comments__c;
              c.CC_Prior_Experience_with_Judge__c = d.DY_Prior_Experience_with_Judge__c;
              c.CC_Assigned_Attorney__c =d.DY_Assigned_Attorney__c;
              c.CC_Assigned_Attorney_Cell_Phone__c = d.DY_Assigned_Attorney_Cell_Phone__c;
              c.CC_Assigned_Attorney_Direct_Line__c =d.DY_Assigned_Attorney_Direct_Line__c;
              c.CC_Assigned_Attorney_Email__c = d.DY_Assigned_Attorney_Email__c;
              c.CC_Opposing_Counsel__c = d.DY_Opposing_Counsel__c;
              c.CC_Opposing_Counsel_Comments__c = d.DY_Opposing_Counsel_Comments__c;
              c.CC_Opposing_Counsel_Email__c=d.DY_Opposing_Counsel_Email__c;
              c.CC_Opposing_Counsel_Firm_Name__c =d.DY_Opposing_Counsel_Firm_Name__c;
              c.CC_Opposing_counsel_Phone__c =d.DY_Opposing_counsel_Phone__c;
              c.CC_Account_Number__c = d.DY_Account_Number__c;
              c.CC_Organization_Name__c = d.DY_Organization_Name__r.id;
              ccRecordListToDisplay.add(c);
             
          }
        }
        
        if((appealRecordList.size()>0 || appealRecordList != null) && discoveryRecordList.size() == 0 && trialWitnessRecordList.size() == 0 ){
          for(Appeal__c  a: appealRecordList ){
              if(a.id != Null)
              {
                CounterclaimId = a.id;
              }            
              Counterclaim__c c = new Counterclaim__c ();
              c.CC_Matter_Name__c = a.AP_Matter_Name__c;
              c.CC_State_Filed__c = a.AP_State_Filed__r.id;
              c.OwnerId = UserInfo.getUserId();
              c.CC_Court_File__c = a.AP_Court_File__c;
              c.CC_Consumer_Account_Detail_Name__c   = a.AP_Consumer_Account_Record__c;
              c.CC_County_Court_Name__c = a.AP_County_Court_Name__c;
              c.CC_Judge_Name__c = a.AP_Judge_Name__c;
              c.CC_IfPriorExperience_with_Judge_Comments__c = a.AP_IfPriorExperience_with_Judge_Comments__c;
              c.CC_Prior_Experience_with_Judge__c = a.AP_Prior_Experience_with_Judge__c;
              c.CC_Assigned_Attorney__c =a.AP_Assigned_Attorney__c;
              c.CC_Assigned_Attorney_Cell_Phone__c = a.AP_Assigned_Attorney_Cell_Phone__c;
              c.CC_Assigned_Attorney_Direct_Line__c =a.AP_Assigned_Attorney_Direct_Line__c;
              c.CC_Assigned_Attorney_Email__c = a.AP_Assigned_Attorney_Email__c;
              c.CC_Opposing_Counsel__c = a.AP_Opposing_Counsel__c;
              c.CC_Opposing_Counsel_Comments__c = a.AP_Opposing_Counsel_Comments__c;
              c.CC_Opposing_Counsel_Email__c=a.AP_Opposing_Counsel_Email__c;
              c.CC_Opposing_Counsel_Firm_Name__c =a.AP_Opposing_Counsel_Firm_Name__c;
              c.CC_Opposing_counsel_Phone__c =a.AP_Opposing_counsel_Phone__c;
              c.CC_Account_Number__c = a.AP_Account_Number__c;
              c.CC_Organization_Name__c =a.AP_Organization_Name__r.id;
              ccRecordListToDisplay.add(c);
          }
        }
        
        if((settlementRecordList.size()>0 || settlementRecordList != null) && discoveryRecordList.size() == 0 && appealRecordList.size()==0 && trialWitnessRecordList.size() == 0 ){
          for(Settlement_Approval__c  s: settlementRecordList ){
              if(s.id != Null)
              {
                CounterclaimId = s.id;
              }            
              Counterclaim__c c = new Counterclaim__c ();
              c.CC_Matter_Name__c = s.SA_Matter_Name__c;
              c.CC_State_Filed__c = s.SA_State_Filed__r.id;
              c.OwnerId = UserInfo.getUserId();
              c.CC_Court_File__c = s.SA_Court_File__c;
              c.CC_Consumer_Account_Detail_Name__c   = s.SA_Consumer_Account_Details__c;
              c.CC_County_Court_Name__c = s.SA_County_Court_Name__c;
              c.CC_Judge_Name__c = s.SA_Judge_Name__c;
              c.CC_IfPriorExperience_with_Judge_Comments__c = s.SA_IfPriorExperience_with_Judge_Comments__c;
              c.CC_Prior_Experience_with_Judge__c = s.SA_Prior_Experience_with_Judge__c;
              c.CC_Assigned_Attorney__c = s.SA_Assigned_Attorney__c;
              c.CC_Assigned_Attorney_Cell_Phone__c = s.SA_Assigned_Attorney_Cell_Phone__c;
              c.CC_Assigned_Attorney_Direct_Line__c = s.SA_Assigned_Attorney_Direct_Line__c;
              c.CC_Assigned_Attorney_Email__c = s.SA_Assigned_Attorney_Email__c;
              c.CC_Opposing_Counsel__c = s.SA_Opposing_Counsel__c;
              c.CC_Opposing_Counsel_Comments__c = s.SA_Opposing_Counsel_Comments__c;
              c.CC_Opposing_Counsel_Email__c= s.SA_Opposing_Counsel_Email__c;
              c.CC_Opposing_Counsel_Firm_Name__c = s.SA_Opposing_Counsel_Firm_Name__c;
              c.CC_Opposing_counsel_Phone__c = s.SA_Opposing_counsel_Phone__c;
              c.CC_Account_Number__c = s.SA_Account_Number__c;
              c.CC_Organization_Name__c = s.SA_Organization_Name__r.id;
              ccRecordListToDisplay.add(c);
          }
        }
        if((BusinessRecordList.size() >0 || BusinessRecordList != Null) && discoveryRecordList.size() == 0 && appealRecordList.size()==0 && trialWitnessRecordList.size() == 0 && settlementRecordList.size() == 0)
        {
            for(Business_Record_Affidavit__c  br: BusinessRecordList ){
              if(br.id != Null)
              {
                CounterclaimId = br.id;
              }              
             Counterclaim__c c = new Counterclaim__c ();
              c.CC_Matter_Name__c = br.BRA_Matter_Name__c;
              c.CC_State_Filed__c = br.BRA_State_Filed__r.id;
              c.OwnerId = UserInfo.getUserId();
              c.CC_Court_File__c = br.BRA_Court_File__c;
              c.CC_Consumer_Account_Detail_Name__c   = br.BRA_Consumer_Account_Details_Record__c;
              c.CC_County_Court_Name__c = br.BRA_County_Court_Name__c;
              c.CC_Judge_Name__c = br.BRA_Judge_Name__c;
              c.CC_IfPriorExperience_with_Judge_Comments__c = br.BRA_IfPriorExperiencewith_Judge_Comments__c;
              c.CC_Prior_Experience_with_Judge__c = br.BRA_Prior_Experience_with_Judge__c;
              c.CC_Assigned_Attorney__c = br.BRA_Assigned_Attorney__c;
              c.CC_Assigned_Attorney_Cell_Phone__c = br.BRA_Assigned_Attorney_Cell_Phone__c ;
              c.CC_Assigned_Attorney_Direct_Line__c = br.BRA_Assigned_Attorney_Direct_Line__c;
              c.CC_Assigned_Attorney_Email__c = br.BRA_Assigned_Attorney_Email__c;
              c.CC_Opposing_Counsel__c = br.BRA_Opposing_Counsel__c;
              c.CC_Opposing_Counsel_Comments__c = br.BRA_Opposing_Counsel_Comments__c   ;
              c.CC_Opposing_Counsel_Email__c= br.BRA_Opposing_Counsel_Email__c;
              c.CC_Opposing_Counsel_Firm_Name__c = br.BRA_Opposing_Counsel_Firm_Name__c;
              c.CC_Opposing_counsel_Phone__c = br.BRA_Opposing_counsel_Phone__c;
              c.CC_Account_Number__c = br.BRA_Account_Number__c;
              c.CC_Organization_Name__c = br.BRA_Organization_Name__r.id;
              ccRecordListToDisplay.add(c);
          }
        }
        if((psarecordList.size() >0 || psarecordList != Null) && discoveryRecordList.size() == 0 && appealRecordList.size()==0 && trialWitnessRecordList.size() == 0 &&  settlementRecordList.size() == 0 && BusinessRecordList.size() == 0)
        {
            for(Purchase_and_Sales_Agreement__c  psa: psarecordList ){
              if(psa.id != Null)
              {
                CounterclaimId = psa.id;
              }              
             Counterclaim__c c = new Counterclaim__c ();
              c.CC_Matter_Name__c = psa.PSA_Matter_Name__c;
              c.CC_State_Filed__c = psa.PSA_State_Filed__r.id;
              c.OwnerId = UserInfo.getUserId();
              c.CC_Court_File__c = psa.PSA_Court_File__c;
              c.CC_Consumer_Account_Detail_Name__c   = psa.PSA_Consumer_Account_Detail_Name__c;
              c.CC_County_Court_Name__c = psa.PSA_County_Court_Name__c;
              c.CC_Judge_Name__c = psa.PSA_Judge_Name__c;
              c.CC_IfPriorExperience_with_Judge_Comments__c = psa.PSA_IfPriorExperiencewith_Judge_Comments__c;
              c.CC_Prior_Experience_with_Judge__c = psa.PSA_Prior_Experience_with_Judge__c;
              c.CC_Assigned_Attorney__c = psa.PSA_Assigned_Attorney__c;
              c.CC_Assigned_Attorney_Cell_Phone__c = psa.PSA_Assigned_Attorney_Cell_Phone__c ;
              c.CC_Assigned_Attorney_Direct_Line__c = psa.PSA_Assigned_Attorney_Direct_Line__c;
              c.CC_Assigned_Attorney_Email__c = psa.PSA_Assigned_Attorney_Email__c;
              c.CC_Opposing_Counsel__c = psa.PSA_Opposing_Counsel__c;
              c.CC_Opposing_Counsel_Comments__c = psa.PSA_Opposing_Counsel_Comments__c   ;
              c.CC_Opposing_Counsel_Email__c= psa.PSA_Opposing_Counsel_Email__c;
              c.CC_Opposing_Counsel_Firm_Name__c = psa.PSA_Opposing_Counsel_Firm_Name__c;
              c.CC_Opposing_counsel_Phone__c = psa.PSA_Opposing_counsel_Phone__c;
              c.CC_Account_Number__c = psa.PSA_Account_Number__c;
              c.CC_Organization_Name__c = psa.PSA_Organization_Name__r.id;
              ccRecordListToDisplay.add(c);
          }
        }        
        if((ccRecordList.size()>0 || ccRecordList!= null) && discoveryRecordList.size() == 0 && settlementRecordList.size() == 0 && appealRecordList.size() == 0 && trialWitnessRecordList.size() == 0 && psarecordList.size() == 0 && BusinessRecordList.size() == 0){
          for(Counterclaim__c  c1 : ccRecordList){
               if(c1.id != Null)
              {
                CounterclaimId = c1.id;
              }           
              Counterclaim__c c = new Counterclaim__c ();
              c.CC_Matter_Name__c = c1.CC_Matter_Name__c ;
              c.CC_State_Filed__c = c1.CC_State_Filed__r.id;
              c.OwnerId = UserInfo.getUserId();
              c.CC_Court_File__c = c1.CC_Court_File__c ;
              c.CC_Consumer_Account_Detail_Name__c   = c1.CC_Consumer_Account_Detail_Name__c;
              c.CC_County_Court_Name__c = c1.CC_County_Court_Name__c ;
              c.CC_Judge_Name__c = c1.CC_Judge_Name__c ;
              c.CC_IfPriorExperience_with_Judge_Comments__c = c1.CC_IfPriorExperience_with_Judge_Comments__c ;
              c.CC_Prior_Experience_with_Judge__c = c1.CC_Prior_Experience_with_Judge__c;
              c.CC_Assigned_Attorney__c =c1.CC_Assigned_Attorney__c ;
              c.CC_Assigned_Attorney_Cell_Phone__c = c1.CC_Assigned_Attorney_Cell_Phone__c ;
              c.CC_Assigned_Attorney_Direct_Line__c =c1.CC_Assigned_Attorney_Direct_Line__c ;
              c.CC_Assigned_Attorney_Email__c = c1.CC_Assigned_Attorney_Email__c ;
              c.CC_Opposing_Counsel__c = c1.CC_Opposing_Counsel__c ;
              c.CC_Opposing_Counsel_Comments__c = c1.CC_Opposing_Counsel_Comments__c ;
              c.CC_Opposing_Counsel_Email__c=c1.CC_Opposing_Counsel_Email__c;
              c.CC_Opposing_Counsel_Firm_Name__c =c1.CC_Opposing_Counsel_Firm_Name__c ;
              c.CC_Opposing_counsel_Phone__c =c1.CC_Opposing_counsel_Phone__c ;
              c.CC_Account_Number__c = c1.CC_Account_Number__c ;
              c.CC_Organization_Name__c =c1.CC_Organization_Name__r.id;
              ccRecordListToDisplay.add(c);
          }
        }
        
        if(trialWitnessRecordList.size() == 0 && discoveryRecordList.size() == 0  && ccRecordList.size() == 0 && settlementRecordList.size() == 0 && appealRecordList.size() == 0 && BusinessRecordList.size () == 0 && psarecordList.size() == 0){
          Counterclaim__c c = new Counterclaim__c ();
          c.CC_Organization_Name__c = CADList[0].Organization_name__r.id;
          c.CC_Account_Number__c = CADList[0].Account_Number__c;
          c.CC_Consumer_Account_Detail_Name__c = CADList[0].id;
          c.OwnerId = UserInfo.getUserId();
          ccRecordListToDisplay.add(c);
        
        }
        
        //Appeal Button Code
        if((trialWitnessRecordList.size() !=  null || trialWitnessRecordList.size() >0))
        {
            for(Trial_Witness_Request__c twr: trialWitnessRecordList)
            {
              if(twr.RecordtypeId != rtLeadID2 || twr.RecordTypeId != rtLeadID3)
              {  
                if(twr.id != Null)
                {
                  appealId = twr.id;
                }            
                 Appeal__c a = new Appeal__c ();
                 a.AP_Matter_Name__c = twr.LW_Matter_Name__c;
                 a.AP_State_Filed__c = twr.State_Filed_State_Profile__r.id;
                 a.OwnerId = UserInfo.getUserId();
                 a.AP_County_Filed__c = twr.County_Filed__c;
                 a.AP_Court_File__c = twr.Court_File__c;
                 a.AP_County_Court_Name__c = twr.County_Court_Name__c;
                 a.AP_Judge_Name__c = twr.Judge_Name__c;
                 a.AP_Prior_Experience_with_Judge__c = twr.Prior_Experience_with_Judge__c;
                 a.AP_IfPriorExperience_with_Judge_Comments__c=twr.If_Prior_Experience_with_Judge_Comments__c;
                 a.AP_Assigned_Attorney__c= twr.Assigned_Attorney__c;
                 a.AP_Assigned_Attorney_Email__c= twr.Assigned_Attorney_Email__c;
                 a.AP_Assigned_Attorney_Cell_Phone__c= twr.Assigned_Attorney_Cell_Phone__c;
                 a.AP_Assigned_Attorney_Direct_Line__c = twr.Assigned_Attorney_Direct_Line__c;
                 a.AP_Opposing_Counsel__c= twr.Opposing_Counsel__c;
                 a.AP_Opposing_Counsel_Firm_Name__c = twr.Opposing_Counsel_Firm_Name__c;
                 a.AP_Opposing_Counsel_Email__c = twr.Opposing_Counsel_Email__c;
                 a.AP_Opposing_counsel_Phone__c = twr.Opposing_Counsel_Phone__c;
                 a.AP_Opposing_Counsel_Comments__c = twr.Opposing_Counsel_Comments__c;
                 a.AP_Account_Number__c= twr.Account_Number__c;
                 a.AP_Consumer_Account_Record__c = twr.TW_Consumer_Account_Records__c;
                 a.AP_Organization_Name__c = twr.OrganizationName__r.id;
                 appealRecordListToDisplay.add(a);
              }
            }
        }
         if((appealRecordList.size()>0 || appealRecordList!= null) && trialWitnessRecordList.size() == 0 ){
           for(Appeal__c  a1: appealRecordList ){
                if(a1.id != Null)
                {
                  appealId = a1.id;
                }  
             Appeal__c a = new Appeal__c ();
             a.AP_Matter_Name__c = a1.AP_Matter_Name__c;
             a.AP_State_Filed__c = a1.AP_State_Filed__r.id;
             a.AP_County_Filed__c =  a1.AP_County_Filed__c;
             a.OwnerId = UserInfo.getUserId();
             a.AP_County_Filed__c = a1.AP_County_Filed__c;
             a.AP_Court_File__c =  a1.AP_Court_File__c;
             a.AP_County_Court_Name__c = a1.AP_County_Court_Name__c;
             a.AP_Judge_Name__c = a1.AP_Judge_Name__c;
             a.AP_Prior_Experience_with_Judge__c =  a1.AP_Prior_Experience_with_Judge__c;
             a.AP_IfPriorExperience_with_Judge_Comments__c =  a1.AP_IfPriorExperience_with_Judge_Comments__c;
             a.AP_Assigned_Attorney__c = a1.AP_Assigned_Attorney__c;
             a.AP_Assigned_Attorney_Email__c = a1.AP_Assigned_Attorney_Email__c;
             a.AP_Assigned_Attorney_Cell_Phone__c = a1.AP_Assigned_Attorney_Cell_Phone__c;
             a.AP_Assigned_Attorney_Direct_Line__c = a1.AP_Assigned_Attorney_Direct_Line__c;
             a.AP_Opposing_Counsel__c =  a1.AP_Opposing_Counsel__c;
             a.AP_Opposing_Counsel_Firm_Name__c =  a1.AP_Opposing_Counsel_Firm_Name__c;
             a.AP_Opposing_Counsel_Email__c = a1.AP_Opposing_Counsel_Email__c;
             a.AP_Opposing_counsel_Phone__c = a1.AP_Opposing_counsel_Phone__c;
             a.AP_Opposing_Counsel_Comments__c =  a1.AP_Opposing_Counsel_Comments__c;
             a.AP_Account_Number__c = a1.AP_Account_Number__c;
             a.AP_Consumer_Account_Record__c = a1.AP_Consumer_Account_Record__c;
             a.AP_Organization_Name__c = a1.AP_Organization_Name__r.id;
             appealRecordListToDisplay.add(a);
           }
         
        }
         if((ccRecordList.size()>0 || ccRecordList != null) && appealRecordList.size() == 0 && trialWitnessRecordList.size() == 0 ){
          for(Counterclaim__c c: ccRecordList){
                            if(c.id != Null)
                {
                  appealId = c.id;
                } 
              Appeal__c a = new Appeal__c ();
              a.AP_Matter_Name__c = c.CC_Matter_Name__c ;
              a.OwnerId = UserInfo.getUserId();
              a.AP_State_Filed__c =  c.CC_State_Filed__r.id;
              a.AP_Court_File__c= c.CC_Court_File__c ;
              a.AP_Organization_Name__c = c.CC_Organization_Name__r.id ;
              a.AP_Consumer_Account_Record__c = c.CC_Consumer_Account_Detail_Name__c;
              a.AP_County_Court_Name__c= c.CC_County_Court_Name__c;
              a.AP_Judge_Name__c= c.CC_Judge_Name__c;
              a.AP_IfPriorExperience_with_Judge_Comments__c= c.CC_IfPriorExperience_with_Judge_Comments__c;
              a.AP_Prior_Experience_with_Judge__c= c.CC_Prior_Experience_with_Judge__c;
              a.AP_Assigned_Attorney__c = c.CC_Assigned_Attorney__c;
              a.AP_Assigned_Attorney_Cell_Phone__c= c.CC_Assigned_Attorney_Cell_Phone__c;
              a.AP_Assigned_Attorney_Direct_Line__c= c.CC_Assigned_Attorney_Direct_Line__c;
              a.AP_Assigned_Attorney_Email__c= c.CC_Assigned_Attorney_Email__c ;
              a.AP_Opposing_Counsel__c= c.CC_Opposing_Counsel__c;
              a.AP_Opposing_Counsel_Comments__c = c.CC_Opposing_Counsel_Comments__c;
              a.AP_Opposing_Counsel_Email__c = c.CC_Opposing_Counsel_Email__c;
              a.AP_Opposing_Counsel_Firm_Name__c = c.CC_Opposing_Counsel_Firm_Name__c;
              a.AP_Opposing_counsel_Phone__c = c.CC_Opposing_counsel_Phone__c;
              a.AP_Account_Number__c= c.CC_Account_Number__c;
              appealRecordListToDisplay.add(a);
          }
        }
        
        if((settlementRecordList.size()>0 || settlementRecordList != null) && appealRecordList.size() == 0 && ccRecordList.size()==0 && trialWitnessRecordList.size() == 0 ){
          for(Settlement_Approval__c  s: settlementRecordList ){
                  if(s.id != Null)
                {
                  appealId = s.id;
                } 
              Appeal__c a = new Appeal__c ();
              a.AP_Matter_Name__c = s.SA_Matter_Name__c;
              a.OwnerId = UserInfo.getUserId();
              a.AP_State_Filed__c =  s.SA_State_Filed__r.id;
              a.AP_Court_File__c= s.SA_Court_File__c;
              a.AP_Organization_Name__c = s.SA_Organization_Name__r.id;
              a.AP_Consumer_Account_Record__c = s.SA_Consumer_Account_Details__c;
              a.AP_County_Court_Name__c=  s.SA_County_Court_Name__c;
              a.AP_Judge_Name__c= s.SA_Judge_Name__c;
              a.AP_IfPriorExperience_with_Judge_Comments__c= s.SA_IfPriorExperience_with_Judge_Comments__c;
              a.AP_Prior_Experience_with_Judge__c= s.SA_Prior_Experience_with_Judge__c;
              a.AP_Assigned_Attorney__c = s.SA_Assigned_Attorney__c;
              a.AP_Assigned_Attorney_Cell_Phone__c= s.SA_Assigned_Attorney_Cell_Phone__c;
              a.AP_Assigned_Attorney_Direct_Line__c= s.SA_Assigned_Attorney_Direct_Line__c;
              a.AP_Assigned_Attorney_Email__c= s.SA_Assigned_Attorney_Email__c ;
              a.AP_Opposing_Counsel__c= s.SA_Opposing_Counsel__c;
              a.AP_Opposing_Counsel_Comments__c = s.SA_Opposing_Counsel_Comments__c;
              a.AP_Opposing_Counsel_Email__c = s.SA_Opposing_Counsel_Email__c;
              a.AP_Opposing_Counsel_Firm_Name__c = s.SA_Opposing_Counsel_Firm_Name__c;
              a.AP_Opposing_counsel_Phone__c = s.SA_Opposing_counsel_Phone__c;
              a.AP_Account_Number__c= s.SA_Account_Number__c;
              appealRecordListToDisplay.add(a);
          }
        }
        if((discoveryRecordList.size()>0 || discoveryRecordList!= null) && appealRecordList.size() == 0 && settlementRecordList.size() == 0 && ccRecordList.size() == 0 && trialWitnessRecordList.size() == 0 ){
            for(Discovery__c  d: discoveryRecordList){
                if(d.id != Null)
                {
                  appealId = d.id;
                } 
              Appeal__c a = new Appeal__c ();
              a.AP_Matter_Name__c = d.DY_Matter_Name__c;
              a.AP_State_Filed__c = d.DY_State_Filed__r.id;
              a.OwnerId = UserInfo.getUserId();
              a.AP_Court_File__c= d.DY_Court_File__c;
              a.AP_Consumer_Account_Record__c = d.DY_Consumer_Account_Details__c;
              a.AP_County_Court_Name__c= d.DY_County_Court_Name__c;
              a.AP_Judge_Name__c= d.DY_Judge_Name__c;
              a.AP_IfPriorExperience_with_Judge_Comments__c= d.DY_IfPriorExperience_with_Judge_Comments__c;
              a.AP_Prior_Experience_with_Judge__c= d.DY_Prior_Experience_with_Judge__c;
              a.AP_Assigned_Attorney__c=d.DY_Assigned_Attorney__c;
              a.AP_Assigned_Attorney_Cell_Phone__c= d.DY_Assigned_Attorney_Cell_Phone__c;
              a.AP_Assigned_Attorney_Direct_Line__c=d.DY_Assigned_Attorney_Direct_Line__c;
              a.AP_Assigned_Attorney_Email__c= d.DY_Assigned_Attorney_Email__c;
              a.AP_Opposing_Counsel__c= d.DY_Opposing_Counsel__c;
              a.AP_Opposing_Counsel_Comments__c= d.DY_Opposing_Counsel_Comments__c;
              a.AP_Opposing_Counsel_Email__c=d.DY_Opposing_Counsel_Email__c;
              a.AP_Opposing_Counsel_Firm_Name__c=d.DY_Opposing_Counsel_Firm_Name__c;
              a.AP_Opposing_counsel_Phone__c=d.DY_Opposing_counsel_Phone__c;
              a.AP_Account_Number__c= d.DY_Account_Number__c;
              a.AP_Organization_Name__c = d.DY_Organization_Name__r.id;
              appealRecordListToDisplay.add(a);
             
          }
        }
       if((BusinessRecordList.size() >0 || BusinessRecordList.size() != Null) && appealRecordList.size() == 0 && settlementRecordList.size() == 0 && ccRecordList.size() == 0 && trialWitnessRecordList.size() == 0 &&  discoveryRecordList.size() == 0)     
           {
            for(Business_Record_Affidavit__c br : BusinessRecordList)
            {
                 if(br.id != Null)
                {
                  appealId = br.id;
                } 
              Appeal__c a = new Appeal__c ();
              a.AP_Matter_Name__c = br.BRA_Matter_Name__c;
              a.AP_State_Filed__c = br.BRA_State_Filed__r.id;
              a.OwnerId = UserInfo.getUserId();
              a.AP_Court_File__c= br.BRA_Court_File__c;
              a.AP_Consumer_Account_Record__c = br.BRA_Consumer_Account_Details_Record__c;
              a.AP_County_Filed__c = br.BRA_County_Filed__c;
              a.AP_County_Court_Name__c= br.BRA_County_Court_Name__c;
              a.AP_Judge_Name__c= br.BRA_Judge_Name__c;
              a.AP_IfPriorExperience_with_Judge_Comments__c= br.BRA_IfPriorExperiencewith_Judge_Comments__c;
              a.AP_Prior_Experience_with_Judge__c= br.BRA_Prior_Experience_with_Judge__c;
              a.AP_Assigned_Attorney__c=br.BRA_Assigned_Attorney__c;
              a.AP_Assigned_Attorney_Cell_Phone__c= br.BRA_Assigned_Attorney_Cell_Phone__c;
              a.AP_Assigned_Attorney_Direct_Line__c=br.BRA_Assigned_Attorney_Direct_Line__c;
              a.AP_Assigned_Attorney_Email__c= br.BRA_Assigned_Attorney_Email__c;
              a.AP_Opposing_Counsel__c= br.BRA_Opposing_Counsel__c;
              a.AP_Opposing_Counsel_Comments__c= br.BRA_Opposing_Counsel_Comments__c;
              a.AP_Opposing_Counsel_Email__c=br.BRA_Opposing_Counsel_Email__c;
              a.AP_Opposing_Counsel_Firm_Name__c=br.BRA_Opposing_Counsel_Firm_Name__c;
              a.AP_Opposing_counsel_Phone__c=br.BRA_Opposing_counsel_Phone__c;
              a.AP_Account_Number__c= br.BRA_Account_Number__c;
              a.AP_Organization_Name__c = br.BRA_Organization_Name__r.id;
              appealRecordListToDisplay.add(a);    
           }
          }
       if((psarecordList.size() >0 || psarecordList.size() != Null) && appealRecordList.size() == 0 && settlementRecordList.size() == 0 && ccRecordList.size() == 0 && trialWitnessRecordList.size() == 0 &&  discoveryRecordList.size() == 0 && BusinessRecordList.size() == 0)     
           {
            for(Purchase_and_Sales_Agreement__c br : psarecordList)
            {
                if(br.id != Null)
                {
                  appealId = br.id;
                } 
              Appeal__c a = new Appeal__c ();
              a.AP_Matter_Name__c = br.PSA_Matter_Name__c;
              a.AP_State_Filed__c = br.PSA_State_Filed__r.id;
              a.OwnerId = UserInfo.getUserId();
              a.AP_Court_File__c= br.PSA_Court_File__c;
              a.AP_Consumer_Account_Record__c = br.PSA_Consumer_Account_Detail_Name__c;
              //a.AP_County_Filed__c = br.BRA_County_Filed__c;
              a.AP_County_Court_Name__c= br.PSA_County_Court_Name__c;
              a.AP_Judge_Name__c= br.PSA_Judge_Name__c;
              a.AP_IfPriorExperience_with_Judge_Comments__c= br.PSA_IfPriorExperiencewith_Judge_Comments__c;
              a.AP_Prior_Experience_with_Judge__c= br.PSA_Prior_Experience_with_Judge__c;
              a.AP_Assigned_Attorney__c=br.PSA_Assigned_Attorney__c  ;
              a.AP_Assigned_Attorney_Cell_Phone__c= br.PSA_Assigned_Attorney_Cell_Phone__c;
              a.AP_Assigned_Attorney_Direct_Line__c=br.PSA_Assigned_Attorney_Direct_Line__c;
              a.AP_Assigned_Attorney_Email__c= br.PSA_Assigned_Attorney_Email__c;
              a.AP_Opposing_Counsel__c= br.PSA_Opposing_Counsel__c;
              a.AP_Opposing_Counsel_Comments__c= br.PSA_Opposing_Counsel_Comments__c;
              a.AP_Opposing_Counsel_Email__c=br.PSA_Opposing_Counsel_Email__c;
              a.AP_Opposing_Counsel_Firm_Name__c=br.PSA_Opposing_Counsel_Firm_Name__c;
              a.AP_Opposing_counsel_Phone__c=br.PSA_Opposing_counsel_Phone__c;
              a.AP_Account_Number__c= br.PSA_Account_Number__c;
              a.AP_Organization_Name__c = br.PSA_Organization_Name__r.id;
              appealRecordListToDisplay.add(a);    
            }
          }          
        if(trialWitnessRecordList.size() == 0 && discoveryRecordList.size() == 0 && ccRecordList.size() == 0 && appealRecordList.size() == 0 && settlementRecordList.size()==0 && BusinessRecordList.size() == 0 && psarecordList.size() == 0){
            Appeal__c a = new Appeal__c ();
            a.AP_Organization_Name__c = CADList[0].Organization_name__r.id;
            a.AP_Account_Number__c = CADList[0].Account_Number__c;
            a.AP_Consumer_Account_Record__c = CADList[0].id;
            a.OwnerId = UserInfo.getUserId();
            appealRecordListToDisplay.add(a);
        }
        
        //Dicovery Button Code
        
        if((trialWitnessRecordList.size() !=  null || trialWitnessRecordList.size() >0))
        {
            for(Trial_Witness_Request__c twr: trialWitnessRecordList)
            {
              if(twr.id != Null)
                {
                  DiscoveryId = twr.id;
                } 
              if(twr.RecordtypeId != rtLeadID2 || twr.RecordTypeId != rtLeadID3)
              {              
                 Discovery__c  d = new Discovery__c();
                 d.DY_Matter_Name__c = twr.LW_Matter_Name__c;
                 d.DY_State_Filed__c = twr.State_Filed_State_Profile__r.id;
                 d.DY_Court_File__c = twr.Court_File__c;
                 d.DY_County_Court_Name__c = twr.County_Court_Name__c;
                 d.DY_Judge_Name__c= twr.Judge_Name__c;
                 d.DY_Prior_Experience_with_Judge__c= twr.Prior_Experience_with_Judge__c;
                 d.DY_IfPriorExperience_with_Judge_Comments__c= twr.If_Prior_Experience_with_Judge_Comments__c;
                 d.DY_Assigned_Attorney__c= twr.Assigned_Attorney__c;
                 d.DY_Assigned_Attorney_Cell_Phone__c= twr.Assigned_Attorney_Cell_Phone__c;
                 d.DY_Assigned_Attorney_Direct_Line__c= twr.Assigned_Attorney_Direct_Line__c;
                 d.DY_Assigned_Attorney_Email__c= twr.Assigned_Attorney_Email__c;
                 d.DY_Opposing_Counsel__c= twr.Opposing_Counsel__c;
                 d.DY_Opposing_Counsel_Comments__c= twr.Opposing_Counsel_Comments__c;
                 d.DY_Opposing_Counsel_Email__c= twr.Opposing_Counsel_Email__c;
                 d.DY_Opposing_Counsel_Firm_Name__c= twr.Opposing_Counsel_Firm_Name__c;
                 d.DY_Opposing_counsel_Phone__c= twr.Opposing_Counsel_Phone__c;
                 d.DY_Organization_Name__c =twr.OrganizationName__r.id;
                 d.DY_Account_Number__c= twr.Account_Number__c;
                 d.ownerid =  UserInfo.getUserId();
                 d.DY_Consumer_Account_Details__c= twr.TW_Consumer_Account_Records__c;
                 disRecordListToDisplay.add(d);
              }
           }
       }
       if((ccRecordList.size()>0 || ccRecordList!= null) && trialWitnessRecordList.size() == 0 ){
          for(Counterclaim__c c: ccRecordList){
              if(c.id != Null)
                {
                  DiscoveryId = c.id;
                }             
                 Discovery__c  d = new Discovery__c  ();
                 d.DY_Matter_Name__c = c.CC_Matter_Name__c ;
                 d.DY_State_Filed__c =c.CC_State_Filed__r.id;
                 d.DY_Court_File__c = c.CC_Court_File__c ;
                 d.DY_County_Court_Name__c = c.CC_County_Court_Name__c ;
                 d.DY_Judge_Name__c= c.CC_Judge_Name__c ;
                 d.DY_Prior_Experience_with_Judge__c= c.CC_Prior_Experience_with_Judge__c ;
                 d.DY_IfPriorExperience_with_Judge_Comments__c= c.CC_IfPriorExperience_with_Judge_Comments__c;
                 d.DY_Assigned_Attorney__c= c.CC_Assigned_Attorney__c ;
                 d.DY_Assigned_Attorney_Cell_Phone__c=c.CC_Assigned_Attorney_Cell_Phone__c ;
                 d.DY_Assigned_Attorney_Direct_Line__c= c.CC_Assigned_Attorney_Direct_Line__c ;
                 d.DY_Assigned_Attorney_Email__c=c.CC_Assigned_Attorney_Email__c ;
                 d.DY_Opposing_Counsel__c= c.CC_Opposing_Counsel__c ;
                 d.DY_Opposing_Counsel_Comments__c= c.CC_Opposing_Counsel_Comments__c;
                 d.DY_Opposing_Counsel_Email__c= c.CC_Opposing_Counsel_Email__c;
                 d.DY_Opposing_Counsel_Firm_Name__c=c.CC_Opposing_Counsel_Firm_Name__c;
                 d.DY_Opposing_counsel_Phone__c=c.CC_Opposing_counsel_Phone__c;
                 d.DY_Organization_Name__c =c.CC_Organization_Name__r.id;
                 d.DY_Account_Number__c= c.CC_Account_Number__c;
                 d.ownerid =  UserInfo.getUserId();
                 d.DY_Consumer_Account_Details__c= c.CC_Consumer_Account_Detail_Name__c;
                 disRecordListToDisplay.add(d);             
          }
        }
        
        if((appealRecordList.size()>0 || appealRecordList!= null) && ccRecordList.size() == 0 && trialWitnessRecordList.size() == 0 ){
          for(Appeal__c a: appealRecordList){
              if(a.id != Null)
                {
                  DiscoveryId = a.id;
                }                
              Discovery__c  d = new Discovery__c  ();
              d.DY_Matter_Name__c = a.AP_Matter_Name__c;
              d.DY_State_Filed__c =a.AP_State_Filed__r.id;
              d.DY_Court_File__c = a.AP_Court_File__c ;
              d.DY_County_Court_Name__c = a.AP_County_Court_Name__c ;
              d.DY_Judge_Name__c= a.AP_Judge_Name__c;
              d.DY_Prior_Experience_with_Judge__c= a.AP_Prior_Experience_with_Judge__c;
              d.DY_IfPriorExperience_with_Judge_Comments__c= a.AP_IfPriorExperience_with_Judge_Comments__c;
              d.DY_Assigned_Attorney__c= a.AP_Assigned_Attorney__c;
              d.DY_Assigned_Attorney_Cell_Phone__c=a.AP_Assigned_Attorney_Cell_Phone__c;
              d.DY_Assigned_Attorney_Direct_Line__c= a.AP_Assigned_Attorney_Direct_Line__c ;
              d.DY_Assigned_Attorney_Email__c= a.AP_Assigned_Attorney_Email__c;
              d.DY_Opposing_Counsel__c= a.AP_Opposing_Counsel__c;
              d.DY_Opposing_Counsel_Comments__c= a.AP_Opposing_Counsel_Comments__c;
              d.DY_Opposing_Counsel_Email__c= a.AP_Opposing_Counsel_Email__c;
              d.DY_Opposing_Counsel_Firm_Name__c= a.AP_Opposing_Counsel_Firm_Name__c;
              d.DY_Opposing_counsel_Phone__c= a.AP_Opposing_counsel_Phone__c ;
              d.DY_Organization_Name__c =a.AP_Organization_Name__r.id;
              d.DY_Account_Number__c= a.AP_Account_Number__c;
              d.ownerid =  UserInfo.getUserId();
              d.DY_Consumer_Account_Details__c= a.AP_Consumer_Account_Record__c;
              disRecordListToDisplay.add(d);
          }
        }
        
        if((settlementRecordList.size()>0 || settlementRecordList != null) && appealRecordList.size() == 0 && ccRecordList.size()==0 && trialWitnessRecordList.size() == 0 ){
          for(Settlement_Approval__c  s: settlementRecordList ){
              if(s.id != Null)
                {
                  DiscoveryId = s.id;
                }                
              Discovery__c  d = new Discovery__c  ();
              d.DY_Matter_Name__c = s.SA_Matter_Name__c;
              d.DY_State_Filed__c = s.SA_State_Filed__r.id;
              d.DY_Court_File__c = s.SA_Court_File__c ;
              d.DY_County_Court_Name__c = s.SA_County_Court_Name__c ;
              d.DY_Judge_Name__c= s.SA_Judge_Name__c;
              d.DY_Prior_Experience_with_Judge__c= s.SA_Prior_Experience_with_Judge__c;
              d.DY_IfPriorExperience_with_Judge_Comments__c = s.SA_IfPriorExperience_with_Judge_Comments__c;
              d.DY_Assigned_Attorney__c= s.SA_Assigned_Attorney__c;
              d.DY_Assigned_Attorney_Cell_Phone__c = s.SA_Assigned_Attorney_Cell_Phone__c;
              d.DY_Assigned_Attorney_Direct_Line__c = s.SA_Assigned_Attorney_Direct_Line__c ;
              d.DY_Assigned_Attorney_Email__c= s.SA_Assigned_Attorney_Email__c;
              d.DY_Opposing_Counsel__c = s.SA_Opposing_Counsel__c;
              d.DY_Opposing_Counsel_Comments__c = s.SA_Opposing_Counsel_Comments__c;
              d.DY_Opposing_Counsel_Email__c= s.SA_Opposing_Counsel_Email__c;
              d.DY_Opposing_Counsel_Firm_Name__c= s.SA_Opposing_Counsel_Firm_Name__c;
              d.DY_Opposing_counsel_Phone__c= s.SA_Opposing_counsel_Phone__c ;
              d.DY_Organization_Name__c = s.SA_Organization_Name__r.id;
              d.DY_Account_Number__c = s.SA_Account_Number__c;
              d.ownerid =  UserInfo.getUserId();
              d.DY_Consumer_Account_Details__c= s.SA_Consumer_Account_Details__c;
              disRecordListToDisplay.add(d);
          }
        }

        if((discoveryRecordList.size()>0 || discoveryRecordList!= null) && ccRecordList.size() == 0 && trialWitnessRecordList.size() == 0 && appealRecordList.size()==0 && settlementRecordList.size()==0 ){
          for(Discovery__c d1: discoveryRecordList){
              if(d1.id != Null)
                {
                  DiscoveryId = d1.id;
                }                
              Discovery__c  d = new Discovery__c  ();
              d.DY_Matter_Name__c =  d1.DY_Matter_Name__c;
              d.DY_State_Filed__c = d1.DY_State_Filed__r.id;
              d.DY_Court_File__c = d1.DY_Court_File__c ;
              d.DY_County_Court_Name__c = d1.DY_County_Court_Name__c ;
              d.DY_Judge_Name__c=  d1.DY_Judge_Name__c;
              d.DY_Prior_Experience_with_Judge__c= d1.DY_Prior_Experience_with_Judge__c;
              d.DY_IfPriorExperience_with_Judge_Comments__c=  d1.DY_IfPriorExperience_with_Judge_Comments__c;
              d.DY_Assigned_Attorney__c= d1.DY_Assigned_Attorney__c;
              d.DY_Assigned_Attorney_Cell_Phone__c= d1.DY_Assigned_Attorney_Cell_Phone__c;
              d.DY_Assigned_Attorney_Direct_Line__c= d1.DY_Assigned_Attorney_Direct_Line__c;
              d.DY_Assigned_Attorney_Email__c = d1.DY_Assigned_Attorney_Email__c;
              d.DY_Opposing_Counsel__c= d1.DY_Opposing_Counsel__c;
              d.DY_Opposing_Counsel_Comments__c = d1.DY_Opposing_Counsel_Comments__c;
              d.DY_Opposing_Counsel_Email__c= d1.DY_Opposing_Counsel_Email__c;
              d.DY_Opposing_Counsel_Firm_Name__c= d1.DY_Opposing_Counsel_Firm_Name__c;
              d.DY_Opposing_counsel_Phone__c= d1.DY_Opposing_counsel_Phone__c ;
              d.DY_Organization_Name__c = d1.DY_Organization_Name__r.id;
              d.DY_Account_Number__c= d1.DY_Account_Number__c;
              d.DY_Consumer_Account_Details__c=d1.DY_Consumer_Account_Details__c;
              d.ownerid =  UserInfo.getUserId();
              disRecordListToDisplay.add(d);
          }
        }
        if((BusinessRecordList.size()>0 || BusinessRecordList!= null) && ccRecordList.size() == 0 && trialWitnessRecordList.size() == 0 && appealRecordList.size()==0 && settlementRecordList.size()==0 && discoveryRecordList.size() == 0){
          for(Business_Record_Affidavit__c br: BusinessRecordList){
              if(br.id != Null)
                {
                  DiscoveryId = br.id;
                }                
              Discovery__c  d = new Discovery__c  ();
              d.DY_Matter_Name__c =  br.BRA_Matter_Name__c;
              d.DY_State_Filed__c = br.BRA_State_Filed__r.id;
              d.DY_Court_File__c = br.BRA_Court_File__c;
              d.DY_County_Court_Name__c = br.BRA_County_Court_Name__c ;
              d.DY_Judge_Name__c=  br.BRA_Judge_Name__c;
              d.DY_Prior_Experience_with_Judge__c= br.BRA_Prior_Experience_with_Judge__c;
              d.DY_IfPriorExperience_with_Judge_Comments__c=  br.BRA_IfPriorExperiencewith_Judge_Comments__c;
              d.DY_Assigned_Attorney__c= br.BRA_Assigned_Attorney__c;
              d.DY_Assigned_Attorney_Cell_Phone__c= br.BRA_Assigned_Attorney_Cell_Phone__c;
              d.DY_Assigned_Attorney_Direct_Line__c= br.BRA_Assigned_Attorney_Direct_Line__c;
              d.DY_Assigned_Attorney_Email__c = br.BRA_Assigned_Attorney_Email__c;
              d.DY_Opposing_Counsel__c= br.BRA_Opposing_Counsel__c;
              d.DY_Opposing_Counsel_Comments__c = br.BRA_Opposing_Counsel_Comments__c;
              d.DY_Opposing_Counsel_Email__c= br.BRA_Opposing_Counsel_Email__c;
              d.DY_Opposing_Counsel_Firm_Name__c= br.BRA_Opposing_Counsel_Firm_Name__c;
              d.DY_Opposing_counsel_Phone__c= br.BRA_Opposing_counsel_Phone__c ;
              d.DY_Organization_Name__c = br.BRA_Organization_Name__r.id;
              d.DY_Account_Number__c= br.BRA_Account_Number__c;
              d.DY_Consumer_Account_Details__c=br.BRA_Consumer_Account_Details_Record__c    ;
              d.ownerid =  UserInfo.getUserId();
              disRecordListToDisplay.add(d);
          }
        }
        if((psarecordList.size()>0 || psarecordList!= null) && ccRecordList.size() == 0 && trialWitnessRecordList.size() == 0 && appealRecordList.size()==0 && settlementRecordList.size()==0 && discoveryRecordList.size() == 0 && BusinessRecordList.size() == 0){
          for(Purchase_and_Sales_Agreement__c psa: psarecordList){
              if(psa.id != Null)
                {
                  DiscoveryId = psa.id;
                }                
              Discovery__c  d = new Discovery__c  ();
              d.DY_Matter_Name__c =  psa.PSA_Matter_Name__c;
              d.DY_State_Filed__c = psa.PSA_State_Filed__r.id;
              d.DY_Court_File__c = psa.PSA_Court_File__c;
              d.DY_County_Court_Name__c = psa.PSA_County_Court_Name__c ;
              d.DY_Judge_Name__c=  psa.PSA_Judge_Name__c;
              d.DY_Prior_Experience_with_Judge__c= psa.PSA_Prior_Experience_with_Judge__c;
              d.DY_IfPriorExperience_with_Judge_Comments__c=  psa.PSA_IfPriorExperiencewith_Judge_Comments__c;
              d.DY_Assigned_Attorney__c= psa.PSA_Assigned_Attorney__c;
              d.DY_Assigned_Attorney_Cell_Phone__c= psa.PSA_Assigned_Attorney_Cell_Phone__c;
              d.DY_Assigned_Attorney_Direct_Line__c= psa.PSA_Assigned_Attorney_Direct_Line__c;
              d.DY_Assigned_Attorney_Email__c = psa.PSA_Assigned_Attorney_Email__c;
              d.DY_Opposing_Counsel__c= psa.PSA_Opposing_Counsel__c;
              d.DY_Opposing_Counsel_Comments__c = psa.PSA_Opposing_Counsel_Comments__c;
              d.DY_Opposing_Counsel_Email__c= psa.PSA_Opposing_Counsel_Email__c;
              d.DY_Opposing_Counsel_Firm_Name__c= psa.PSA_Opposing_Counsel_Firm_Name__c;
              d.DY_Opposing_counsel_Phone__c= psa.PSA_Opposing_counsel_Phone__c ;
              d.DY_Organization_Name__c = psa.PSA_Organization_Name__r.id;
              d.DY_Account_Number__c= psa.PSA_Account_Number__c;
              d.DY_Consumer_Account_Details__c=psa.PSA_Consumer_Account_Detail_Name__c      ;
              d.ownerid =  UserInfo.getUserId();
              disRecordListToDisplay.add(d);
            }
          }
        if(trialWitnessRecordList.size() == 0  && ccRecordList.size() == 0 && discoveryRecordList.size() == 0 && appealRecordList.size()==0 && settlementRecordList.size()==0 && BusinessRecordList.size() == 0 && psarecordList.size() == 0){
            Discovery__c  d = new Discovery__c  ();
            d.DY_Organization_Name__c = CADList[0].Organization_name__r.id;
            d.DY_Account_Number__c = CADList[0].Account_Number__c;
            d.DY_Consumer_Account_Details__c = CADList[0].id;
            d.OwnerId = UserInfo.getUserId();
            disRecordListToDisplay.add(d);
        }
        //Live witness button
        if((appealRecordList.size()>0 || appealRecordList!= null))
           {
              for(Appeal__c a: appealRecordList){
                if(a != Null)
                {
                  LiveWitnessId = a.id;
                }
                Trial_Witness_Request__c twr = new Trial_Witness_Request__c();
                twr.LW_Matter_Name__c = a.AP_Matter_Name__c ;
                twr.County_Filed__c = a.AP_County_Filed__c;
                twr.Court_File__c = a.AP_Court_File__c;
                twr.State_Filed_State_Profile__c = a.AP_State_Filed__r.id;
                twr.County_Court_Name__c = a.AP_County_Court_Name__c;
                twr.Judge_Name__c = a.AP_Judge_Name__c;
                twr.Prior_Experience_with_Judge__c = a.AP_Prior_Experience_with_Judge__c;
                twr.If_Prior_Experience_with_Judge_Comments__c = a.AP_IfPriorExperience_with_Judge_Comments__c;
                twr.Assigned_Attorney__c = a.AP_Assigned_Attorney__c;
                twr.Assigned_Attorney_Email__c = a.AP_Assigned_Attorney_Email__c;
                twr.Assigned_Attorney_Cell_Phone__c = a.AP_Assigned_Attorney_Cell_Phone__c;
                twr.Assigned_Attorney_Direct_Line__c = a.AP_Assigned_Attorney_Direct_Line__c;
                twr.Opposing_Counsel__c = a.AP_Opposing_Counsel__c;
                twr.Opposing_Counsel_Firm_Name__c =  a.AP_Opposing_Counsel_Firm_Name__c;
                twr.Opposing_Counsel_Email__c = a.AP_Opposing_Counsel_Email__c;
                twr.Opposing_Counsel_Phone__c = a.AP_Opposing_counsel_Phone__c;
                twr.Opposing_Counsel_Comments__c =  a.AP_Opposing_Counsel_Comments__c;
                twr.Account_Number__c =  a.AP_Account_Number__c;
                twr.TW_Consumer_Account_Records__c = a.AP_Consumer_Account_Record__c;
                twr.OrganizationName__c = a.AP_Organization_Name__r.id;
                twr.Recordtypeid = rtLeadID;
                twr.ownerid =  UserInfo.getUserId();
                LWRecordListToDisplay.add(twr);
              }
           }
        if((ccRecordList.size()>0 || ccRecordList!= null)  && appealRecordList.size() == 0)
        {
          for(Counterclaim__c c: ccRecordList){
              if(c != Null)
                {
                  LiveWitnessId = c.id;
                }            
            Trial_Witness_Request__c twr = new Trial_Witness_Request__c();
             twr.LW_Matter_Name__c = c.CC_Matter_Name__c;
             twr.Court_File__c = c.CC_Court_File__c;
             twr.State_Filed_State_Profile__c = c.CC_State_Filed__r.id;
             twr.County_Court_Name__c = c.CC_County_Court_Name__c;
             twr.Judge_Name__c =  c.CC_Judge_Name__c;
             twr.Prior_Experience_with_Judge__c =  c.CC_Prior_Experience_with_Judge__c;
             twr.If_Prior_Experience_with_Judge_Comments__c = c.CC_IfPriorExperience_with_Judge_Comments__c;
             twr.Assigned_Attorney__c = c.CC_Assigned_Attorney__c;
             twr.Assigned_Attorney_Email__c = c.CC_Assigned_Attorney_Email__c;
             twr.Assigned_Attorney_Cell_Phone__c = c.CC_Assigned_Attorney_Cell_Phone__c;
             twr.Assigned_Attorney_Direct_Line__c = c.CC_Assigned_Attorney_Direct_Line__c;
             twr.Opposing_Counsel__c = c.CC_Opposing_Counsel__c;
             twr.Opposing_Counsel_Firm_Name__c = c.CC_Opposing_Counsel_Firm_Name__c;
             twr.Opposing_Counsel_Email__c =c.CC_Opposing_Counsel_Email__c;
             twr.Opposing_Counsel_Phone__c  = c.CC_Opposing_counsel_Phone__c;
             twr.Opposing_Counsel_Comments__c = c.CC_Opposing_Counsel_Comments__c;
             twr.Account_Number__c = c.CC_Account_Number__c;
             twr.TW_Consumer_Account_Records__c = c.CC_Consumer_Account_Detail_Name__c;
             twr.OrganizationName__c = c.CC_Organization_Name__r.id;
             twr.Recordtypeid = rtLeadID;
             twr.ownerid =  UserInfo.getUserId();
             LWRecordListToDisplay.add(twr);
          }
        }
           
           if((discoveryRecordList.size()>0 || discoveryRecordList != null) && ccRecordList.size() ==0 &&  appealRecordList.size() ==0)
           {
            for(Discovery__c  d : discoveryRecordList)
            {
                if(d != Null)
                {
                  LiveWitnessId = d.id;
                }              
                Trial_Witness_Request__c twr = new Trial_Witness_Request__c();
                 twr.LW_Matter_Name__c = d.DY_Matter_Name__c;
                 twr.Court_File__c = d.DY_Court_File__c;
                 twr.State_Filed_State_Profile__c = d.DY_State_Filed__r.id;
                 twr.County_Court_Name__c = d.DY_County_Court_Name__c;
                 twr.Judge_Name__c = d.DY_Judge_Name__c;
                 twr.Prior_Experience_with_Judge__c = d.DY_Prior_Experience_with_Judge__c;
                 twr.If_Prior_Experience_with_Judge_Comments__c = d.DY_IfPriorExperience_with_Judge_Comments__c;
                 twr.Assigned_Attorney__c = d.DY_Assigned_Attorney__c;
                 twr.Assigned_Attorney_Cell_Phone__c = d.DY_Assigned_Attorney_Cell_Phone__c;
                 twr.Assigned_Attorney_Direct_Line__c = d.DY_Assigned_Attorney_Direct_Line__c;
                 twr.Assigned_Attorney_Email__c = d.DY_Assigned_Attorney_Email__c;
                 twr.Opposing_Counsel__c = d.DY_Opposing_Counsel__c;
                 twr.Opposing_Counsel_Comments__c = d.DY_Opposing_Counsel_Comments__c;
                 twr.Opposing_Counsel_Email__c = d.DY_Opposing_Counsel_Email__c;
                 twr.Opposing_Counsel_Firm_Name__c = d.DY_Opposing_Counsel_Firm_Name__c;
                 twr.Opposing_Counsel_Phone__c = d.DY_Opposing_counsel_Phone__c;
                 twr.OrganizationName__c = d.DY_Organization_Name__r.id;
                 twr.Account_Number__c = d.DY_Account_Number__c;
                 twr.TW_Consumer_Account_Records__c = d.DY_Consumer_Account_Details__c;
                 twr.Recordtypeid = rtLeadID;
                 twr.ownerid =  UserInfo.getUserId();
                 LWRecordListToDisplay.add(twr);
            }
           }
           if((settlementRecordList.size()>0 || settlementRecordList != null) && appealRecordList.size() == 0 && ccRecordList.size()==0 && discoveryRecordList.size() == 0 ){
            for(Settlement_Approval__c  s: settlementRecordList ){
                if(s != Null)
                {
                  LiveWitnessId = s.id;
                }              
                 Trial_Witness_Request__c twr = new Trial_Witness_Request__c();
                 twr.LW_Matter_Name__c = s.SA_Matter_Name__c;
                 twr.Court_File__c = s.SA_Court_File__c;
                 twr.State_Filed_State_Profile__c = s.SA_State_Filed__r.id;
                 twr.County_Court_Name__c = s.SA_County_Court_Name__c;
                 twr.Judge_Name__c = s.SA_Judge_Name__c;
                 twr.Prior_Experience_with_Judge__c = s.SA_Prior_Experience_with_Judge__c;
                 twr.If_Prior_Experience_with_Judge_Comments__c = s.SA_IfPriorExperience_with_Judge_Comments__c;
                 twr.Assigned_Attorney__c = s.SA_Assigned_Attorney__c;
                 twr.Assigned_Attorney_Cell_Phone__c = s.SA_Assigned_Attorney_Cell_Phone__c;
                 twr.Assigned_Attorney_Direct_Line__c = s.SA_Assigned_Attorney_Direct_Line__c;
                 twr.Assigned_Attorney_Email__c = s.SA_Assigned_Attorney_Email__c;
                 twr.Opposing_Counsel__c = s.SA_Opposing_Counsel__c;
                 twr.Opposing_Counsel_Comments__c = s.SA_Opposing_Counsel_Comments__c;
                 twr.Opposing_Counsel_Email__c = s.SA_Opposing_Counsel_Email__c;
                 twr.Opposing_Counsel_Firm_Name__c = s.SA_Opposing_Counsel_Firm_Name__c;
                 twr.Opposing_Counsel_Phone__c = s.SA_Opposing_counsel_Phone__c;
                 twr.OrganizationName__c = s.SA_Organization_Name__r.id;
                 twr.Account_Number__c = s.SA_Account_Number__c;
                 twr.TW_Consumer_Account_Records__c = s.SA_Consumer_Account_Details__c;
                 twr.Recordtypeid = rtLeadID;
                 twr.ownerid =  UserInfo.getUserId();
                 LWRecordListToDisplay.add(twr);   
            }
           }
           if((BusinessRecordList.size()>0 || BusinessRecordList != null) && appealRecordList.size() == 0 && ccRecordList.size()==0 && discoveryRecordList.size() == 0 && settlementRecordList.size () == 0){
            for(Business_Record_Affidavit__c  br: BusinessRecordList ){
                if(br != Null)
                {
                  LiveWitnessId = br.id;
                }                             
                 Trial_Witness_Request__c twr = new Trial_Witness_Request__c();
                 twr.LW_Matter_Name__c = br.BRA_Matter_Name__c;
                 twr.Court_File__c = br.BRA_Court_File__c;
                 twr.State_Filed_State_Profile__c = br.BRA_State_Filed__r.id;
                 twr.County_Court_Name__c = br.BRA_County_Court_Name__c;
                 twr.County_Filed__c = br.BRA_County_Filed__c;
                 twr.Judge_Name__c = br.BRA_Judge_Name__c;
                 twr.Prior_Experience_with_Judge__c = br.BRA_Prior_Experience_with_Judge__c;
                 twr.If_Prior_Experience_with_Judge_Comments__c = br.BRA_IfPriorExperiencewith_Judge_Comments__c    ;
                 twr.Assigned_Attorney__c = br.BRA_Assigned_Attorney__c;
                 twr.Assigned_Attorney_Cell_Phone__c = br.BRA_Assigned_Attorney_Cell_Phone__c;
                 twr.Assigned_Attorney_Direct_Line__c = br.BRA_Assigned_Attorney_Direct_Line__c;
                 twr.Assigned_Attorney_Email__c = br.BRA_Assigned_Attorney_Email__c;
                 twr.Opposing_Counsel__c = br.BRA_Opposing_Counsel__c;
                 twr.Opposing_Counsel_Comments__c = br.BRA_Opposing_Counsel_Comments__c;
                 twr.Opposing_Counsel_Email__c = br.BRA_Opposing_Counsel_Email__c;
                 twr.Opposing_Counsel_Firm_Name__c = br.BRA_Opposing_Counsel_Firm_Name__c;
                 twr.Opposing_Counsel_Phone__c = br.BRA_Opposing_counsel_Phone__c;
                 twr.OrganizationName__c = br.BRA_Organization_Name__r.id;
                 twr.Account_Number__c = br.BRA_Account_Number__c;
                 twr.TW_Consumer_Account_Records__c = br.BRA_Consumer_Account_Details_Record__c;
                 twr.Recordtypeid = rtLeadID;
                 twr.ownerid =  UserInfo.getUserId();
                 LWRecordListToDisplay.add(twr);
            }
           } 
           if((psarecordList.size()>0 || psarecordList != null) && appealRecordList.size() == 0 && ccRecordList.size()==0 && discoveryRecordList.size() == 0 && settlementRecordList.size () == 0 && BusinessRecordList.size() == 0 && trialWitnessRecordList.size() == 0){
            for(Purchase_and_Sales_Agreement__c  psa: psarecordList ){      
                if(psa != Null)
                {
                  LiveWitnessId = psa.id;
                }                      
                 Trial_Witness_Request__c twr = new Trial_Witness_Request__c();
                 twr.LW_Matter_Name__c = psa.PSA_Matter_Name__c;
                 twr.Court_File__c = psa.PSA_Court_File__c;
                 twr.State_Filed_State_Profile__c = psa.PSA_State_Filed__r.id;
                 twr.County_Court_Name__c = psa.PSA_County_Court_Name__c;
                 twr.Judge_Name__c = psa.PSA_Judge_Name__c;
                 twr.Prior_Experience_with_Judge__c = psa.PSA_Prior_Experience_with_Judge__c;
                 twr.If_Prior_Experience_with_Judge_Comments__c = psa.PSA_IfPriorExperiencewith_Judge_Comments__c    ;
                 twr.Assigned_Attorney__c = psa.PSA_Assigned_Attorney__c;
                 twr.Assigned_Attorney_Cell_Phone__c = psa.PSA_Assigned_Attorney_Cell_Phone__c;
                 twr.Assigned_Attorney_Direct_Line__c = psa.PSA_Assigned_Attorney_Direct_Line__c;
                 twr.Assigned_Attorney_Email__c = psa.PSA_Assigned_Attorney_Email__c;
                 twr.Opposing_Counsel__c = psa.PSA_Opposing_Counsel__c;
                 twr.Opposing_Counsel_Comments__c = psa.PSA_Opposing_Counsel_Comments__c;
                 twr.Opposing_Counsel_Email__c = psa.PSA_Opposing_Counsel_Email__c  ;
                 twr.Opposing_Counsel_Firm_Name__c = psa.PSA_Opposing_Counsel_Firm_Name__c;
                 twr.Opposing_Counsel_Phone__c = psa.PSA_Opposing_counsel_Phone__c;
                 twr.OrganizationName__c = psa.PSA_Organization_Name__r.id;
                 twr.Account_Number__c = psa.PSA_Account_Number__c;
                 twr.TW_Consumer_Account_Records__c = psa.PSA_Consumer_Account_Detail_Name__c;
                 twr.Recordtypeid = rtLeadID;
                 twr.ownerid =  UserInfo.getUserId();
                 LWRecordListToDisplay.add(twr);
            }
           }                          
        if((trialWitnessRecordList.size()>0 || trialWitnessRecordList!= null) && ccRecordList.size() == 0 && discoveryRecordList.size() == 0  && settlementRecordList.size() == 0 && appealRecordList.size() == 0 && psarecordList.size() == 0 && BusinessRecordList.size() == 0){
          for(Trial_Witness_Request__c twr1: trialWitnessRecordList){
               if(twr1 != Null)
                {
                  LiveWitnessId = twr1.id;
                }
                if(twr1.RecordtypeId != rtLeadID2 || twr1.RecordTypeId != rtLeadID3)
              {            
                Trial_Witness_Request__c twr = new Trial_Witness_Request__c();
                 twr.LW_Matter_Name__c = twr1.LW_Matter_Name__c ;
                 twr.Court_File__c = twr1.Court_File__c;
                 twr.State_Filed_State_Profile__c = twr1.State_Filed_State_Profile__r.id;
                 twr.County_Court_Name__c = twr1.County_Court_Name__c ;
                 twr.Judge_Name__c = twr1.Judge_Name__c ;
                 twr.Prior_Experience_with_Judge__c = twr1.Prior_Experience_with_Judge__c ;
                 twr.If_Prior_Experience_with_Judge_Comments__c = twr1.If_Prior_Experience_with_Judge_Comments__c ;
                 twr.Assigned_Attorney__c = twr1.Assigned_Attorney__c ;
                 twr.Assigned_Attorney_Cell_Phone__c = twr1.Assigned_Attorney_Cell_Phone__c ;
                 twr.Assigned_Attorney_Direct_Line__c = twr1.Assigned_Attorney_Direct_Line__c ;
                 twr.Assigned_Attorney_Email__c = twr1.Assigned_Attorney_Email__c ;
                 twr.Opposing_Counsel__c = twr1.Opposing_Counsel__c ;
                 twr.Opposing_Counsel_Comments__c = twr1.Opposing_Counsel_Comments__c;
                 twr.Opposing_Counsel_Email__c = twr1.Opposing_Counsel_Email__c ;
                 twr.Opposing_Counsel_Firm_Name__c = twr1.Opposing_Counsel_Firm_Name__c ;
                 twr.Opposing_Counsel_Phone__c = twr1.Opposing_Counsel_Phone__c ;
                 twr.OrganizationName__c = twr1.OrganizationName__r.id;
                 twr.Account_Number__c = twr1.Account_Number__c ;
                 twr.TW_Consumer_Account_Records__c = twr1.TW_Consumer_Account_Records__c;
                 twr.Recordtypeid = rtLeadID;
                 twr.ownerid =  UserInfo.getUserId();
                 LWRecordListToDisplay.add(twr1);
            }
          }
        }
           if(discoveryRecordList.size() == 0  && ccRecordList.size() == 0 &&  trialWitnessRecordList.size() == 0 && settlementRecordList.size() ==0 && appealRecordList.size() == 0 && BusinessRecordList.size() == 0 && psarecordList.size() == 0){
                Trial_Witness_Request__c twr = new Trial_Witness_Request__c();
                twr.OrganizationName__c = CADList[0].Organization_name__r.id;
                twr.Account_Number__c = CADList[0].Account_Number__c;
                twr.TW_Consumer_Account_Records__c  = CADList[0].id;
                twr.OwnerId = UserInfo.getUserId();
                twr.Recordtypeid = rtLeadID;
                LWRecordListToDisplay.add(twr);
           }
   
    //Settelement Button
     if((trialWitnessRecordList.size() !=  null || trialWitnessRecordList.size() >0))
        {
            for(Trial_Witness_Request__c twr: trialWitnessRecordList)
            {
              if(twr.RecordtypeId != rtLeadID2 || twr.RecordTypeId != rtLeadID3)
              {
                 if(twr.id != Null)
                 {
                   SettlementId = twr.id;
                 }
                 Settlement_Approval__c s = new Settlement_Approval__c ();
                 s.SA_Matter_Name__c = twr.LW_Matter_Name__c;
                 s.SA_State_Filed__c = twr.State_Filed_State_Profile__r.id;
                 s.OwnerId = UserInfo.getUserId();
                 s.SA_Court_File__c = twr.Court_File__c;
                 s.SA_County_Court_Name__c = twr.County_Court_Name__c;
                 s.SA_Judge_Name__c = twr.Judge_Name__c;
                 s.SA_Prior_Experience_with_Judge__c = twr.Prior_Experience_with_Judge__c;
                 s.SA_IfPriorExperience_with_Judge_Comments__c = twr.If_Prior_Experience_with_Judge_Comments__c;
                 s.SA_Assigned_Attorney__c = twr.Assigned_Attorney__c;
                 s.SA_Assigned_Attorney_Email__c = twr.Assigned_Attorney_Email__c;
                 s.SA_Assigned_Attorney_Cell_Phone__c = twr.Assigned_Attorney_Cell_Phone__c;
                 s.SA_Assigned_Attorney_Direct_Line__c = twr.Assigned_Attorney_Direct_Line__c;
                 s.SA_Opposing_Counsel__c = twr.Opposing_Counsel__c;
                 s.SA_Opposing_Counsel_Firm_Name__c = twr.Opposing_Counsel_Firm_Name__c;
                 s.SA_Opposing_Counsel_Email__c = twr.Opposing_Counsel_Email__c;
                 s.SA_Opposing_counsel_Phone__c = twr.Opposing_Counsel_Phone__c;
                 s.SA_Opposing_Counsel_Comments__c = twr.Opposing_Counsel_Comments__c;
                 s.SA_Account_Number__c = twr.Account_Number__c;
                 s.SA_Consumer_Account_Details__c = twr.TW_Consumer_Account_Records__c;
                 s.SA_Organization_Name__c = twr.OrganizationName__r.id;
                 //c.CC_Discovery_Documents_Attached__c = twr.Discovery_Documents_Attached__c;
                 //c.CC_Discovery_Propounded_on_MCM__c = twr.Discovery_Propounded_on_MCM__c;
                 SettlementRecordtoDisplay.add(s);
              }
            }
        }
        if((discoveryRecordList.size()>0 || discoveryRecordList != null) && trialWitnessRecordList.size() == 0 ){
          for(Discovery__c  d: discoveryRecordList){
              if(d.id != Null)
                 {
                   SettlementId = d.id;
                 }            
              Settlement_Approval__c s = new Settlement_Approval__c ();
              s.SA_Matter_Name__c = d.DY_Matter_Name__c;
              s.SA_State_Filed__c = d.DY_State_Filed__r.id;
              s.SA_Court_File__c = d.DY_Court_File__c;
              s.OwnerId = UserInfo.getUserId();
              s.SA_Consumer_Account_Details__c = d.DY_Consumer_Account_Details__c ;
              s.SA_County_Court_Name__c = d.DY_County_Court_Name__c;
              s.SA_Judge_Name__c = d.DY_Judge_Name__c;
              s.SA_IfPriorExperience_with_Judge_Comments__c = d.DY_IfPriorExperience_with_Judge_Comments__c;
              s.SA_Prior_Experience_with_Judge__c = d.DY_Prior_Experience_with_Judge__c;
              s.SA_Assigned_Attorney__c =d.DY_Assigned_Attorney__c;
              s.SA_Assigned_Attorney_Cell_Phone__c = d.DY_Assigned_Attorney_Cell_Phone__c;
              s.SA_Assigned_Attorney_Direct_Line__c =d.DY_Assigned_Attorney_Direct_Line__c;
              s.SA_Assigned_Attorney_Email__c = d.DY_Assigned_Attorney_Email__c;
              s.SA_Opposing_Counsel__c = d.DY_Opposing_Counsel__c;
              s.SA_Opposing_Counsel_Comments__c = d.DY_Opposing_Counsel_Comments__c;
              s.SA_Opposing_Counsel_Email__c=d.DY_Opposing_Counsel_Email__c;
              s.SA_Opposing_Counsel_Firm_Name__c =d.DY_Opposing_Counsel_Firm_Name__c;
              s.SA_Opposing_counsel_Phone__c =d.DY_Opposing_counsel_Phone__c;
              s.SA_Account_Number__c = d.DY_Account_Number__c;
              s.SA_Organization_Name__c = d.DY_Organization_Name__r.id;
              SettlementRecordtoDisplay.add(s);
             
          }
        }
        
        if((appealRecordList.size()>0 || appealRecordList != null) && discoveryRecordList.size() == 0 && trialWitnessRecordList.size() == 0 ){
          for(Appeal__c  a: appealRecordList ){
              if(a.id != Null)
                {
                 SettlementId = a.id;
                }            
             Settlement_Approval__c s = new Settlement_Approval__c (); 
              s.SA_Matter_Name__c = a.AP_Matter_Name__c;
              s.SA_State_Filed__c = a.AP_State_Filed__r.id;
              s.OwnerId = UserInfo.getUserId();
              s.SA_Court_File__c = a.AP_Court_File__c;
              s.SA_Consumer_Account_Details__c = a.AP_Consumer_Account_Record__c;
              s.SA_County_Court_Name__c = a.AP_County_Court_Name__c;
              s.SA_Judge_Name__c = a.AP_Judge_Name__c;
              s.SA_IfPriorExperience_with_Judge_Comments__c = a.AP_IfPriorExperience_with_Judge_Comments__c;
              s.SA_Prior_Experience_with_Judge__c = a.AP_Prior_Experience_with_Judge__c;
              s.SA_Assigned_Attorney__c =a.AP_Assigned_Attorney__c;
              s.SA_Assigned_Attorney_Cell_Phone__c = a.AP_Assigned_Attorney_Cell_Phone__c;
              s.SA_Assigned_Attorney_Direct_Line__c =a.AP_Assigned_Attorney_Direct_Line__c;
              s.SA_Assigned_Attorney_Email__c = a.AP_Assigned_Attorney_Email__c;
              s.SA_Opposing_Counsel__c = a.AP_Opposing_Counsel__c;
              s.SA_Opposing_Counsel_Comments__c = a.AP_Opposing_Counsel_Comments__c;
              s.SA_Opposing_Counsel_Email__c=a.AP_Opposing_Counsel_Email__c;
              s.SA_Opposing_Counsel_Firm_Name__c =a.AP_Opposing_Counsel_Firm_Name__c;
              s.SA_Opposing_counsel_Phone__c =a.AP_Opposing_counsel_Phone__c;
              s.SA_Account_Number__c = a.AP_Account_Number__c;
              s.SA_Organization_Name__c =a.AP_Organization_Name__r.id;
              SettlementRecordtoDisplay.add(s);
             
          }
        }
        if((ccRecordList.size()>0 || ccRecordList != null) && discoveryRecordList.size() == 0 && appealRecordList.size()==0 && trialWitnessRecordList.size() == 0 ){
          for(Counterclaim__c  c: ccRecordList ){
              if(c.id != Null)
                {
                   SettlementId = c.id;
                }            
              Settlement_Approval__c s = new Settlement_Approval__c ();
              s.SA_Matter_Name__c = c.CC_Matter_Name__c  ;
              s.SA_State_Filed__c = c.CC_State_Filed__r.id;
              s.OwnerId = UserInfo.getUserId();
              s.SA_Court_File__c = c.CC_Court_File__c;
              s.SA_Consumer_Account_Details__c = c.CC_Consumer_Account_Detail_Name__c;
              s.SA_County_Court_Name__c = c.cc_County_Court_Name__c;
              s.SA_Judge_Name__c = c.CC_Judge_Name__c;
              s.Sa_IfPriorExperience_with_Judge_Comments__c = c.CC_IfPriorExperience_with_Judge_Comments__c;
              s.SA_Prior_Experience_with_Judge__c = c.CC_Prior_Experience_with_Judge__c;
              s.SA_Assigned_Attorney__c = c.CC_Assigned_Attorney__c;
              s.SA_Assigned_Attorney_Cell_Phone__c = c.CC_Assigned_Attorney_Cell_Phone__c;
              s.SA_Assigned_Attorney_Direct_Line__c = c.CC_Assigned_Attorney_Direct_Line__c;
              s.SA_Assigned_Attorney_Email__c = c.CC_Assigned_Attorney_Email__c;
              s.SA_Opposing_Counsel__c = c.CC_Opposing_Counsel__c;
              s.SA_Opposing_Counsel_Comments__c = c.CC_Opposing_Counsel_Comments__c;
              s.SA_Opposing_Counsel_Email__c= c.CC_Opposing_Counsel_Email__c;
              s.SA_Opposing_Counsel_Firm_Name__c = c.CC_Opposing_Counsel_Firm_Name__c;
              s.SA_Opposing_counsel_Phone__c = c.CC_Opposing_counsel_Phone__c;
              s.SA_Account_Number__c = c.CC_Account_Number__c;
              s.SA_Organization_Name__c = c.CC_Organization_Name__r.id;
              SettlementRecordtoDisplay.add(s);
             
          }
        }
        if((BusinessRecordList.size()>0 || BusinessRecordList != null) && discoveryRecordList.size() == 0 && appealRecordList.size()==0 && trialWitnessRecordList.size() == 0 && ccRecordList.size() == 0){
          for(Business_Record_Affidavit__c  br: BusinessRecordList){
                 if(br.id != Null)
                 {
                   SettlementId = br.id;
                 }            
              Settlement_Approval__c s = new Settlement_Approval__c ();
              s.SA_Matter_Name__c = br.BRA_Matter_Name__c;
              s.SA_State_Filed__c = br.BRA_State_Filed__r.id;
              s.OwnerId = UserInfo.getUserId();  
              s.SA_Court_File__c = br.BRA_Court_File__c;
              s.SA_Consumer_Account_Details__c = br.BRA_Consumer_Account_Details_Record__c;
              s.SA_County_Court_Name__c = br.BRA_County_Court_Name__c;
              s.SA_Judge_Name__c = br.BRA_Judge_Name__c;
              s.Sa_IfPriorExperience_with_Judge_Comments__c = br.BRA_IfPriorExperiencewith_Judge_Comments__c;
              s.SA_Prior_Experience_with_Judge__c = br.BRA_Prior_Experience_with_Judge__c;
              s.SA_Assigned_Attorney__c = br.BRA_Assigned_Attorney__c;
              s.SA_Assigned_Attorney_Cell_Phone__c = br.BRA_Assigned_Attorney_Cell_Phone__c;
              s.SA_Assigned_Attorney_Direct_Line__c = br.BRA_Assigned_Attorney_Direct_Line__c;
              s.SA_Assigned_Attorney_Email__c = br.BRA_Assigned_Attorney_Email__c;
              s.SA_Opposing_Counsel__c = br.BRA_Opposing_Counsel__c;
              s.SA_Opposing_Counsel_Comments__c = br.BRA_Opposing_Counsel_Comments__c;
              s.SA_Opposing_Counsel_Email__c= br.BRA_Opposing_Counsel_Email__c  ;
              s.SA_Opposing_Counsel_Firm_Name__c = br.BRA_Opposing_Counsel_Firm_Name__c;
              s.SA_Opposing_counsel_Phone__c = br.BRA_Opposing_counsel_Phone__c;
              s.SA_Account_Number__c = br.BRA_Account_Number__c;
              s.SA_Organization_Name__c = br.BRA_Organization_Name__r.id;
              SettlementRecordtoDisplay.add(s);
          }
        }
        if((psarecordList.size()>0 || psarecordList != null) && discoveryRecordList.size() == 0 && appealRecordList.size()==0 && trialWitnessRecordList.size() == 0 && ccRecordList.size() == 0 && BusinessRecordList.size()== 0){
          for(Purchase_and_Sales_Agreement__c  br: psarecordList){
               if(br.id != Null)
                 {
                   SettlementId = br.id;
                 }
              Settlement_Approval__c s = new Settlement_Approval__c ();
              s.SA_Matter_Name__c = br.PSA_Matter_Name__c;
              s.SA_State_Filed__c = br.PSA_State_Filed__r.id;
              s.OwnerId = UserInfo.getUserId();  
              s.SA_Court_File__c = br.PSA_Court_File__c;
              s.SA_Consumer_Account_Details__c = br.PSA_Consumer_Account_Detail_Name__c;
              s.SA_County_Court_Name__c = br.PSA_County_Court_Name__c  ;
              s.SA_Judge_Name__c = br.PSA_Judge_Name__c;
              s.Sa_IfPriorExperience_with_Judge_Comments__c = br.PSA_IfPriorExperiencewith_Judge_Comments__c;
              s.SA_Prior_Experience_with_Judge__c = br.PSA_Prior_Experience_with_Judge__c;
              s.SA_Assigned_Attorney__c = br.PSA_Assigned_Attorney__c;
              s.SA_Assigned_Attorney_Cell_Phone__c = br.PSA_Assigned_Attorney_Cell_Phone__c;
              s.SA_Assigned_Attorney_Direct_Line__c = br.PSA_Assigned_Attorney_Direct_Line__c;
              s.SA_Assigned_Attorney_Email__c = br.PSA_Assigned_Attorney_Email__c;
              s.SA_Opposing_Counsel__c = br.PSA_Opposing_Counsel__c;
              s.SA_Opposing_Counsel_Comments__c = br.PSA_Opposing_Counsel_Comments__c;
              s.SA_Opposing_Counsel_Email__c= br.PSA_Opposing_Counsel_Email__c    ;
              s.SA_Opposing_Counsel_Firm_Name__c = br.PSA_Opposing_Counsel_Firm_Name__c;
              s.SA_Opposing_counsel_Phone__c = br.PSA_Opposing_counsel_Phone__c;
              s.SA_Account_Number__c = br.PSA_Account_Number__c;
              s.SA_Organization_Name__c = br.PSA_Organization_Name__r.id;
              SettlementRecordtoDisplay.add(s);
          }
        }                 
        if((settlementRecordList.size()>0 || settlementRecordList!= null) && discoveryRecordList.size() == 0 && ccRecordList.size() == 0 && appealRecordList.size() == 0 && trialWitnessRecordList.size() == 0 && BusinessRecordList.size()== 0 ){
          for(Settlement_Approval__c  s1 : settlementRecordList){
                 if(s1.id != Null)
                 {
                   SettlementId = s1.id;
                 }            
              Settlement_Approval__c s = new Settlement_Approval__c ();
              s.SA_Matter_Name__c = s1.SA_Matter_Name__c ;
              s.SA_State_Filed__c = s1.SA_State_Filed__r.id;
              s.OwnerId = UserInfo.getUserId();
              s.SA_Court_File__c = s1.SA_Court_File__c;
              s.SA_Consumer_Account_Details__c = s1.SA_Consumer_Account_Details__c;
              s.SA_County_Court_Name__c = s1.SA_County_Court_Name__c;
              s.SA_Judge_Name__c = s1.SA_Judge_Name__c;
              s.Sa_IfPriorExperience_with_Judge_Comments__c = s1.Sa_IfPriorExperience_with_Judge_Comments__c;
              s.SA_Prior_Experience_with_Judge__c = s1.SA_Prior_Experience_with_Judge__c;
              s.SA_Assigned_Attorney__c = s1.SA_Assigned_Attorney__c;
              s.SA_Assigned_Attorney_Cell_Phone__c = s1.SA_Assigned_Attorney_Cell_Phone__c;
              s.SA_Assigned_Attorney_Direct_Line__c = s1.SA_Assigned_Attorney_Direct_Line__c;
              s.SA_Assigned_Attorney_Email__c = s1.SA_Assigned_Attorney_Email__c;
              s.SA_Opposing_Counsel__c = s1.SA_Opposing_Counsel__c;
              s.SA_Opposing_Counsel_Comments__c = s1.SA_Opposing_Counsel_Comments__c;
              s.SA_Opposing_Counsel_Email__c= s1.SA_Opposing_Counsel_Email__c;
              s.SA_Opposing_Counsel_Firm_Name__c = s1.SA_Opposing_Counsel_Firm_Name__c;
              s.SA_Opposing_counsel_Phone__c = s1.SA_Opposing_counsel_Phone__c;
              s.SA_Account_Number__c = s1.SA_Account_Number__c;
              s.SA_Organization_Name__c = s1.SA_Organization_Name__r.id;
              SettlementRecordtoDisplay.add(s);
          }
        }
        
        if(trialWitnessRecordList.size() == 0 && discoveryRecordList.size() == 0  && ccRecordList.size() == 0 && settlementRecordList.size() == 0 && appealRecordList.size() == 0 && BusinessRecordList.size() == 0 && psarecordList.size() == 0){
          Settlement_Approval__c s = new Settlement_Approval__c ();
          s.SA_Organization_Name__c = CADList[0].Organization_name__r.id;
          s.SA_Account_Number__c = CADList[0].Account_Number__c;
          s.SA_Consumer_Account_Details__c = CADList[0].id;
          s.OwnerId = UserInfo.getUserId();
          SettlementRecordtoDisplay.add(s);
        
        }
       //Business Record Affidavit
       
        if((trialWitnessRecordList.size() !=  null || trialWitnessRecordList.size() >0))
        {
            for(Trial_Witness_Request__c twr: trialWitnessRecordList)
            {
              if(twr.RecordtypeId != rtLeadID2 || twr.RecordTypeId != rtLeadID3)
              {     
               if(twr.id != Null)
               {
                 BRAId = twr.id;
               }           
                 Business_Record_Affidavit__c br = new Business_Record_Affidavit__c ();
                 br.BRA_Matter_Name__c = twr.LW_Matter_Name__c;
                 br.BRA_State_Filed__c = twr.State_Filed_State_Profile__r.id;
                 br.OwnerId = UserInfo.getUserId();
                 br.BRA_Court_File__c = twr.Court_File__c;
                 br.BRA_County_Filed__c = twr.County_Filed__c;
                 br.BRA_County_Court_Name__c = twr.County_Court_Name__c;
                 br.BRA_Judge_Name__c = twr.Judge_Name__c;
                 br.BRA_Prior_Experience_with_Judge__c = twr.Prior_Experience_with_Judge__c;
                 br.BRA_IfPriorExperiencewith_Judge_Comments__c = twr.If_Prior_Experience_with_Judge_Comments__c;
                 br.BRA_Assigned_Attorney__c = twr.Assigned_Attorney__c; 
                 br.BRA_Assigned_Attorney_Email__c = twr.Assigned_Attorney_Email__c;
                 br.BRA_Assigned_Attorney_Cell_Phone__c = twr.Assigned_Attorney_Cell_Phone__c;
                 br.BRA_Assigned_Attorney_Direct_Line__c = twr.Assigned_Attorney_Direct_Line__c;
                 br.BRA_Opposing_Counsel__c = twr.Opposing_Counsel__c;
                 br.BRA_Opposing_Counsel_Firm_Name__c = twr.Opposing_Counsel_Firm_Name__c;
                 br.BRA_Opposing_Counsel_Email__c = twr.Opposing_Counsel_Email__c;
                 br.BRA_Opposing_counsel_Phone__c = twr.Opposing_Counsel_Phone__c;
                 br.BRA_Opposing_Counsel_Comments__c = twr.Opposing_Counsel_Comments__c;
                 br.BRA_Account_Number__c = twr.Account_Number__c;
                 br.BRA_Consumer_Account_Details_Record__c = twr.TW_Consumer_Account_Records__c;
                 br.BRA_Organization_Name__c = twr.OrganizationName__r.id;
                 br.BRA_Original_Creditor__c = CADList[0].Original_Creditor__c;
                 br.RecordtypeId = rtLeadID1;
                 BRAtoDisplay.add(br);
              }
            }
        }
        if((discoveryRecordList.size()>0 || discoveryRecordList != null) && trialWitnessRecordList.size() == 0 ){
          for(Discovery__c  d: discoveryRecordList){
               if(d.id != Null)
               {
                 BRAId = d.id;
               }            
              Business_Record_Affidavit__c br = new Business_Record_Affidavit__c ();
              br.BRA_Matter_Name__c = d.DY_Matter_Name__c;
              br.BRA_State_Filed__c = d.DY_State_Filed__r.id;
              br.BRA_Court_File__c    = d.DY_Court_File__c;
              br.OwnerId = UserInfo.getUserId();
              br.BRA_Consumer_Account_Details_Record__c = d.DY_Consumer_Account_Details__c ;
              br.BRA_County_Court_Name__c = d.DY_County_Court_Name__c;
              br.BRA_Judge_Name__c = d.DY_Judge_Name__c;
              br.BRA_IfPriorExperiencewith_Judge_Comments__c = d.DY_IfPriorExperience_with_Judge_Comments__c;
              br.BRA_Prior_Experience_with_Judge__c   = d.DY_Prior_Experience_with_Judge__c;
              br.BRA_Assigned_Attorney__c =d.DY_Assigned_Attorney__c;
              br.BRA_Assigned_Attorney_Cell_Phone__c = d.DY_Assigned_Attorney_Cell_Phone__c;
              br.BRA_Assigned_Attorney_Direct_Line__c =d.DY_Assigned_Attorney_Direct_Line__c;
              br.BRA_Assigned_Attorney_Email__c = d.DY_Assigned_Attorney_Email__c;
              br.BRA_Opposing_Counsel__c = d.DY_Opposing_Counsel__c; 
              br.BRA_Opposing_Counsel_Comments__c = d.DY_Opposing_Counsel_Comments__c;
              br.BRA_Opposing_Counsel_Email__c=d.DY_Opposing_Counsel_Email__c;
              br.BRA_Opposing_Counsel_Firm_Name__c =d.DY_Opposing_Counsel_Firm_Name__c;
              br.BRA_Opposing_counsel_Phone__c =d.DY_Opposing_counsel_Phone__c;
              br.BRA_Account_Number__c = d.DY_Account_Number__c;
              br.BRA_Organization_Name__c = d.DY_Organization_Name__r.id;
              br.BRA_Original_Creditor__c = CADList[0].Original_Creditor__c;
              br.RecordtypeId = rtLeadID1;
              BRAtoDisplay.add(br);
          }
        }
         if((appealRecordList.size()>0 || appealRecordList != null) && discoveryRecordList.size() == 0 && trialWitnessRecordList.size() == 0 ){
          for(Appeal__c  a: appealRecordList ){
               if(a.id != Null)
               {
                 BRAId = a.id;
               }            
              Business_Record_Affidavit__c s = new Business_Record_Affidavit__c ();
              s.BRA_Matter_Name__c = a.AP_Matter_Name__c;
              s.BRA_State_Filed__c = a.AP_State_Filed__r.id;
              s.OwnerId = UserInfo.getUserId();
              s.BRA_Court_File__c = a.AP_Court_File__c;
              s.BRA_Consumer_Account_Details_Record__c = a.AP_Consumer_Account_Record__c;
              s.BRA_County_Filed__c =a.AP_County_Filed__c;
              s.BRA_County_Court_Name__c = a.AP_County_Court_Name__c;
              s.BRA_Judge_Name__c = a.AP_Judge_Name__c;
              s.BRA_IfPriorExperiencewith_Judge_Comments__c = a.AP_IfPriorExperience_with_Judge_Comments__c;
              s.BRA_Prior_Experience_with_Judge__c = a.AP_Prior_Experience_with_Judge__c;
              s.BRA_Assigned_Attorney__c =a.AP_Assigned_Attorney__c;
              s.BRA_Assigned_Attorney_Cell_Phone__c = a.AP_Assigned_Attorney_Cell_Phone__c;
              s.BRA_Assigned_Attorney_Direct_Line__c =a.AP_Assigned_Attorney_Direct_Line__c;
              s.BRA_Assigned_Attorney_Email__c = a.AP_Assigned_Attorney_Email__c;
              s.BRA_Opposing_Counsel__c = a.AP_Opposing_Counsel__c;
              s.BRA_Opposing_Counsel_Comments__c = a.AP_Opposing_Counsel_Comments__c;
              s.BRA_Opposing_Counsel_Email__c=a.AP_Opposing_Counsel_Email__c;
              s.BRA_Opposing_Counsel_Firm_Name__c =a.AP_Opposing_Counsel_Firm_Name__c;
              s.BRA_Opposing_counsel_Phone__c =a.AP_Opposing_counsel_Phone__c;
              s.BRA_Account_Number__c = a.AP_Account_Number__c;
              s.BRA_Organization_Name__c =a.AP_Organization_Name__r.id;
              System.debug(LoggingLevel.Info, 'cadlist-->'+CADList[0]);
              System.debug(LoggingLevel.Info, 'cadlistcreditor-->'+CADList[0].Original_Creditor__c);
              
              system.debug('cadlist-->'+CADList[0]);
              system.debug('cadlistcreditor-->'+CADList[0].Original_Creditor__c);
              
              if(CADList[0] != Null && CADList[0].Original_Creditor__c != Null)
              {
              s.BRA_Original_Creditor__c = CADList[0].Original_Creditor__c;
              }
              s.RecordtypeId = rtLeadID1;
              
              BRAtoDisplay.add(s);
          }
        }        
        if((ccRecordList.size()>0 || ccRecordList != null) && discoveryRecordList.size() == 0 && appealRecordList.size()==0 && trialWitnessRecordList.size() == 0 ){
          for(Counterclaim__c  c: ccRecordList ){
               if(c.id != Null)
               {
                 BRAId = c.id;
               }            
              Business_Record_Affidavit__c s = new Business_Record_Affidavit__c ();
              s.BRA_Matter_Name__c = c.CC_Matter_Name__c;
              s.BRA_State_Filed__c = c.CC_State_Filed__r.id;
              s.OwnerId = UserInfo.getUserId();
              s.BRA_Court_File__c = c.CC_Court_File__c;
              s.BRA_Consumer_Account_Details_Record__c = c.CC_Consumer_Account_Detail_Name__c;
              s.BRA_County_Court_Name__c = c.cc_County_Court_Name__c;
              s.BRA_Judge_Name__c = c.CC_Judge_Name__c;
              s.BRA_IfPriorExperiencewith_Judge_Comments__c = c.CC_IfPriorExperience_with_Judge_Comments__c;
              s.BRA_Prior_Experience_with_Judge__c = c.CC_Prior_Experience_with_Judge__c;
              s.BRA_Assigned_Attorney__c = c.CC_Assigned_Attorney__c;
              s.BRA_Assigned_Attorney_Cell_Phone__c = c.CC_Assigned_Attorney_Cell_Phone__c;
              s.BRA_Assigned_Attorney_Direct_Line__c = c.CC_Assigned_Attorney_Direct_Line__c;
              s.BRA_Assigned_Attorney_Email__c = c.CC_Assigned_Attorney_Email__c;
              s.BRA_Opposing_Counsel__c = c.CC_Opposing_Counsel__c;
              s.BRA_Opposing_Counsel_Comments__c = c.CC_Opposing_Counsel_Comments__c;
              s.BRA_Opposing_Counsel_Email__c= c.CC_Opposing_Counsel_Email__c;
              s.BRA_Opposing_Counsel_Firm_Name__c = c.CC_Opposing_Counsel_Firm_Name__c;
              s.BRA_Opposing_counsel_Phone__c = c.CC_Opposing_counsel_Phone__c;
              s.BRA_Account_Number__c = c.CC_Account_Number__c;
              s.BRA_Organization_Name__c = c.CC_Organization_Name__r.id;
              s.BRA_Original_Creditor__c = CADList[0].Original_Creditor__c;
              s.RecordtypeId = rtLeadID1;
              
              
              BRAtoDisplay.add(s);
             
          }
        }
       if((settlementRecordList.size()>0 || settlementRecordList!= null) && discoveryRecordList.size() == 0 && ccRecordList.size() == 0 && appealRecordList.size() == 0 && trialWitnessRecordList.size() == 0 )
       {
          for(Settlement_Approval__c  s1 : settlementRecordList){
               if(s1.id != Null)
               {
                 BRAId = s1.id;
               }            
              Business_Record_Affidavit__c s = new Business_Record_Affidavit__c ();
              s.BRA_Matter_Name__c = s1.SA_Matter_Name__c ;
              s.BRA_State_Filed__c = s1.SA_State_Filed__r.id;
              s.OwnerId = UserInfo.getUserId();
              s.BRA_Court_File__c = s1.SA_Court_File__c;
              s.BRA_Consumer_Account_Details_Record__c = s1.SA_Consumer_Account_Details__c;
              s.BRA_County_Court_Name__c = s1.SA_County_Court_Name__c;
              s.BRA_Judge_Name__c = s1.SA_Judge_Name__c;
              s.BRA_IfPriorExperiencewith_Judge_Comments__c = s1.Sa_IfPriorExperience_with_Judge_Comments__c;
              s.BRA_Prior_Experience_with_Judge__c = s1.SA_Prior_Experience_with_Judge__c;
              s.BRA_Assigned_Attorney__c = s1.SA_Assigned_Attorney__c;
              s.BRA_Assigned_Attorney_Cell_Phone__c = s1.SA_Assigned_Attorney_Cell_Phone__c;
              s.BRA_Assigned_Attorney_Direct_Line__c = s1.SA_Assigned_Attorney_Direct_Line__c;
              s.BRA_Assigned_Attorney_Email__c = s1.SA_Assigned_Attorney_Email__c;
              s.BRA_Opposing_Counsel__c = s1.SA_Opposing_Counsel__c;
              s.BRA_Opposing_Counsel_Comments__c = s1.SA_Opposing_Counsel_Comments__c;
              s.BRA_Opposing_Counsel_Email__c= s1.SA_Opposing_Counsel_Email__c;
              s.BRA_Opposing_Counsel_Firm_Name__c = s1.SA_Opposing_Counsel_Firm_Name__c;
              s.BRA_Opposing_counsel_Phone__c = s1.SA_Opposing_counsel_Phone__c;
              s.BRA_Account_Number__c = s1.SA_Account_Number__c;
              s.BRA_Organization_Name__c = s1.SA_Organization_Name__r.id;
              s.BRA_Original_Creditor__c = CADList[0].Original_Creditor__c;
              s.RecordtypeId = rtLeadID1;
              
              BRAtoDisplay.add(s);
          }
        }
        if((BusinessRecordList.size()>0 || BusinessRecordList != null) && appealRecordList.size() == 0 && ccRecordList.size()==0 && discoveryRecordList.size() == 0 && settlementRecordList.size () == 0 && trialWitnessRecordList.size() == 0 && psarecordList.size() ==0){
            for(Business_Record_Affidavit__c  br: BusinessRecordList ){
              if(br.id != Null)
               {
                 BRAId = br.id;
               }
              Business_Record_Affidavit__c s = new Business_Record_Affidavit__c ();
              s.BRA_Matter_Name__c = br.BRA_Matter_Name__c ;
              s.BRA_State_Filed__c = br.BRA_State_Filed__r.id;
              s.OwnerId = UserInfo.getUserId();
              s.BRA_Court_File__c = br.BRA_Court_File__c;
              s.BRA_Consumer_Account_Details_Record__c = br.BRA_Consumer_Account_Details_Record__c;
              s.BRA_County_Court_Name__c = br.BRA_County_Court_Name__c;
              s.BRA_County_Filed__c = br.BRA_County_Filed__c;
              s.BRA_Judge_Name__c = br.BRA_Judge_Name__c;
              s.BRA_IfPriorExperiencewith_Judge_Comments__c = br.BRA_IfPriorExperiencewith_Judge_Comments__c;
              s.BRA_Prior_Experience_with_Judge__c = br.BRA_Prior_Experience_with_Judge__c;
              s.BRA_Assigned_Attorney__c = br.BRA_Assigned_Attorney__c;
              s.BRA_Assigned_Attorney_Cell_Phone__c = br.BRA_Assigned_Attorney_Cell_Phone__c;
              s.BRA_Assigned_Attorney_Direct_Line__c = br.BRA_Assigned_Attorney_Direct_Line__c;
              s.BRA_Assigned_Attorney_Email__c = br.BRA_Assigned_Attorney_Email__c;
              s.BRA_Opposing_Counsel__c = br.BRA_Opposing_Counsel__c;
              s.BRA_Opposing_Counsel_Comments__c = br.BRA_Opposing_Counsel_Comments__c;
              s.BRA_Opposing_Counsel_Email__c= br.BRA_Opposing_Counsel_Email__c;
              s.BRA_Opposing_Counsel_Firm_Name__c = br.BRA_Opposing_Counsel_Firm_Name__c;
              s.BRA_Opposing_counsel_Phone__c = br.BRA_Opposing_counsel_Phone__c;
              s.BRA_Account_Number__c = br.BRA_Account_Number__c;
              s.BRA_Organization_Name__c = br.BRA_Organization_Name__r.id;
              s.BRA_Original_Creditor__c = CADList[0].Original_Creditor__c;
              s.RecordtypeId = rtLeadID1;
              BRAtoDisplay.add(s);
             }
              }        
       if((psarecordList.size()>0 || psarecordList != null) && discoveryRecordList.size() == 0 && ccRecordList.size() == 0 && appealRecordList.size() == 0 && trialWitnessRecordList.size() == 0 && settlementRecordList.size() == 0)
       {
          for(Purchase_and_Sales_Agreement__c  s1 : psarecordList){
                if(s1.id != Null)
               {
                 BRAId = s1.id;
               }
              Business_Record_Affidavit__c s = new Business_Record_Affidavit__c ();
              s.BRA_Matter_Name__c = s1.PSA_Matter_Name__c ;
              s.BRA_State_Filed__c = s1.PSA_State_Filed__r.id;
              s.OwnerId = UserInfo.getUserId();
              s.BRA_Court_File__c = s1.PSA_Court_File__c;
              s.BRA_Consumer_Account_Details_Record__c = s1.PSA_Consumer_Account_Detail_Name__c;
              s.BRA_County_Court_Name__c = s1.PSA_County_Court_Name__c;
              s.BRA_Judge_Name__c = s1.PSA_Judge_Name__c;
              s.BRA_IfPriorExperiencewith_Judge_Comments__c = s1.PSA_IfPriorExperiencewith_Judge_Comments__c;
              s.BRA_Prior_Experience_with_Judge__c = s1.PSA_Prior_Experience_with_Judge__c;
              s.BRA_Assigned_Attorney__c = s1.PSA_Assigned_Attorney__c;
              s.BRA_Assigned_Attorney_Cell_Phone__c = s1.PSA_Assigned_Attorney_Cell_Phone__c;
              s.BRA_Assigned_Attorney_Direct_Line__c = s1.PSA_Assigned_Attorney_Direct_Line__c;
              s.BRA_Assigned_Attorney_Email__c = s1.PSA_Assigned_Attorney_Email__c;
              s.BRA_Opposing_Counsel__c = s1.PSA_Opposing_Counsel__c;
              s.BRA_Opposing_Counsel_Comments__c = s1.PSA_Opposing_Counsel_Comments__c;
              s.BRA_Opposing_Counsel_Email__c= s1.PSA_Opposing_Counsel_Email__c;
              s.BRA_Opposing_Counsel_Firm_Name__c = s1.PSA_Opposing_Counsel_Firm_Name__c;
              s.BRA_Opposing_counsel_Phone__c = s1.PSA_Opposing_counsel_Phone__c;
              s.BRA_Account_Number__c = s1.PSA_Account_Number__c;
              s.BRA_Organization_Name__c = s1.PSA_Organization_Name__r.id;
              s.BRA_Original_Creditor__c = CADList[0].Original_Creditor__c;
              s.RecordtypeId = rtLeadID1;
              
              BRAtoDisplay.add(s);
          }
        }        
        if(trialWitnessRecordList.size() == 0 && discoveryRecordList.size() == 0  && ccRecordList.size() == 0 && settlementRecordList.size() == 0 && appealRecordList.size() == 0 &&  BusinessRecordList.size() == 0 && psarecordList.size() ==0){
          Business_Record_Affidavit__c br = new Business_Record_Affidavit__c ();
          br.BRA_Organization_Name__c = CADList[0].Organization_name__r.id;
          br.BRA_Account_Number__c = CADList[0].Account_Number__c;
          br.BRA_Consumer_Account_Details_Record__c = CADList[0].id;
          br.OwnerId = UserInfo.getUserId();
          br.BRA_Original_Creditor__c = CADList[0].Original_Creditor__c;
          br.RecordtypeId = rtLeadID1;
          
          BRAtoDisplay.add(br);
        }  
        // Purchase and Sales Agreement    
             if((trialWitnessRecordList.size() !=  null || trialWitnessRecordList.size() >0))
        {
            for(Trial_Witness_Request__c twr: trialWitnessRecordList)
            {
              if(twr.RecordtypeId != rtLeadID2 || twr.RecordTypeId != rtLeadID3)
              {
                if(twr.id != Null)
                {
                  PSAId = twr.id;
                }
                 Purchase_and_Sales_Agreement__c ps = new Purchase_and_Sales_Agreement__c();
                 ps.PSA_Matter_Name__c = twr.LW_Matter_Name__c;
                 ps.PSA_State_Filed__c = twr.State_Filed_State_Profile__r.id;
                 ps.OwnerId = UserInfo.getUserId();
                 ps.PSA_Court_File__c = twr.Court_File__c;
                 ps.PSA_County_Court_Name__c = twr.County_Court_Name__c;
                 ps.PSA_Judge_Name__c = twr.Judge_Name__c;
                 ps.PSA_Prior_Experience_with_Judge__c = twr.Prior_Experience_with_Judge__c;
                 ps.PSA_IfPriorExperiencewith_Judge_Comments__c = twr.If_Prior_Experience_with_Judge_Comments__c;
                 ps.PSA_Assigned_Attorney__c = twr.Assigned_Attorney__c;
                 ps.PSA_Assigned_Attorney_Email__c = twr.Assigned_Attorney_Email__c;
                 ps.PSA_Assigned_Attorney_Cell_Phone__c = twr.Assigned_Attorney_Cell_Phone__c;
                 ps.PSA_Assigned_Attorney_Direct_Line__c = twr.Assigned_Attorney_Direct_Line__c;
                 ps.PSA_Opposing_Counsel__c = twr.Opposing_Counsel__c;
                 ps.PSA_Opposing_Counsel_Firm_Name__c = twr.Opposing_Counsel_Firm_Name__c;
                 ps.PSA_Opposing_Counsel_Email__c = twr.Opposing_Counsel_Email__c;
                 ps.PSA_Opposing_counsel_Phone__c = twr.Opposing_Counsel_Phone__c;
                 ps.PSA_Opposing_Counsel_Comments__c = twr.Opposing_Counsel_Comments__c;
                 ps.PSA_Account_Number__c = twr.Account_Number__c;
                 ps.PSA_Consumer_Account_Detail_Name__c = twr.TW_Consumer_Account_Records__c;
                 ps.PSA_Organization_Name__c = twr.OrganizationName__r.id;
                 ps.PSA_Original_Creditor__c = CADList[0].Original_Creditor__c;
                 ps.PSA_Chain_of_Title__c = CADList[0].Chain_of_Title__c;
                 ps.PSA_Portfolio__c = CADList[0].Portfolio__c;
                 psatoDisplay.add(ps);
              }
            }
        } 
       if((discoveryRecordList.size()>0 || discoveryRecordList != null) && trialWitnessRecordList.size() == 0){
          for(Discovery__c  d: discoveryRecordList){
                if(d.id != Null)
                {
                  PSAId = d.id;
                }            
              Purchase_and_Sales_Agreement__c ps = new Purchase_and_Sales_Agreement__c();
              ps.PSA_Matter_Name__c = d.DY_Matter_Name__c;
              ps.PSA_State_Filed__c = d.DY_State_Filed__r.id;
              ps.PSA_Court_File__c = d.DY_Court_File__c;
              ps.OwnerId = UserInfo.getUserId();
              ps.PSA_Consumer_Account_Detail_Name__c = d.DY_Consumer_Account_Details__c ;
              ps.PSA_County_Court_Name__c = d.DY_County_Court_Name__c;
              ps.PSA_Judge_Name__c = d.DY_Judge_Name__c;
              ps.PSA_IfPriorExperiencewith_Judge_Comments__c = d.DY_IfPriorExperience_with_Judge_Comments__c;
              ps.PSA_Prior_Experience_with_Judge__c   = d.DY_Prior_Experience_with_Judge__c;
              ps.PSA_Assigned_Attorney__c =d.DY_Assigned_Attorney__c;
              ps.PSA_Assigned_Attorney_Cell_Phone__c = d.DY_Assigned_Attorney_Cell_Phone__c;
              ps.PSA_Assigned_Attorney_Direct_Line__c =d.DY_Assigned_Attorney_Direct_Line__c;
              ps.PSA_Assigned_Attorney_Email__c = d.DY_Assigned_Attorney_Email__c;
              ps.PSA_Opposing_Counsel__c = d.DY_Opposing_Counsel__c; 
              ps.PSA_Opposing_Counsel_Comments__c = d.DY_Opposing_Counsel_Comments__c;
              ps.PSA_Opposing_Counsel_Email__c=d.DY_Opposing_Counsel_Email__c;
              ps.PSA_Opposing_Counsel_Firm_Name__c =d.DY_Opposing_Counsel_Firm_Name__c;
              ps.PSA_Opposing_counsel_Phone__c =d.DY_Opposing_counsel_Phone__c;
              ps.PSA_Account_Number__c = d.DY_Account_Number__c;
              ps.PSA_Organization_Name__c = d.DY_Organization_Name__r.id;
              ps.PSA_Original_Creditor__c = CADList[0].Original_Creditor__c;
              ps.PSA_Chain_of_Title__c = CADList[0].Chain_of_Title__c;
              ps.PSA_Portfolio__c = CADList[0].Portfolio__c;              
              psatoDisplay.add(ps);
          }
        }
         if((appealRecordList.size()>0 || appealRecordList != null) && discoveryRecordList.size() == 0 && trialWitnessRecordList.size() == 0 ){
          for(Appeal__c  a: appealRecordList ){
                if(a.id != Null)
                {
                  PSAId = a.id;
                }            
              Purchase_and_Sales_Agreement__c ps = new Purchase_and_Sales_Agreement__c();
              ps.PSA_Matter_Name__c = a.AP_Matter_Name__c;
              ps.PSA_State_Filed__c = a.AP_State_Filed__r.id;
              ps.OwnerId = UserInfo.getUserId();
              ps.PSA_Court_File__c = a.AP_Court_File__c;
              ps.PSA_Consumer_Account_Detail_Name__c = a.AP_Consumer_Account_Record__c;
              ps.PSA_County_Court_Name__c = a.AP_County_Court_Name__c;
              ps.PSA_Judge_Name__c = a.AP_Judge_Name__c;
              ps.PSA_IfPriorExperiencewith_Judge_Comments__c = a.AP_IfPriorExperience_with_Judge_Comments__c;
              ps.PSA_Prior_Experience_with_Judge__c = a.AP_Prior_Experience_with_Judge__c;
              ps.PSA_Assigned_Attorney__c =a.AP_Assigned_Attorney__c;
              ps.PSA_Assigned_Attorney_Cell_Phone__c = a.AP_Assigned_Attorney_Cell_Phone__c;
              ps.PSA_Assigned_Attorney_Direct_Line__c =a.AP_Assigned_Attorney_Direct_Line__c;
              ps.PSA_Assigned_Attorney_Email__c = a.AP_Assigned_Attorney_Email__c;
              ps.PSA_Opposing_Counsel__c = a.AP_Opposing_Counsel__c;
              ps.PSA_Opposing_Counsel_Comments__c = a.AP_Opposing_Counsel_Comments__c;
              ps.PSA_Opposing_Counsel_Email__c=a.AP_Opposing_Counsel_Email__c;
              ps.PSA_Opposing_Counsel_Firm_Name__c =a.AP_Opposing_Counsel_Firm_Name__c;
              ps.PSA_Opposing_counsel_Phone__c =a.AP_Opposing_counsel_Phone__c;
              ps.PSA_Account_Number__c = a.AP_Account_Number__c;
              ps.PSA_Organization_Name__c =a.AP_Organization_Name__r.id;
              ps.PSA_Original_Creditor__c = CADList[0].Original_Creditor__c;
              ps.PSA_Chain_of_Title__c = CADList[0].Chain_of_Title__c;
              ps.PSA_Portfolio__c = CADList[0].Portfolio__c;                            
              psatoDisplay.add(ps);
          }
        }  
        if((ccRecordList.size()>0 || ccRecordList != null) && discoveryRecordList.size() == 0 && appealRecordList.size()==0 && trialWitnessRecordList.size() == 0 ){
          for(Counterclaim__c  c: ccRecordList ){
                if(c.id != Null)
                {
                  PSAId = c.id;
                }            
              Purchase_and_Sales_Agreement__c ps = new Purchase_and_Sales_Agreement__c();
              ps.PSA_Matter_Name__c = c.CC_Matter_Name__c;
              ps.PSA_State_Filed__c = c.CC_State_Filed__r.id;
              ps.OwnerId = UserInfo.getUserId();
              ps.PSA_Court_File__c = c.CC_Court_File__c;
              ps.PSA_Consumer_Account_Detail_Name__c = c.CC_Consumer_Account_Detail_Name__c;
              ps.PSA_County_Court_Name__c = c.cc_County_Court_Name__c;
              ps.PSA_Judge_Name__c = c.CC_Judge_Name__c;
              ps.PSA_IfPriorExperiencewith_Judge_Comments__c = c.CC_IfPriorExperience_with_Judge_Comments__c;
              ps.PSA_Prior_Experience_with_Judge__c = c.CC_Prior_Experience_with_Judge__c;
              ps.PSA_Assigned_Attorney__c = c.CC_Assigned_Attorney__c;
              ps.PSA_Assigned_Attorney_Cell_Phone__c = c.CC_Assigned_Attorney_Cell_Phone__c;
              ps.PSA_Assigned_Attorney_Direct_Line__c = c.CC_Assigned_Attorney_Direct_Line__c;
              ps.PSA_Assigned_Attorney_Email__c = c.CC_Assigned_Attorney_Email__c;
              ps.PSA_Opposing_Counsel__c = c.CC_Opposing_Counsel__c;
              ps.PSA_Opposing_Counsel_Comments__c = c.CC_Opposing_Counsel_Comments__c;
              ps.PSA_Opposing_Counsel_Email__c= c.CC_Opposing_Counsel_Email__c;
              ps.PSA_Opposing_Counsel_Firm_Name__c = c.CC_Opposing_Counsel_Firm_Name__c;
              ps.PSA_Opposing_counsel_Phone__c = c.CC_Opposing_counsel_Phone__c;
              ps.PSA_Account_Number__c = c.CC_Account_Number__c;
              ps.PSA_Organization_Name__c = c.CC_Organization_Name__r.id;  
              ps.PSA_Original_Creditor__c = CADList[0].Original_Creditor__c;
              ps.PSA_Chain_of_Title__c = CADList[0].Chain_of_Title__c;
              ps.PSA_Portfolio__c = CADList[0].Portfolio__c;                                        
              psatoDisplay.add(ps);
             
          }
        }
       if((settlementRecordList.size()>0 || settlementRecordList!= null) && discoveryRecordList.size() == 0 && ccRecordList.size() == 0 && appealRecordList.size() == 0 && trialWitnessRecordList.size() == 0 )
       {
          for(Settlement_Approval__c  s1 : settlementRecordList){
                if(s1.id != Null)
                {
                  PSAId = s1.id;
                }            
              Purchase_and_Sales_Agreement__c ps = new Purchase_and_Sales_Agreement__c();
              ps.PSA_Matter_Name__c = s1.SA_Matter_Name__c ;
              ps.PSA_State_Filed__c = s1.SA_State_Filed__r.id;
              ps.OwnerId = UserInfo.getUserId();
              ps.PSA_Court_File__c = s1.SA_Court_File__c;
              ps.PSA_Consumer_Account_Detail_Name__c = s1.SA_Consumer_Account_Details__c;
              ps.PSA_County_Court_Name__c = s1.SA_County_Court_Name__c;
              ps.PSA_Judge_Name__c = s1.SA_Judge_Name__c;
              ps.PSA_IfPriorExperiencewith_Judge_Comments__c = s1.Sa_IfPriorExperience_with_Judge_Comments__c;
              ps.PSA_Prior_Experience_with_Judge__c = s1.SA_Prior_Experience_with_Judge__c;
              ps.PSA_Assigned_Attorney__c = s1.SA_Assigned_Attorney__c;
              ps.PSA_Assigned_Attorney_Cell_Phone__c = s1.SA_Assigned_Attorney_Cell_Phone__c;
              ps.PSA_Assigned_Attorney_Direct_Line__c = s1.SA_Assigned_Attorney_Direct_Line__c;
              ps.PSA_Assigned_Attorney_Email__c = s1.SA_Assigned_Attorney_Email__c;
              ps.PSA_Opposing_Counsel__c = s1.SA_Opposing_Counsel__c;
              ps.PSA_Opposing_Counsel_Comments__c = s1.SA_Opposing_Counsel_Comments__c;
              ps.PSA_Opposing_Counsel_Email__c= s1.SA_Opposing_Counsel_Email__c;
              ps.PSA_Opposing_Counsel_Firm_Name__c = s1.SA_Opposing_Counsel_Firm_Name__c;
              ps.PSA_Opposing_counsel_Phone__c = s1.SA_Opposing_counsel_Phone__c;
              ps.PSA_Account_Number__c = s1.SA_Account_Number__c;
              ps.PSA_Organization_Name__c = s1.SA_Organization_Name__r.id;
              ps.PSA_Original_Creditor__c = CADList[0].Original_Creditor__c;
              ps.PSA_Chain_of_Title__c = CADList[0].Chain_of_Title__c;
              ps.PSA_Portfolio__c = CADList[0].Portfolio__c;                            
              psatoDisplay.add(ps);
          }
        }  
        if((BusinessRecordList.size()>0 || BusinessRecordList != null) && appealRecordList.size() == 0 && ccRecordList.size()==0 && discoveryRecordList.size() == 0 && settlementRecordList.size () == 0 && trialWitnessRecordList.size() == 0){
            for(Business_Record_Affidavit__c  br: BusinessRecordList ){
                if(br.id != Null)
                {
                  PSAId = br.id;
                }              
              Purchase_and_Sales_Agreement__c ps = new Purchase_and_Sales_Agreement__c();
              ps.PSA_Matter_Name__c = br.BRA_Matter_Name__c ;
              ps.PSA_State_Filed__c = br.BRA_State_Filed__r.id;
              ps.OwnerId = UserInfo.getUserId();
              ps.PSA_Court_File__c = br.BRA_Court_File__c;
              ps.PSA_Consumer_Account_Detail_Name__c = br.BRA_Consumer_Account_Details_Record__c;
              ps.PSA_County_Court_Name__c = br.BRA_County_Court_Name__c;
              ps.PSA_Judge_Name__c = br.BRA_Judge_Name__c;
              ps.PSA_IfPriorExperiencewith_Judge_Comments__c = br.BRA_IfPriorExperiencewith_Judge_Comments__c;
              ps.PSA_Prior_Experience_with_Judge__c = br.BRA_Prior_Experience_with_Judge__c;
              ps.PSA_Assigned_Attorney__c = br.BRA_Assigned_Attorney__c;
              ps.PSA_Assigned_Attorney_Cell_Phone__c = br.BRA_Assigned_Attorney_Cell_Phone__c;
              ps.PSA_Assigned_Attorney_Direct_Line__c = br.BRA_Assigned_Attorney_Direct_Line__c;
              ps.PSA_Assigned_Attorney_Email__c = br.BRA_Assigned_Attorney_Email__c;
              ps.PSA_Opposing_Counsel__c = br.BRA_Opposing_Counsel__c;
              ps.PSA_Opposing_Counsel_Comments__c = br.BRA_Opposing_Counsel_Comments__c;
              ps.PSA_Opposing_Counsel_Email__c= br.BRA_Opposing_Counsel_Email__c;
              ps.PSA_Opposing_Counsel_Firm_Name__c = br.BRA_Opposing_Counsel_Firm_Name__c;
              ps.PSA_Opposing_counsel_Phone__c = br.BRA_Opposing_counsel_Phone__c;
              ps.PSA_Account_Number__c = br.BRA_Account_Number__c;
              ps.PSA_Organization_Name__c = br.BRA_Organization_Name__r.id;         
              ps.PSA_Original_Creditor__c = CADList[0].Original_Creditor__c;
              ps.PSA_Chain_of_Title__c = CADList[0].Chain_of_Title__c;
              ps.PSA_Portfolio__c = CADList[0].Portfolio__c;                                
              psatoDisplay.add(ps);
             }
              }
       if((psarecordList.size()>0 || psarecordList != null) && discoveryRecordList.size() == 0 && ccRecordList.size() == 0 && appealRecordList.size() == 0 && trialWitnessRecordList.size() == 0 && settlementRecordList.size() == 0 && BusinessRecordList.size() == 0)
       {
          for(Purchase_and_Sales_Agreement__c  s1 : psarecordList){
                if(s1.id != Null)
                {
                  PSAId = s1.id;
                }
              Purchase_and_Sales_Agreement__c ps = new Purchase_and_Sales_Agreement__c();
              ps.PSA_Matter_Name__c = s1.PSA_Matter_Name__c ;
              ps.PSA_State_Filed__c = s1.PSA_State_Filed__r.id;
              ps.OwnerId = UserInfo.getUserId();
              ps.PSA_Court_File__c = s1.PSA_Court_File__c;
              ps.PSA_Consumer_Account_Detail_Name__c = s1.PSA_Consumer_Account_Detail_Name__c;
              ps.PSA_County_Court_Name__c = s1.PSA_County_Court_Name__c;
              ps.PSA_Judge_Name__c = s1.PSA_Judge_Name__c;
              ps.PSA_IfPriorExperiencewith_Judge_Comments__c = s1.PSA_IfPriorExperiencewith_Judge_Comments__c;
              ps.PSA_Prior_Experience_with_Judge__c = s1.PSA_Prior_Experience_with_Judge__c;
              ps.PSA_Assigned_Attorney__c = s1.PSA_Assigned_Attorney__c;
              ps.PSA_Assigned_Attorney_Cell_Phone__c = s1.PSA_Assigned_Attorney_Cell_Phone__c;
              ps.PSA_Assigned_Attorney_Direct_Line__c = s1.PSA_Assigned_Attorney_Direct_Line__c;
              ps.PSA_Assigned_Attorney_Email__c = s1.PSA_Assigned_Attorney_Email__c;
              ps.PSA_Opposing_Counsel__c = s1.PSA_Opposing_Counsel__c;
              ps.PSA_Opposing_Counsel_Comments__c = s1.PSA_Opposing_Counsel_Comments__c;
              ps.PSA_Opposing_Counsel_Email__c= s1.PSA_Opposing_Counsel_Email__c;
              ps.PSA_Opposing_Counsel_Firm_Name__c = s1.PSA_Opposing_Counsel_Firm_Name__c;
              ps.PSA_Opposing_counsel_Phone__c = s1.PSA_Opposing_counsel_Phone__c;
              ps.PSA_Account_Number__c = s1.PSA_Account_Number__c;
              ps.PSA_Organization_Name__c = s1.PSA_Organization_Name__r.id;  
              ps.PSA_Original_Creditor__c = CADList[0].Original_Creditor__c; 
              ps.PSA_Chain_of_Title__c = CADList[0].Chain_of_Title__c;
              ps.PSA_Portfolio__c = CADList[0].Portfolio__c;                                      
              psatoDisplay.add(ps);
          }
        }
        if(trialWitnessRecordList.size() == 0 && discoveryRecordList.size() == 0  && ccRecordList.size() == 0 && settlementRecordList.size() == 0 && appealRecordList.size() == 0 &&  BusinessRecordList.size() == 0 && psarecordList.size() ==0){
          Purchase_and_Sales_Agreement__c ps = new Purchase_and_Sales_Agreement__c();
          ps.PSA_Organization_Name__c = CADList[0].Organization_name__r.id;
          ps.PSA_Account_Number__c = CADList[0].Account_Number__c;
          ps.PSA_Consumer_Account_Detail_Name__c = CADList[0].id;
          ps.OwnerId = UserInfo.getUserId();
          ps.PSA_Original_Creditor__c = CADList[0].Original_Creditor__c;
          ps.PSA_Chain_of_Title__c = CADList[0].Chain_of_Title__c;
          ps.PSA_Portfolio__c = CADList[0].Portfolio__c;                
          psatoDisplay.add(ps);
        }                                                               
   }
   public list<Counterclaim__c> getccLIst(){
       if(ccRecordListToDisplay.size() >0){
         return ccRecordListToDisplay;
       }
       return null;
   }
   public list<Appeal__c> getappealLIst(){
      if(appealRecordListToDisplay.size() >0){
       return appealRecordListToDisplay;
      }
      return null;
   }
   public list<Discovery__c> getdiscLIst(){
     if(disRecordListToDisplay.size() >0){
       return disRecordListToDisplay;
     }
     return null;
   }
   public list<Trial_Witness_Request__c> getTrialist()
   {
    if(LWRecordListToDisplay.size() >0){
      return LWRecordListToDisplay;
    }
    return null;
   }
   public list<Settlement_Approval__c> getSAList()
   {
    if(SettlementRecordtoDisplay.size() >0){
      return SettlementRecordtoDisplay;
    }
    
    return null;
   }
   public list<Business_Record_Affidavit__c> getBRAList()
   {
    if(BRAtoDisplay.size() >0){
      return BRAtoDisplay;
    }
    return null;
   }   
   public list<Purchase_and_Sales_Agreement__c> getPSAList()
   {
    if(psatoDisplay.size() >0){
      return psatoDisplay;
    }    
    return null;
   }   
   public PageReference save()
   {         
      try{
           if(ccRecordListToDisplay.size() <> null){
             insert ccRecordListToDisplay;
             return new PageReference('/'+ccRecordListToDisplay[0].id);
           }
        
       }
       catch(Exception ex){
          ApexPages.addMessages(ex);
       }
          return null;
        
   }
   
   public PageReference saveDisc()
   {         
       try{
           if(disRecordListToDisplay.size() <> null){
            insert disRecordListToDisplay;
            return new PageReference('/'+disRecordListToDisplay[0].id);
           }
          }
           
       catch(Exception ex){
          ApexPages.addMessages(ex);
       }
          return null;
        
   }
   
   public PageReference saveAppeal()
   {         
       try{     
            if(appealRecordListToDisplay.size() <> null){                     
                insert appealRecordListToDisplay;
                return new PageReference('/'+appealRecordListToDisplay[0].id);
            }
          }
           
       catch(Exception ex){
          ApexPages.addMessages(ex);
       }
          return null;
        
   }
   
   public PageReference saveLiveWitness()
     {         
       try{     
            if(LWRecordListToDisplay.size() <> null){                     
                insert LWRecordListToDisplay;
                return new PageReference('/'+LWRecordListToDisplay[0].id);
            }
          }
           
       catch(Exception ex){
          ApexPages.addMessages(ex);
       }
          return null;
        
   }
   
    public PageReference saveSA()
     {         
       try{     
            if(SettlementRecordtoDisplay.size() <> null){                     
                insert SettlementRecordtoDisplay;
                return new PageReference('/'+SettlementRecordtoDisplay[0].id);
            }
          }
           
       catch(Exception ex){
          ApexPages.addMessages(ex);
       }
          return null;
        
   }
    public PageReference saveBRA() 
     {         
       try{   
            if(BRAtoDisplay.size() <> null){                     
                insert BRAtoDisplay;
                return new PageReference('/'+BRAtoDisplay[0].id);
            }
          }
       catch(Exception ex){
          ApexPages.addMessages(ex);
       }
          return null;
        
   }
    public PageReference savePSA()
     {         
       try{  
              if(psatoDisplay.size() <> null){                     
                upsert psatoDisplay;
                return new PageReference('/'+psatoDisplay[0].id);
             }
            }
       catch(Exception ex){
          ApexPages.addMessages(ex);
       }
          return null;
        
   }   
}