/***********************************************************************************
 * Class Name  : LRMM_DataArchive_Test
 * Description : Test class for LRMM_DataArchiveScheduler,LRMM_DataArchiveBatch & LRMM_DataArchiveHandler
 * Created By  : Prabhakar Joshi
 * Created Date: 14-Apr-2020
 * *******************************************************************************/

@isTest
public class LRMM_DataArchive_Test {
    @TestSetup
    static void testsetup() {
       Trigger_Setting__c ts = new Trigger_Setting__c();
        ts.Name = 'AttachmentTrigger';
        ts.Active__c = true;
        insert ts;
    }
    
    
    @isTest
    static void test1(){
        List<Trigger_Setting__c> tsList = [SELECT Name,Active__c FROM Trigger_Setting__c];
        DateTime lastDate = LRMM_DataArchiveHandler.lastDate;

        Account accObj = new Account();
        accObj.Firm_ID__c ='test';
        accObj.Name = 'CA137';
        
        insert accObj;
        
        Consumer_Account_Details__c cadObj = new Consumer_Account_Details__c();
        cadObj.Organization_name__c = accObj.id;
        cadObj.Account_Number__c = '111';
        insert cadObj;

		Appeal__c ap = new Appeal__c();
        ap.AP_Appeal_Status__c = 'Closed';
        ap.AP_Pro_Se__c = true;
        ap.AP_Consumer_Account_Record__c = cadObj.Id;
        ap.CreatedDate = lastDate.addDays(-1); 
        ap.LastModifiedDate = lastDate.addDays(-1);
        insert ap;
        
        Attachment att = new Attachment();
        att.ParentId = ap.Id;
        att.Name = 'testAtt';
        att.body = Blob.valueOf('testing');
        att.CreatedDate = lastDate.addDays(-1);
        att.LastModifiedDate = lastDate.addDays(-1);
        insert att;
        
        Test.startTest();
        LRMM_DataArchiveScheduler obj = new LRMM_DataArchiveScheduler();
        obj.execute(NULL);
        Test.stopTest();
        
    }
}