/*
##########################################################################################################################################
# Project Name..........: LO - CT Test Class Re-Work
# File..................: Class : "Test_CT_StringBuilder"
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
public class Test_CT_StringBuilder{

 public static testMethod void testStringBuilder1()
    {
        CT_StringBuilder sb = CT_StringBuilder.NewStringBuilder();
        sb.Append('HAPPY HOLIDAYS!');
        System.assertNotEquals(sb.AsString(), '');
        System.assertNotEquals(sb.AsString(), null);
    }
    
    public static testMethod void testStringBuilder2()
    {
        CT_StringBuilder sb = CT_StringBuilder.NewWithFirstValue('THIS IS A TEST FOR CLOUDTRIGGER');
        sb.Append('This is the second line');
        System.assertNotEquals(sb.AsString(), '');
        System.assertNotEquals(sb.AsString(), null);
        System.assert(sb.AsString().contains('CLOUDTRIGGER'));
    }
    
    public static testMethod void testStringBuilder3()
    {
        CT_StringBuilder sb = CT_StringBuilder.NewWithFirstValue('THIS IS A TEST FOR CLOUDTRIGGER');
        sb.Clear();
        System.assertEquals(sb.AsString(), '');
        System.assert(sb.AsString().contains('CLOUDTRIGGER') == false);
    }
    
    public static testMethod void testStringBuilder4()
    {
        CT_StringBuilder sb = CT_StringBuilder.NewStringBuilder();
        sb.AppendLine('CLOUDTRIGGER');
        sb.Append('ROCKS!');
        System.assertNotEquals(sb.AsString(), '');
        System.assertNotEquals(sb.AsString(), null);
        System.assert(sb.AsString().contains('\r\n'));
    }

}