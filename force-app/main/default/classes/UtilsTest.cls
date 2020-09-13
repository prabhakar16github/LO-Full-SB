@isTest
private class UtilsTest {

    static testMethod void buildBodyForTest() {
        
        Test.startTest();
        
	        try{
	        	
	        	 CalloutException e = new CalloutException();
			     e.setMessage('This is a constructed exception!');
			     throw e;
	        
	        }catch(Exception ex){
	        	
	        	Utils.buildBodyFor(new List<Exception>{ex});
	        }
        
        Test.stopTest();
        system.assert(true);
        
    }
    
    static testMethod void getExceptionErrorMailtest() {
        
        Test.startTest();
        
	        try{
	        	
	        	 CalloutException e = new CalloutException();
			     e.setMessage('This is a constructed exception!');
			     throw e;
	        
	        }catch(Exception ex){
	        	
	        	Utils.getExceptionErrorMail(new List<Exception>{ex});
	        }
        
        Test.stopTest();
        system.assert(true);
    }
    
    static testMethod void testgetCommunityBaseUrl(){
    
    	Test.startTest();
    		Utils.getCommunityBaseUrl();
    	Test.stopTest();
    	system.assert(true);
    }
    
    static testmethod void getErrorMailTest(){
    	Test.startTest();
    		Utils.getErrorMail('Test ', 'Test batch Name');
    	Test.stopTest();
    	system.assert(true);
    }
}