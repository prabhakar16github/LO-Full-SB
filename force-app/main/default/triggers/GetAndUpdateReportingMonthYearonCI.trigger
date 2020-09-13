/*
##############################################################################################################################################
# Project Name..........: S2S  Project
# File..................: getAndUpdateReportingMonthYearonCI
# Version...............: 1.0
# Created by............: Sunny Kumar   
# Created Date..........: 21-Sep-2015
# Last Modified by......: Sunny Kumar
# Last Modified Date....: 21-Sep-2015                         
# Description...........: Update Reporting Month and Year field on Consumer Inquiry. This field is using under code.
##############################################################################################################################################
*/
trigger GetAndUpdateReportingMonthYearonCI on Consumer_Inquiries__c (before insert,before update) {  
Set<Id> setFirmId=new set<Id>();
Set<String> setYear=new Set<String>();
Set<String> setMonth=new Set<String>();
Set<String> setYearMonthFirmName=new Set<String>();
map<String,Consumer_Inquiries__c> mapFirmYrMonthCI = new map<String,Consumer_Inquiries__c>();
Map<String,CIS_Counts__c> mapConsumerHistory=new Map<String,CIS_Counts__c>();
public string ModifyMonth {get;set;}

// Extract CI RecordType.....
Map<id,Consumer_Inquiries__c> mapConsumerInqMnthYear=new Map<Id,Consumer_Inquiries__c>();
Map<String,String> mapRecordType=new  Map<String,String>();
Map<String,String> mapRecordTypeNameID=new  Map<String,String>();
     Schema.sObjectType objType = Consumer_Inquiries__c.getSObjectType();
     Schema.DescribeSObjectResult sObjReslt = objType.getDescribe();  
     Map<String,Schema.RecordTypeInfo> rtMapByName = sObjReslt.getRecordTypeInfosByName();
     
     for(String str:rtMapByName.keySet()){
          Schema.RecordTypeInfo rtByName =  rtMapByName.get(str);
         if(rtByName.isAvailable() && rtByName.getName()=='Consumer Dissatisfaction' || rtByName.getName()=='Regulatory Complaint'){
             if(mapRecordType.get(rtByName.getRecordTypeId())==null){                
                 mapRecordType.put(rtByName.getRecordTypeId(),rtByName.getName()); 
             }
           
             
         }  
     }
     System.debug('Sunny---->>>'+mapRecordType.size()+mapRecordType);
//........Extracted Record Type.......
 
    for(Consumer_Inquiries__c obj:trigger.new){ 
    System.debug('Sunny---->>'+obj.RecordType.Name+obj.RecordTypeId);
        if(mapRecordType.get(obj.RecordTypeId)!=null && obj.Date_Received__c!=null){
        if(String.Valueof(obj.Date_Received__c.Month()).length()==1)    
        obj.Reporting_Month__c = '0'+String.Valueof(obj.Date_Received__c.Month());
        else
        obj.Reporting_Month__c = String.Valueof(obj.Date_Received__c.Month());  
        obj.Reporting_Year__c = String.Valueof(obj.Date_Received__c.Year());
        }
          
      
    }

}