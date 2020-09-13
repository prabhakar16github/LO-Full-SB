@isTest
public class LRMM_PopulateResolutionController_Test {
	@isTest
    static void test1(){
        
        Consumer_Account_Details__c cad = new Consumer_Account_Details__c();
        cad.Master_Activated__c = true;
        insert cad;
        
        Appeal__c ap = new Appeal__c();
        ap.AP_Consumer_Account_Record__c = cad.Id;
        ap.AP_Opposing_Counsel_Email__c = 'test@abc.com';
        ap.AP_Opposing_Counsel__c = 'test';
        ap.AP_Opposing_Counsel_Firm_Name__c = 'test';
        ap.AP_Opposing_counsel_Phone__c = '9878677876';
        ap.AP_Resolution_Amount__c = 1000;
        ap.AP_Resolution_Date__c = System.today();
        ap.AP_Resolution_Payment_To__c = 'MCM';
        ap.AP_Resolution_Type__c = 'Arbitration';
        ap.AP_Resolution_Notes__c = 'Test';
        ap.AP_Variance_From_Established_Process__c = 'SOL';
        insert ap;
        
        Trial_Witness_Request__c tw = new Trial_Witness_Request__c ();
        tw.TW_Consumer_Account_Records__c = cad.Id;
        insert tw;
        Apexpages.StandardController sc = new ApexPages.StandardController(tw);
        LRMM_PopulateResolutionController obj = new LRMM_PopulateResolutionController(sc);
        obj.recordId = tw.Id;
        
        
       obj.doSave();
    } 
}