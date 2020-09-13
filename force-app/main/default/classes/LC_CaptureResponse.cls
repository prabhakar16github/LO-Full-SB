// Needed this class by sunny

public with sharing class LC_CaptureResponse {
    
    public string Authorization_Code;
    public CaptureResponse resp;
    public captureFolderResponse cfr;
    public captureFolderResponse cfr2;
    //public Attachment dct;
    
    public LC_CaptureResponse(){
        //dct = new Attachment();
        //dct = [Select Id, Name from Attachment][0];
        Authorization_Code = apexpages.currentPage().getParameters().get('code');
        resp = new CaptureResponse(); 
        cfr2 = new captureFolderResponse();
    }
    
    public pageReference getAccessToken(){
        system.debug('The Authorization Code is'+Authorization_Code);
        HTTPRequest req = new HTTPRequest();
        HTTPResponse res = new HTTPResponse();
        req.setMethod('POST');
        req.setEndpoint('https://app.box.com/api/oauth2/token');
        
        BoxDetails__c myBFclientid = BoxDetails__c.getInstance('client_id');
        String clientid = myBFclientid.BOX_Parent_Folder__c;
        System.debug('Sunny------>>>'+clientid);
                                                                   //'&client_id=3wciossk97vvab00mrifkgigqo9f0g0b&client_secret=uNrQYRXoLpY4B8ISmnpwe7RrLC0a3n3D');
        
        BoxDetails__c myBF = BoxDetails__c.getInstance('client_secret');
        String clientSecret = myBF.BOX_Parent_Folder__c;
        System.debug('Sunny------>>>'+clientSecret);
        
                  
        req.setBody('grant_type=authorization_code&code='+Authorization_Code+'&client_id='+clientid+'&client_secret='+clientSecret);
        HTTP get_Access_Token = new HTTP();
        res = get_Access_Token.send(req);
        String bodyString = res.getBody();
        resp = (CaptureResponse)JSON.deserialize(bodyString,CaptureResponse.class);
        system.debug('The response body is '+resp.access_token);
        system.debug('The response body is '+resp.refresh_token);
        system.debug('The response body is '+res.getBody());
        system.debug('The response body is '+res.getStatus());
        if(res.getStatus() == 'OK'){
            //InsertFolders();
            //retrieveFolders();
        }
        return null;
    }
    
    public pageReference retrieveFolders(){
        HTTPRequest req = new HTTPRequest();
        HTTPResponse res = new HTTPResponse();
        req.setEndpoint('https://api.box.com/2.0/folders/2555630553/items?limit=10&offset=0');
        req.setHeader('Authorization', 'Bearer '+resp.access_token);
        req.setMethod('GET');
        HTTP getFolders = new HTTP();
        res = getFolders.send(req);
        system.debug('The folder Items contains'+res.getBody());
        return null;
    }
    
    
    public pageREference InsertFolders(){
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint('https://api.box.com/2.0/folders');
        req.setHeader('Authorization', 'Bearer '+resp.access_token);
        req.setBody('{"name":"New Folder1","parent":{"id":"2573128889"}}');
        req.setMethod('POST');
        HTTPResponse res = new HTTPResponse();
        HTTP get_Access_Token = new HTTP();
        res = get_Access_Token.send(req);
        string bodystring = res.getBody();
        cfr = (captureFolderResponse)JSON.deserialize(bodyString,captureFolderResponse.class);
        system.debug('The response body is '+res.getBody());
        system.debug('The response body is '+cfr.id);
        if(cfr.id != Null && cfr.id != ''){
            InsertSubFolders(cfr.id);
        }
        return null;
    }
    
    public pageReference InsertSubFolders(string FolderID){
        HTTPResponse res1 = new HTTPResponse();
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint('https://api.box.com/2.0/folders');
        req.setHeader('Authorization', 'Bearer '+resp.access_token);
        req.setMethod('POST');
        
        req.setBody('{"name":"New Folder11","parent":{"id":"'+ FolderID +'"}}');
        HTTP get_Access_Token = new HTTP();
        res1 = get_Access_Token.send(req);
        string bodystring = res1.getBody();
        cfr = (captureFolderResponse)JSON.deserialize(bodyString,captureFolderResponse.class);
        
        req.setBody('{"name":"New Folder22","parent":{"id":"'+ FolderID +'"}}');
        HTTPResponse res2 = new HTTPResponse();
        res2 = get_Access_Token.send(req);
        string bodystring2 = res2.getBody();
        cfr2 = (captureFolderResponse)JSON.deserialize(bodyString2,captureFolderResponse.class);
        if(cfr2.id  != Null && cfr2.id != ''){
            //insertFile();
        }
        return null;
    }
    
    public Attachment dct  {

   get{

       if (dct == null)

       dct = new Attachment();

       return dct;

       }

       set;

     }
     
    public pageReference insertFile(){
        //dct.Name = 'Test Document';
        //dct.body = Blob.valueOf('Unit Test Document Body');
        dct = new Attachment();
        dct.Name = 'Test Name';
        dct.ParentId = '006J000000GuDnw';
        dct.Body = blob.valueOf('Hello This is Nikhil');
        
        String p_fileName = dct.name;
        String boundary = '__boundary__xxx';
        
        String header= 'Content:\r\n--' + boundary + '\r\nContent-Disposition:attachment;name="' + p_fileName +'";filename="'+p_fileName+'"\r\n';
        header +='Content-Type: '+dct.ContentType+'\r\n';
        header +='Content-Transfer-Encoding: base64\r\n\r\n';
        String footer = '\n--'+boundary+'--';
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header));
        while(headerEncoded.endsWith('=')){
            header+=' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header));
        }
        String bodyEncoded = EncodingUtil.base64Encode(dct.body);
        String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
        Blob bodyBlob = null;
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
        bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        //if(bodyBlob.size()>3000000){
            
        //}
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type','multipart/form-data;boundary='+boundary);
        req.setHeader('Content-Encoding','base64');
        req.setMethod('POST');
        req.setEndpoint('https://upload.box.com/api/2.0/files/content?access_token='+resp.access_token+'&parent_id='+cfr2.id+'&filename=@'+dct.name);
        req.setBodyAsBlob(bodyBlob);
        req.setTimeout(60000);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String resp=res.getBody();
        system.debug('////'+resp);
        return null;
    }
    
    public class CaptureResponse{
        public string access_token;
        public string expires_in;
        public string refresh_token;
        public string token_type;
        
        public CaptureResponse(){
            access_token = '';
            expires_in = '';
            refresh_token = '';
            token_type = '';
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
        public list<path_collection> pathcollectionlist;
        public list<created_by> createdlist;
        public list<modified_by> modifiedlist;
        public string trashed_at;
        public string purged_at;
        public string content_created_at;
        public string content_modified_at;
        public list<owned_by> Ownedlist;
        public string shared_link;
        public string folder_upload_email;
        public list<parent> parentList;
        public string item_status;
        public list<item_collection> itemlist;
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
            pathcollectionlist = new list<path_collection>();
            createdlist = new list<created_by>();
            modifiedlist = new list<modified_by>();
            trashed_at = '';
            purged_at = '';
            content_created_at = '';
            content_modified_at = '';
            Ownedlist = new list<owned_by>();
            shared_link = '';
            folder_upload_email = '';
            parentList = new list<parent>();
            item_status = '';
            itemlist = new list<item_collection>();
        }
    }
    /* Folder  Wrapper */
    
    public class path_collection{
        public integer total_count;
        public list<entries> entrylist;
        public path_collection(){
            total_count = 0;
            entrylist = new list<entries>();
        }
    }
    
    /* Folder  Wrapper */
    
    public class entries{
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
    }
    
    /* Folder  Wrapper */
    
    public class created_by{
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
    }
    
    /* Folder  Wrapper */
    
    public class modified_by{
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
    }
    
    /* Folder  Wrapper */
    
    public class owned_by{
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
    }
    
    /* Folder  Wrapper */
    
    public class parent{
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
    }
    
    /* Folder  Wrapper */
    
    public class item_collection{
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
    }
    
    /* Folder  Wrapper */
    
    public class Order{
        public string by1;
        public string direction;
        public Order(){
            by1 = '';
            direction = '';
        }
    }
    
    /* Folder  Wrapper */
    
    /* File  Wrapper */
    
    /* File  Wrapper */
}