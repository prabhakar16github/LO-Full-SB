@isTest
private class LC_CallMonitoringRemediationTriggerTest {

    static testMethod void LC_CallMonitoringRemediationTriggerTest() {
        
        
      Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName();
	      Id rtLeadID =  rtMap.get('Call Monitoring Materials Results').getRecordTypeId(); 
	      Id rtLeadID1 =  rtMap.get('Call Monitoring Remediation').getRecordTypeId(); 
      
      
      Account acc = new Account();
    	
    	acc.Firm_ID__c = 'test';
        acc.Name = 'Test1';
        acc.Phone = '34354345';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        
        insert acc;
      
      Call_Monitoring__c cm = new Call_Monitoring__c();
      
      cm.Organization_Name_CM__c = acc.id;
      cm.Account_Type_CM__c = 'MCM';
      cm.Account_Number_CM__c = 'test';
      cm.Reporting_Quarter_CM__c = 'QTR01';
      cm.Reporting_Year_CM__c = '2016';
      cm.RecordTypeId = rtLeadID;
      
      insert cm;
 
        
    }
}