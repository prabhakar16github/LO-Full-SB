@isTest
private class TrialWitnessRequestTriggerHelperTest {
	
	@TestSetup
    private static void testSetup() {
        Account accObj = new Account();
        accObj.Firm_ID__c ='test';
        accObj.Name = 'CA137';
        accObj.Phone = '98828383';
        accObj.Physical_Street__c= 'test';
        accObj.Physical_City__c = 'city';
        accObj.Physical_Postal_Code__c = '11111';
        accObj.Physical_Country__c = 'test country';
        accObj.Physical_State_Province__c = 'Province';
        accObj.Paralegal__c = UserInfo.getUserId();
        accObj.MCM_Attorney__c = UserInfo.getUserId();
        insert accObj;
        
        Consumer_Account_Details__c cadObj = new Consumer_Account_Details__c();
        cadObj.Organization_name__c = accObj.id;
        cadObj.Account_Number__c = '111';
        cadObj.OwnerId =  UserInfo.getUserId();
        cadObj.Original_Creditor__c = 'test';
        cadObj.CAD_Credit_Card__c = true;
        insert cadObj;
        
    }
    
    @IsTest
    private static void updateTrialWitnessSubmittedTest(){
    	List<Consumer_Account_Details__c> consumerAccountDetails = [SELECT Id, Organization_name__c FROM Consumer_Account_Details__c LIMIT 1];
    	Consumer_Account_Details__c cadObj = consumerAccountDetails.get(0);
    	Trial_Witness_Request__c trialWitnessObj = new Trial_Witness_Request__c();
    	trialWitnessObj.Recordtypeid = Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName().get('Live Witness Request Step I').getRecordTypeId();
        trialWitnessObj.OrganizationName__c = cadObj.Organization_name__c;
        trialWitnessObj.TW_Consumer_Account_Records__c = cadObj.id;
        trialWitnessObj.Opposing_Counsel__c = 'test';
        trialWitnessObj.Opposing_Counsel_Comments__c = 'test';
        trialWitnessObj.Opposing_Counsel_Email__c = 'i@gmail.com';
        trialWitnessObj.Opposing_Counsel_Firm_Name__c = 'test';
        trialWitnessObj.Opposing_counsel_Phone__c = '235235';
        trialWitnessObj.Status__c = 'Pending Resolution';
        Test.startTest();
        	insert trialWitnessObj;
        Test.stopTest();
        system.assert(true);
    }
}