public class CaseTriggerHelper{
    
    public static void FRBCaseandBatchRun(){
        if(!Trigger.isInsert) return ;
        Boolean runBatch = false;
        for(Case caseObj : (List<Case>)Trigger.new){
            if(caseObj.Subject != null && caseObj.Subject.equals('PAM - BI Enterprise Data Integration Load Completed')){
                
                List<User> userList = [SELECT id FROM User WHERE Name = 'System Administrator' AND Profile.Name = 'System Administrator' LIMIT 1];
                if(!userList.isEmpty()){
                    caseObj.OwnerId = userList.get(0).id;
                }
                caseObj.Reason = 'Firm Reported Balance';
                caseObj.Subcategories__c = 'Upload';
                runBatch = true;
            }
        }
        
        if(runBatch) Database.executeBatch(new FRB_BatchToUpdateCloseStatus(),500);
    }
    
    public static void PAMCaseAndBatchRun(List<Case> caseNewList){
        
        Id pamRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Operations - PAM').getRecordTypeId();
        List<Contact> contactList = [SELECT Id, Name FROM Contact WHERE Name = 'System Administrator' LIMIT 1];
        Contact systemAdministratorContact = new Contact();
        
        if(!contactList.isEmpty()){
            systemAdministratorContact = contactList.get(0); 
        }
        
        Boolean runBatchCCM = false;
        Boolean runBatchSOL = false;
        Boolean runBatchPNA = false;
        Boolean runBatchIRUM = false;
        Boolean runBatchIRUM_ACF = false;
        //created on 20-Mar for IR DM process
       // Boolean runBatchIRUM_DM = false;
        Boolean runBatchSCUM = false;
        Boolean runBatchSCUM_ACF = false;
       
        for(Case caseObj : caseNewList){
            
            if( pamRecordTypeId != null && caseObj.recordTypeId != null &&  caseObj.recordTypeId == pamRecordTypeId && caseObj.Subcategories__c == 'Scripts - CCM'){
                
                caseObj.Subject = 'Scripts - CCM';
                caseObj.ContactId = systemAdministratorContact.id;
                caseObj.Outcome_FTR__c = 'Scripts - CCM running in progress';
                runBatchCCM = true;
                
            }else if(pamRecordTypeId != null && caseObj.recordTypeId != null &&  caseObj.recordTypeId == pamRecordTypeId && caseObj.Subcategories__c  == 'Scripts - SOL'){
                
                caseObj.Subject = 'Scripts - SOL';
                caseObj.ContactId = systemAdministratorContact.id;
                caseObj.Outcome_FTR__c = 'Scripts - SOL running in progress';
                runBatchSOL = true;
                
            }else if(pamRecordTypeId != null && caseObj.recordTypeId != null &&  caseObj.recordTypeId == pamRecordTypeId && caseObj.Subcategories__c  == 'Scripts - PNA'){
                
                caseObj.Subject = 'Scripts - PNA';
                caseObj.ContactId = systemAdministratorContact.id;
                caseObj.Outcome_FTR__c = 'Scripts - PNA running in progress';
                runBatchPNA = true;
            }else if(pamRecordTypeId != null && caseObj.recordTypeId != null &&  caseObj.recordTypeId == pamRecordTypeId && caseObj.Subcategories__c  == 'Scripts - IRUM'){
                
                caseObj.Subject = 'Scripts - IRUM';
                caseObj.ContactId = systemAdministratorContact.id;
                caseObj.Outcome_FTR__c = 'Scripts - IRUM running in progress';
                runBatchIRUM = true;
            }else if(pamRecordTypeId != null && caseObj.recordTypeId != null &&  caseObj.recordTypeId == pamRecordTypeId && caseObj.Subcategories__c  == 'Scripts - IRUM ACF'){
                
                caseObj.Subject = 'Scripts - IRUM ACF';
                caseObj.ContactId = systemAdministratorContact.id;
                caseObj.Outcome_FTR__c = 'Scripts - IRUM ACF running in progress';
                runBatchIRUM_ACF = true;
            }else if (pamRecordTypeId != null && caseObj.recordTypeId != null &&  caseObj.recordTypeId == pamRecordTypeId && caseObj.Subcategories__c  == 'Scripts - SCMUM'){
               
                caseObj.Subject = 'Scripts - SCMUM';
                caseObj.ContactId = systemAdministratorContact.id;
                caseObj.Outcome_FTR__c = 'Scripts - SCMUM running is progress';
                runBatchSCUM = true;
            }/*else if (pamRecordTypeId != null && caseObj.recordTypeId != null &&  caseObj.recordTypeId == pamRecordTypeId && caseObj.Subcategories__c  == 'Scripts - SCMUM ACF'){
                
                caseObj.Subject = 'Scripts - SCMUM ACF';
                caseObj.ContactId = systemAdministratorContact.id;
                caseObj.Outcome_FTR__c = 'Scripts - SCMUM ACF running is progress';
                runBatchSCUM_ACF = true;
            }*/
            //
           /* else if (pamRecordTypeId != null && caseObj.recordTypeId != null &&  caseObj.recordTypeId == pamRecordTypeId && caseObj.Subcategories__c  == 'Scripts - IRUM DM'){
               
                caseObj.Subject = 'Scripts - SCMUM';
                caseObj.ContactId = systemAdministratorContact.id;
                caseObj.Outcome_FTR__c = 'Scripts - IRUM DM running is progress';
                runBatchIRUM_DM = true;
            }*/
        }
        
        if(runBatchSOL){
            Database.executeBatch(new SOLUpdateExceptionFieldsBatch(),1);
            runBatchSOL = false;
        }
        
        if(runBatchCCM){
            Database.executeBatch(new CCM_BatchToUpdateCloseStatus(),2000);
            runBatchCCM = false;    
        }
        
        if(runBatchPNA){
            Database.executeBatch(new PNA_BatchToUpdateCloseStatus() ,1000);
            runBatchPNA = false; 
        }
        
        if(runBatchIRUM){
            Database.executeBatch(new IRUM_SendCreationNotificationBatch() ,1);
            /*Closing the IRUM record here 
            LastModified - 11/12/2019
            */
            Database.executeBatch(new ClosePamUnmatchedRecord('LO IR - Account #\'s Sent'));
            runBatchIRUM = false; 
        }
        
        if(runBatchIRUM_ACF){
            Database.executeBatch(new IRUM_ACF_CreationNotificationBatch() ,1);
            /*Closing the IRUM record here 
            LastModified - 11/12/2019
            */
            Database.executeBatch(new ClosePamUnmatchedRecord('ACF IR - Account #\'s Sent'));
            runBatchIRUM_ACF = false;   
        }
        //Created on 20-Mar for DM IR
       /* if(runBatchIRUM_DM){
          //  Database.executeBatch(new IRUM_DM_CreationNotificationBatch() ,1);
            /*Closing the IRUM record here 
            
            //Database.executeBatch(new ClosePamUnmatchedRecord('DM IR - Account #\'s Sent'));
            runBatchIRUM_ACF = false;   
        }*/
        
        if(runBatchSCUM){
            /* call batch to send notification here for SCUM unmatched
              LastModified - 11/12/2019
            */
               Database.executeBatch(new SCUM_CreationNotificationBatch('LO SCMDUM'));
             /* running the script to close the scum record here 
                LastModified - 11/12/2019
             */
             
             Database.executeBatch(new ClosePamUnmatchedRecord('LO SCM Dispute - Account #s Sent'));
             runBatchSCUM = false;
        }
        
        /*if(runBatchSCUM_ACF){
             
               call batch to send notification here for SCUM unmatched
               LastModified - 11/12/2019
            
               Database.executeBatch(new SCUM_CreationNotificationBatch('ACF SCMDUM')); //
        
               running the script to close the scum ACF record here 
               LastModified - 11/12/2019
                         
             Database.executeBatch(new ClosePamUnmatchedRecord('ACF SCM Dispute - Account #s Sent'));
             runBatchSCUM_ACF = true;
        }*/
        
        
    }
    
