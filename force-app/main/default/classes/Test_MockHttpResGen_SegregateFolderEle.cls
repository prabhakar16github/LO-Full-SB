@isTest

global class Test_MockHttpResGen_SegregateFolderEle implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        string str = '{"total_count": 24,"entries": [{"type": "folder","id": "11446498","sequence_id": "1","etag": "1","name": "00P0000000000abcdefghij"},{"type": "file","id": "818853862","sequence_id": "0","etag": "0","name": "Warriors.jpg"}],"offset": 0,"limit": 2,"order": [{"by": "type","direction": "ASC"},{"by": "name","direction": "ASC"}]}';
        res.setBody(str);
        res.setStatusCode(200);
        return res;
    }
}