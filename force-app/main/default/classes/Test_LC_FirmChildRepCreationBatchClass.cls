@isTest(seealldata=true)
public class Test_LC_FirmChildRepCreationBatchClass{
    static testMethod void myUnitTest(){
        list<Account> accList = new list<Account>();
        Account a = new Account();
        a.Name = 'TestAcc';
        a.Firm_ID__c = 'Test';
        insert a;
        accList.add(a);
       
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
     
                        
      Consumer_Inquiries__c cI = new Consumer_Inquiries__c();      
      cI.Firm_Name__c =a.id;
      cI.RecordTypeId = mapRecordTypeCI.get('Regulatory Complaint');   
      cI.Account_Type__c = 'MCM';  
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
     
/*
       Box_Folder_ID_Map__c BFIM = [select Actual_Firm__c, Reference_ID__c, Firm_ID__c, Type__c, Created_Date__c from Box_Folder_ID_Map__c where Actual_Firm__c =: a.id and Reference_ID__c =: a.id and Type__c = 'Account'];
      */
    
        Test.StartTest();
        
        
        Database.BatchableContext BC;
        LC_FirmChildReplicaCreationBatchClass obj = new LC_FirmChildReplicaCreationBatchClass();
        obj.Start(BC);
        obj.execute(BC,accList);
        obj.finish(BC);
        //Database.executeBatch(obj);
        
        Test.StopTest();
        
    }
    
    static testMethod void myUnitTest1(){
        list<Account> accList = new list<Account>();
        list<Account> accList1 = new list<Account>();
        Account a = new Account();
        a.Name = 'TestAcc';
        a.Firm_ID__c = 'Test';
        insert a;
        accList.add(a);
        
        Account a1 = new Account();
        a1.Name = 'TestAcc';
        a1.Agency_ID__c = 'Test';
        insert a1;
        accList1.add(a1);
       
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
     
                        
      Consumer_Inquiries__c cI = new Consumer_Inquiries__c();      
      cI.Firm_Name__c =a.id;
      cI.RecordTypeId = mapRecordTypeCI.get('Regulatory Complaint');   
      cI.Account_Type__c = 'MCM';  
      cI.Nature_of_Inquiry__c='Calling Repeatedly';
      cI.Source_of_Inquiry__c='Test';
      cI.Account_Number__c='345';
      cI.Consumer_Name__c='Test';
      cI.Date_Received__c = system.today(); // Response to Consumer, Result of Investigation and Final Resolution fields
      cI.Response_to_Consumer__c='test';
      cI.Result_of_Investigation__c='test';
     // cI.Final_Resolution__c='test';
     // cI.Date_Closed__c=System.today(); //.addDays(8)
      cI.Reporting_Month__c=String.valueOf(System.today().month());
      cI.Reporting_Year__c=String.valueOf(System.today().year());
      cI.Inquiry_Summary__c='Test';
      cI.Wrong_Party_Complaint__c='No';
      insert cI; 
     
       Box_Folder_ID_Map__c BFIM = [select Actual_Firm__c, Reference_ID__c, Firm_ID__c, Type__c, Created_Date__c from Box_Folder_ID_Map__c where Actual_Firm__c =: a.id and Type__c = 'Account'];
       if(BFIM!=null){
        BFIM.Type__c=null;   
         update BFIM;  
       }
    
        Test.StartTest();
        
        
        Database.BatchableContext BC;
        LC_FirmChildReplicaCreationBatchClass obj = new LC_FirmChildReplicaCreationBatchClass();
        obj.Start(BC);
        obj.execute(BC,accList);
        obj.execute(BC,accList1);
        obj.finish(BC);
        
        
        Test.StopTest();
        
    }
}