    public static void YGC_RejectReportonCase(List<Case> caseNewList, Map<Id, Case> caseOldMap){

        if(checkRecursive.runOnce()){
            
            Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Case.getRecordTypeInfosByName();
            Id rtLeadID =  rtMap.get('Operations - YGC Reject Report').getRecordTypeId(); 
            List<Case> caseList = new List<Case>();
            List<Contact> conc = new List<Contact>();
            
            caseList = [Select id,RecordTypeId,ContactId,Firm_ID__c,CaseNumber,Reason FROM Case WHERE Recordtypeid =: rtLeadID and Id IN: caseNewList];
            conc = [Select id,Contact_Type_SME__c,Inactive_Contact__c,Email,Firm_ID__c,FirstName FROM Contact 
                        WHERE Contact_Type_SME__c INCLUDES ('YGC Reject Report') AND Inactive_Contact__c = False AND Email != null];
            system.debug('contactemails-->'+caseList);
            system.debug('conc-->'+conc);
            
            List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>();   
                
            for(Contact cont : conc){
                
                for(Case casel : caseList){
                
                    if(caseOldMap.get(casel.id).Recordtypeid != rtLeadID){
                                                
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTargetObjectId(cont.id);
                        string body =   '<html lang="ja"><body>'+
                        
                                'Hello '+cont.FirstName+
                                '<br><br>'+'Please be advised that the firm may have YGC transactions that have rejected. These rejections'+
                                '<br>'+'are high priority and will require action taken to correct.'+
                                '<br><br><br>'+'All records rejected can be viewed by looking at the Returned Mail Inbox on YGC.'+
                                '<br><br>'+'For court costs rejected the firm will need to resubmit using one of the MCM approved cost'+
                                '<br>'+'codes (see MCM Firm Manual for approved cost codes).'+
                                '<br><br>'+'If you have questions please send an email to to LO-Operational@mcmcg.com using the format'+
                                '<br>'+'below:'+'<br><br>'+'Thank you,'+'<br><br>'+'YGC Reject Report Team';
                        
                        mail.setSubject(cont.Firm_ID__c+' '+'YGC Reject Report'+' '+'Case #'+casel.CaseNumber);
                        mail.sethtmlBody(body); 
                        mail.setSaveAsActivity(false);  
                        lstMails.add(mail);
                    }
                }              
                    
            }
            
            if(lstMails.size() >0 || lstMails != Null){
               Messaging.sendEmail(lstMails);  
            }
            
            system.debug('lstMails-->'+lstMails);
         }
        
    }
    
