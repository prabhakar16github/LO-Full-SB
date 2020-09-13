/*
##########################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: Class : "LC_SendAttachmentsWSDL" Type : WSDL
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 29-Sep-2014
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 12-Dev-2014
# Description...........: This class provides the details for CastIron tool like Attachment Detail and the actual path for box where it 
#                         has to be resided.
# BOX Sequence..........: 01 Cast Iron Level
###############################################################################################################################################
*/ 
global with sharing class LC_SendAttachmentsWSDL {
    
    static AttachmentDetail AD;
    
    static list<AttachmentDetail> ATDetailList;
    static list<Attachment> AttachmentList;
    static list<Firm_s_Child__c> BoxFolderList;
    
    static map<Id,Firm_s_Child__c> BoxFolderMap;
        
    static set<Id> CIParentIDSet;
    
    public LC_SendAttachmentsWSDL(){
         
    }
    
    public static pageREference Build(string type){
        
        AD = new AttachmentDetail();
        ATDetailList = new list<AttachmentDetail>();
        AttachmentList = new list<Attachment>();
        BoxFolderList = new list<Firm_s_Child__c>();
        BoxFolderMap = new map<Id, Firm_s_Child__c>();
        CIParentIDSet = new set<Id>();
        
        set<Id> refIds = new set<Id>();
        list<Firm_s_Child__c> boxFolderIdMapRecords = new list<Firm_s_Child__c>();
        boxFolderIdMapRecords = [select Reference_ID__c from Firm_s_Child__c where Box_Folder_ID__c != null and Type__c = 'Consumer Inquiry' and Reference_ID__c != null];
        if(!boxFolderIdMapRecords.isEmpty()){
            for(Firm_s_Child__c rec: boxFolderIdMapRecords)
                refIds.add(rec.Reference_ID__c);
        }
        
        if(!refIds.isEmpty()){
            if(type == 'Historical'){
                AttachmentList = [Select a.Id, a.Name, a.ContentType, a.CreatedDate, a.ParentID, a.Body from Attachment a where ParentID IN: refIds limit 10];
            }else if(type == 'DaytoDay'){
                AttachmentList = [Select a.Id, a.Name, a.ContentType, a.CreatedDate, a.ParentID, a.Body from Attachment a where ParentID IN: refIds limit 10];
            }
        }
        if(AttachmentList != Null && AttachmentList.size() > 0){
            for(Attachment atc : AttachmentList){
                Id str = atc.ParentID;
                if(str.getSObjectType().getDescribe().getName() == 'Consumer_Inquiries__c'){
                    CIParentIDSet.add(atc.parentID);
                }
            }
            
            if(CIParentIDSet != Null && CIParentIDSet.size() > 0){
                
                BoxFolderList = [Select Id, Name, Box_CI_Case_Name__c, Box_Folder_ID__c, Box_Parent_Folder_ID__c, Consumer_Inquiries_Reference__c, 
                                    Firm_Date__c, Reference_ID__c, Type__c, Consumer_Inquiries_Reference__r.CreatedDate,
                                    Consumer_Inquiries_Reference__r.name, Parent_Folder_Name_Firm__c, Parent_Folder_Name_Firm_Date__c
                                    from Firm_s_Child__c Where Reference_ID__c =: CIParentIDSet];
                                                                                    
                if(BoxFolderList != Null && BoxFolderList.size() > 0){
                    for(Firm_s_Child__c bfimp : BoxFolderList){
                        BoxFolderMap.put(bfimp.Reference_ID__c,bfimp);
                    }   
                }                   
            }
        }
        return null;
    }
        
    static webservice list<AttachmentDetail> SendAttachments(){
        Build('DaytoDay');
        if(AttachmentList != Null && AttachmentList.size() > 0){
            string str;
            for(Attachment att : AttachmentList){
                if(BoxFolderMap != Null && BoxFolderMap.size() > 0 && BoxFolderMap.get(att.parentId) != Null && 
                    BoxFolderMap.get(att.parentId).Box_Parent_Folder_ID__c != Null && BoxFolderMap.get(att.parentId).Box_Parent_Folder_ID__c != ''){
                    
                    system.debug('Value existence: '+BoxFolderMap.containsKey(att.parentId));
                    system.debug('Attachment Parent Id: '+att.parentId);
                    system.debug('BoxFolderMap: '+BoxFolderMap.get(att.parentId));
                    system.debug('Created Date: '+BoxFolderMap.get(att.parentId).Consumer_Inquiries_Reference__r.CreatedDate);
                    
                    str = BoxFolderMap.get(att.parentId).Consumer_Inquiries_Reference__r.CreatedDate.year() + '-';
                    if(BoxFolderMap.get(att.parentId).Consumer_Inquiries_Reference__r.CreatedDate.month() < 10)
                        str += '0'+BoxFolderMap.get(att.parentId).Consumer_Inquiries_Reference__r.CreatedDate.month();
                    else
                        str += BoxFolderMap.get(att.parentId).Consumer_Inquiries_Reference__r.CreatedDate.month();
                    
                    AD = new AttachmentDetail();
                    AD.Attachment_Body = att.body;
                    AD.AttachmentID = att.id;
                    AD.AttachmentName = att.name; 
                    AD.ContentType = att.contentType;
                    datetime dt = att.CreatedDate; 
                    AD.CreatedDateMonth = dt.Year() + '-' + dt.Month(); 
                    AD.ParentID = att.parentID;
                    AD.Type = 'Consumer Inquiry';
                    AD.ParentFOlderID = BoxFolderMap.get(att.parentId).Box_Parent_Folder_ID__c;
                    AD.FolderID = BoxFolderMap.get(att.parentId).Box_Folder_ID__c;
                    
                    /*Need to create Custom Settings For Parent Production Box Folder Name   */
                   BoxDetails__c myBF = BoxDetails__c.getInstance('Parent Folder Label');
                   String BoxParentRootFolder = myBF.BOX_Parent_Folder__c;

                   System.debug('Sunny------>>>'+BoxParentRootFolder);
                    
                    AD.pathtoFolder = BoxParentRootFolder+'/'+BoxFolderMap.get(att.parentId).Parent_Folder_Name_Firm__c+'/'+ 
                                        BoxFolderMap.get(att.parentId).Parent_Folder_Name_Firm_Date__c +'/CI'+
                                        BoxFolderMap.get(att.parentId).Consumer_Inquiries_Reference__r.name;
                    system.debug('The Path to folder is'+AD.pathtoFolder);
                    ATDetailList.add(AD);
                    /* Path to be constructed for CastIron FTP location */
                        //ftp://ftp.box.com/LC-Salesforce BOX Sandbox/LC-Sunny/2014-11/CI%20%2300003478/
                    /* Path to be constructed for CastIron FTP location */
                }
            }
        }
        if(ATDetailList != Null && ATDetailList.size() > 0){
            return ATDetailList;
        }else{
            return null;
        }
        return null;
    }   
    
    global class AttachmentDetail{
        webservice string AttachmentID;
        webservice string ParentID;
        webservice string AttachmentName;
        webservice blob Attachment_Body;
        webservice string ContentType;
        webservice string Type;
        webservice string ParentFOlderID;
        webservice string FolderID;
        webservice string CreatedDateMonth;
        webservice string pathtoFolder;
    }
    
    
}