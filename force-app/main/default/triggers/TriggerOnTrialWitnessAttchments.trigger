trigger TriggerOnTrialWitnessAttchments on Attachment (after insert,after undelete,after delete,before delete) {

    // Trial Witness
    Set<id> parentTWids = new Set <id>();
    list<Trial_Witness_Request__c> ta = new list<Trial_Witness_Request__c>();
    list<Trial_Witness_Request__c> updateta = new list<Trial_Witness_Request__c>();

    //Counterclaim
    Set<id> parentCCids = new Set <id>();
    list<Counterclaim__c> Cclaim = new list<Counterclaim__c>();
    list<Counterclaim__c> updateclaim = new list<Counterclaim__c>();   
    
    //Escalated Contested Matter
    Set<id> parentECMids = new Set <id>();
    list<Escalated_Contested_Matters__c> ecmList = new list<Escalated_Contested_Matters__c>();
    list<Escalated_Contested_Matters__c> updateECMList = new list<Escalated_Contested_Matters__c>();   
    
    //Business Record Affidavit
    Set<id> parentBRAids = new Set <id>();
    list<Business_Record_Affidavit__c> Brat = new list<Business_Record_Affidavit__c>();
    list<Business_Record_Affidavit__c> updateBrat = new list<Business_Record_Affidavit__c>();   
    
    //Purchase Sales Agreement
    Set<Id> parentPSAids = new Set<Id>();
    list<Purchase_and_Sales_Agreement__c> Psag = new list<Purchase_and_Sales_Agreement__c>();
    list<Purchase_and_Sales_Agreement__c> updatePsag = new list<Purchase_and_Sales_Agreement__c>();        
    
    //Discovery
    Set<Id> parentDDIds = new Set <Id>();
    list<Discovery__c> Dcovery = new list<Discovery__c>();
    list<Discovery__c> updatediscovery = new list<Discovery__c>();        
    
    //Call Monitoring
    list<Call_Monitoring__c> cm = new list<Call_Monitoring__c>();
    list<Call_Monitoring__c> updatet_CM = new list<Call_Monitoring__c>();
    List<ID> CMList = new List<ID>();
    map<ID,ID> DeletedCMList = new map<ID,ID>();
    
    //Consumer Inquiries
    list<Consumer_Inquiries__c> ci = new list<Consumer_Inquiries__c>();
    list<Consumer_Inquiries__c> updatet_CI = new list<Consumer_Inquiries__c>();
    List<ID> CIList = new List<ID>();
    map<ID,ID> DeletedCIList = new map<ID,ID>();

    if(trigger.isinsert || trigger.isundelete)
    {
        for(Attachment at : trigger.new)
        {
            if(at.ParentId.getSobjectType() == Trial_Witness_Request__c.SobjectType)
            parentTWids.add(at.parentID);
            
            if(at.ParentId.getSobjectType() == Counterclaim__c.SobjectType) 
            {
            parentCCids.add(at.parentID);   
            }
            if(at.ParentId.getSobjectType() == Escalated_Contested_Matters__c.SobjectType)
            {
            parentECMids.add(at.parentID);   
            }
            if(at.ParentId.getSobjectType() == Discovery__c.SobjectType) 
            {
            parentDDIds.add(at.parentID);   
            } 
            if(at.ParentId.getSobjectType() == Business_Record_Affidavit__c.SobjectType) 
            {
            parentBRAids.add(at.parentID);  
            }  
            if(at.ParentId.getSobjectType() == Purchase_and_Sales_Agreement__c.SobjectType) 
            {
            parentPSAids.add(at.parentID);  
            }                     
            if(at.ParentId.getSobjectType() == Call_Monitoring__c.SobjectType){
              CMList.add(at.parentID);
            }
            
            if(at.ParentId.getSobjectType() == Consumer_Inquiries__c.SobjectType){           
              CIList.add(at.parentID);
            }
       }
      System.debug('Sunny-----CMList>>>'+CMList.size()+'==='+CMList+'==parentTWids=='+parentTWids.size()+'==='+parentTWids); 
    }
    if(trigger.isdelete)
    {
        for(Attachment at : trigger.old)
        {
           if(at.ParentId.getSobjectType() == Trial_Witness_Request__c.SobjectType) 
               parentTWids.add(at.parentID);
           if(at.ParentId.getSobjectType() == Counterclaim__c.SobjectType) 
               parentCCids.add(at.parentID);
           if(at.ParentId.getSobjectType() == Escalated_Contested_Matters__c.SobjectType) 
               parentECMids.add(at.parentID);
           if(at.ParentId.getSobjectType() == Discovery__c.SobjectType)
            {
              parentDDIds.add(at.parentID);   
            } 
           if(at.ParentId.getSobjectType() == Business_Record_Affidavit__c.SobjectType)
            {
              parentBRAids.add(at.parentID);   
            } 
           if(at.ParentId.getSobjectType() == Purchase_and_Sales_Agreement__c.SobjectType)
            {
              parentPSAids.add(at.parentID);   
            }                                 
           if(at.ParentId.getSobjectType() == Call_Monitoring__c.SobjectType){
                  CMList.add(at.parentID);
                  DeletedCMList.put(at.parentID,at.parentID);
           }   
           if(at.ParentId.getSobjectType() == Consumer_Inquiries__c.SobjectType){               
                  CIList.add(at.parentID);
                  DeletedCIList.put(at.parentID,at.parentID);
           }   
        }
      System.debug('Sunny-----CMList>>>'+CMList.size()+'==='+CMList+'==parentTWids=='+parentTWids.size()+'==='+parentTWids); 
      // if before delete 
        if(trigger.isbefore)
        {
          for(Attachment at : trigger.old)
            {
                if(at.ParentId.getSobjectType() == Call_Monitoring__c.SobjectType){
                   // CMList.add(new Call_Monitoring__c(Id=at.ParentId,Most_Recent_Attachment_Date__c = System.now())); 
                    System.debug('Sunny-----userinfo.getProfileId()>>>'+userinfo.getProfileId());
                     id id1 = userinfo.getProfileId();
                     System.debug('******************Profile ID' +id1);
                    List<Profile> profileName = [Select Name from Profile where Id =: id1];
                    // Restrict user from deletion if apart from Admin
                    if(!profileName[0].name.contains('Admin')){
                    System.debug('******************profileName-->' +profileName[0]);
                    CMList.add(at.parentID);
                    at.addError('Please submit a “Delete Request” via the User Support Object to delete an attachment and/or record.'); //System Administrator
                    }       
                     
               }   
               
               if(at.ParentId.getSobjectType() == Consumer_Inquiries__c.SobjectType){                  
                     id id1 = userinfo.getProfileId();
                     System.debug('******************Profile ID' +id1);
                    List<Profile> profileName = [Select Name from Profile where Id =: id1];
                    // Restrict user from deletion if apart from Admin
                    if(!profileName[0].name.contains('Admin')){
                    System.debug('******************profileName-->' +profileName[0]);
                    CIList.add(at.parentID);
                    at.addError('Please submit a “Delete Request” via the User Support Object to delete an attachment and/or record.'); //System Administrator
                    }       
                     
               }   

            }
        }   
        
 }
    if(!parentTWids.isEmpty())
    {
       ta=[select name,id,(select id,name from Attachments limit 1 ) from Trial_Witness_Request__c where id in :parentTWids];
       
        if(!ta.isEmpty())
        {
            for(Trial_Witness_Request__c tc : ta)
            {
              System.debug('Sunny---->>>>'+tc.Attachments.size());
                if(!tc.Attachments.isEmpty())    
                   tc.Attachments__c=true;    
                else    
                   tc.Attachments__c=false;
                
                updateta.add(tc);
            }  
        }
    }
    if(!parentCCids.isEmpty())
    {
       Cclaim=[select name,id,(select id,name from Attachments limit 1 ) from Counterclaim__c where id in :parentCCids];
       
        if(!Cclaim.isEmpty())
        {
            for(Counterclaim__c tc1 : Cclaim) 
            {
                if(!tc1.Attachments.isEmpty())    
                   tc1.CC_Attachments__c=true;    
                else    
                   tc1.CC_Attachments__c=false;
                
                updateclaim.add(tc1);
            }  
        }
    }
    if(!parentECMids.isEmpty())
    {
       ecmList = [select name,id,(select id,name from Attachments limit 1 ) from Escalated_Contested_Matters__c where id in :parentECMids];
       
        if(!ecmList.isEmpty())
        {
            for(Escalated_Contested_Matters__c ecmObj : ecmList) 
            {
                if(!ecmObj.Attachments.isEmpty())    
                   ecmObj.ECM_Attachments__c=true;    
                else    
                   ecmObj.ECM_Attachments__c=false;
                
                updateECMList.add(ecmObj);
            }  
        }
    }    
    if(!parentDDIds.isEmpty())
    {
       Dcovery=[select name,id,(select id,name from Attachments limit 1) from Discovery__c where id in :parentDDIds];
       
        if(!Dcovery.isEmpty())
        {
            for(Discovery__c tc1 : Dcovery) 
            {
                if(!tc1.Attachments.isEmpty())    
                   tc1.DY_Attachments__c    =true;    
                else    
                   tc1.DY_Attachments__c    =false;
                
                updatediscovery.add(tc1);
            }  
        }
    }
    //Business Record Affidavit
    if(!parentBRAids.isEmpty())
    {
       Brat=[select name,id,(select id,name from Attachments limit 1) from Business_Record_Affidavit__c where id in :parentBRAids];
       
        if(!Brat.isEmpty())
        {
            for(Business_Record_Affidavit__c tc1 : Brat) 
            {
                if(!tc1.Attachments.isEmpty())    
                   tc1.BRA_Attachments__c = true;    
                else    
                   tc1.BRA_Attachments__c = false;
                
                updateBrat.add(tc1);
            }  
        }
    } 
    //Purchase Sales Agreement
        if(!parentPSAids.isEmpty())
    {
       Psag=[select name,id,(select id,name from Attachments limit 1) from Purchase_and_Sales_Agreement__c where id in :parentPSAids];
       
        if(!Psag.isEmpty())
        {
            for(Purchase_and_Sales_Agreement__c tc1 : Psag) 
            {
                if(!tc1.Attachments.isEmpty())    
                   tc1.PSA_Attachment__c = true;    
                else    
                   tc1.PSA_Attachment__c = false;
                
                updatePsag.add(tc1);
            }  
        }
    }      
    //  Call Monitoring ..........

    if(!CMList.isEmpty())
    {
       cm=[select name,id,RecordTypeId,Owner.Type,OwnerId,(select id,name from Attachments limit 1 ) from Call_Monitoring__c where id in :CMList
           ]; //...........and RecordType.Name In ('Call Monitoring Log','Call Monitoring Materials')
    System.debug('Sunny---->>>>'+cm.size()+'------'+cm);
        if(!cm.isEmpty())
        {   
             for(Call_Monitoring__c tc : cm)
            {
            System.debug('0000000000----->>>'+tc.OwnerId+UserInfo.getUserId());
            // FOr CM QA Record Type
              if(tc.OwnerId== UserInfo.getUserId() && Utility.getCMRecordType(tc.RecordTypeID).contains('QA') && DeletedCMList.get(tc.id)==null){
              System.debug('11111111----->>>'+tc.OwnerId+UserInfo.getUserId());
                System.debug('Sunny---->>>>'+tc.Attachments.size());
                tc.Most_Recent_Attachment_Date__c=System.Now();
                if(!tc.Attachments.isEmpty())    
                   tc.Attachments__c=true;    
                else    
                   tc.Attachments__c=false;
                
                updatet_CM.add(tc);
              }
               System.debug('44444444----size->>>'+tc.Attachments.size());
               // Means last record also get deleted on QA record type
               if(Utility.getCMRecordType(tc.RecordTypeID).contains('QA') && DeletedCMList.get(tc.id)!=null && tc.Attachments.isEmpty()){
            //  tc.addError('You can not delete last attachment record'); 
                System.debug('Sunny--444-->>>>'+tc.Attachments.size());
                // Commenting this line so that no email has been sent on last deletion of attachment .....tc.Most_Recent_Attachment_Date__c=System.Now();
                if(!tc.Attachments.isEmpty())    
                   tc.Attachments__c=true;    
                else    
                   tc.Attachments__c=false;
                
                updatet_CM.add(tc);
              }
              
             // QA has last attachment into it
             
             
              // For Cm Log and materials Record Types
              if(!Utility.getCMRecordType(tc.RecordTypeID).contains('QA')){
              System.debug('333333333----222222222->>>'+tc.OwnerId+UserInfo.getUserId());
                System.debug('Sunny---->>>>'+tc.Attachments.size());
                tc.Most_Recent_Attachment_Date__c=System.Now();
                if(!tc.Attachments.isEmpty())    
                   tc.Attachments__c=true;    
                else    
                   tc.Attachments__c=false;
                
                updatet_CM.add(tc);
              }
              
            }  
        }   
    }
    
    //  Consumer inquiry..........

    if(!CIList.isEmpty())
    {
       ci=[select name,id,RecordTypeId,Owner.Type,OwnerId,(select id,name from Attachments limit 1 ) from Consumer_Inquiries__c where id in :CIList];
    System.debug('Sunny---->>>>'+ci.size()+'------'+ci);
        if(!ci.isEmpty())
        {   
             for(Consumer_Inquiries__c tc : ci)
            {
            System.debug('0000000000----->>>'+tc.OwnerId+UserInfo.getUserId());
            // FOr CI QA Record Type
              if(tc.OwnerId== UserInfo.getUserId() && Utility.getCIRecordType(tc.RecordTypeID).contains('Dissatisfaction') && DeletedCIList.get(tc.id)==null){
              System.debug('11111111----->>>'+tc.OwnerId+UserInfo.getUserId());
                System.debug('Sunny---->>>>'+tc.Attachments.size());
                tc.Most_Recent_Attachment_Date__c=System.Now();
                if(!tc.Attachments.isEmpty())    
                   tc.Attachments__c=true;    
                else    
                   tc.Attachments__c=false;
                
                updatet_CI.add(tc);
              }
               System.debug('44444444----size->>>'+tc.Attachments.size());
               // Means last record also get deleted on QA record type
               if(Utility.getCIRecordType(tc.RecordTypeID).contains('Dissatisfaction') && DeletedCIList.get(tc.id)!=null && tc.Attachments.isEmpty()){
            //  tc.addError('You can not delete last attachment record'); 
                System.debug('Sunny--444-->>>>'+tc.Attachments.size());
                // Commenting this line so that no email has been sent on last deletion of attachment .....tc.Most_Recent_Attachment_Date__c=System.Now();
                if(!tc.Attachments.isEmpty())    
                   tc.Attachments__c=true;    
                else    
                   tc.Attachments__c=false;
                
                updatet_CI.add(tc);
              }
              
             // QA has last attachment into it
             
             
              // For Ci Log and materials Record Types
              if(!Utility.getCIRecordType(tc.RecordTypeID).contains('Dissatisfaction')){
              System.debug('333333333----222222222->>>'+tc.OwnerId+UserInfo.getUserId());
                System.debug('Sunny---->>>>'+tc.Attachments.size());
                tc.Most_Recent_Attachment_Date__c=System.Now();
                if(!tc.Attachments.isEmpty())    
                   tc.Attachments__c=true;    
                else    
                   tc.Attachments__c=false;
                
                updatet_CI.add(tc);
              }
              
            }  
        }   
    }


    if(!updateta.isEmpty()){
        System.debug('Sunny---->>>>'+updateta.size()+'-----'+updateta);
        try{
          update updateta;
          }
        catch (system.Dmlexception e) {
        system.debug (e);  
        }
    }
    if(!updateclaim.isEmpty()){
        System.debug('Counterclaim---->>>>'+updateclaim.size()+'-----'+updateclaim);
        try{
          update updateclaim;
          }
        catch (system.Dmlexception e) {
        system.debug (e);  
        }
    }    
    if(!updateECMList.isEmpty()){
        System.debug('ECM---->>>>'+updateECMList.size()+'-----'+updateECMList);
        try{
          update updateECMList;
          }
        catch (system.Dmlexception e) {
        system.debug (e);  
        }
    }    
    if(!updateBrat.isEmpty()){
        System.debug('Businessrecordaffidavit---->>>>'+updateBrat.size()+'-----'+updateBrat);
        try{
          update updateBrat;
          }
        catch (system.Dmlexception e) {
        system.debug (e);  
        }
    }
    if(!updatePsag.isEmpty()){
        System.debug('Businessrecordaffidavit---->>>>'+updatePsag.size()+'-----'+updatePsag);
        try{
          update updatePsag;
          }
        catch (system.Dmlexception e) {
        system.debug (e);  
        }
    }    
    if(!updatediscovery.isEmpty()){
        System.debug('Discovery---->>>>'+updatediscovery.size()+'-----'+updatediscovery);
        try{
          update updatediscovery;
          }
        catch (system.Dmlexception e) {
        system.debug (e);  
        }
    }           
    if(!updatet_CM.isEmpty()){
        System.debug('CallMonitoring---->>>>'+updatet_CM.size()+'-----'+updatet_CM);
            try{
              update updatet_CM;
            }
            catch (system.Dmlexception e) {
            system.debug (e);  
            }
            
            ////Database.Saveresult[] srList = database.Update(uniqueAccounts,false);
        }
        
     if(!updatet_CI.isEmpty()){
        System.debug('Sunny---->>>>'+updatet_CI.size()+'-----'+updatet_CI);
            try{
              update updatet_CI;
            }
            catch (system.Dmlexception e) {
            system.debug (e);  
            }
            
            ////Database.Saveresult[] srList = database.Update(uniqueAccounts,false);
        }

    }