public class PAM_InquiryController{
    
    public Case caseObj{get;set;}
    public Process_Adherence_Monitoring__c pamObj{get;set;}
    public Boolean isScmdView {get; set;}
    public Boolean isIrView {get; set;}
    
    public PAM_InquiryController(){
        caseObj = new Case();
        pamObj = new Process_Adherence_Monitoring__c();
        isScmdView = false;
        isIrView = false;
        String recordId = apexpages.currentpage().getparameters().get('id');
        Set<Id> scmdRecordstypeIds = new Set<Id>();
        Set<Id> scmdACFRecordstypeIds = new Set<Id>();
        //Adde on 03-Feb-2020 for SCM DM records
        Set<Id> scmdDMRecordstypeIds = new Set<Id>();
        
        pamObj = [SELECT Name, OwnerId, Owner.Email, Account_Number__c, Organization_Name__r.Firm_ID__c, 
        		  Organization_Name__c,  RecordTypeId, RecordType.Name, Organization_Name__r.Firm_Specialist__c  
        		  FROM Process_Adherence_Monitoring__c WHERE id =: recordId];
        			
        			
        scmdRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute').getRecordTypeId());
        scmdRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute - Account #s Sent').getRecordTypeId());
        scmdRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute - No PCodes Sent').getRecordTypeId());
        
        scmdACFRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute').getRecordTypeId());
        scmdACFRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute - Account #s Sent').getRecordTypeId());
        scmdACFRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute - No PCodes Sent').getRecordTypeId());
        
        //Added on 03-Feb-2020 Fro SCM DM records
        scmdDMRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM SCM Dispute').getRecordTypeId());
        scmdDMRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM SCM Dispute - Account #s Sent').getRecordTypeId());
        scmdDMRecordstypeIds.add(Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM SCM Dispute - No PCodes Sent').getRecordTypeId());
        
        
        caseObj.AccountId  = pamObj.Organization_Name__c;
        caseObj.Status = 'Awaiting Response';
        caseObj.Reason = 'Process Adherence Monitoring (PAM)';
        
        if(pamObj.RecordType.Name == 'LO SOL'){
            caseObj.Subcategories__c = 'SOL';
        }
        
        else if(pamObj.RecordType.Name == 'LO FRB'){
            caseObj.Subcategories__c = 'FRB';
        }else if(pamObj.RecordType.Name == 'LO CCM - JR' || pamObj.RecordType.Name == 'LO CCM - SR'){
            caseObj.Subcategories__c = 'Court Cost Monitoring';
        }
        /***************** Added on 14/Aug/2019 [for ACF IR process]*******************/
        else if(pamObj.RecordType.Name == 'ACF IR'  || pamObj.RecordType.Name == 'ACF IR - Account #\'s Sent'){
        	caseObj.Subcategories__c = 'IR';
            caseObj.MCM_Account__c = null;
            isIrView = true;
        }
        /******************* Added on 21-Jan-2020 [FOR DM IR PROCESS] ***********************/
        else if(pamObj.RecordType.Name == 'DM IR'  || pamObj.RecordType.Name == 'DM IR - Account #\'s Sent'){
        	caseObj.Subcategories__c = 'IR';
            caseObj.MCM_Account__c = null;
            isIrView = true;
        }
        
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Operations - PAM').getRecordTypeId();
        caseObj.Process_Adherence_Monitoring__c = pamObj.id;
        caseObj.MCM_Account__c = pamObj.Account_Number__c;
        caseObj.Turn_Off_Auto_response__c = true;
        
        if(pamObj.Organization_Name__c != null && pamObj.Organization_Name__r.Firm_Specialist__c != null){
        	caseObj.OwnerId = pamObj.Organization_Name__r.Firm_Specialist__c;
        }
        
        
        if(scmdRecordstypeIds.contains(pamObj.recordTypeId) || scmdACFRecordstypeIds.contains(pamObj.recordTypeId) || scmdDMRecordstypeIds.contains(pamObj.recordTypeId) ){ // used only for the scmd dispute process
        	isScmdView = true;
        	caseObj.Subcategories__c = 'SCMD';
        	caseObj.Type = 'SME';
        	caseObj.Origin = 'Internal';
        	caseObj.MCM_Account__c = null;
        }else if(pamObj.RecordType.Name == 'LO IR' || pamObj.RecordType.Name == 'LO IR - Account #\'s Sent'){
        	caseObj.Subcategories__c = 'IR';
            caseObj.MCM_Account__c = null;
            isIrView = true;
        }
        
        if( pamObj.RecordType.Name == 'LO PNA' ){ 
        	caseObj.Subcategories__c = 'PNA';
        	caseObj.Type = 'SME';
        	caseObj.Origin = 'Internal';
        }
        
        if( pamObj.RecordType.Name == 'LO PSNM' || pamObj.RecordType.Name == 'DM PSNM' ){ 
        	caseObj.Subcategories__c = 'PSNM';
        	caseObj.Type = 'SME';
        	caseObj.Origin = 'Internal';
        }
        
        if(pamObj.RecordType.Name == 'LO RSNM' || pamObj.RecordType.Name == 'DM RSNM'){
            caseObj.Subcategories__c = 'RSNM';
            caseObj.Type = 'SME';
        	caseObj.Origin = 'Internal';
        }
        
        caseObj.Subject = (pamObj.Organization_Name__c != null && pamObj.Organization_Name__r.Firm_ID__c != null ? pamObj.Organization_Name__r.Firm_ID__c+' ': '')+(caseObj.Subcategories__c != null ? caseObj.Subcategories__c:'')+' Process Inquiry - '+pamObj.Name; 
         
    }
    
    public PageReference saveCase(){
        try{
            insert caseObj;
            SendEmail();
            return new PageReference('/'+pamObj.id);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
        return null;
    }
    
    public void SendEmail(){
        
        caseObj = [SELECT New_Thread_Id__c, Description,ContactEmail,Subcategories__c,Subject 
                   FROM Case 
                   WHERE Id =: caseObj.id];
        
        List<String> emailList = new List<String>();
        if(!Test.isRunningTest()){
            //emailList.add(pamObj.Owner.Email);
            
            /*****Added on 7-6-2019 to send the email notification to the Selected Contact Email*****/
            if(caseObj.ContactEmail != NULL)
                emailList.add(caseObj.ContactEmail); //user2firma@mcmcg.com
            	
            /****************************************************************************************/
        }else{
            emailList.add('user1firma@mcmcg.com');
        }
       // System.debug('emailList >> '+emailList);
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(emailList);
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'lo-operational@mcmcg.com'];
        if (owea.size() > 0 ) {
            message.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        message.setReplyTo('LO-Operational@mcmcg.com');
        
        //changes made on 19-Feb-2020
        EmailTemplate emailTemplate = [Select Id from EmailTemplate where name = 'LO: Case - Inquiry Button - PAM'];
        Case caseContact = [SELECT ContactId FROM Case WHERE Id =: caseObj.Id][0];
        
        //Code changed on 19-Feb-2020
        message.setTargetObjectId(caseContact.ContactId);// userid
        message.setTemplateId(emailTemplate.Id);
        message.setWhatid(caseContact.Id); 
        
        //Commented on 21-Feb-2020
        /* message.subject = caseobj.Subject;
		message.subject = 'SOL - Inquiry : ' + pamObj.Name + ' ' + pamObj.Account_Number__c;*/
        
        //Commented on 21-Feb-2020
      /*  message.plainTextBody = 'Hello,\n\n\n' + caseobj.Description + '\n\nThank You,\n\nProcess Adherence Team\n';
        message.plainTextBody += 'Ref #: (' + caseObj.New_Thread_Id__c + ') DO NOT DELETE REF #';*/
        
         
        
        
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results;
        //changes done on 21-Feb-2020
        try{
            results = Messaging.sendEmail(messages);
        }catch(Exception ex){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); //Please select a community user
        }
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
}