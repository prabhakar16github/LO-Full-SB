public class CM_DataArchiveHandler {
    public Id cm_QARecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId();
    public Id cm_LogRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Log').getRecordTypeId();
    public Id cm_MaterialRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Materials').getRecordTypeId();
    public Id cm_MaterialResRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('CM Materials Results 20180701').getRecordTypeId();
    public Id cm_RemediationRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('CM Remediation 20180701').getRecordTypeId();
    public Set<Id> CM_recordTypeIdSet = new Set<Id>{cm_QARecordTypeId,cm_LogRecordTypeId,cm_MaterialRecordTypeId,cm_MaterialResRecordTypeId,cm_RemediationRecordTypeId};
        
        
        public Integer fetchAttachmentsOfSixMonths(Set<Id> sixMonthsRecTypeIdSet,List<Call_Monitoring__c> cmList){
            system.debug('cmList of  QA and Log << '+cmList.size());
            Date lastmonth = System.today().addMonths(-6);
            List<Attachment> attList = [SELECT Id, ParentId,Parent.RecordTypeId
                                        FROM Attachment
                                        WHERE ParentId IN :cmList AND Parent.RecordTypeId IN: sixMonthsRecTypeIdSet AND LastModifiedDate <: lastmonth];
            System.debug('attList before delete >> '+attList.size());
            // delete attList;
            //System.debug('attList after delete >>'+attList.size());
            return attList.size();
        } 
    public static CM_WrapperClass fetchMaterailAttachmentsOfSixMonths(Set<Id> sixMonthsMaterialRecTypeIdSet,List<Call_Monitoring__c> cmList){
        system.debug('cmList of  QA and Log << '+cmList.size());
        Date lastmonth = System.today().addMonths(-6);
        Id materialRecordTypeIdSet = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Materials').getRecordTypeId();
        
        List<Call_Monitoring__c> cm_MaterialList = [SELECT Id FROM Call_Monitoring__c WHERE recordTypeId =: sixMonthsMaterialRecTypeIdSet AND LastModifiedDate <: lastmonth];
        System.debug('CM_DataArchiveHandler.cm_MaterialList >>> '+cm_MaterialList.size());
        
        
        List<Attachment> attList = [SELECT Id, ParentId,Parent.RecordTypeId
                                    FROM Attachment
                                    WHERE ParentId IN :cm_MaterialList AND Parent.RecordTypeId IN: sixMonthsMaterialRecTypeIdSet AND LastModifiedDate <: lastmonth];
        System.debug('CM_DataArchiveHandler.cm_MaterialList attList >>> '+attList.size());
         //delete cm_MaterialList;
         //delete attList;
        System.debug('wrapperData >> '+new CM_WrapperClass(cm_MaterialList.size(), attList.size()));
        return new CM_WrapperClass(cm_MaterialList.size(), attList.size());
    }
    
    public Integer fetchMaterialAttachments(Set<Id> oneYearMaterialTypeIdSet,List<Call_Monitoring__c> cmList){
        System.debug('Material List Size >> '+cmList.size());
        Date lastdate = System.today().addMonths(-12);
        System.debug('lastdate >>> '+lastdate);
        
        List<Call_Monitoring__c> cmListforOneYear = [SELECT Id FROM Call_Monitoring__c WHERE RecordTypeId =: oneYearMaterialTypeIdSet 
                                                     AND Id IN:cmList 
                                                     AND LastModifiedDate <: lastdate];
        
        System.debug('Material New List Size >> '+cmListforOneYear.size());
        
        Date lastyear = System.today().addYears(-1);
        List<Attachment> attList = [SELECT Id, ParentId,Parent.RecordTypeId
                                    FROM Attachment
                                    WHERE ParentId IN :cmListforOneYear AND Parent.RecordTypeId IN: oneYearMaterialTypeIdSet AND LastModifiedDate <: lastyear];
        //delete attList;
        return attList.size();
    }
    
    public Integer fetchRemediationAttachments(Set<Id> oneYearRemedTypeIdSet, List<Call_Monitoring__c> cmList){
        //System.debug('Redmediation List Size >> '+cmList.size());
        Date lastdate = System.today().addMonths(-12);
        //System.debug('lastdate >>> '+lastdate);
        
        List<Call_Monitoring__c> cmListforCheckbox = [SELECT Id FROM Call_Monitoring__c WHERE RecordTypeId =: oneYearRemedTypeIdSet 
                                                      AND Firm_Remediation_Complete__c = True AND Id IN:cmList 
                                                      AND LastModifiedDate <: lastdate];
        
        System.debug('Redmediation New List Size >> '+cmListforCheckbox.size()); 
        
        Date lastyear = System.today().addYears(-1);
        List<Attachment> attList = [SELECT Id, ParentId,Parent.RecordTypeId
                                    FROM Attachment
                                    WHERE ParentId IN :cmListforCheckbox AND Parent.RecordTypeId IN: oneYearRemedTypeIdSet AND LastModifiedDate <: lastyear];
       // delete attList;
        return attList.size();
    }
    
    //Wrapper Class for 3recordType i.e; Material
    public Class CM_WrapperClass{
        public Integer recordsCount{get;set;}
        public Integer attachmentsCount{get;set;}
        
        public CM_WrapperClass(Integer recordsCount,Integer attachmentsCount){
            this.recordsCount = recordsCount;
            this.attachmentsCount = attachmentsCount;
        }
    }
    
    public void sendEmailOfArchiveData(Integer totalAttachment,Integer totalRecord, string subject){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject(subject);
        String htmlBody = totalAttachment+' of total attachments and ';
        htmlBody += totalRecord+ ' records of Call Monitoring Materials has been deleted from CM Objects. ';
        email.setHtmlBody(htmlBody);
       // email.toaddresses = new List<String>{'shivangi.srivastava@mcmcg.com'}; 
             email.toaddresses = new List<String>{'lcsalesforceadmin@mcmcg.com'};
            if(!test.isRunningTest())    
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
    }
}