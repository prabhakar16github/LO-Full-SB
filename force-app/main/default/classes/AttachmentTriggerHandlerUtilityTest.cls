@isTest
private class AttachmentTriggerHandlerUtilityTest {
	
	/*@TestSetup
    static void testsetup() {
        // for common data 
        Account account = TestDataFactory.createAccounts(1, false).get(0);
		insert account;        
    }*/
    
    static testMethod void processIrOnAttachmentAddedTest(){
    	Account account = new Account(Name = 'TestAccount');
        insert account;
    	Id irRecordType = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR').getRecordTypeId();
        Id psnmRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO PSNM').getRecordTypeId();
        Id rsnmRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO RSNM').getRecordTypeId();
        Id dmIrRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM IR').getRecordTypeId();
        
        List<Process_Adherence_Monitoring__c> pamList = new List<Process_Adherence_Monitoring__c>();
    	Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c();
    	pamObj.Organization_Name__c = account.Id;
    	pamObj.IR_Open_Inventory_Act_Volume__c = 10;
    	pamObj.recordTypeId = irRecordType;
    	pamObj.Status__c = 'Accounts Sent To ISeries';
        pamList.add(pamObj);
    	
    	Process_Adherence_Monitoring__c pamObj2 = new Process_Adherence_Monitoring__c();
    	pamObj2.Organization_Name__c = account.Id;
    	pamObj2.IR_Open_Inventory_Act_Volume__c = 10;
    	pamObj2.recordTypeId = psnmRecordTypeId;
    	pamObj2.Status__c = 'Accounts Sent To ISeries';
    	pamList.add(pamObj2);
        
        Process_Adherence_Monitoring__c pamObj3 = new Process_Adherence_Monitoring__c();
    	pamObj3.Organization_Name__c = account.Id;
    	pamObj3.IR_Open_Inventory_Act_Volume__c = 10;
    	pamObj3.recordTypeId = rsnmRecordTypeId;
    	pamObj3.Status__c = 'Accounts Sent To ISeries';
    	pamList.add(pamObj3);
    	
        Process_Adherence_Monitoring__c pamObj4 = new Process_Adherence_Monitoring__c();
    	pamObj4.Organization_Name__c = account.Id;
    	pamObj4.IR_Open_Inventory_Act_Volume__c = 10;
    	pamObj4.recordTypeId = dmIRRecordTypeId;
    	pamObj4.Status__c = 'Accounts Sent To ISeries';
    	pamList.add(pamObj4);
        
    	insert pamList;
        
        Attachment attachment = new Attachment();
    	attachment.Name = 'Test';
    	Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
    	attachment.body = bodyBlob;
        attachment.ParentId = pamObj2.Id;
        
        Attachment attachment2 = new Attachment();
    	attachment2.Name = 'Test';
    	Blob bodyBlob2 = Blob.valueOf('Unit Test Attachment Body for RSNM');
    	attachment2.body = bodyBlob2;
        attachment2.ParentId = pamObj3.Id;
        test.startTest();
        insert  attachment;
        insert attachment2;
        test.stopTest();
        
        
        
    }
    
