public class ConsumerAccountDetailTriggerHelper {
    /*
update six child object where resolutionCheckbox would be true
*/
    public static void updateResolutionField(List<Consumer_Account_Details__c> CadList){
        
        // update appeal object here 
        List<Appeal__c> appealObjList = [select id ,AP_Resolution_Master_Details_Available__c,
                                         AP_Resolution_Master_Detail_Record__c 
                                         from Appeal__c 
                                         where AP_Consumer_Account_Record__c in :cadList];
        
        List<Appeal__c> appealObjLists = new List<Appeal__c>(); 
        
        for(Appeal__c app : appealObjList){
            //if(!app.AP_Resolution_Master_Detail_Record__c){
                app.AP_Resolution_Master_Details_Available__c = true;
                appealObjLists.add(app);
            //}  
        }
        
        if(appealObjLists.size() > 0){
            update appealObjLists ;
        }
        
        // update counter claim object here 
        List<Counterclaim__c> counterClaimList = [select id,CC_Resolution_Master_Details_Available__c,CC_Resolution_Master_Detail_Record__c from Counterclaim__c 
                                                  where CC_Consumer_Account_Detail_Name__c in :cadList];
        
        List<Counterclaim__c> counterClaimLists = new List<Counterclaim__c>();        
        
        for(Counterclaim__c cc :  counterClaimList ){
            //if(!cc.CC_Resolution_Master_Detail_Record__c){
                cc.CC_Resolution_Master_Details_Available__c  = true;
                counterClaimLists.add(cc);
            //}
        }         
        
        if(counterClaimLists.size() > 0){
            update counterClaimLists ;
        }
        
        // update Purchase and Sales Agreement object here 
        List<Purchase_and_Sales_Agreement__c> purchaseAndSalesList = [select id,PSA_Resolution_Master_Details_Available__c,PSA_Resolution_Master_Detail_Record__c from Purchase_and_Sales_Agreement__c where 
                                                                      PSA_Consumer_Account_Detail_Name__c In : cadList];
        
        List<Purchase_and_Sales_Agreement__c> purchaseAndSalesLists = new List<Purchase_and_Sales_Agreement__c>();
        
        for(Purchase_and_Sales_Agreement__c pp : purchaseAndSalesList ){
            //if(!pp.PSA_Resolution_Master_Detail_Record__c){
                pp.PSA_Resolution_Master_Details_Available__c = true;
                purchaseAndSalesLists.add(pp); 
            //}
        }
        
        if(purchaseAndSalesLists.size() > 0){
            update purchaseAndSalesLists ;
        }
        
        // update Trial Witness Request object here  
        
        List<Trial_Witness_Request__c> trialInfoList = [select id,LW_Resolution_Master_Details_Available__c,LW_Resolution_Master_Detail_Record__c  from Trial_Witness_Request__c where TW_Consumer_Account_Records__c
                                                        In : cadList AND Recordtype.name = 'Live Witness Request Step III'];
        
        List<Trial_Witness_Request__c> trialInfoLists = new List<Trial_Witness_Request__c>();    
        
        for(Trial_Witness_Request__c tw : trialInfoList){
            //if(!tw.LW_Resolution_Master_Detail_Record__c){
                tw.LW_Resolution_Master_Details_Available__c  = true;
                trialInfoLists.add(tw);
            //}
        }
        
        if(trialInfoLists.size() > 0){
            
            update trialInfoLists;
        }  
        
        //  update Escalated Contested Matters object here
        
        List<Escalated_Contested_Matters__c> escalatedContestList = [select id,ECM_Resolution_Master_Details_Available__c ,ECM_Resolution_Master_Detail_Record__c from Escalated_Contested_Matters__c 
                                                                     where ECM_Consumer_Account_Detail_Name__c IN : cadList];
        
        List<Escalated_Contested_Matters__c> escalatedContestLists = new List<Escalated_Contested_Matters__c>();
        
        for(Escalated_Contested_Matters__c ecm : escalatedContestList){
            //if(!ecm.ECM_Resolution_Master_Detail_Record__c){
                ecm.ECM_Resolution_Master_Details_Available__c = true;
                escalatedContestLists.add(ecm);
            //}
        }                        
        
        if(escalatedContestLists.size() > 0){
            update escalatedContestLists ;
        }
        
        // update settlement object here 
        
        List<Settlement_Approval__c> settlementApp = [select id , SA_Resolution_Master_Details_Available__c,SA_Resolution_Master_Detail_Record__c from Settlement_Approval__c 
                                                      where SA_Consumer_Account_Details__c IN : cadList];  
        
        List<Settlement_Approval__c> settlementApps = new List<Settlement_Approval__c>();
        
        for(Settlement_Approval__c sa : settlementApp){
            //if(!sa.SA_Resolution_Master_Detail_Record__c){
                sa.SA_Resolution_Master_Details_Available__c = true;
                settlementApps.add(sa);
            //} 
        }           
        
        if(settlementApps.size() > 0){
            update settlementApps ;
        }  
        
    }
    
    
    public static void beforeInsertConsumerAccountDetail(List<Consumer_Account_Details__c> newCadList){
        
        Set<Consumer_Account_Details__c> masterLinkedAccount = new Set<Consumer_Account_Details__c>();
        
        for(Consumer_Account_Details__c cadObj : newCadList){
            
            if(cadObj.CAD_Linked_Master_CAD__c){
                masterLinkedAccount.add(cadObj);
            }
        }
        
        if(!masterLinkedAccount.isEmpty() && checkRecursive.runOnce()){
            
            addErrorIfMasterExists(masterLinkedAccount);
        } 
    }
    
