/*
##############################################################################################################################################
#Batch Claa.............:batchToUpdateLoginTime
# Created by............: Sakshi Gandhi   
# Created Date..........: 15-11-2016  
# Last Modified by......: Sakshi Gandhi
# Description...........: This class will Update LastLogin Field of contact with LAst Login field value on User
##############################################################################################################################################
*/

global class batchToUpdateLoginTime implements Database.Batchable<SObject>{
   
    global database.querylocator start(Database.BatchableContext bc)
   {
       string ProfileName = Utility.getCCProfileNameLabel();            
       string query= 'Select id,profileId,LastLoginDate,ContactID  from User where ISActive= true AND profileId =: ProfileName  ';
       return Database.getQueryLocator(query);
   }
   global void execute(Database.BatchableContext bc, User[] UserList)
   {
      
       System.debug('======UserList=='+UserList); 
       map<id,User> mapContactDateToUpdate = new Map<id,User>();           
       set<id>ContactIdSet = new set<id>();      
       List<contact>   contactToUpdate= new List<Contact>();       
       List<Contact>contctList =new List<Contact>();     
       
       if(UserList != null && UserList.size()>0){        
           for(User U: UserList){                          
               ContactIdSet.add(U.ContactID);              
           }
       }
                
       contctList =[select id,Last_Login__c from Contact where Id in:ContactIdSet];           
       for(User Usr: UserList){          
           mapContactDateToUpdate.put(Usr.Contactid,Usr);
           system.debug('====mapContactDateToUpdate==='+mapContactDateToUpdate);
       } 
            
       if(UserList!= null && UserList.size()>0)
       {              
           for(Contact c:contctList){
               if(mapContactDateToUpdate!= null && mapContactDateToUpdate.containsKey(c.id)){
                    c.Last_Login__c  =mapContactDateToUpdate.get(c.id).LastLoginDate; 
                    contactToUpdate.add(c);
                    system.debug('====contactToUpdate==='+contactToUpdate);
                }
            }
                
       }
       
       if(contactToUpdate!= null && contactToUpdate.size() > 0)
       {
           Database.Saveresult[] srList = database.update(contactToUpdate,false);
           system.debug('====srList ==='+srList );
       }
           
    }       
      
    global void finish(Database.BatchableContext bc)
    {}
}