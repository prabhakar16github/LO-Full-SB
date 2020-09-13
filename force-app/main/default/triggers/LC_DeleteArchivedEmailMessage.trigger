/*
############################################################################################################
# Project Name..........: LO - Data Stroage Email Archival 
# File..................: trigger : "deleteArchivedEmailMessage"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 15-May-2015
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 15-May-2015
# Description...........: It will delete all Email Message records which would be processed under 
#                         Archive Email Message/"Processed_Archived_Case_Email_Message__c" Table 
# Test Coverage Covered by  : Test_LC_CreateBOXFoldersNew Class
#############################################################################################################
*/ 

trigger LC_DeleteArchivedEmailMessage on Processed_Archived_Case_Email_Message__c (after insert){//, before insert
    
    set<Id> archivedEMessageID = new set<Id>(); 
    for(Processed_Archived_Case_Email_Message__c pEM : trigger.new){
        if(pEM.Email_Message_Reference_Id__c!= Null && pEM.Email_Message_Reference_Id__c!= '')
            archivedEMessageID.add(ID.ValueOf(pEM.Email_Message_Reference_Id__c));
    }
    
    if(archivedEMessageID != Null && archivedEMessageID.size() > 0){
        List<EmailMessage> emailMsg4Deletion = new List<EmailMessage>();        
        emailMsg4Deletion = [Select id from EmailMessage where Id IN:archivedEMessageID];       
        If(!emailMsg4Deletion.isEmpty()){
           System.debug('Sunny Kumar------->>>>'+emailMsg4Deletion.size());
           delete emailMsg4Deletion;  
        }
            
              
        }
 }