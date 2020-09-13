/**********************************************************************************************
*  Developer Name :  Shivangi Srivastava
*  Created on :  14-Apr-2020
*  Description : This code will archive all attachments of recordtype : LO IR - Account #\'s Sent 
*  The backup will be stored in myownbackup
* **********************************************************************************************/
global class IR_DataArchiveBatch implements Database.Batchable<sObject>,Database.stateful{
    global Integer countSuccessDeletion;
    global Integer countFailedDeletion;
    global Map<Id,String> recIdByMsg;
    
    
    public IR_DataArchiveBatch(){
        this.countSuccessDeletion = 0;
        this.countFailedDeletion = 0;
        this.recIdByMsg = new Map<Id,String>();
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        string Status = 'Closed';
        Id IR_RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR - Account #\'s Sent').getRecordTypeId();
        Date lastMonth = System.today().addMonths(-6);
        Set<Id> irIdSet = new Set<Id>();
        
        string query = 'SELECT Id FROM Process_Adherence_Monitoring__c WHERE RecordTypeId =: IR_RecordTypeId AND Status__c =: Status ';
        if(!test.isRunningTest())
        query += ' AND LastModifiedDate <: lastMonth';
        
        for(Process_Adherence_Monitoring__c pam : Database.query(query)){
          irIdSet.add(pam.Id);  
        }
        
       string querys = 'SELECT Id, parentId, LastModifiedDate FROM Attachment WHERE parentId IN: irIdSet AND LastModifiedDate < :lastMonth';
        
        return Database.getQueryLocator(querys);
    }
    global void execute(Database.BatchableContext bc, List<Attachment> irAttachmentList){
        
        if(irAttachmentList.size() > 0 ){
            List<Database.DeleteResult> resultList = Database.delete(irAttachmentList,false);
            for(Database.DeleteResult res : resultList){
                if(res.isSuccess()){
                    this.countSuccessDeletion++;
                }else{
                    this.countFailedDeletion++;
                    for(Database.Error er : res.getErrors()){
                        recIdByMsg.put(res.getId(), er.getMessage());
                    }
                }
            }
        }
    }
    global void finish(Database.BatchableContext bc){
       
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Archive IR Attachments');
        string htmlBody = 'Total number of IR attachments deleted : '+this.countSuccessDeletion;//this.totalAttachmentsDeleted;
       if(this.countFailedDeletion > 0){
            htmlBody += '<table border="1" cellpadding="4"><tr><th>RecordId</th><th>Error Message</th></tr>';
            htmlBody += '<body>';
            for(Id key : this.recIdByMsg.keySet()){
               htmlBody += '<tr><td>'+Key+'</td><td>'+this.recIdByMsg.get(key)+'</td></tr>'; 
            }
        htmlBody += '</body></table>';
        }
        mail.setHtmlBody(htmlBody);
        //mail.toAddresses = new List<String>{'shivangi.srivastava@mcmcg.com'};
       mail.toaddresses = new List<String>{'lcsalesforceadmin@mcmcg.com'};
            // if(!test.isRunningTest()) 
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
    }
}