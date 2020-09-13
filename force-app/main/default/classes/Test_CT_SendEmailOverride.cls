/*
##########################################################################################################################################
# Project Name..........: LO - CT Test Class Re-Work
# File..................: Class : "Test_CT_SendEmailOverride"
# Version...............: 1.0
# Created by............: Sunny Kumar   
# Created Date..........: 26-Mar-2015
# Last Modified by......: Sunny Kumar
# Last Modified Date....: 26-Mar-2015                         
# Description...........: All CT_ Classes were failing due to OLD API and Badly Written their individual test Coverage. So, a re-work over test
                          Coverage has been done for all of them.
###########################################################################################################################################
*/


@isTest
public class Test_CT_SendEmailOverride{

public static testMethod void test_CT_SendEmailOverride_redirect() {
        ApexPages.StandardController controller = new ApexPages.StandardController(new Account(name='TEST ACCOUNT'));
        CT_SendEmailOverride attach = new CT_SendEmailOverride(controller);
        system.assert(attach != null);
        PageReference pr = attach.redirect();
        system.assert(pr != null);
    }


}