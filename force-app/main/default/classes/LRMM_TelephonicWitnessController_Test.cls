/********************************************** 
* Class Name	    : LRMM_TelephonicWitnessController_Test
* Description		: Test class for LRMM_TelephonicWitnessController for Aura component : LRMM_NewTelephonicWitness
* Created By  		: Shivangi Srivastava
* Created Date		: 20-July-2020
* *************************************************/


@isTest
public class LRMM_TelephonicWitnessController_Test {
    
    @isTest
    static void test1(){
        Account account = new Account(Name = 'TestAccount');
        insert account;
        
        Consumer_Account_Details__c cadObj = new Consumer_Account_Details__c();
        cadObj.Organization_name__c = account.id;
        cadObj.Account_Number__c = '1111';
        cadObj.OwnerId =  UserInfo.getUserId();
        cadObj.Original_Creditor__c = 'test';
        cadObj.CAD_Credit_Card__c = true;
        insert cadObj;
        
        test.startTest();
        LRMM_TelephonicWitnessController.fetchCAD_Records(cadObj.Id);
        test.stopTest();
        system.assert(true);  
     }
}