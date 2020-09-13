@isTest
private class TestTrgTrialWitnessAttachments{
static testMethod void testAttachments()
    {
            Trial_Witness_Request__c tw  = new Trial_Witness_Request__c();
            tw.Assigned_Attorney__c = 'dfgf';
            tw.Defendant_Name__c = 'dfgf';
            insert tw;
            Attachment attach=new Attachment();    
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=tw.id;
            insert attach;
          
            Account accObj = new Account();
            accObj.Firm_ID__c ='test';
            accObj.Name = 'CA137';
            accObj.Phone = '98828383';
            accObj.Physical_Street__c= 'test';
            accObj.Physical_City__c = 'city';
            accObj.Physical_Postal_Code__c = '11111';
            accObj.Physical_Country__c = 'test country';
            accObj.Physical_State_Province__c = 'Province';
            accObj.Paralegal__c = UserInfo.getUserId();
            accObj.MCM_Attorney__c = UserInfo.getUserId();
            insert accObj;
            
            Consumer_Account_Details__c cadObj = new Consumer_Account_Details__c();
            cadObj.Organization_name__c = accObj.id;
            cadObj.Account_Number__c = '111';
            cadObj.OwnerId =  UserInfo.getUserId();
            cadObj.Original_Creditor__c = 'test';
            cadObj.CAD_Credit_Card__c = true;
            insert cadObj;
          
            Counterclaim__c ccObj = new Counterclaim__c();
            ccObj.CC_Organization_Name__c = accObj.id;
            ccObj.CC_Consumer_Account_Detail_Name__c = cadObj.id;
            ccObj.CC_Matter_Name__c = 'test';
            ccObj.CC_Court_File__c = 'test';
            ccObj.CC_Account_Number__c = '124';
            ccObj.CC_County_Court_Name__c= 'test';
            ccObj.CC_Judge_Name__c = 'test';
            ccObj.CC_Prior_Experience_with_Judge__c = 'Yes';
            ccObj.CC_IfPriorExperience_with_Judge_Comments__c = 'test';
            ccObj.CC_Assigned_Attorney__c = 'test';
            ccObj.CC_Assigned_Attorney_Cell_Phone__c = '3463463464';
            ccObj.CC_Assigned_Attorney_Direct_Line__c = '74574';
            ccObj.CC_Assigned_Attorney_Email__c = 'test@gmail.com';
            ccObj.CC_Opposing_Counsel__c = 'test';
            ccObj.CC_Opposing_Counsel_Comments__c = 'test';
            ccObj.CC_Opposing_Counsel_Email__c = 'email@gmail.com';
            ccObj.CC_Opposing_Counsel_Firm_Name__c = 'test';
            ccObj.CC_Opposing_counsel_Phone__c = '34634';
            ccObj.CC_Counterclaim_Status__c = 'New';
            insert ccObj;   
            Attachment attachCC=new Attachment();
            attachCC.Name='Unit Test Attachment';
            attachCC.body=Blob.valueOf('Unit Test Attachment Body');
            attachCC.parentId=ccObj.id;
            insert attachCC;
            
            Escalated_Contested_Matters__c ecmObj = new Escalated_Contested_Matters__c();
            ecmObj.ECM_Organization_Name__c = accObj.id;
            ecmObj.ECM_Consumer_Account_Detail_Name__c = cadObj.id;
            ecmObj.ECM_Opposing_Counsel__c = 'test';
            ecmObj.ECM_Opposing_Counsel_Comments__c = 'test';
            ecmObj.ECM_Opposing_Counsel_Email__c = 'i@gmail.com';
            ecmObj.ECM_Opposing_Counsel_Firm_Name__c = 'test';
            ecmObj.ECM_Opposing_counsel_Phone__c = '235235';
            insert ecmObj;
            Attachment attachECM=new Attachment();
            attachECM.Name='Unit Test Attachment';
            attachECM.body=Blob.valueOf('Unit Test Attachment Body');
            attachECM.parentId=ecmObj.id;
            insert attachECM;
          
            Discovery__c discoveryObj = new Discovery__c();
            discoveryObj.DY_Organization_Name__c = accObj.id;
            discoveryObj.DY_Request_For_Admissions__c = true;
            discoveryObj.DY_Matter_Name__c = 'test';
            discoveryObj.DY_Account_Number__c = 'test';
            discoveryObj.DY_Court_File__c = 'test';
            discoveryObj.DY_County_Court_Name__c = 'test';
            discoveryObj.DY_Judge_Name__c = 'test';
            discoveryObj.DY_Prior_Experience_with_Judge__c = 'Yes';
            discoveryObj.DY_IfPriorExperience_with_Judge_Comments__c = 'test';
            discoveryObj.DY_Assigned_Attorney__c = 'test';
            discoveryObj.DY_Assigned_Attorney_Cell_Phone__c = '23523';
            discoveryObj.DY_Assigned_Attorney_Direct_Line__c = '34534';
            discoveryObj.DY_Assigned_Attorney_Email__c = 'i@gmail.com';
            discoveryObj.DY_Opposing_Counsel__c = 'test';
            discoveryObj.DY_Opposing_Counsel_Comments__c = 'test';
            discoveryObj.DY_Opposing_Counsel_Email__c = 'i@gmail.com';
            discoveryObj.DY_Opposing_Counsel_Firm_Name__c = 'test';
            discoveryObj.DY_Opposing_counsel_Phone__c = '235235';
            discoveryObj.DY_Consumer_Account_Details__c = cadObj.id;
            insert discoveryObj;
            Attachment attachDY=new Attachment();
            attachDY.Name='Unit Test Attachment';
            attachDY.body=Blob.valueOf('Unit Test Attachment Body');
            attachDY.parentId=discoveryObj.id;
            insert attachDY;
          
            Business_Record_Affidavit__c braObj = new Business_Record_Affidavit__c();
            braObj.Recordtypeid = Schema.SObjectType.Business_Record_Affidavit__c.getRecordTypeInfosByName().get('BRA: Record Type').getRecordTypeId();
            braObj.BRA_Organization_Name__c = accObj.id;
            braObj.BRA_Original_Creditor__c = 'test';
            braObj.BRA_Consumer_Account_Details_Record__c = cadObj.id;
            braObj.BRA_Opposing_Counsel__c = 'test';
            braObj.BRA_Opposing_Counsel_Comments__c = 'test';
            braObj.BRA_Opposing_Counsel_Email__c = 'i@gmail.com';
            braObj.BRA_Opposing_Counsel_Firm_Name__c = 'test';
            braObj.BRA_Opposing_counsel_Phone__c = '235235';
            insert braObj;
            Attachment attachBRA=new Attachment();
            attachBRA.Name='Unit Test Attachment';
            attachBRA.body=Blob.valueOf('Unit Test Attachment Body');
            attachBRA.parentId=braObj.id;
            insert attachBRA;
            
            Purchase_and_Sales_Agreement__c psaObj = new Purchase_and_Sales_Agreement__c();
            psaObj.PSA_Organization_Name__c = accObj.id;
            psaObj.PSA_Portfolio__c = 'test';
            psaObj.PSA_Chain_of_Title__c = 'test';
            psaObj.PSA_Original_Creditor__c = 'test';
            psaObj.PSA_Consumer_Account_Detail_Name__c = cadObj.id;
            psaObj.PSA_Opposing_Counsel__c = 'test';
            psaObj.PSA_Opposing_Counsel_Comments__c = 'test';
            psaObj.PSA_Opposing_Counsel_Email__c = 'i@gmail.com';
            psaObj.PSA_Opposing_Counsel_Firm_Name__c = 'test';
            psaObj.PSA_Opposing_counsel_Phone__c = '235235';
            insert psaObj;
            Attachment attachPSA=new Attachment();
            attachPSA.Name='Unit Test Attachment';
            attachPSA.body=Blob.valueOf('Unit Test Attachment Body');
            attachPSA.parentId=psaObj.id;
            insert attachPSA;
            
            Account a = new Account();
            a.Name = 'TestAcc';
            a.Firm_ID__c = 'Test';
            insert a;
            Account a1 = new Account();
            a1.Name = 'TestAcc';
            a1.Firm_ID__c = 'Test';
            insert a1;
         	
         	Test.startTest();
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
            callMontring.Organization_Name_CM__c = a1.id;
            callMontring.Reporting_Month_CM__c = '01';
            callMontring.Reporting_Year_CM__c = '2015';
            callMontring.Most_Recent_Attachment_Date__c=system.today()-30;      
            insert callMontring;
        
            Attachment attach1=new Attachment();    
            attach1.Name='Unit Test Attachment';
            Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
            attach1.body=bodyBlob;
            attach1.parentId=callMontring.id;
            insert attach1;
            
        	Test.stopTest();
        	
            Attachment attach2=new Attachment();    
            attach2.id=attach.id;            
            delete attach2;  
            
            Attachment attach3=new Attachment();    
            attach3.id=attach1.id;            
            delete attach3;  
            
            //delete attachCC;
            //delete attachECM;
            //delete attachBRA;
            //delete attachDY;
            //delete attachPSA;
            
             
            
     }
     
     static testmethod void setAttachmentCallMonitoring(){
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
     		Account a = new Account();
            a.Name = 'TestAcc';
            a.Firm_ID__c = 'Test';
            insert a;
     	    Call_Monitoring__c callMontring1 = new Call_Monitoring__c();
            callMontring1.RecordTypeID = ID.ValueOF(mapRecordType.get('Call Monitoring QA'));
            callMontring1.Attachments__c = false;
            callMontring1.Organization_Name_CM__c = a.id;
            callMontring1.Reporting_Month_CM__c = '01';
            callMontring1.Reporting_Year_CM__c = '2015';
            insert callMontring1;
        	
        	Test.startTest();
            Attachment attachCall = new Attachment();    
            attachCall.Name = 'Unit Test Attachment';
            Blob bodyBlob2 = Blob.valueOf('Unit Test Attachment Body');
            attachCall.body = bodyBlob2;
            attachCall.parentId = callMontring1.id;
            insert attachCall;
            Test.stopTest();
     }
}