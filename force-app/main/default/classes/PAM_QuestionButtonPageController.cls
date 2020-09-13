public with sharing class PAM_QuestionButtonPageController {
    
    List<Case> CaseList = new List<Case>();
    List<Case> CasetoDisplay = new List<Case>();
    List<User> userList = new List<User>();
    Set<Id> PAMOwnerId = new Set<Id>();
    public boolean showCase{get;set;}
    

    public PAM_QuestionButtonPageController(ApexPages.StandardController controller) {
                
        Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Case.getRecordTypeInfosByName();
         Id rtLeadID =  rtMap.get('Operations - PAM').getRecordTypeId(); 
         Id pageId = ApexPages.currentPage().getParameters().get('id');
         Process_Adherence_Monitoring__c[] PAMList = [select id,Account_Number__c,Organization_Name__c,OwnerId from Process_Adherence_Monitoring__c where id =: pageId];
         system.debug('PAMList-->>'+PAMList);
        
        for(Process_Adherence_Monitoring__c pam : PAMList)
        {
            PAMOwnerId.add(pam.OwnerId);
        }
         system.debug('PAMOwnerId-->>'+PAMOwnerId);
        
        userList = [Select Id,Name,Contactid FROM User where Id =: PAMOwnerId];
        system.debug('userList-->'+userList);
        
        String sCase = ApexPages.currentPage().getParameters().get('showCC');
        if(sCase == '1')
        {
            showCase = true;
        }
                
        CaseList = [Select id,Reason,Subcategories__c,Accountid,OwnerId,RecordTypeId,MCM_Account__c FROM Case WHERE Process_Adherence_Monitoring__c =: pageId limit 1];
         system.debug('CaseList-->>'+CaseList);
        
        if(CaseList.size() == 0 || CaseList.size() > 0)
        {
        Case c = new Case();
        c.AccountId  = PAMList[0].Organization_Name__c;
        //c.ContactId = userList[0].Contactid;
        system.debug('PAMList[0].OwnerId-->>'+PAMList[0].OwnerId);
        c.Reason = 'Process Adherence Monitoring (PAM)';
        c.Subcategories__c = 'FRB';
        c.RecordTypeId = rtLeadID;
        c.Process_Adherence_Monitoring__c = PAMList[0].Id;
        c.MCM_Account__c = PAMList[0].Account_Number__c;
        CasetoDisplay.add(c);
        }
     }
   public list<Case> getccLIst(){
       if(CasetoDisplay.size() >0){
         return CasetoDisplay;
       }
       return null;
   }
   public PageReference save()
   {         
      try{
           if(CasetoDisplay.size() <> null){
             insert CasetoDisplay;
             return new PageReference('/'+CasetoDisplay[0].Process_Adherence_Monitoring__c);
           }
        
       }
       catch(Exception ex){
          ApexPages.addMessages(ex);
       }
          return null;
        
   }   
}