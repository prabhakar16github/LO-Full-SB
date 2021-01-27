public class PAMTriggerHelper{
    
    
    public static void beforeInsert(List<Process_Adherence_Monitoring__c> pamList, Map<Id, Process_Adherence_Monitoring__c> pamOldMap){

        //This will assign owners from organizations        
        PAM_AssignOwnerfromOrganization(pamList);
        
        RecordAssignmentInit(pamList);
    
        //This is to update Status and account standing field
        UpdateAccountStanding(pamList);
        
        // This is to Update Owner of PAM records
        UpdatePAMOwnerRecords(pamList);
        
        // This is to Update Exceptions of FRB record
        UpdateFRBExceptions(pamList, pamOldMap);
        updatePNAOwner(pamList);
        updateIROwner(pamList);
        
        //added on (30-5-2019) to update the owner of PAM (LO PSNM)
        
        updatePSNMOwner(pamList);
        
        ///****************************************************/
        
        //added on (12-6-2019) to update the owner of PAM (LO RSNM)
        updateRSNMOwner(pamList);
        
        ///****************************************************/
        
        
        updateAccountResolutionDate(pamList);
    }
    
    public static void beforeUpdate(List<Process_Adherence_Monitoring__c> pamList, Map<Id, Process_Adherence_Monitoring__c> pamOldMap){
        //This is to update Status and account standing field
        UpdateAccountStanding(pamList);
        
        UpdateFRBExceptions(pamList, pamOldMap);
        updateAccountResolutionDate(pamList);
    }
    
    
    /********************************* added on 10-01-2020 by Prabhakar Joshi After Update Trigger ****************************/
    public static void afterUpdate(List<Process_Adherence_Monitoring__c> triggerNew,Map<Id,Process_Adherence_Monitoring__c> oldMap){
        /***** added on 10-01-2020 by Prabhakar Joshi for hit the DM external gateway URL to send the PAM record to DM ****/
        //sendDataToDM(triggerNew,oldMap);
    }
    
    private static void sendDataToDM(List<Process_Adherence_Monitoring__c> triggerNew,Map<Id,Process_Adherence_Monitoring__c> oldMap){
        /***************************** To get the record Type Ids ************************************/
        Id DM_PSNM_RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM PSNM').getRecordTypeId();
        Id DM_RSNM_RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM RSNM').getRecordTypeId();
        
        for(Process_Adherence_Monitoring__c pam : triggerNew){
            if(pam.RecordTypeId == DM_PSNM_RecordTypeId){
                if(pam.Change_PSNM_Flag_to_Yes__c == true && oldMap.get(pam.Id).Change_PSNM_Flag_to_Yes__c != true){
                    DM_NoMedia_Integration.sendDataToDM(pam.Id);
                }else if(pam.Status__c == 'Closed' && oldMap.get(pam.Id).Status__c != 'Closed'
                         && pam.SOL_Observation_Description__c != NULL && pam.SOL_Observation_Description__c != oldMap.get(pam.Id).SOL_Observation_Description__c){
                             DM_NoMedia_Integration.sendDataToDM(pam.Id);
                         }
            }else if(pam.RecordTypeId == DM_RSNM_RecordTypeId){
                if((pam.Change_RSNM_Flag_to_Yes__c == true && oldMap.get(pam.Id).Change_RSNM_Flag_to_Yes__c != true) 
                   || (pam.Change_COT_Affidavit_Flag_to_Yes__c == true && oldMap.get(pam.Id).Change_COT_Affidavit_Flag_to_Yes__c != true)){
                       
                       DM_NoMedia_Integration.sendDataToDM(pam.Id);
                   }else if(pam.Status__c == 'Closed' && oldMap.get(pam.Id).Status__c != 'Closed' && pam.SOL_Observation_Description__c != NULL 
                        && pam.SOL_Observation_Description__c != oldMap.get(pam.Id).SOL_Observation_Description__c){
                            
                            DM_NoMedia_Integration.sendDataToDM(pam.Id);
                        }
            }
        }
    }
    
    public static void updatePNAOwner(List<Process_Adherence_Monitoring__c> pamList){
        Id pnaRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO PNA').getRecordTypeId();
        
        List<Process_Adherence_Monitoring__c> pamLOPNAList = new List<Process_Adherence_Monitoring__c>();  
        
        for(Process_Adherence_Monitoring__c pamObj : pamList){
            
            if(pamObj.recordTypeId == pnaRecordTypeId){
                
                pamLOPNAList.add(pamObj);
            }
        }
        
        if( pamLOPNAList.size() > 0 ){
            
            pam_updateOwnerAssociatedProcess(pamLOPNAList, 'Placement Acknowledgment');
        }
    }
    
    public static void updateIROwner(List<Process_Adherence_Monitoring__c> pamList){
        
        Id LO_IR_RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR').getRecordTypeId();
        Id ACF_IR_RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR').getRecordTypeId();
      //  Id DM_IR_RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM IR').getRecordTypeId();
        Set<Id> irRecordTypeIds = new Set<Id>{LO_IR_RecordTypeId,ACF_IR_RecordTypeId};//,DM_IR_RecordTypeId};
            
        List<Process_Adherence_Monitoring__c> pamIRList = new List<Process_Adherence_Monitoring__c>();  
        
        for(Process_Adherence_Monitoring__c pamObj : pamList){
            if(irRecordTypeIds.contains(pamObj.RecordTypeId)){
                pamIRList.add(pamObj);
            }
        }
        if(pamIRList.size() > 0){
           // System.debug('pamLOIRList PAM Trigger >>>> '+pamIRList);
            pam_updateOwnerAssociatedProcess(pamIRList, 'Inventory Reconciliation');
        }
    }
    
    //*********************added on (30-5-2019) to update the owner of PAM (LO PSNM)**********************//
    
    public static void updatePSNMOwner(List<Process_Adherence_Monitoring__c> pamList){
        Id dmPSNMRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM PSNM').getRecordTypeId();
        Id psnmRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO PSNM').getRecordTypeId();
        List<Process_Adherence_Monitoring__c> pamPSNMList = new List<Process_Adherence_Monitoring__c>();  
        
        for(Process_Adherence_Monitoring__c pamObj : pamList){
            if(pamObj.recordTypeId == psnmRecordTypeId || pamObj.recordTypeId == dmPSNMRecordTypeId){
                pamPSNMList.add(pamObj);
            }
        }
        if( pamPSNMList.size() > 0 ){
            pam_updateOwnerAssociatedProcess(pamPSNMList, 'Process Adherence Monitoring (PAM)');
        }
    }
    //******************************************************************************************************//
    
    //*********************added on (12-6-2019) to update the owner of PAM (LO RSNM)**********************//
    
    public static void updateRSNMOwner(List<Process_Adherence_Monitoring__c> pamList){
        Id dmRSNMRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM RSNM').getRecordTypeId();
        Id rsnmRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO RSNM').getRecordTypeId();
        List<Process_Adherence_Monitoring__c> pamRSNMList = new List<Process_Adherence_Monitoring__c>();  
        
        for(Process_Adherence_Monitoring__c pamObj : pamList){
            if(pamObj.recordTypeId == rsnmRecordTypeId || pamObj.recordTypeId == dmRSNMRecordTypeId){
                pamRSNMList.add(pamObj);
            }
        }
        if(pamRSNMList.size() > 0){
            pam_updateOwnerAssociatedProcess(pamRSNMList, 'Process Adherence Monitoring (PAM)');
        }
    }
    //******************************************************************************************************//
    
    
    public static void updateAccountResolutionDate(List<Process_Adherence_Monitoring__c> pamList){
        Set<Id> processRecordTypeIds = new Set<Id>();  
        processRecordTypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR - Account #\'s Sent').getRecordTypeId());
        processRecordTypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute - Account #s Sent').getRecordTypeId());
        processRecordTypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute - No PCodes Sent').getRecordTypeId());
       // system.debug('Pam Trigger updateAccountResolutionDate pamList '+JSON.serialize(pamList));
        for(Process_Adherence_Monitoring__c pamObj : pamList){
            if(processRecordTypeIds.contains(pamObj.recordTypeId)){
                if(pamObj.Status__c != null && pamObj.Status__c == 'Closed' && pamObj.Account_Resolution_Date__c == null){
                    pamObj.Account_Resolution_Date__c = system.today();
                }
            }
        }
    }
    
    public static void pam_updateOwnerAssociatedProcess(List<Process_Adherence_Monitoring__c> pamList, String processName){
        
        Set<Id> accountIds = new Set<Id>();
        Map<Id, Id> userIdByContactId = new Map<Id, Id>(); 
        
        for(Process_Adherence_Monitoring__c pamObj : pamList){
            
            if(pamObj.Organization_Name__c != null){

                accountIds.add(pamObj.Organization_Name__c);
            }
        } 
        
        
        Map<Id, Account> accountByaccountIdMap = new Map<Id, Account>([SELECT Id, Name, Firm_ID__c,
         
                                                                       (SELECT Id, ContactId, Contact.FirstName, Contact.Email, 
                                                                        Contact.Contact_Type_SME__c, Contact.Community_User__c 
                                                                        FROM AccountContactRelations 
                                                                        WHERE Contact.Contact_Type_SME__c INCLUDES(:processName) 
                                                                        OR Contact.Community_User__c = true)
                                                                         
                                                                       From Account WHERE Id IN :accountIds]);
        
        List<User> userList = [SELECT Id, Name, contactId, isActive 
                               FROM User
                               WHERE (Name = 'System Administrator' 
                                      AND Profile.Name = 'System Administrator' 
                                      AND isActive = True ) 
                               OR Contact.accountId IN : accountIds];
        
        User adminUser = new User(); 
        
        if(!userList.isEmpty()){
            
            for(User usr : userList){
                
                if(usr.Name == 'System Administrator'){
                    
                    adminUser = usr;
                }
                
                if(usr.ContactId != null && usr.isActive){
                    
                    userIdByContactId.put(usr.ContactId, usr.Id);
                }
            }
        }
        
        for(Process_Adherence_Monitoring__c pamObj : pamList){
            
            if(pamObj.Organization_Name__c != null && accountByaccountIdMap.containsKey(pamObj.Organization_Name__c)){
                
                Account accobj = accountByaccountIdMap.get(pamObj.Organization_Name__c);
                pamObj.OwnerId = assignPamOwner(adminUser, accobj, userIdByContactId, processName);
            }
        } 
       // System.debug('pamTriggerHelper.pam_updateOwnerAssociatedProcess  >>  '+pamList);
        
    }
    
     private static Id assignPamOwner(User adminUser, Account accObj, Map<Id, Id> userIdByContactId, String processName){
        
        Id assignOwnerId;
        
        for(AccountContactRelation accountContactRelation : accObj.AccountContactRelations){
            
            if(assignOwnerId == null 
                && accountContactRelation.Contact.Contact_Type_SME__c != null
                && String.valueOf(accountContactRelation.Contact.Contact_Type_SME__c).containsIgnoreCase(processName) 
                && accountContactRelation.Contact.Community_User__c && userIdByContactId.containsKey(accountContactRelation.ContactId)){
                        
                assignOwnerId = userIdByContactId.get(accountContactRelation.ContactId);
                break;
            }
        }
        
        if(assignOwnerId == null){
            
            for(AccountContactRelation accountContactRelation : accObj.AccountContactRelations){
                
                if(assignOwnerId == null && accountContactRelation.Contact.Community_User__c 
                        && userIdByContactId.containsKey(accountContactRelation.ContactId)){
                    
                    assignOwnerId = userIdByContactId.get(accountContactRelation.ContactId);
                    
                    break;
                }
            }
        }
        
        if(assignOwnerId == null){
            
            assignOwnerId = adminUser.Id;
        }
       //system.debug('pam owner assignmnt in pam trigge helper  >> '+assignOwnerId);

        return assignOwnerId;
    }
    
    public static void PAM_AssignOwnerfromOrganization(List<Process_Adherence_Monitoring__c> pamList){
        
        Set<Id> recordTypesToSkip = new Set<Id>(); 
        recordTypesToSkip.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute').getRecordTypeId());
        recordTypesToSkip.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute').getRecordTypeId());
        recordTypesToSkip.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR').getRecordTypeId());
        recordTypesToSkip.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute - Account #s Sent').getRecordTypeId());
        recordTypesToSkip.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute - No PCodes Sent').getRecordTypeId());
        recordTypesToSkip.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute - Account #s Sent').getRecordTypeId());
        recordTypesToSkip.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute - No PCodes Sent').getRecordTypeId());
        recordTypesToSkip.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR').getRecordTypeId());
        recordTypesToSkip.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM IR').getRecordTypeId());
        recordTypesToSkip.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM SCM Dispute').getRecordTypeId());
        
        Set<Id> accountId = new Set<Id>();
        List<User> userlist = new List<User>();
        Map<Id, User> userByAccountId = new Map<Id, User>();   
        
        for(Process_Adherence_Monitoring__c pam : pamList){
          if(pam.Organization_Name__c!= Null){
              accountId.add(pam.Organization_Name__c);   
          }
        }
        userList = [SELECT Id, Name, Contact.AccountId 
                    FROM User 
                    WHERE ContactId != null 
                    AND Contact.AccountId IN :accountId 
                    AND Contact.Contact_Type_SME__c INCLUDES ('Process Adherence Monitoring (PAM)') 
                    AND Contact.Inactive_Contact__c = FALSE 
                    AND isActive = true];
        
                        
        for(User userObj : userList){
            userByAccountId.put(userObj.Contact.AccountId, userObj);
        }
        
        for(Process_Adherence_Monitoring__c pam : pamList){
            
            if(!recordTypesToSkip.contains(pam.recordTypeId)){
                pam.OwnerId = UserInfo.getUserId();
                if(userByAccountId.containsKey(pam.Organization_Name__c)){
                    User user = userByAccountId.get(pam.Organization_Name__c);
                    if(user != null){
                        pam.OwnerId = user.Id;
                        pam.Inactive_Owner__c = False; 
                    }
                }
            }
        }
       // System.debug('PAMTriggerHelper.PAM_AssignOwnerfromOrganization.pamList >>>   '+pamList);
    }
    
    public static void RecordAssignmentInit(List<Process_Adherence_Monitoring__c> triggerList){
        //system.debug('Called');
        List<Process_Adherence_Monitoring__c> frbList = new List<Process_Adherence_Monitoring__c>();
        List<Process_Adherence_Monitoring__c> ccmJRList = new List<Process_Adherence_Monitoring__c>();
        List<Process_Adherence_Monitoring__c> ccmSRList = new List<Process_Adherence_Monitoring__c>();
        List<Process_Adherence_Monitoring__c> solList = new List<Process_Adherence_Monitoring__c>();
        
        Id recordTypeFRB =  Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO FRB').getRecordTypeId();
        Id recordTypeCCM_JR =  Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO CCM - JR').getRecordTypeId();
        Id recordTypeCCM_SR =  Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO CCM - SR').getRecordTypeId();
        Id recordTypeSOL =  Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SOL').getRecordTypeId();
        
        for(Process_Adherence_Monitoring__c pamObj : triggerList){
            if(pamObj.RecordTypeId == recordTypeFRB){
                frbList.add(pamObj);
            }else if(pamObj.RecordTypeId == recordTypeCCM_JR){
                ccmJRList.add(pamObj);
            }else if(pamObj.RecordTypeId == recordTypeCCM_SR){
                ccmSRList.add(pamObj);
            }else if(pamObj.RecordTypeId == recordTypeSOL){
                solList.add(pamObj);
            }
        }
        
        if(!frbList.isEmpty()) PAMTriggerHelper.PAMRecordAssignment(frbList,'FRB','Sara Christopherson');
        if(!ccmJRList.isEmpty()) PAMTriggerHelper.PAMRecordAssignment(ccmJRList,'Financial Exceptions/Court Costs','Brittany Tholund-Schafer');
        if(!ccmSRList.isEmpty()) PAMTriggerHelper.PAMRecordAssignment(ccmSRList,'Financial Exceptions/Court Costs','Brittany Tholund-Schafer');
        if(!solList.isEmpty()) PAMTriggerHelper.PAMRecordAssignment(solList,'SOL','Alisha Schuldt');
        
        /*system.debug('frbList ' + frbList.isEmpty());
        system.debug('ccmJRList ' + ccmJRList.isEmpty());
        system.debug('ccmSRList ' + ccmSRList.isEmpty());
        system.debug('solList ' + solList.isEmpty());*/
    }
    
    public static void PAMRecordAssignment(List<Process_Adherence_Monitoring__c> triggerList, String smeType, String userName){
        system.debug('Called Again');
        List<String> smeList = new List<String>{smeType};
        Set<String> accountIdSet = new Set<String>();
        for(Process_Adherence_Monitoring__c pamObj : triggerList){
            if(pamObj.Organization_Name__c != null) accountIdSet.add(pamObj.Organization_Name__c);
        }
        
        Map<String,String> ownerMap = new Map<String,String>();
        system.debug(accountIdSet);
        system.debug(smeType);

        List<User> userList = [SELECT id, Contact.AccountId FROM User WHERE Contact.AccountId in: accountIdSet AND Contact.Inactive_Contact__c = FALSE AND 
                                IsActive = true AND (Contact.Contact_Type_SME__c includes (:smeType) OR Contact.Contact_Type_SME__c =: smeType)];
        //system.debug('userList ' + userList);
        for(User userObj : userList){
            if(ownerMap.get(userObj.Contact.AccountId) == null) ownerMap.put(userObj.Contact.AccountId,userObj.id);
        }
        
        accountIdSet.removeAll(ownerMap.keyset());
        
        if(!accountIdSet.isEmpty()){
            userList = [SELECT id, Contact.AccountId FROM User WHERE Contact.AccountId in: accountIdSet AND Contact.Inactive_Contact__c = FALSE AND 
                                IsActive = true];
            system.debug('userList 2 ' + userList);
            for(User userObj : userList){
                if(ownerMap.get(userObj.Contact.AccountId) == null) ownerMap.put(userObj.Contact.AccountId,userObj.id);
            }
        }
        
        accountIdSet.removeAll(ownerMap.keyset());
        
        if(!accountIdSet.isEmpty()){
            userList = [SELECT id FROM User WHERE Name =: userName AND isActive = true];
            //system.debug('userList 3 ' + userList);
            for(String accId : accountIdSet){
                ownerMap.put(accId,userList[0].id);
            }
        }
        
        for(Process_Adherence_Monitoring__c pamObj : triggerList){
            if(pamObj.Organization_Name__c != null) pamObj.OwnerId = ownerMap.get(pamObj.Organization_Name__c);
        }
    }
    
    public static void UpdateAccountStanding(List<Process_Adherence_Monitoring__c> triggerList){
        Id recordTypeFRB =  Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO FRB').getRecordTypeId();
        for(Process_Adherence_Monitoring__c pamObj : triggerList){
            if(pamObj.ToupdateCloseStatus__c || pamObj.RecordTypeId != recordTypeFRB) continue;
            if(pamObj.Day_Counter__c >= 0 && pamObj.Day_Counter__c <= 3){
                pamObj.Account_Standing__c= '0-3 Days (Green - New Exception)';
                pamObj.Status__c= 'New';
           }else if(pamObj.Day_Counter__c >= 4 && pamObj.Day_Counter__c <= 6){
                pamObj.Account_Standing__c= '4-6 Days (Yellow - Outside Correction Timeframe)';
                pamObj.Status__c= 'First Escalation';
           }else if(pamObj.Day_Counter__c >= 7 && pamObj.Day_Counter__c <= 10){
                pamObj.Account_Standing__c= '7-10 Days (Orange - Approaching Critical Timeframe)';
                pamObj.Status__c ='Second Escalation';
           }else if(pamObj.Day_Counter__c >= 11){
                pamObj.Account_Standing__c= '11-19 Days (Red - Immediate Correction Required)';
                pamObj.Status__c ='Final Escalation';
           }
        }
    }
    
    public static void UpdateFRBExceptions(List<Process_Adherence_Monitoring__c> triggerList, Map<Id,Process_Adherence_Monitoring__c> oldMap){
        Id recordTypeFRB =  Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO FRB').getRecordTypeId();
        for(Process_Adherence_Monitoring__c pamObj : triggerList){
            if(oldMap != null && pamObj.RecordTypeId == recordTypeFRB && pamObj.Status__c != 'Closed'){
                Process_Adherence_Monitoring__c oldPamObj = oldMap.get(pamObj.Id);
            
                if(oldPamObj.C1_TOTAL_BAL_THRESHOLD__c && !pamObj.C1_TOTAL_BAL_THRESHOLD__c){
                    pamObj.C1_TOTAL_BAL_THRESHOLD__c = true;
                    if(pamObj.C1_Resolution_Date__c == null){
                        pamObj.C1_Resolution_Date__c = system.today();
                    }
                }
                
                if(oldPamObj.C2_RCVRABLE_COST_COST_SPENT__c && !pamObj.C2_RCVRABLE_COST_COST_SPENT__c){
                    pamObj.C2_RCVRABLE_COST_COST_SPENT__c = true;
                    if(pamObj.C2_Resolution_Date__c == null){
                        pamObj.C2_Resolution_Date__c = system.today();
                    }
                }
                
                if(oldPamObj.C3_ATTY_OTHER_FEES_CNTRCT_AMT__c && !pamObj.C3_ATTY_OTHER_FEES_CNTRCT_AMT__c){
                    pamObj.C3_ATTY_OTHER_FEES_CNTRCT_AMT__c = true;
                    if(pamObj.C3_Resolution_Date__c == null){
                        pamObj.C3_Resolution_Date__c = system.today();
                    }
                }
                
                if(oldPamObj.C4_ATTY_FEES_STAT_AMT__c && !pamObj.C4_ATTY_FEES_STAT_AMT__c){
                    pamObj.C4_ATTY_FEES_STAT_AMT__c = true;
                    if(pamObj.C4_Resolution_Date__c == null){
                        pamObj.C4_Resolution_Date__c = system.today();
                    }
                }
                
                if(oldPamObj.C5_INTEREST_RATE__c && !pamObj.C5_INTEREST_RATE__c){
                    pamObj.C5_INTEREST_RATE__c = true;
                    if(pamObj.C5_Resolution_Date__c == null){
                        pamObj.C5_Resolution_Date__c = system.today();
                    }
                }
            
                if(oldPamObj.C6_INTEREST_THRESHOLD__c && !pamObj.C6_INTEREST_THRESHOLD__c){
                    pamObj.C6_INTEREST_THRESHOLD__c = true;
                    if(pamObj.C6_Resolution_Date__c == null){
                        pamObj.C6_Resolution_Date__c = system.today();
                    }
                }
                
                if(oldPamObj.C7_CALCULATED_BALANCE_FIRM_BAL__c && !pamObj.C7_CALCULATED_BALANCE_FIRM_BAL__c){
                    pamObj.C7_CALCULATED_BALANCE_FIRM_BAL__c = true;
                    if(pamObj.C7_Resolution_Date__c == null){
                        pamObj.C7_Resolution_Date__c = system.today();
                    }
                }
            
                if(oldPamObj.C7A_PRIN_AMT_PLACED_PRIN__c && !pamObj.C7A_PRIN_AMT_PLACED_PRIN__c){
                    pamObj.C7A_PRIN_AMT_PLACED_PRIN__c = true;
                    if(pamObj.C7A_Resolution_Date__c == null){
                        pamObj.C7A_Resolution_Date__c = system.today();
                    }
                }
            
                if(oldPamObj.C7B_REC30_PMTS_ADJS_REC42_PMTS_ADJS__c && !pamObj.C7B_REC30_PMTS_ADJS_REC42_PMTS_ADJS__c){
                    pamObj.C7B_REC30_PMTS_ADJS_REC42_PMTS_ADJS__c = true;
                    if(pamObj.C7B_Resolution_Date__c == null){
                        pamObj.C7B_Resolution_Date__c = system.today();
                    }
                }
            
                if(oldPamObj.C7C_REC30_RCVR_COST_REC42_RCVR_COST__c && !pamObj.C7C_REC30_RCVR_COST_REC42_RCVR_COST__c){
                    pamObj.C7C_REC30_RCVR_COST_REC42_RCVR_COST__c= true;
                    if(pamObj.C7C_Resolution_Date__c == null){
                        pamObj.C7C_Resolution_Date__c = system.today();
                    }
                }
            
                if(oldPamObj.C7D_CURRENT_BALANCE_0__c && !pamObj.C7D_CURRENT_BALANCE_0__c){
                    pamObj.C7D_CURRENT_BALANCE_0__c = true;
                    if( pamObj.C7D_Resolution_Date__c == null){
                        pamObj.C7D_Resolution_Date__c = system.today();
                    }
                }
            }
        }
    }
    
    public static void UpdatePAMOwnerRecords(List<Process_Adherence_Monitoring__c> triggerList){
        Set<String> accountIdSet = new Set<String>();
        for(Process_Adherence_Monitoring__c pamObj : triggerList){
            accountIdSet.add(pamObj.Organization_Name__c);
        }
        
        List<User> userList = [SELECT ContactId, Contact.AccountId FROM User WHERE Contact.AccountId IN: accountIdSet AND 
                                Contact.Inactive_Contact__c = FALSE AND (Contact.Contact_Type_SME__c INCLUDES ('Process Adherence Monitoring (PAM)') OR 
                                Contact.Contact_Type_SME__c = 'Process Adherence Monitoring (PAM)') AND isActive = TRUE];
        Map<Id,User> userMap = new Map<Id,User>();
        for(User userObj : userList){
            userMap.put(userObj.Contact.AccountId,userObj);
        }
        
        Id recordTypeFRB =  Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO FRB').getRecordTypeId();
        Id recordTypeCCM_JR =  Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO CCM - JR').getRecordTypeId();
        Id recordTypeCCM_SR =  Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO CCM - SR').getRecordTypeId();
        Id recordTypeSOL =  Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SOL').getRecordTypeId();
        //Id recordTypeIR =  Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR').getRecordTypeId();
        Id recordTypeIR =  Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM IR').getRecordTypeId();
        
        for(Process_Adherence_Monitoring__c pamObj : triggerList){
            if(pamObj.RecordTypeId != recordTypeSOL && pamObj.RecordTypeId != recordTypeCCM_SR && pamObj.RecordTypeId != recordTypeCCM_JR && 
                pamObj.RecordTypeId != recordTypeFRB  && userMap.get(pamObj.Organization_Name__c) != null 
                && pamObj.RecordTypeId != recordTypeIR){ //
                pamObj.OwnerId = userMap.get(pamObj.Organization_Name__c).id;
                pamObj.Inactive_Owner__c = false;
            }
        }
    }
}