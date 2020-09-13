@isTest(seealldata=true)
public class Test_CM_PreventDuplicateRecords{ 
    public static testMethod void Test_CM_PreventDuplicateRecords(){
        Account a = new Account();
        a.Name = 'TestAcc';
        a.Firm_ID__c = 'Test';
        insert a;
        Account a1 = new Account();
        a1.Name = 'TestAcc';
        a1.Firm_ID__c = 'Test';
        insert a1;
     
        Map<String,String> mapRecordType=new  Map<String,String>();     
        Schema.sObjectType objType = Call_Monitoring__c.getSObjectType();
     Schema.DescribeSObjectResult sObjReslt = objType.getDescribe();  
     Map<String,Schema.RecordTypeInfo> rtMapByName = sObjReslt.getRecordTypeInfosByName();
     String IfQARecordTypeAccessIssue = 'test';
     for(String str:rtMapByName.keySet()){
          Schema.RecordTypeInfo rtByName =  rtMapByName.get(str);
         if(rtByName.isAvailable()){
            mapRecordType.put(rtByName.getName(),rtByName.getRecordTypeId());
         }  
        } 
        Call_Monitoring__c callMontring = new Call_Monitoring__c();
        callMontring.RecordTypeID = ID.ValueOF(mapRecordType.get('Call Monitoring Log'));
        callMontring.Attachments__c = false;
        callMontring.Organization_Name_CM__c =[Select id from account where name like '%AL003%' limit 1].id;
        callMontring.Reporting_Month_CM__c = '01';
        callMontring.Reporting_Year_CM__c = '2015';
        callMontring.Most_Recent_Attachment_Date__c=system.today()-30;      
        insert callMontring;
        
        Call_Monitoring__c callMontring1 = new Call_Monitoring__c();
        callMontring1.ID = callMontring.id;
        
        update callMontring1;
        callMontring1.RecordTypeID = ID.ValueOF(mapRecordType.get('Call Monitoring QA'));
        callMontring1.Reporting_Year_CM__c = '2016';
        callMontring1.Attachments__c=true;
        callMontring1.Reporting_Quarter_CM__c = 'QTR01';
        callMontring1.Most_Recent_Attachment_Date__c=system.today()-20;
        update callMontring1;
        callMontring1.Reporting_Quarter_CM__c = 'QTR02';
        update callMontring1;
        }
         
}