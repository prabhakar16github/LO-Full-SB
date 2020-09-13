public class LRMM_Response_InquiryController{
    
    public Case caseObj{get;set;}
    public sObject sObjLRMM{get;set;}
    public String questionLabel{get;set;}
    public String recordLabel{get;set;}
    public Boolean isResponse{get;set;}
    public Boolean isInquiry{get;set;}
    public Integer totalAttachments{get;set;}
    public List<Attachment> attList{get;set;}
    public String selectedObject{get;set;}
    
    private Map<String,String> LRMMObjShortDescMap = new Map<String,String>{'Appeal__c'=>'AP_','Business_Record_Affidavit__c'=>'BRA_',
        'Counterclaim__c'=>'CC_','Discovery__c'=>'DY_',
        'Escalated_Contested_Matters__c'=>'ECM_','Settlement_Approval__c'=>'SA_',
        'Purchase_and_Sales_Agreement__c'=>'PSA_','Trial_Witness_Request__c'=>''};
            
            public LRMM_Response_InquiryController(){
                caseObj = new Case();
                attList = new List<Attachment>();
                totalAttachments = 1;
                changeAttachmentSize();
                questionLabel = 'Details';
                isResponse = false;
                isInquiry = false;
                String recordId = apexpages.currentpage().getparameters().get('id');
                for(String objectName : LRMMObjShortDescMap .keyset()){
                    if(recordId.startsWith(Schema.getGlobalDescribe().get(objectName).getDescribe().getKeyPrefix())){
                        selectedObject = Schema.getGlobalDescribe().get(objectName).getDescribe().getLocalName();
                        recordLabel = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get('Name').getDescribe().getLabel();
                    }
                }
                
                String fieldsPrefix = LRMMObjShortDescMap.get(selectedObject);
                String fieldNames = 'OwnerId, Owner.Email, Name, Paralegal_Assignment__c, Organization_Name__c, Account_Number__c, Additional_Contacts__c';
                if(selectedObject != 'Trial_Witness_Request__c'){
                    fieldNames = fieldNames.replace('Organization_Name__c', fieldsPrefix + 'Organization_Name__c');
                    fieldNames = fieldNames.replace('Paralegal_Assignment__c', fieldsPrefix + 'Paralegal_Assignment__c');
                }
                if(selectedObject == 'Trial_Witness_Request__c'){
                    fieldNames = fieldNames.replace('Organization_Name__c', 'OrganizationName__c');
                    fieldNames = fieldNames.replace('Paralegal_Assignment__c', 'LW_Paralegal_Assignment__c');
                }
                fieldNames = fieldNames.replace('Additional_Contacts__c', fieldsPrefix + 'Additional_Contacts__c');
                fieldNames = fieldNames.replace('Account_Number__c', fieldsPrefix + 'Account_Number__c');
                
                sObjLRMM = Database.query('SELECT ' + fieldNames + ' FROM ' + selectedObject + ' WHERE id =: recordId');
                User userObj = [SELECT ContactId FROM User WHERE id =: sObjLRMM.get('OwnerId')+''];
                
                caseObj.Status = 'New';
                caseObj.Reason = selectedObject.remove('__c').replace('_',' ');
                caseObj.Turn_Off_Auto_response__c = true;
                caseObj.Privileged__c = true;
                caseObj.Priority = 'Normal';
                caseobj.ContactId = userObj.ContactId;
                caseObj.Subject = sObjLRMM.get('Name') + ' ' + sObjLRMM.get(fieldsPrefix  + 'Account_Number__c');
                caseObj.MCM_Account__c = sObjLRMM.get(fieldsPrefix  + 'Account_Number__c') + '';
                if(selectedObject != 'Trial_Witness_Request__c'){
                    if(sObjLRMM.get(fieldsPrefix  + 'Organization_Name__c') != null) caseObj.AccountId = sObjLRMM.get(fieldsPrefix  + 'Organization_Name__c') + '';
                    if(sObjLRMM.get(fieldsPrefix  + 'Paralegal_Assignment__c') != null){
                        caseObj.OwnerId = sObjLRMM.get(fieldsPrefix  + 'Paralegal_Assignment__c') + '';
                    }else{
                        List<User> userList = [SELECT id FROM User WHERE Name = 'Ashley Escobar'];
                        if(!userList.isEmpty()) caseObj.OwnerId = userList[0].id;
                    }
                }
                if(selectedObject == 'Trial_Witness_Request__c'){
                    if(sObjLRMM.get(fieldsPrefix  + 'OrganizationName__c') != null) caseObj.AccountId = sObjLRMM.get('OrganizationName__c') + '';
                    if(sObjLRMM.get(fieldsPrefix  + 'LW_Paralegal_Assignment__c') != null){
                        caseObj.OwnerId = sObjLRMM.get('LW_Paralegal_Assignment__c') + '';
                    }else{
                        List<User> userList = [SELECT id FROM User WHERE Name = 'Ashley Escobar'];
                        if(!userList.isEmpty()) caseObj.OwnerId = userList[0].id;
                    }
                }
                String recordTypeName = 'Legal Review - ' + fieldsPrefix.removeEnd('_');
                if(selectedObject == 'Trial_Witness_Request__c') recordTypeName = 'Trial Witness - Live';
                caseObj.RecordTypeId = [SELECT id FROM RecordType WHERE sObjectType = 'Case' ANd Name =: recordTypeName].id;
                String referenceField = selectedObject.removeEnd('__c');
                if(selectedObject != 'Trial_Witness_Request__c') referenceField = referenceField + '_Record__c';
                if(selectedObject == 'Trial_Witness_Request__c') referenceField = referenceField + '__c';
                caseObj.put(referenceField,sObjLRMM.id);
            }
    
    public void changeAttachmentSize(){
        attList.clear();
        for(Integer i = 0; i < totalAttachments; i++){
            attList.add(new Attachment());
        }
    }
    
    public void changeQuestionLabel(){
        if(isResponse && questionLabel != 'Response Details'){
            questionLabel = 'Response Details';
            isInquiry = false;
        }else if(isInquiry){
            questionLabel = 'Inquiry Details';
            isResponse = false;
        }else{
            questionLabel = 'Details';
        }
    }
    
    public PageReference saveCase(){
        String type = 'Response';
        if(isResponse){
            caseObj.Type = 'LRMM - Response';
            caseObj.Status = 'Closed';
            type = 'Response';
        }else if(isInquiry){
            caseObj.Type = 'LRMM - Inquiry';
            caseObj.Status = 'Awaiting Response-Ext';
            type = 'Inquiry';
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Response or Inquiry.'));
            return null;
        }
        System.debug('type >>>'+type);
        caseObj.Subject = type + ': ' + caseObj.Subject;
        //system.debug('Before: ' + caseObj);
        insert caseObj;
        //system.debug('After: ' + caseObj);
        SendEmail(type);
        return new PageReference('/'+sObjLRMM.id);
    }
    
    public void SendEmail(String type){
        List<String> emailList = new List<String>();
        String recordId = sObjLRMM.id;
        String fieldsPrefix = LRMMObjShortDescMap.get(selectedObject);
        if(sObjLRMM.get(fieldsPrefix  + 'Additional_Contacts__c') != null){
            for(String conObj : String.valueOf(sObjLRMM.get(fieldsPrefix  + 'Additional_Contacts__c')).split(';')){
                String email = conObj.subStringAfter('<').subStringBefore('>');
                emailList.add(email);
            }
        }
        if(!Test.isRunningTest()){
            emailList.add(sObjLRMM.getSobject('Owner').get('Email')+'');
            //emailList.add('shivangi.srivastava@mcmcg.com');
        }//else{
            //emailList.add('tst@gmail.com');//user1firma@mcmcg.com
        //}
        //changes made on 19-Feb-2020
        EmailTemplate emailTemplate = [Select Id from EmailTemplate where name = 'LO: Case - Inquiry Button - LRMM'];
        Case caseContact = [SELECT ContactId FROM Case WHERE Id =: caseObj.Id][0] ;
        System.debug('caseContact>>>>>>>>'+caseContact.ContactId);
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(emailList);
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'lo-legalreview@mcmcg.com'];
        if (owea.size() > 0 ) {
            message.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        
        message.setReplyTo('lo-legalreview@mcmcg.com');//	lo-legalreview@mcmcg.com
        
        
        //Code changed on 19-Feb-2020
        message.setTargetObjectId(caseContact.ContactId);// userid
        message.setTemplateId(emailTemplate.Id);
        message.setWhatid(caseContact.Id);
        
        
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        for(Attachment attObj : attList){
            if(attObj.Body != null){
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(attObj.Name);
                efa.setBody(attObj.Body);
                efa.setContentType(attObj.ContentType);
                fileAttachments.add(efa);
            }
        }
        message.setFileAttachments(fileAttachments);
        
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results;
        try{
            if(!Test.isRunningTest())
                results  = Messaging.sendEmail(messages);
        }catch(Exception ex){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); //Please select a community user
        }
        System.debug('results >>>>>>>>>>>>>>>> '+results);
        /*if (results[0].success) {
            System.debug('The email was sent successfully.');
            
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }*/
    }
}