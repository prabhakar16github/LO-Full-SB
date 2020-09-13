@isTest
private class LRMM_CADRelatedRecordsController_Test{
    
    private static String createData(){
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
        
        return cadObj.id;
    }
    
    private static testMethod void testAppeal(){
        Consumer_Account_Details__c cadObj = [SELECT Organization_name__c FROM Consumer_Account_Details__c WHERE id =: createData()];
        
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
        
        System.currentPageReference().getParameters().put('id', cadObj.id);
        System.currentPageReference().getParameters().put('objectType', String.valueOf(appealObj.id).substring(0,3));
        
        LRMM_CADRelatedRecordsController CADRelatedObj = new LRMM_CADRelatedRecordsController();
        CADRelatedObj.saveRecord();
    }
    
    private static testMethod void testCounterClaim(){
        Consumer_Account_Details__c cadObj = [SELECT Organization_name__c FROM Consumer_Account_Details__c WHERE id =: createData()];
        
        Counterclaim__c ccObj = new Counterclaim__c();
        ccObj.CC_Organization_Name__c = cadObj.Organization_name__c;
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
        ccObj.CC_Consumer_Account_Detail_Name__c = cadObj.id;    
        ccObj.CC_Counterclaim_Status__c = 'New';
        ccObj.OwnerId = UserInfo.getUserId();    
        insert ccObj;   
        
        
        System.currentPageReference().getParameters().put('id', cadObj.id);
        System.currentPageReference().getParameters().put('objectType', String.valueOf(ccObj.id).substring(0,3));
        
        LRMM_CADRelatedRecordsController CADRelatedObj = new LRMM_CADRelatedRecordsController();
        CADRelatedObj.saveRecord();
    }
    
    private static testMethod void testSettlementApproval(){
        Consumer_Account_Details__c cadObj = [SELECT Organization_name__c FROM Consumer_Account_Details__c WHERE id =: createData()];
        
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
        
        System.currentPageReference().getParameters().put('id', cadObj.id);
        System.currentPageReference().getParameters().put('objectType', String.valueOf(saObj.id).substring(0,3));
        
        LRMM_CADRelatedRecordsController CADRelatedObj = new LRMM_CADRelatedRecordsController();
        CADRelatedObj.saveRecord();
    }
    
    private static testMethod void testDiscovery(){
        Consumer_Account_Details__c cadObj = [SELECT Organization_name__c FROM Consumer_Account_Details__c WHERE id =: createData()];
        
        Discovery__c discoveryObj = new Discovery__c();
        discoveryObj.DY_Organization_Name__c = cadObj.Organization_name__c;
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
        
        System.currentPageReference().getParameters().put('id', cadObj.id);
        System.currentPageReference().getParameters().put('objectType', String.valueOf(discoveryObj.id).substring(0,3));
        
        LRMM_CADRelatedRecordsController CADRelatedObj = new LRMM_CADRelatedRecordsController();
        CADRelatedObj.saveRecord();
    }
    
    private static testMethod void testTrialWitess(){
        Consumer_Account_Details__c cadObj = [SELECT Organization_name__c FROM Consumer_Account_Details__c WHERE id =: createData()];
        
        Trial_Witness_Request__c trialWitnessObj = new Trial_Witness_Request__c();
        trialWitnessObj.Recordtypeid = Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName().get('Live Witness Request Step I').getRecordTypeId();
        trialWitnessObj.OrganizationName__c = cadObj.Organization_name__c;
        trialWitnessObj.TW_Consumer_Account_Records__c = cadObj.id;
        trialWitnessObj.Opposing_Counsel__c = 'test';
        trialWitnessObj.Opposing_Counsel_Comments__c = 'test';
        trialWitnessObj.Opposing_Counsel_Email__c = 'i@gmail.com';
        trialWitnessObj.Opposing_Counsel_Firm_Name__c = 'test';
        trialWitnessObj.Opposing_counsel_Phone__c = '235235';
        
        insert trialWitnessObj;
        
        System.currentPageReference().getParameters().put('id', cadObj.id);
        System.currentPageReference().getParameters().put('objectType', String.valueOf(trialWitnessObj.id).substring(0,3));
        
        LRMM_CADRelatedRecordsController CADRelatedObj = new LRMM_CADRelatedRecordsController();
        CADRelatedObj.saveRecord();
    }
    
