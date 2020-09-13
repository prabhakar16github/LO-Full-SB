/*
##########################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: Class : "SendEmailReminderBatchCtrl"
# Version...............: 1.0
# Created by............: Sunny Kumar
# Created Date..........: 27-May-2014
# Last Modified by......: Sunny Kumar
# Last Modified Date....: 12-May-2014
# Description...........: It will Control the batch job and schedule it accordingly....
###########################################################################################################################################
*/



public class SendEmailReminderBatchCtrl {

	public Consumer_Inquirie_History__c objConsumer{get;set;}
	
	public SendEmailReminderBatchCtrl(){
	    objConsumer = new Consumer_Inquirie_History__c();
	}
	
	public pagereference start(){
		
		Integer currentMonth = System.Today().month();
		Integer currentYear = System.Today().Year();
	    
	    system.debug('objConsumer------------>'+objConsumer);
	    
	    system.debug('currentMonth---------->'+currentMonth);
	    system.debug('currentYear---------->'+currentYear);
	    
	    if( (Integer.valueOf(objConsumer.Month__c) > currentMonth && Integer.valueOf(objConsumer.Year__c) >= currentYear) 
	    	|| (Integer.valueOf(objConsumer.Month__c) < currentMonth && Integer.valueOf(objConsumer.Year__c) > currentYear) ){
	    		
        	system.debug('Entered in the error message');
        	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Future Month Not Allowed!'));
        	return null; 
	    }
	    
	   Integer iMonth = currentMonth;
	   
	   if(objConsumer.Is_Business_Day_Reminder__c != null && objConsumer.Is_Business_Day_Reminder__c){
	     iMonth = currentMonth - 1;
	   }
	   
	   if(objConsumer.Is_Email_Send__c && (Integer.valueOf(objConsumer.Month__c) == iMonth && Integer.valueOf(objConsumer.Year__c) == currentYear )){
	    	objConsumer.Is_Email_Send__c = true;
	   }else{
	      	objConsumer.Is_Email_Send__c = false;
	   }
	   
	   system.debug('objConsumer.Year__c--------->'+objConsumer.Year__c);
	   system.debug('objConsumer.Month__c--------->'+objConsumer.Month__c);
	   system.debug('objConsumer.Is_Email_Send__c--------->'+objConsumer.Is_Email_Send__c);
	   system.debug('objConsumer.Is_Monthly_Reminder__c--------->'+objConsumer.Is_Monthly_Reminder__c);
	   system.debug('objConsumer.Is_Business_Day_Reminder__c--------->'+objConsumer.Is_Business_Day_Reminder__c);
	   
	    
	   EmailReminderBatch obj = new EmailReminderBatch(objConsumer.Year__c, objConsumer.Month__c, objConsumer.Is_Email_Send__c,
	                                                  objConsumer.Is_Monthly_Reminder__c, objConsumer.Is_Business_Day_Reminder__c);
	  
	   if(!test.isrunningTest()){
	   		system.debug('obj------------->'+obj);
	   		Database.executebatch(obj,1);
	   }
	  
		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Successfully Submitted'));
		return null;
	}

}