    public static void beforeUpdateConsumerAccountDetail(List<Consumer_Account_Details__c> newCadList, Map<Id, Consumer_Account_Details__c> cadByIdOldMap){
        
        Set<Consumer_Account_Details__c> masterLinkedAccount = new Set<Consumer_Account_Details__c>();
        
        for(Consumer_Account_Details__c cadObj : newCadList){
            
            if(cadObj.CAD_Linked_Master_CAD__c && cadObj.CAD_Linked_Master_CAD__c != cadByIdOldMap.get(cadObj.id).CAD_Linked_Master_CAD__c){
                
                masterLinkedAccount.add(cadObj);
            }
        }
        
        if(!masterLinkedAccount.isEmpty() && checkRecursive.runOnce()){
            
            addErrorIfMasterExists(masterLinkedAccount);    
        } 
    }
    
    public static void afterInsertConsumerAccountDetail(List<Consumer_Account_Details__c> newCadList){
        
        system.debug('enterd in the block of after insert ------>');
        Set<Id> masterCadIdToUpdate = new Set<Id>(); 
        String linkedRecordTypeId = Schema.SObjectType.Consumer_Account_Details__c.getRecordTypeInfosByName().get('CAD: MCM Linked Account Details').getRecordTypeId();
        
        for(Consumer_Account_Details__c cadObj : newCadList){
            
            if(cadObj.recordTypeId == linkedRecordTypeId && cadObj.Linked_Master_CAD_Account__c != null){
                masterCadIdToUpdate.add(cadObj.Linked_Master_CAD_Account__c);
            }
        }
        
        if(!masterCadIdToUpdate.isEmpty() && checkRecursive.runOnce()){
            updateAmountOnMaster(masterCadIdToUpdate);
        }
    }
    
