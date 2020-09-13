/*
	* @ Class Name 		: 	LW_Re_Request_Controller_Test
 	* @ Description 	: 	Test Class for LW_Re_Request_Controller
 	* @ Created By 		: 	Prabhakar Joshi
 	* @ Created Date	: 	3-July-2020 
*/

@isTest
public class LW_Re_Request_Controller_Test {
	@isTest
    static void test1(){
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
        trialWitnessRequest.TW_Consumer_Account_Records__c = cadObj.Id;
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
        
        PageReference pg = Page.LW_Re_Request;
        ApexPages.currentPage().getParameters().put('recordId',trialWitnessRequest.Id);
        LW_Re_Request_Controller obj = new LW_Re_Request_Controller();
        obj.SaveNew();
        LW_Re_Request_Controller.saveNewRecord(JSON.serialize(trialWitnessRequest.clone(false,false,false,false)),trialWitnessRequest.Id);
        LW_Re_Request_Controller.saveNewRecord(JSON.serialize(trialWitnessRequest),trialWitnessRequest.Id);
    }
}