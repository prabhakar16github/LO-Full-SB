/*
##########################################################################################################################################
# Project Name..........: CI Box Related Work 
# File..................: Trigger : "ConsumerInquiryTrigger"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 02-Oct-2014
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 19-Jan-2015
# Description...........: On Going Process -->>> It will create insert all newly entered CI's under Firm Child based on mapping Month-Year combination
 it will only insert CI of Regultory Complaint type.

###############################################################################################################################################
*/

/*
	This trigger will create ConsumerInquiry replica in FirmsChild table after ConsumerInquiry got inserted
	
	ConsumerInquiry should be of type 'Regulatory Complaint'
	
	replica will get related with the firmdate record created under the firm replica 
	(firm replica will be the firm assiciated with the ConsumerInquiry) 
	in box folder id map and firm dates table based on ConsumerInquiry createdDate
*/
trigger ConsumerInquiryTrigger on Consumer_Inquiries__c (after insert) {

	set<Id> accIds = new set<Id>();
	list<Box_Folder_ID_Map__c> FolderIDList = new list<Box_Folder_ID_Map__c>();
	map<Id,list<Firm_Dates__c>> AccountFirmMap = new map<Id,list<Firm_Dates__c>>();
	list<Firm_s_Child__c> fcCIListtoInsert = new list<Firm_s_Child__c>();
	
	Map<String,Schema.RecordTypeInfo> CIRecordTypeInfo = Schema.SObjectType.Consumer_Inquiries__c.getRecordTypeInfosByName(); 
    Id recordTypeId = CIRecordTypeInfo.get('Regulatory Complaint').getRecordTypeId();
	
	for(Consumer_Inquiries__c ci: trigger.new){
		if(ci.RecordTypeId == recordTypeId && ci.Firm_Name__c != null)
			accIds.add(ci.Firm_Name__c);
	}

	if(!accIds.isEmpty()){
        FolderIDList = [Select Id, Name, Reference_ID__c, Type__c, 
                        (Select Id, Name, Name__c From Firm_Dates__r)
                        from Box_Folder_ID_Map__c
                        where Type__c = 'Account' and Actual_Firm__c IN: accIds];
		
		if(!FolderIDList.isEmpty()){
			for(Box_Folder_ID_Map__c bfim: FolderIDList){
				AccountFirmMap.put(bfim.Reference_ID__c,bfim.Firm_Dates__r);
			}
			
			if(!AccountFirmMap.isEmpty()){
                string str;
                for(Consumer_Inquiries__c ci: trigger.new){
                	if(ci.RecordTypeId == recordTypeId && ci.Firm_Name__c != null){
						str = ci.CreatedDate.year() + '-';
	                    if(ci.CreatedDate.month() < 10)
	                        str += '0'+ci.CreatedDate.month();
	                    else
	                        str += ci.CreatedDate.month();
						if(AccountFirmMap.containsKey(ci.Firm_Name__c) && AccountFirmMap.get(ci.Firm_Name__c).size() > 0){
							for(Firm_Dates__c fd: AccountFirmMap.get(ci.Firm_Name__c)){
								if(fd.Name__c == str){
									Firm_s_Child__c fc = new Firm_s_Child__c();
									fc.Firm_Date__c = fd.Id;
									fc.Consumer_Inquiries_Reference__c = ci.Id;
									fc.Box_CI_Case_Name__c = 'CI'+ci.Name;
									fc.Reference_ID__c = ci.Id;
									fc.Type__c = 'Consumer Inquiry';
				                    fcCIListtoInsert.add(fc);
								}
							}
						}
                	}
				}
            }
		}
	}

	if(!fcCIListtoInsert.isEmpty()){
		try{
            insert fcCIListtoInsert;
        }catch(exception e){
            system.debug('***** CI error (Trigger) *****');
            system.debug('The error is'+e.getMessage());
            system.debug('The error Line Number is'+e.getLineNumber());
        }
	}

}