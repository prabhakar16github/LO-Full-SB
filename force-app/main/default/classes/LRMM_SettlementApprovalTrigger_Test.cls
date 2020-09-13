@isTest
public class LRMM_SettlementApprovalTrigger_Test{
    
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
    
    public static testMethod void testSettlementApproval(){
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
        saObj.Settlement_Approval_Status__c = 'Pending Resolution';
        insert saObj;
        
        saObj = [SELECT SA_Resolution_Amount__c, SA_Resolution_Date__c, SA_Resolution_Notes__c, SA_Resolution_Payment_To__c, 
                        SA_Resolution_Type__c, Settlement_Approval_Status__c FROM Settlement_Approval__c WHERE id =: saObj.id];
        saObj.SA_Resolution_Amount__c = 121;
        saObj.SA_Resolution_Date__c = system.today();
        saObj.SA_Resolution_Notes__c = 'Test';
        saObj.SA_Resolution_Payment_To__c = 'ACF';
        saObj.SA_Resolution_Type__c = 'Arbitration';
        saObj.Settlement_Approval_Status__c = 'Closed';
        update saObj;
        
        saObj = [SELECT SA_Resolution_Amount__c, SA_Resolution_Date__c, SA_Resolution_Notes__c, SA_Resolution_Payment_To__c, 
                        SA_Resolution_Type__c, Settlement_Approval_Status__c FROM Settlement_Approval__c WHERE id =: saObj.id];
        saObj.SA_Resolution_Amount__c = null;
        saObj.SA_Resolution_Date__c = null;
        saObj.SA_Resolution_Notes__c = null;
        saObj.SA_Resolution_Payment_To__c = null;
        saObj.SA_Resolution_Type__c = null;
        saObj.Settlement_Approval_Status__c = 'Pending Resolution';
        update saObj;
    }
}