    public static void afterUpdateConsumerAccountDetail(List<Consumer_Account_Details__c> newCadList, Map<Id, Consumer_Account_Details__c> cadByIdOldMap){
        
        Set<Id> masterCadIdToUpdate = new Set<Id>(); 
        
        for(Consumer_Account_Details__c cadObj : newCadList){
            
            if(cadObj.Linked_Master_CAD_Account__c != null 
               && (cadObj.Linked_Master_CAD_Account__c != cadByIdOldMap.get(cadObj.Id).Linked_Master_CAD_Account__c 
                   || cadObj.Account_Balance__c != cadByIdOldMap.get(cadObj.Id).Account_Balance__c)){
                       
                       masterCadIdToUpdate.add(cadObj.Linked_Master_CAD_Account__c);
                       
                   }else if(cadByIdOldMap.get(cadObj.Id).Linked_Master_CAD_Account__c != null 
                            && (cadObj.Linked_Master_CAD_Account__c != cadByIdOldMap.get(cadObj.Id).Linked_Master_CAD_Account__c
                                || cadObj.Account_Balance__c != cadByIdOldMap.get(cadObj.Id).Account_Balance__c)){
                                    
                                    masterCadIdToUpdate.add(cadByIdOldMap.get(cadObj.Id).Linked_Master_CAD_Account__c);
                                    
                                }
            
            if(cadObj.CAD_Linked_Master_CAD__c && cadObj.CAD_Linked_Master_CAD__c 
               && cadObj.Account_Balance__c != cadByIdOldMap.get(cadObj.Id).Account_Balance__c){
                   
                   masterCadIdToUpdate.add(cadObj.id);
               }
            
        }
        
        if(!masterCadIdToUpdate.isEmpty() && checkRecursive.runOnce()){
            
            updateAmountOnMaster(masterCadIdToUpdate);
        }
        
    }
    
    public static void afterDeleteConsumerAccountDetail(List<Consumer_Account_Details__c> oldCadList){
        
        
        Set<Id> masterCadIdToUpdate = new Set<Id>(); 
        
        for(Consumer_Account_Details__c cadObj : oldCadList){
            
            if(cadObj.Linked_Master_CAD_Account__c != null){
                
                masterCadIdToUpdate.add(cadObj.Linked_Master_CAD_Account__c);
                
            }
        }
        
        if(!masterCadIdToUpdate.isEmpty() && checkRecursive.runOnce()){
            
            updateAmountOnMaster(masterCadIdToUpdate);
        }
    }
    
    @future
    private static void updateAmountOnMaster(Set<Id> masterCadIds){
        
        List<Consumer_Account_Details__c> masterConsumerAccountDetailList = [SELECT Id, Name, Account_Balance__c, Linked_Master_CAD_Account__c, 
                                                                             CAD_Linked_Account_Balance__c,
                                                                             (SELECT ID, Name, Account_Balance__c FROM Consumer_Account_Details__r)  
                                                                             FROM Consumer_Account_Details__c WHERE Id IN :masterCadIds];
        
        for(Consumer_Account_Details__c masterCadObj : masterConsumerAccountDetailList){
            
            Decimal totalLinkedBalance = 0.00;
            
            if(masterCadObj.Account_Balance__c != null){
                totalLinkedBalance += masterCadObj.Account_Balance__c;
            }
            
            for(Consumer_Account_Details__c childCadObj : masterCadObj.Consumer_Account_Details__r){
                
                if(childCadObj.Account_Balance__c != null){
                    
                    totalLinkedBalance += childCadObj.Account_Balance__c; 
                }
            }
            
            masterCadObj.CAD_Linked_Account_Balance__c = totalLinkedBalance;    
        }
        
        update masterConsumerAccountDetailList;
    }
    
