trigger UpdateBoxFolderID on Box_Mapping_Table__c (before insert, before update) {
    public set<Id> AttachmentIDSet = new set<Id>(); 
    public map<Id,Attachment> AttMap;
    public set<Id> emailMessageIDSet = new set<Id>(); 
    public map<Id,EmailMessage> emMap;
    
    for(Box_Mapping_Table__c bmt : trigger.new){
        if(bmt.Attachment_ID__c != Null && bmt.Attachment_ID__c != '' && bmt.type__c != null && 
            bmt.type__c.trim() != '' && bmt.type__c == 'Consumer Inquiry'){
            AttachmentIDSet.add(bmt.Attachment_ID__c);
        }else if(bmt.Parent_ID__c != Null && bmt.Parent_ID__c != '' && bmt.type__c != null && 
            bmt.type__c.trim() != '' && bmt.type__c == 'Case-EmailMessage'){
            emailMessageIDSet.add(bmt.Parent_ID__c);
        }
    }
    
    if(AttachmentIDSet != Null && AttachmentIDSet.size() > 0){
        AttMap = new map<Id,Attachment>([Select Id, Name, ParentID from Attachment Where Id IN: AttachmentIDSet]);
    }
    if(emailMessageIDSet != Null && emailMessageIDSet.size() > 0){
        emMap = new map<Id,EmailMessage>([Select Id, ParentID from EmailMessage Where Id IN: emailMessageIDSet]);
    }
    if((AttMap != Null && AttMap.size() > 0) || (emMap != Null && emMap .size() > 0)){
        for(Box_Mapping_Table__c bmc : trigger.new){
            if(bmc.Attachment_ID__c != Null && bmc.Attachment_ID__c != '' && AttMap != null && AttMap.get(bmc.Attachment_ID__c) != Null
                  && bmc.type__c != null && bmc.type__c.trim() != '' && bmc.type__c == 'Consumer Inquiry'){
                bmc.Consumer_Inquiries__c = AttMap.get(bmc.Attachment_ID__c).parentId;
            }else if(bmc.Parent_ID__c != Null && bmc.Parent_ID__c != '' && emMap != null && emMap.get(bmc.Parent_ID__c) != Null
                  && bmc.type__c != null && bmc.type__c.trim() != '' && bmc.type__c == 'Case-EmailMessage'){
                bmc.Case__c = emMap.get(bmc.Parent_ID__c).parentId;
            }
        }
    }
    
}