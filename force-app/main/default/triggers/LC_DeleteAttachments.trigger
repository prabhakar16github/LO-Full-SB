/*
##########################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: trigger : "LC_DeleteAttachments"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 29-Sep-2014
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 12-Dev-2014
# Description...........: It will delete all Attachments from CI once uploaded on box based on "Box_Mapping_Table__c" Table 
                          where records will b e created  by Cast Iron
#                         which will be updated by Cast Iron 
# BOX Sequence..........: 10 Consumer Inquiry Level
###############################################################################################################################################
*/  

trigger LC_DeleteAttachments on Box_Mapping_Table__c (after insert, after update) {
    
    set<Id> AttachmentIDs = new set<Id>();
    
    for(Box_Mapping_Table__c bmt : trigger.new){
        if(bmt.Attachment_ID__c != Null && bmt.Attachment_ID__c != '' && bmt.Box_Upload__c == true){
            AttachmentIDs.add(bmt.Attachment_ID__c);
        }
    }
    
    if(AttachmentIDs != Null && AttachmentIDs.size() > 0){
        list<Attachment> AttachmentList = new list<Attachment>();
        AttachmentList = [select Id from Attachment Where Id IN: AttachmentIDs];
        if(AttachmentList != Null && AttachmentList.size() > 0){
            delete AttachmentList;
        }
    }
}