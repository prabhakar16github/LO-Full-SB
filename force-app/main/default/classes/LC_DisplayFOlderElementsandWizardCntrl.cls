/*
##########################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: class : "LC_DisplayFOlderElementsandWizardCntrl"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 29-Sep-2014
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 12-Dev-2014
# Description...........: This class is used to decide which page should be displayed in the CI Detail Page.
#							Portal User ==> display files and existing attachments for that CI 
#							System Administrator ==> displays Box Wizard
# BOX Sequence..........: 01 "Controller Class for LC_DisplayCIFolderElementsandWizard"
###############################################################################################################################################
*/
public with sharing class LC_DisplayFOlderElementsandWizardCntrl {
	
	public boolean displayIFrame{get;set;}
	public boolean displayPortal{get;set;}
	
	public LC_DisplayFOlderElementsandWizardCntrl(apexpages.standardController sc){
		if(userinfo.getUserType() == 'Standard'){
			displayPortal = false;
		}else{
			displayPortal = true;
		}
		string ProfileName = [Select Id, Name from Profile where Id =: userinfo.getProfileId()].Name;
		if(ProfileName.contains('System Administrator')){
			displayIFrame = true;
		}else{
			displayIFrame = false;
		}
	}
}