@isTest
private class LC_FirmScorecardExportTest {

    static testMethod void LC_FirmScorecardExportTest() 
    {
    	
    	Account acc = new Account();
    	
    	acc.Firm_ID__c = 'test';
        acc.Name = 'Test1';
        acc.Phone = '34354345';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        
        insert acc;
        
        List<Firm_Scorecard__c> firmlist = new List<Firm_Scorecard__c>();
        
         Firm_Scorecard__c fms = new Firm_Scorecard__c();
        
         fms.Name = 'test';
         fms.Organization_Name__c = acc.id;
         firmlist.add(fms);
        
        
        Firm_Scorecard__c fms1 = new Firm_Scorecard__c();
        
        fms1.Name = 'test1';
        fms1.Organization_Name__c = acc.id;
        firmlist.add(fms1);
        
        insert firmlist;
        
        Apexpages.currentPage().getParameters().put('id',acc.Id);
        LC_FirmScorecardInternalReportController ctrl = new LC_FirmScorecardInternalReportController();
   
        
    }
}