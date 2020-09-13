trigger FRB_updateStatusTrigger on Process_Adherence_Monitoring__c (before update,before insert) {

	//Moved this functionality to pamTriggerHelperClass 
	//@Deprecated on 14/8/2018
	/*
	
    //FRB Record Assignment
    PAMTriggerHelper.RecordAssignmentInit(Trigger.new);
    
    //This is to update Status and account standing field
    PAMTriggerHelper.UpdateAccountStanding(Trigger.new);
    
    // This is to Update Owner of PAM records
    PAMTriggerHelper.UpdatePAMOwnerRecords(Trigger.new);
    
    // This is to Update Exceptions of FRB record
    PAMTriggerHelper.UpdateFRBExceptions(Trigger.new, Trigger.oldMap);
    
    */
}