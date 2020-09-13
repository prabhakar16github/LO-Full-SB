@isTest(SeeAllData= true)
public with sharing class Test_BoxFolderIDMapANDDeleteAttachments{

static testMethod void Test_BoxFolderIDMapTrigger(){


Map<String,String> mapRecordTypeCI=new  Map<String,String>();
       Schema.sObjectType objType = Consumer_Inquiries__c.getSObjectType();
       Schema.DescribeSObjectResult sObjReslt = objType.getDescribe();  
       Map<String,Schema.RecordTypeInfo> rtMapByName = sObjReslt.getRecordTypeInfosByName();
       Map<String,CIS_Counts__c> mapConsumerHistory=new Map<String,CIS_Counts__c>();
       
       for(String str:rtMapByName.keySet()){
             Schema.RecordTypeInfo rtByName =  rtMapByName.get(str);
             if(rtByName.isAvailable()){
                mapRecordTypeCI.put(rtByName.getName(),rtByName.getRecordTypeId());
             }
       }

 Consumer_Inquiries__c cI = new Consumer_Inquiries__c();
         //String strRecordTypeName=mapRecordTypeCI.get(cI.RecordTypeId);
             cI.Firm_Name__c =[Select id from Account limit 1].Id;
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
             
             

 Attachment attach1 = new Attachment(Name = 'TEST ATTACHMENT'
                          , Body = Blob.valueOf('TEST BODY')
                          , ParentId = cI.Id
                          
                          , IsPrivate = false);
        insert attach1; 
        
         Attachment attach2 = new Attachment(Name = 'TEST ATTACHMENT'
                          , Body = Blob.valueOf('TEST BODY11')
                          , ParentId = cI.Id
                          
                          , IsPrivate = false);
        insert attach2; 
        
        Box_Mapping_Table__c  b = new Box_Mapping_Table__c();
        b.Attachment_ID__c = attach1.id;
        b.Consumer_Inquiries__c = cI.id;
        b.Parent_ID__c = cI.Firm_Name__c;
        b.Type__c = 'Consumer Inquiry';
        b.Attachment_Name__c = 'TEST ATTACHMENT';
        b.Box_Upload__c =True;
        insert b;
        
         Box_Mapping_Table__c  b1 = new Box_Mapping_Table__c();
        b1.Attachment_ID__c = attach2.id;
        b1.Consumer_Inquiries__c = cI.id;
        b1.Parent_ID__c = cI.Firm_Name__c;
        b1.Type__c = 'Case-EmailMessage';
        b1.Attachment_Name__c = 'TEST ATTACHMENT';
        b1.Box_Upload__c =True;
        insert b1;

   
       

}





}