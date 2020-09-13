@isTest

global class MockHttpResponseGenerator implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        string str = '{"type":"folder","id":"2740401686","sequence_id":"0","etag":"0","name":"Test Firm","created_at":"2014-11-26T02:55:05-08:00","modified_at":"2014-11-26T02:55:05-08:00","description":"","size":0,"path_collection":{"total_count":2,"entries":[{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"},{"type":"folder","id":"2735825274","sequence_id":"0","etag":"0","name":"LC-Salesforce-Sunny-Final"}]},"created_by":{"type":"user","id":"226075787","name":"SVC LegalCMS","login":"svc.legalcms@mcmcg.com"},"modified_by":{"type":"user","id":"226075787","name":"SVC LegalCMS","login":"svc.legalcms@mcmcg.com"},"trashed_at":null,"purged_at":null,"content_created_at":"2014-11-26T02:55:05-08:00","content_modified_at":"2014-11-26T02:55:05-08:00","owned_by":{"type":"user","id":"226075787","name":"SVC LegalCMS","login":"svc.legalcms@mcmcg.com"},"shared_link":null,"folder_upload_email":null,"parent":{"type":"folder","id":"2735825274","sequence_id":"0","etag":"0","name":"LC-Salesforce-Sunny-Final"},"item_status":"active","item_collection":{"total_count":0,"entries":[],"offset":0,"limit":100,"order":[{"by":"type","direction":"ASC"},{"by":"name","direction":"ASC"}]}}';
        res.setBody(str);
        res.setStatusCode(200);
        return res;
    }
}