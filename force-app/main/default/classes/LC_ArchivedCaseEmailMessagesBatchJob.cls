/*
##########################################################################################################################################
# Project Name..........: CI Box Related Work    
# File..................: Class : "LC_ArchivedCaseEmailMessagesBatchJob"
# Version...............: 1.0
# Created by............: Sunny Kumar    
# Created Date..........:  18-04-2015
# Last Modified by......: Sunny Kumar 
# Last Modified Date....:  30-04-2015
# Description...........:  This Class will pick all Email Messages where their own and parent closed cases lastmodified date ahould be 
#                          18 months old and case record type not equal to Judgement and Legal Review type. When we pick these case's
#                          Email Messages in Processed Email Message object with minimum information. Once archival will be done then we are deleting 
#                          these email mesdsages from salesforce to make data Stroage.
###############################################################################################################################################
*/


global class LC_ArchivedCaseEmailMessagesBatchJob implements Database.Batchable<sObject>{ 
    
    list<Box_Folder_ID_Map__c> FolderIDList = new list<Box_Folder_ID_Map__c>();
    map<Id,list<Firm_Dates__c>> AccountFirmMap = new map<Id,list<Firm_Dates__c>>();
    map<Id,Case> mapCases = new map<Id,Case>(); 
    list<Firm_s_Child__c> fcCaseListtoInsert = new list<Firm_s_Child__c>();
    list<Processed_Archived_Case_Email_Message__c> caseEMListtoInsert = new list<Processed_Archived_Case_Email_Message__c>();
    list<Firm_Dates__c> firmDatesList = new list<Firm_Dates__c>();
    set<Id> accIds = new set<Id>(); 
    list<Firm_s_Child__c> fcCaseCheckList = new list<Firm_s_Child__c>();
    set<Id> validateCaseIds = new set<Id>();
    // added Later
    List<String> allMainEmailMsgID = new List<String>();
    List<ID> insertedNewEmailMessages = new List<ID>();
    global Database.QueryLocator start(Database.BatchableContext BC){
    
    Map<String,String> mapRecordTypeIdName=new  Map<String,String>();
    Map<String,String> mapRecordTypeNameID=new  Map<String,String>();
     Schema.sObjectType objType = Case.getSObjectType();
     Schema.DescribeSObjectResult sObjReslt = objType.getDescribe();  
     Map<String,Schema.RecordTypeInfo> rtMapByName = sObjReslt.getRecordTypeInfosByName();
     
     for(String str:rtMapByName.keySet())
     {
          Schema.RecordTypeInfo rtByName =  rtMapByName.get(str);
         if(rtByName.isAvailable()){
             System.debug('Sunny-----rtByName.getName()>>>>'+rtByName.getName());
         if(rtByName.getName()=='Judgment' || rtByName.getName()=='Legal Review'){   
             mapRecordTypeIdName.put(rtByName.getRecordTypeId(),rtByName.getName());
             mapRecordTypeNameID.put(rtByName.getName(),rtByName.getRecordTypeId());
           }
         }  
     }
System.debug('Sunny-----mapRecordTypeNameID>>>>'+mapRecordTypeNameID.size() +'=============='+mapRecordTypeNameID);
 Date D = System.Today().AddMonths(-18);
System.debug('------------------>>>>' +d);
 if(test.isrunningTest()){
      return Database.getQueryLocator([select id, caseNumber,RecordType.Name, CreatedDate, AccountId,
        
                           (SELECT ActivityId,BccAddress,CcAddress,CreatedById,CreatedBy.Name,CreatedDate,FromAddress,FromName,HasAttachment,
                            Headers,Id,Incoming,IsDeleted,LastModifiedById,LastModifiedBy.Name,LastModifiedDate,MessageDate,
                            ParentId,ReplyToEmailMessageId,Status,Subject,ToAddress 
                            FROM EmailMessages WHERE IsDeleted=False and LastModifiedDate <=:D)
                                                         
                            From Case where AccountId != null and IsDeleted=False
                            and IsClosed=True and RecordTypeId!=:mapRecordTypeNameID.get('Judgment')
                            and RecordTypeId!=:mapRecordTypeNameID.get('Legal Review') and LastModifiedDate <=:D
                            limit 9000 ]);
 }
  else {
       
             return Database.getQueryLocator([select id, caseNumber,RecordType.Name, CreatedDate, AccountId,
        
                           (SELECT ActivityId,BccAddress,CcAddress,CreatedById,CreatedBy.Name,CreatedDate,FromAddress,FromName,HasAttachment,
                            Headers,Id,Incoming,IsDeleted,LastModifiedById,LastModifiedBy.Name,LastModifiedDate,MessageDate,
                            ParentId,ReplyToEmailMessageId,Status,Subject,ToAddress 
                            FROM EmailMessages WHERE IsDeleted=False and LastModifiedDate <=:D)
                                                         
                            From Case where AccountId != null and IsDeleted=False
                            and IsClosed=True and RecordTypeId!=:mapRecordTypeNameID.get('Judgment')
                            and RecordTypeId!=:mapRecordTypeNameID.get('Legal Review') and LastModifiedDate <=:D
                            and ID not in (SELECT Case_Reference__c FROM Firm_s_Child__c where
                            Case_Reference__c!=null and Type__c='Case')]); //limit 1  -----  and ID='500U0000006zQ8dIAE' case NC6
       //SELECT Case__c FROM Processed_Archived_Case_Email_Message__c
        }
        
    } // pick all cases
    
    global void execute(Database.BatchableContext BC, List<Case> caseList){ // 500 batch run
        
        for(Case cs: caseList){
            accIds.add(cs.AccountId);
            mapCases.put(cs.Id,cs);
        }
                
        if(!accIds.isEmpty()){
            if(!mapCases.isEmpty()){ // Check weather PEM case already exist or not
                fcCaseCheckList = [select id, Case_Reference__c from Firm_s_Child__c where Case_Reference__c != null 
                and Case_Reference__c IN: mapCases.keyset()];
                if(!fcCaseCheckList.isEmpty()){
                    for(Firm_s_Child__c fc: fcCaseCheckList)
                        validateCaseIds.add(fc.Case_Reference__c); // already have in system cases data
                }
            }
            // reterieve all firms related to 500 cases
            FolderIDList = [Select Id, Name, Reference_ID__c, Type__c, 
                        (Select Id, Name, Name__c From Firm_Dates__r)
                        from Box_Folder_ID_Map__c
                        where Type__c = 'Account' and Actual_Firm__c IN: accIds]; // Retrive existing Account Records from BOX Folder Map table
            
            system.debug('The FolderIDList size == '+FolderIDList.size());
        
            if(!FolderIDList.isEmpty()){
                for(Box_Folder_ID_Map__c IDMap : FolderIDList)
                    AccountFirmMap.put(IDMap.Reference_ID__c,IDMap.Firm_Dates__r); // Account id - Firmdates map
                System.Debug('Sunny===============AccountFirmMap>>>>'+AccountFirmMap+'========='+AccountFirmMap.size());
                
                if(!AccountFirmMap.isEmpty()){
                    string str;
                    for(Case cs : caseList){
                        System.Debug('Sunny===============caseList>>>>'+caseList+'===caseList======'+caseList.size()+'=====validateCaseIds======'+validateCaseIds+'====validateCaseIds===='+validateCaseIds.size());
                        if(!validateCaseIds.contains(cs.Id)){
                            str = cs.CreatedDate.year() + '-';
                            if(cs.CreatedDate.month() < 10)
                                str += '0'+cs.CreatedDate.month();
                            else
                                str += cs.CreatedDate.month();
                            if(AccountFirmMap.containsKey(cs.AccountId) && AccountFirmMap.get(cs.AccountId) != Null && AccountFirmMap.get(cs.AccountId).size() > 0){ // Finding account
                                firmDatesList = AccountFirmMap.get(cs.AccountId);
                                Box_Folder_ID_Map__c bfic = null;
                                for(Firm_Dates__c fdc : firmDatesList){
                                    system.debug('The str is'+str);
                                    system.debug('The str is'+fdc.Name__c);  
                                    if(fdc.Name__c == str){ // matching mapped created date i.e. month and Year
                                        Firm_s_Child__c fc = new Firm_s_Child__c();
                                        fc.Firm_Date__c = fdc.Id;
                                        fc.Record_Type_Name__c = String.ValueOf(cs.RecordType.Name);
                                        fc.Case_Reference__c = cs.Id;
                                        fc.Box_CI_Case_Name__c = 'Case#'+cs.caseNumber;
                                        fc.Reference_ID__c = cs.Id;
                                        fc.Type__c = 'Case';
                                        if(fcCaseListtoInsert.size() < 8000)
                                        fcCaseListtoInsert.add(fc); // all cases pick and we know its Firm Child and Firm Dates
                                        
                                        system.debug('The List size (in loop Case) == '+fcCaseListtoInsert.size());  
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        
        }
                
        system.debug('The List size (Case)== '+fcCaseListtoInsert.size());  
        if(!fcCaseListtoInsert.isEmpty()){ // inserting cases in Firm_s_Child__c table
            try{
                insert fcCaseListtoInsert; // Insert all cases
                
                for(Firm_s_Child__c fc: fcCaseListtoInsert){
                    if(mapCases.containsKey(fc.Reference_ID__c) && mapCases.get(fc.Reference_ID__c).EmailMessages.size() > 0){
                        for(EmailMessage em: mapCases.get(fc.Reference_ID__c).EmailMessages){// mapCases = case ID + all Email msgs
                            Processed_Archived_Case_Email_Message__c cem = new Processed_Archived_Case_Email_Message__c();
                            cem.Firm_s_Child__c = fc.id;
                            cem.Case__c = fc.Case_Reference__c;
                            cem.Email_Message_Reference_Id__c = em.id;                          
                           // cem.Created_Date__c = em.CreatedDate;
                            cem.Name__c = 'EmailMessage - '+em.id;
                            
                            /* Added Later   to map fields from Email Messages*/
                           // cem.BCC_Address__c=em.BccAddress;
                            cem.CC_Address__c=em.CcAddress;
                         //   cem.EmailMessageCreatedByID__c = String.ValueOf(em.CreatedBy.Name);
                            cem.EmailMessafeCreatedByDate__c=   em.CreatedDate; 
                            cem.From_Address__c= em.FromAddress;
                            cem.From_Name__c = em.FromName;
                            cem.Has_Attachments__c=em.HasAttachment;
                          //  cem.Headers__c=em.Headers;
                            /*cem.HTML_Body__c='Please refer below Body.Html Attachment as its an Archived Email Message';
                             
                            cem.Text_Area__c ='Please refer below Body.Txt Attachment as its an Archived Email Message';*/
                            
                           // cem.Incomming__c=em.Incoming;
                            cem.Message_Date__c=em.MessageDate;
                             
                            //cem.ReplyToEmailMessageId__c=em.ReplyToEmailMessageId;
                            cem.Status__c=em.Status;
                            cem.Subject__c = em.Subject;
                            cem.To_Address__c = em.ToAddress;
                           // cem.EmailMessageModifiedByID__c = String.ValueOf(em.LastModifiedBy.Name);
                           // cem.EmailMessafeModifiedByDate__c = em.LastModifiedDate;
                            caseEMListtoInsert.add(cem);
                            allMainEmailMsgID.add(String.ValueOF(em.id));
                            insertedNewEmailMessages.add(em.id);
                        }
                        system.debug('The List size (in loop EM) == '+caseEMListtoInsert.size());
                    }
                }
                
            }catch(exception e){
                system.debug('***** Case error *****');
                system.debug('The error is'+e.getMessage());
                system.debug('The error Line Number is'+e.getLineNumber());
            }   
        }
        
        system.debug('The List size (Case EM)== '+caseEMListtoInsert.size());  
        if(!caseEMListtoInsert.isEmpty()){ // inserting cases in Firm_s_Child__c table
            try{
                insert caseEMListtoInsert;
            }catch(exception e){
                system.debug('***** Case EM error *****');
                system.debug('The error is'+e.getMessage());
                system.debug('The error Line Number is'+e.getLineNumber());
            }   
        }

    }
    global void finish(Database.BatchableContext BC){
         /*AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CompletedDate,CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        if(a!=null){
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //String[] toAddresses = new String[] {'FirmManagement@mcmcg.com'};
         String[] toAddresses = new String[] {'sunny.kumar@mcmcg.com'};
         /*=================================
         // Add all CC Address via Custom Setting....
         List<String> lstEmailId=new List<String>();
         for (EmailNotification__c objEmail : EmailNotification__c.getAll().values())
         {
           lstEmailId.add(objEmail.Email__c);
         }
         if(lstEmailId.size()>0)
         {
           mail.setCcAddresses(lstEmailId);
         }
          =========================================================================
        mail.setToAddresses(toAddresses);
        
         mail.setSubject('Email Archival Batch Job has been completed: ' + a.CompletedDate);   
         mail.setPlainTextBody('This job has processed: '+ a.JobItemsProcessed +' batches with '+ a.NumberOfErrors + ' failures.');       
       
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        }*/
    } 
 
}