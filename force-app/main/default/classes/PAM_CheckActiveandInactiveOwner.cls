global class PAM_CheckActiveandInactiveOwner implements Schedulable {
  
   global void execute(SchedulableContext sc) {
   
     Set<id> accountId = new Set<id>();
     List<Contact> conList = new List<Contact>();
     Map<Id,Id> mapUC = new Map<Id,Id>();
     Map<Id,Contact> mapCA = new Map<Id,Contact>();
     String id;
     List<Process_Adherence_Monitoring__c> pamList = new List<Process_Adherence_Monitoring__c>();        
     pamList = [Select id,Status__c,Organization_Name__c,OwnerId,First_Escalation_Day__c,Created_Date_DV__c,CreatedDate,Second_Escalation_Day__c,Inactive_Owner__c FROM Process_Adherence_Monitoring__c];
     
     
        For(Process_Adherence_Monitoring__c pam : pamList){
            if(pam.Organization_Name__c!= Null){
                accountId.add(pam.Organization_Name__c);   
                
            }
        }
 
        conList = [select id,Name,Community_Profile__c,Inactive_Contact__c,Contact_Type_SME__c FROM Contact WHERE AccountId IN :accountId 
                   AND (Contact_Type_SME__c INCLUDES  ('Process Adherence Monitoring (PAM)') OR Contact_Type_SME__c =  'Process Adherence Monitoring (PAM)') ORDER By CreatedDate DESC];
        
       List<User> userlist = new List<User>([Select Id,ContactId FROM User]);
        for(User us : userlist)
        {
            if(us.Contactid != Null)
            mapUC.put(us.id,us.Contactid);
        }
        system.debug('pamList-->'+pamList);
        system.debug('conList-->'+conList);
        system.debug('conListsize-->'+conList.size());
        
                
        list<Process_Adherence_Monitoring__c > processList = new list<Process_Adherence_Monitoring__c>(); 
        
        
        
        for(Contact con:conList){
            
          mapCA.put(con.Id,con);
          }
          system.debug('mapCA-->'+mapCA);
          for(Process_Adherence_Monitoring__c pamonitoring : pamList)
          { 
            if(mapUC.get(pamonitoring.Ownerid) != Null)
            id = mapUC.get(pamonitoring.Ownerid);
            if(mapCA.get(id) != null &&pamonitoring.Inactive_Owner__c != mapCA.get(id).Inactive_Contact__c)
            {
                pamonitoring.Inactive_Owner__c = mapCA.get(id).Inactive_Contact__c;
                processList.add(pamonitoring);
            }
          }
          if(processList.size() >0 && processList != Null)
         update processList;
        system.debug('processList-->'+processList);
   }

}