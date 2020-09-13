/*
##########################################################################################################################################
# Project Name..........: CI Box Related Work 
# File..................: Trigger : "AccountTrigger"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 02-Oct-2014
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 19-Jan-2015
# Description...........: On Going Process -->>> It will create all Firm's Firm Dates records  based on its created date
###############################################################################################################################################
*/



trigger BoxFolderIDMapTrigger on Box_Folder_ID_Map__c (after insert) {
    Firm_Dates__c fd;
    list<Firm_Dates__c> fds = new list<Firm_Dates__c>();
    //list<Case_Firm_Dates__c> casefds = new list<Case_Firm_Dates__c>();
    
    map<Id,Account> AccountMap;
    map<Id,Case> caseMap;
    
    set<Id> AccountIDSet = new set<Id>();
    set<Id> caseIDSet = new set<Id>();
    
    for(Box_Folder_ID_Map__c Fold : trigger.new){
        if(Fold.Reference_ID__c != Null && Fold.Reference_ID__c != ''){
            if(Fold.Type__c != Null && Fold.Type__c.trim() != '' && Fold.Type__c == 'Account')
                AccountIDSet.add(Fold.Reference_ID__c);// Putting all inserted folderID
        }
    }

    if(AccountIDSet != Null && AccountIDSet.size() > 0){
        AccountMap = new Map<Id,Account>([Select Id, Name, Firm_ID__c, CreatedDate from Account Where Id IN: AccountIDSet]); // picking all Account only
    }
    
    if(AccountMap != Null && AccountMap.size() > 0)
    {
        for(Box_Folder_ID_Map__c bfim : trigger.new)
        {
            if(bfim.Type__c == 'Account')
                
            {
                for(integer i=AccountMap.get(bfim.Reference_ID__c).createdDate.Year(); i<=system.today().year(); i++)// 2011 till current year it will run
                {
                    Integer monthValue = AccountMap.get(bfim.Reference_ID__c).createdDate.Year() == i?AccountMap.get(bfim.Reference_ID__c).createdDate.Month():1;
                    for(integer j=monthValue; j<=12; j++)// for each month it will run
                    {
                        fd = new Firm_Dates__c();
                        if(j < 10)// append zero if month comes between 0 to 9
                        {
                            fd.Name__c = i + '-0' + j;
                        }else // else we are good for 10,11,12 as a month in creation
                        {
                            fd.Name__c = i + '-' + j;
                        }
                        fd.Box_Folder_ID_Map__c = bfim.Id;
                        fd.status__c = 'In Progress';
                        fds.add(fd);
                    }
                }
            }
        }
    }
    // It will insert all Firm Dates Records in salesforce for each Account based on year-month combination
    if(fds != Null && fds.size() > 0){
        try{
            insert fds;
        }catch(exception e){
            system.debug('***** Firm Dates error *****');
            system.debug('The error is'+e.getMessage());
            system.debug('The error Line Number is'+e.getLineNumber());
        }   
    }
    
}