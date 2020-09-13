@isTest
public class Test_CT_ExceptionHandler{
    private static testMethod void test_GetExceptionDetailsAsString()
    {
        String pSourceMethodName = 'TEST_METHOD_NAME';
        String exceptionString = '';
        try{
            Account acct = new Account();
            insert acct;
        }
        catch(Exception ex)
        {
            exceptionString = CT_ExceptionHandler.GetExceptionDetailsAsString(ex);
            System.assert(exceptionString.contains('ERROR DETAILS'));
        }
    }
}