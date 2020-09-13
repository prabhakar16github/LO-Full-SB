/**********************************************************************
 * Class Name  : CM_PreventDuplicateRecordsHelper
 * Description : Helper class for CM_PreventDuplicateRecords trigger which prevents the duplicate record with each 
				 Firm+ Month+year combination. It will work on each insert and update on a record.
 * Created Date: 28-6-2019
 *****************************************************************************/

public class CM_PreventDuplicateRecordsHelper {
    
    /***************Method to Prevent the duplicate Call Monitoring records *********************/
    
    public static void preventDuplicateCMRecords(List<Call_Monitoring__c> triggerNew){
        Set<Id> recordTypeIdSet = new Set<Id>();
        Id cmQARecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId();
        recordTypeIdSet.add(cmQARecordTypeId);
        Id cmLogRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Log').getRecordTypeId();
        recordTypeIdSet.add(cmLogRecordTypeId);
        
        
        Set<Id> firmIdSet = new Set<Id>();
        Map<String,Call_Monitoring__c> uniqueKeyMAP = new Map<String,Call_Monitoring__c>();
        
        for(Call_Monitoring__c cm : triggerNew){
            if(recordTypeIdSet.contains(cm.RecordTypeId)){
                firmIdSet.add(cm.Organization_Name_CM__c);
                String uniqueKey = cm.RecordTypeId+'@@'+cm.Organization_Name_CM__c + '@@' + cm.Reporting_Year_CM__c + '@@' + cm.Reporting_Month_CM__c;
                uniqueKeyMAP.put(uniqueKey, NULL);
            }
        }
        
        if(firmIdSet.size() > 0 && uniqueKeyMAP.keySet().size() > 0){
            for(Call_Monitoring__c cm : [SELECT Id,Organization_Name_CM__c,Reporting_Year_CM__c,Reporting_Month_CM__c,
                                         RecordTypeId
                                         FROM Call_Monitoring__c
                                         WHERE recordTypeId IN :recordTypeIdSet
                                         AND Organization_Name_CM__c != NULL
                                         AND Reporting_Year_CM__c != NULL
                                         AND Reporting_Month_CM__c != NULL
                                         AND Organization_Name_CM__c IN :firmIdSet
                                         AND Id NOT IN :triggerNew]){
                                             
                                             String uniqueKey = cm.RecordTypeId+'@@'+cm.Organization_Name_CM__c + '@@' + cm.Reporting_Year_CM__c + '@@' + cm.Reporting_Month_CM__c;
                                             if(uniqueKeyMAP.containsKey(uniqueKey)){
                                                 uniqueKeyMAP.put(uniqueKey,cm);
                                             }
                                         }
            for(Call_Monitoring__c cm : triggerNew){
                String uniqueKey = cm.RecordTypeId+'@@'+cm.Organization_Name_CM__c + '@@' + cm.Reporting_Year_CM__c + '@@' + cm.Reporting_Month_CM__c;
                if(uniqueKeyMAP.containsKey(uniqueKey) && uniqueKeyMAP.get(uniqueKey) != NULL){
                    cm.addError('Only one record can be created for each month/year combination related to this Organization.');
                }
            }
        }
    }
}