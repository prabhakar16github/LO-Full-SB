global class DeleteEmailMessagesBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(Test.isRunningTest()){
            return Database.getQueryLocator([SELECT id FROM EmailMessage LIMIT 1]);
        }
        return Database.getQueryLocator([SELECT id FROM EmailMessage WHERE Parent.IsClosed = true AND 
                                        Parent.RecordType.Name in ('Operations','Operations - AA','Operations - ACF','Operations - Account Inquiry',
                                        'Operations - CAO','Operations - IR','Operations - PAM','Operations - QA Case','Operations - YGC Reject Report') 
                                        AND MessageDate <: system.today().addMonths(-18) AND Parent.LastModifiedDate <: system.today().addMonths(-18)]);
    }
    
    global void execute(Database.BatchableContext BC, List<EmailMessage> emailMessageList){
        delete emailMessageList;
    }
    
    global void finish(Database.BatchableContext BC){}
}