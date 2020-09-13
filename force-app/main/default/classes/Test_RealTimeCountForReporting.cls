@isTest
public class Test_RealTimeCountForReporting{
	
    static testMethod void CountTrigger(){
        String CIProfileName;

    // Get Profile Name from Custom Setting Details
     
    ProfileName__c getProfileName = new ProfileName__c(Name = 'CI_ProfileName', ProfileLabel__c = 'CC - User Access');
    insert getProfileName;
   
     if(getProfileName !=null){
      CIProfileName = getProfileName.ProfileLabel__c;  
        Profile objProfile=[Select id,name from Profile where Name=:CIProfileName];
       String strProfileId=objProfile.id; 
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
       
         List<User> u = [Select u.Username,u.Accountid,u.UserType,u.IsActive, u.IsPortalEnabled, u.Department, 
                      u.Contact.Community_Profile__c,u.Contact.Inactive_Contact__c, u.Contact.Firm_ID__c, 
                      u.Contact.Name, u.ContactId From User u where  u.UserType='CspLitePortal' and u.IsActive=True 
                      and profileid=:strProfileId 
                      and u.Department!=null limit 1];
                      
	      CIS_Counts__c CISobj = new CIS_Counts__c();
	      String strInquiryType='';
                       
         Consumer_Inquiries__c consumerInquiryObj = new Consumer_Inquiries__c( Account_Type__c = 'AA', Reporting_Month__c = '01', Reporting_Year__c = '2018', RecordTypeId = '012U0000000QMUI'); 
         insert consumerInquiryObj;
         Consumer_Inquiries__c cITemp = [SELECT Account_Type__c,Id,Type__c,Reporting_Month__c,Reporting_Year__c FROM Consumer_Inquiries__c WHERE RecordTypeId = '012U0000000QMUI' limit 1];
         cITemp.RecordTypeId = '012U0000000QMUN';
         //cITemp.Final_Resolution__c='test';
          cITemp.Date_Received__c = system.today(); // Response to Consumer, Result of Investigation and Final Resolution fields
         cITemp.Response_to_Consumer__c='test';
         cITemp.Result_of_Investigation__c='test';
         cITemp.Final_Resolution__c='test';
         cITemp.Date_Closed__c=System.today(); //.addDays(8)
         cITemp.Firm_Name__c = u.get(0).Accountid;
         cITemp.Account_Type__c = 'AA';
         update cITemp;
         
         cITemp.RecordTypeId = '012U0000000QMUS';
         cITemp.Type__c = 'Consumer Dissatisfaction';
         cITemp.Account_Type__c = 'MCM';
         update cITemp;
                 
         Consumer_Inquiries__c cIList = [select id from Consumer_Inquiries__c where ID =:cITemp.ID];
         delete cIList;
         
         database.undelete(cITemp.ID);
         
         Consumer_Inquiries__c cI = new Consumer_Inquiries__c();
         //String strRecordTypeName=mapRecordTypeCI.get(cI.RecordTypeId);
         
             if(!u.isEmpty()){
             cI.Firm_Name__c =u[0].Accountid;
             cI.RecordTypeId = mapRecordTypeCI.get('Consumer Dissatisfaction');
             if(!u.isEmpty()){
             cI.OwnerId = u[0].id;
             cI.Account_Type__c = 'MCM';
             }
             cI.Nature_of_Inquiry__c='Calling Repeatedly';
             cI.Source_of_Inquiry__c='Test';
             cI.Account_Number__c='345';
             cI.Consumer_Name__c='Test';
             cI.Date_Received__c = system.today(); // Response to Consumer, Result of Investigation and Final Resolution fields
             cI.Response_to_Consumer__c='test';
             cI.Result_of_Investigation__c='test';
             cI.Final_Resolution__c='test';
             cI.Date_Closed__c=System.today(); //.addDays(8)
             cI.Reporting_Month__c=String.valueOf(System.today().month());
             cI.Reporting_Year__c=String.valueOf(System.today().year());
             cI.Inquiry_Summary__c='Test';
             cI.Wrong_Party_Complaint__c='No';
             strInquiryType='CD';
             insert cI; 
             }
             
             
             cI.RecordTypeId = mapRecordTypeCI.get('Regulatory Complaint');
             strInquiryType='RC';
             update cI;
             
             
             //Consumer_Inquiries__c CI1 = [select Firm_Name__c, RecordTypeId, Account_Type__c, Nature_of_Inquiry__c, Source_of_Inquiry__c, Account_Number__c, Consumer_Name__c, Date_Received__c, Date_Closed__c, Reporting_Month__c, Reporting_Year__c, Inquiry_Summary__c, Wrong_Party_Complaint__c from Consumer_Inquiries__c Where ID =:cI.ID];
             
             Consumer_Inquiries__c CI1 = cI.clone();
             insert CI1;
             
             CI1.RecordTypeId = mapRecordTypeCI.get('No Consumer Inquiries');
             CI1.Type__c = 'Consumer Dissatisfaction';
             CI1.Reporting_Month__c = String.valueOf(System.today().month()-1);
             strInquiryType='CD';
             update CI1;
             
             Consumer_Inquiries__c CI2 = CI1.clone();
             insert CI2;
             
             CI2.RecordTypeId = mapRecordTypeCI.get('No Consumer Inquiries');
             CI2.Type__c = 'Regulatory Complaint';
             CI2.Final_Resolution__c='Test';
             CI2.Response_to_Consumer__c='test';
             CI2.Result_of_Investigation__c='test';
             strInquiryType='RC';
             update CI2;
             
             Consumer_Inquiries__c CI3 = CI2.clone();
              CI3.Final_Resolution__c='Test';
             CI3.Response_to_Consumer__c='test';
             CI3.Result_of_Investigation__c='test';
             CI3.Date_Closed__c=System.today().addDays(8);
             insert CI3;
             
             CI3.RecordTypeId = mapRecordTypeCI.get('Consumer Dissatisfaction');
             strInquiryType='CD';
             CI3.Reporting_Month__c = String.valueOf(System.today().month()-6);
             CI3.Reporting_Year__c = String.valueOf(System.today().year()-2);
             update CI3;
                          
             Consumer_Inquiries__c CI4 = CI1.clone();
             insert CI4;
             
             CI4.RecordTypeId = mapRecordTypeCI.get('Consumer Dissatisfaction');
             strInquiryType='CD';
             CI4.Account_Type__c = 'AA';
             CI4.Reporting_Month__c = String.valueOf(System.today().month()+2);
             CI4.Reporting_Year__c = String.valueOf(System.today().year()-1);
             update CI4;
             
             Consumer_Inquiries__c CI5 = CI4.clone();
             insert CI5;
             
             CI5.RecordTypeId = mapRecordTypeCI.get('Regulatory Complaint');
             strInquiryType='RC';
             CI5.Account_Type__c = 'AA';
             CI5.Reporting_Month__c = String.valueOf(System.today().month()-6);
             CI3.Reporting_Year__c = String.valueOf(System.today().year()-3);
             update CI5;
             
             Consumer_Inquiries__c CI6 = CI5.clone();
             insert CI6;
             
             CI6.RecordTypeId = mapRecordTypeCI.get('No Consumer Inquiries');
             CI6.Type__c = 'Consumer Dissatisfaction';
             strInquiryType='CD';
             CI4.Reporting_Month__c = String.valueOf(System.today().month()+2);
            // CI4.Reporting_Year__c = String.valueOf(System.today().year()+1);
             update CI6;
             
             Consumer_Inquiries__c CI7 = CI6.clone();
             insert CI7;
             
             CI7.Type__c = 'Regulatory Complaint';
             strInquiryType='RC';
             CI4.Reporting_Month__c = String.valueOf(System.today().month()+2);
             CI4.Reporting_Year__c = String.valueOf(System.today().year()+1);
             update CI7;
             
 
             List<Consumer_Inquiries__c> cc = [Select ID,RecordAccountTypeDevCombination__c From Consumer_Inquiries__c Where ID =:cI.ID];
             Delete cc;  
     }
       
             
    }
    
}