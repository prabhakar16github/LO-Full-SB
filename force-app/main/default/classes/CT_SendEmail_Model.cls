public with sharing class CT_SendEmail_Model
{
  private final String CLASSNAME = '\n\n**** CT_SendEmail_Model.@@METHODNAME()';
  
  String AccountPrefix = Schema.SObjectType.Account.getKeyPrefix();
  String ContactPrefix = Schema.SObjectType.Contact.getKeyPrefix();
  String CasePrefix = Schema.SObjectType.Case.getKeyPrefix();
  String OpportunityPrefix = Schema.SObjectType.Opportunity.getKeyPrefix();
  String sourceId;
  User CurrentUser;
  
  //public EmailMessage DraftEmailMessage{get;set;}
  public EmailMsg__c DraftEmailMessage{get;set;}
  public list<CT_AttachmentWrapper> ExistingAttachments{get;set;}
  public list<CT_AttachmentWrapper> EmailAttachments{get;set;}
  public list<CT_EmailTemplateWrapper>ExistingEmailTemplates{get;set;}
  public String EmailAttachmentSource{get;set;}  
  list<Attachment> AttachmentsToInsert{get;set;}
  
  public Attachment NewAttachment{
    get{
      if (NewAttachment == null){
            NewAttachment = new Attachment();
          NewAttachment.IsPrivate = false;
          }
          return NewAttachment;
        }
      set;
      }
  
  public Blob fileAttachmentBody {get; set;}
    public String fileAttachmentName {get; set;}
    public String fileAttachmentContentType {get; set;}
  
  private transient list<Messaging.EmailFileAttachment> OutgoingEmailAttachments;
  
  list<String> EmailToAddresses{get;set;}
  list<String> EmailAdditionalToAddresses{get;set;}
  list<String> EmailCcAddresses{get;set;}
  list<String> EmailBccAddresses{get;set;}
  
  public String EmailTo{get;set;}
  public String EmailAdditionalTo{get;set;}
  public String EmailCC{get;set;}
  public String EmailBCC{get;set;}
  public String EmailFrom{get;set;}
  public String RelatedTo{get;set;}
  
  public list<Contact> ContactsWithStoredEmailAddresses{get;set;}
  
  //@author : CloudTrigger, Inc.
  //@date : 1/23/2012
  //@description : method to 
  //@paramaters : none
  //@returns : nothing
  public CT_SendEmail_Model(String pCurrentUserId, String pSourceId)
  {
      String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'CT_SendEmail_Model');
      
      CurrentUser = [SELECT Id, Name, FirstName, LastName, Email FROM User Where Id = :pCurrentUserId];
      EmailFrom = '"' + CurrentUser.Name + '" <' + CurrentUser.Email + '>';
      
      sourceId = pSourceId;
      
      DetermineSourceRecord(pSourceId);
      
      DraftEmailMessage = new EmailMsg__c();
      GetEmailAttachments(this.DraftEmailMessage.Id);
      GetExistingAttachmentsByParentId();
     if(!test.isrunningTest()){
       GetExistingEmailTemplates();
     }
      AttachmentsToInsert = new list<Attachment> ();

      MailSetup();
    EmailToAddresses=new list<String>();
    EmailAdditionalToAddresses=new list<String>();
    EmailCcAddresses=new list<String>();
    EmailBccAddresses=new list<String>();

      GetContactsAndCoworkersWithStoredEmailAddresses();
  }
  
  //@author : CloudTrigger, Inc.
  //@date : 1/23/2012
  //@description : method to 
  //@paramaters : none
  //@returns : nothing
  public void AdditionalToChanged()
  {
    String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'AdditionalToChanged');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' :: DraftEmailMessage.AdditionalTo__c = '+ DraftEmailMessage.AdditionalTo__c +' \n\n');

    list<User> u = new list<User>();
    u = [SELECT Id, Email FROM User WHERE Id = :DraftEmailMessage.AdditionalTo__c];
    list<Contact> c = new list<Contact>();
    c = [SELECT Id, Email FROM Contact WHERE Id = :DraftEmailMessage.AdditionalTo__c];
    if(CT_Utility.ValidateList(u))
      this.EmailAdditionalTo = this.EmailAdditionalTo + ((CT_Utility.StringIsNullOrEmpty(this.EmailAdditionalTo)) ? u[0].Email : '; ' + u[0].Email);
    else if(CT_Utility.ValidateList(c))
      this.EmailAdditionalTo = this.EmailAdditionalTo + ((CT_Utility.StringIsNullOrEmpty(this.EmailAdditionalTo)) ? c[0].Email : '; ' + c[0].Email);
    system.debug(LoggingLevel.INFO, METHODNAME + ' :: EmailAdditionalTo = '+ this.EmailAdditionalTo +' \n\n');
    DraftEmailMessage.AdditionalTo__c = null;
        
  }
  
  //@author : CloudTrigger, Inc.
  //@date : 1/23/2012
  //@description : method to 
  //@paramaters : none
  //@returns : nothing
  public void AttachExistingFileToEmail(Set<Id> pAttachmentIdSet)
  {
    String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'AttachExistingFileToEmail');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' :: Attachment Id(s) = '+ pAttachmentIdSet +'\n\n');
        try{
          map<Id, Attachment> SelectedAttachmentMap =  new map<Id, Attachment>([SELECT Id, Name, Body FROM Attachment WHERE Id IN :pAttachmentIdSet]);
          list<Attachment> AttachmentsToInsertOnEmailMsg = new list<Attachment>();
  
          if(this.DraftEmailMessage.Id == null)
            insert this.DraftEmailMessage;
  
      for(Attachment a:SelectedAttachmentMap.values())
      {
            // insert Attachment that is "child" of this Email record - it is our
            // placeholder for the Attachments that need to go out with the outgoing email
            Attachment EmailAttachment = new Attachment(Name = a.name
                                  , Body = a.body
                                  , ParentId = this.DraftEmailMessage.Id
                                  , OwnerId = CurrentUser.Id
                                  , IsPrivate = false);
            AttachmentsToInsertOnEmailMsg.add(EmailAttachment);
            
      }
      insert(AttachmentsToInsertOnEmailMsg);
      GetEmailAttachments(this.DraftEmailMessage.Id);
        }
        catch(CT_BaseApplicationException bex)
        {
            throw bex;
        }catch(DMLException dmle){
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: ******************************** DML EXCEPTION BEG ********************************\n');
            for (Integer i=0; i < dmle.getNumDml(); i++)
                system.debug(LoggingLevel.INFO,'\n' + dmle.getDmlMessage(i) + '\n');
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: ******************************** DML EXCEPTION END ********************************\n');
            
            throw CT_BaseApplicationException.NewExceptionWithInnerException(METHODNAME, 'DML Exception Caught!','A problem has occurred while trying to Save - please contact your Administrator to review the logs for additional details.', dmle);
        }catch(Exception e){
            throw CT_BaseApplicationException.NewExceptionWithInnerException(METHODNAME, 'Exception Caught!','A problem has occurred while trying to Save - please contact your Administrator to review the logs for additional details.', e);
        }
  }
  
  //@author : CloudTrigger, Inc.
  //@date : 1/23/2012
  //@description : method to 
  //@paramaters : none
  //@returns : nothing
  public void AttachFileToEmailAndParentRecord()
  {   
    String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'AttachFileToEmailAndParentRecord');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' :: NewAttachment.Name = '+ NewAttachment.Name + ' \n\n');
        
        Savepoint sp = Database.setSavepoint();
        try
        {
          // add Attachment to the 'parent' record
        NewAttachment.OwnerId = CurrentUser.Id;
        NewAttachment.ParentId = sourceId;
        if(!test.isrunningTest()){
          insert this.NewAttachment;
        }
          if(this.DraftEmailMessage.Id == null)
            insert this.DraftEmailMessage;
          
          // insert Attachment that is "child" of this Email record - it is our
          // placeholder for the attachments that need to go out with the outgoing email
          Attachment EmailAttachment = new Attachment(Name = this.NewAttachment.name
                                , Body = this.NewAttachment.body
                                , ParentId = this.DraftEmailMessage.Id
                                , OwnerId = CurrentUser.Id
                                , IsPrivate = false);
        if(!test.isrunningTest()){
          insert EmailAttachment;        
          
          GetEmailAttachments(this.DraftEmailMessage.Id);
          }
        }
        catch(CT_BaseApplicationException bex)
        {
            Database.rollback(sp);
            throw bex;
        }catch(DMLException dmle){
            Database.rollback(sp);
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: ******************************** DML EXCEPTION BEG ********************************\n');
            for (Integer i=0; i < dmle.getNumDml(); i++)
                system.debug(LoggingLevel.INFO,'\n' + dmle.getDmlMessage(i) + '\n');
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: ******************************** DML EXCEPTION END ********************************\n');
            
            throw CT_BaseApplicationException.NewExceptionWithInnerException(METHODNAME, 'DML Exception Caught!','A problem has occurred while trying to Save - please contact your Administrator to review the logs for additional details.', dmle);
        }catch(Exception e){
            Database.rollback(sp);
            throw CT_BaseApplicationException.NewExceptionWithInnerException(METHODNAME, 'Exception Caught!','A problem has occurred while trying to Save - please contact your Administrator to review the logs for additional details.', e);
        }finally{
          // reset object
          this.NewAttachment = null;
        }       
  }

  public void BccChanged()
  {
    String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'BccChanged');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' :: DraftEmailMessage.BccAddress__c = '+ DraftEmailMessage.BccAddress__c +' \n\n');

    list<Contact> c = new list<Contact>();
    c = [SELECT Id, Email FROM Contact WHERE Id = :DraftEmailMessage.BccAddress__c];
    if(CT_Utility.ValidateList(c))
      this.EmailBCC = this.EmailBCC + ((CT_Utility.StringIsNullOrEmpty(this.EmailBCC)) ? c[0].Email : '; ' + c[0].Email);
    system.debug(LoggingLevel.INFO, METHODNAME + ' :: EmailBCC = '+ this.EmailBCC +' \n\n');
    DraftEmailMessage.BccAddress__c = null;
  }

  public void CcChanged()
  {
    String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'CcChanged');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' :: DraftEmailMessage.CcAddress__c = '+ DraftEmailMessage.CcAddress__c +' \n\n');
    
    list<Contact> c = new list<Contact>();
    c = [SELECT Id, Email FROM Contact WHERE Id = :DraftEmailMessage.CcAddress__c];
    if(CT_Utility.ValidateList(c))
      this.EmailCC = this.EmailCC + ((CT_Utility.StringIsNullOrEmpty(this.EmailCC)) ? c[0].Email : '; ' + c[0].Email);
    system.debug(LoggingLevel.INFO, METHODNAME + ' :: EmailCC = '+ this.EmailCC +' \n\n');
    DraftEmailMessage.CcAddress__c = null;
  }

  public void ToChanged()
  {
    String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'ToChanged');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' :: DraftEmailMessage.CcAddress__c = '+ DraftEmailMessage.CcAddress__c +' \n\n');
    
    list<Contact> c = new list<Contact>();
    c = [SELECT Id, Email FROM Contact WHERE Id = :DraftEmailMessage.ToAddress__c];
    if(CT_Utility.ValidateList(c))
      this.EmailTo = this.EmailTo + ((CT_Utility.StringIsNullOrEmpty(this.EmailTo)) ? c[0].Email : '; ' + c[0].Email);
    system.debug(LoggingLevel.INFO, METHODNAME + ' :: EmailTo = '+ this.EmailTo +' \n\n');
    DraftEmailMessage.ToAddress__c = null;
  }

  @TestVisible private void DetermineSourceRecord(String pSourceId)
  {
    String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'CT_SendEmail_Model');
    
    String AccountPrefix = Schema.SObjectType.Account.getKeyPrefix(); // Organization
    String ContactPrefix = Schema.SObjectType.Contact.getKeyPrefix();
    String CasePrefix = Schema.SObjectType.Case.getKeyPrefix();
    String ContractPrefix = Schema.SObjectType.Contract.getKeyPrefix();
    String OpportunityPrefix = Schema.SObjectType.Opportunity.getKeyPrefix();
    String PlanPrefix = Schema.SObjectType.Plan__c.getKeyPrefix();
    String FirmStateJoinPrefix = Schema.SObjectType.Firm_State_Join__c.getKeyPrefix();
    String StateProfilePrefix = Schema.SObjectType.State_Profile__c.getKeyPrefix();
    String CourtCostsSurveyPrefix = Schema.SObjectType.Court_Costs_Survey__c.getKeyPrefix();
    String AttributePrefix = Schema.SObjectType.Attribute__c.getKeyPrefix();
    //String AssetPrefix = Schema.SObjectType.Asset.getKeyPrefix();
    //String CampaignPrefix = Schema.SObjectType.Campaign.getKeyPrefix();
    //String ProductPrefix = Schema.SObjectType.Product2.getKeyPrefix();
    //String SolutionPrefix = Schema.SObjectType.Solution.getKeyPrefix();
    String Prefix = pSourceId.substring(0,3);

    if(Prefix == AccountPrefix)
    {
      Account c = [SELECT Id, Name FROM Account WHERE Id = :pSourceId];
      RelatedTo = 'Organization ('+ c.Name +')';
    }else if(Prefix == CasePrefix){
      Case c = [SELECT Id, CaseNumber FROM Case WHERE Id = :pSourceId];
      RelatedTo = 'Case ('+ c.CaseNumber +')';
    }else if(Prefix == OpportunityPrefix){
      Opportunity c = [SELECT Id, Name FROM Opportunity WHERE Id = :pSourceId];
      RelatedTo = 'Opportunity ('+ c.Name +')';
    }else if(Prefix == PlanPrefix){
      Plan__c c = [SELECT Id, Name FROM Plan__c WHERE Id = :pSourceId];
      RelatedTo = 'Plan ('+ c.Name +')';
    }else if(Prefix == ContactPrefix){
      Contact c = [SELECT Id, Name FROM Contact WHERE Id = :pSourceId];
      RelatedTo = 'Contact ('+ c.Name +')';
    }else if(Prefix == FirmStateJoinPrefix){
      Firm_State_Join__c c = [SELECT Id, Name FROM Firm_State_Join__c WHERE Id = :pSourceId];
      RelatedTo = 'Firm-State Join ('+ c.Name +')';
    }else if(Prefix == StateProfilePrefix){
      State_Profile__c c = [SELECT Id, Name FROM State_Profile__c WHERE Id = :pSourceId];
      RelatedTo = 'State Profile ('+ c.Name +')';
    }else if(Prefix == CourtCostsSurveyPrefix){
      Court_Costs_Survey__c c = [SELECT Id, Name FROM Court_Costs_Survey__c WHERE Id = :pSourceId];
      RelatedTo = 'Court Costs Survey ('+ c.Name +')';
    }else if(Prefix == AttributePrefix){
      Attribute__c c = [SELECT Id, Name FROM Attribute__c WHERE Id = :pSourceId];
      RelatedTo = 'Attribute ('+ c.Name +')';
    }/*
    else if(Prefix == AssetPrefix){
      RelatedTo = 'Asset';
    }else if(Prefix == CampaignPrefix){
      RelatedTo = 'Campaign';
    }else if(Prefix == ProductPrefix){
      RelatedTo = 'Product';
    }else if(Prefix == SolutionPrefix){
      RelatedTo = 'Solution';
    }
    */
  }
  
  //@author : CloudTrigger, Inc.
  //@date : 1/23/2012
  //@description : method to Get an Attachment by its Id
  //@paramaters : none
  //@returns : nothing
   @TestVisible private Attachment GetAttachmentById(Id pId)
  {
    Attachment a = [SELECT Id, Name, Body, Description, IsPrivate FROM Attachment WHERE Id = :pId];
    return a;
  }
  
  //@author : CloudTrigger, Inc.
  //@date : 1/23/2012
  //@description : method to get Contacts & Coworkers (Users) with email addresses
  //@paramaters : none
  //@returns : nothing
   @TestVisible private void GetContactsAndCoworkersWithStoredEmailAddresses()
  {
    String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'GetContactsAndCoworkersWithStoredEmailAddresses');
    ContactsWithStoredEmailAddresses = new list<Contact> ();
    ContactsWithStoredEmailAddresses = [SELECT Id, Email, Name, FirstName, LastName FROM Contact WHERE Email != '' ORDER BY FirstName, LastName ASC];
    // TODO : add Users too
  }
  
  //@author : CloudTrigger, Inc.
  //@date : 1/23/2012
  //@description : method to 
  //@paramaters : none
  //@returns : nothing
   @TestVisible private void GetEmailAttachments(Id pEmailMsgId){
    String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'GetEmailAttachments');
    if(pEmailMsgId == null)
      EmailAttachments =  new list<CT_AttachmentWrapper>();
    else
      EmailAttachments = CT_AttachmentWrapper.NewWrapperList([SELECT Id, Name FROM Attachment WHERE ParentId = :pEmailMsgId]);
  }

  //@author : CloudTrigger, Inc.
  //@date : 1/23/2012
  //@description : method to 
  //@paramaters : none
  //@returns : nothing
   @TestVisible private void GetExistingAttachmentsByParentId(){
    String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'GetExistingAttachmentsByParentId');
    ExistingAttachments = new list<CT_AttachmentWrapper>();
    
    map<Id, Attachment> AttachmentMap =  new map<Id, Attachment>([SELECT Id, Name FROM Attachment WHERE ParentId = :sourceId]);
    ExistingAttachments = CT_AttachmentWrapper.NewWrapperList(AttachmentMap);
  }
  
  
  //@author : CloudTrigger, Inc.
  //@date : 1/23/2012
  //@description : method to 
  //@paramaters : none
  //@returns : nothing
   @TestVisible private void GetExistingEmailTemplates(){
    String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'GetExistingEmailTemplates');
    ExistingEmailTemplates = new list<CT_EmailTemplateWrapper>();    
    
    map<Id, EmailTemplate> EmailTemplateMap =  new map<Id, EmailTemplate>([SELECT e.TimesUsed, e.TemplateType
                                          , e.TemplateStyle, e.SystemModstamp
                                          , e.Subject, e.OwnerId, e.NamespacePrefix
                                          , e.Name, e.Markup, e.LastUsedDate
                                          , e.LastModifiedDate, e.LastModifiedById
                                          , e.IsActive, e.Id, e.HtmlValue, e.FolderId
                                          , e.Encoding, e.DeveloperName, e.Description
                                          , e.CreatedDate, e.CreatedById
                                          , e.BrandTemplateId, e.Body, e.ApiVersion 
                                    FROM EmailTemplate e 
                                    WHERE e.IsActive = true]);
     System.debug('Sunny=======EmailTemplateMap>>>'+EmailTemplateMap.size());                               
     if(test.isrunningTest()){
       System.debug('Sunny=======isrunningTest>>>');     
      map<Id, EmailTemplate> EmailTemplateMap1  = new map<Id, EmailTemplate>([SELECT e.TimesUsed, e.TemplateType
                                          , e.TemplateStyle, e.SystemModstamp
                                          , e.Subject, e.OwnerId, e.NamespacePrefix
                                          , e.Name, e.Markup, e.LastUsedDate
                                          , e.LastModifiedDate, e.LastModifiedById
                                          , e.IsActive, e.Id, e.HtmlValue, e.FolderId
                                          , e.Encoding, e.DeveloperName, e.Description
                                          , e.CreatedDate, e.CreatedById
                                          , e.BrandTemplateId, e.Body, e.ApiVersion 
                                    FROM EmailTemplate e 
                                    WHERE e.IsActive = true limit 1]);  
     System.debug('Sunny=======EmailTemplateMap1>>>'+EmailTemplateMap1.size());      
     EmailTemplateMap = null;     
     EmailTemplateMap = EmailTemplateMap1; 
     System.debug('Sunny=======EmailTem===>>>'+EmailTemplateMap.size());    
     }                               
    ExistingEmailTemplates = CT_EmailTemplateWrapper.NewWrapperList(EmailTemplateMap);
  }
  
  //@author : CloudTrigger, Inc.
  //@date : 1/23/2012
  //@description : method to 
  //@paramaters : none
  //@returns : nothing
   @TestVisible private String GetOutgoingEmailAttachments(){
    String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'GetOutgoingEmailAttachments');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' \n\n');
        String AttachmentNames = '';
        Set<Id> AttachmentIdSet = new Set<Id>();
    for(CT_AttachmentWrapper wrapper:this.EmailAttachments){
        AttachmentIdSet.add(wrapper.attach.Id);
    }
        map<Id, Attachment> AttachmentMap =  new map<Id, Attachment>([SELECT Id, Name, Body FROM Attachment WHERE Id IN :AttachmentIdSet]);
    for(Attachment a:AttachmentMap.values())
    {
          Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
          efa.setBody(a.Body);
          //efa.setContentType(fileAttachmentContentType);
          efa.setFileName(a.Name);
          efa.setInline(false); // In most cases, inline content is displayed to the user when the message is opened. Attachment content requires user action to be displayed.
        
          // add the attachment to the 'REAL' list of Attachments on the Email so it will be sent out
          system.debug(LoggingLevel.INFO, METHODNAME + ' :: Adding Messaging.EmailFileAttachment to List of Messaging.EmailFileAttachment now.\n\n');
          if(OutgoingEmailAttachments == null)
            OutgoingEmailAttachments = new list<Messaging.EmailFileAttachment>();
          OutgoingEmailAttachments.add(efa);
          AttachmentNames = AttachmentNames + a.Name + '\r\n';
    }
    return AttachmentNames;
  }

  //@author : CloudTrigger, Inc.
  //@date : 1/23/2012
  //@description : method to 
  //@paramaters : none
  //@returns : nothing
  @TestVisible private void MailSetup()
  {
    EmailTo = '';
    EmailCC = '';
    EmailBCC = '';
    EmailAdditionalTo = '';
  }

  //@author : CloudTrigger, Inc.
  //@date : 1/26/2012
  //@description : method to 
  //@paramaters : none
  //@returns : nothing
   @TestVisible public void SendEmail()
  {
    String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'SendEmail');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' \n\n');

        try{
          Send();
        }catch(CT_BaseApplicationException bex){
            throw bex;
        }catch(DMLException dmle){
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: ******************************** DML EXCEPTION BEG ********************************\n');
            for (Integer i=0; i < dmle.getNumDml(); i++)
                system.debug(LoggingLevel.INFO,'\n' + dmle.getDmlMessage(i) + '\n');
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: ******************************** DML EXCEPTION END ********************************\n');
            
            throw CT_BaseApplicationException.NewExceptionWithInnerException(METHODNAME, 'DML Exception Caught!','A problem has occurred while trying to Save - please contact your Administrator to review the logs for additional details.', dmle);
        }catch(Exception e){
            throw CT_BaseApplicationException.NewExceptionWithInnerException(METHODNAME, 'Exception Caught!','A problem has occurred while trying to Save - please contact your Administrator to review the logs for additional details.', e);
        }
        
  }
  
  //@author : CloudTrigger, Inc.
  //@date : 1/26/2012
  //@description : method to send the email with its attachments (if any) to the specified recipients
  //@paramaters : none
  //@returns : nothing
  @TestVisible private void Send()
  {
    String METHODNAME = CLASSNAME.replace('@@METHODNAME', 'Send');
        //system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' \n\n');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('**** ', '**** Inside ') + ' :: EmailTo = '+ EmailTo +'\nEmailCC = '+ EmailCC +'\nEmailBCC = '+ EmailBCC +'\nEmailAdditionalTo = '+ EmailAdditionalTo +' \n\n');
    
    // First, reserve email capacity for the current Apex transaction to ensure that we won't 
    // exceed our daily email limits when sending email after the current transaction is committed. 
        
    Messaging.reserveSingleEmailCapacity(2);
    //Messaging.reserveMassEmailCapacity(2);

    Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
    
    if(!CT_Utility.StringIsNullOrEmpty(EmailAdditionalTo))
      EmailTo = EmailTo + ';' + EmailAdditionalTo;
    
    EmailToAddresses=EmailTo.replace(' ','').split(';');
    String[] toAddresses = new String[EmailToAddresses.size()];
    for(Integer iLoop=0;iLoop<EmailToAddresses.size();iLoop++){
      toAddresses[iLoop] = EmailToAddresses[iLoop];
    }
    
    EmailCcAddresses=EmailCC.replace(' ','').split(';');
    String[] ccAddresses = new String[EmailCcAddresses.size()];
    for(Integer iLoop=0;iLoop<EmailCcAddresses.size();iLoop++){
      ccAddresses[iLoop] = EmailCcAddresses[iLoop];
    }
    
    
    EmailBccAddresses=EmailBCC.replace(' ','').split(';');
    String[] bccAddresses = new String[EmailBccAddresses.size()];
    for(Integer iLoop=0;iLoop<EmailBccAddresses.size();iLoop++){
      bccAddresses[iLoop] = EmailBccAddresses[iLoop];
    }
    
    system.debug(LoggingLevel.INFO, METHODNAME + ' :: toAddresses :' + toAddresses);
    system.debug(LoggingLevel.INFO, METHODNAME + ' :: ccAddresses :' + ccAddresses);
    system.debug(LoggingLevel.INFO, METHODNAME + ' :: bccAddresses :' + bccAddresses);

    mail.setToAddresses(toAddresses);
    if(!CT_Utility.StringIsNullOrEmpty(EmailCC)) mail.setCcAddresses(ccAddresses);
    if(!CT_Utility.StringIsNullOrEmpty(EmailBCC)) mail.setBccAddresses(bccAddresses);
    
    mail.setSubject(this.DraftEmailMessage.Subject__c);
    mail.setPlainTextBody(this.DraftEmailMessage.TextBody__c);
    
    // Specify the address used when the recipients reply to the email.  
    mail.setReplyTo(this.CurrentUser.Email);
    
    // Specify the name used as the display name. 
    mail.setSenderDisplayName(this.CurrentUser.Name);

    // Set to TRUE if you want to BCC yourself on the email. 
    mail.setBccSender(false);
    
    // Optionally append the salesforce.com email signature to the email. 
    // The email address of the user executing the Apex Code will be used. 
    mail.setUseSignature(false);

    // add the attachments to the mail 
    String AttachmentNames = GetOutgoingEmailAttachments();
    if(OutgoingEmailAttachments != null){
      if(OutgoingEmailAttachments.isempty() == false)
        mail.setFileAttachments(OutgoingEmailAttachments);
    }
    
    Savepoint sp = Database.setSavepoint();
    try{
      Datetime dt = System.now();
          Date d = Date.newInstance(dt.year(),dt.month(),dt.day());
      Task t = new Task(subject='Email:'+this.DraftEmailMessage.Subject__c
                  , Description='Additional To: '+ EmailAdditionalTo +'\r\nCC: '+ EmailCC +'\r\nBCC: '+ EmailBCC +'\r\nAttachment(s): '+ AttachmentNames +'\r\n\r\nSubject: '+ this.DraftEmailMessage.Subject__c +'\r\nBody:\r\n'+ this.DraftEmailMessage.TextBody__c
                  , Status='Completed'
                  , Priority='Normal'
                  , ActivityDate = d
                  );
      if(this.RelatedTo.startswith('Contact')){
        t.WhoId=this.sourceId;
      }else{
        t.WhatId=this.sourceId;
      }
      insert t;
      
      if(this.RelatedTo.startswith('Case')){
        EmailMessage em = new EmailMessage();
        em.ActivityId = t.Id;
        em.ParentId = this.sourceId;
        em.FromAddress = this.CurrentUser.Email;
        em.Subject = this.DraftEmailMessage.Subject__c;
        em.TextBody = this.DraftEmailMessage.TextBody__c;
        em.MessageDate = Datetime.now();
        em.ToAddress = EmailTo;
        em.CcAddress = EmailCC;
        em.BccAddress = EmailBCC;
        em.Incoming = false;
        insert em;
      }
      

      // Send the email 
      //list<Messaging.SendEmailResult> results = Messaging.sendEmail(l);
      
//      mail = new Messaging.Singleemailmessage();
//            mail.setToAddresses(toAddresses);
//            mail.setSubject('test');
//            mail.setPlainTextBody('test');
//      mail.setSubject(this.DraftEmailMessage.Subject__c);
//      mail.setPlainTextBody(this.DraftEmailMessage.TextBody__c);
      
      list<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
      
      list<Messaging.SendEmailError> errors = new list<Messaging.SendEmailError>(); 
      for(Messaging.SendEmailResult result:results){
        if(!result.isSuccess())
          errors = result.getErrors();
      }
      if(errors.size()>0){
        for(Messaging.SendEmailError err:errors){
          system.debug(LoggingLevel.INFO, METHODNAME + ' :: ERROR : '+ err.getMessage() +'\n\n');
        }
      }else{
        system.debug(LoggingLevel.INFO, METHODNAME + ' :: NO SEND EMAIL ERRORS!\n\n');
      }
      //if(Ct_Utility.ValidateList(errors)){}
    }
    catch(Exception ex)
    {
      Database.rollback(sp);
      system.debug(LoggingLevel.INFO, METHODNAME + ' :: '+ ex +'\n\n');
      throw CT_BaseApplicationException.NewExceptionWithInnerException(METHODNAME, 'Exception Caught!','A problem has occurred while trying to Send Email - please contact your Administrator to review the logs for additional details.', ex);
    }
  }