    private static testMethod void testBRA(){
        Consumer_Account_Details__c cadObj = [SELECT Organization_name__c FROM Consumer_Account_Details__c WHERE id =: createData()];
        
        Business_Record_Affidavit__c braObj = new Business_Record_Affidavit__c();
        braObj.Recordtypeid = Schema.SObjectType.Business_Record_Affidavit__c.getRecordTypeInfosByName().get('BRA: Record Type').getRecordTypeId();
        braObj.BRA_Organization_Name__c = cadObj.Organization_name__c;
        braObj.BRA_Original_Creditor__c = 'test';
        braObj.BRA_Consumer_Account_Details_Record__c = cadObj.id;
        braObj.BRA_Opposing_Counsel__c = 'test';
        braObj.BRA_Opposing_Counsel_Comments__c = 'test';
        braObj.BRA_Opposing_Counsel_Email__c = 'i@gmail.com';
        braObj.BRA_Opposing_Counsel_Firm_Name__c = 'test';
        braObj.BRA_Opposing_counsel_Phone__c = '235235';
        
        insert braObj;
        
        System.currentPageReference().getParameters().put('id', cadObj.id);
        System.currentPageReference().getParameters().put('objectType', String.valueOf(braObj.id).substring(0,3));
        
        LRMM_CADRelatedRecordsController CADRelatedObj = new LRMM_CADRelatedRecordsController();
        CADRelatedObj.saveRecord();
    }
    
    private static testMethod void testPSA(){
        Consumer_Account_Details__c cadObj = [SELECT Organization_name__c FROM Consumer_Account_Details__c WHERE id =: createData()];
        
        Purchase_and_Sales_Agreement__c psaObj = new Purchase_and_Sales_Agreement__c();
        psaObj.PSA_Organization_Name__c = cadObj.Organization_name__c;
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
        
        System.currentPageReference().getParameters().put('id', cadObj.id);
        System.currentPageReference().getParameters().put('objectType', String.valueOf(psaObj.id).substring(0,3));
        
        LRMM_CADRelatedRecordsController CADRelatedObj = new LRMM_CADRelatedRecordsController();
        CADRelatedObj.saveRecord();
    }
    
    private static testMethod void testECM(){
        Consumer_Account_Details__c cadObj = [SELECT Organization_name__c FROM Consumer_Account_Details__c WHERE id =: createData()];
        
        Escalated_Contested_Matters__c ecmObj = new Escalated_Contested_Matters__c();
        ecmObj.ECM_Organization_Name__c = cadObj.Organization_name__c;
        ecmObj.ECM_Consumer_Account_Detail_Name__c = cadObj.id;
        ecmObj.ECM_Opposing_Counsel__c = 'test';
        ecmObj.ECM_Opposing_Counsel_Comments__c = 'test';
        ecmObj.ECM_Opposing_Counsel_Email__c = 'i@gmail.com';
        ecmObj.ECM_Opposing_Counsel_Firm_Name__c = 'test';
        ecmObj.ECM_Opposing_counsel_Phone__c = '235235';
        insert ecmObj;
        
        System.currentPageReference().getParameters().put('id', cadObj.id);
        System.currentPageReference().getParameters().put('objectType', String.valueOf(ecmObj.id).substring(0,3));
        
        LRMM_CADRelatedRecordsController CADRelatedObj = new LRMM_CADRelatedRecordsController();
        CADRelatedObj.saveRecord();
    }
}