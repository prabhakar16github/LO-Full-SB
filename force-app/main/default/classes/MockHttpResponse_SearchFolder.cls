@isTest

global class MockHttpResponse_SearchFolder implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        string str = '{"total_count": 24,"entries": [{"type": "folder","id": "","sequence_id": "1","etag": "1","name": "Stephen Curry Three Pointers"},{"type": "file","id": "","sequence_id": "0","etag": "0","name": "Warriors.jpg"}],"offset": 0,"limit": 2}';
        res.setBody(str);
        res.setStatusCode(200);
        return res;
    }
}