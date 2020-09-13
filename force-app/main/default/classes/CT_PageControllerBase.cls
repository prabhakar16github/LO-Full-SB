/*
##########################################################################################################################################
# Project Name..........: LO - CT Test Class Re-Work
# File..................: Class : "CT_PageControllerBase"
# Version...............: 1.0
# Created by............: Sunny Kumar   
# Created Date..........: 26-Mar-2015
# Last Modified by......: Sunny Kumar
# Last Modified Date....: 26-Mar-2015                         
# Description...........: All CT_ Classes were failing due to OLD API and Badly Written their individual test Coverage. 
                          So, a re-work over test coverage has been done for all of them.
###########################################################################################################################################
*/



public virtual class CT_PageControllerBase
{
    public Boolean InErrorState {get; private set;}

    protected void InfoMessage(ApexPages.Severity pSeverity, String pMessage)
    {
        InErrorState = false;
        ApexPages.addMessage(new ApexPages.Message(pSeverity, pMessage));
    }

    protected void ErrorMessage(ApexPages.Severity pSeverity, String pMessage)
    {
        InErrorState = true;
        ApexPages.addMessage(new ApexPages.Message(pSeverity, pMessage));
    }
    
    protected void ErrorMessageFatal(String pMessage)
    {
        ErrorMessage(ApexPages.Severity.FATAL, pMessage);
    }
    
    protected void ErrorMessageInfo(String pMessage)
    {
        InfoMessage(ApexPages.Severity.INFO, pMessage);
    }

}