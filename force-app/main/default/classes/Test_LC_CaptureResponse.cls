@isTest(SeeAllData= true)
private class Test_LC_CaptureResponse {
          
     //This method will cover getAccessToken method in LC_CaptureResponse class
     static testMethod void testGetAccessTokenMethod() {
       test.startTest();
       apexpages.currentPage().getParameters().put('code','test code');
       Test.setMock(HttpCalloutMock.class, new MockHttpResponse_BoxAccessToken());
       LC_CaptureResponse LC_CR = new LC_CaptureResponse();
       LC_CR.getAccessToken();
       test.stopTest();
     }
     
     //This method will cover retrieveFolders method in LC_CaptureResponse class
     static testMethod void testRetrieveFoldersMethod() {
       test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpResponse_BoxAccessToken());
       LC_CaptureResponse LC_CR = new LC_CaptureResponse();
       LC_CR.retrieveFolders();
       test.stopTest();
     }
     
     //This method will cover InsertFolders, InsertSubFolders method in LC_CaptureResponse class
     static testMethod void testInsertFoldersMethod() {
       test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpResponse_BoxAccessToken());
       apexpages.currentPage().getParameters().put('code','test code');
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       LC_CaptureResponse LC_CR = new LC_CaptureResponse();
       LC_CR.InsertFolders();
       test.stopTest();
     }
     
     //This method will cover insertFile method in LC_CaptureResponse class
     static testMethod void testInsertFileMethod() {
       test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpResponse_BoxAccessToken());
       LC_CaptureResponse LC_CR = new LC_CaptureResponse();
       LC_CR.dct = new Attachment();
       LC_CR.insertFile();
       test.stopTest();
     }
     
     //This method will cover inner classes in LC_CaptureResponse class
     static testMethod void testInnerClassesMethod() {
       LC_CaptureResponse.path_collection obj1 = new LC_CaptureResponse.path_collection();
       LC_CaptureResponse.entries obj2 = new LC_CaptureResponse.entries();
       LC_CaptureResponse.created_by obj3 = new LC_CaptureResponse.created_by();
       LC_CaptureResponse.modified_by obj4 = new LC_CaptureResponse.modified_by();
       LC_CaptureResponse.owned_by obj5 = new LC_CaptureResponse.owned_by();
       LC_CaptureResponse.parent obj6 = new LC_CaptureResponse.parent();
       LC_CaptureResponse.item_collection obj7 = new LC_CaptureResponse.item_collection();
       LC_CaptureResponse.Order obj8 = new LC_CaptureResponse.Order();
     }
     
}