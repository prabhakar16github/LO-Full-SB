@isTest
public class CaseTrigger_Test{
    
    public static testMethod void unitTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User();
        u.Alias = 'ssa';
        u.Email='standarduser11sak@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingsak';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='sak1@salesforce.com';
        insert u;
        
        Account acc = new Account();
        acc.Firm_ID__c ='CA20';//changed
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        acc.Paralegal__c = u.id;
        acc.MCM_Attorney__c = u.id;
        insert acc;
        
        Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c();
        pamObj = new Process_Adherence_Monitoring__c(Organization_Name__c = acc.id,Account_Number__c='121211',
                                                        RecordTypeId=Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO FRB').getRecordTypeId(),
                                                        C1_Resolution_Date__c=null,C1_TOTAL_BAL_THRESHOLD__c=true,
                                                        C2_Resolution_Date__c=null,C2_RCVRABLE_COST_COST_SPENT__c=true,
                                                        C3_Resolution_Date__c=null,C3_ATTY_OTHER_FEES_CNTRCT_AMT__c=true,
                                                        C4_Resolution_Date__c=null,C4_ATTY_FEES_STAT_AMT__c=true,
                                                        C5_Resolution_Date__c=null,C5_INTEREST_RATE__c=true,
                                                        C6_Resolution_Date__c=null,C6_INTEREST_THRESHOLD__c=true,
                                                        C7_Resolution_Date__c=null,C7_CALCULATED_BALANCE_FIRM_BAL__c=true,
                                                        C7A_Resolution_Date__c=null,C7A_PRIN_AMT_PLACED_PRIN__c=true,
                                                        C7B_Resolution_Date__c=null,C7B_REC30_PMTS_ADJS_REC42_PMTS_ADJS__c=true,
                                                        C7C_Resolution_Date__c=null,C7C_REC30_RCVR_COST_REC42_RCVR_COST__c=true,
                                                        C7D_Resolution_Date__c=null,C7D_CURRENT_BALANCE_0__c=true);
        insert pamObj;

