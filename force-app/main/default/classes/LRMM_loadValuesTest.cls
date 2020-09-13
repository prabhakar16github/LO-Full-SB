@isTest
private class LRMM_loadValuesTest{
     static testMethod void myUnitTest() {
     	
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
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
        
        Consumer_Account_Details__c cad = new Consumer_Account_Details__c();
        cad.Organization_name__c = acc.id;
        cad.Account_Number__c = '111';
        cad.OwnerId =  UserInfo.getUserId();
        cad.Original_Creditor__c = 'test';
      
        insert cad;
        system.debug('====cad'+cad);

        Counterclaim__c cc = new Counterclaim__c();
        cc.CC_Organization_Name__c = acc.id;
        cc.CC_Matter_Name__c = 'test';
        cc.CC_Court_File__c = 'test';
        cc.CC_Account_Number__c = '124';
        cc.CC_County_Court_Name__c= 'test';
        cc.CC_Judge_Name__c = 'test';
        cc.CC_Prior_Experience_with_Judge__c = 'Yes';
        cc.CC_IfPriorExperience_with_Judge_Comments__c = 'test';
        cc.CC_Assigned_Attorney__c = 'test';
        cc.CC_Assigned_Attorney_Cell_Phone__c = '3463463464';
        cc.CC_Assigned_Attorney_Direct_Line__c = '74574';
        cc.CC_Assigned_Attorney_Email__c = 'ishan@gmail.com';
        cc.CC_Opposing_Counsel__c = 'test';
        cc.CC_Opposing_Counsel_Comments__c = 'test';
        cc.CC_Opposing_Counsel_Email__c = 'email@gmail.com';
        cc.CC_Opposing_Counsel_Firm_Name__c = 'test';
        cc.CC_Opposing_counsel_Phone__c = '34634';
	    cc.CC_Consumer_Account_Detail_Name__c = cad.id;    
	    cc.CC_Counterclaim_Status__c = 'New';
	    cc.OwnerId = UserInfo.getUserId();    
        insert cc;   
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cad);
        System.currentPageReference().getParameters().put('id', cad.id);
        
