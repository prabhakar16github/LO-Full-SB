global class IRUM_ACF_NoResponseBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc){
        String statusFinal = 'Final Escalation';
        Id irACFOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Open').getRecordTypeId();
        Id irACFClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Closed').getRecordTypeId();
        Set<Id> pamIdSet = new Set<Id>();

        /*Date reportingDate = System.today();
        string month = string.valueOf(reportingDate.month());
        if(month.length() == 1){
            month = '0'+month;
        }
        string ReportingPeriod = reportingDate.year()+'-'+month;
        System.debug('ReportingPeriod >> '+ReportingPeriod);*/
        
        Date todaysDate = System.today().addMonths(-1);
    	String month = String.valueOf(todaysDate.month());
        
        if(month.length() == 1){
        	month = '0' + month; // format month
        }
        String reportingPeriod = todaysDate.year() +'-'+ month;
        
       List<PAM_Unmatched__c> unmatchedList = [SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, PAMUM_Status__c 
        												FROM PAM_Unmatched__c 
        												WHERE SCMDUM_Reporting_Period__c = :reportingPeriod 
        													AND PAMUM_Status__c = :statusFinal 
        													AND (recordTypeId = :irACFOpenRecType OR recordTypeId = :irACFClosedRecType)];
        													
     	for(PAM_Unmatched__c UmObj : unmatchedList){
        	
        	pamIdSet.add(UmObj.PAMUM_Process_Adherence_Monitoring__c);
        } 
        
        
        String query = 'SELECT Id, Name, Organization_Name__c, Organization_Name__r.Owner.Email, '
        				+'Organization_Name__r.Firm_ID__c, SCMD_Reporting_Period__c'
        				+', (SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, PAMUM_Status__c'
        				+' FROM PAM_Unmatched__r WHERE SCMDUM_Reporting_Period__c = :reportingPeriod'
        				+' AND PAMUM_Status__c = :statusFinal)'
        				+' FROM Process_Adherence_Monitoring__c WHERE Id IN :pamIdSet';

        return Database.getQueryLocator(query);    
    }
    global void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){
        IR_ACF_UnmatchedService.sendNoResponse(pamList);
    }
    global void finish(Database.BatchableContext bc){
        
    }
}