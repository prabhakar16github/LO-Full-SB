/* 
    * @ Class Name      :       EmailMessageTrigger_Test
    * @ Description     :       Test Class for EmailMessageTrigger
    * @ Created By      :       Prabhakar Joshi
    * @ Created Date    :       18-Sept-2020
*/

@isTest
public class EmailMessageTrigger_Test {
	@isTest
    static void test1(){
        Trigger_Setting__c ts = new Trigger_Setting__c();
        ts.Name = 'EmailMessageTrigger';
        ts.Active__c = true;
        ts.Sobject_Type__c = 'EmailMessage';
        insert ts;
        
        Case cs = new Case();
        cs.subject='';
        cs.Outcome_Description__c = 'testing';
        cs.Outcome_FTR__c = 'Completed.';
        cs.Turn_Off_Auto_response__c = false;
        cs.Invalid_Request__c = false;
        cs.Status = 'New';
        cs.RecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Operations').getRecordTypeId();
        insert cs;
        
        EmailMessage email = new EmailMessage();
        email.Incoming = true;
        email.ParentId = cs.Id;
        email.ToAddress = 'test@abc.com';
        email.CcAddress = 'abc@test.com;xyz@test.com';
        email.BccAddress = 'user@sfdc.com';
        insert email;
        
        System.assertEquals(cs.Id, email.ParentId);
    }
}