        RecordType pamRecordType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'case' AND DeveloperName = 'Operations_PAM'];
        
        List<Case> caseList = new List<Case>();
         
        Case caseObj = new Case(Status='New',Origin='Email - Ext',Subject='PAM - BI Enterprise Data Integration Load Completed');
        caseList.add(caseObj);
        
        Case caseObj1 = new Case(Status = 'New', recordTypeId = pamRecordType.Id, Subcategories__c = 'Scripts - SOL');
        caseList.add(caseObj1); 
        
        Case caseObj2 = new Case(Status='New',  recordTypeId = pamRecordType.Id, Subcategories__c = 'Scripts - CCM');
        caseList.add(caseObj2);
        
        insert caseList;
    }
    
    static testmethod void pnaScriptsTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User u = new User();
        u.Alias = 'ssa';
        u.Email='standarduser11sak@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingsak';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='sak1@salesforce.com';
        insert u;
        
        Account acc = new Account();
        acc.Firm_ID__c ='test';
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        acc.Paralegal__c = u.id;
        acc.MCM_Attorney__c = u.id;
        insert acc;
        
        
        String PNARecordTypeID = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO PNA').getRecordTypeId();
        
        Process_Adherence_Monitoring__c pamTestObj = new Process_Adherence_Monitoring__c( RecordTypeId = PNARecordTypeID, 
                                                                                            Account_Number__c = '0987654321',
                                                                                            Organization_Name__c = acc.id,
                                                                                            Status__c = 'New',
                                                                                            SOL_Placement_Date__c = System.today(),
                                                                                            PNA_Placement_Type__c = 'LB5');
                                                                                            
        insert pamTestObj;
        Test.setCreatedDate(pamTestObj.Id, Datetime.valueOf(System.now().addDays(-1)));
        
        String casePamRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Operations - PAM').getRecordTypeId();
        
        
        Case caseObj = new Case(Subcategories__c = 'Scripts - PNA', Status = 'New', 
                                    Reason = 'Process Adherence Monitoring (PAM)',
                                    RecordTypeId = casePamRecordTypeId);
                                    
        Test.startTest();                                   
                                    
            insert caseObj; 
        
        Test.stopTest();
        
        System.assert(true);
         
    } 
    static testmethod void IRUM_ACFScriptsTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User u = new User();
        u.Alias = 'ssa';
        u.Email='standarduser11sak@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingsak';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='sak1@salesforce.com';
        insert u;
        
        Account acc = new Account();
        acc.Firm_ID__c ='test';
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        insert acc;
        
        
        String IRUMRecordTypeID = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR - Account #\'s Sent').getRecordTypeId();
        
        Process_Adherence_Monitoring__c pamTestObj = new Process_Adherence_Monitoring__c( RecordTypeId = IRUMRecordTypeID, 
                                                                                            Account_Number__c = '0987654321',
                                                                                            Organization_Name__c = acc.id,
                                                                                            Status__c = 'New');
                                                                                            
        insert pamTestObj;
        Test.setCreatedDate(pamTestObj.Id, Datetime.valueOf(System.now().addDays(-1)));
        
        String casePamRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Operations - PAM').getRecordTypeId();
                
        Case caseObj = new Case(Subcategories__c = 'Scripts - IRUM ACF', Status = 'New', 
                                    Reason = 'Process Adherence Monitoring (PAM)',
                                    RecordTypeId = casePamRecordTypeId);
                                    
        Test.startTest();                                           
        insert caseObj;         
        Test.stopTest();        
        System.assert(true);
        
    }
    /* change test class by avaneesh singh 11/25/2019 */
    static testmethod void SCUM_ScriptsTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User u = new User();
        u.Alias = 'ssa';
        u.Email='standarduser11sak@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingsak';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='sak1@salesforce.com';
        insert u;
        
        Account acc = new Account();
        acc.Firm_ID__c ='test';
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        insert acc;
        
        
        String IRUMRecordTypeID = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute - Account #s Sent').getRecordTypeId();
        
        Process_Adherence_Monitoring__c pamTestObj = new Process_Adherence_Monitoring__c( RecordTypeId = IRUMRecordTypeID, 
                                                                                            Account_Number__c = '0987654321',
                                                                                            Organization_Name__c = acc.id,
                                                                                            Status__c = 'Accounts Sent To ISeries');
                                                                                            
        insert pamTestObj;
        Test.setCreatedDate(pamTestObj.Id, Datetime.valueOf(System.now().addDays(-1)));
        
        String unmatchedRecordTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId();
        
        PAM_Unmatched__c pam = new PAM_Unmatched__c(PAMUM_Process_Adherence_Monitoring__c=pamTestObj.id ,
               recordTypeId = unmatchedRecordTypeId , SCMDUM_Record_Creation_Notification_Sent__c=false);
        
        insert pam;
        
        String casePamRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Operations - PAM').getRecordTypeId();
                
        Case caseObj = new Case(Subcategories__c = 'Scripts - SCMUM', Status = 'New', 
                                    Reason = 'Process Adherence Monitoring (PAM)',
                                    RecordTypeId = casePamRecordTypeId);
                                    
        Test.startTest();                                           
        insert caseObj;         
        Test.stopTest();        
        System.assert(true);
        
    }

