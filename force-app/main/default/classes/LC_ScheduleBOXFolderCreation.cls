/*
##########################################################################################################################################
# Project Name..........: CI Box Related Work 
# File..................: Class : "LC_ScheduleBOXFolderCreation"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 02-Oct-2014
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 19-Jan-2015
# Description...........: On Going Process -->>> It will create All Folders for firms,Firm Dates,CI,case Count and Email message Count folder

It will depends on helper class to get the count i.e. LC_CreateBOXFoldersNew

###############################################################################################################################################
*/ 

global class LC_ScheduleBOXFolderCreation implements schedulable{
    
    global void execute(schedulableContext sc){
        
        Integer firmCount = 0;  //Seq: 01
        Integer firmDatesCount = 0;//Seq: 02
        Integer ciCount = 0;//Seq: 03
        Integer caseCount = 0;//Seq: 04
        Integer caseFirmDatesCount = 0;//Seq: 05
         // It will jump to seq:01 to create all Firms
        firmCount = LC_CreateBOXFoldersNew.createFirmBoxFolder();
        // If all firms folder has been created thn jump to seq:02
        if(firmCount == 0)
            firmDatesCount = LC_CreateBOXFoldersNew.createFirmDatesBoxFolder();
        // If all firms,Firm Dates folder has been created thn jump to seq:03
        if(firmCount == 0 && firmDatesCount == 0)
            ciCount = LC_CreateBOXFoldersNew.createCIBoxFolder();
       
        /* Status: On Hold
        // If all firms,Firm Dates,CI Count folder has been created thn jump to seq:04
        //Seq: 03  For Case Folder Box Folder creation 
        if(firmCount == 0 && firmDatesCount == 0 && ciCount == 0)
            caseCount = LC_CreateBOXFoldersNew.createCaseBoxFolder();
              // If all firms,Firm Dates,CI,case Count and now email message Count folder has been created thn jump to seq:05
        //Seq: 04 For Email Messages Box Folder creation
        if(firmCount == 0 && firmDatesCount == 0 && ciCount == 0 && caseCount == 0)
            caseFirmDatesCount = LC_CreateBOXFoldersNew.createCaseEmailMessagesBoxFolder();
        */    
        
    }
    
}