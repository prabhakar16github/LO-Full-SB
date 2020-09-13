/*
##########################################################################################################################################
# Project Name..........: LO - CT Test Class Re-Work
# File..................: Class : "Test_CT_Utility"
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
private class Test_CT_Utility{

 static testMethod void test_GetRecordTypeIdByRecordTypeName()
    {
    CT_Utility c = new CT_Utility();
    list<RecordType> types = [Select
                    r.SobjectType
                  , r.NamespacePrefix
                  , r.Name
                  , r.IsActive
                  , r.Id
                  , r.DeveloperName
                  , r.Description
                  , r.BusinessProcessId
                From
                  RecordType r
                WHERE
                  r.IsActive = true];
        
        RecordType rt;
        if(CT_Utility.ValidateList(types))
        {
          rt = types[0];
        }

      system.assert(rt.Id != null);
      
      String returnedId = CT_Utility.GetRecordTypeIdByRecordTypeName(rt.Name);
      
      system.assert(rt.Id == returnedId);
     
    }

    static testMethod void test_GetRecordTypeIdBySobjectTypeAndRecordTypeName()
    {
    list<RecordType> types = [Select
                    r.SobjectType
                  , r.NamespacePrefix
                  , r.Name
                  , r.IsActive
                  , r.Id
                  , r.DeveloperName
                  , r.Description
                  , r.BusinessProcessId
                From
                  RecordType r
                WHERE
                  r.IsActive = true];
        
        RecordType rt;
        if(CT_Utility.ValidateList(types))
        {
          rt = types[0];
        }

      system.assert(rt.Id != null);
      
      String returnedId = CT_Utility.GetRecordTypeIdBySobjectTypeAndRecordTypeName(rt.SobjectType, rt.Name);
      
      system.assert(rt.Id == returnedId);
     
    }

    static testMethod void test_ValidateSaveresultListPositive()
    {
        Contact cont = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@cloudtrigger.net'
            ,FirstName            = 'Test_FirstName'
            ,LastName             = 'Test_Lastname'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'FL'
            ,MailingPostalCode    = '12345'
        );

        list<Contact> Contacts = new list<Contact>();
        Contacts.add(cont);
        list<Database.Saveresult> Results = Database.insert(Contacts);
      system.assert(CT_Utility.ValidateSaveresultList(Results) == true);
     
    }

    static testMethod void test_ValidateMapPositive()
    {
        Contact cont = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@cloudtrigger.net'
            ,FirstName            = 'Test_FirstName'
            ,LastName             = 'Test_Lastname'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'FL'
            ,MailingPostalCode    = '12345'
        );
        insert cont;
      map<Id, Contact> myMap = new map<Id, Contact>();
      myMap.put(cont.Id, cont);
      system.assert(CT_Utility.ValidateMap(myMap) == true);
     
    }
    
    static testMethod void test_ValidateMapNegativeNull()
    {
      map<Id, Contact> myMap;
      system.assert(CT_Utility.ValidateMap(myMap) == false);
    }
    
    static testMethod void test_ValidateMapNegativeEmpty()
    {
      map<Id, Contact> myMap = new map<Id, Contact>();
      system.assert(CT_Utility.ValidateMap(myMap) == false);
    }
    
    static testMethod void test_ExistsInListNegative()
    {
        Contact cont = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@cloudtrigger.net'
            ,FirstName            = 'Test_FirstName'
            ,LastName             = 'Test_Lastname'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'FL'
            ,MailingPostalCode    = '12345'
        );
        list<Contact> Contacts = new list<Contact>();
        system.assert(CT_Utility.ExistsInList(cont, Contacts) == false);
    }

    static testMethod void test_ExistsInListPositive()
    {
        Contact cont = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@cloudtrigger.net'
            ,FirstName            = 'Test_FirstName'
            ,LastName             = 'Test_Lastname'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'FL'
            ,MailingPostalCode    = '12345'
        );
        list<Contact> Contacts = new list<Contact>();
        Contacts.add(cont);
        system.assert(CT_Utility.ExistsInList(cont, Contacts) == true);
    }

    static testMethod void test_ValidateSobjectListPositive()
    {
        Contact cont = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@cloudtrigger.net'
            ,FirstName            = 'Test_FirstName'
            ,LastName             = 'Test_Lastname'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'FL'
            ,MailingPostalCode    = '12345'
        );
        list<Contact> Contacts = new list<Contact>();
        Contacts.add(cont);
        system.assert(CT_Utility.ValidateList(Contacts) == true);
    }

    static testMethod void test_ValidateSobjectListNegative()
    {
        list<Contact> Contacts = new list<Contact>();
        system.assert(CT_Utility.ValidateList(Contacts) == false);
    }

    static testMethod void test_ValidateObjectList()
    {
        list<Integer> ints = new list<Integer>{1,2,3};
        system.assert(CT_Utility.ValidateList(ints));
    }

    static testMethod void test_StringGetValueOrDefault1()
    {
        String one = '';
        String defaultVal = 'DEFAULT';
        system.assert(CT_Utility.StringGetValueOrDefault(one, defaultVal) == 'DEFAULT');
    }

    static testMethod void test_StringGetValueOrDefault2()
    {
        String one = 'TEST';
        String defaultVal = 'DEFAULT';
        system.assert(CT_Utility.StringGetValueOrDefault(one, defaultVal) == 'TEST');
    }


    static testMethod void test_BuildStringOfIdsForInClause_WithList()
    {

        Contact cont1 = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@cloudtrigger.net'
            ,FirstName            = 'Test_FirstName1'
            ,LastName             = 'Test_Lastname1'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'FL'
            ,MailingPostalCode    = '12345'
        );
        
        Contact cont2 = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@cloudtrigger.net'
            ,FirstName            = 'Test_FirstName2'
            ,LastName             = 'Test_Lastname2'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'FL'
            ,MailingPostalCode    = '12345'
        );
        
        list<Contact> conts = new list<Contact>();
        conts.add(cont1);
        conts.add(cont2);
        insert conts;

      string soql = CT_Utility.BuildStringOfIDsForInClause(conts,',');
      
          system.assert(soql.contains(conts[0].Id));
      system.assert(soql.contains(conts[1].Id));
      system.assert(soql.contains(','));
     
    }

    static testMethod void test_BuildStringOfIdsForInClause_WithSet()
    {

        Contact cont1 = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@cloudtrigger.net'
            ,FirstName            = 'Test_FirstName1'
            ,LastName             = 'Test_Lastname1'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'FL'
            ,MailingPostalCode    = '12345'
        );
        
        Contact cont2 = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@cloudtrigger.net'
            ,FirstName            = 'Test_FirstName2'
            ,LastName             = 'Test_Lastname2'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'FL'
            ,MailingPostalCode    = '12345'
        );
        
        list<Contact> conts = new list<Contact>();
        conts.add(cont1);
        conts.add(cont2);
        insert conts;
        
        system.debug('*****TEST :: ID is for Cont #1 is: ' + conts[0].Id);
        system.debug('*****TEST :: ID is for Cont #2 is: ' + conts[1].Id);

      Set<Id> mySet = new Set<Id>{conts[0].Id, conts[1].Id};
      string soql = CT_Utility.BuildStringOfIDsForInClause(mySet,',');

      system.assert(soql.contains(conts[0].Id));
      system.assert(soql.contains(conts[1].Id));
      system.assert(soql.contains(','));
     
    }

    static testMethod void test_ValidateSetPositive()
    {
        Contact cont = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@cloudtrigger.net'
            ,FirstName            = 'Test_FirstName'
            ,LastName             = 'Test_Lastname'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'FL'
            ,MailingPostalCode    = '12345'
        );
        insert cont;

      Set<Id> mySet = new Set<Id>{cont.Id};
      system.assert(CT_Utility.ValidateSet(mySet) == true);
     
    }
    
    static testMethod void test_ValidateSetNegativeNull()
    {
      Set<Id> mySet;
      system.assert(CT_Utility.ValidateSet(mySet) == false);
    }
    
    static testMethod void test_ValidateSetNegativeEmpty()
    {
      Set<Id> mySet = new Set<Id>();
      system.assert(CT_Utility.ValidateSet(mySet) == false);
    }
    
    
    
    
    }