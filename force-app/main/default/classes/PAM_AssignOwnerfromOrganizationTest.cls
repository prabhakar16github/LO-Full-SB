@isTest
private class PAM_AssignOwnerfromOrganizationTest {

    static testMethod void PAM_AssignOwnerfromOrganizationTest() {
    	
    	Account acc = new Account();
    	
    	acc.Firm_ID__c ='test';
    	acc.Name = 'test1';
    	acc.Phone = '98828383';
    	acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        
        insert acc;
        
        
        Contact con = new Contact();
        
        con.LastName = 'test';
        con.AccountId = acc.id;
        con.Phone = '023823233';
        con.Email = 'test@gmail.com';
        con.Inactive_Contact__c = false;
        insert con;
        
        Process_Adherence_Monitoring__c pam = new Process_Adherence_Monitoring__c();
        
        pam.Organization_Name__c = acc.id;
        pam.Inactive_Owner__c = False;
        
        
        insert pam;
        
    }
}