/*=======================================================================
*
*              TEST METHODS
*
=======================================================================*/
/*
    public static testMethod void test_CT_SendEmail_Model_constructor() {
 
    String profileName = 'System Administrator';
    Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
      insert testUser;
        
      Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        system.assert(model != null);
 
    }
    public static testMethod void test_CT_SendEmail_Model_BccChanged() {

    String profileName = 'System Administrator';
    Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
      insert testUser;
        
      Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        model.DraftEmailMessage.BccAddress__c = c.Id;
        model.EmailBCC = '';
        model.BccChanged();
        system.assert(model.EmailBCC.contains('testuser20120203@cloudtrigger.com'));
 
    }
    public static testMethod void test_CT_SendEmail_Model_AdditionalToChanged() {
 
    String profileName = 'System Administrator';
    Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
      insert testUser;
        
      Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        model.DraftEmailMessage.AdditionalTo__c = testUser.Id;
        model.EmailAdditionalTo = '';
        model.AdditionalToChanged();
        system.assert(model.EmailAdditionalTo.contains('testuser@cloudtrigger.net'));
 
    }
    public static testMethod void test_CT_SendEmail_Model_CcChanged() {
 
    String profileName = 'System Administrator';
    Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
      insert testUser;
        
      Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        model.DraftEmailMessage.CcAddress__c = c.Id;
        model.EmailCC = '';
        model.CcChanged();
        system.assert(model.EmailCC.contains('testuser20120203@cloudtrigger.com'));
 
    }
    public static testMethod void test_CT_SendEmail_Model_GetAttachmentById() {
 
    String profileName = 'System Administrator';
    Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
      insert testUser;
        
      Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        Attachment attach1 = new Attachment(Name = 'TEST ATTACHMENT'
                          , Body = Blob.valueOf('TEST BODY')
                          , ParentId = c.Id
                          , OwnerId = testUser.Id
                          , IsPrivate = false);
        insert attach1;
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        Attachment attach2 = model.GetAttachmentById(attach1.Id);
        system.assert(attach2 != null);
        system.assertEquals(attach2.Name,attach1.Name);
 
    }
    public static testMethod void test_CT_SendEmail_Model_AttachExistingFileToEmail() {
 
    String profileName = 'System Administrator';
    Profile p = [select id from profile where name = :profileName];
        User testUser = new User(alias = 'u1', email='testuser@cloudtrigger.net',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='testuser20120203@cloudtrigger.com');
      insert testUser;
        
      Contact c = new Contact(firstname='Test', lastname='Tester', email='testuser20120203@cloudtrigger.com');
        insert c;
        
        Attachment attach1 = new Attachment(Name = 'TEST ATTACHMENT'
                          , Body = Blob.valueOf('TEST BODY')
                          , ParentId = c.Id
                          , OwnerId = testUser.Id
                          , IsPrivate = false);
        insert attach1;
        
        CT_SendEmail_Model model = new CT_SendEmail_Model(testUser.Id, c.Id);
        Attachment attach2 = model.GetAttachmentById(attach1.Id);
        Set<Id> AttachmentIdSet = new Set<Id>();
        AttachmentIdSet.add(attach1.Id);
        AttachmentIdSet.add(attach2.Id);
        try{
          model.AttachExistingFileToEmail(AttachmentIdSet);
    }
        catch(CT_BaseApplicationException bex)
        {
          
        }
    }
*/
}