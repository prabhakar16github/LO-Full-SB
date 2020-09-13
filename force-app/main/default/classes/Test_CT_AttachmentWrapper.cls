@isTest
public class Test_CT_AttachmentWrapper{
    public static testMethod void test_NewWrapper_Attachment() {
 
      /* String profileName = 'System Administrator';
         Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
      insert testUser; 
       User testUser = [SELECT AccountId,City,CompanyName,Email,Id,IsActive,LastName,Name,ProfileId,
        Title,Username FROM User where IsActive=true and Profile.Name='System Administrator' limit 1];*/
        
      Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        Attachment attach = new Attachment(Name = 'TEST ATTACHMENT'
                          , Body = Blob.valueOf('TEST BODY')
                          , ParentId = c.Id
                         // , OwnerId = testUser.Id
                          , IsPrivate = false);
        insert attach;
        Attachment attach2 = new Attachment(Name = 'TEST ATTACHMENT 2'
                          , Body = Blob.valueOf('TEST BODY 2')
                          , ParentId = c.Id
                         // , OwnerId = testUser.Id
                          , IsPrivate = false);
        insert attach2;
        
        CT_AttachmentWrapper aw = CT_AttachmentWrapper.NewWrapper(attach.id);
        
        system.assert(aw != null);
        system.assertEquals(aw.selected,false);
         Messaging.EmailFileAttachment attach123 = new Messaging.EmailFileAttachment();
        CT_AttachmentWrapper aw12 = CT_AttachmentWrapper.NewWrapper(attach123);
       // aw12.CT_AttachmentWrapper('Test');
        system.assert(aw12 != null);
        system.assertEquals(aw12.selected,false);
        list<Attachment> AttachmentList = new list<Attachment>();
        AttachmentList.add(attach2);
        AttachmentList.add(attach);
        map<id,Attachment> attMap= new map<id,Attachment>([SELECT Body,BodyLength,ConnectionReceivedId,ConnectionSentId,ContentType,Description,Id,IsDeleted,IsPrivate,Name,ParentId FROM Attachment where ID IN:AttachmentList]);
         list<CT_AttachmentWrapper> NewWrapperList = CT_AttachmentWrapper.NewWrapperList(attMap);
         list<CT_AttachmentWrapper> NewWrapperList1 = CT_AttachmentWrapper.NewWrapperList(AttachmentList);
        system.assert(NewWrapperList != null);
        system.assert(NewWrapperList.size()>1);
        
        
    }
    /*
   
    public static testMethod void test_NewWrapper_EmailFileAttachment() {
 
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        CT_AttachmentWrapper aw = CT_AttachmentWrapper.NewWrapper(attach);
        system.assert(aw != null);
        system.assertEquals(aw.selected,false);
 
    }
    public static testMethod void test_NewWrapper_NewWrapperList() {
 
    String profileName = 'System Administrator';
    Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
      insert testUser;
        
      Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        Attachment attach1 = new Attachment(Name = 'TEST ATTACHMENT 1'
                          , Body = Blob.valueOf('TEST BODY 1')
                          , ParentId = c.Id
                          , OwnerId = testUser.Id
                          , IsPrivate = false);
        insert attach1;
        Attachment attach2 = new Attachment(Name = 'TEST ATTACHMENT 2'
                          , Body = Blob.valueOf('TEST BODY 2')
                          , ParentId = c.Id
                          , OwnerId = testUser.Id
                          , IsPrivate = false);
        insert attach2;
        
        list<Attachment> AttachmentList = new list<Attachment>();
        AttachmentList.add(attach1);
        AttachmentList.add(attach2);
        list<CT_AttachmentWrapper> NewWrapperList = CT_AttachmentWrapper.NewWrapperList(AttachmentList);
        system.assert(NewWrapperList != null);
        system.assert(NewWrapperList.size()>1);
 
    } */
}