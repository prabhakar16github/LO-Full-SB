@isTest
private class TrialWitnessRequestTrigger_Test {
	
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
        
        
       Trigger_Setting__c ts = new Trigger_Setting__c();
        ts.Name = 'TrialWitnessRequestTrigger';
        ts.Active__c = true;
        insert ts;
    
    }
    
    @IsTest
    private static void updateTrialWitnessSubmittedTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User();
        u.Alias = 'stan';
        u.Email='xderfv1234@test.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testing11';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='testvdd75@salesforce.com';
        
        insert u;
        
        List<Trigger_Setting__c> tsList = [SELECT Name,Active__c FROM Trigger_Setting__c];
    	List<Consumer_Account_Details__c> consumerAccountDetails = [SELECT Id, Organization_name__c FROM Consumer_Account_Details__c LIMIT 1];
    	Consumer_Account_Details__c cadObj = consumerAccountDetails.get(0);
        
        State_Profile__c Sp = new State_Profile__c();
        Sp.Name = 'test';
        Sp.State_NPV_Group__c = 'High';
        Sp.SP_Paralegal__c = u.id;
        Sp.SP_MCM_Attorney__c = u.id;
            
        insert Sp;  
        
    	Trial_Witness_Request__c trialWitnessObj = new Trial_Witness_Request__c();
    	trialWitnessObj.Recordtypeid = Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName().get('Live Witness Request Step II').getRecordTypeId();
        trialWitnessObj.OrganizationName__c = cadObj.Organization_name__c;
        trialWitnessObj.TW_Consumer_Account_Records__c = cadObj.id;
        trialWitnessObj.Opposing_Counsel__c = 'test';
        trialWitnessObj.Opposing_Counsel_Comments__c = 'test';
        trialWitnessObj.Opposing_Counsel_Email__c = 'i@gmail.com';
        trialWitnessObj.Opposing_Counsel_Firm_Name__c = 'test';
        trialWitnessObj.Opposing_counsel_Phone__c = '235235';
        trialWitnessObj.Status__c = 'Pending Resolution';
        trialWitnessObj.State_Filed_State_Profile__c = sp.Id;
        trialWitnessObj.LW_Attorney_Approval_Needed__c =true;
       trialWitnessObj.Date_of_Appearance__c = System.today().addDays(15);
        Test.startTest();
        	insert trialWitnessObj;
        
        trialWitnessObj.RecordTypeId =  Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName().get('Live Witness Request Step III').getRecordTypeId();
        update trialWitnessObj;
        LW_MissingAttNotificationScheduler obj = new LW_MissingAttNotificationScheduler(new Set<Id>{trialWitnessObj.Id});
        obj.execute(NULL);
        Test.stopTest();
        system.assert(true);
    }
}