    static testMethod void lrmm_CopyAttachmentstoCADTest(){
    	
    	Account account = new Account(Name = 'TestAccount');
        insert account;
    	
    	Consumer_Account_Details__c cadObj = new Consumer_Account_Details__c();
        cadObj.Organization_name__c = account.id;
        cadObj.Account_Number__c = '111';
        cadObj.OwnerId =  UserInfo.getUserId();
        cadObj.Original_Creditor__c = 'test';
        cadObj.CAD_Credit_Card__c = true;
        insert cadObj;
        
        Trial_Witness_Request__c trialWitnessRequest = new Trial_Witness_Request__c();
        trialWitnessRequest.Account_Number__c = 'test';
        trialWitnessRequest.Defendant_Name__c = 'test';
        trialWitnessRequest.Date_of_Trial__c = system.today();
        trialWitnessRequest.Date_Response_is_Needed_By__c = system.today();
        trialWitnessRequest.Time_of_Trial__c = '01:00';
        trialWitnessRequest.AM_PM__c = 'AM';
        trialWitnessRequest.Time_Zone__c = 'Eastern';
        trialWitnessRequest.County_Court_Name__c = 'test';
        trialWitnessRequest.Assigned_Attorney__c	= 'test';
        trialWitnessRequest.Opposing_Counsel__c = 'test';
        trialWitnessRequest.Suit_Balance__c = 100;
        trialWitnessRequest.Court_Costs__c = 00;
        trialWitnessRequest.Counterclaim__c = 'Yes';
        trialWitnessRequest.Appearance_Type__c = 'Trial';
        insert trialWitnessRequest;
        
        Appeal__c appealObj = new Appeal__c();
        appealObj.AP_Organization_Name__c = cadObj.Organization_name__c;
        appealObj.AP_Consumer_Account_Record__c = cadObj.id;
        appealObj.AP_Matter_Name__c = 'test';
        appealObj.AP_Court_File__c = 'test';
        appealObj.AP_County_Court_Name__c = 'test';
        appealObj.AP_Account_Number__c = '111';
        appealObj.AP_Judge_Name__c = 'test';
        appealObj.AP_Prior_Experience_with_Judge__c = 'Yes';
        appealObj.AP_IfPriorExperience_with_Judge_Comments__c = 'test';
        appealObj.AP_County_Filed__c = 'test';
        appealObj.AP_Assigned_Attorney__c= 'test';
        appealObj.AP_Assigned_Attorney_Cell_Phone__c = '12412';
        appealObj.AP_Assigned_Attorney_Direct_Line__c = '2424';
        appealObj.AP_Assigned_Attorney_Email__c = 'test@gmail.com';
        appealObj.AP_Opposing_Counsel__c = '23523';
        appealObj.AP_Opposing_Counsel_Comments__c = 'test';
        appealObj.AP_Opposing_Counsel_Email__c = 'test@gmail.com';
        appealObj.AP_Opposing_Counsel_Firm_Name__c = 'test';
        appealObj.AP_Opposing_counsel_Phone__c = '12412';
        insert appealObj;
    	
		Business_Record_Affidavit__c braObj = new Business_Record_Affidavit__c();
        braObj.Recordtypeid = Schema.SObjectType.Business_Record_Affidavit__c.getRecordTypeInfosByName().get('BRA: Record Type').getRecordTypeId();
        braObj.BRA_Organization_Name__c = account.id;
        braObj.BRA_Original_Creditor__c = 'test';
        braObj.BRA_Consumer_Account_Details_Record__c = cadObj.id;
        braObj.BRA_Opposing_Counsel__c = 'test';
        braObj.BRA_Opposing_Counsel_Comments__c = 'test';
        braObj.BRA_Opposing_Counsel_Email__c = 'i@gmail.com';
        braObj.BRA_Opposing_Counsel_Firm_Name__c = 'test';
        braObj.BRA_Opposing_counsel_Phone__c = '235235';
        insert braObj;
        
        Counterclaim__c ccObj = new Counterclaim__c();
        ccObj.CC_Organization_Name__c = account.id;
        ccObj.CC_Consumer_Account_Detail_Name__c = cadObj.id;
        ccObj.CC_Matter_Name__c = 'test';
        ccObj.CC_Court_File__c = 'test';
        ccObj.CC_Account_Number__c = '124';
        ccObj.CC_County_Court_Name__c= 'test';
        ccObj.CC_Judge_Name__c = 'test';
        ccObj.CC_Prior_Experience_with_Judge__c = 'Yes';
        ccObj.CC_IfPriorExperience_with_Judge_Comments__c = 'test';
        ccObj.CC_Assigned_Attorney__c = 'test';
        ccObj.CC_Assigned_Attorney_Cell_Phone__c = '3463463464';
        ccObj.CC_Assigned_Attorney_Direct_Line__c = '74574';
        ccObj.CC_Assigned_Attorney_Email__c = 'test@gmail.com';
        ccObj.CC_Opposing_Counsel__c = 'test';
        ccObj.CC_Opposing_Counsel_Comments__c = 'test';
        ccObj.CC_Opposing_Counsel_Email__c = 'email@gmail.com';
        ccObj.CC_Opposing_Counsel_Firm_Name__c = 'test';
        ccObj.CC_Opposing_counsel_Phone__c = '34634';
        ccObj.CC_Counterclaim_Status__c = 'New';
        insert ccObj;   
        
        Escalated_Contested_Matters__c ecmObj = new Escalated_Contested_Matters__c();
        ecmObj.ECM_Organization_Name__c = account.id;
        ecmObj.ECM_Consumer_Account_Detail_Name__c = cadObj.id;
        ecmObj.ECM_Opposing_Counsel__c = 'test';
        ecmObj.ECM_Opposing_Counsel_Comments__c = 'test';
        ecmObj.ECM_Opposing_Counsel_Email__c = 'i@gmail.com';
        ecmObj.ECM_Opposing_Counsel_Firm_Name__c = 'test';
        ecmObj.ECM_Opposing_counsel_Phone__c = '235235';
        insert ecmObj;
      
        Discovery__c discoveryObj = new Discovery__c();
        discoveryObj.DY_Organization_Name__c = account.id;
        discoveryObj.DY_Request_For_Admissions__c = true;
        discoveryObj.DY_Matter_Name__c = 'test';
        discoveryObj.DY_Account_Number__c = 'test';
        discoveryObj.DY_Court_File__c = 'test';
        discoveryObj.DY_County_Court_Name__c = 'test';
        discoveryObj.DY_Judge_Name__c = 'test';
        discoveryObj.DY_Prior_Experience_with_Judge__c = 'Yes';
        discoveryObj.DY_IfPriorExperience_with_Judge_Comments__c = 'test';
        discoveryObj.DY_Assigned_Attorney__c = 'test';
        discoveryObj.DY_Assigned_Attorney_Cell_Phone__c = '23523';
        discoveryObj.DY_Assigned_Attorney_Direct_Line__c = '34534';
        discoveryObj.DY_Assigned_Attorney_Email__c = 'i@gmail.com';
        discoveryObj.DY_Opposing_Counsel__c = 'test';
        discoveryObj.DY_Opposing_Counsel_Comments__c = 'test';
        discoveryObj.DY_Opposing_Counsel_Email__c = 'i@gmail.com';
        discoveryObj.DY_Opposing_Counsel_Firm_Name__c = 'test';
        discoveryObj.DY_Opposing_counsel_Phone__c = '235235';
        discoveryObj.DY_Consumer_Account_Details__c = cadObj.id;
        insert discoveryObj;
        Attachment attachDY = new Attachment();
        attachDY.Name = 'Unit Test Attachment';
        attachDY.body = Blob.valueOf('Unit Test Attachment Body');
        attachDY.parentId = discoveryObj.id;
        insert attachDY;
        
        Purchase_and_Sales_Agreement__c psaObj = new Purchase_and_Sales_Agreement__c();
        psaObj.PSA_Organization_Name__c = account.id;
        psaObj.PSA_Portfolio__c = 'test';
        psaObj.PSA_Chain_of_Title__c = 'test';
        psaObj.PSA_Original_Creditor__c = 'test';
        psaObj.PSA_Consumer_Account_Detail_Name__c = cadObj.id;
        psaObj.PSA_Opposing_Counsel__c = 'test';
        psaObj.PSA_Opposing_Counsel_Comments__c = 'test';
        psaObj.PSA_Opposing_Counsel_Email__c = 'i@gmail.com';
        psaObj.PSA_Opposing_Counsel_Firm_Name__c = 'test';
        psaObj.PSA_Opposing_counsel_Phone__c = '235235';
        insert psaObj;
        
        Settlement_Approval__c saObj = new Settlement_Approval__c ();
        saObj.SA_Organization_Name__c = cadObj.Organization_name__c;
        saObj.SA_Consumer_Account_Details__c = cadObj.id;
        saObj.SA_Matter_Name__c = 'test';
        saObj.SA_Account_Number__c = '121';
        saObj.SA_Court_File__c = 'test';
        saObj.SA_County_Court_Name__c  = 'test';
        saObj.SA_Judge_Name__c = 'test';
        saObj.SA_Prior_Experience_with_Judge__c = 'Yes';
        saObj.SA_IfPriorExperience_with_Judge_Comments__c  = 'test';
        saObj.SA_Assigned_Attorney__c = 'test';
        saObj.SA_Assigned_Attorney_Cell_Phone__c = '23523';
        saObj.SA_Assigned_Attorney_Direct_Line__c = '23523';
        saObj.SA_Assigned_Attorney_Email__c = 'test@gmail.com';
        saObj.SA_Opposing_Counsel__c = 'test';
        saObj.SA_Opposing_Counsel_Comments__c = 'test';
        saObj.SA_Opposing_Counsel_Email__c = 'test@gmail.com';
        saObj.SA_Opposing_Counsel_Firm_Name__c = 'test';
        saObj.SA_Opposing_counsel_Phone__c = '2235';
        insert saObj;
            
        Test.startTest();
        
        	Attachment twrAttachObj = new Attachment();
            twrAttachObj.Name = 'Unit Test Attachment';
            twrAttachObj.body = Blob.valueOf('Unit Test Attachment Body');
            twrAttachObj.parentId = trialWitnessRequest.id;
            insert twrAttachObj;
        	
        	Attachment attachAppealObj = new Attachment();
            attachAppealObj.Name = 'Unit Test Attachment';
            attachAppealObj.body = Blob.valueOf('Unit Test Attachment Body');
            attachAppealObj.parentId = appealObj.id;
            insert attachAppealObj;
        
            Attachment attachSaObj = new Attachment();
            attachSaObj.Name = 'Unit Test Attachment';
            attachSaObj.body = Blob.valueOf('Unit Test Attachment Body');
            attachSaObj.parentId = saObj.id;
            insert attachSaObj;
            
            Attachment attachCC = new Attachment();
            attachCC.Name = 'Unit Test Attachment';
            attachCC.body = Blob.valueOf('Unit Test Attachment Body');
            attachCC.parentId = ccObj.id;
            insert attachCC;
            
            Attachment attachSA = new Attachment();
            attachSA.Name = 'Unit Test Attachment';
            attachSA.body = Blob.valueOf('Unit Test Attachment Body');
            attachSA.parentId = ccObj.id;
            insert attachSA;
            
            Attachment attachECM=new Attachment();
            attachECM.Name='Unit Test Attachment';
            attachECM.body = Blob.valueOf('Unit Test Attachment Body');
            attachECM.parentId = ecmObj.id;
            insert attachECM;
            
            Attachment attachPSA = new Attachment();
            attachPSA.Name = 'Unit Test Attachment';
            attachPSA.body = Blob.valueOf('Unit Test Attachment Body');
            attachPSA.parentId = psaObj.id;
            insert attachPSA;
            
            Attachment attachBRA = new Attachment();
            attachBRA.Name = 'Unit Test Attachment';
            attachBRA.body = Blob.valueOf('Unit Test Attachment Body');
            attachBRA.parentId = braObj.id;
            insert attachBRA;
            
            attachBRA.Name = 'Update Unit Test Attachment';
            update attachBRA;
            
            delete attachBRA;
            
        Test.stopTest();
    }
    
