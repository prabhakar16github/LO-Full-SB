/*
##########################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: Class : "LC_CreateFirmonBOX"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 29-Sep-2014
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 12-Dev-2014
# Description...........: This class intract with Box and only  create folder and retrive their Box Unique folder ID for further update back to 
#                         Box folder Map table for all calling records.
# BOX Sequence..........: 03 Account Level - Needed
###############################################################################################################################################
*/  


public with sharing class LC_CreateFirmonBOX {
     
    public static string access_token;
    public static captureFolderResponse cfr;
    public static ErrorResponse erp;
    
    public static pageReference getAccess(){
        access_token = [Select Id, Name, Token__c from Access_Token__c].Token__c;
        return null;
    }
    
    @future(callout=true)
    public static void createFolder(Id ActID, string FirmID){ // BoxMap table RecordID , Firm Name = KY9
        getAccess();
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint('https://api.box.com/2.0/folders');
        req.setHeader('Authorization', 'Bearer '+access_token); // Get access from above SOQL 23:
        
         /* Custom Settings for Client and Secret ID */
        BoxDetails__c myBOXRootFolderID = BoxDetails__c.getInstance('BOXRootFolderID');
        String BOXRootFolderID = myBOXRootFolderID.BOX_Parent_Folder__c;
        System.debug('Sunny------>>>'+BOXRootFolderID);     
        
        
        
        req.setBody('{"name":"'+FirmID+'","parent":{"id":'+BOXRootFolderID+'}}');// --Root Folder ......also passing Firm Unique Name under parent over Box
          
        req.setMethod('POST');
        req.setTimeout(120000);
        HTTPResponse res = new HTTPResponse();
        HTTP Create_Firm = new HTTP();
        res = Create_Firm.send(req);
        string bodystring = res.getBody();
        //Converting the response to catch in Wrapper Class
        system.debug('The Status code is'+res.getStatusCode());
        system.debug('The Status code is'+res.getBody());
        if(res.getStatusCode() == 200 || res.getStatusCode() == 201){ // 200 & 201 Means ALL OK i.e. Process Done 
            cfr = new captureFolderResponse();
            cfr = (captureFolderResponse)JSON.deserialize(bodyString,captureFolderResponse.class);
            if(cfr.id != Null && cfr.id != ''){
                HTTPRequest req1 = new HTTPRequest();
                req1.setEndpoint('https://api.box.com/2.0/folders/'+cfr.id);
                req1.setHeader('Authorization', 'Bearer '+access_token);
                req1.setBody('{"shared_link": {"access": "company"}}');
                req1.setMethod('PUT');
                req1.setTimeout(120000);
                HTTPResponse res1 = new HTTPResponse();
                HTTP Create_Shared_Link = new HTTP();
                res1 = Create_Shared_Link.send(req1);
            }
            if(cfr.id != Null && cfr.id != ''){
                system.debug('Hello The Folder ID is'+cfr.id);
                Box_Folder_ID_Map__c Folder = new Box_Folder_ID_Map__c();
                //system.debug('cfr.shared_link == '+cfr.shared_link);
                //if(cfr.shared_link != Null && cfr.shared_link.trim() != '')
                //  Folder.Box_Folder_Shared_Link__c = cfr.shared_link;
                Folder.Id = ActID;
                Folder.FOlder_ID__c = cfr.id;// It will update new folder Box Id in Salesforce
                update Folder;
            }
        }else if(res.getStatusCode() == 409){ // 409 Means Box Items already in Use
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
                            Box_Folder_ID_Map__c Folder = new Box_Folder_ID_Map__c();
                            //system.debug('cfr.shared_link == '+conf.shared_link);
                            //if(conf.shared_link != Null && conf.shared_link.trim() != '')
                            //  Folder.Box_Folder_Shared_Link__c = conf.shared_link;
                            Folder.Id = ActID;
                            Folder.FOlder_ID__c = conf.id; // retrieve Account Folder Id which was not in SFDC in BOXMAP Table and will update it
                            update Folder;
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
    
    /*public class path_collection{
        public integer total_count;
        public list<entries> entrylist;
        public path_collection(){
            total_count = 0;
            entrylist = new list<entries>();
        }
    }*/
    
    /* Folder  Wrapper */
    
    /*public class entries{
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
    }*/
    
    /* Folder  Wrapper */
    
    /*public class created_by{
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
    }*/
    
    /* Folder  Wrapper */
    
    /*public class modified_by{
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
    }*/
    
    /* Folder  Wrapper */
    
    /*public class owned_by{
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
    }*/
    
    /* Folder  Wrapper */
    
    /*public class parent{
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
    }*/
    
    /* Folder  Wrapper */
    
    /*public class item_collection{
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
    }*/
    
    /* Folder  Wrapper */
    
    /*public class Order{
        public string by1;
        public string direction;
        public Order(){
            by1 = '';
            direction = '';
        }
    }*/
    
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