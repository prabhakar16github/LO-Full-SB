trigger UpdateFirmDuringEmail2Case on Case (after insert) {
// deprecate on 15 - feb -2018

/*


Map<ID, Set<String>> mapCaseIDSubject = new Map<ID, Set<String>>();
Map<String,String> setofAgencyID = new Map<String,String> ();
map<ID,string> mapAccIDFirmORAgencyName = new map<ID,string>(); 
map<String,ID> mapFirmiAgencyNameID = new map<string,ID>(); 
 

// List to Update Case
list<Case> updateCaseLst = new list<Case>();
set<Case> updateCaseSet = new set<Case>(); 
map<id,case> mapofWinCase = new  map<id,case>();
    for(case c:trigger.new) //[select id,subject from case where id='5007A000000wLfz']
    {
    System.debug('Sunny---1-'+c +'---'+c.Account.Name);
       if(c.subject!='' && c.subject!=null
        && c.Mapped_Organization_Value__c==null && c.Firm_ID__c=='CA20'){
      
       System.debug('Sunny---02--Name>'+c.Account.Name);
       String[] cd = c.subject.split(' ');
       Set<String> extractUniqueSubject = new Set<String>();
       for(string s:cd)
       {           
        if(s.isAlphanumeric())        
        extractUniqueSubject.add(s.toUpperCase());
       }
       System.debug('Sunny---2-'+extractUniqueSubject.size()+'==='+extractUniqueSubject);
       mapCaseIDSubject.put(c.id,extractUniqueSubject);       
       }    
        
       
       //if subject is blank
        else{
                                   
            if(c.AccountID!=null && c.Firm_ID__c=='CA20'){
                System.debug('Sunny----3--c.id---'+c);
             Case cUpdate = new Case();
                        cUpdate.id=c.id;
                        cUpdate.AccountId =null;                       
                        cUpdate.IsOrganizationUpdated__c=false;
                        cUpdate.Mapped_Organization_Value__c='';
                        updateCaseSet.add(cUpdate);     
                 break;   
            } 
             
        }    
                
        
    }      
    System.debug('Sunny----5--'+mapCaseIDSubject.size()+'-----'+mapCaseIDSubject);
     
    if(!mapCaseIDSubject.isEmpty()){
        for(Account a:[SELECT id,Name,Agency_ID__c,Firm_ID__c  FROM Account limit 2000])
        {
            if(a.Firm_ID__c!='' && a.Firm_ID__c!=null && mapAccIDFirmORAgencyName.get(a.id)==null){
            mapAccIDFirmORAgencyName.put(a.id,a.Firm_ID__c);        
            mapFirmiAgencyNameID.put(a.Firm_ID__c,a.id);
            }
                    
            else{        
            mapAccIDFirmORAgencyName.put(a.id,a.Agency_ID__c);
            mapFirmiAgencyNameID.put(a.Agency_ID__c,a.id);
            setofAgencyID.put(a.Agency_ID__c,a.Agency_ID__c);
            }       
     }
    
    }   
        for(case c:trigger.new)
        {
           System.debug('Sunny-----6---'+c);
           if(mapCaseIDSubject.get(c.id)!=null)
           { 
            Boolean processedCase = false;
                System.debug('Sunny-----7----'+mapCaseIDSubject.get(c.id));
                for(String sMatch: mapCaseIDSubject.get(c.id))
                {
                    if(mapFirmiAgencyNameID.get(sMatch)!=null && !processedCase)
                    {
                        System.debug('Sunny------8-Win'+mapFirmiAgencyNameID.get(sMatch)+'----'+sMatch);
                        if(mapofWinCase.get(c.id)!=null){
                            System.debug('Sunny------9-Lose'+c);
                        mapofWinCase.remove(c.id);
                        updateCaseSet.remove(c);                        
                        }   
                        Case cUpdate = new Case();
                        cUpdate.id=c.id;
                        cUpdate.AccountId = mapFirmiAgencyNameID.get(sMatch);                       
                        cUpdate.IsOrganizationUpdated__c=true;                      
                        cUpdate.Mapped_Organization_Value__c=sMatch;
                        processedCase=true;                      
                        mapofWinCase.put(cUpdate.id,cUpdate);   
                        if(processedCase){
                        updateCaseSet.add(cUpdate);
                        }   
                       break; 
                    } 
                    // only to update of no match found
                                    
                    
                }           
                if(mapofWinCase.get(c.id)==null && c.Firm_ID__c!='CA20'){
                System.debug('Sunny----10----->>>'+c);     
                Case cUpdate = new Case();
                                    cUpdate.id=c.id;
                                    cUpdate.AccountId =null;                       
                                    cUpdate.IsOrganizationUpdated__c=false;
                                    cUpdate.Mapped_Organization_Value__c='';                                     
                                    updateCaseSet.add(cUpdate);         
                    
                }
            
            }
        }
    
    
    if(!updateCaseSet.isEmpty()){
    System.debug('Sunny------12---'+updateCaseSet.size()+'----'+updateCaseSet);
    updateCaseLst.addALL(updateCaseSet);
    System.debug('Sunny---------13-'+updateCaseLst.size()+'----'+updateCaseLst);
    update updateCaseLst;   
    }
    
     
  */  
}   
/* if(setofAgencyID.get(sMatch)==null)
                        cUpdate.Firm_ID__c =mapAccIDFirmORAgencyName.get(cUpdate.AccountId); // update Firm ID
                        else
                        cUpdate.Agency_ID__c =mapAccIDFirmORAgencyName.get(cUpdate.AccountId);  */