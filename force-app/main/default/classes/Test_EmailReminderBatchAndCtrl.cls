/*
##########################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: It is a Test Class for "EmailReminderBatch And EmailReminderBatchCtrl" Classes
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 13-May-2014
# Last Modified by......: Sunny Kumar
# Last Modified Date....: 13-May-2014
# Description...........: It will cover the code for class  EmailReminderBatch and EmailReminderBatchCtrl . 
###########################################################################################################################################
*/
/**  @isTest
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*/   
@isTest(SeeAllData= true)
public with sharing class Test_EmailReminderBatchAndCtrl { 

 
    static testMethod void TestFirmBatch()
    {  
       
      //Consumer_Inquiries__c RecordType
       Map<String,String> mapRecordTypeCI=new  Map<String,String>();
       Schema.sObjectType objType = Consumer_Inquiries__c.getSObjectType();
       Schema.DescribeSObjectResult sObjReslt = objType.getDescribe();  
       Map<String,Schema.RecordTypeInfo> rtMapByName = sObjReslt.getRecordTypeInfosByName();
       
       for(String str:rtMapByName.keySet()){
              Schema.RecordTypeInfo rtByName =  rtMapByName.get(str);
             if(rtByName.isAvailable()){
                mapRecordTypeCI.put(rtByName.getName(),rtByName.getRecordTypeId());
             }  
       }
       
       
      // Inserting Dummy Record     
      Consumer_Inquirie_History__c CIH = new Consumer_Inquirie_History__c();
      CIH.Month__c = String.valueOf(System.today().month());
      CIH.Year__c = String.valueOf(System.today().year());
      CIH.Is_Active__c=TRUE;
      CIH.Firm_Type__c='Single';
      List<Account> a = [Select id,name from Account limit 1];
      if(!a.isEmpty()){
      CIH.Account__c = a[0].id;
      System.debug('Sunny=====>>>>'+a +'---------'+a.size());     
      }
      
      CIH.RC__c=TRUE;
      insert CIH;    
      
          
      String CIProfileName;
    // Get Profile Name from Custom Setting Details
      ProfileName__c getProfileName = ProfileName__c.getInstance('CI_ProfileName');    
      CIProfileName = getProfileName.ProfileLabel__c;  
      Profile objProfile=[Select id,name from Profile where Name=:CIProfileName];
        String strProfileId=objProfile.id; 
     
      List<User> u = [Select u.Username,u.Accountid,u.UserType,u.IsActive, u.IsPortalEnabled, u.Department, 
                      u.Contact.Community_Profile__c,u.Contact.Inactive_Contact__c, u.Contact.Firm_ID__c, 
                      u.Contact.Name, u.ContactId From User u where  u.UserType='CspLitePortal' and u.IsActive=True 
                      and profileid=:strProfileId 
                      and u.Department!=null limit 1];
                        
      Consumer_Inquiries__c cI = new Consumer_Inquiries__c();
       if(!u.isEmpty()){
      cI.Firm_Name__c =u[0].Accountid;
      System.debug('Sunny=====>>>>'+a +'---------'+a.size());
      cI.RecordTypeId = mapRecordTypeCI.get('Consumer Dissatisfaction');
      if(!u.isEmpty()){
      cI.OwnerId = u[0].id;
      cI.Account_Type__c = u[0].Department;
      System.debug('Sunny=====>>>>'+u[0] +'---------'+u.size()); 
      }
      cI.Nature_of_Inquiry__c='Calling Repeatedly';
      cI.Source_of_Inquiry__c='Test';
      cI.Account_Number__c='345';
      cI.Consumer_Name__c='Test';
      ci.Date_Received__c = system.today(); // Response to Consumer, Result of Investigation and Final Resolution fields
      ci.Response_to_Consumer__c='test';
      ci.Result_of_Investigation__c='test';
      ci.Final_Resolution__c='test';
      cI.Date_Closed__c=System.today().addDays(8);
      cI.Reporting_Month__c=String.valueOf(System.today().month());
      cI.Reporting_Year__c=String.valueOf(System.today().year());
      cI.Inquiry_Summary__c='Test';
      cI.Wrong_Party_Complaint__c='No';
      insert cI; 
      }
     
     Test.StartTest();         
      
     List<Account> a1 = [Select id,name from Account where id=:u[0].Accountid];     
     
      Database.BatchableContext BC;
      EmailReminderBatch eRB = new EmailReminderBatch(String.valueOf(System.today().year()),String.valueOf(System.today().month()),true,true,false);
      eRB.Start(BC);
      eRB.execute(BC,a1);
      
     
       EmailReminderBatch eRB1 = new EmailReminderBatch(String.valueOf(System.today().year()),String.valueOf(System.today().month()),true,true,true);
       ID batchprocessid = Database.executeBatch(eRB1);
       eRB1.Start(BC);

      EmailReminderBatch.InquiryDetail eI = new EmailReminderBatch.InquiryDetail();      
      eI.bRCFound = True;
      eI.bCDFound= True;
      eI.strFirmType='Joint';
      eI.isJointFirm= True;
      eI.bMCMRCFound= True;
      eI.bMCMCDFound= True;
      eI.bAARSRCFound= True;
      eI.bAARSCDFound= True;
      eI.b_ACF_RC_Found= True;
      eI.b_ACF_CD_Found= True;
      
      
      EmailReminderBatch emailRemainderBatchObj = new EmailReminderBatch(String.valueOf(System.today().year()),String.valueOf(System.today().month()),true,true,false);
      
      EmailReminderBatch.UserDetail userObj = new EmailReminderBatch.UserDetail();  
      
      Account accountObj = new Account(Name='Test', MultipleAccountTypes__c=false, Firm_Status_IN__c = 'Active');
      emailRemainderBatchObj.getFirmDetail(accountObj);
      
      Account accountObj1 = new Account(Name='Test', MultipleAccountTypes__c=false, Firm_Status_IN_AARS__c = 'Active');
      emailRemainderBatchObj.getFirmDetail(accountObj1);
      
      Account accountObj2 = new Account(Name='Test', MultipleAccountTypes__c=false, Firm_Status_IN_ACF__c = 'Active');
      emailRemainderBatchObj.getFirmDetail(accountObj2);
      
      Map<String,Map<String,String>> mapUserInquiryType = new Map<String,Map<String,String>>();
      mapUserInquiryType.put('MCM',new map<String, String>{'RC'=>'RC'});
      mapUserInquiryType.put('MCM',new map<String, String>{'CD'=>'CD'});
      mapUserInquiryType.put('ACF',new map<String, String>{'CD'=>'CD'});
      mapUserInquiryType.put('ACF',new map<String, String>{'RC'=>'RC'});
      mapUserInquiryType.put('AA',new map<String, String>{'CD'=>'CD'});
      mapUserInquiryType.put('AA',new map<String, String>{'RC'=>'RC'});
      emailRemainderBatchObj.getInquiryDetail(mapUserInquiryType,userObj, true);
      emailRemainderBatchObj.getInquiryDetail(mapUserInquiryType,userObj, false);
       
      Test.StopTest();
        
   
       
      SendEmailReminderBatchCtrl MCMAcc = new SendEmailReminderBatchCtrl();
     
      // Inserting Dummy Record  
      Consumer_Inquirie_History__c CInH = new Consumer_Inquirie_History__c();
      CInH.Month__c = String.valueOf(System.today().month()-1);
      CInH.Year__c = String.valueOf(System.today().year()+2);
      system.debug('******' +CInH.Month__c);
      system.debug('******' +CInH.Year__c);
      CInH.Is_Active__c=TRUE;
      CInH.Firm_Type__c='Single';
      List<Account> aa = [Select id,name from Account limit 1];
      if(!aa.isEmpty()){
      CInH.Account__c = aa[0].id;
      System.debug('Sunny=====>>>>'+aa +'---------'+aa.size());     
      }
      
      CInH.RC__c=TRUE;
      insert CInH;   
          
       MCMAcc.objConsumer=CInH;
       MCMAcc.start();
       CInH.Month__c = String.valueOf(System.today().month());
       CInH.Year__c = String.valueOf(System.today().year());
       MCMAcc.start();
      
       
     } 
      
}