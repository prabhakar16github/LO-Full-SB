/*
##########################################################################################################################################
# Project Name..........: CI Box Related Work 
# File..................: Class : "LC_FirmChildReplicaCreationBatchClass"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 02-Oct-2014
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 19-Jan-2015
# Description...........: Batch Class: It will pick all Firms and start working on them by picking 1 firm at a time.It will then Insert That Firm's data in Box folder Id map table 
and define type as Account where further Box folder Id Map Trigger will further creates All Firm dates starting from its created date till current year's last month.
Then, it will pick all CI i.e. Consumer Inquiries records to further insert CI replica under Firm Child's then further it will under Firm Dates

They will only pick all histroical data and start creating their replica's

Job Will need to Run Manually throough Developer Console : 
LC_FirmChildReplicaCreationBatchClass LC_FCRCBC = new LC_FirmChildReplicaCreationBatchClass();
Database.executeBatch(LC_FCRCBC,1);


Sequence Number: 01 - Needed
###############################################################################################################################################
*/


global class LC_FirmChildReplicaCreationBatchClass implements Database.Batchable<sObject>{
	
	list<Account> accList = new list<Account>();
	list<Case> caseList = new list<Case>();
	map<string,Firm_Dates__c> mapFirmDates = new map<string,Firm_Dates__c>();
	list<Firm_s_Child__c> fcCIListtoInsert = new list<Firm_s_Child__c>();
	
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator([select id from Account]); // pick all Accounts
	}
	
	global void execute(Database.BatchableContext BC, List<Account> accountList){
		
		system.debug('Account == '+system.now()+'  --  '+accountList.size());
		
		// We always need to call batch with batch size=1
		
		accList = [select id, Firm_ID__c, Agency_ID__c, CreatedDate, Name,
					(select id, Name, CreatedDate from Consumer_Inquiries_MCM__r where RecordType.Name = 'Regulatory Complaint')
				from Account where id =: accountList[0].Id]; // batch size 01
		
		
		Boolean validateBFIMFlag;
		if((accList[0].Firm_ID__c != null && accList[0].Firm_ID__c.trim() != '') ||
				(accList[0].Agency_ID__c != null && accList[0].Agency_ID__c.trim() != '')){
			validateBFIMFlag = [select count() from Box_Folder_ID_Map__c where Firm_ID__c != null and Firm_ID__c != '' and
					(Firm_ID__c =: accList[0].Firm_ID__c or Firm_ID__c =: accList[0].Agency_ID__c) limit 1] == 1?true:false;
		}	
				
		if(!accList.isEmpty()){
			
			//Firm Replica creation code STARTS here
			Box_Folder_ID_Map__c BFIM = new Box_Folder_ID_Map__c();
			
				//code to validate whether account replica created or not STARTS here
				list<Box_Folder_ID_Map__c> BFIMCheck = new list<Box_Folder_ID_Map__c>();
				BFIMCheck = [select id from Box_Folder_ID_Map__c where type__c = 'Account' and Actual_Firm__c =: accountList[0].Id limit 1];
				//code to validate whether account replica created or not ENDS here
				
				//code to create replica if not exists STARTS here
					if(BFIMCheck.isEmpty()){
						BFIM.Actual_Firm__c = accList[0].Id;
			            BFIM.Reference_ID__c = accList[0].Id;
			            if(accList[0].Firm_ID__c != null && accList[0].Firm_ID__c.trim() != ''){
			            	if(validateBFIMFlag)
			            		BFIM.Firm_ID__c = accList[0].Firm_ID__c+' - '+accList[0].Id;
			            	else if(!validateBFIMFlag)
			            		BFIM.Firm_ID__c = accList[0].Firm_ID__c;
						}else if(accList[0].Agency_ID__c != null && accList[0].Agency_ID__c.trim() != ''){
			            	if(validateBFIMFlag)
			            		BFIM.Firm_ID__c = accList[0].Agency_ID__c+' - '+accList[0].Id;
			            	else if(!validateBFIMFlag)
			            		BFIM.Firm_ID__c = accList[0].Agency_ID__c;
						}else
			            	BFIM.Firm_ID__c = accList[0].Name+' - '+accList[0].Id;
			            BFIM.Type__c = 'Account';
			            BFIM.Created_Date__c = accList[0].CreatedDate;
			            try{
			                insert BFIM; // Insert account in BFMI
			            }catch(exception e){
			                system.debug('***** Firm error *****');
			                system.debug('The error is'+e.getMessage());
			                system.debug('The error Line Number is'+e.getLineNumber());
			            }  
					}else{
						BFIM = BFIMCheck[0];
					}
		        //code to create replica if not exists ENDS here
			//Firm Replica creation code ENDS here
			
			
			
			list<Firm_Dates__c> FirmDatesList = new list<Firm_Dates__c>();
            FirmDatesList = [Select Id, Name__c From Firm_Dates__c where Box_Folder_ID_Map__c =: BFIM.Id]; // Retrive existing Firm Dates Records from Firm Dates table
			
			if(!FirmDatesList.isEmpty()){
				for(Firm_Dates__c fd: FirmDatesList){
					mapFirmDates.put(fd.Name__c,fd);
				}
			}
			
			
			
			//Consumer Inquiries Replica creation code STARTS here
			if(accList[0].Consumer_Inquiries_MCM__r.size() > 0 && !FirmDatesList.isEmpty()){
				string str = '';
				for(Consumer_Inquiries__c ci: accList[0].Consumer_Inquiries_MCM__r){
					str = ci.CreatedDate.year() + '-';
                    if(ci.CreatedDate.month() < 10)
                        str += '0'+ci.CreatedDate.month();
                    else
                        str += ci.CreatedDate.month();
					if(mapFirmDates.containsKey(str)){
						Firm_s_Child__c fc = new Firm_s_Child__c();
						fc.Firm_Date__c = mapFirmDates.get(str).Id; // Under Firm dates
						fc.Consumer_Inquiries_Reference__c = ci.Id;
						fc.Box_CI_Case_Name__c = 'CI'+ci.Name;
						fc.Reference_ID__c = ci.Id;
						fc.Type__c = 'Consumer Inquiry'; // CI TYpe and later case we can insert
	                    fcCIListtoInsert.add(fc);
					}
				}
			}
			system.debug('The List size (CI)== '+fcCIListtoInsert.size());  
	        if(!fcCIListtoInsert.isEmpty()){ // inserting CI in Firm_s_Child__c table
	            try{
	                insert fcCIListtoInsert;
	            }catch(exception e){
	                system.debug('***** CI error *****');
	                system.debug('The error is'+e.getMessage());
	                system.debug('The error Line Number is'+e.getLineNumber());
	            }   
	        }
			//Consumer Inquiries Replica creation code ENDS here
			
		}
		
	}
	
	global void finish(Database.BatchableContext BC){
		
	}
	
}