static testmethod void SCUM_ScriptsTest1(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User u = new User();
        u.Alias = 'ssa';
        u.Email='standarduser11sak@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingsak';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='sak1@salesforce.com';
        insert u;
        
        Account acc = new Account();
        acc.Firm_ID__c ='test';
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        insert acc;
        
        
        String IRUMRecordTypeID = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute - Account #s Sent').getRecordTypeId();
        
        Process_Adherence_Monitoring__c pamTestObj = new Process_Adherence_Monitoring__c( RecordTypeId = IRUMRecordTypeID, 
                                                                                            Account_Number__c = '0987654321',
                                                                                            Organization_Name__c = acc.id,
                                                                                            Status__c = 'new');
                                                                                            
        insert pamTestObj;
        Test.setCreatedDate(pamTestObj.Id, Datetime.valueOf(System.now().addDays(-1)));
        
        String unmatchedRecordTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO SCMDUM').getRecordTypeId();
        
        PAM_Unmatched__c pam = new PAM_Unmatched__c(PAMUM_Process_Adherence_Monitoring__c=pamTestObj.id ,
               recordTypeId = unmatchedRecordTypeId , SCMDUM_Record_Creation_Notification_Sent__c=false);
        
        insert pam;
        
        String casePamRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Operations - PAM').getRecordTypeId();
                
        Case caseObj = new Case(Subcategories__c = 'Scripts - SCMUM', Status = 'New', 
                                    Reason = 'Process Adherence Monitoring (PAM)',
                                    RecordTypeId = casePamRecordTypeId);
                                    
        Test.startTest();                                           
        insert caseObj;         
        Test.stopTest();        
        System.assert(true);
        
    }



    /* change test class by avaneesh singh 11/25/2019 */
   static testmethod void SCUM_ACF_ScriptsTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User u = new User();
        u.Alias = 'ssa';
        u.Email='standarduser11sak@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingsak';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='sak1@salesforce.com';
        insert u;
        
        Account acc = new Account();
        acc.Firm_ID__c ='test';
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        insert acc;
        
        
        String IRUMRecordTypeID = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute - Account #s Sent').getRecordTypeId();
        
        Process_Adherence_Monitoring__c pamTestObj = new Process_Adherence_Monitoring__c( RecordTypeId = IRUMRecordTypeID, 
                                                                                            Account_Number__c = '0987654321',
                                                                                            Organization_Name__c = acc.id,
                                                                                            Status__c = 'Accounts Sent To ISeries');
                                                                                            
        insert pamTestObj;
        Test.setCreatedDate(pamTestObj.Id, Datetime.valueOf(System.now().addDays(-1)));
        
        String unmatchedRecordTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('ACF SCMDUM').getRecordTypeId();
        
        PAM_Unmatched__c pam = new PAM_Unmatched__c(PAMUM_Process_Adherence_Monitoring__c=pamTestObj.id ,
               recordTypeId = unmatchedRecordTypeId ,SCMDUM_Record_Creation_Notification_Sent__c=false);
        
        insert pam;
         OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'lcsalesforceadmin@mcmcg.com'];
        SCUM_CreationNotificationBatchHelper.createMailForSCMUnmatchedRecords('test','test',pamTestObj ,'test',false,'SCMD-LO',owea[0]);
        SCUM_CreationNotificationBatchHelper.createMailForSCMUnmatchedRecords('test','test',pamTestObj ,'test',false,'SCMD-ACF',owea[0]);
        
        String casePamRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Operations - PAM').getRecordTypeId();
                
        Case caseObj = new Case(Subcategories__c = 'Scripts - SCMUM ACF', Status = 'New', 
                                    Reason = 'Process Adherence Monitoring (PAM)',
                                    RecordTypeId = casePamRecordTypeId);
                                    
        Test.startTest();                                           
        insert caseObj;         
        Test.stopTest();        
        System.assert(true);
        
    }


    
    
    
    static testmethod void IRUMScriptsTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User u = new User();
        u.Alias = 'ssa';
        u.Email='standarduser11sak@testorg.com';
        u.EmailEncodingKey='UTF-8';
        u.LastName='Testingsak';
        u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='sak1@salesforce.com';
        insert u;
        
        Account acc = new Account();
        acc.Firm_ID__c ='test';
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        insert acc;
        
        
        String IRUMRecordTypeID = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR - Account #\'s Sent').getRecordTypeId();
        
        Process_Adherence_Monitoring__c pamTestObj = new Process_Adherence_Monitoring__c( RecordTypeId = IRUMRecordTypeID, 
                                                                                            Account_Number__c = '0987654321',
                                                                                            Organization_Name__c = acc.id,
                                                                                            Status__c = 'New');
                                                                                            
        insert pamTestObj;
        Test.setCreatedDate(pamTestObj.Id, Datetime.valueOf(System.now().addDays(-1)));
        
        String casePamRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Operations - PAM').getRecordTypeId();
                
        Case caseObj = new Case(Subcategories__c = 'Scripts - IRUM', Status = 'New', 
                                    Reason = 'Process Adherence Monitoring (PAM)',
                                    RecordTypeId = casePamRecordTypeId);
                                    
        Test.startTest();                                           
        insert caseObj;         
        Test.stopTest();        
        System.assert(true);
        
    }
    static testmethod void updateFirmDuringEmail2Case_Test(){
        list<Account> accList = new list<Account>();
        list<Account> accList1 = new list<Account>();
        Account a = new Account();
        a.Name = 'TestAcc';
        a.Firm_ID__c = 'Test';
        insert a;
        accList.add(a);
        
        Account a1 = new Account();
        a1.Name = 'TestAcc';
        a1.Firm_ID__c = 'CA20';
        insert a1;
        accList1.add(a1);
        
        Case c = new Case();
        c.subject='AK5 AAA ABA @9 dcwdd ed dddewew d w 12 32 1312 31312 4325 35543534##$$# 3#';
        c.Mapped_Organization_Value__c = null;
        c.AccountID = a1.id;
        insert c;
        
        Case c4 = new Case();
        c4.subject='AK3 AAA ABA @9 dcwdd ed dddewew d w 12 32 1312 31312 4325 35543534##$$# 3#';
        c4.Mapped_Organization_Value__c = null;
        c4.AccountID = a1.id;
        insert c4;
        
        Case c2 = new Case();
        c2.subject='';
        c2.AccountID = a1.id;
        insert c2;
        
        Case c1 = new Case();
        c1.subject='CA20 ss ss  ss';
        insert c1;
    }
}