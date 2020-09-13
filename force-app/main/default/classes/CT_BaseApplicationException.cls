/*
##########################################################################################################################################
# Project Name..........: LO - CT Test Class Re-Work
# File..................: Class : "CT_BaseApplicationException"
# Version...............: 1.0
# Created by............: Sunny Kumar   
# Created Date..........: 26-Mar-2015
# Last Modified by......: Sunny Kumar
# Last Modified Date....: 26-Mar-2015                         
# Description...........: All CT_ Classes were failing due to OLD API and Badly Written their individual test Coverage. 
                          So, a re-work over test coverage has been done for all of them.
###########################################################################################################################################
*/



//@author : CloudTrigger, Inc.
//@date : 1/18/2012
//@description :    class to extend the Exception class and provide the user the ability to throw custom exceptions 
//                  related to business rules, etc.; supports user-defined error messages as well as "user-friendly" error messages
global virtual class CT_BaseApplicationException extends Exception
{
    final String CLASSNAME = 'CT_BaseApplicationException.METHODNAME()';
    
    public String UserFriendlyMessage{get; set;}
    public String Message
    {
        get
        {
            return this.getMessage();
        }
    }

    private String privateMethodName;
    public String SourceMethodName
    {
        get
        {
            return privateMethodName; 
        }
        set
        {
            privateMethodName = value.Replace('*','').Replace(' ','');
        }
    }

    //@author : CloudTrigger, Inc.
    //@date : 1/18/2012
    //@description : method to ...
    //@paramaters : 
    //@returns : 
    protected CT_BaseApplicationException(String pSourceMethodName, String pMessage)
    {
        this.SourceMethodName = pSourceMethodName;
        this.setMessage(pMessage);      
    } 
    
    //@author : CloudTrigger, Inc.
    //@date : 1/18/2012
    //@description : method to ...
    //@paramaters : 
    //@returns : 
    protected CT_BaseApplicationException(String pSourceMethodName, String pMessage, Exception pException)
    {
        this(pSourceMethodName, pMessage);
        this.initCause(pException);
    }
    
    //@author : CloudTrigger, Inc.
    //@date : 1/18/2012
    //@description : method to ...
    //@paramaters : 
    //@returns : 
    public static CT_BaseApplicationException NewException(String pSourceMethodName, String pMessage, String pUserFriendlyMessage)
    {
        CT_BaseApplicationException bae = new CT_BaseApplicationException(pSourceMethodName,pMessage);
        bae.UserFriendlyMessage = pUserFriendlyMessage;
        bae.LogException();
        return bae;
    }

    //@author : CloudTrigger, Inc.
    //@date : 1/18/2012
    //@description : method to ...
    //@paramaters : 
    //@returns : 
    public static CT_BaseApplicationException NewException(String pSourceMethodName, String pMessage)
    {
        return CT_BaseApplicationException.NewException(pSourceMethodName, pMessage, pMessage);
    }
    
    //@author : CloudTrigger, Inc.
    //@date : 1/18/2012
    //@description : method to ...
    //@paramaters : 
    //@returns : 
    public static CT_BaseApplicationException NewExceptionWithInnerException(String pSourceMethodName, String pMessage, Exception pException)
    {
        return CT_BaseApplicationException.NewExceptionWithInnerException(pSourceMethodName, pMessage, pMessage, pException);
    }
    
    //@author : CloudTrigger, Inc.
    //@date : 1/18/2012
    //@description : method to ...
    //@paramaters : 
    //@returns : 
    public static CT_BaseApplicationException NewExceptionWithInnerException(String pSourceMethodName, String pMessage, String pUserFriendlyMessage, Exception pException)
    {
        CT_BaseApplicationException bae = new CT_BaseApplicationException(pSourceMethodName, pMessage, pException);
        bae.UserFriendlyMessage = pUserFriendlyMessage;
        bae.LogException();
        return bae;
    }

    //@author : CloudTrigger, Inc.
    //@date : 1/18/2012
    //@description : method to ...
    //@paramaters : none
    //@returns : nothing
    public virtual void LogException()
    {
        final string METHODNAME = CLASSNAME.replace('METHODNAME','LogException');
        try
        {
            //system.Debug(LoggingLevel.INFO, '\n\n' + METHODNAME + ' :: Gathering Exception Details\n\n');
            String errorDetails = this.SourceMethodName + ' :: ' + CT_ExceptionHandler.GetExceptionDetailsAsString(this);
           
            CT_StringBuilder sb = CT_StringBuilder.NewWithFirstValue('\n\n******************************************************************************************************');
            sb.Append('\n          ERROR DETAILS          ');
            sb.Append('\n******************************************************************************************************\n');
            sb.Append('\n' + errorDetails + '\n');
            sb.Append('\n\n******************************************************************************************************\n\n');
            system.Debug(LoggingLevel.INFO, sb.AsString());
        }
        catch (Exception ex)
        {
            // TODO
        } 
        //system.Debug(LoggingLevel.INFO, '\n\n' + METHODNAME + ' :: Gathering Exception Details\n\n');
        //system.Debug(LoggingLevel.INFO, CT_ExceptionHandler.GetExceptionDetailsAsString(this));
    }
    
    //@author : CloudTrigger, Inc.
    //@date : 1/18/2012
    //@description : method to ...
    //@paramaters : 
    //@returns : 
    public virtual String GetExceptionDetailsAsString()
    {
        final string METHODNAME = CLASSNAME.replace('METHODNAME','GetExceptionDetailsAsString');
        return '';
    }

/* =============================================  TEST METHODS  ============================================= 

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
    
    */

}