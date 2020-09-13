@isTest
private class ConsumerAccountDetailTriggerHelperTest {

    static testMethod void beforeInsertUpdateConsumerAccountDetailTest() {
    	
    	Consumer_Master_File__c consumerMasterFile = new Consumer_Master_File__c();
        consumerMasterFile.Consumer_First_Name__c = 'Test First Name';
        consumerMasterFile.Consumer_Last_Name__c = 'Test Last Name';
        consumerMasterFile.Consumer_Middle_Name__c = 'Test Middle Name';
        consumerMasterFile.Date_of_Birth__c = System.today();
        consumerMasterFile.SSN__c = '999-99-9999';
        
        insert consumerMasterFile;
        
        String recordTypeId = Schema.SObjectType.Consumer_Account_Details__c.getRecordTypeInfosByName().get('CAD: MCM Individual Account Details').getRecordTypeId();
        
        Account accountObj = new Account(name = 'Name test account');
        insert accountObj;
        
        Test.startTest();
		 
		Consumer_Account_Details__c cadToInsert1 = new Consumer_Account_Details__c();
        
        cadToInsert1.Account_Balance__c = 1000;
        cadToInsert1.Account_Number__c = '187SDFGH';
        cadToInsert1.RecordTypeId = recordTypeId;
        cadToInsert1.Organization_name__c = accountObj.id;
        cadToInsert1.Chain_of_Title__c = 'Test';
        cadToInsert1.CAD_Consumer_Loan__c = true;
        cadToInsert1.Consumer_Master_File_Record__c = consumerMasterFile.Id;
        cadToInsert1.CAD_Credit_Card__c = false;
        cadToInsert1.CAD_Linked_Account__c = true;
        cadToInsert1.CAD_Linked_Master_CAD__c = true;
        cadToInsert1.Original_Creditor__c = 'test';
        cadToInsert1.Original_Creditor_Account_Number__c = '123456789976543';
        cadToInsert1.Placement_Date__c = System.today();
        cadToInsert1.Portfolio__c = '1960';
        
        insert cadToInsert1;
        
        Consumer_Account_Details__c cadToInsert2 = new Consumer_Account_Details__c();
        
        cadToInsert2.Account_Balance__c = 1000;
        cadToInsert2.Account_Number__c = '187SDoGH';
        cadToInsert2.RecordTypeId = recordTypeId;
        cadToInsert2.Organization_name__c = accountObj.id;
        cadToInsert2.Chain_of_Title__c = 'Test';
        cadToInsert2.CAD_Consumer_Loan__c = true;
        cadToInsert2.Consumer_Master_File_Record__c = consumerMasterFile.Id;
        cadToInsert2.CAD_Credit_Card__c = false;
        cadToInsert2.CAD_Linked_Account__c = true;
        cadToInsert2.CAD_Linked_Master_CAD__c = true;
        cadToInsert2.Original_Creditor__c = 'test';
        cadToInsert2.Original_Creditor_Account_Number__c = '123456789976543';
        cadToInsert2.Placement_Date__c = System.today();
        cadToInsert2.Portfolio__c = '1960';
        
        Boolean gotInsertException = false;
        Boolean gotUpdateException = false;
        
        try{
        	
	        insert cadToInsert2;
	        
        }catch(Exception ex){
        	
        	if(String.valueOf(ex.getMessage()).contains('already exists as the master CAD for this consumer having the same placement date and account type')){
	        	gotInsertException = true;
        	}
        }
        
    	try{
    		
    		cadToInsert2.CAD_Linked_Master_CAD__c = false;
    		insert cadToInsert2;
    		
        	Consumer_Account_Details__c cad4 = new Consumer_Account_Details__c(Id = cadToInsert2.Id, CAD_Linked_Master_CAD__c = true);  
        	update cad4;
        	
        	
        }catch(Exception ex){
        	
        	if(String.valueOf(ex.getMessage()).contains('already exists as the master CAD for this consumer having the same placement date and account type')){
	        	gotUpdateException = true;
        	}
        	
        }
        
        Test.stopTest();
        
        List<Consumer_Account_Details__c> newCadList = [SELECT Id, Name FROM Consumer_Account_Details__c WHERE Id = :cadToInsert2.Id];
        
        system.assertEquals(true, gotInsertException);
        system.assertEquals(true, gotUpdateException);
        Appeal__c ap = new Appeal__c();
        ap.AP_Consumer_Account_Record__c = cadToInsert2.Id;
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
        ConsumerAccountDetailTriggerHelper.updateResolutionField(newCadList);
    }
    
    
    static testMethod void afterInsertUpdateDeleteConsumerAccountDetailTest() {
    	
    	Consumer_Master_File__c consumerMasterFile = new Consumer_Master_File__c();
        consumerMasterFile.Consumer_First_Name__c = 'Test First Name';
        consumerMasterFile.Consumer_Last_Name__c = 'Test Last Name';
        consumerMasterFile.Consumer_Middle_Name__c = 'Test Middle Name';
        consumerMasterFile.Date_of_Birth__c = System.today();
        consumerMasterFile.SSN__c = '999-99-9999';
        
        insert consumerMasterFile;
        
        String recordTypeId = Schema.SObjectType.Consumer_Account_Details__c.getRecordTypeInfosByName().get('CAD: MCM Linked Account Details').getRecordTypeId();
        String recordTypeIdIndividual = Schema.SObjectType.Consumer_Account_Details__c.getRecordTypeInfosByName().get('CAD: MCM Individual Account Details').getRecordTypeId();
        
        Account accountObj = new Account(name = 'Name test account');
        insert accountObj;
        
        Test.startTest();
		 
		Consumer_Account_Details__c cadToInsert1 = new Consumer_Account_Details__c();
        
        cadToInsert1.Account_Balance__c = 1000;
        cadToInsert1.Account_Number__c = '187SDFGH';
        cadToInsert1.RecordTypeId = recordTypeIdIndividual;
        cadToInsert1.Organization_name__c = accountObj.id;
        cadToInsert1.Chain_of_Title__c = 'Test';
        cadToInsert1.CAD_Consumer_Loan__c = true;
        cadToInsert1.Consumer_Master_File_Record__c = consumerMasterFile.Id;
        cadToInsert1.CAD_Credit_Card__c = false;
        cadToInsert1.CAD_Linked_Account__c = true;
        cadToInsert1.CAD_Linked_Master_CAD__c = true;
        cadToInsert1.Original_Creditor__c = 'test';
        cadToInsert1.Original_Creditor_Account_Number__c = '123456789976543';
        cadToInsert1.Placement_Date__c = System.today();
        cadToInsert1.Portfolio__c = '1960';
        
        insert cadToInsert1;
        
        Consumer_Account_Details__c cadToInsert2 = new Consumer_Account_Details__c();
        
        cadToInsert2.Account_Balance__c = 1000;
        cadToInsert2.Account_Number__c = '187SDoGH';
        cadToInsert2.RecordTypeId = recordTypeId;
        cadToInsert2.Organization_name__c = accountObj.id;
        cadToInsert2.Chain_of_Title__c = 'Test';
        cadToInsert2.CAD_Consumer_Loan__c = true;
        cadToInsert2.Linked_Master_CAD_Account__c = cadToInsert1.Id;
        cadToInsert2.Consumer_Master_File_Record__c = consumerMasterFile.Id;
        cadToInsert2.CAD_Credit_Card__c = false;
        cadToInsert2.CAD_Linked_Account__c = true;
        cadToInsert2.CAD_Linked_Master_CAD__c = false;
        cadToInsert2.Original_Creditor__c = 'test';
        cadToInsert2.Original_Creditor_Account_Number__c = '123456789976543';
        cadToInsert2.Placement_Date__c = System.today();
        cadToInsert2.Portfolio__c = '1960';
        
        system.debug('cadToInsert1------------>'+cadToInsert1);
        system.debug('cadToInsert2------------>'+cadToInsert2);
        
        insert cadToInsert2;
        
        delete cadToInsert2;
        
        Test.stopTest();
        
        system.assert(true);
    }
}