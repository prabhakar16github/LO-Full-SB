/***********************************************************************************
 * Class Name  : IR_DataArchive_Test
 * Description : Test class for IR_DataArchive_Scheduler, IR_DataArchiveBatch
 * Created By  : Shivangi Srivastava
 * Created Date: 17-Apr-2020
 * *******************************************************************************/
@isTest
public class IR_DataArchive_Test {
    @isTest
    static void IR_UnitTest(){
        Date dt = System.today().addMonths(-6);
        Date dt2 = System.today().addMonths(-7);
        
        Account acc = new Account(name='Test');
        acc.Firm_Id__c = '123';
        insert acc;
        
        Process_Adherence_Monitoring__c pam = new Process_Adherence_Monitoring__c();
        pam.RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR - Account #\'s Sent').getRecordTypeId();
        pam.SCMD_Reporting_Period__c = '2019-04';
        pam.CreatedDate = dt2;
        pam.Status__c = 'Closed';
        pam.Organization_Name__c = acc.Id;
        pam.LastModifiedDate = dt2;
        insert pam;
        
        Attachment att = new Attachment();
        att.ParentId = pam.Id;
        att.LastModifiedDate = dt;
        att.CreatedDate = dt;
        att.body = blob.valueOf('Testing');
        att.Name = 'Test PAM att';
        //insert att;
        
        Attachment att2 = new Attachment();
        att2.ParentId = pam.Id;
        att2.LastModifiedDate = dt2;
        att2.CreatedDate = dt2;
        att2.body = blob.valueOf('Testing2');
        att2.Name = 'Test PAM att2';
       // insert att2;
        
        List<Attachment> attList = new List<Attachment>();
        attList.add(att);
        attList.add(att2);
        insert attList;
        
		Test.startTest();
        IR_DataArchive_Scheduler sch = new IR_DataArchive_Scheduler();
        sch.execute(null);
        Test.stopTest();
        //System.assert(!res[0].isSuccess());
        
       
    }

}