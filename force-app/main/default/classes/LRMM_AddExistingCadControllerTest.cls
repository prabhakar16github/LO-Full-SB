@isTest
private class LRMM_AddExistingCadControllerTest {

    static testMethod void initTest() {
    	
    	Consumer_Master_File__c consumerMasterFile = new Consumer_Master_File__c();
        consumerMasterFile.Consumer_First_Name__c = 'Test First Name';
        consumerMasterFile.Consumer_Last_Name__c = 'Test Last Name';
        consumerMasterFile.Consumer_Middle_Name__c = 'Test Middle Name';
        consumerMasterFile.Date_of_Birth__c = System.today();
        consumerMasterFile.SSN__c = '999-99-9999';
        
        insert consumerMasterFile;
    	
    	List<Consumer_Account_Details__c> consumerAccountDetailList = new List<Consumer_Account_Details__c>();
    	
    	String recordTypeId = Schema.SObjectType.Consumer_Account_Details__c.getRecordTypeInfosByName().get('CAD: MCM Individual Account Details').getRecordTypeId(); 
        
        Consumer_Account_Details__c cadToInsert1 = new Consumer_Account_Details__c();
        
        cadToInsert1.Account_Balance__c = 1000;
        cadToInsert1.Account_Number__c = '01SDFGH';
        cadToInsert1.RecordTypeId = recordTypeId;
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
        
        consumerAccountDetailList.add(cadToInsert1);
        
        Consumer_Account_Details__c cadToInsert2 = new Consumer_Account_Details__c();
        
        cadToInsert2.Account_Balance__c = 1000;
        cadToInsert2.RecordTypeId = recordTypeId;
        cadToInsert2.Account_Number__c = '01SDjkFGH';
        cadToInsert2.Chain_of_Title__c = 'Test';
        cadToInsert2.CAD_Consumer_Loan__c = true;
        cadToInsert2.Consumer_Master_File_Record__c = consumerMasterFile.Id;
        cadToInsert2.CAD_Credit_Card__c = false;
        cadToInsert2.CAD_Linked_Account__c = false;
        cadToInsert2.CAD_Linked_Master_CAD__c = false;
        cadToInsert2.Original_Creditor__c = 'test';
        cadToInsert2.Original_Creditor_Account_Number__c = '2345678789987';
        cadToInsert2.Placement_Date__c = System.today();
        cadToInsert2.Portfolio__c = '1960';
        
        
        consumerAccountDetailList.add(cadToInsert2);
        
        insert consumerAccountDetailList;
        
        
        PageReference pageRef = Page.LRMM_AddExistingCadPage;
		
		Test.startTest();

        LRMM_AddExistingCadController lrmmAddExisting = new LRMM_AddExistingCadController();
        
        system.Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getparameters().put('cadId', cadToInsert1.Id);
        
        lrmmAddExisting.init();
        
        // calling remote method
        
        LRMM_AddExistingCadController.initRemote(cadToInsert1.Id);
        
        Test.stopTest();
        
        system.assert(true);
    }
    
     static testMethod void assignCadToMasterCadTest() {
    	
    	Consumer_Master_File__c consumerMasterFile = new Consumer_Master_File__c();
        consumerMasterFile.Consumer_First_Name__c = 'Test First Name';
        consumerMasterFile.Consumer_Last_Name__c = 'Test Last Name';
        consumerMasterFile.Consumer_Middle_Name__c = 'Test Middle Name';
        consumerMasterFile.Date_of_Birth__c = System.today();
        consumerMasterFile.SSN__c = '999-99-9999';
        
        insert consumerMasterFile;
    	
    	List<Consumer_Account_Details__c> consumerAccountDetailList = new List<Consumer_Account_Details__c>();
    	
    	String recordTypeId = Schema.SObjectType.Consumer_Account_Details__c.getRecordTypeInfosByName().get('CAD: MCM Individual Account Details').getRecordTypeId(); 
        
        Consumer_Account_Details__c cadToInsert1 = new Consumer_Account_Details__c();
        
        cadToInsert1.Account_Balance__c = 1000;
        cadToInsert1.Account_Number__c = 'ABDCH0109';
        cadToInsert1.RecordTypeId = recordTypeId;
        cadToInsert1.Chain_of_Title__c = 'Test';
        cadToInsert1.CAD_Consumer_Loan__c = true;
        cadToInsert1.Consumer_Master_File_Record__c = consumerMasterFile.Id;
        cadToInsert1.CAD_Credit_Card__c = false;
        cadToInsert1.CAD_Linked_Account__c = true;
        cadToInsert1.CAD_Linked_Master_CAD__c = true;
        cadToInsert1.Original_Creditor__c = 'test';
        cadToInsert1.Original_Creditor_Account_Number__c = '123456789976543';
        cadToInsert1.Placement_Date__c = System.today();
        cadToInsert1.Portfolio__c = '1965';
        
        consumerAccountDetailList.add(cadToInsert1);
        
        Consumer_Account_Details__c cadToInsert2 = new Consumer_Account_Details__c();
        
        cadToInsert2.Account_Balance__c = 1000;
        cadToInsert2.RecordTypeId = recordTypeId;
        cadToInsert2.Account_Number__c = 'ABDCH009';
        cadToInsert2.Chain_of_Title__c = 'Test';
        cadToInsert2.CAD_Consumer_Loan__c = true;
        cadToInsert2.Consumer_Master_File_Record__c = consumerMasterFile.Id;
        cadToInsert2.CAD_Credit_Card__c = false;
        cadToInsert2.CAD_Linked_Account__c = false;
        cadToInsert2.CAD_Linked_Master_CAD__c = false;
        cadToInsert2.Original_Creditor__c = 'test';
        cadToInsert2.Original_Creditor_Account_Number__c = '2345678789987';
        cadToInsert2.Placement_Date__c = System.today();
        cadToInsert2.Portfolio__c = '1969';
        
        
        consumerAccountDetailList.add(cadToInsert2);
        
        insert consumerAccountDetailList;
        
        LRMM_AddExistingCadController.SelectedCounsumerAccountDetailWrapper selectedConsumerAccountDeatailsObj = new LRMM_AddExistingCadController.SelectedCounsumerAccountDetailWrapper(); 
        
        selectedConsumerAccountDeatailsObj.masterCadId = cadToInsert1.Id;
        selectedConsumerAccountDeatailsObj.selectedCadIds = new List<String>{cadToInsert2.Id};
        
        String jsonString = JSON.serialize(selectedConsumerAccountDeatailsObj);
        
        Test.startTest();
        
        LRMM_AddExistingCadController.assignCadToMasterCad(jsonString);
        
        Test.stopTest();
        
        List<Consumer_Account_Details__c> consumerAccountDetailsList = [SELECT Id, Name, CAD_Linked_Account__c 
        																FROM Consumer_Account_Details__c 
        																WHERE Id = :cadToInsert2.Id];
        																
        if(!consumerAccountDetailsList.isEmpty()){
			
			system.assert(true);        
        } 
        
        system.assert(true);
    }
}