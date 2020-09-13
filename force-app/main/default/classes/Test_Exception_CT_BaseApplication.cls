@isTest
public class Test_Exception_CT_BaseApplication{
    private static testMethod void testBaseApplication_NewException1()
    {
        String pSourceMethodName = 'TEST_METHOD_NAME';
        String pMessage = 'TEST_MESSAGE';
        String pUserFriendlyMessage = 'TEST_USER_FRIENDLY_MESSAGE';
        CT_BaseApplicationException bae = CT_BaseApplicationException.NewException(pSourceMethodName, pMessage, pUserFriendlyMessage);
        
        System.assertEquals(bae.Message, pMessage);
        System.assertEquals(bae.UserFriendlyMessage, pUserFriendlyMessage);
    }

    private static testMethod void testBaseApplication_NewException2()
    {
        String pSourceMethodName = 'TEST_METHOD_NAME';
        String pMessage = 'TEST_MESSAGE';
        
        CT_BaseApplicationException bae = CT_BaseApplicationException.NewException(pSourceMethodName, pMessage);
        
        System.assertEquals(bae.Message, pMessage);
        System.assertEquals(bae.UserFriendlyMessage, pMessage);
    }
    
    private static testMethod void testBaseApplication_WithInnerException1()
    {
        String pSourceMethodName = 'TEST_METHOD_NAME';
        String pMessage = 'TEST_MESSAGE';
        String pUserFriendlyMessage = 'TEST_USER_FRIENDLY_MESSAGE';
        try{
            Account acct = new Account();
            insert acct;
        }catch(Exception ex){
            CT_BaseApplicationException bae = CT_BaseApplicationException.NewExceptionWithInnerException(pSourceMethodName, ex.getMessage(), pUserFriendlyMessage, ex);
            
            System.assertNotEquals(bae.Message, pMessage);
            System.assertEquals(bae.UserFriendlyMessage, pUserFriendlyMessage);
        }
    }
    
    private static testMethod void testBaseApplication_WithInnerException2()
    {
        String pSourceMethodName = 'TEST_METHOD_NAME';
        String pMessage = 'TEST_MESSAGE';
        
        try{
            Account acct = new Account();
            insert acct;
        }catch(Exception ex){
            CT_BaseApplicationException bae = CT_BaseApplicationException.NewExceptionWithInnerException(pSourceMethodName, ex.getMessage(), ex);
            
            System.assertNotEquals(bae.Message, pMessage);
            System.assertEquals(bae.UserFriendlyMessage, bae.Message);
        }
    } 
}