    private static void addErrorIfMasterExists(Set<Consumer_Account_Details__c> consumerAccountDetailList){
        
        system.debug('eneterd in the addErrorIfMasterExists method');
        
        Set<Date> placementDateSet = new Set<Date>();
        Set<Id> masterFileSet = new Set<Id>();
        
        Map<Id, Map<Date, List<Consumer_Account_Details__c>>> existingMasterCadsByPlacementDateByCmf = new Map<Id, Map<Date, List<Consumer_Account_Details__c>>>(); 
        
        for(Consumer_Account_Details__c consumerAccountDetailObj : consumerAccountDetailList){
            
            placementDateSet.add(consumerAccountDetailObj.Placement_Date__c);
            
            masterFileSet.add(consumerAccountDetailObj.Consumer_Master_File_Record__c);
            
        }
        
        List<Consumer_Account_Details__c> existingMasters = [SELECT Id, RecordTypeId, Name, Consumer_Master_File_Record__c, Organization_name__c, 
                                                             CAD_Credit_Card__c, CAD_Consumer_Loan__c, CAD_Linked_Account__c, 
                                                             CAD_Linked_Master_CAD__c, Placement_Date__c, CAD_Linked_Account_Balance__c, 
                                                             Linked_Master_CAD_Account__c  
                                                             FROM Consumer_Account_Details__c 
                                                             WHERE Placement_Date__c IN :placementDateSet
                                                             AND Consumer_Master_File_Record__c IN :masterFileSet
                                                             AND CAD_Linked_Master_CAD__c = true];
        
        
        for(Consumer_Account_Details__c consumerAccountDetailObj : existingMasters){
            
            if(existingMasterCadsByPlacementDateByCmf.containsKey(consumerAccountDetailObj.Consumer_Master_File_Record__c)){
                
                Map<Date, List<Consumer_Account_Details__c>> temp = existingMasterCadsByPlacementDateByCmf.get(consumerAccountDetailObj.Consumer_Master_File_Record__c);
                
                if(temp.containsKey(consumerAccountDetailObj.Placement_Date__c)){
                    
                    List<Consumer_Account_Details__c> cadTempList = temp.get(consumerAccountDetailObj.Placement_Date__c);
                    
                    cadTempList.add(consumerAccountDetailObj);
                    
                    temp.put(consumerAccountDetailObj.Placement_Date__c, cadTempList);
                    
                }else{
                    
                    temp.put(consumerAccountDetailObj.Placement_Date__c, new List<Consumer_Account_Details__c> {consumerAccountDetailObj});
                }
                
                existingMasterCadsByPlacementDateByCmf.put(consumerAccountDetailObj.Consumer_Master_File_Record__c, temp);
                
            }else{
                
                existingMasterCadsByPlacementDateByCmf.put(consumerAccountDetailObj.Consumer_Master_File_Record__c, new Map<Date, List<Consumer_Account_Details__c>> {consumerAccountDetailObj.Placement_Date__c => new List<Consumer_Account_Details__c> {consumerAccountDetailObj}});
            }
        }
        
        Id linkedRecordTypeId = Schema.SObjectType.Consumer_Account_Details__c.getRecordTypeInfosByName().get('CAD: MCM Linked Account Details').getRecordTypeId(); 
        
        for(Consumer_Account_Details__c consumerAccountDetailObj : consumerAccountDetailList){
            
            if(consumerAccountDetailObj.Linked_Master_CAD_Account__c != null && consumerAccountDetailObj.recordTypeId == linkedRecordTypeId){
                consumerAccountDetailObj.addError('Cannot create two master\'s in same Linked group.');     
                
            }else if( existingMasterCadsByPlacementDateByCmf.containsKey(consumerAccountDetailObj.Consumer_Master_File_Record__c)){
                
                Map<Date, List<Consumer_Account_Details__c>> existingPlacementDateByMasterCadMap = existingMasterCadsByPlacementDateByCmf.get(consumerAccountDetailObj.Consumer_Master_File_Record__c);
                
                if(existingPlacementDateByMasterCadMap != null && existingPlacementDateByMasterCadMap.containsKey(consumerAccountDetailObj.Placement_Date__c)){
                    
                    List<Consumer_Account_Details__c> existingMasterCads = existingPlacementDateByMasterCadMap.get(consumerAccountDetailObj.Placement_Date__c); 
                    
                    for(Consumer_Account_Details__c consumerMasterCadExisting : existingMasterCads){
                        
                        if(consumerMasterCadExisting.Organization_name__c == consumerAccountDetailObj.Organization_name__c 
                           && ( consumerAccountDetailObj.CAD_Credit_Card__c == consumerMasterCadExisting.CAD_Credit_Card__c 
                               || consumerAccountDetailObj.CAD_Consumer_Loan__c == consumerMasterCadExisting.CAD_Consumer_Loan__c )){
                                   
                                   consumerAccountDetailObj.addError(consumerMasterCadExisting.name +' already exists as the master CAD for this consumer having the same placement date and account type (Credit Card/Consumer Loan).');
                                   
                               }
                    }
                }       
            }
            
        }       
    }
}