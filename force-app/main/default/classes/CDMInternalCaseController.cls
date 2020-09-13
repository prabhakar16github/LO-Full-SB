public class CDMInternalCaseController{
    
    public Case caseObj{get;set;}
    public String caseAccountId{get;set;}
    public String caseContactId{get;set;}
    public Boolean caseCreated{get;set;}
    
    public CDMInternalCaseController(){
        caseObj = new Case();
        caseCreated = false;
        caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CDM: Internal Client Projects').getRecordTypeId();
        caseObj.Origin = 'Sharepoint';
        caseObj.Status = 'New';
        List<User> userList = [SELECT id FROM User WHERE Name = 'Jamie Garcia' LIMIT 1];
        if(!userList.isEmpty()){
            caseObj.OwnerId = userList[0].id;
        }else{
            caseObj.OwnerId = UserInfo.getUserId();
        }
    }
    
    public void CreateRecord(){
        if(caseAccountId == 'None'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Organization Name'));
            return ;
        }
        if(caseContactId == 'None'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Contact Name'));
            return ;
        }
        try{
            Boolean accountMatched = validateAccount(caseAccountId,caseContactId);
            if(!accountMatched){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Contact Name is not related to the selected Organization.'));
            }else{
                caseObj.AccountId = caseAccountId;
                caseObj.ContactId = caseContactId;
                insert caseObj;
                caseObj = [SELECT CaseNumber FROM Case WHERE id =: caseObj.id];
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Case ' + caseObj.CaseNumber + ' has been successfully created.'));
                caseCreated = true;
            }
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
    }
    
    public Boolean validateAccount(Id accountId, Id contactId){
        Boolean isCorrect = true;
        List<AccountContactRelation> accountContactList = new List<AccountContactRelation>();
        Set<String> accountIDSet = new Set<String>();
        if(contactId != null){
            accountContactList = [SELECT AccountId FROM AccountContactRelation WHERE ContactId =: contactId];
            for(AccountContactRelation acRelated : accountContactList){
                accountIDSet.add(acRelated.AccountId);
            }
        }
        
        if(!accountIDSet.contains(accountId)){
            isCorrect = false;
        }
        return isCorrect;
    }
    
    public List<SelectOption> getAccountRecordList(){
        String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CDM: Internal Clients').getRecordTypeId();
        List<SelectOption> tempList = new List<SelectOption>();
        tempList.add(new SelectOption('None','None'));
        List<Account> accList = [SELECT Name FROM Account WHERE RecordTypeId =: recordTypeId ORDER BY Name];
        for(Account accObj : accList){
            tempList.add(new SelectOption(accObj.id,accObj.Name));
        }
        return tempList;
    }
    
    public List<SelectOption> getContactRecordList(){
        String cdmInternalRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CDM: Internal Contacts').getRecordTypeId();
        String operationsRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Operations').getRecordTypeId();
        List<SelectOption> tempList = new List<SelectOption>();
        tempList.add(new SelectOption('None','None'));
        List<Contact> conList = [SELECT Name FROM Contact WHERE RecordTypeId = :cdmInternalRecordTypeId 
        							OR (RecordTypeId = :operationsRecordTypeId AND CDM_CDM__c = true) ORDER BY Name];
        for(Contact conObj : conList){
            tempList.add(new SelectOption(conObj.id,conObj.Name));
        }
        return tempList;
    }
}