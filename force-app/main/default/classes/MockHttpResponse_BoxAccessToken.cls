@isTest

global class MockHttpResponse_BoxAccessToken implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        string str = '{"access_token": "T9cE5asGnuyYCCqIZFoWjFHvNbvVqHjl","expires_in": 3600,"restricted_to": [],"token_type": "bearer","refresh_token": "J7rxTiWOHMoSC1isKZKBZWizoRXjkQzig5C6jFgCVJ9bUnsUfGMinKBDLZWP9BgR"}';
        res.setBody(str);
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}