    @isTest
    static void CallMonitoring_UnitTest(){
               
        Account acc = new Account();
        acc.Firm_ID__c ='test';
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        insert acc;
        
        Contact con = new Contact(FirstName = 'testFname',LastName = 'test', AccountId = acc.Id,Community_User__c = true, Inactive_Contact__c = false);
        insert con;
 
       /* Profile p = [SELECT Id,name FROM Profile WHERE Name = 'Customer Community User'];
        User u = new User();
        u.Alias = 'testcm';
        u.Email='standard1user11cm@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingc1m';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='cm1@salesforce.com';
        u.ContactId = con.id;
        //u.AccountId = acc.id;
        u.IsActive = true;
        insert u;*/
         User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'CC - User Access'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'dsddsdjs@gmail.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ContactId = con.Id
        );
        insert u;
        
        Call_Monitoring__c callMonitoringObj = new Call_Monitoring__c(
            RecordTypeId =  Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId(),
            Organization_Name_CM__c = acc.Id,
            Account_Type_CM__c = 'MCM',
            Reporting_Month_CM__c = '04',
            Reporting_Year_CM__c = '2017',
            Attachments__c = false,
            Account_Number_CM__c = 'testcmNumb'
        );
        insert callMonitoringObj;
        
        Test.startTest();  
        
        Attachment attachment = new Attachment();
    	attachment.Name = 'Test';
    	Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
    	attachment.body = bodyBlob;
        attachment.ParentId = callMonitoringObj.Id;
        insert attachment;
        
        Test.stopTest();
        System.assert(true);
    }
}