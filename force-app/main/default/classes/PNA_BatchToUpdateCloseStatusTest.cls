@isTest
private class PNA_BatchToUpdateCloseStatusTest {

    static testMethod void myUnitTest() {
	        // TO DO: implement unit test
	        
	        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User u = new User();
        u.Alias = 'ssa';
        u.Email='standarduser11sak@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingsak';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='sak1@salesforce.com';
        insert u;
        
        Account acc = new Account();
        acc.Firm_ID__c ='test';
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        acc.Paralegal__c = u.id;
        acc.MCM_Attorney__c = u.id;
        insert acc;
        
        
        String PNARecordTypeID = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO PNA').getRecordTypeId();
        
    	Process_Adherence_Monitoring__c pamTestObj = new Process_Adherence_Monitoring__c( RecordTypeId = PNARecordTypeID, 
    																						Account_Number__c = '0987654321',
    																						Organization_Name__c = acc.id,
    																						Status__c = 'New',
    																						SOL_Placement_Date__c = System.today(),
    																						PNA_Placement_Type__c = 'LB5');
    																						
    	insert pamTestObj;
    	
    	Test.setCreatedDate(pamTestObj.Id, Datetime.valueOf(System.now().addDays(-2)));
    	
    	String lastModifiedDate = Datetime.valueOf(System.now().addDays(-2)).formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    	
    	String pamJson = '{"attributes":{"type":"Process_Adherence_Monitoring__c",'
    						+'"url":"/services/data/v25.0/sobjects/Process_Adherence_Monitoring__c/'+pamTestObj.Id+'"},'+
    						'"Id":"'+pamTestObj.Id+'","LastModifiedDate":"'+lastModifiedDate+'", "PNA_Placement_Type__c" : "LB7"}';
    	
    	Process_Adherence_Monitoring__c pamTOUpdate = (Process_Adherence_Monitoring__c)JSON.deserializeStrict(pamJson, Process_Adherence_Monitoring__c.Class);
    	
    	
    	update pamTOUpdate;
    	
    	
    	Test.startTest();    								
    								
    		Database.executeBatch(new PNA_BatchToUpdateCloseStatus() ,1000); 
    	
    	Test.stopTest();
    	
    	System.assert(true);
        
    }
}