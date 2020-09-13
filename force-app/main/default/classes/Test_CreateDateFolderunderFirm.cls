@isTest(seealldata=true)
public class Test_CreateDateFolderunderFirm{
     public static testMethod void main(){
         Account act = new Account();
         act.Name = 'Test Account';
         act.Firm_ID__c = 'Test Firm786';
         insert act;   
         
         list<Box_Folder_ID_Map__c> BoxFolderIDList = [select id,Firm_ID__c from Box_Folder_ID_Map__c where Reference_ID__c =: act.Id];
         
         Firm_Dates__c fd = new Firm_Dates__c();
         //fd.Name__c = '2014-11';
         fd.Folder_ID__c = '0123456789';
         fd.Box_Folder_ID_Map__c = BoxFolderIDList[0].id;
         insert fd;
         
         String folderName = 'test';
         String ParentId = fd.Folder_ID__c;
         
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         LC_CreateDateFolderunderFirm.createFolder(fd.id,folderName,ParentId);
     }
     
     public static testMethod void main2(){
         Account act2 = new Account();
         act2.Name = 'Test Account';
         act2.Firm_ID__c = 'Test Firm786';
         insert act2;
         
         list<Box_Folder_ID_Map__c> BoxFolderIDList = [select id,Firm_ID__c from Box_Folder_ID_Map__c where Reference_ID__c =: act2.Id];
         
         Firm_Dates__c fd1 = new Firm_Dates__c();
         //fd1.Name__c = '2014-11';
         fd1.Folder_ID__c = '0123456788';
         fd1.Box_Folder_ID_Map__c = BoxFolderIDList[0].id;
         insert fd1;
         
         String folderName = 'test1234';
         String ParentId = fd1.Folder_ID__c;
         
         Test.setMock(HttpCalloutMock.class, new MockHTTPforItemInUse());
         LC_CreateDateFolderunderFirm.createFolder(fd1.id,folderName,ParentId);
     }
     
      static testMethod void myUnitTest() {
           LC_Box_Utility pc =new LC_Box_Utility();
           
      }
}