        LRMM_loadValues testCad = new LRMM_loadValues(sc);
        testCad.getdiscLIst();
        testCad.getccLIst();
        testCad.getTrialist();
        testCad.save();
        testCad.saveDisc();
        testCad.saveAppeal();
        testCad.saveSa(); 
        testCad.saveLiveWitness();
        testCad.getappealLIst();
        testCad.getSAList();
        testCad.savePSA();
        testCad.saveBRA();
        testCad.getBRAList();
        testCad.getPSAList();        
     }

     static testMethod void myUnitTest1() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User();
        u.Alias = 'ssa1';
        u.Email='standarduser12sak@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingsak1';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='sak11@salesforce.com';
        
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
        
        Consumer_Account_Details__c cad = new Consumer_Account_Details__c();
        cad.Organization_name__c = acc.id;
        cad.Account_Number__c = '111';
        cad.OwnerId =  UserInfo.getUserId();
      
        insert cad;
        system.debug('====cad'+cad);

        Appeal__c appeal1 = new Appeal__c();
        appeal1.AP_Organization_Name__c = acc.id;
        appeal1.AP_Consumer_Account_Record__c = cad.id;
        appeal1.AP_Matter_Name__c = 'test';
        appeal1.AP_Court_File__c = 'test';
        appeal1.AP_County_Court_Name__c = 'test';
        appeal1.AP_Account_Number__c = '111';
        appeal1.AP_Judge_Name__c = 'test';
        appeal1.AP_Prior_Experience_with_Judge__c = 'Yes';
        appeal1.AP_IfPriorExperience_with_Judge_Comments__c = 'test';
        appeal1.AP_County_Filed__c = 'test';
        appeal1.AP_Assigned_Attorney__c= 'test';
        appeal1.AP_Assigned_Attorney_Cell_Phone__c = '12412';
        appeal1.AP_Assigned_Attorney_Direct_Line__c = '2424';
        appeal1.AP_Assigned_Attorney_Email__c = 'ishan@gmail.com';
        appeal1.AP_Opposing_Counsel__c = '23523';
        appeal1.AP_Opposing_Counsel_Comments__c = 'test';
        appeal1.AP_Opposing_Counsel_Email__c = 'isan@gmail.com';
        appeal1.AP_Opposing_Counsel_Firm_Name__c = 'test';
        appeal1.AP_Opposing_counsel_Phone__c = '12412';

        insert appeal1;  
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cad);
     	System.currentPageReference().getParameters().put('id', cad.id);
        
        LRMM_loadValues testCad = new LRMM_loadValues(sc);
        testCad.getdiscLIst();
        testCad.getccLIst();
        testCad.getTrialist();
        testCad.save();
        testCad.saveDisc();
        testCad.saveAppeal();
        testCad.saveSa(); 
        testCad.saveLiveWitness();
        testCad.savePSA();
        testCad.saveBRA();
        testCad.getBRAList();
        testCad.getPSAList();        
     }
     
      static testMethod void myUnitTest2() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User();
        u.Alias = 'ssa2';
        u.Email='standarduser13sak@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingsak2';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='sak12@salesforce.com';
        
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
        
        Consumer_Account_Details__c cad = new Consumer_Account_Details__c();
        cad.Organization_name__c = acc.id;
        cad.Account_Number__c = '111';
        cad.OwnerId =  UserInfo.getUserId();
      
        insert cad;
        system.debug('====cad'+cad);

        Settlement_Approval__c s1 = new Settlement_Approval__c ();
         s1.SA_Organization_Name__c = acc.id;
         s1.SA_Consumer_Account_Details__c = cad.id;
         s1.SA_Matter_Name__c = 'test';
         s1.SA_Account_Number__c = '121';
         s1.SA_Court_File__c = 'test';
         s1.SA_County_Court_Name__c	= 'test';
         s1.SA_Judge_Name__c = 'test';
         s1.SA_Prior_Experience_with_Judge__c = 'Yes';
         s1.SA_IfPriorExperience_with_Judge_Comments__c	= 'test';
         s1.SA_Assigned_Attorney__c = 'test';
         s1.SA_Assigned_Attorney_Cell_Phone__c = '23523';
         s1.SA_Assigned_Attorney_Direct_Line__c = '23523';
         s1.SA_Assigned_Attorney_Email__c = 'ishan@gmail.com';
         s1.SA_Opposing_Counsel__c = 'test';
         s1.SA_Opposing_Counsel_Comments__c = 'test';
         s1.SA_Opposing_Counsel_Email__c = 'ishan@gmail.com';
         s1.SA_Opposing_Counsel_Firm_Name__c = 'test';
         s1.SA_Opposing_counsel_Phone__c = '2235';

         
         insert s1;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cad);
     	System.currentPageReference().getParameters().put('id', cad.id);
        
        LRMM_loadValues testCad = new LRMM_loadValues(sc);
        testCad.getdiscLIst();
        testCad.getccLIst();
        testCad.getTrialist();
        testCad.save();
        testCad.saveDisc();
        testCad.saveAppeal();
        testCad.saveSa(); 
        testCad.saveLiveWitness();
        testCad.savePSA();
        testCad.saveBRA();
        testCad.getBRAList();
        testCad.getPSAList();        
     }
     
      static testMethod void myUnitTest3() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User();
        u.Alias = 'ssa3';
        u.Email='standarduser14sak@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingsak3';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='sak13@salesforce.com';
        
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
        
        Consumer_Account_Details__c cad = new Consumer_Account_Details__c();
        cad.Organization_name__c = acc.id;
        cad.Account_Number__c = '111';
        cad.OwnerId =  UserInfo.getUserId();
      
        insert cad;
        system.debug('====cad'+cad);

        Discovery__c counter = new Discovery__c();
        counter.DY_Organization_Name__c = acc.id;
        counter.DY_Request_For_Admissions__c = true;
        counter.DY_Matter_Name__c = 'test';
        counter.DY_Account_Number__c = 'test';
        counter.DY_Court_File__c = 'test';
        counter.DY_County_Court_Name__c = 'test';
        counter.DY_Judge_Name__c = 'test';
        counter.DY_Prior_Experience_with_Judge__c = 'Yes';
        counter.DY_IfPriorExperience_with_Judge_Comments__c = 'test';
        counter.DY_Assigned_Attorney__c = 'test';
        counter.DY_Assigned_Attorney_Cell_Phone__c = '23523';
        counter.DY_Assigned_Attorney_Direct_Line__c = '34534';
        counter.DY_Assigned_Attorney_Email__c = 'i@gmail.com';
        counter.DY_Opposing_Counsel__c = 'test';
        counter.DY_Opposing_Counsel_Comments__c = 'test';
        counter.DY_Opposing_Counsel_Email__c = 'i@gmail.com';
        counter.DY_Opposing_Counsel_Firm_Name__c = 'test';
        counter.DY_Opposing_counsel_Phone__c = '235235';
        counter.DY_Consumer_Account_Details__c = cad.id;
        insert counter;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cad);
     	System.currentPageReference().getParameters().put('id', cad.id);
        
        LRMM_loadValues testCad = new LRMM_loadValues(sc);
        testCad.getdiscLIst();
        testCad.getccLIst();
        testCad.getTrialist();
        testCad.save();
        testCad.saveDisc();
        testCad.saveAppeal();
        testCad.saveSa(); 
        testCad.saveLiveWitness();
        testCad.savePSA();
        testCad.saveBRA();
        testCad.getBRAList();
        testCad.getPSAList();        
     }
     static testMethod void myUnitTest4() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User();
        u.Alias = 'ssa3';
        u.Email='standarduser14sak@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingsak3';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='sak13@salesforce.com';
        
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
        
        Consumer_Account_Details__c cad = new Consumer_Account_Details__c();
        cad.Organization_name__c = acc.id;
        cad.Account_Number__c = '111';
        cad.OwnerId =  UserInfo.getUserId();
      
        insert cad;
        
        Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName();
        Id rtLeadID =  rtMap.get('Live Witness Request Step I').getRecordTypeId();
        system.debug('====cad'+cad);
        Trial_Witness_Request__c TW = new Trial_Witness_Request__c();
        TW.Recordtypeid = rtLeadId;
        TW.OrganizationName__c = acc.id;
        TW.TW_Consumer_Account_Records__c = cad.id;
        insert TW;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cad);
     	System.currentPageReference().getParameters().put('id', cad.id);
        
        LRMM_loadValues testCad = new LRMM_loadValues(sc);
        testCad.getdiscLIst();
        testCad.getccLIst();
        testCad.getTrialist();
        testCad.save();
        testCad.saveDisc();
        testCad.saveAppeal();
        testCad.saveSa(); 
        testCad.saveLiveWitness();
        testCad.savePSA();
        testCad.saveBRA();
        testCad.getBRAList();
        testCad.getPSAList();        
     }
     static testMethod void myUnitTest5() {
     	
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User();
        u.Alias = 'ssa3';
        u.Email='standarduser14sak@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingsak3';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='sak13@salesforce.com';
        
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
        
        Consumer_Account_Details__c cad = new Consumer_Account_Details__c();
        cad.Organization_name__c = acc.id;
        cad.Original_Creditor__c = 'test';
        cad.Chain_of_Title__c = 'test';
        cad.Portfolio__c = 'test';
        cad.Account_Number__c = '111';
        cad.OwnerId =  UserInfo.getUserId();
      
        insert cad;
        
        Map<String,Schema.RecordTypeInfo> rtMap1 = Schema.SObjectType.Business_Record_Affidavit__c.getRecordTypeInfosByName();
        Id rtLeadID1 =  rtMap1.get('BRA: Record Type').getRecordTypeId();
        system.debug('====cad'+cad);
        Business_Record_Affidavit__c bfra = new Business_Record_Affidavit__c();
        bfra.Recordtypeid = rtLeadId1;
        bfra.BRA_Organization_Name__c = acc.id;
        bfra.BRA_Original_Creditor__c = 'test';
        bfra.BRA_Consumer_Account_Details_Record__c = cad.id;
        insert bfra;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cad);
     	System.currentPageReference().getParameters().put('id', cad.id);
        
        
        LRMM_loadValues testCad = new LRMM_loadValues(sc);
        testCad.getdiscLIst();
        testCad.getccLIst();
        testCad.getTrialist();
        testCad.save();
        testCad.saveDisc();
        testCad.saveAppeal();
        testCad.saveSa(); 
        testCad.saveLiveWitness();
        testCad.savePSA();
        testCad.saveBRA();
        testCad.getBRAList();
        testCad.getPSAList();        
     }
     static testMethod void myUnitTest6() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User();
        u.Alias = 'ssa3';
        u.Email='standarduser14sak@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingsak3';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='sak13@salesforce.com';
        
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
        
        Consumer_Account_Details__c cad = new Consumer_Account_Details__c();
        cad.Organization_name__c = acc.id;
        cad.Original_Creditor__c = 'test';
        cad.Chain_of_Title__c = 'test';
        cad.Portfolio__c = 'test';        
        cad.Account_Number__c = '111';
        cad.OwnerId =  UserInfo.getUserId();
      
        insert cad;
        
        Purchase_and_Sales_Agreement__c psa = new Purchase_and_Sales_Agreement__c();
        psa.PSA_Organization_Name__c = acc.id;
        psa.PSA_Portfolio__c = 'test';
        psa.PSA_Chain_of_Title__c = 'test';
        psa.PSA_Original_Creditor__c = 'test';
        psa.PSA_Consumer_Account_Detail_Name__c = cad.id;
        insert psa;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cad);
     	System.currentPageReference().getParameters().put('id', cad.id);
        
        LRMM_loadValues testCad = new LRMM_loadValues(sc);
        testCad.getdiscLIst();
        testCad.getccLIst();
        testCad.getTrialist();
        testCad.save();
        testCad.saveDisc();
        testCad.saveAppeal();
        testCad.saveSa(); 
        testCad.saveLiveWitness();
        testCad.savePSA();
        testCad.saveBRA();
        testCad.getBRAList();
        testCad.getPSAList();
     }    
       
}