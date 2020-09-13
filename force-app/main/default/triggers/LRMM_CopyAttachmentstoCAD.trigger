trigger LRMM_CopyAttachmentstoCAD on Attachment (before insert) {
    
     Set<Id> salesOrderIds = new Set<Id>();
     Set<Id> salesOrderIds1 = new Set<Id>();
     Set<Id> salesOrderIds2 = new Set<Id>();
     Set<Id> salesOrderIds3 = new Set<Id>();
     Set<Id> salesOrderIds4 = new Set<Id>();
     Set<Id> salesOrderIds5 = new Set<Id>();
     Set<Id> salesOrderIds6 = new Set<Id>();

     Map<String,Schema.RecordTypeInfo> rtMap1 = Schema.SObjectType.Business_Record_Affidavit__c.getRecordTypeInfosByName();
     Id rtLeadID1 =  rtMap1.get('BRA: Record Type').getRecordTypeId(); 
     Map<String,Schema.RecordTypeInfo> rtMap2 = Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName();
     Id rtLeadIDLive =  rtMap2.get('Live Witness Request Step I').getRecordTypeId();    
     Map<String,Schema.RecordTypeInfo> rtMap3 = Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName();
     Id rtLeadIDLive1 =  rtMap3.get('Live Witness Request Step II').getRecordTypeId();       
     Map<String,Schema.RecordTypeInfo> rtMap4 = Schema.SObjectType.Trial_Witness_Request__c.getRecordTypeInfosByName();
     Id rtLeadIDLive2 =  rtMap4.get('Live Witness Request Step III').getRecordTypeId(); 
         
    for(Attachment file : Trigger.new) {

        if(file.ParentId.getSObjectType() == Appeal__c.getSObjectType()) {
            salesOrderIds.add(file.ParentId);
        }
        system.debug('file.ParentId.getSObjectType() -->'+file.ParentId.getSObjectType());
        if(file.ParentId.getSObjectType() == Business_Record_Affidavit__c.getSObjectType()) {
            salesOrderIds1.add(file.ParentId);
        }
        if(file.ParentId.getSObjectType() == Counterclaim__c.getSObjectType()) {
            salesOrderIds2.add(file.ParentId);
        } 
        if(file.ParentId.getSObjectType() == Discovery__c.getSObjectType()) {
            salesOrderIds3.add(file.ParentId);
        } 
        if(file.ParentId.getSObjectType() == Trial_Witness_Request__c.getSObjectType()) {
            salesOrderIds4.add(file.ParentId);
        } 
        if(file.ParentId.getSObjectType() == Purchase_and_Sales_Agreement__c.getSObjectType()) {
            salesOrderIds5.add(file.ParentId);
        } 
        if(file.ParentId.getSObjectType() == Settlement_Approval__c.getSObjectType()) {
            salesOrderIds6.add(file.ParentId);
        }                                                
        system.debug('salesOrderIds-->'+salesOrderIds);
    }

    if(!salesOrderIds.isEmpty()) {

        Map<Id,Appeal__c> serviceOrderMap = new Map<Id,Appeal__c>([Select AP_Consumer_Account_Record__c From Appeal__c Where Id IN :salesOrderIds]);        

        List<Attachment> attachments = new List<Attachment>();

        for(Attachment file : Trigger.new) {
            Attachment newFile = file.clone();
            newFile.ParentId = serviceOrderMap.get(file.ParentId).AP_Consumer_Account_Record__c;
            system.debug('newfile-->'+newfile);
            attachments.add(newFile);
 
            insert attachments;
        }
    } 
    if(!salesOrderIds1.isEmpty()) {

        Map<Id,Business_Record_Affidavit__c> serviceOrderMap = new Map<Id,Business_Record_Affidavit__c>([Select BRA_Consumer_Account_Details_Record__c,RecordTypeId From Business_Record_Affidavit__c Where Id IN :salesOrderIds1]);        

        List<Attachment> attachments = new List<Attachment>();

        for(Attachment file : Trigger.new) {
            if(serviceOrderMap.get(file.ParentId).RecordTypeId == rtLeadID1)
            {
                Attachment newFile = file.clone();
                newFile.ParentId = serviceOrderMap.get(file.ParentId).BRA_Consumer_Account_Details_Record__c;
                attachments.add(newFile);
                insert attachments;
            }
        }
    }      
    if(!salesOrderIds2.isEmpty()) {

        Map<Id,Counterclaim__c> serviceOrderMap = new Map<Id,Counterclaim__c>([Select CC_Consumer_Account_Detail_Name__c From Counterclaim__c Where Id IN :salesOrderIds2]);        

        List<Attachment> attachments = new List<Attachment>();

        for(Attachment file : Trigger.new) {
            Attachment newFile = file.clone();
            newFile.ParentId = serviceOrderMap.get(file.ParentId).CC_Consumer_Account_Detail_Name__c;
            attachments.add(newFile);
            insert attachments;
        }
    }
    if(!salesOrderIds3.isEmpty()) {

        Map<Id,Discovery__c> serviceOrderMap = new Map<Id,Discovery__c>([Select DY_Consumer_Account_Details__c From Discovery__c Where Id IN :salesOrderIds3]);        

        List<Attachment> attachments = new List<Attachment>();

        for(Attachment file : Trigger.new) {
            Attachment newFile = file.clone();
            newFile.ParentId = serviceOrderMap.get(file.ParentId).DY_Consumer_Account_Details__c;
            attachments.add(newFile);
            insert attachments;
        }
    }
    if(!salesOrderIds4.isEmpty()) {

        Map<Id,Trial_Witness_Request__c> serviceOrderMap = new Map<Id,Trial_Witness_Request__c>([Select TW_Consumer_Account_Records__c,RecordTypeId From Trial_Witness_Request__c Where Id IN :salesOrderIds4]);        

        List<Attachment> attachments = new List<Attachment>();

        for(Attachment file : Trigger.new) {
            if(serviceOrderMap.get(file.ParentId).RecordTypeId == rtLeadIDLive || serviceOrderMap.get(file.ParentId).RecordTypeId == rtLeadIDLive1 
               || serviceOrderMap.get(file.ParentId).RecordTypeId == rtLeadIDLive2)
               {
                Attachment newFile = file.clone();
                newFile.ParentId = serviceOrderMap.get(file.ParentId).TW_Consumer_Account_Records__c;
                attachments.add(newFile);
                insert attachments;
               }
        }
    }
    if(!salesOrderIds5.isEmpty()) {

        Map<Id,Purchase_and_Sales_Agreement__c> serviceOrderMap = new Map<Id,Purchase_and_Sales_Agreement__c>([Select PSA_Consumer_Account_Detail_Name__c From Purchase_and_Sales_Agreement__c Where Id IN :salesOrderIds5]);        

        List<Attachment> attachments = new List<Attachment>();

        for(Attachment file : Trigger.new) {
            Attachment newFile = file.clone();
            newFile.ParentId = serviceOrderMap.get(file.ParentId).PSA_Consumer_Account_Detail_Name__c;
            attachments.add(newFile);
            insert attachments;
        }
    }
    if(!salesOrderIds6.isEmpty()) {

        Map<Id,Settlement_Approval__c> serviceOrderMap = new Map<Id,Settlement_Approval__c>([Select SA_Consumer_Account_Details__c From Settlement_Approval__c Where Id IN :salesOrderIds6]);        

        List<Attachment> attachments = new List<Attachment>();

        for(Attachment file : Trigger.new) {
            Attachment newFile = file.clone();
            newFile.ParentId = serviceOrderMap.get(file.ParentId).SA_Consumer_Account_Details__c;
            attachments.add(newFile);
            insert attachments;
        }
    }                     
}