    public static void updateFirmDuringEmail2Case(List<Case> caseNewList){
        
        Map<ID, Set<String>> mapCaseIDSubject = new Map<ID, Set<String>>();
        Map<String,String> setofAgencyID = new Map<String,String> ();
        map<ID,string> mapAccIDFirmORAgencyName = new map<ID,string>(); 
        map<String,ID> mapFirmiAgencyNameID = new map<string,ID>(); 
         
        
        // List to Update Case
        list<Case> updateCaseLst = new list<Case>();
        set<Case> updateCaseSet = new set<Case>(); 
        map<id,case> mapofWinCase = new  map<id,case>();
            
        for(case c:caseNewList){
            
            system.debug('c----------->'+c.OwnerId);
            
           if(c.subject!='' && c.subject!=null
                && c.Mapped_Organization_Value__c==null && c.Firm_ID__c=='CA20'){
          
                String[] cd = c.subject.split(' ');
                Set<String> extractUniqueSubject = new Set<String>();
                for(string s:cd){
                       
                        if(s.isAlphanumeric()){
                            extractUniqueSubject.add(s.toUpperCase());
                        }        
           
                }
                
                mapCaseIDSubject.put(c.id,extractUniqueSubject);
                system.debug('mapCaseIDSubject--------->'+mapCaseIDSubject);       
           
           }else{
                                       
                if(c.AccountID!=null && c.Firm_ID__c=='CA20'){
                    Case cUpdate = new Case();
                    cUpdate.id=c.id;
                    cUpdate.AccountId =null;                       
                    cUpdate.IsOrganizationUpdated__c=false;
                    cUpdate.Mapped_Organization_Value__c='';
                    updateCaseSet.add(cUpdate);     
                    break;   
                }
                
                system.debug('updateCaseSet------------->'+updateCaseSet); 
                 
            }    
                    
            
        }      
             
        if(!mapCaseIDSubject.isEmpty()){
            
            for(Account a:[SELECT id,Name,Agency_ID__c,Firm_ID__c  FROM Account limit 2000]){
                
                if(a.Firm_ID__c!='' && a.Firm_ID__c!=null && mapAccIDFirmORAgencyName.get(a.id)==null){
                
                    mapAccIDFirmORAgencyName.put(a.id,a.Firm_ID__c);        
                    mapFirmiAgencyNameID.put(a.Firm_ID__c,a.id);
                
                }else{
                            
                    mapAccIDFirmORAgencyName.put(a.id,a.Agency_ID__c);
                    mapFirmiAgencyNameID.put(a.Agency_ID__c,a.id);
                    setofAgencyID.put(a.Agency_ID__c,a.Agency_ID__c);
                }
                
                system.debug('mapAccIDFirmORAgencyName---------------->'+mapAccIDFirmORAgencyName);
                system.debug('mapFirmiAgencyNameID---------------->'+mapFirmiAgencyNameID);
                system.debug('setofAgencyID---------------->'+setofAgencyID);       
            }
        
        }   
            
        for(case c:caseNewList){
            
           
           if(mapCaseIDSubject.get(c.id)!=null){
             
            Boolean processedCase = false;
                
                for(String sMatch: mapCaseIDSubject.get(c.id)){
                    
                    if(mapFirmiAgencyNameID.get(sMatch)!=null && !processedCase){
                        
                        
                        if(mapofWinCase.get(c.id)!=null){
                            System.debug('Sunny------9-Lose'+c);
                            mapofWinCase.remove(c.id);
                            updateCaseSet.remove(c);                        
                        }
                           
                        Case cUpdate = new Case();
                        cUpdate.id=c.id;
                        cUpdate.AccountId = mapFirmiAgencyNameID.get(sMatch);                       
                        cUpdate.IsOrganizationUpdated__c=true;                      
                        cUpdate.Mapped_Organization_Value__c=sMatch;
                        processedCase=true;                      
                        mapofWinCase.put(cUpdate.id,cUpdate);   
                        
                        if(processedCase){
                            updateCaseSet.add(cUpdate);
                        }
                               
                       break; 
                    } 
                    // only to update of no match found
                                    
                }   
                        
                if(mapofWinCase.get(c.id)==null && c.Firm_ID__c!='CA20'){
                
                    Case cUpdate = new Case();
                    cUpdate.id=c.id;
                    cUpdate.AccountId =null;                       
                    cUpdate.IsOrganizationUpdated__c=false;
                    cUpdate.Mapped_Organization_Value__c='';                                     
                    updateCaseSet.add(cUpdate);         
                    system.debug('updateCaseSet------------->'+updateCaseSet);
                }
            
            }
            
        }
            
            
        if(!updateCaseSet.isEmpty()){
            System.debug('updateCaseSet--->'+updateCaseSet.size()+'---->'+updateCaseSet);
            updateCaseLst.addALL(updateCaseSet);
            System.debug('updateCaseLst.size--->'+updateCaseLst.size()+'updateCaseLst---->'+updateCaseLst);
            update updateCaseLst;   
        } 
        
    }
    
    public static void sendDataToDM(List<Case> triggerNew){
        String fromDate = String.valueOf(System.today().addDays(-1)).split(' ')[0];
        for(Case cs : triggerNew){
            if(cs.Subcategories__c == 'Scripts - PSNM/RSNM'){
                DM_NoMedia_Integration.getData(fromDate);
            }
        }
    }
    
}