@isTest
private class RelatedCADForLRMMObjControllerTest {

    static testMethod void relatedCADForLRMMObjControllerTest() {
		
		// for test coverage we are only taking one schenario i.e. for appeal only
		
		Consumer_Master_File__c consumerMasterFile = new Consumer_Master_File__c();
        consumerMasterFile.Consumer_First_Name__c = 'Test First Name';
        consumerMasterFile.Consumer_Last_Name__c = 'Test Last Name';
        consumerMasterFile.Consumer_Middle_Name__c = 'Test Middle Name';
        consumerMasterFile.Date_of_Birth__c = System.today();
        consumerMasterFile.SSN__c = '999-99-9999';
        
        insert consumerMasterFile;
        
        Account accountObj = new Account(Name = 'Account Test Name');
        insert accountObj;
    	
    	
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
        
        
        insert cadToInsert1;
        
        Appeal__c appealObj = new Appeal__c();
        appealObj.AP_Account_Number__c='8547629453';
		appealObj.AP_Amount_of_Judgement__c=988765432; 
		appealObj.AP_Appeal_Status__c='Overdue'; 
		appealObj.AP_Assigned_Attorney_Cell_Phone__c='123456789';
		appealObj.AP_Assigned_Attorney_Direct_Line__c='123456789'; 
		appealObj.AP_Assigned_Attorney_Email__c='test@test.com'; 
		appealObj.AP_Assigned_Attorney__c='test'; 
		appealObj.AP_Attorney_Approval_Needed__c=false;
		appealObj.AP_Consumer_Account_Record__c=cadToInsert1.id;
		appealObj.AP_Could_this_Matter_Impact_Precedent__c='No'; 
		appealObj.AP_County_Court_Name__c='Test'; 
		appealObj.AP_County_Filed__c='Test'; 
		appealObj.AP_Court_File__c='123456789'; 
		appealObj.AP_Date_Notice_of_Appeal_Filed__c=Date.valueOf('2018-03-15'); 
		appealObj.AP_Firm_Recommendation_for_Client__c='Settle'; 
		appealObj.AP_Judge_Name__c='Test'; 
		appealObj.AP_Judgment_Entered_in_Favor_of__c='ACF'; 
		appealObj.AP_Matter_Name__c='Test'; 
		appealObj.AP_Name_of_Higher_Court_for_this_Appeal__c='asdfghjk'; 
		appealObj.AP_Name_of_Lower_Court__c='asdfghjk'; 
		appealObj.AP_Organization_Name__c=accountObj.id; 
		appealObj.AP_Prior_Experience_with_Judge__c='No'; 
		appealObj.AP_Summary_of_Precedential_Impact__c='qwertghjk'; 
		appealObj.AP_Type_of_Appeal__c='Interlocutory'; 
		appealObj.AP_Pro_Se__c=true; 
        
        insert appealObj;
        
        Test.startTest();
        
        Apexpages.StandardController stdController = new Apexpages.StandardController(appealObj);
        
        PageReference pageRef = Page.LRMM_AppealRelatedCAD;
        
        system.Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getparameters().put('cadId', cadToInsert1.Id);
        
        RelatedCADForLRMMObjController relatedObj = new RelatedCADForLRMMObjController(stdController);
        
        Test.stopTest();
		        
    }
}