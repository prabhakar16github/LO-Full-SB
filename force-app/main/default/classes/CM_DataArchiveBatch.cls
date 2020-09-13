/***********************************************************************************
 *  Developer Name :  Shivangi Srivastava
 *  Created on :  16-Apr-2020
 *  Description : This code will archive all attachments of 5 recordtypes and also the record of material record type.
 *  The backup will be stored in myownbackup
 ************************************************************************************/
global class CM_DataArchiveBatch implements Database.Batchable<sObject>, Database.Stateful{
    global Integer totalCountOfAttachment;
    global Integer totalCountOfRecords;
    
   public Id cm_QARecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId();
   public Id cm_LogRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Log').getRecordTypeId();
   public Id cm_MaterialRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Materials').getRecordTypeId();
   public Id cm_MaterialResRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('CM Materials Results 20180701').getRecordTypeId();
   public Id cm_RemediationRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('CM Remediation 20180701').getRecordTypeId();
        
    public Date lastmonth = System.today().addMonths(-6);
    public Date lastyear = System.today().addMonths(-12);
    
    global CM_DataArchiveBatch(){
        this.totalCountOfAttachment = 0;
        this.totalCountOfRecords = 0;
    }
    
    global database.QueryLocator start(Database.BatchableContext bc){
        Set<Id> cmSixMonthsBefore = new Set<Id>{cm_QARecordTypeId,cm_MaterialRecordTypeId,cm_LogRecordTypeId};
            Set<Id> cmOneYearBefore = new Set<Id>{cm_RemediationRecordTypeId,cm_MaterialResRecordTypeId};
                Set<Id> cmIdSet = new Set<Id>();
       // System.debug('lastmonth '+lastmonth);
        
        for(Call_Monitoring__c cmList : [SELECT Id, RecordTypeId FROM Call_Monitoring__c 
                                         WHERE (RecordTypeId IN: cmSixMonthsBefore AND LastModifiedDate <: lastmonth) 
                                         OR (((RecordTypeId =: cm_RemediationRecordTypeId AND Firm_Remediation_Complete__c = true) 
                                              OR (RecordTypeId =: cm_MaterialResRecordTypeId)) AND LastModifiedDate <: lastyear)]){
                                                  
                                                  cmIdSet.add(cmList.Id);       
                                              }
        string attList = 'SELECT Id, ParentId FROM Attachment WHERE ParentId IN: cmIdSet'
                                +  '  AND ((Parent.RecordTypeId NOT IN :cmOneYearBefore AND LastModifiedDate < :lastmonth) '
                                 +   '  OR (Parent.RecordTypeId IN :cmOneYearBefore AND LastModifiedDate < :lastyear))';
       // system.debug('query >> '+database.query(attList).size());
        
        return database.getQueryLocator(attList);
     } 
    global void execute(Database.BatchableContext bc, List<Attachment> attList){
        if(attList.size() > 0){
          this.totalCountOfAttachment += attList.size();
            delete attList;
        }
        
    }
    global void finish(Database.BatchableContext bc){
        List<Call_Monitoring__c> cmListMaterial = [SELECT Id FROM Call_Monitoring__c WHERE recordTypeId =: cm_MaterialRecordTypeId AND LastModifiedDate < :lastmonth];
        this.totalCountOfRecords = cmListMaterial.size();
        delete cmListMaterial;
        
        //System.debug('totalCountOfattachments of cm in finish >> '+this.totalCountOfAttachment);
       // System.debug('totalCountOfREcords of cm in finish >> '+this.totalCountOfRecords);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject('CM Data Archive Notification');
        String htmlBody = this.totalCountOfAttachment+' of total attachments and ';
        htmlBody += this.totalCountOfRecords+ ' records of Call Monitoring Materials has been deleted from CM Objects. ';
        email.setHtmlBody(htmlBody);
        //email.toaddresses = new List<String>{'shivangi.srivastava@mcmcg.com'}; 
          email.toaddresses = new List<String>{'lcsalesforceadmin@mcmcg.com'};
            if(!test.isRunningTest())    
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
    }
}