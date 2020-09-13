@isTest(SeeAllData= true)
private class Test_LC_GetAccessToken {

    //This method will cover getAccessToken method in LC_GetAccessToken class
    static testMethod void testgetAccessTokenMethod() {
        test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpResponse_BoxAccessToken());
       LC_GetAccessToken.getAccessToken();
       test.stopTest();
    }
}