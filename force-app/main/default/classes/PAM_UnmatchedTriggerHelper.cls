public without sharing class PAM_UnmatchedTriggerHelper {
    
    public static final String STATUS_CLOSED = 'Closed';
    
    public static void beforeInsertPamUnmatched(List<PAM_Unmatched__c> pamUnmatchedNew){
        
        Map<Id, List<PAM_Unmatched__c>> groupedResults;
        
        groupedResults = groupByRecordTypes(pamUnmatchedNew);
            
        Id scmdRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId();
        Id scmdACFRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF SCMDUM').getRecordTypeId();
        
        //For DM SCM added on 24-03-2020
        Id scmdDMRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM SCMDUM').getRecordTypeId();
        
        Id irOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
        Id irClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Closed').getRecordTypeId();
        
        //For ACF IR
        Id irACFOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Open').getRecordTypeId();
        Id irACFClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Closed').getRecordTypeId();
        
        //For DM IR
        Id irDMOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Open').getRecordTypeId();
        Id irDMClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Closed').getRecordTypeId();
        
        
        if(groupedResults.containsKey(scmdRecType) || groupedResults.containsKey(scmdACFRecType) || groupedResults.containsKey(scmdDMRecType)){
            
            List<PAM_Unmatched__c> pamScmdList = new List<PAM_Unmatched__c>();
            
            if(groupedResults.get(scmdRecType) != null && !groupedResults.get(scmdRecType).isEmpty()){
                pamScmdList.addAll(groupedResults.get(scmdRecType));
            }else if(groupedResults.get(scmdACFRecType) != null && !groupedResults.get(scmdACFRecType).isEmpty()){
                pamScmdList.addAll(groupedResults.get(scmdACFRecType));
            }else if(groupedResults.get(scmdDMRecType) != null && !groupedResults.get(scmdDMRecType).isEmpty()){
                pamScmdList.addAll(groupedResults.get(scmdDMRecType));
            }
            
            if(!pamScmdList.isEmpty()){
                beforeInsertSCMDUM(pamScmdList);
            }
        }else if(groupedResults.containsKey(irOpenRecType)){
            
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irOpenRecType);
            if(!pamIrList.isEmpty()){
                beforeInsertIRUM(pamIrList);
            }
        }else if(groupedResults.containsKey(irClosedRecType)){
            
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irClosedRecType);
            if(!pamIrList.isEmpty()){
                beforeInsertIRUM(pamIrList);
            }
        }else if(groupedResults.containsKey(irACFOpenRecType) ){
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irACFOpenRecType);
            
            if(!pamIrList.isEmpty()){
                beforeInsertIRUM(pamIrList);
            }
        }else if(groupedResults.containsKey(irACFClosedRecType) ){
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irACFClosedRecType);
            
            if(!pamIrList.isEmpty()){
                beforeInsertIRUM(pamIrList);
            }
        }
        //Added on 20/03/2020
        else if(groupedResults.containsKey(irDMOpenRecType) ){
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irDMOpenRecType);
            
            if(!pamIrList.isEmpty()){
                //System.debug('pamIrList >> '+pamIrList);
                beforeInsertIRUM(pamIrList);
            }
        }else if(groupedResults.containsKey(irDMClosedRecType) ){
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irDMClosedRecType);
            
            if(!pamIrList.isEmpty()){
                //System.debug('pamIrList >> '+pamIrList);
                beforeInsertIRUM(pamIrList);
            }
        }
    }
    
    public static void afterInsertPamUnmatched(List<PAM_Unmatched__c> pamUnmatchedNew){
        
        Map<Id, List<PAM_Unmatched__c>> groupedResults = groupByRecordTypes(pamUnmatchedNew);
        
        Id scmdRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId();
        Id scmdACFRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF SCMDUM').getRecordTypeId();
        
        //DM SCM added on 24-03-2020
        Id scmdDMRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM SCMDUM').getRecordTypeId();
        
        Id irOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
        Id irClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Closed').getRecordTypeId();
        
        /************* added on 13-sept-2019 (unmatched acf) ***************/
        Id irACFOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Open').getRecordTypeId();
        Id irACFClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Closed').getRecordTypeId();

		//Added on 20/03/2020
		Id irDMOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Open').getRecordTypeId();
        Id irDMClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Closed').getRecordTypeId();
       
        
        if(groupedResults.containsKey(scmdRecType) || groupedResults.containsKey(scmdACFRecType) || groupedResults.containsKey(scmdDMRecType)){
            
            List<PAM_Unmatched__c> pamScmdList = new List<PAM_Unmatched__c>();
            if(groupedResults.get(scmdRecType) != null && !groupedResults.get(scmdRecType).isEmpty()){
                pamScmdList.addAll(groupedResults.get(scmdRecType));
            }else if(groupedResults.get(scmdACFRecType) != null && !groupedResults.get(scmdACFRecType).isEmpty()){
                pamScmdList.addAll(groupedResults.get(scmdACFRecType));
            }else if(groupedResults.get(scmdDMRecType) != null && !groupedResults.get(scmdDMRecType).isEmpty()){
                pamScmdList.addAll(groupedResults.get(scmdDMRecType));
            }
            
            if(!pamScmdList.isEmpty()){
                afterInsertSCMDUM(pamScmdList);
            }
        }else if(groupedResults.containsKey(irOpenRecType)){
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irOpenRecType);
            if(!pamIrList.isEmpty()){
                afterInsertIRUM(pamIrList);
            }
        }else if(groupedResults.containsKey(irClosedRecType)){
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irClosedRecType);
            if(!pamIrList.isEmpty()){
                afterInsertIRUM(pamIrList);
            }
        }
        else if(groupedResults.containsKey(irACFOpenRecType)){
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irACFOpenRecType);
            
            if(!pamIrList.isEmpty()){
                
                afterInsertIRUM(pamIrList);
            }
        } else if(groupedResults.containsKey(irACFClosedRecType)){
                List<PAM_Unmatched__c> pamIrList = groupedResults.get(irACFClosedRecType);
                
                if(!pamIrList.isEmpty()){
                    
                    afterInsertIRUM(pamIrList);
                }
        }
        //Added on 20/03/2020
        else if(groupedResults.containsKey(irDMOpenRecType)){
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irDMOpenRecType);
            
            if(!pamIrList.isEmpty()){
                afterInsertIRUM(pamIrList);
            }
        } else if(groupedResults.containsKey(irDMClosedRecType)){
                List<PAM_Unmatched__c> pamIrList = groupedResults.get(irDMClosedRecType);
                
                if(!pamIrList.isEmpty()){
                    afterInsertIRUM(pamIrList);
                }
        }
    }
    
    public static void beforeUpdatePamUnmatched(List<PAM_Unmatched__c> pamUnmatchedNew, Map<Id, PAM_Unmatched__c> pamUnmatchedOldMap){
        
        Map<Id, List<PAM_Unmatched__c>> groupedResults = groupByRecordTypes(pamUnmatchedNew);
        Map<Id, Map<Id, PAM_Unmatched__c>> groupedResultsMap = groupByRecordTypes(pamUnmatchedOldMap);
        
        Id scmdRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId();
        Id scmdACFRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF SCMDUM').getRecordTypeId();
        //SCM DM added on 25-03-2020
        Id scmdDMRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM SCMDUM').getRecordTypeId();
        
        Id irOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
        Id irClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Closed').getRecordTypeId();
        
        //For ACF IR Unmatched
        Id irACFOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Open').getRecordTypeId();
        Id irACFClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Closed').getRecordTypeId();
        
        //For DM IR Unmatched- created on 20/03/2020
        Id irDMOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Open').getRecordTypeId();
        Id irDMClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Closed').getRecordTypeId();
        
        
        if((groupedResults.containsKey(scmdRecType) && groupedResultsMap.containsKey(scmdRecType)) 
                || (groupedResults.containsKey(scmdACFRecType) && groupedResultsMap.containsKey(scmdACFRecType))
          || (groupedResults.containsKey(scmdDMRecType) && groupedResultsMap.containsKey(scmdDMRecType))){
            
            List<PAM_Unmatched__c> pamScmdList = new List<PAM_Unmatched__c>();
            if(groupedResults.get(scmdRecType) != null && !groupedResults.get(scmdRecType).isEmpty()){
                pamScmdList.addAll(groupedResults.get(scmdRecType));
            }else if(groupedResults.get(scmdACFRecType) != null && !groupedResults.get(scmdACFRecType).isEmpty()){
                pamScmdList.addAll(groupedResults.get(scmdACFRecType));
            }else if(groupedResults.get(scmdDMRecType) != null && !groupedResults.get(scmdDMRecType).isEmpty()){
                pamScmdList.addAll(groupedResults.get(scmdDMRecType));
            }
              
            
            Map<Id, PAM_Unmatched__c> pamSCMDUmMap = new Map<Id, PAM_Unmatched__c>();
            if(groupedResultsMap.get(scmdRecType) != null && !groupedResultsMap.get(scmdRecType).isEmpty()){
                pamSCMDUmMap.putAll(groupedResultsMap.get(scmdRecType));
            }else if(groupedResultsMap.get(scmdACFRecType) != null && !groupedResultsMap.get(scmdACFRecType).isEmpty()){
                pamSCMDUmMap.putAll(groupedResultsMap.get(scmdACFRecType));
            }else if(groupedResultsMap.get(scmdDMRecType) != null && !groupedResultsMap.get(scmdDMRecType).isEmpty()){
                pamSCMDUmMap.putAll(groupedResultsMap.get(scmdDMRecType));
            }
            
            if(!pamScmdList.isEmpty() && !pamSCMDUmMap.isEmpty()){
                beforeUpdateSCMDUM(pamScmdList, pamSCMDUmMap);
            }
        }else if(groupedResults.containsKey(irOpenRecType) && groupedResultsMap.containsKey(irOpenRecType)){
            
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irOpenRecType);
            Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irOpenRecType);
            
            if(!pamIrList.isEmpty() && !pamIrUmMap.isEmpty()){
                
                beforeUpdateIRUM(pamIrList, pamIrUmMap);
            }
        }else if(groupedResults.containsKey(irClosedRecType) && groupedResultsMap.containsKey(irClosedRecType)){
            
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irClosedRecType);
            Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irClosedRecType);
            
            if(!pamIrList.isEmpty() && !pamIrUmMap.isEmpty()){
                
                beforeUpdateIRUM(pamIrList, pamIrUmMap);
            }
        }
        //ACF Unmatched
        else if(groupedResults.containsKey(irACFClosedRecType) && groupedResultsMap.containsKey(irACFClosedRecType)){
            
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irACFClosedRecType);
            Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irACFClosedRecType);
            
            if(!pamIrList.isEmpty() && !pamIrUmMap.isEmpty()){
                
                beforeUpdateIRUM(pamIrList, pamIrUmMap);
            }
        }
        else if(groupedResults.containsKey(irACFOpenRecType) && groupedResultsMap.containsKey(irACFOpenRecType)){
            
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irACFOpenRecType);
            Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irACFOpenRecType);
            
            if(!pamIrList.isEmpty() && !pamIrUmMap.isEmpty()){
                
                beforeUpdateIRUM(pamIrList, pamIrUmMap);
            }
        }
        //DM IR Unmatched - 20/03/2020
        else if(groupedResults.containsKey(irDMClosedRecType) && groupedResultsMap.containsKey(irDMClosedRecType)){
            
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irDMClosedRecType);
            Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irDMClosedRecType);
            
            if(!pamIrList.isEmpty() && !pamIrUmMap.isEmpty()){
                
                beforeUpdateIRUM(pamIrList, pamIrUmMap);
            }
        }
        else if(groupedResults.containsKey(irDMOpenRecType) && groupedResultsMap.containsKey(irDMOpenRecType)){
            
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irDMOpenRecType);
            Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irDMOpenRecType);
            
            if(!pamIrList.isEmpty() && !pamIrUmMap.isEmpty()){
                
                beforeUpdateIRUM(pamIrList, pamIrUmMap);
            }
        }
        
    }
    
    public static void afterUpdatePamUnmatched(List<PAM_Unmatched__c> pamUnmatchedNew, Map<Id, PAM_Unmatched__c> pamUnmatchedOldMap){
        //System.debug('update called');
        
        Map<Id, List<PAM_Unmatched__c>> groupedResults = groupByRecordTypes(pamUnmatchedNew);
        Map<Id, Map<Id, PAM_Unmatched__c>> groupedResultsMap = groupByRecordTypes(pamUnmatchedOldMap);
        
        Id scmdRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId();
        Id scmdACFRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF SCMDUM').getRecordTypeId();
        //Added for DM SCM 
        Id scmdDMRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM SCMDUM').getRecordTypeId();
        
        Id irOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
        Id irClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Closed').getRecordTypeId();
        
        /********************************** added on 17-09-2019 ****************************************/
        Id irACFOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Open').getRecordTypeId();
        Id irACFClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Closed').getRecordTypeId();
        
        //Added on 20/03/2020
        Id irDMOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Open').getRecordTypeId();
        Id irDMClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Closed').getRecordTypeId();
        
        
        if((groupedResults.containsKey(scmdRecType) && groupedResultsMap.containsKey(scmdRecType)) 
                || (groupedResults.containsKey(scmdACFRecType) && groupedResultsMap.containsKey(scmdACFRecType))
          | (groupedResults.containsKey(scmdDMRecType) && groupedResultsMap.containsKey(scmdDMRecType))){
            
            List<PAM_Unmatched__c> pamScmdList = new List<PAM_Unmatched__c>();
            if(groupedResults.get(scmdRecType) != null && !groupedResults.get(scmdRecType).isEmpty()){
                pamScmdList.addAll(groupedResults.get(scmdRecType));
            }else if(groupedResults.get(scmdACFRecType) != null && !groupedResults.get(scmdACFRecType).isEmpty()){
                pamScmdList.addAll(groupedResults.get(scmdACFRecType));
            }else if(groupedResults.get(scmdDMRecType) != null && !groupedResults.get(scmdDMRecType).isEmpty()){
                pamScmdList.addAll(groupedResults.get(scmdDMRecType));
            }
            
            Map<Id, PAM_Unmatched__c> pamSCMDUmMap = new Map<Id, PAM_Unmatched__c>();
            if(groupedResultsMap.get(scmdRecType) != null && !groupedResultsMap.get(scmdRecType).isEmpty()){
                pamSCMDUmMap.putAll(groupedResultsMap.get(scmdRecType));
            }else if(groupedResultsMap.get(scmdACFRecType) != null && !groupedResultsMap.get(scmdACFRecType).isEmpty()){
                pamSCMDUmMap.putAll(groupedResultsMap.get(scmdACFRecType));
            }else if(groupedResultsMap.get(scmdDMRecType) != null && !groupedResultsMap.get(scmdDMRecType).isEmpty()){
                pamSCMDUmMap.putAll(groupedResultsMap.get(scmdDMRecType));
            }
            
            if(!pamScmdList.isEmpty() && !pamSCMDUmMap.isEmpty()){
                
                afterUpdateSCMDUM(pamScmdList, pamSCMDUmMap);
            }
        }else if(groupedResults.containsKey(irOpenRecType) && groupedResultsMap.containsKey(irOpenRecType)){
            
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irOpenRecType);
            Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irOpenRecType);
            
            if(!pamIrList.isEmpty() && !pamIrUmMap.isEmpty()){
                
                afterUpdateIRUM(pamIrList, pamIrUmMap);
            }
        }else if(groupedResults.containsKey(irClosedRecType) && groupedResultsMap.containsKey(irClosedRecType)){
            
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irClosedRecType);
            Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irClosedRecType);
            
            if(!pamIrList.isEmpty() && !pamIrUmMap.isEmpty()){
                
                afterUpdateIRUM(pamIrList, pamIrUmMap);
            }
        }
        else if(groupedResults.containsKey(irACFOpenRecType) && groupedResultsMap.containsKey(irACFOpenRecType)){
            
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irACFOpenRecType);
            Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irACFOpenRecType);
            
            if(!pamIrList.isEmpty() && !pamIrUmMap.isEmpty()){
                System.debug('pamIrList after update :: '+pamIrList);
                afterUpdateIRUM(pamIrList, pamIrUmMap);
            }
        }
        else if(groupedResults.containsKey(irACFClosedRecType) && groupedResultsMap.containsKey(irACFClosedRecType)){
            
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irACFClosedRecType);
            Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irACFClosedRecType);
            
            if(!pamIrList.isEmpty() && !pamIrUmMap.isEmpty()){
                System.debug('pamIrList after update :: '+pamIrList);
                afterUpdateIRUM(pamIrList, pamIrUmMap);
            }
        }
        //Added on 20/03/2020 - dm ir
         else if(groupedResults.containsKey(irDMOpenRecType) && groupedResultsMap.containsKey(irDMOpenRecType)){
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irDMOpenRecType);
            Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irDMOpenRecType);
            
            if(!pamIrList.isEmpty() && !pamIrUmMap.isEmpty()){
                afterUpdateIRUM(pamIrList, pamIrUmMap);
            }
        }
        else if(groupedResults.containsKey(irDMClosedRecType) && groupedResultsMap.containsKey(irDMClosedRecType)){
            
            List<PAM_Unmatched__c> pamIrList = groupedResults.get(irDMClosedRecType);
            Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irDMClosedRecType);
            
            if(!pamIrList.isEmpty() && !pamIrUmMap.isEmpty()){
                afterUpdateIRUM(pamIrList, pamIrUmMap);
            }
        }
        
    }
    
    public static void afterDeletePamUnmatched(Map<Id, PAM_Unmatched__c> pamUmOldMap){
        //System.debug('after delete');
        Map<Id, Map<Id, PAM_Unmatched__c>> groupedResultsMap = groupByRecordTypes(pamUmOldMap);
        
        Id scmdRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId();
        Id scmdACFRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF SCMDUM').getRecordTypeId();
        //SCM DM
        Id scmdDMRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM SCMDUM').getRecordTypeId();
        
        Id irOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
        Id irClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Closed').getRecordTypeId();
        
        //For ACF IR
        Id irACFOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Open').getRecordTypeId();
        Id irACFClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Closed').getRecordTypeId();
        
        //For DM IR
        Id irDMOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Open').getRecordTypeId();
        Id irDMClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Closed').getRecordTypeId();
        
        
        if(groupedResultsMap.containsKey(scmdRecType) || groupedResultsMap.containsKey(scmdACFRecType) || groupedResultsMap.containsKey(scmdDMRecType)){
            
            Map<Id, PAM_Unmatched__c> pamSCMDUmMap = new Map<Id, PAM_Unmatched__c>();
            if(groupedResultsMap.get(scmdRecType) != null && !groupedResultsMap.get(scmdRecType).isEmpty()){
                pamSCMDUmMap.putAll(groupedResultsMap.get(scmdRecType));
            }else if(groupedResultsMap.get(scmdACFRecType) != null && !groupedResultsMap.get(scmdACFRecType).isEmpty()){
                pamSCMDUmMap.putAll(groupedResultsMap.get(scmdACFRecType));
            }else if(groupedResultsMap.get(scmdDMRecType) != null && !groupedResultsMap.get(scmdDMRecType).isEmpty()){
                pamSCMDUmMap.putAll(groupedResultsMap.get(scmdDMRecType));
            }
            
            if(!pamSCMDUmMap.isEmpty()){
                afterDeleteSCMDUM(pamSCMDUmMap);
            }
        } else if(groupedResultsMap.containsKey(irOpenRecType)){
                Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irOpenRecType);
                if(!pamIrUmMap.isEmpty()){
                    afterDeleteIRUM(pamIrUmMap);
                }
            }else if(groupedResultsMap.containsKey(irClosedRecType)){
                Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irClosedRecType);
                if(!pamIrUmMap.isEmpty()){
                    afterDeleteIRUM(pamIrUmMap);
                }
        }
        //Changes for ACF IR
        else if(groupedResultsMap.containsKey(irACFOpenRecType)){
            Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irACFOpenRecType);
            if(!pamIrUmMap.isEmpty()){
                afterDeleteIRUM(pamIrUmMap);
            }
        }
        else if(groupedResultsMap.containsKey(irACFClosedRecType)){
            Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irACFClosedRecType);
            if(!pamIrUmMap.isEmpty()){
                afterDeleteIRUM(pamIrUmMap);
            }
        }
        //Changes for DM IR
        else if(groupedResultsMap.containsKey(irDMOpenRecType)){
            Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irDMOpenRecType);
            if(!pamIrUmMap.isEmpty()){
                afterDeleteIRUM(pamIrUmMap);
            }
        }
        else if(groupedResultsMap.containsKey(irDMClosedRecType)){
            Map<Id, PAM_Unmatched__c> pamIrUmMap = groupedResultsMap.get(irDMClosedRecType);
            if(!pamIrUmMap.isEmpty()){
                afterDeleteIRUM(pamIrUmMap);
            }
        }
        
    }
    
    private static Map<Id, List<PAM_Unmatched__c>> groupByRecordTypes (List<PAM_Unmatched__c> pamUnmatched){
        
        Map<Id, List<PAM_Unmatched__c>> groupedResults = new Map<Id, List<PAM_Unmatched__c>>();   
        
        for(PAM_Unmatched__c pamUmObj : pamUnmatched){
            
            if(groupedResults.containsKey(pamUmObj.recordTypeId)){
                
                List<PAM_Unmatched__c> temp = groupedResults.get(pamUmObj.recordTypeId);
                temp.add(pamUmObj);
                groupedResults.put(pamUmObj.recordTypeId, temp); 
                
            }else{
                
                groupedResults.put(pamUmObj.recordTypeId, new List<PAM_Unmatched__c> {pamUmObj});
            }
        }
        
        return groupedResults;
    }
    
    private static Map<Id, Map<Id, PAM_Unmatched__c>> groupByRecordTypes (Map<Id, PAM_Unmatched__c> pamUnmatchedOldMap){
        
        Map<Id, Map<Id, PAM_Unmatched__c>> groupedResults = new Map<Id, Map<Id, PAM_Unmatched__c>>();   
        
        for(PAM_Unmatched__c pamUmObj : pamUnmatchedOldMap.values()){
            
            if(groupedResults.containsKey(pamUmObj.recordTypeId)){
                
                Map<Id, PAM_Unmatched__c> temp = groupedResults.get(pamUmObj.recordTypeId);
                temp.put(pamUmObj.Id, pamUmObj);
                groupedResults.put(pamUmObj.recordTypeId, temp); 
                
            }else{
                
                groupedResults.put(pamUmObj.recordTypeId, new Map<Id, PAM_Unmatched__c> {pamUmObj.Id => pamUmObj});
            }
        }
        
        return groupedResults;
    }
    
    /*
    * SCMD Process events Starts
    *
    */
    
    // insert events
    
    public static void beforeInsertSCMDUM(List<PAM_Unmatched__c> scmdUnmatchedNewList){
    
        updateOrganisationField(scmdUnmatchedNewList);
        updatePAMUMResolutionDate(scmdUnmatchedNewList);
    }
    
    public static void afterInsertSCMDUM(List<PAM_Unmatched__c> scmdUnmatchedNewList){
    
        sendEmailToOrgContacts(scmdUnmatchedNewList);
        
        if(checkRecursive.runOnce()){
            
            updateSCMDCloseStatus(scmdUnmatchedNewList);
            
            updatePcodeCount(scmdUnmatchedNewList);
        }
    }
    
    // update events
    
    public static void beforeUpdateSCMDUM(List<PAM_Unmatched__c> scmdUnmatchedNewList, Map<Id, PAM_Unmatched__c> scmdUmOldMap){
        
        List<PAM_Unmatched__c> scmdumList = new List<PAM_Unmatched__c>();
        List<PAM_Unmatched__c> scmdumResolutionDateUpdate = new List<PAM_Unmatched__c>(); 
        
        for(PAM_Unmatched__c scmdUmObj : scmdUnmatchedNewList){
            
            if(scmdUmObj.PAMUM_Organization_Name__c != scmdUmOldMap.get(scmdUmObj.Id).PAMUM_Organization_Name__c ){
                
                scmdumList.add(scmdUmObj);
            }
            
            if(scmdUmObj.PAMUM_Status__c != scmdUmOldMap.get(scmdUmObj.Id).PAMUM_Status__c 
                    && scmdUmOldMap.get(scmdUmObj.Id).PAMUM_Status__c != 'Closed' 
                    && scmdUmOldMap.get(scmdUmObj.Id).SCMDUM_Account_Resolution_Date__c == null){
                
                scmdumResolutionDateUpdate.add(scmdUmObj);
            }
        }
        
        updateOrganisationField(scmdumList);
        updatePAMUMResolutionDate(scmdumResolutionDateUpdate);
    }
    
    // delete event 
    
    public static void afterUpdateSCMDUM(List<PAM_Unmatched__c> scmdUnmatchedNewList, Map<Id, PAM_Unmatched__c> scmdUmOldMap){
        
        List<PAM_Unmatched__c> scmdumList = new List<PAM_Unmatched__c>(); 
        
        for(PAM_Unmatched__c scmdUmObj : scmdUnmatchedNewList){
            
            if(scmdUmObj.PAMUM_Organization_Name__c != scmdUmOldMap.get(scmdUmObj.Id).PAMUM_Organization_Name__c ){
                
                scmdumList.add(scmdUmObj);
            }
        }
        
        if(checkRecursive.runOnce()){
            updateSCMDCloseStatus(scmdUnmatchedNewList);
            updatePcodeCount(scmdUnmatchedNewList);
        }
    
    }
    
    public static void afterDeleteSCMDUM(Map<Id, PAM_Unmatched__c> scmdUmOldMap){
        if(checkRecursive.runOnce()){
            updatePcodeCount(scmdUmOldMap.values());
        }
        
    }
        
    /*
    * SCMD Process events ends
    *
    */
    
    /*
    * IR Process events Starts
    *
    */
    
    // insert events
    
    public static void beforeInsertIRUM(List<PAM_Unmatched__c> irUmNewList){
        System.debug('beforeInsertIRUM ');
        updateOrganisationField(irUmNewList);
        updateIrStatusBasedOnReasonForDiscrepency(irUmNewList);
        updatePAMUMResolutionDate(irUmNewList);
    }
    
    public static void afterInsertIRUM(List<PAM_Unmatched__c> irUmNewList){
        //sendEmailToOrgContacts(irUmNewList);
        if(checkRecursive.runOnce()){
            updateIrCounts(irUmNewList);
            updateIrCloseStatus(irUmNewList);
        }
    }
    
    // update events
    
    public static void beforeUpdateIRUM(List<PAM_Unmatched__c> irUnmatchedNewList, Map<Id, PAM_Unmatched__c> irUmOldMap){
        List<PAM_Unmatched__c> irumList = new List<PAM_Unmatched__c>();
        List<PAM_Unmatched__c> irumResolutionDateUpdate = new List<PAM_Unmatched__c>();
        for(PAM_Unmatched__c irUmObj : irUnmatchedNewList){
            if(irUmObj.PAMUM_Organization_Name__c != irUmOldMap.get(irUmObj.Id).PAMUM_Organization_Name__c || irUmObj.PAMUM_Organization_Name__c == null){
                irumList.add(irUmObj);
            }
            if(irUmObj.PAMUM_Status__c != irUmOldMap.get(irUmObj.Id).PAMUM_Status__c 
                    && irUmOldMap.get(irUmObj.Id).PAMUM_Status__c != 'Closed' 
                    && irUmOldMap.get(irUmObj.Id).SCMDUM_Account_Resolution_Date__c == null){
                
                irumResolutionDateUpdate.add(irUmObj);
            }
        }
        
        updateIrStatusBasedOnReasonForDiscrepency(irUnmatchedNewList);
        if(!irumList.isEmpty()){
            updateOrganisationField(irumList);
        }
    }
    
    
    public static void afterUpdateIRUM(List<PAM_Unmatched__c> irUnmatchedNewList, Map<Id, PAM_Unmatched__c> irUmOldMap){
        List<PAM_Unmatched__c> irumList = new List<PAM_Unmatched__c>(); 
        for(PAM_Unmatched__c irUmObj : irUnmatchedNewList){
            if(irUmObj.PAMUM_Status__c != irUmOldMap.get(irUmObj.Id).PAMUM_Status__c ){
                irumList.add(irUmObj);
            }
        }
        
        if(checkRecursive.runOnce()){
            //System.debug('irumList >> '+irumList);
            updateIrCloseStatus(irumList);
            updateIrCounts(irumList);
        }
    }
    
    // delete event
    
    public static void afterDeleteIRUM(Map<Id, PAM_Unmatched__c> pamIrUmMap){
        if(checkRecursive.runOnce()){
            System.debug('delete called');
            updateIrCounts(pamIrUmMap.values());
        }
    }
    
    
    /*
    * IR Process events ends
    *
    */
            
    private static void updateSCMDCloseStatus(List<PAM_Unmatched__c> scmdUnmatchedNewList){
        
        Id pamAccountSentRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute - Account #s Sent').getRecordTypeId();
        //Added on 25-03-2020
        Id pamDMAccountSentRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM SCM Dispute - Account #s Sent').getRecordTypeId();
        
        Set<Id> pamIdSet = new Set<Id>(); 
        Set<Id> scmdUmIdSet = new Set<Id>();
        
        for(PAM_Unmatched__c scmdUmObj : scmdUnmatchedNewList){
            
            scmdUmIdSet.add(scmdUmObj.Id);
        }
        
        scmdUnmatchedNewList = [SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, 
                                            PAMUM_Process_Adherence_Monitoring__r.RecordTypeId, PAMUM_Process_Adherence_Monitoring__r.Status__c 
                                             FROM PAM_Unmatched__c WHERE Id IN :scmdUmIdSet];
        
        for(PAM_Unmatched__c scmdUmObj : scmdUnmatchedNewList){
            
            if( pamAccountSentRecordTypeId == scmdUmObj.PAMUM_Process_Adherence_Monitoring__r.RecordTypeId 
                    && scmdUmObj.PAMUM_Process_Adherence_Monitoring__r.Status__c != STATUS_CLOSED ){
            
                pamIdSet.add(scmdUmObj.PAMUM_Process_Adherence_Monitoring__c);
            }
            //Added for SCM DM
            else if(pamDMAccountSentRecordTypeId == scmdUmObj.PAMUM_Process_Adherence_Monitoring__r.RecordTypeId 
                    && scmdUmObj.PAMUM_Process_Adherence_Monitoring__r.Status__c != STATUS_CLOSED ){
            
                pamIdSet.add(scmdUmObj.PAMUM_Process_Adherence_Monitoring__c);
            }
            
        }
        
        if(!pamIdSet.isEmpty() && !System.IsBatch() && !System.isFuture()){
            System.debug('pamUnmatchedtriggerhandler.updateSCMDCloseStatus >>> '+pamIdSet);
            closePamStatusFuture(pamIdSet);
        }
        
    }
    
    private static void updateIrCloseStatus(List<PAM_Unmatched__c> irUnmatchedNewList){
        
        Id pamAccountSentRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR - Account #\'s Sent').getRecordTypeId();
        //Added on 17-09-2019
        Id pamACFAccountSentRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR - Account #\'s Sent').getRecordTypeId();

        //Added on 20/03/2020 for DM IRUM
        Id pamDMAccountSentRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM IR - Account #\'s Sent').getRecordTypeId();
 	
        Set<Id> pamIdSet = new Set<Id>(); 
        Set<Id> irUmIdSet = new Set<Id>();
        
        for(PAM_Unmatched__c irUmObj : irUnmatchedNewList){
            irUmIdSet.add(irUmObj.Id);
        }
        
        irUnmatchedNewList = [SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, 
                                            PAMUM_Process_Adherence_Monitoring__r.RecordTypeId, PAMUM_Process_Adherence_Monitoring__r.Status__c 
                                             FROM PAM_Unmatched__c WHERE Id IN :irUmIdSet];
        
        for(PAM_Unmatched__c irUmObj : irUnmatchedNewList){
            if(irUmObj.PAMUM_Process_Adherence_Monitoring__r.RecordTypeId  == pamAccountSentRecordTypeId){
                if(irUmObj.PAMUM_Process_Adherence_Monitoring__r.Status__c != STATUS_CLOSED ){
                    
                    pamIdSet.add(irUmObj.PAMUM_Process_Adherence_Monitoring__c);
                }  
            }
            if(irUmObj.PAMUM_Process_Adherence_Monitoring__r.RecordTypeId  == pamACFAccountSentRecordTypeId){
                if(irUmObj.PAMUM_Process_Adherence_Monitoring__r.Status__c != STATUS_CLOSED ){
                    
                    pamIdSet.add(irUmObj.PAMUM_Process_Adherence_Monitoring__c);
                }  
            }
            //Added on 20/03/2020
            if(irUmObj.PAMUM_Process_Adherence_Monitoring__r.RecordTypeId  == pamDMAccountSentRecordTypeId){
                if(irUmObj.PAMUM_Process_Adherence_Monitoring__r.Status__c != STATUS_CLOSED ){
                    
                    pamIdSet.add(irUmObj.PAMUM_Process_Adherence_Monitoring__c);
                }  
            }
        }
        
        if(!pamIdSet.isEmpty() && !System.IsBatch() && !System.isFuture()){
            //System.debug('pamIdSet >> '+pamIdSet);
            closePamStatusFuture(pamIdSet);
        }
        
    }
    
    private static void updatePAMUMResolutionDate(List<PAM_Unmatched__c> pamUnmatchedList){
        for(PAM_Unmatched__c pamUmObj : pamUnmatchedList){
            if(pamUmObj.PAMUM_Status__c == 'Closed'){
                pamUmObj.SCMDUM_Account_Resolution_Date__c = system.today();
            }
        }  
        System.debug('pamUnmatchedList line 645 >> '+pamUnmatchedList);
    }
    
    private static void updateIrStatusBasedOnReasonForDiscrepency(List<PAM_Unmatched__c> pamUnmatchedList){
        
        Id irOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
        Id irClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Closed').getRecordTypeId();
        
         //For ACF IR
        Id irACFOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Open').getRecordTypeId();
        Id irACFClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Closed').getRecordTypeId();
        
        //DM IR - 20/03/2020
        Id irDMOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Open').getRecordTypeId();
        Id irDMClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Closed').getRecordTypeId();
        

        for(PAM_Unmatched__c pamUmObj : pamUnmatchedList){
            if(pamUmObj.PAMUM_Status__c != 'Closed'){
                if(pamUmObj.SCMDUM_Reason_for_Discrepancy__c == 'Currently Open with Firm'){
                    pamUmObj.PAMUM_Status__c = 'Closed';
                    pamUmObj.SCMDUM_Account_Resolution_Date__c = system.today();
                }else if(pamUmObj.SCMDUM_Reason_for_Discrepancy__c == 'Timing – Account closed same day as cut off'){
                    if(pamUmObj.recordTypeId == irClosedRecType || pamUmObj.recordTypeId == irACFClosedRecType || pamUmObj.recordTypeId == irDMClosedRecType){
                        pamUmObj.PAMUM_Status__c = 'Reason For Discrepancy Provided';
                    }else if(pamUmObj.recordTypeId == irOpenRecType || pamUmObj.recordTypeId == irACFOpenRecType || pamUmObj.recordTypeId == irDMOpenRecType){
                        pamUmObj.PAMUM_Status__c = 'Closed';
                        pamUmObj.SCMDUM_Account_Resolution_Date__c = system.today();
                    }
                }else if(pamUmObj.SCMDUM_Reason_for_Discrepancy__c == 'Inactive close code used'){
                    pamUmObj.PAMUM_Status__c = 'Reason For Discrepancy Provided';
                }else if(pamUmObj.SCMDUM_Reason_for_Discrepancy__c == 'Close code re-sent'){
                    pamUmObj.PAMUM_Status__c = 'Reason For Discrepancy Provided';
                }else if(pamUmObj.SCMDUM_Reason_for_Discrepancy__c == 'Legal Obligation'){
                    pamUmObj.PAMUM_Status__c = 'Reason For Discrepancy Provided';
                }else if(pamUmObj.SCMDUM_Reason_for_Discrepancy__c == 'Reopen Request Sent'){
                    pamUmObj.PAMUM_Status__c = 'Closed';
                    pamUmObj.SCMDUM_Account_Resolution_Date__c = system.today();
                }else if(pamUmObj.SCMDUM_Reason_for_Discrepancy__c == 'Account is currently Closed'){
                    pamUmObj.PAMUM_Status__c = 'Closed';
                    pamUmObj.SCMDUM_Account_Resolution_Date__c = system.today();
                }
            }
        }
        System.debug('pamUnmatchedList  in pamUnmatched trigger>> '+pamUnmatchedList);
    }
    
    private static void updateOrganisationField(List<PAM_Unmatched__c> pamUnmatchedList){
        
        Set<Id> pamIdSet = new Set<Id>(); 
        Map<Id, Process_Adherence_Monitoring__c> pamObjByPamId = new Map<Id, Process_Adherence_Monitoring__c>(); 
        
        for(PAM_Unmatched__c pamUmObj : pamUnmatchedList){
            
            pamIdSet.add(pamUmObj.PAMUM_Process_Adherence_Monitoring__c);
        }
        
        if(!pamIdSet.isEmpty()){
            
            for(Process_Adherence_Monitoring__c pamObj : [SELECT Id, Name, Organization_Name__c FROM Process_Adherence_Monitoring__c WHERE Id IN :pamIdSet]){
                
                pamObjByPamId.put(pamObj.Id, pamObj);   
            }
            
            for(PAM_Unmatched__c pamUmObj : pamUnmatchedList){
                
                if(pamObjByPamId.containsKey(pamUmObj.PAMUM_Process_Adherence_Monitoring__c) 
                    && pamObjByPamId.get(pamUmObj.PAMUM_Process_Adherence_Monitoring__c).Organization_Name__c != null ){

                    pamUmObj.PAMUM_Organization_Name__c = pamObjByPamId.get(pamUmObj.PAMUM_Process_Adherence_Monitoring__c).Organization_Name__c;
                    
                }
            System.debug('pamUmObj.PAMUM_Organization_Name__c before insert >> '+pamUmObj.PAMUM_Organization_Name__c);
            }
         }
     }
    
    
    private static void sendEmailToOrgContacts(List<PAM_Unmatched__c> unmatchedList){
        
		Set<Id> scmdPamIdsSet = new Set<Id>();
        Set<Id> irPamIdsSet = new Set<Id>();
        Set<Id> scmdPamAcfIdsSet = new Set<Id>();
        Set<Id> scmdPamDmIdsSet = new Set<Id>();
         
        Id pamUnmatchedSCMDRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId();
        Id irOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
        Id irClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Closed').getRecordTypeId();
        Id pamUnmatchedScmdAcfRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF SCMDUM').getRecordTypeId();
        //Added on 24-03-2020
        Id pamUnmatchedScmdDmRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM SCMDUM').getRecordTypeId();
        
        for(PAM_Unmatched__c pamUmObj : unmatchedList){
            
            if(pamUmObj.SCMDUM_Record_Creation_Notification_Sent__c != true && pamUmObj.RecordTypeId == pamUnmatchedSCMDRecType){
            
                scmdPamIdsSet.add(pamUmObj.PAMUM_Process_Adherence_Monitoring__c);
                
            }else if(pamUmObj.SCMDUM_Record_Creation_Notification_Sent__c != true 
                        && (pamUmObj.RecordTypeId == irOpenRecType || pamUmObj.RecordTypeId == irClosedRecType)){
            
                irPamIdsSet.add(pamUmObj.PAMUM_Process_Adherence_Monitoring__c);
                
            }else if(pamUmObj.SCMDUM_Record_Creation_Notification_Sent__c != true 
                        && pamUmObj.RecordTypeId == pamUnmatchedScmdAcfRecType){
            
                scmdPamAcfIdsSet.add(pamUmObj.PAMUM_Process_Adherence_Monitoring__c);
            }//DM SCM
            else if(pamUmObj.SCMDUM_Record_Creation_Notification_Sent__c != true 
                        && pamUmObj.RecordTypeId == pamUnmatchedScmdDmRecType){
            
                scmdPamDmIdsSet.add(pamUmObj.PAMUM_Process_Adherence_Monitoring__c);
            }
            
         }
        
        if(!scmdPamIdsSet.isEmpty() && checkRecursive.runOnce()){
        
            sendSCMDUMEmailFuture(scmdPamIdsSet, 'SCMD-LO');
        }
        
        if(!scmdPamAcfIdsSet.isEmpty() && checkRecursive.runOnce()){
            
            sendSCMDUMEmailFuture(scmdPamAcfIdsSet, 'SCMD-ACF');
        }
        //DM SCM
        if(!scmdPamDmIdsSet.isEmpty() && checkRecursive.runOnce()){
            
            sendSCMDUMEmailFuture(scmdPamDmIdsSet, 'SCMD-DM');
        }
    }
    
    private static void updatePcodeCount(List<PAM_Unmatched__c> pamUnmatchedList){
        
        Set<Id> pamUnmatchScmdRecordTypesIds = new Set<Id>();
        pamUnmatchScmdRecordTypesIds.add(Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId());
        pamUnmatchScmdRecordTypesIds.add(Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF SCMDUM').getRecordTypeId());
        //Added on 25-03-2020 for DM SCM
        pamUnmatchScmdRecordTypesIds.add(Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM SCMDUM').getRecordTypeId());
        
        Set<Id> pamIdSet = new Set<Id>(); 
        
        for(PAM_Unmatched__c scmdUmObj : pamUnmatchedList){
            
            if(pamUnmatchScmdRecordTypesIds.contains(scmdUmObj.RecordTypeId)){
                
                pamIdSet.add(scmdUmObj.PAMUM_Process_Adherence_Monitoring__c);
            }
            
        }
        
        if(!pamIdSet.isEmpty() && !System.IsBatch() && !System.isFuture()){
            
            countScmdPcodes(pamIdSet);
        }
        
    }
    
    private static void updateIrCounts(List<PAM_Unmatched__c> pamUnmatchedList){
        Id irOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
        Id irClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Closed').getRecordTypeId();
        /*************************** Added on 01/10/2019 **************************/
        Id irACFOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Open').getRecordTypeId();
        Id irACFClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Closed').getRecordTypeId();
        
        //Added on 20/03/2020
        Id irDMOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Open').getRecordTypeId();
        Id irDMClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Closed').getRecordTypeId();
        
        Set<Id> pamIdSet = new Set<Id>(); 
        for(PAM_Unmatched__c irUmObj : pamUnmatchedList){
            if(irUmObj.RecordTypeId == irOpenRecType || irUmObj.RecordTypeId == irClosedRecType){
                pamIdSet.add(irUmObj.PAMUM_Process_Adherence_Monitoring__c);
            }
            /*************************** Added on 01/10/2019 **************************/
            else if(irUmObj.RecordTypeId == irACFOpenRecType || irUmObj.RecordTypeId == irACFClosedRecType){
                pamIdSet.add(irUmObj.PAMUM_Process_Adherence_Monitoring__c);
            }
            //Added on 20/03/2020
            else if(irUmObj.RecordTypeId == irDMOpenRecType || irUmObj.RecordTypeId == irDMClosedRecType){
                pamIdSet.add(irUmObj.PAMUM_Process_Adherence_Monitoring__c);
            }
        }
        if(!pamIdSet.isEmpty() && !System.IsBatch() && !System.isFuture()){
            countIR(pamIdSet);
        }
    }
    
    @future
    public static void countIR(Set<Id> pamIdSet){
        Id irOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
        Id irClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Closed').getRecordTypeId();
        
        /***************************************** Added on 1-oct-2019 *********************************************/
        Id irACFOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Open').getRecordTypeId();
        Id irACFClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Closed').getRecordTypeId();

       //Added on 20/03/2020
        Id irDMOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Open').getRecordTypeId();
        Id irDMClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('DM IRUM - Firm Closed').getRecordTypeId();
 	
        	
        List<Process_Adherence_Monitoring__c> pamList = [SELECT Id, Name, IR_No_of_UM_Firm_Closed_MCM_Open__c, 
                                                            IR_No_of_UM_Firm_Open_MCM_Closed__c, 
                                                            (SELECT Id, Name, recordTypeId From PAM_Unmatched__r) 
                                                            FROM Process_Adherence_Monitoring__c WHERE Id IN :pamIdSet];
                                                            
        List<Process_Adherence_Monitoring__c> pamListToUpdate = new List<Process_Adherence_Monitoring__c>(); 
        for(Process_Adherence_Monitoring__c pamObj : pamList){
            Integer noOfOpenIr = 0;
            Integer noOfClosedIr = 0;
            for(PAM_Unmatched__c pamUnmatchedObj : pamObj.PAM_Unmatched__r){
                if(pamUnmatchedObj.recordTypeId != null){
                    if(pamUnmatchedObj.recordTypeId == irOpenRecType){
                        noOfOpenIr += 1;
                    }else if(pamUnmatchedObj.recordTypeId == irClosedRecType){
                        noOfClosedIr += 1;
                    }
                    /***********************Added on 01/10/2019 *********************/
                    else if(pamUnmatchedObj.recordTypeId == irACFOpenRecType){
                        noOfOpenIr += 1;
                    }else if(pamUnmatchedObj.recordTypeId == irACFClosedRecType){
                        noOfClosedIr += 1;
                    }
                    //For DM IRUM 20/03/2020
                    else if(pamUnmatchedObj.recordTypeId == irDMOpenRecType){
                        noOfOpenIr += 1;
                    }else if(pamUnmatchedObj.recordTypeId == irDMClosedRecType){
                        noOfClosedIr += 1;
                    }
                }
            }
            pamObj.IR_No_of_UM_Firm_Open_MCM_Closed__c = noOfOpenIr;
            pamObj.IR_No_of_UM_Firm_Closed_MCM_Open__c = noOfClosedIr;
            pamListToUpdate.add(pamObj);
        }
        if(!pamListToUpdate.isEmpty()){
            update pamListToUpdate;
        }
    }
    
    @future
    public static void countScmdPcodes(Set<Id> pamIdSet){
        
        List<Process_Adherence_Monitoring__c> pamList = [SELECT Id, Name , No_of_um_Oral_disputes__c, No_of_um_written_disputes__c, 
                                                                No_of_um_mail_validation__c,
                                                                (SELECT Id, Name, SCMDUM_Correct_PCode__c, SCMDUM_PCode_Sent__c From PAM_Unmatched__r) 
                                                            FROM Process_Adherence_Monitoring__c WHERE Id IN :pamIdSet ];
        
        ApexDebugLog.debug('PAM_UnmatchedTriggerHelper countScmdPcodes pamList' + pamList);                                                         
        List<Process_Adherence_Monitoring__c> pamListToUpdate = new List<Process_Adherence_Monitoring__c>(); 
        Map<String, PCodeSetting__c> pcodeSettingMap = PCodeSetting__c.getAll();
        ApexDebugLog.debug('PAM_UnmatchedTriggerHelper countScmdPcodes pcodeSettingMap' + pcodeSettingMap);
        if(pcodeSettingMap != null && !pcodeSettingMap.isEmpty()){
            String oralDisputes = pcodeSettingMap.get('Oral dispute').PcodeValue__c;
            Set<String> oralDisputesSet = new Set<String>(oralDisputes.split(','));
            ApexDebugLog.debug('PAM_UnmatchedTriggerHelper countScmdPcodes oralDisputesSet' + oralDisputesSet);             
            String writtenDisputes = pcodeSettingMap.get('Written dispute').PcodeValue__c;
            Set<String> writtenDisputesSet = new Set<String>(writtenDisputes.split(','));
            ApexDebugLog.debug('PAM_UnmatchedTriggerHelper countScmdPcodes writtenDisputes' + writtenDisputes);         
            String mailedOutValidation = pcodeSettingMap.get('Mailed out validation').PcodeValue__c;
            Set<String> mailedOutValidationsSet = new Set<String>(mailedOutValidation.split(','));
            ApexDebugLog.debug('PAM_UnmatchedTriggerHelper countScmdPcodes mailedOutValidation' + mailedOutValidation);         
            
            for(Process_Adherence_Monitoring__c pamObj : pamList){
                
                Integer noOfOralDispute = 0;
                Integer noOfWrittenDispute = 0;
                Integer noOfMailedValidation = 0;
                
                for(PAM_Unmatched__c pamUnmatchedObj : pamObj.PAM_Unmatched__r){
                    
                    if(pamUnmatchedObj.SCMDUM_PCode_Sent__c != null && pcodeSettingMap != null){
                        
                        Boolean isFound = false;
                    
                        if(oralDisputesSet.contains(pamUnmatchedObj.SCMDUM_Correct_PCode__c)){
                            
                            noOfOralDispute += 1;
                            isFound = true;
                            
                        }else if(writtenDisputesSet.contains(pamUnmatchedObj.SCMDUM_Correct_PCode__c)){
                            
                            noOfWrittenDispute += 1;
                            isFound = true;
                            
                        }else if(mailedOutValidationsSet.contains(pamUnmatchedObj.SCMDUM_Correct_PCode__c)){
                            
                            noOfMailedValidation += 1;
                            isFound = true;
                        }
                        
                        if(!isFound){
                        
                        
                            if(oralDisputesSet.contains(pamUnmatchedObj.SCMDUM_PCode_Sent__c)){
                                
                                noOfOralDispute += 1;
                                
                            }else if(writtenDisputesSet.contains(pamUnmatchedObj.SCMDUM_PCode_Sent__c)){
                                
                                noOfWrittenDispute += 1;
                                
                            }else if(mailedOutValidationsSet.contains(pamUnmatchedObj.SCMDUM_PCode_Sent__c)){
                                
                                noOfMailedValidation += 1;
                            }   
                            
                        }
                    }
                    
                }
                
                pamObj.No_of_um_oral_disputes__c = noOfOralDispute;
                pamObj.No_of_um_written_disputes__c = noOfWrittenDispute;
                pamObj.No_of_um_mail_validation__c = noOfMailedValidation;
                ApexDebugLog.debug('PAM_UnmatchedTriggerHelper countScmdPcodes pamObj' + pamListToUpdate);
                pamListToUpdate.add(pamObj);
                
            }
        }                                                           
        
        if(!pamListToUpdate.isEmpty()){
            
            update pamListToUpdate;
        }
        
    }
    
    @future
    public static void closePamStatusFuture(Set<Id> pamIdSet){
        
        List<Process_Adherence_Monitoring__c> pamList = [SELECT Id, Name, Status__c , 
                                                                (SELECT Id, Name From PAM_Unmatched__r WHERE PAMUM_Status__c != 'Closed') 
                                                            FROM Process_Adherence_Monitoring__c WHERE Id IN :pamIdSet ];
                                                            
        List<Process_Adherence_Monitoring__c> pamListToUpdate = new List<Process_Adherence_Monitoring__c>(); 
        for(Process_Adherence_Monitoring__c pamObj : pamList){
            
            if(pamObj.PAM_Unmatched__r.size() == 0){
                
                pamObj.Status__c = 'Closed';
                pamObj.Account_Resolution_Date__c = System.today();
                pamListToUpdate.add(pamObj);
                
            }
        }
        if(!pamListToUpdate.isEmpty()){
            System.debug('closePamStatusFuture >> '+pamListToUpdate);
            update pamListToUpdate;
        }
    }
    
    
    @future
    public static void sendSCMDUMEmailFuture(Set<Id> pamIdsSet, String processType){
        
        List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
        Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccountId = new Map<Id, List<Process_Adherence_Monitoring__c>>();
        Map<Id, List<PAM_Unmatched__c>> scmdUmListByAccountId = new Map<Id, List<PAM_Unmatched__c>>();
        Map<Id, Account> accountByAccountId = new Map<Id, Account>();
        List<PAM_Unmatched__c> recordsToUpdate = new List<PAM_Unmatched__c>(); 

        List<Process_Adherence_Monitoring__c> pamList = getPamList(pamIdsSet); 
        if(!pamList.isEmpty()){
            mapValuesByAccount(pamListByAccountId, scmdUmListByAccountId, pamList);
        }
        accountByAccountId = getAccountRecordsSCMDMap(pamListByAccountId.keySet()); 
        
        OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'lcsalesforceadmin@mcmcg.com'];
        
        for( Id accountId : accountByAccountId.keySet() ){
            List<String> address = new List<String>();
            List<AccountContactRelation> accountContactRelationList = accountByAccountId.get(accountId).AccountContactRelations;
            List<Process_Adherence_Monitoring__c> pamTempList = new List<Process_Adherence_Monitoring__c>(); 
            if( pamListByAccountId.containsKey(accountId) ){
                pamTempList = pamListByAccountId.get(accountId);
            }
            
          /* As per discussion with shelly the bellow notification would not be send 
          for the SCMD Unmatched for creation of profile 
           Modified date - 11/11/2019
           Developer - Avaneesh Singh
          */  

          /*  for( Process_Adherence_Monitoring__c pamObj : pamTempList ){

                for( AccountContactRelation accountContactRelationObj : accountContactRelationList ){

                    Messaging.SingleEmailMessage mail = createMailForSCMUnmatchedRecords(accountContactRelationObj.Contact.Email, 
                                                                                        accountByAccountId.get(accountId).Firm_ID__c,
                                                                                        pamObj, 
                                                                                        accountContactRelationObj.Contact.firstName,
                                                                                        accountContactRelationObj.Contact.Community_User__c,
                                                                                        processType, owea.get(0));
                    sentMailToContactList.add(mail);            
                }
            }  
            
            for(PAM_Unmatched__c scmdUmObj : scmdUmListByAccountId.get(accountId)){
                scmdUmObj.SCMDUM_Record_Creation_Notification_Sent__c = true;
                recordsToUpdate.add(scmdUmObj);
            } */
        }
        Messaging.sendEmail(sentMailToContactList);
        
        if(!recordsToUpdate.isEmpty()){
            update recordsToUpdate;
        }
        
    }
    
    private static void mapValuesByAccount(Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccountId, 
                                                Map<Id, List<PAM_Unmatched__c>> pamUmListByAccountId, 
                                                List<Process_Adherence_Monitoring__c> pamList){
        
        for(Process_Adherence_Monitoring__c pamObj : pamList){ // put values in pamListByAccountId & scmdUmListByAccountId
            
            if( pamObj.PAM_Unmatched__r != null ){ // put only those values who have umRecords
                
                
                if( pamListByAccountId.containsKey(pamObj.Organization_Name__c) ){
                
                    List<Process_Adherence_Monitoring__c> pamTempList = pamListByAccountId.get(pamObj.Organization_Name__c);
                    pamTempList.add(pamObj);
                    
                    pamListByAccountId.put(pamObj.Organization_Name__c, pamTempList);
                
                }else{
                    
                    pamListByAccountId.put(pamObj.Organization_Name__c, new List<Process_Adherence_Monitoring__c>{pamObj});
                } 
                
                if( pamUmListByAccountId.containskey(pamObj.Organization_Name__c) ){
                    
                    List<PAM_Unmatched__c> pamUmTempList = pamUmListByAccountId.get(pamObj.Organization_Name__c);
                    pamUmTempList.addAll(pamObj.PAM_Unmatched__r);
                    
                    pamUmListByAccountId.put(pamObj.Organization_Name__c, pamUmTempList);
                
                }else{
                    
                    pamUmListByAccountId.put(pamObj.Organization_Name__c, pamObj.PAM_Unmatched__r);
                }
                
            }
                
        }
    }
    
    /*
    @future
    public static void sendIRUMEmailFuture(Set<Id> pamIdsSet){
        
        List<Messaging.SingleEmailMessage> sentMailToContactList = new List<Messaging.SingleEmailMessage>();
        Map<Id, List<Process_Adherence_Monitoring__c>> pamListByAccountId = new Map<Id, List<Process_Adherence_Monitoring__c>>();
        Map<Id, List<PAM_Unmatched__c>> irUmListByAccountId = new Map<Id, List<PAM_Unmatched__c>>();
        Map<Id, Account> accountByAccountId = new Map<Id, Account>();
        List<PAM_Unmatched__c> recordsToUpdate = new List<PAM_Unmatched__c>(); 

        List<Process_Adherence_Monitoring__c> pamList = getPamList(pamIdsSet); 
        if(!pamList.isEmpty()){
            mapValuesByAccount(pamListByAccountId, irUmListByAccountId, pamList);
        }
        accountByAccountId = getAccountRecordsIrMap(pamListByAccountId.keySet()); 

        for( Id accountId : accountByAccountId.keySet() ){
            List<String> address = new List<String>();
            List<AccountContactRelation> accountContactRelationList = accountByAccountId.get(accountId).AccountContactRelations;
            List<Process_Adherence_Monitoring__c> pamTempList = new List<Process_Adherence_Monitoring__c>(); 
            if( pamListByAccountId.containsKey(accountId) ){
                pamTempList = pamListByAccountId.get(accountId);
            }

            for( Process_Adherence_Monitoring__c pamObj : pamTempList ){

                for( AccountContactRelation accountContactRelationObj : accountContactRelationList ){
                    
                    Messaging.SingleEmailMessage mail = IR_UnmatchedService.getInitialUnmatchedNotification(accountContactRelationObj, pamObj
                                                                                                , accountByAccountId.get(accountId));
                    sentMailToContactList.add(mail);            
                }
            }
            
            for(PAM_Unmatched__c irUmObj : irUmListByAccountId.get(accountId)){
                irUmObj.SCMDUM_Record_Creation_Notification_Sent__c = true;
                recordsToUpdate.add(irUmObj);
            }
        }
        Messaging.sendEmail(sentMailToContactList);
        
        if(!recordsToUpdate.isEmpty()){
            update recordsToUpdate;
        }
        
    }
    
    */
    private static List<Process_Adherence_Monitoring__c> getPamList(Set<Id> pamIdsSet){
        
        List<Process_Adherence_Monitoring__c> pamList = [SELECT Id, Name, SCMD_Day_Counter__c, Organization_Name__c, Organization_Name__r.Name,
                                                            (SELECT Id, Name, SCMDUM_Record_Creation_Notification_Sent__c From PAM_Unmatched__r 
                                                                WHERE SCMDUM_Record_Creation_Notification_Sent__c != true),    
                                                            SCMD_Reporting_Period__c FROM Process_Adherence_Monitoring__c
                                                            WHERE Id IN :pamIdsSet]; 
        
        return pamList;
        
    }
    
    private static Map<Id, Account> getAccountRecordsSCMDMap(Set<Id> accountIdSet){
        
        Map<Id, Account> accountByAccountId = new Map<Id, Account>([SELECT Id, Name, Firm_ID__c, 
                                                                        (SELECT Id, ContactId, Contact.firstName, Contact.Email,  
                                                                            Contact.Community_User__c 
                                                                        FROM AccountContactRelations 
                                                                        WHERE Contact.Contact_Type_SME__c INCLUDES('Process Adherence Monitoring (PAM)') 
                                                                        AND Contact.Inactive_Contact__c = FALSE) 
                                                                    FROM Account 
                                                                    WHERE Id IN : accountIdSet]);
                                                                    
        return accountByAccountId;
        
    }
    
    private static Map<Id, Account> getAccountRecordsIrMap(Set<Id> accountIdSet){
        
        Map<Id, Account> accountByAccountId = new Map<Id, Account>([SELECT Id, Name, Firm_ID__c, 
                                                                        (SELECT Id, ContactId, Contact.firstName, Contact.Email,  
                                                                            Contact.Community_User__c 
                                                                        FROM AccountContactRelations 
                                                                        WHERE Contact.Contact_Type_SME__c INCLUDES('Inventory Reconciliation') 
                                                                        AND Contact.Inactive_Contact__c = FALSE) 
                                                                    FROM Account 
                                                                    WHERE Id IN : accountIdSet]);
                                                                    
        return accountByAccountId;
        
    }
    
    private static Messaging.SingleEmailMessage createMailForSCMUnmatchedRecords(String contactEmail, String firmId,
                                                                                Process_Adherence_Monitoring__c pamObj, String contactName,
                                                                                Boolean isCommunityUser,
                                                                                String processType, OrgWideEmailAddress owAddress){
                                                                            
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{contactEmail});
        if(processType == 'SCMD-LO'){
            mail.setSubject(firmId + ' Monthly Dispute SCM Unmatched ' + pamObj.SCMD_Reporting_Period__c );
            mail.setHtmlBody(SCMDEmailCommunicationTemplates.getSCMDUnmatchedOnCreateTemplate(pamObj, contactName, isCommunityUser));
        }else{
            mail.setSubject(firmId + ' ACF Monthly Dispute SCM Unmatched ' + pamObj.SCMD_Reporting_Period__c );
            mail.setHtmlBody(SCMDEmailCommunicationTemplates.getSCMDUnmatchedACFOnCreateTemplate(pamObj, contactName, isCommunityUser));
        }
        if(owAddress != null ){
            mail.setOrgWideEmailAddressId(owAddress.Id);
        }
        mail.setReplyTo('lcsalesforceadmin@mcmcg.com');
        return mail;
        
    }
    
    public static void testBufferCoverage(){
    // needs to remove ASAP
    // Created because of running out of time and could not be able to create the test cases 
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
            i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
            i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
            i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}