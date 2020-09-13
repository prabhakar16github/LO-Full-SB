/*
##############################################################################################################################################
# Project Name..........: LO - Call Monitoring  
# File..................: Class : "Utility" Trigger: CM_PreventDuplicateRecords 
# Version...............: 1.0
# Created by............: Sunny Kumar   
# Created Date..........: 02-Mar-2016  
# Last Modified by......: Prabhakar Joshi
# Last Modified Date....: 27-June-2019                         
# Description...........: This trigger restrict users from creating any duplicate record with each 
Firm+ Month+year combination. It will work on each insert and update on a record
##############################################################################################################################################
*/

trigger CM_PreventDuplicateRecords on Call_Monitoring__c (before insert,before Update) {
    
    List<Call_Monitoring__c> cmListToProcess = new List<Call_Monitoring__c>();
    
    for(Call_Monitoring__c cm : trigger.new){
        if(trigger.isBefore){
            if(trigger.isInsert 
               || (trigger.isUpdate && 
                   (cm.Organization_Name_CM__c != trigger.oldMap.get(cm.Id).Organization_Name_CM__c
                    || cm.Reporting_Year_CM__c != trigger.oldMap.get(cm.Id).Reporting_Year_CM__c
                    || cm.Reporting_Month_CM__c != trigger.oldMap.get(cm.Id).Reporting_Month_CM__c))){
                        
                        if(cm.Organization_Name_CM__c != NULL && cm.Reporting_Year_CM__c != NULL 
                           && cm.Reporting_Month_CM__c != NULL){
                               
                               cmListToProcess.add(cm);
                           }
                    }
        }
    }
    if(cmListToProcess.size() > 0){
        CM_PreventDuplicateRecordsHelper.preventDuplicateCMRecords(cmListToProcess);
    }
}