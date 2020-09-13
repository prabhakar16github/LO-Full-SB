global class IRUM_ACF_ReminderNotificationBatch implements database.Batchable<sObject>{ 
    global Database.QueryLocator start(Database.BatchableContext bc){
        String statusNew = 'New';
        Id irACFOpenRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Open').getRecordTypeId();
        Id irACFClosedRecType = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF IRUM - Firm Closed').getRecordTypeId();
        
       /* Date reportingDate = System.today();
        string month = string.valueOf(reportingDate.month());
        if(month.length() == 1){
            month = '0'+month;
        }
        string ReportingPeriod = reportingDate.year()+'-'+month;*/
        
        Date todaysDate = System.today().addMonths(-1);
    	String month = String.valueOf(todaysDate.month());
        
        if(month.length() == 1){
        	month = '0' + month; // format month
        }
        String reportingPeriod = todaysDate.year() +'-'+ month; 
         
        System.debug('ReportingPeriod >> '+reportingPeriod);
        Set<Id> pamIdSet = new Set<Id>();
        List<PAM_Unmatched__c> irUnmatchedList = [SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, PAMUM_Status__c 
        												FROM PAM_Unmatched__c 
        												WHERE SCMDUM_Reporting_Period__c = :reportingPeriod 
        													AND PAMUM_Status__c = :statusNew 
        													AND (recordTypeId = :irACFOpenRecType
        													OR recordTypeId = :irACFClosedRecType)];
        
        
        for(PAM_Unmatched__c irUmObj : irUnmatchedList){
        	
        	pamIdSet.add(irUmObj.PAMUM_Process_Adherence_Monitoring__c);
        } 
        				
        String query = 'SELECT Id, Name, Organization_Name__c, Organization_Name__r.Firm_ID__c, SCMD_Reporting_Period__c'
        				+', (SELECT Id, Name, PAMUM_Process_Adherence_Monitoring__c, PAMUM_Status__c'
        				+' FROM PAM_Unmatched__r WHERE SCMDUM_Reporting_Period__c = :reportingPeriod'
        				+' AND PAMUM_Status__c = :statusNew)'
        				+' FROM Process_Adherence_Monitoring__c WHERE Id IN :pamIdSet';
        				
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext bc, List<Process_Adherence_Monitoring__c> pamList){//List<PAM_Unmatched__c> umPamList
        IR_ACF_UnmatchedService.processReminderPam(pamList);
    }
    global void finish(Database.BatchableContext bc){
        
    }
}