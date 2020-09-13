// Used for all test classes

public class LC_TestDataUtility {
    
    public static list<Account> createAccounts(Integer noofRecords){
        list<Account> accList = new list<Account>();
        Account acc = null;
        for(Integer i=0;i<noofRecords;i++){
            acc = new Account();
            acc.Name = 'Test Account - '+i;
           acc.Firm_ID__c = 'tID'+i;
            accList.add(acc);
        }
        insert accList; 
        return accList;
    }
    
    public static list<Case> createCases(Integer noofRecords){
        list<Case> caseList = new list<Case>();
        Case cs = null;
        for(Integer i=0;i<noofRecords;i++){
            cs = new Case();
            cs.Status = 'New';
            cs.Origin = 'Internal - AARS';
            caseList.add(cs);
        }
        insert caseList;
        return caseList;
    }
    
    public static list<Consumer_Inquiries__c> createConsumerInquiries(list<Account> accList){
        list<Consumer_Inquiries__c> ciList = new list<Consumer_Inquiries__c>();
        RecordType rt = [select Id from RecordType where Name = 'Regulatory Complaint' and sObjectType = 'Consumer_Inquiries__c'];
        Consumer_Inquiries__c ci = null;
        for(Account acc: accList){
            ci = new Consumer_Inquiries__c();
            ci.Firm_Name__c = acc.Id;
            ci.Nature_of_Inquiry__c= 'Bankruptcy Stay Violation';
            ci.Source_of_Inquiry__c = 'Oral';
            ci.Account_Type__c = 'AARS';
            ci.Account_Number__c = 'Test No';
            ci.Consumer_Name__c = 'Test Name';
            ci.Date_Received__c = system.today(); // Response to Consumer, Result of Investigation and Final Resolution fields
            cI.Date_Closed__c=System.today(); //.addDays(8)
            ci.Response_to_Consumer__c='test';
            ci.Result_of_Investigation__c='test';
            ci.Final_Resolution__c='test';
            ci.Reporting_Month__c = '01';
            ci.Reporting_Year__c = '2014';
            ci.Theme_of_Inquiry__c='Test';
            ci.Inquiry_Summary__c = 'Test Summary';
            ci.Wrong_Party_Complaint__c = 'No';
            ci.RecordTypeId = rt.Id;
            ciList.add(ci);
        }
        insert ciList;
        return ciList;
    }
    
    public static list<Box_Folder_ID_Map__c> createBoxFolderIDs(list<Account> accList, string typeValue, Boolean folderId){
        list<Box_Folder_ID_Map__c> BoxFolderIDList = new list<Box_Folder_ID_Map__c>();
        Box_Folder_ID_Map__c BoxFolderID = null;
        for(Integer i=0;i<accList.size();i++){
            system.debug('BFIM '+i+'== '+[select count() from Box_Folder_ID_Map__c where Reference_ID__c =: accList[i].Id]);
            BoxFolderID = new Box_Folder_ID_Map__c();
            system.debug('Account Id == '+accList[i].Id);
            BoxFolderID.Reference_ID__c = accList[i].Id;
            BoxFolderID.Created_Date__c = system.today();
            BoxFolderID.Firm_ID__c = accList[i].Firm_ID__c;
            BoxFolderID.Type__c = typeValue;
            BoxFolderID.Folder_ID__c = '123456'+i;
            if(folderId)
                BoxFolderID.Folder_ID__c = '11446498'+i;
            BoxFolderIDList.add(BoxFolderID);
        }
        insert BoxFolderIDList;
        return BoxFolderIDList;
    }
    
    public static list<Box_Folder_ID_Map__c> createCIBoxFolderIDs(list<Consumer_Inquiries__c> ciList, string typeValue, Boolean folderId){
        list<Box_Folder_ID_Map__c> BoxFolderIDList = new list<Box_Folder_ID_Map__c>();
        Box_Folder_ID_Map__c BoxFolderID = null;
        for(integer i=0; i<ciList.size();i++){
            BoxFolderID = new Box_Folder_ID_Map__c();
            BoxFolderID.Reference_ID__c = ciList[i].Id;
            BoxFolderID.Created_Date__c = system.today();
            //BoxFolderID.Firm_ID__c = acc.Firm_ID__c;
            BoxFolderID.Type__c = typeValue;
            BoxFolderID.CI_Parent_Folder_ID__c = 'Test1234'+i;
            if(folderId)
                BoxFolderID.Folder_ID__c = '11446498'+i;
            BoxFolderIDList.add(BoxFolderID);
            system.debug('BoxFolderID == '+BoxFolderID);
        }
        insert BoxFolderIDList;
        return BoxFolderIDList;
    }
    
    public static list<Attachment> createAttachments(set<Id> parentIds){
        list<Attachment> AttachmentList = new list<Attachment>();
        Attachment att = null;
        for(Id parentId: parentIds){
            att = new Attachment();
            att.Name = 'Test';
            att.ParentId = parentId;
            att.Body = blob.valueOf('Test body');
            att.ContentType = 'application/pdf';
            AttachmentList.add(att);
        }
        insert AttachmentList;
        return AttachmentList;
    }

}