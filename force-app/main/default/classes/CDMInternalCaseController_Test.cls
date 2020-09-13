@isTest
public class CDMInternalCaseController_Test{
    
    public static testMethod void unitTest(){

        Account accObj = new Account(RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('CDM: Internal Clients').getRecordTypeId(),
                                        Name='Test Account');
        insert accObj;
        
        Contact conObj = new Contact(RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CDM: Internal Contacts').getRecordTypeId(),
                                        LastName='Test Account',AccountId=accObj.id);
        insert conObj;
        
        CDMInternalCaseController CDMInternalCaseObj = new CDMInternalCaseController();
        CDMInternalCaseObj.caseAccountId = null;
        CDMInternalCaseObj.caseContactId = null;
        CDMInternalCaseObj.getAccountRecordList();
        CDMInternalCaseObj.getContactRecordList();
        CDMInternalCaseObj.CreateRecord();
        CDMInternalCaseObj.caseAccountId = accObj.id;
        CDMInternalCaseObj.CreateRecord();
        CDMInternalCaseObj.caseContactId = conObj.id;
        CDMInternalCaseObj.CreateRecord();
    }
}