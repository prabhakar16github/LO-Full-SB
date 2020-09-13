/*
##########################################################################################################################################
# Project Name..........: LO - CT Test Class Re-Work
# File..................: Class : "CT_ExceptionHandler"
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
//@description : class to ...
public with sharing class CT_ExceptionHandler
{
    final static String CLASSNAME = 'CT_ExceptionHandler.METHODNAME()';

    //@author : CloudTrigger, Inc.
    //@date : 1/18/2012
    //@description : method to ...
    //@paramaters : an Exception
    //@returns : a string containing the details for an Exception
    public static String GetExceptionDetailsAsString(Exception ex)
    {
        final string METHODNAME = CLASSNAME.replace('METHODNAME','GetExceptionDetailsAsString');
        CT_StringBuilder sb = CT_StringBuilder.NewStringBuilder();

        sb.Append(GetCommonExceptionDetails(ex));
        sb.Append(GetSpecificExceptionDetails(ex)); 

        // TODO: make sure that call to GetSpecificExceptionDetails() does NOT cause an infinite loop until crashes with a limit exception.
        
        if (ex.getCause() != null)      
            sb.Append(GetExceptionDetailsAsString(ex.getCause()));
        
        String ss = sb.AsString();
        if(ss.contains('ERROR DETAILS')==false){
            CT_StringBuilder sb2 = CT_StringBuilder.NewWithFirstValue('\n\n******************************************************************************************************');
            sb2.Append('\n          ERROR DETAILS          ');
            sb2.Append('\n******************************************************************************************************\n');
            sb2.Append(ss + '\n');
            sb2.Append('\n******************************************************************************************************\n');
    
            return sb2.AsString();
        }else{
            return ss;
        }
    }
    
    //@author : CloudTrigger, Inc.
    //@date : 1/18/2012
    //@description : method to ...
    //@paramaters : an Exception
    //@returns : a string containing the details for an Exception
    private static String GetCommonExceptionDetails(Exception ex)
    {
        final string METHODNAME = CLASSNAME.replace('METHODNAME','GetCommonExceptionDetails');
        CT_StringBuilder sb = CT_StringBuilder.NewStringBuilder();
        
        sb.AppendLine(' EXCEPTION : \nMessage: ' + ex.getMessage());
        sb.AppendLine('Source Exception Type: ' + ex.getTypeName());
        sb.AppendLine('Line Number: ' + String.valueof(ex.getLineNumber()));
        sb.AppendLine('Stack Trace: ');
        sb.AppendLine(ex.getStackTraceString());
        
        return sb.asString();
    }

    //@author : CloudTrigger, Inc.
    //@date : 1/18/2012
    //@description : method to ...
    //@paramaters : an Exception
    //@returns : a string containing the details for an Email Exception or a DML Exception
    private static String GetDmlEmailExceptionDetailsAsString(System.Exception ex)
    {
        final string METHODNAME = CLASSNAME.replace('METHODNAME','GetDmlEmailExceptionDetailsAsString');
        if (ex instanceof DmlException)
            ex = (DmlException)ex;
        else if (ex instanceof EmailException)
            ex = (EmailException)ex;
                 
        CT_StringBuilder sb = CT_StringBuilder.NewStringBuilder();
        
        // build message with all errors
        for (Integer i = 0; i < ex.getNumDml(); i++)
        {              
            sb.AppendLine('Exception Message: ' + ex.getDmlMessage(i));
            
            sb.Append('Field Names: ');
            for(String s : ex.getDmlFieldNames(i))
            {
                sb.Append(s + '; ');
            }
            sb.AppendLine('');
            
            sb.AppendLine('Status Code: ' + ex.getDmlType(i));                      
        }
        return sb.asString();
    }

    //@author : CloudTrigger, Inc.
    //@date : 1/18/2012
    //@description : method to ...
    //@paramaters : an Exception
    //@returns : a string containing the details for an Exception
    private static String GetSpecificExceptionDetails(Exception pException)
    {
        final string METHODNAME = CLASSNAME.replace('METHODNAME','GetSpecificExceptionDetails');
        
        String errMessage = '';
        String Details = '';
        
        if(pException instanceof System.Dmlexception)
        {
            Details = GetDmlEmailExceptionDetailsAsString(pException);
        }
        else if(pException instanceof System.Emailexception)
        {
            Details = GetDmlEmailExceptionDetailsAsString(pException);
        }/*
        else if (pException instanceof CT_BaseApplicationException)
        {
            //Details = ((CT_BaseApplicationException)pException).GetSpecificExceptionDetails();
            Details = ((CT_BaseApplicationException)pException).Message;
        }*/
        return Details;
    }




/* =============================================  TEST METHODS  =============================================

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
    
   */  
    
}