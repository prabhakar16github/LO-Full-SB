@isTest
private class LC_CreateArchivedEmailMessagesBatchTest {

    static testMethod void myUnitTest() {
           
        
        Date D = System.Today().AddMonths(-18);
        Map<String,Schema.RecordTypeInfo> CaseRecordTypeInfo = Schema.SObjectType.Case.getRecordTypeInfosByName(); 
        id Operations1 = CaseRecordTypeInfo.get('Operations').getRecordTypeId();
        id OA= CaseRecordTypeInfo.get('Operations - AA').getRecordTypeId();
        id OAI= CaseRecordTypeInfo.get('Operations - Account Inquiry').getRecordTypeId();
        id CAO= CaseRecordTypeInfo.get('Operations - CAO').getRecordTypeId();
        id OIR= CaseRecordTypeInfo.get('Operations - IR').getRecordTypeId();
      
        Map<id,Case> em = new Map<id,Case>([Select id,LastModifiedDate,ParentId,RecordTypeId,IsClosed FROM Case WHERE LastModifiedDate <= : D AND ParentId != Null and (RecordTypeId =: Operations1 or RecordTypeId =: OA or RecordTypeId=: OAI  OR RecordTypeId =: CAO  OR RecordTypeId =: OIR)  AND IsClosed = true]);
                            
         List<EmailMessage> emailmessage = new List<EmailMessage>();
         emailmessage =  [SELECT ActivityId,BccAddress,CcAddress,
                  CreatedById,CreatedBy.Name,CreatedDate,FromAddress,FromName,HasAttachment,
                  Headers,Id,Incoming,IsDeleted,LastModifiedById,LastModifiedBy.Name,LastModifiedDate,MessageDate,
                  ParentId,ReplyToEmailMessageId,Status,Subject,ToAddress 
                  FROM EmailMessage WHERE LastModifiedDate <= : D AND ParentId IN: em.keyset() LIMIT 9000]; 
                           
        delete emailmessage ;
      
                   
       
       
         Test.startTest();
        LC_CreateArchivedEmailMessagesBatch  sb=new LC_CreateArchivedEmailMessagesBatch ();
        Database.executeBatch(sb,500);
        Test.stopTest();
      
      
     
        
    }
}