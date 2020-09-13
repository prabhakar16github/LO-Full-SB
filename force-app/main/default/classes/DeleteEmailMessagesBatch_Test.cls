@isTest
public class DeleteEmailMessagesBatch_Test{
    
    public static testMethod void unitTest(){
        Case caseObj = new Case(RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Operations').getRecordTypeId(),Status='Closed');
        insert caseObj;
        
        EmailMessage emailMsgObj = new EmailMessage(ParentId=caseObj.id);
        insert emailMsgObj;
        
        Database.executeBatch(new DeleteEmailMessagesBatch(),2000);
    }
}