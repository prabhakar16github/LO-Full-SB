/*
##########################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: Class : "LC_CreateDateFolderunderFirm"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 29-Sep-2014
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 12-Dev-2014
# Description...........: It's a BOX Utility Class to create Folder on Box for All newly created Firm Dates with Blank FolderID get 
#                          from ScheduleFirmDatesCreation class
# BOX Sequence..........: 06 Account Level - Needed
###############################################################################################################################################
*/  


public with sharing class LC_CreateDateFolderunderFirm {
    
    public static captureFolderResponse cfr;
    public static string access_token;
    public static ErrorResponse erp;
    
    public static pageReference getAccess(){
        access_token = [Select Id, Name, Token__c from Access_Token__c].Token__c;
        return null;
    }

    @future(callout=true)
    public static void createFolder(Id FirmDateID, string FolderName, string ParentID){ // SFDC ID = FirmDateID,FolderName= 2014-11, ParenID= Firm BOX FolderID i.e. KY9=123456789
        getAccess();
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint('https://api.box.com/2.0/folders');
        req.setHeader('Authorization', 'Bearer '+access_token);
        req.setBody('{"name":"'+FolderName+'","parent":{"id":"'+ParentID+'"}}');//Root Folder
        req.setMethod('POST');
        req.setTimeout(120000);
        HTTPResponse res = new HTTPResponse();
        HTTP Create_Firm = new HTTP();
        res = Create_Firm.send(req);
        
        //Converting the response to catch in Wrapper Class
        string bodystring = res.getBody();
        if(res.getStatusCode() == 200 || res.getStatusCode() == 201){
            cfr = new captureFolderResponse();
            cfr = (captureFolderResponse)JSON.deserialize(bodyString,captureFolderResponse.class); // Parsing Json Response
            if(cfr.id != Null && cfr.id != ''){
                system.debug('Hello The Folder ID is'+cfr.id);
                Firm_Dates__c fdc = new Firm_Dates__c();
                fdc.Id = FirmDateID;
                fdc.Folder_ID__c = cfr.id;
                update fdc;
            }
        }else if(res.getStatusCode() == 409){
            erp = new ErrorResponse();
            erp = (ErrorResponse)JSON.deserialize(bodyString,ErrorResponse.class);
            if(erp.status == 409){
                system.debug('Hello The Status is'+erp.status);
                if(erp.context_info != Null){
                    CI CInfo = new CI();
                    CInfo = erp.context_info;
                    if(CInfo.conflicts != Null && CInfo.conflicts.size() > 0){
                        cfts conf = new cfts();
                        conf = CInfo.conflicts[0];
                        if(conf.id != Null && conf.id != ''){
                            Firm_Dates__c fdc = new Firm_Dates__c();
                            fdc.Id = FirmDateID;
                            fdc.Folder_ID__c = conf.id;
                            update fdc;
                        }
                    }
                }
            }
        }
    }
    
    /* Folder  Wrapper */
    public class captureFolderResponse{
        public string type;
        public string id;
        public string sequence_id;
        public string etag;
        public string name;
        public string created_at;
        public string modified_at;
        public string description;
        public integer size;
        //public list<path_collection> pathcollectionlist;
        //public list<created_by> createdlist;
        //public list<modified_by> modifiedlist;
        public string trashed_at;
        public string purged_at;
        public string content_created_at;
        public string content_modified_at;
        //public list<owned_by> Ownedlist;
        public string shared_link;
        public string folder_upload_email;
        //public list<parent> parentList;
        public string item_status;
        //public list<item_collection> itemlist;
        public captureFolderResponse(){
            type = '';
            id = '';
            sequence_id = '';
            etag = '';
            name = '';
            created_at = '';
            modified_at = '';
            description = '';
            size = 0;
            //pathcollectionlist = new list<path_collection>();
            //createdlist = new list<created_by>();
            //modifiedlist = new list<modified_by>();
            trashed_at = '';
            purged_at = '';
            content_created_at = '';
            content_modified_at = '';
            //Ownedlist = new list<owned_by>();
            shared_link = '';
            folder_upload_email = '';
            //parentList = new list<parent>();
            item_status = '';
            //itemlist = new list<item_collection>();
        }
    }
    /* Folder  Wrapper */
    
   /* public class path_collection{
        public integer total_count;
        public list<entries> entrylist;
        public path_collection(){
            total_count = 0;
            entrylist = new list<entries>();
        }
    } */
    
    /* Folder  Wrapper */
    
  /*  public class entries{
        string type;
        string id;
        string sequence_id;
        string etag;
        string name;
        public entries(){
            type = '';
            id = '';
            sequence_id = '';
            etag = '';
            name = '';
        }
    } */
    
    /* Folder  Wrapper */
    
   /* public class created_by{
        public string type;
        public string id;
        public string name;
        public string login;
        public created_by(){
            type = '';
            id = '';
            name = '';
            login = '';
        }
    } */
    
    /* Folder  Wrapper */
    
  /*  public class modified_by{
        public string type;
        public string id;
        public string name;
        public string login;
        public modified_by(){
            type = '';
            id = '';
            name = '';
            login = '';
        }
    } */
    
    /* Folder  Wrapper */
    
  /*  public class owned_by{
        public string type;
        public string id;
        public string name;
        public string login;
        public owned_by(){
            type = '';
            id = '';
            name = '';
            login = '';
        }
    } */
    
    /* Folder  Wrapper */
    
   /* public class parent{
        public string type;
        public string id;
        public string name;
        public string sequence_id;
        public string etag;
        public parent(){
            type = '';
            id = '';
            name = '';
            sequence_id = '';
            etag = '';
        }
    } */
    
    /* Folder  Wrapper */
    
   /* public class item_collection{
        public integer total_count;
        public integer offset;
        public integer limit1;
        public list<Order> orderlist;
        public list<string> entrlist;
        public item_collection(){
            total_count = 0;
            offset = 0;
            limit1 = 0;
            entrlist = new list<string>();
            orderlist = new list<Order>();
        }
    } */
    
    /* Folder  Wrapper */
    
  /*  public class Order{
        public string by1;
        public string direction;
        public Order(){
            by1 = '';
            direction = '';
        }
    } */
    
    /*Error Response*/
    public class ErrorResponse{
        public string type;
        public integer status;
        public string code;
        public string help_url;
        public string message;
        public string request_id;
        public CI context_info;
    }
    
    public class CI{
        public list<cfts> conflicts;
    }
    
    public class cfts{
        public string type;
        public string id;
        public string sequence_id;
        public string etag;
        public string name;
    }
    /*Error Response*/
}