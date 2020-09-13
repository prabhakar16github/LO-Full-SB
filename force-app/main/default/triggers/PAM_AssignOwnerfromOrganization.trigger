trigger PAM_AssignOwnerfromOrganization on Process_Adherence_Monitoring__c (before insert) {
  // @ Deprecated on 14/8/2018
  	/*
    Set<id> accountId = new Set<id>();
    system.debug('accountId-->'+accountId);
    List<Contact> conList = new List<Contact>();
    For(Process_Adherence_Monitoring__c pam : Trigger.new)
    {
      if(pam.Organization_Name__c!= Null)
      accountId.add(pam.Organization_Name__c);   
    }
    conList = [select id,Name,Community_Profile__c,Inactive_Contact__c,Contact_Type_SME__c FROM Contact WHERE AccountId IN :accountId AND (Contact_Type_SME__c INCLUDES  ('Process Adherence Monitoring (PAM)') OR Contact_Type_SME__c =  'Process Adherence Monitoring (PAM)') AND Inactive_Contact__c = FALSE];
    List<User> userlist = new List<User>();
    system.debug('conList-->'+conList);
    if(conList.size()>0)
    {       
    userlist = [Select Id,isActive FROM User Where ContactId != Null AND ContactId =: conList[0].id];
    }
    system.debug('userlist-->'+userlist);
      for(Process_Adherence_Monitoring__c pam : Trigger.new)
      {
        if(!conList.isEmpty() && conList[0].Inactive_Contact__c == False){
          pam.OwnerId = userlist[0].Id; 
          pam.Inactive_Owner__c = False;
        }
        if(!conList.isEmpty() && conList[0].Inactive_Contact__c == True){
          pam.OwnerId = userlist[0].Id; 
          pam.Inactive_Owner__c = True;
        }
        else if(conlist.size() == 0 || userlist[0].isActive == False)
        {
            pam.OwnerId = UserInfo.getUserId(); 
        }  
      } */  
 }