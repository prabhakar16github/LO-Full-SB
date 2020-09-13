/*
##########################################################################################################################################
# Project Name..........: CI Box Related Work 
# File..................: Trigger : "LC_CreateBOXFoldersNew"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 02-Oct-2014
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 19-Jan-2015
# Description...........: Helper Class for "LC_ScheduleBOXFolderCreation"--->>>It will create Folders for firms,Firm Dates,CI,case Count and Email message 
based on further classes i.e. LC_CreateFirmonBOX,LC_CreateDateFolderunderFirm,
CI-->LC_Box_Utility.createFolder3, Cases-->LC_Box_Utility.createFolder3,Email Msg-->LC_CreateDateFolderunderCaseFirm.createFolder
Needed
###############################################################################################################################################
*/

public class LC_CreateBOXFoldersNew {  

    public static Integer createFirmBoxFolder(){
        list<Box_Folder_ID_Map__c> FolderMaps = new list<Box_Folder_ID_Map__c>();
        // capture all folder id = null account type from all records
        FolderMaps = [Select Folder_ID__c, Reference_ID__c, Type__c, Firm_ID__c, CreatedDate
                        from Box_Folder_ID_Map__c Where Type__c = 'Account' and (Folder_Id__c = Null or Folder_Id__c = '') limit 40];
        
        if(!FolderMaps.isEmpty()){
            for(integer i=0;i<FolderMaps.size();i++){
                LC_CreateFirmonBOX.createFolder(FolderMaps[i].ID, FolderMaps[i].Firm_ID__c); // calling Utility class i.e. LC_CreateFirmonBOX
            }
        }
        
        return FolderMaps.size();
    }
    
    public static Integer createFirmDatesBoxFolder(){
        list<Firm_Dates__c> DatesList = new list<Firm_Dates__c>();
        
        DatesList = [Select Id, Name, Folder_ID__c, Name__c, Parent_Folder_ID__c, Box_Folder_ID_Map__c, Box_Folder_ID_Map__r.Folder_ID__c 
                     from Firm_Dates__c Where Box_Folder_ID_Map__r.Folder_ID__c != Null 
                     and Box_Folder_ID_Map__r.Folder_ID__c != '' 
                     and (Folder_ID__c = Null or Folder_ID__c = '') 
                     and Box_Folder_ID_Map__r.Type__c = 'Account' limit 40]; // Retrives Firm Dates which won't have BOX Folder ID
                    
        if(!DatesList.isEmpty()){//// < Limit 40 and call Future class method named as "LC_CreateDateFolderunderFirm.createFolder"
            for(integer i=0;i<DatesList.size();i++){
                LC_CreateDateFolderunderFirm.createFolder(DatesList[i].Id, DatesList[i].Name__c, DatesList[i].Box_Folder_ID_Map__r.Folder_ID__c);
            }
        }
        
        return DatesList.size();
    }
    
    
    public static Integer createCIBoxFolder(){
        list<Firm_s_Child__c> FolderMaps = new list<Firm_s_Child__c>();   
        FolderMaps = [Select Id, Box_Folder_ID__c, Reference_ID__c, Type__c, Box_CI_Case_Name__c, CreatedDate, Box_Parent_Folder_ID__c
                        from Firm_s_Child__c Where Type__c = 'Consumer Inquiry' and (Box_Folder_ID__c = Null or Box_Folder_ID__c = '') 
                        and Box_Parent_Folder_ID__c != Null and Box_Parent_Folder_ID__c != '' limit 1]; // limit 40
                                
        if(!FolderMaps.isEmpty()){
            for(integer i=0;i<FolderMaps.size();i++){
                LC_Box_Utility.createFolder3(FolderMaps[i].Box_Parent_Folder_ID__c,FolderMaps[i].Id,FolderMaps[i].Box_CI_Case_Name__c);
            }
        }
        return FolderMaps.size();
    }
    
   /* Will be used later if needed for cases 
    public static Integer createCaseBoxFolder(){
        list<Firm_s_Child__c> FolderMaps = new list<Firm_s_Child__c>();   
        FolderMaps = [Select Id, Box_Folder_ID__c, Reference_ID__c, Type__c, Box_CI_Case_Name__c, CreatedDate, Box_Parent_Folder_ID__c
                        from Firm_s_Child__c Where Type__c = 'Case' and (Box_Folder_ID__c = Null or Box_Folder_ID__c = '') 
                        and Box_Parent_Folder_ID__c != Null and Box_Parent_Folder_ID__c != '' limit 40];
                                
        if(!FolderMaps.isEmpty()){
            for(integer i=0;i<FolderMaps.size();i++){
                LC_Box_Utility.createFolder3(FolderMaps[i].Box_Parent_Folder_ID__c,FolderMaps[i].Id,FolderMaps[i].Box_CI_Case_Name__c);
            }
        }
        return FolderMaps.size();
    }
    */
/*
    public static Integer createCaseEmailMessagesBoxFolder(){
        list<Case_Email_Message__c> caseEmailMessageList = new list<Case_Email_Message__c>();
        
        caseEmailMessageList = [Select Id, Name, Folder_ID__c, Name__c, Box_Parent_Folder_ID__c 
                     from Case_Email_Message__c Where Box_Parent_Folder_ID__c != Null 
                     and Box_Parent_Folder_ID__c != '' 
                     and (Folder_ID__c = Null or Folder_ID__c = '') 
                     and Firm_s_Child__r.Type__c = 'Case' limit 40]; // Retrives Case EmailMessage which don't have BOX Folder ID
                    
        if(!caseEmailMessageList.isEmpty()){//// < Limit 40 and call Future class method named as "LC_CreateDateFolderunderFirm.createFolder"
            for(integer i=0;i<caseEmailMessageList.size();i++){
                LC_CreateDateFolderunderCaseFirm.createFolder(caseEmailMessageList[i].Id, caseEmailMessageList[i].Name__c, caseEmailMessageList[i].Box_Parent_Folder_ID__c);
            }
        }
        
        return caseEmailMessageList.size();
    } */
}