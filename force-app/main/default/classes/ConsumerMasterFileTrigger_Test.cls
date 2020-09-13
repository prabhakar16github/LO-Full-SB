@isTest
public class ConsumerMasterFileTrigger_Test 
{
		@isTest
    static void test()
    {
        Test.startTest();       
        
            Trigger_Setting__c ts = new Trigger_Setting__c();
            ts.Name = 'ConsumerMasterFileTrigger';
            ts.Active__c = true;
            insert ts;
	    	State_Profile__c SP = new State_Profile__c();
	    	SP.Name = 'test';
	    	SP.State_NPV_Group__c	= 'Medium';
	    	Insert SP;
	    	
	 
	    insert new Consumer_Master_File__c(Name = 'HR',Consumer_First_Name__c = 'test', Consumer_Last_Name__c='Target', Date_of_Birth__c=system.today(), SSN__c = '999-99-9999');
	    assertErrorOnInsert(
	            new Consumer_Master_File__c(Name = 'HR',Consumer_First_Name__c = 'test', Consumer_Last_Name__c='Target', Date_of_Birth__c=system.today(), SSN__c = '999-99-9999'),
	            Label.ErrorMessage
	            ); 
	    Test.stopTest();   
    }
    
    private static void assertErrorOnInsert(SObject sob, String expected) {
    try 
        {
	        insert sob;
	        System.assert(false, 'A Consumer Master File record already exists for a Consumer with the same first & last name, DOB and SSN. ' + sob);
        } 
        catch (Exception e) 
        {
        	System.assert(e.getMessage().contains(expected), 'message=' + e.getMessage());
        }       
    }
}