/*
##########################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: class : "LC_DisplayFolderElementsController"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 29-Sep-2014
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 12-Dev-2014
# Description...........: This class helps in retrieving the files from Box Folder and joining them with existing attachments in Salesforce.
#                         Finally displays the Consolidated list.
# BOX Sequence..........: 01 Controller Class for LC_DisplayFolderElements.page 
###############################################################################################################################################
*/
public with sharing class LC_DisplayFolderElementsController {
    
    public Consumer_Inquiries__c CI;
    public Access_Token__c gats;
    public captureFileElements cfe;
    
    public list<displayAttachments> Box_Attachments{get;set;}
    public list<FileEntries> Files;
    
    public boolean displayIFrame{get;set;}
    public displayAttachments dat;
    
    
    public LC_DisplayFolderElementsController(apexpages.standardController sc){
        gats = new Access_Token__c();
        CI = new Consumer_Inquiries__c();
        cfe = new captureFileElements();
        displayIFrame = false;
        dat = new displayAttachments();
                
        Id CIID = apexpages.currentPage().getParameters().get('ID');
        CI = [Select Id, Name, RecordTypeID, Folder_ID__c, (select Id, Name, ContentType from Attachments) from Consumer_Inquiries__c Where Id =: CIID];
        
        list<RecordType> RTList = new list<RecordType>();
        RTList = [Select Id, Name from RecordType Where sObjectType = 'Consumer_Inquiries__c' and Name = 'Regulatory Complaint'];
        RecordType RCRT;
        if(RTList != Null && RTList.size() > 0){
            for(RecordType rt : RTList){
                RCRT = rt;
            }
        }
        
        gats = [Select Id, Name, Token__c, Refresh_Token__c, LastmodifiedDate From Access_Token__c];
        Box_Attachments = new list<displayAttachments>();
        Files = new list<FileEntries>();
        if(CI != Null){//Adding the Existing Attachments into list for the Specific CI 
            for(Attachment att : CI.attachments){
                dat = new displayAttachments();
                dat.Attachment_Name = att.name;
                dat.FileID = '';
                dat.location = 'Salesforce';
                string Extension;
                if(att.name != Null && att.name != ''){
                    integer IndexValue= att.name.lastIndexOf('.');
                    if(IndexValue > -1){
                        Extension = att.name.substring(IndexValue+1,att.name.length());// to show the actual file extension from salesforce
                    } 
                }
                dat.Type = Extension;
                Box_Attachments.add(dat);
            }
        }
        
        if(Box_Attachments != Null && Box_Attachments.size() > 0){
            displayIFrame = true;
        }else{
            displayIFrame = false;
        }
        
        list<Firm_s_Child__c> FolderMapList = new list<Firm_s_Child__c>();
        FolderMapList = [Select Id, Name, Box_Folder_ID__c from Firm_s_Child__c Where Reference_ID__c =: CIID and Type__c = 'Consumer Inquiry'];
        system.debug('FolderMapList Value----->'+FolderMapList );
        if(FolderMapList != Null && FolderMapList.size() > 0){
            displayFolderElements(FolderMapList[0].Box_Folder_ID__c);
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please try after some time as the folder has not yet created.'));
        }   
    }

    public void displayFolderElements(string FolderID){//Folder Id is picked up from Box Folder ID Map Table
        HTTPResponse res = new HTTPResponse();
        HTTPRequest req = new HTTPRequest();
        gats = [Select Id, Name, Token__c, Refresh_Token__c, LastmodifiedDate From Access_Token__c];
        req.setEndpoint('https://api.box.com/2.0/folders/'+FolderID+'/items');//Request URL for Folder Elements
        req.setHeader('Authorization','Bearer '+gats.Token__c);
        req.setMethod('GET');
        HTTP getFolderItems = new HTTP();
        res = getFolderItems.send(req);//Sending the request to get the actual response
        string bodystring = res.getBody();
        system.debug('The JSON Body is'+res.getBody());
        
        if(res.getStatusCode() == 200){
            cfe = (captureFileElements)JSON.deserialize(bodyString,captureFileElements.class);// Parsing the above request
            Files = cfe.entries;
    
           system.debug('Files vlue---->'+ Files);
           if(!Test.isRunningTest()) {
            for(FileEntries fe : Files)
            {////Adding the Box Files into list for the Specific CI
                string str; integer dotIndex;
                dat = new displayAttachments();
                dat.Attachment_Name = fe.name;
                dat.FileID = fe.id; dat.location = 'Box';
                if(fe.name.contains('.')){
                    str = fe.name;
                    dotIndex = fe.name.lastIndexOf('.');
                    system.debug('The dot Index is'+dotIndex);
                    system.debug('The Type could be '+str.substring(dotIndex+1,str.length()));
                    string str2 = str.substring(dotIndex+1,str.length());
                    dat.Type = str2;
                }
                Box_Attachments.add(dat);
                if(Box_Attachments != Null && Box_Attachments.size() > 0){
                    displayIFrame = true;
                }else{displayIFrame = false;
                 } } }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please try after some time as the folder has not yet created.'));
        }
        system.debug('The box Attachments are'+Box_Attachments);
    } 
    
    public class displayAttachments{
        public string Attachment_Name{get;set;}
        public string FileID{get;set;}
        public string Type{get;set;}
        public string location{get;set;}
        
        public displayAttachments(){
            Attachment_Name = '';
            FileID = '';
            Type = '';
            location = '';
        }
    }
    
    /* File Wrapper*/
    public class captureFileElements{
        public integer total_count;
        public list<FileEntries> entries;
        public integer offset;
        public integer limit2;
        public list<Orders> Order;
        
        public captureFileElements(){
        }
    }
    /* File Wrapper*/
    /* File Wrapper*/
    public class FileEntries{
        public string Type;
        public string id;
        public string sequence_id;
        public string etag;
        public string sha1;
        public string name;
    }
    /* File Wrapper*/
    /* File Wrapper*/
    public class orders{
        public string by1;
        public string direction;
    }
    /* File Wrapper*/
}