@isTest
public class LRMM_PSATrigger_Test{
    
    public static String createData(){
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
        insert cadObj;
        
        return cadObj.id;
    }
    
    public static testMethod void unitTest(){
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
        psaObj.PSA_PSA_Status__c = 'Pending Resolution';
        insert psaObj;
        
        psaObj = [SELECT PSA_Resolution_Amount__c, PSA_Resolution_Date__c, PSA_Resolution_Notes__c, PSA_Resolution_Payment_To__c, 
                        PSA_Resolution_Type__c, PSA_PSA_Status__c FROM Purchase_and_Sales_Agreement__c WHERE id =: psaObj.id];
        psaObj.PSA_Resolution_Amount__c = 121;
        psaObj.PSA_Resolution_Date__c = system.today();
        psaObj.PSA_Resolution_Notes__c = 'Test';
        psaObj.PSA_Resolution_Payment_To__c = 'ACF';
        psaObj.PSA_Resolution_Type__c = 'Arbitration';
        psaObj.PSA_PSA_Status__c = 'Closed';
        update psaObj;
        
        psaObj = [SELECT PSA_Resolution_Amount__c, PSA_Resolution_Date__c, PSA_Resolution_Notes__c, PSA_Resolution_Payment_To__c, 
                        PSA_Resolution_Type__c, PSA_PSA_Status__c FROM Purchase_and_Sales_Agreement__c WHERE id =: psaObj.id];
        psaObj.PSA_Resolution_Amount__c = null;
        psaObj.PSA_Resolution_Date__c = null;
        psaObj.PSA_Resolution_Notes__c = null;
        psaObj.PSA_Resolution_Payment_To__c = null;
        psaObj.PSA_Resolution_Type__c = null;
        psaObj.PSA_PSA_Status__c = 'Pending Resolution';
        update psaObj;
    }
}