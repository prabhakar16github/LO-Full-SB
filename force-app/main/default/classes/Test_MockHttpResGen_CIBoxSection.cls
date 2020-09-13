@isTest

global class Test_MockHttpResGen_CIBoxSection implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        string str = '{"type": "folder","id": "11446498","sequence_id": "1","etag": "1","name": "Pictures","created_at": "2012-12-12T10:53:43-08:00","modified_at": "2012-12-12T11:15:04-08:00","description": "Some pictures I took","size": 629644,"path_collection": {"total_count": 1,"entries": [{"type": "folder","id": "0","sequence_id": null,"etag": null,"name": "All Files"}]},"created_by": {"type": "user","id": "226075787","name": "SVC LegalCMS","login": "svc.legalcms@mcmcg.com"},"modified_by": {"type": "user","id": "226075787","name": "SVC LegalCMS","login": "svc.legalcms@mcmcg.com"},"owned_by": {"type": "user","id":"226075787","name":"SVC LegalCMS","login":"svc.legalcms@mcmcg.com"},"shared_link": {"url": "https://www.box.com/s/vspke7y05sb214wjokpk","download_url": null,"vanity_url": null,"is_password_enabled": false,"unshared_at": null,"download_count": 0,"preview_count": 0,"access": "open","permissions": {"can_download": true,"can_preview": true}},"folder_upload_email": null,"parent": {"type": "folder","id": "2735825274","sequence_id": null,"etag": null,"name": "LC-Salesforce-Sunny-Final"},"item_status": "active","item_collection": {"total_count": 1,"entries": [],"offset": 0,"limit": 100}}';
        res.setBody(str);
        res.setStatusCode(200);
        return res;
    }
}