/***********************************************************************************
 * Class Name  : DM_NoMedia_Integration_Test
 * Description : Test class for DM_NoMedia_Integration_Scheduler,DM_NoMedia_Integration & DM_NoMedia_Integration_Helper.
 * Created By  : Prabhakar Joshi
 * Created Date: 18-feb-2020
 * *******************************************************************************/

@isTest
public class DM_NoMedia_Integration_Test {
	@TestSetup
    static void testSetupMethod(){
        
        DM_API_Credentials__c cred = new DM_API_Credentials__c();
        cred.Name = 'API 1';
        cred.Endpoint_URL__c = 'www.google.com';
        cred.API_Key__c = '1234avcd';
        cred.correlation_id__c = 'test';
        cred.Key_Secret__c = '32323adad';
        cred.mcm_appid__c = 'test';
        cred.mcm_userid__c = 'salesforce';
        insert cred;
        
        DM_API_Field_Mapping__c fieldMap = new DM_API_Field_Mapping__c();
        fieldMap.Name = 'Account_Number__c';
        fieldMap.API_Parameter__c = 'consumerAccountIdentifierAgencyId';
        fieldMap.Active__c = true;
        insert fieldMap;
        
        DM_API_Field_Mapping__c fieldMap2 = new DM_API_Field_Mapping__c();
        fieldMap2.Name = 'STNM_Suit_Theory_Code_Date__c';
        fieldMap2.API_Parameter__c = 'suitTheoryDate';
        fieldMap2.Active__c = true;
        insert fieldMap2;
        
        DM_API_Field_Mapping__c fieldMap3 = new DM_API_Field_Mapping__c();
        fieldMap3.Name = 'State__c';
        fieldMap3.API_Parameter__c = 'state';
        fieldMap3.Active__c = true;
        insert fieldMap3;
        
        Account acc = new Account();
        acc.Name = 'test account';
        acc.Firm_ID__c = 'CA137';
        insert acc;
        
        Process_Adherence_Monitoring__c pam = new Process_Adherence_Monitoring__c();
        pam.RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM PSNM').getRecordTypeId();
        pam.STNM_Suit_Theory_Code_Date__c = System.today();
        pam.Account_Number__c = '300182755';
        insert pam;
        
    }
    
    @isTest
    static void test1(){
        DM_API_Credentials__c cred = [SELECT Name,Endpoint_URL__c,API_Key__c,correlation_id__c,Key_Secret__c,mcm_appid__c,
                                      mcm_userid__c FROM DM_API_Credentials__c LIMIT 1];
        
        DM_API_Field_Mapping__c fieldMap = [SELECT Name,API_Parameter__c,Active__c FROM DM_API_Field_Mapping__c LIMIT 1];
        
        Account acc1 = [SELECT Name,Firm_ID__c FROM Account];
        
        Process_Adherence_Monitoring__c pam = [SELECT RecordTypeId,STNM_Suit_Theory_Code_Date__c,Account_Number__c 
                                               FROM Process_Adherence_Monitoring__c];
    
    	DM_NoMedia_Integration_Scheduler sch = new DM_NoMedia_Integration_Scheduler();
        sch.execute(NULL);
        DM_NoMedia_Integration_Helper handler = new DM_NoMedia_Integration_Helper();
        handler.sendCalloutException('Test Error', 'test response','API 1');
    }
    
    
}