/*
##########################################################################################################################################
# Project Name..........: CI Box Related Work 
# File..................: Trigger : "AccountTrigger"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 02-Oct-2014
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 19-Jan-2015
# Description...........: On Going Process -->>> It will create all Firm's record in system under BOx Folder Id Map Table but first check if record exist then will append Salesforce ID while creating
Preference for creation would be 1. Firm ID 2. Agency ID 3 . Name+ SFDC ID
 

###############################################################################################################################################
*/



/*
	This trigger will create firm replica in box folder id map table after firm got inserted
	    box folder id map field	-	value
		Actual_Firm__c			Account
		Reference_ID__c			Account id
		Type__c					'Account'
		Created_Date__c			Account CreatedDate
		Firm_ID__c				
			i) If Account Firm_ID__c not equal to null then Account Firm_ID__c
			ii) If Account Firm_ID__c not equal to null and already a record exists with same folder name
						then Account Firm_ID__c+Account id
			iii) If Account Firm_ID__c equal to null and Agency_ID__c not equal to null then Account Agency_ID__c
			iv) If Account Firm_ID__c equal to null and Agency_ID__c not equal to null 
				and already a record exists with same folder name then Account Agency_ID__c+Account id 
			v) If Account Firm_ID__c equal to null and Account Agency_ID__c equal to null
				then Account Name + Account Id
*/
trigger AccountTrigger on Account (after insert) {

    Box_Folder_ID_Map__c BFIM = null;
    list<Box_Folder_ID_Map__c> firmReplicaList = new list<Box_Folder_ID_Map__c>();
    
    list<Box_Folder_ID_Map__c> validateFirmReplicaList = new list<Box_Folder_ID_Map__c>();
	map<string,Box_Folder_ID_Map__c> validateFirmReplicaMap = new map<string,Box_Folder_ID_Map__c>();
		

	set<string> boxFolderNameSet = new set<string>(); 

	for(Account acc: trigger.new){
		if(acc.Firm_ID__c != null && acc.Firm_ID__c.trim() != '')
            boxFolderNameSet.add(acc.Firm_ID__c);
        else if(acc.Agency_ID__c != null && acc.Agency_ID__c.trim() != '')
            boxFolderNameSet.add(acc.Agency_ID__c);
	}

	if(!boxFolderNameSet.isEmpty()){
		validateFirmReplicaList = [select id, Firm_ID__c from Box_Folder_ID_Map__c where 
									Firm_ID__c != null and Firm_ID__c != '' and Firm_ID__c IN: boxFolderNameSet];
		
		if(!validateFirmReplicaList.isEmpty()){
			for(Box_Folder_ID_Map__c bfimRec: validateFirmReplicaList)
				validateFirmReplicaMap.put(bfimRec.Firm_ID__c,bfimRec);
		}
	}	
	
    for(Account acc: trigger.new){
        BFIM = new Box_Folder_ID_Map__c();
        BFIM.Actual_Firm__c = acc.Id;
        BFIM.Reference_ID__c = acc.Id;
        if(acc.Firm_ID__c != null && acc.Firm_ID__c.trim() != ''){
            if(!validateFirmReplicaMap.isEmpty() && validateFirmReplicaMap.containsKey(acc.Firm_ID__c))
            	BFIM.Firm_ID__c = acc.Firm_ID__c+' - '+acc.Id;
            else
        		BFIM.Firm_ID__c = acc.Firm_ID__c;
        }else if(acc.Agency_ID__c != null && acc.Agency_ID__c.trim() != ''){
            if(!validateFirmReplicaMap.isEmpty() && validateFirmReplicaMap.containsKey(acc.Agency_ID__c))
            	BFIM.Firm_ID__c = acc.Agency_ID__c+' - '+acc.Id;
            else
        		BFIM.Firm_ID__c = acc.Agency_ID__c;
        }else
            BFIM.Firm_ID__c = acc.Name+' - '+acc.Id;
        BFIM.Type__c = 'Account';
        BFIM.Created_Date__c = acc.CreatedDate;
        firmReplicaList.add(BFIM);
    }
	
    
    if(!firmReplicaList.isEmpty()){
        try{
            insert firmReplicaList;
        }catch(exception e){
            system.debug('***** Firm error (Trigger) *****');
            system.debug('The error is'+e.getMessage());
            system.debug('The error Line Number is'+e.getLineNumber());
        }
    }  

}