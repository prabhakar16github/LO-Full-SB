/*
##############################################################################################################################################
# Project Name..........: LO - Call Monitoring  
# File..................: Class : Utility 
# Version...............: 1.0
# Created by............: Sunny Kumar   
# Created Date..........: 02-Mar-2016  
# Last Modified by......: Sunny Kumar
# Last Modified Date....: 09-Mar-2016                         
# Description...........: This class will help all subclasses and triggers. It will also provide access to common required hard code items like, email, profile name etc.
##############################################################################################################################################
*/
public with sharing class Utility {


/* ############################################################################
        Manage Custom Settings 
   ############################################################################## */
   
   public static Map<String,ProfileName__c> getProfileNameSettings()
   {
        
        Map<String,ProfileName__c> custSettingMap1 = ProfileName__c.getAll();        
        return custSettingMap1;
   }

  /* This is used get the Name of Trial Witness*/
  public static String getTrialWitnessProfileLabel()
  {
    Map<String,ProfileName__c> custSettingMap = getProfileNameSettings();
    String TWProfileName=custSettingMap.get('TW_ProfileName').ProfileLabel__c;
    System.debug('Sunny=======>>'+TWProfileName); 
    return TWProfileName;
  }
 //////////////////////////// 
 //  This is used get the Name of TW_CISProfileName - BOTH
  public static String getTW_CISProfileLabel()
  {
    Map<String,ProfileName__c> custSettingMap = getProfileNameSettings();
    String TW_CISProfileName=custSettingMap.get('TW_CISProfileName').ProfileLabel__c;
    System.debug('Sunny=======>>'+TW_CISProfileName); 
    return TW_CISProfileName;
  }
  
  
  /* This is used get the Name of CIS Profile Name*/
  public static String getCISProfileNameLabel()
  {
    Map<String,ProfileName__c> custSettingMap = getProfileNameSettings();
    String CIProfileName=custSettingMap.get('CI_ProfileName').ProfileLabel__c;
    System.debug('Sunny=======>>'+CIProfileName); 
    return CIProfileName;
  }
  
  /* This is used get the Name of CC Profile Name*/
  public static String getCCProfileNameLabel()
  {
    Map<String,ProfileName__c> custSettingMap = getProfileNameSettings();
    String CCProfileName=custSettingMap.get('CC_UserProfile').ProfileLabel__c;
    System.debug('Sunny=======>>'+CCProfileName); 
    return CCProfileName;
  }
  
  /* This is used get the Name of FRB Profile Name*/
  public static String getFRBProfileNameLabel()
  {
    Map<String,ProfileName__c> custSettingMap = getProfileNameSettings();
    String FRBProfileName=custSettingMap.get('LOFRBRecordTypeID').ProfileLabel__c;
    System.debug('Sunny=======>>'+FRBProfileName); 
    return FRBProfileName;
  }
  
   /* This methos will get OWD email address*/
  public static String getOWDFirmManagmentEmail()
  {
    Map<String,ProfileName__c> custSettingMap = getProfileNameSettings();
    String getOWD_FirmManagmentEmail=custSettingMap.get('Firm Management Email').ProfileLabel__c;
    System.debug('Sunny=======>>'+getOWD_FirmManagmentEmail); 
    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:custSettingMap.get('Firm Management Email').ProfileLabel__c];
   if ( owea.size() > 0 ) 
    return owea[0].Id;
   else
    return null;    
  }
  
  /*public static void sendCMEmail(String emailList,ID recordID)
  {
    System.debug('Sunny=======emailList>>'+emailList+'===recordID==='+recordID); 
    OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];
    EmailTemplate templateId = [Select id from EmailTemplate where name = 'CM: Call Log Monitoring Accounts From QA'];
    System.debug('templateId=======>>'+templateId); 
     
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setTemplateID(templateId.Id); 
    mail.setSaveAsActivity(false);
    //mail.setTargetObjectId(recordID);
    String[] toAddresses = new String[] {'sunny.kumar@mcmcg.com'};
    //mail.setToAddresses(emailList);
   mail.setToAddresses(toAddresses);
    //mail.setCcAddresses('sunny.kumar@mcmcg.com');
    //mail.setOrgWideEmailAddressId(owa.id);
    System.debug('mail=======>>'+mail);       
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
    
  }*/

  /* This is used get the Record Type of Call Monitoring*/
  public static string getCMRecordType(ID recordtypeID)
  {
     Map<ID,String> mapRecordType=new  Map<ID,String>();     
     Schema.sObjectType objType = Call_Monitoring__c.getSObjectType();
     Schema.DescribeSObjectResult sObjReslt = objType.getDescribe();  
     Map<String,Schema.RecordTypeInfo> rtMapByName = sObjReslt.getRecordTypeInfosByName();
     String IfQARecordTypeAccessIssue = 'test';
     for(String str:rtMapByName.keySet()){
          Schema.RecordTypeInfo rtByName =  rtMapByName.get(str);
         if(rtByName.isAvailable()){
            mapRecordType.put(rtByName.getRecordTypeId(),rtByName.getName());
         }  
     }
    System.debug('Sunny=======>>'+mapRecordType); 
    if(mapRecordType.get(recordtypeID)!=null){
    System.debug('Sunny=======>>'+mapRecordType.get(recordtypeID)); 
    return mapRecordType.get(recordtypeID);
    }
    else{
    System.debug('Sunny=======>>'+mapRecordType.get(recordtypeID)); 
    return IfQARecordTypeAccessIssue;
    }
  }
  
  /* This is used get the CIS&CM Record Type of Consumer_Inquirie_History__c table*/
  public static ID getCISCMRecordType(String keyword)
  {
     Map<ID,String> mapRecordType=new  Map<ID,String>();     
     Schema.sObjectType objType = Consumer_Inquirie_History__c.getSObjectType();
     Schema.DescribeSObjectResult sObjReslt = objType.getDescribe();  
     Map<String,Schema.RecordTypeInfo> rtMapByName = sObjReslt.getRecordTypeInfosByName();
     ID recordTypeID;
     for(String str:rtMapByName.keySet()){
          Schema.RecordTypeInfo rtByName =  rtMapByName.get(str);
         if(rtByName.isAvailable() && rtByName.getName().contains(keyword)){
            recordTypeID=rtByName.getRecordTypeId();
            break;
         }   
     }
    System.debug('Sunny=======>>'+recordTypeID); 
    
    return recordTypeID;
  }
  
  /* This is used get the CIS&CM Record Type of Email_Reminder__c Table*/
  public static ID getCISCMEmail_ReminderRecordType(String keyword)
  {
     Map<ID,String> mapRecordType=new  Map<ID,String>();     
     Schema.sObjectType objType = Email_Reminder__c.getSObjectType();
     Schema.DescribeSObjectResult sObjReslt = objType.getDescribe();  
     Map<String,Schema.RecordTypeInfo> rtMapByName = sObjReslt.getRecordTypeInfosByName();
     ID recordTypeID;
     for(String str:rtMapByName.keySet()){
          Schema.RecordTypeInfo rtByName =  rtMapByName.get(str);
         if(rtByName.isAvailable() && rtByName.getName().contains(keyword)){
            recordTypeID=rtByName.getRecordTypeId();
            break;
         }  
     }
    System.debug('Sunny=======>>'+recordTypeID); 
    
    return recordTypeID;
  }
   /* This is used get the Record Type of Consumer Inquiries*/
  public static string getCIRecordType(ID recordtypeID)
  {
     Map<ID,String> mapRecordType=new  Map<ID,String>();     
     Schema.sObjectType objType = Consumer_Inquiries__c.getSObjectType();
     Schema.DescribeSObjectResult sObjReslt = objType.getDescribe();  
     Map<String,Schema.RecordTypeInfo> rtMapByName = sObjReslt.getRecordTypeInfosByName();
     String IfQARecordTypeAccessIssue = 'test';
     for(String str:rtMapByName.keySet()){
          Schema.RecordTypeInfo rtByName =  rtMapByName.get(str);
         if(rtByName.isAvailable()){
            mapRecordType.put(rtByName.getRecordTypeId(),rtByName.getName());
         }  
     }
    System.debug('Sunny=======>>'+mapRecordType); 
    if(mapRecordType.get(recordtypeID)!=null){
    System.debug('Sunny=======>>'+mapRecordType.get(recordtypeID)); 
    return mapRecordType.get(recordtypeID);
    }
    else{
    System.debug('Sunny=======>>'+mapRecordType.get(recordtypeID)); 
    return IfQARecordTypeAccessIssue;
    }
  }
 

}