@isTest
global with sharing class MockHTTPforItemInUse implements HttpCalloutMock{
	global HTTPResponse respond(HTTPRequest req) {        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"type":"error","status":409,"code":"item_name_in_use","context_info":{"conflicts":[{"type":"folder","id":"2756644439","sequence_id":"0","etag":"0","name":"AK3"}]},"help_url":"http://developers.box.com/docs/#errors","message":"Item with the same name already exists","request_id":"11982065445481723b382fd"}');
        res.setStatusCode(409);
        return res;
    }
}