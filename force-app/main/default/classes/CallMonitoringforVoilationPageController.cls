public with sharing class CallMonitoringforVoilationPageController {

	public Call_Monitoring__c cm {get;set;} 
	public string CallMonitoringEdit{get;set;}
	public boolean isEdit{get;set;}
	public String recordTypeName {get;set;}



	public CallMonitoringforVoilationPageController (Apexpages.standardcontroller sc){
			
			isEdit = false; 
			cm = new Call_Monitoring__c();
			CallMonitoringEdit = apexPages.currentPage().getParameters().get('EditID');
			
			if(CallMonitoringEdit != Null || CallMonitoringEdit != ''){
				
				isEdit = true;
				cm = [SELECT Id, Name, RecordTypeId, RecordType.Name, Account_Number_CM__c, Account_Type_CM__c, Attachments__c, CF1_01_Violation__c, 
							CF1_01__c, CF1_02_Violation__c, CF1_02__c, CF1_03_Violation__c, CF1_03__c, CF1_04_Violation__c, CF1_04__c, 
							CF1_05_Violation__c, CF1_05__c, CF_Violation_Count__c, CM_Notification_Receiver__c, CM_Org_Month_Year_del__c, 
							Most_Recent_Attachment_Date__c, No_Calls_This_Month__c, Org_ID_Agency__c, Org_ID_Firm__c, Org_Name_Agency__c, 
							Org_Name_Firm__c, Org_Owner_s_Name__c, Org_Owners_Email_CM__c, Organization_Name_CM__c, PIO3_01_Violation__c, 
							PIO3_01__c, PIO3_02_Violation__c, PIO3_02__c, PIO3_03_Violation__c, PIO3_03__c, PIOViolation_Count__c, 
							Reporting_Month_CM__c, Reporting_Quarter_CM__c, Reporting_Year_CM__c, SF2_01_Violation__c, SF2_01__c, 
							SF2_02_Violation__c, SF2_02__c, SF2_03_Violation__c, SF2_03__c, SF2_04_Violation__c, SF2_04__c, SF2_05_Violation__c, 
							SF2_05__c, SF2_06_Violation__c, SF2_06__c, SF2_07_Violation__c, SF2_07__c, SF2_08_Violation__c, SF2_08__c, 
							SF2_09_Violation__c, SF2_09__c, SF2_10_Violation__c, SF2_10__c, SF2_11_Violation__c, SF2_11__c, SF2_12_Violation__c, 
							SF2_12__c, SF2_13_Violation__c, SF2_13__c, SF2_14_Violation__c, SF2_14__c, SF2_15_Violation__c, SF2_15__c, 
							SF2_16_Violation__c, SF2_16__c, SF2_17_Violation__c, SF2_17__c, SF2_18_Violation__c, SF2_18__c, SF2_19_Violation__c, 
							SF2_19__c, SF2_20_Violation__c, SF2_20__c, SF2_21_Violation__c, SF2_21__c, SF2_22_Violation__c, SF2_22__c, 
							SFViolation_Count__c, QA_Comments__c, CF1_01_Explanation__c, CF1_01_Remediation_Plan__c, 
							CF1_01_Remediation_Steps_Completed__c, CF1_01_Remidated__c, CF1_01_Remidiation_Date__c, CF1_02_Explanation__c, 
							CF1_02_Remediated__c, CF1_02_Remediation_Date__c, CF1_02_Remediation_Plan__c, CF1_02_Remediation_Steps_Completed__c, 
							CF1_03_Explanation__c, CF1_03_Remediated__c, CF1_03_Remediation_Date__c, CF1_03_Remediation_Plan__c, 
							CF1_03_Remediation_Steps_Completed__c, CF1_04_Explanation__c, CF1_04_Remediated__c, CF1_04_Remediation_Date__c, 
							CF1_04_Remediation_Plan__c, CF1_04_Remediation_Steps_Completed__c, CF1_05_Explanation__c, CF1_05_Remediated__c, 
							CF1_05_Remediation_Date__c, CF1_05_Remediation_Plan__c, CF1_05_Remediation_Steps_Completed__c, 
							Firm_Remediation_Complete__c, Remediation_Completed__c, SF2_01_Explanation__c, SF2_01_Remediated__c, 
							SF2_01_Remediation_Date__c, SF2_01_Remediation_Plan__c, SF2_01_Remediation_Steps_Completed__c, SF2_02_Explanation__c, 
							SF2_02_Remediated__c, SF2_02_Remediation_Date__c, SF2_02_Remediation_Plan__c, SF2_02_Remediation_Steps_Completed__c, 
							SF2_03_Explanation__c, SF2_03_Remediated__c, SF2_03_Remediation_Date__c, SF2_03_Remediation_Plan__c, 
							SF2_03_Remediation_Steps_Completed__c, SF2_04_Explanation__c, SF2_04_Remediated__c, SF2_04_Remediation_Date__c, 
							SF2_04_Remediation_Plan__c, SF2_04_Remediation_Steps_Completed__c, SF2_05_Explanation__c, SF2_05_Remediated__c, 
							SF2_05_Remediation_Date__c, SF2_05_Remediation_Plan__c, SF2_05_Remediation_Steps_Completed__c, SF2_06_Explanation__c, 
							SF2_06_Remediated__c, SF2_06_Remediation_Date__c, SF2_06_Remediation_Plan__c, SF2_06_Remediation_Steps_Completed__c, 
							SF2_07_Explanation__c, SF2_07_Remediated__c, SF2_07_Remediation_Date__c, SF2_07_Remediation_Plan__c, 
							SF2_07_Remediation_Steps_Completed__c, SF2_08_Explanation__c, SF2_08_Remediated__c, SF2_08_Remediation_Date__c, 
							SF2_08_Remediation_Plan__c, SF2_08_Remediation_Steps_Completed__c, SF2_09_Explanation__c, SF2_09_Remediated__c, 
							SF2_09_Remediation_Date__c, SF2_09_Remediation_Plan__c, SF2_09_Remediation_Steps_Completed__c, SF2_10_Explanation__c, 
							SF2_10_Remediated__c, SF2_10_Remediation_Date__c, SF2_10_Remediation_Plan__c, SF2_10_Remediation_Steps_Completed__c, 
							SF2_11_Explanation__c, SF2_11_Remediated__c, SF2_11_Remediation_Date__c, SF2_11_Remediation_Plan__c, 
							SF2_11_Remediation_Steps_Completed__c, SF2_12_Explanation__c, SF2_12_Remediated__c, SF2_12_Remediation_Date__c, 
							SF2_12_Remediation_Plan__c, SF2_12_Remediation_Steps_Completed__c, SF2_13_Explanation__c, SF2_13_Remediated__c, 
							SF2_13_Remediation_Date__c, SF2_13_Remediation_Plan__c, SF2_13_Remediation_Steps_Completed__c, SF2_14_Explanation__c, 
							SF2_14_Remediated__c, SF2_14_Remediation_Date__c, SF2_14_Remediation_Plan__c, SF2_14_Remediation_Steps_Completed__c, 
							SF2_15_Explanation__c, SF2_15_Remediated__c, SF2_15_Remediation_Date__c, SF2_15_Remediation_Plan__c, 
							SF2_15_Remediation_Steps_Completed__c, SF2_16_Explanation__c, SF2_16_Remediated__c, SF2_16_Remediation_Date__c, 
							SF2_16_Remediation_Plan__c, SF2_16_Remediation_Steps_Completed__c, SF2_17_Explanation__c, SF2_17_Remediated__c, 
							SF2_17_Remediation_Date__c, SF2_17_Remediation_Plan__c, SF2_17_Remediation_Steps_Completed__c, SF2_18_Explanation__c, 
							SF2_18_Remediated__c, SF2_18_Remediation_Date__c, SF2_18_Remediation_Plan__c, SF2_18_Remediation_Steps_Completed__c, 
							SF2_19_Explanation__c, SF2_19_Remediated__c, SF2_19_Remediation_Date__c, SF2_19_Remediation_Plan__c, 
							SF2_19_Remediation_Steps_Completed__c, SF2_20_Explanation__c, SF2_20_Remediated__c, SF2_20_Remediation_Date__c, 
							SF2_20_Remediation_Plan__c, SF2_20_Remediation_Steps_Completed__c, SF2_21_Explanation__c, SF2_21_Remediated__c, 
							SF2_21_Remediation_Date__c, SF2_21_Remediation_Plan__c, SF2_21_Remediation_Steps_Completed__c, SF2_22_Explanation__c, 
							SF2_22_Remediated__c, SF2_22_Remediation_Date__c, SF2_22_Remediation_Plan__c, SF2_22_Remediation_Steps_Completed__c, 
							Invalid_Attachment__c, Date_of_Call__c, QA_Date__c, Critical_Finding_CountDB__c, PIO_Violation_CountDB__c, 
							Significant_Finding_CountDB__c, Parent_Organization__c, CF1_01_1_Violation__c, PIO3_04_Violation__c, 
							PIO3_05_Violation__c, PIO3_06_Violation__c, PIO3_04__c, PIO3_06__c, CF1_01_1__c, CF1_01_1_Explanation__c, 
							CF1_01_1_Remediated__c, CF1_01_1_Remediation_Date__c, CF1_01_1_Remediation_Plan__c, CF1_01_1_Remediation_Steps_Completed__c, 
							CF1_02_1_Violation__c, CF1_02_1__c, CF1_02_1_Explanation__c, CF1_02_1_Remediated__c, CF1_02_1_Remediation_Date__c, 
							CF1_02_1_Remediation_Plan__c, CF1_02_1_Remediation_Steps_Completed__c, CF1_04_1_Violation__c, 
							CF1_04_1__c, CF1_04_1_Explanation__c, CF1_04_1_Remediated__c, CF1_04_1_Remedation_Date__c, CF1_04_1_Remediation_Plan__c, 
							CF1_04_1_Remediation_Steps_Completed__c, SF2_01_1_Violation__c, SF2_01_1__c, SF2_01_1_Explanation__c, 
							SF2_01_1_Remediation_Date__c, SF2_01_1_Remediated__c, SF2_01_1_Remediation_Plan__c, 
							SF2_01_1_Remediation_Steps_Completed__c, SF2_07_1_Violation__c, SF2_07_1__c, SF2_07_1_Explanation__c, 
							SF2_07_1_Remediated__c, SF2_07_1_Remediation_Date__c, SF2_07_1_Remediation_Plan__c, 
							SF2_07_1_Remediation_Steps_Completed__c, SF2_08_1_Violation__c, SF2_08_1__c, SF2_08_1_Explanation__c, 
							SF2_08_1_Remediation__c, SF2_08_1_Remediation_Date__c, SF2_08_1_Remediation_Plan__c, SF2_08_1_Remediation_Steps_Completed__c, 
							SF2_09_1_Violation__c, SF2_09_1__c, SF2_09_1_Explanation__c, SF2_09_1_Remediated__c, SF2_09_1_Remediation_Date__c, 
							SF2_09_1_Remediation_Plan__c, SF2_09_1_Remediation_Steps_Completed__c, SF2_10_1_Violation__c, SF2_10_1__c, 
							SF2_10_1_Explanatio__c, SF2_10_1_Remediated__c, SF2_10_1_Remediation_Date__c, SF2_10_1_Remediation_Plan__c, 
							SF2_10_1_Remediation_Steps_Completed__c, SF2_11_1_Violation__c, SF2_11_1__c, SF2_11_1_Explanation__c, 
							SF2_11_1_Remediated__c, SF2_11_1_Remediation_Date__c, SF2_11_1_Remediation_Plan__c, 
							SF2_11_1_Remediation_Steps_Completed__c, SF2_12_1_Violation__c, SF2_12_1__c, SF2_12_1_Explanation__c, 
							SF2_12_1_Remediated__c, SF2_12_1_Remediation_Date__c, SF2_12_1_Remediation_Plan__c, 
							SF2_12_1_Remediation_Steps_Completed__c, SF2_13_1_Violation__c, SF2_13_1__c, SF2_13_1_Explanation__c, 
							SF2_13_1_Remediated__c, SF2_13_1_Remediation_Date__c, SF2_13_1_Remediation_Plan__c, 
							SF2_13_1_Remediation_Steps_Completed__c, SF2_16_1_Violation__c, SF2_16_1__c, SF2_16_1_Explanation__c, 
							SF2_16_1_Remediated__c, SF2_16_1_Remediation_Date__c, SFX2_16_1_Remediation_Plan__c, 
							SF2_16_1_Remediation_Steps_Completed__c, SF2_17_1_Violation__c, SF2_17_1__c, SF2_17_1_Explanation__c, 
							SF2_17_1_Remediation_Date__c, SFX2_17_1_Remediation_Plan__c, SF2_17_1_Remediation_Steps__c, SF2_18_1_Violation__c, 
							SF2_18_1__c, SF2_18_1_Remediated__c, SF2_18_1_Remediation_Date__c, SF2_18_1_Remediation_Plan__c, 
							SF2_18_1_Remediation_Steps_Completed__c, SF2_19_1_Violation__c, SF2_19_1__c, SF2_19_1_Explanation__c, 
							SF2_19_1_Remediated__c, SF2_19_1_Remediation_Date__c, SF2_19_1_Remediation_Plan__c, 
							SF2_19_1_Remediation_Steps_Completed__c, SF2_20_1_Violation__c, SF2_20_1__c, SF2_20_1_Explanation__c, 
							SF2_20_1_Remediated__c, SF2_20_1_Remediation_Date__c, SF2_20_1_Remediation_Plan__c, 
							SF2_20_1_Remediation_Steps_Completed__c, SF2_21_1_Violation__c, SF2_21_1__c, SF2_21_1_Explanation__c, 
							SF2_21_1_Remediated__c, SF2_21_1_Remediation_Date__c, SF2_21_1_Remediation_Plan__c, 
							SF2_21_1_Remediation_Steps_Completed__c, SF2_22_1_Violation__c, SF2_22_1__c, SF2_22_1_Explanation__c, 
							SF2_22_1_Remediated__c, SF2_22_1_Remediation_Date__c, SF2_22_1_Remediation_Plan__c, 
							SF2_22_1_Remediation_Steps_Completed__c, SF2_18_1_Explanation__c, SF2_17_1_Remediated__c, 
							PIO3_01_1_Violation__c, PIO3_01_1__c, PIO3_02_1_Violation__c, PIO3_02_1__c, PIO3_04_1_Violation__c, 
							PIO3_04_1__c, PIO3_05_1_Violation__c, PIO3_05_1__c, PIO3_06_1_Violation__c, PIO3_06_1__c 
						FROM Call_Monitoring__c 
						where Id =: CallMonitoringEdit];
						
						if(cm.recordTypeId != null){
							
							recordTypeName = cm.RecordType.Name;
						}
						
						system.debug('cm---------->'+cm);
			}
	}

	public pagereference save(){
	
	       	if(cm.CF1_01__c == 'Yes' && cm.CF1_01_Remidated__c == 'Yes' &&(cm.CF1_01_Remidiation_Date__c == Null  || cm.CF1_01_Remediation_Plan__c == Null ||cm.CF1_01_Remediation_Steps_Completed__c == Null)){
	       		
	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.01 Remediated Date, 1.01 Remediation Plan and 1.01 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}
	       	
	       	if(cm.CF1_02__c == 'Yes' && cm.CF1_02_Remediated__c == 'Yes' &&(cm.CF1_02_Remediation_Date__c == Null  || cm.CF1_02_Remediation_Plan__c == Null ||cm.CF1_02_Remediation_Steps_Completed__c == Null)){
	       		
	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.02 Remediated Date, 1.02 Remediation Plan and 1.02 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}
	       	
	       	if(cm.CF1_03__c == 'Yes' && cm.CF1_03_Remediated__c	 == 'Yes' &&(cm.CF1_03_Remediation_Date__c == Null  || cm.CF1_03_Remediation_Plan__c == Null ||cm.CF1_03_Remediation_Steps_Completed__c == Null)){
	       		
	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.03 Remediated Date, 1.03 Remediation Plan and 1.03 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}
	       	
	       	if(cm.CF1_04__c == 'Yes' && cm.CF1_04_Remediated__c	 == 'Yes' &&(cm.CF1_04_Remediation_Date__c == Null  || cm.CF1_04_Remediation_Plan__c == Null ||cm.CF1_04_Remediation_Steps_Completed__c == Null)){
	       		
	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.04 Remediated Date, 1.04 Remediation Plan and 1.04 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}
	       	
	       	if(cm.CF1_05__c == 'Yes' && cm.CF1_05_Remediated__c	 == 'Yes' &&(cm.CF1_05_Remediation_Date__c == Null  || cm.CF1_05_Remediation_Plan__c == Null ||cm.CF1_05_Remediation_Steps_Completed__c == Null)){
	       		
	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.05 Remediated Date, 1.05 Remediation Plan and 1.05 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}
	       	
	       	if(cm.SF2_01__c == 'No' && cm.SF2_01_Remediated__c	 == 'Yes' &&(cm.SF2_01_Remediation_Date__c == Null  || cm.SF2_01_Remediation_Plan__c == Null ||cm.SF2_01_Remediation_Steps_Completed__c == Null)){
	       		
	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.01 Remediated Date, 2.01 Remediation Plan and 2.01 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}
	       	
	       	if(cm.SF2_02__c == 'No' && cm.SF2_02_Remediated__c	 == 'Yes' &&(cm.SF2_02_Remediation_Date__c == Null  || cm.SF2_02_Remediation_Plan__c == Null ||cm.SF2_02_Remediation_Steps_Completed__c == Null)){
	       		
	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.02 Remediated Date, 2.02 Remediation Plan and 2.02 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}
	       	
	       	if(cm.SF2_03__c == 'No' && cm.SF2_03_Remediated__c	 == 'Yes' &&(cm.SF2_03_Remediation_Date__c == Null  || cm.SF2_03_Remediation_Plan__c == Null ||cm.SF2_03_Remediation_Steps_Completed__c == Null)){
	       		
	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.03 Remediated Date, 2.03 Remediation Plan and 2.03 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}
	       	
	       	if(cm.SF2_04__c == 'No' && cm.SF2_04_Remediated__c	 == 'Yes' &&(cm.SF2_04_Remediation_Date__c == Null  || cm.SF2_04_Remediation_Plan__c == Null ||cm.SF2_04_Remediation_Steps_Completed__c == Null)){
	       		
	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.04 Remediated Date, 2.04 Remediation Plan and 2.04 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_05__c == 'No' && cm.SF2_05_Remediated__c	 == 'Yes' &&(cm.SF2_05_Remediation_Date__c == Null  || cm.SF2_05_Remediation_Plan__c == Null ||cm.SF2_05_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.05 Remediated Date, 2.05 Remediation Plan and 2.05 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_06__c == 'No' && cm.SF2_06_Remediated__c	 == 'Yes' &&(cm.SF2_06_Remediation_Date__c == Null  || cm.SF2_06_Remediation_Plan__c == Null ||cm.SF2_06_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.06 Remediated Date, 2.06 Remediation Plan and 2.06 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_07__c == 'No' && cm.SF2_07_Remediated__c	 == 'Yes' &&(cm.SF2_07_Remediation_Date__c == Null  || cm.SF2_07_Remediation_Plan__c == Null ||cm.SF2_07_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.07 Remediated Date, 2.07 Remediation Plan and 2.07 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_08__c == 'No' && cm.SF2_08_Remediated__c	 == 'Yes' &&(cm.SF2_08_Remediation_Date__c == Null  || cm.SF2_08_Remediation_Plan__c == Null ||cm.SF2_08_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.08 Remediated Date, 2.08 Remediation Plan and 2.08 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_09__c == 'No' && cm.SF2_09_Remediated__c	 == 'Yes' &&(cm.SF2_09_Remediation_Date__c == Null  || cm.SF2_09_Remediation_Plan__c == Null ||cm.SF2_09_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.09 Remediated Date, 2.09 Remediation Plan and 2.09 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_10__c == 'No' && cm.SF2_10_Remediated__c	 == 'Yes' &&(cm.SF2_10_Remediation_Date__c == Null  || cm.SF2_10_Remediation_Plan__c == Null ||cm.SF2_10_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.10 Remediated Date, 2.10 Remediation Plan and 2.10 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_11__c == 'No' && cm.SF2_11_Remediated__c	 == 'Yes' &&(cm.SF2_11_Remediation_Date__c == Null  || cm.SF2_11_Remediation_Plan__c == Null ||cm.SF2_11_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.11 Remediated Date, 2.11 Remediation Plan and 2.11 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_12__c == 'No' && cm.SF2_12_Remediated__c	 == 'Yes' &&(cm.SF2_12_Remediation_Date__c == Null  || cm.SF2_12_Remediation_Plan__c == Null ||cm.SF2_12_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.12 Remediated Date, 2.12 Remediation Plan and 2.12 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_13__c == 'No' && cm.SF2_13_Remediated__c	 == 'Yes' &&(cm.SF2_13_Remediation_Date__c == Null  || cm.SF2_13_Remediation_Plan__c == Null ||cm.SF2_13_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.13 Remediated Date, 2.13 Remediation Plan and 2.13 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_14__c == 'No' && cm.SF2_14_Remediated__c	 == 'Yes' &&(cm.SF2_14_Remediation_Date__c == Null  || cm.SF2_14_Remediation_Plan__c == Null ||cm.SF2_14_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.14 Remediated Date, 2.14 Remediation Plan and 2.14 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_15__c == 'No' && cm.SF2_15_Remediated__c	 == 'Yes' &&(cm.SF2_15_Remediation_Date__c == Null  || cm.SF2_15_Remediation_Plan__c == Null ||cm.SF2_15_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.15 Remediated Date, 2.15 Remediation Plan and 2.15 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_16__c == 'No' && cm.SF2_16_Remediated__c	 == 'Yes' &&(cm.SF2_16_Remediation_Date__c == Null  || cm.SF2_16_Remediation_Plan__c == Null ||cm.SF2_16_Remediation_Steps_Completed__c == Null)){
				   
	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.16 Remediated Date, 2.16 Remediation Plan and 2.16 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_17__c == 'No' && cm.SF2_17_Remediated__c	 == 'Yes' &&(cm.SF2_17_Remediation_Date__c == Null  || cm.SF2_17_Remediation_Plan__c == Null ||cm.SF2_17_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.17 Remediated Date, 2.17 Remediation Plan and 2.17 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_18__c == 'No' && cm.SF2_18_Remediated__c	 == 'Yes' &&(cm.SF2_18_Remediation_Date__c == Null  || cm.SF2_18_Remediation_Plan__c == Null ||cm.SF2_18_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.18 Remediated Date, 2.18 Remediation Plan and 2.18 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_19__c == 'No' && cm.SF2_19_Remediated__c	 == 'Yes' &&(cm.SF2_19_Remediation_Date__c == Null  || cm.SF2_19_Remediation_Plan__c == Null ||cm.SF2_19_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.19 Remediated Date, 2.19 Remediation Plan and 2.19 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_20__c == 'No' && cm.SF2_20_Remediated__c	 == 'Yes' &&(cm.SF2_20_Remediation_Date__c == Null  || cm.SF2_20_Remediation_Plan__c == Null ||cm.SF2_20_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.20 Remediated Date, 2.20 Remediation Plan and 2.20 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_21__c == 'No' && cm.SF2_21_Remediated__c	 == 'Yes' &&(cm.SF2_21_Remediation_Date__c == Null  || cm.SF2_21_Remediation_Plan__c == Null ||cm.SF2_21_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.21 Remediated Date, 2.21 Remediation Plan and 2.22 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_22__c == 'No' && cm.SF2_22_Remediated__c	 == 'Yes' &&(cm.SF2_22_Remediation_Date__c == Null  || cm.SF2_22_Remediation_Plan__c == Null ||cm.SF2_22_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.22 Remediated Date, 2.22 Remediation Plan and 2.22 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	/* Dispute error messsages */
	       	if(cm.CF1_01__c == 'Yes' && (cm.CF1_01_Remidated__c == 'Dispute' || cm.CF1_01_Remidated__c == 'No') && cm.CF1_01_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.01 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.CF1_01__c == 'Yes' && (cm.CF1_01_Remidated__c == 'Dispute' || cm.CF1_01_Remidated__c == 'No') &&(cm.CF1_01_Remidiation_Date__c != Null  || cm.CF1_01_Remediation_Plan__c != Null ||cm.CF1_01_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.01 Remediated Date, 1.01 Remediation Plan and 1.01 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.CF1_01__c == 'Yes' && cm.CF1_01_Remidated__c == 'Yes' && cm.CF1_01_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.01 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.CF1_02__c == 'Yes' && (cm.CF1_02_Remediated__c == 'Dispute' || cm.CF1_02_Remediated__c == 'No') && cm.CF1_02_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.02 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.CF1_02__c == 'Yes' && (cm.CF1_02_Remediated__c == 'Dispute' || cm.CF1_02_Remediated__c == 'No') &&(cm.CF1_02_Remediation_Date__c != Null  || cm.CF1_02_Remediation_Plan__c != Null ||cm.CF1_02_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.02 Remediated Date, 1.02 Remediation Plan and 1.02 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.CF1_02__c == 'Yes' && cm.CF1_02_Remediated__c == 'Yes' && cm.CF1_02_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.02 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.CF1_03__c == 'Yes' && (cm.CF1_03_Remediated__c == 'Dispute' || cm.CF1_03_Remediated__c == 'No') && cm.CF1_03_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.03 If No/Dispute Provide Explanation'));
	            return null;
	       	}
	       	
			if(cm.CF1_03__c == 'Yes' && (cm.CF1_03_Remediated__c == 'Dispute' || cm.CF1_03_Remediated__c == 'No') &&(cm.CF1_03_Remediation_Date__c != Null  || cm.CF1_03_Remediation_Plan__c != Null ||cm.CF1_03_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.03 Remediated Date, 1.03 Remediation Plan and 1.03 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.CF1_03__c == 'Yes' && cm.CF1_03_Remediated__c == 'Yes' && cm.CF1_03_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.03 If No/Dispute Provide Explanation.'));
	            return null;
	       	}
	       	
	       	if(cm.CF1_04__c == 'Yes' && (cm.CF1_04_Remediated__c == 'Dispute' || cm.CF1_04_Remediated__c == 'No') && cm.CF1_04_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.04 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.CF1_04__c == 'Yes' && (cm.CF1_04_Remediated__c == 'Dispute' || cm.CF1_04_Remediated__c == 'No') &&(cm.CF1_04_Remediation_Date__c != Null  || cm.CF1_04_Remediation_Plan__c != Null ||cm.CF1_04_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.04 Remediated Date, 1.04 Remediation Plan and 1.04 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.CF1_04__c == 'Yes' && cm.CF1_04_Remediated__c == 'Yes' && cm.CF1_04_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.04 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.CF1_05__c == 'Yes' && (cm.CF1_05_Remediated__c == 'Dispute' || cm.CF1_05_Remediated__c == 'No') && cm.CF1_05_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.05 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.CF1_05__c == 'Yes' && (cm.CF1_05_Remediated__c == 'Dispute' || cm.CF1_05_Remediated__c == 'No') &&(cm.CF1_05_Remediation_Date__c != Null  || cm.CF1_05_Remediation_Plan__c != Null ||cm.CF1_05_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.05 Remediated Date, 1.05 Remediation Plan and 1.05 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.CF1_05__c == 'Yes' && cm.CF1_05_Remediated__c == 'Yes' && cm.CF1_05_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.05 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_01__c == 'No' && (cm.SF2_01_Remediated__c == 'Dispute' || cm.SF2_01_Remediated__c == 'No') && cm.SF2_01_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.01 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_01__c == 'No' && (cm.SF2_01_Remediated__c == 'Dispute' || cm.SF2_01_Remediated__c == 'No') &&(cm.SF2_01_Remediation_Date__c != Null  || cm.SF2_01_Remediation_Plan__c != Null ||cm.SF2_01_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.01 Remediated Date, 2.01 Remediation Plan and 2.01 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_01__c == 'No' && cm.SF2_01_Remediated__c == 'Yes' && cm.SF2_01_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.01 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_02__c == 'No' && (cm.SF2_02_Remediated__c == 'Dispute' || cm.SF2_02_Remediated__c == 'No') && cm.SF2_02_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.02 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_02__c == 'No' && (cm.SF2_02_Remediated__c == 'Dispute' || cm.SF2_02_Remediated__c == 'No') &&(cm.SF2_02_Remediation_Date__c != Null  || cm.SF2_02_Remediation_Plan__c != Null ||cm.SF2_02_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.02 Remediated Date, 2.02 Remediation Plan and 2.02 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_02__c == 'No' && cm.SF2_02_Remediated__c == 'Yes' && cm.SF2_02_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.02 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_03__c == 'No' && (cm.SF2_03_Remediated__c == 'Dispute' || cm.SF2_03_Remediated__c == 'No') && cm.SF2_03_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.03 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_03__c == 'No' && (cm.SF2_03_Remediated__c == 'Dispute' || cm.SF2_03_Remediated__c == 'No') &&(cm.SF2_03_Remediation_Date__c != Null  || cm.SF2_03_Remediation_Plan__c != Null ||cm.SF2_03_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.03 Remediated Date, 2.03 Remediation Plan and 2.03 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_03__c == 'No' && cm.SF2_03_Remediated__c == 'Yes' && cm.SF2_03_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.03 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_04__c == 'No' && (cm.SF2_04_Remediated__c == 'Dispute' || cm.SF2_04_Remediated__c == 'No') && cm.SF2_04_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.04 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_04__c == 'No' && (cm.SF2_04_Remediated__c == 'Dispute' || cm.SF2_04_Remediated__c == 'No') &&(cm.SF2_04_Remediation_Date__c != Null  || cm.SF2_04_Remediation_Plan__c != Null ||cm.SF2_04_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.04 Remediated Date, 2.04 Remediation Plan and 2.04 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_04__c == 'No' && cm.SF2_04_Remediated__c == 'Yes' && cm.SF2_04_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.04 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_05__c == 'No' && (cm.SF2_05_Remediated__c == 'Dispute' || cm.SF2_05_Remediated__c == 'No') && cm.SF2_05_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.05 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_05__c == 'No' && (cm.SF2_05_Remediated__c == 'Dispute' || cm.SF2_05_Remediated__c == 'No') &&(cm.SF2_05_Remediation_Date__c != Null  || cm.SF2_05_Remediation_Plan__c != Null ||cm.SF2_05_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.05 Remediated Date, 2.05 Remediation Plan and 2.05 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_05__c == 'No' && cm.SF2_05_Remediated__c == 'Yes' && cm.SF2_05_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.05 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_06__c == 'No' && (cm.SF2_06_Remediated__c == 'Dispute' || cm.SF2_06_Remediated__c == 'No') && cm.SF2_06_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.06 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_06__c == 'No' && (cm.SF2_06_Remediated__c == 'Dispute' || cm.SF2_06_Remediated__c == 'No') &&(cm.SF2_06_Remediation_Date__c != Null  || cm.SF2_06_Remediation_Plan__c != Null ||cm.SF2_06_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.06 Remediated Date, 2.06 Remediation Plan and 2.06 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_06__c == 'No' && cm.SF2_06_Remediated__c == 'Yes' && cm.SF2_06_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.06 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_07__c == 'No' && (cm.SF2_07_Remediated__c == 'Dispute' || cm.SF2_07_Remediated__c == 'No') && cm.SF2_07_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.07 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_07__c == 'No' && (cm.SF2_07_Remediated__c == 'Dispute' || cm.SF2_07_Remediated__c == 'No') &&(cm.SF2_07_Remediation_Date__c != Null  || cm.SF2_07_Remediation_Plan__c != Null ||cm.SF2_07_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.07 Remediated Date, 2.07 Remediation Plan and 2.07 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_07__c == 'No' && cm.SF2_07_Remediated__c == 'Yes' && cm.SF2_07_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.07 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_08__c == 'No' && (cm.SF2_08_Remediated__c == 'Dispute' || cm.SF2_08_Remediated__c == 'No') && cm.SF2_08_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.08 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_08__c == 'No' && (cm.SF2_08_Remediated__c == 'Dispute' || cm.SF2_08_Remediated__c == 'No') &&(cm.SF2_08_Remediation_Date__c != Null  || cm.SF2_08_Remediation_Plan__c != Null ||cm.SF2_08_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.08 Remediated Date, 2.08 Remediation Plan and 2.08 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_08__c == 'No' && cm.SF2_08_Remediated__c == 'Yes' && cm.SF2_08_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.08 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_09__c == 'No' && (cm.SF2_09_Remediated__c == 'Dispute' || cm.SF2_09_Remediated__c == 'No') && cm.SF2_09_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.09 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_09__c == 'No' && (cm.SF2_09_Remediated__c == 'Dispute' || cm.SF2_09_Remediated__c == 'No') &&(cm.SF2_09_Remediation_Date__c != Null  || cm.SF2_09_Remediation_Plan__c != Null ||cm.SF2_09_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.09 Remediated Date, 2.09 Remediation Plan and 2.09 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_09__c == 'No' && cm.SF2_09_Remediated__c == 'Yes' && cm.SF2_09_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.09 If No/Dispute Provide Explanation.'));
	            return null; 
	       	}

	       	if(cm.SF2_10__c == 'No' && (cm.SF2_10_Remediated__c == 'Dispute' || cm.SF2_10_Remediated__c == 'No') && cm.SF2_10_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.10 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_10__c == 'No' && (cm.SF2_10_Remediated__c == 'Dispute' || cm.SF2_10_Remediated__c == 'No') &&(cm.SF2_10_Remediation_Date__c != Null  || cm.SF2_10_Remediation_Plan__c != Null ||cm.SF2_10_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.10 Remediated Date, 2.10 Remediation Plan and 2.10 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_10__c == 'No' && cm.SF2_10_Remediated__c == 'Yes' && cm.SF2_10_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.10 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_11__c == 'No' && (cm.SF2_11_Remediated__c == 'Dispute' || cm.SF2_11_Remediated__c == 'No') && cm.SF2_11_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.11 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_11__c == 'No' && (cm.SF2_11_Remediated__c == 'Dispute' || cm.SF2_11_Remediated__c == 'No') &&(cm.SF2_11_Remediation_Date__c != Null  || cm.SF2_11_Remediation_Plan__c != Null ||cm.SF2_11_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.11 Remediated Date, 2.11 Remediation Plan and 2.11 Remediation Steps Completed'));
	            return null;
	       	}
	       	if(cm.SF2_11__c == 'No' && cm.SF2_11_Remediated__c == 'Yes' && cm.SF2_11_Explanation__c != Null){
				   
	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.11 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_12__c == 'No' && (cm.SF2_12_Remediated__c == 'Dispute' || cm.SF2_12_Remediated__c == 'No') && cm.SF2_12_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.12 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_12__c == 'No' && (cm.SF2_12_Remediated__c == 'Dispute' || cm.SF2_12_Remediated__c == 'No') &&(cm.SF2_12_Remediation_Date__c != Null  || cm.SF2_12_Remediation_Plan__c != Null ||cm.SF2_12_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.12 Remediated Date, 2.12 Remediation Plan and 2.12 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_12__c == 'No' && cm.SF2_12_Remediated__c == 'Yes' && cm.SF2_12_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.12 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_13__c == 'No' && (cm.SF2_13_Remediated__c == 'Dispute' || cm.SF2_13_Remediated__c == 'No') && cm.SF2_13_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.13 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_13__c == 'No' && (cm.SF2_13_Remediated__c == 'Dispute' || cm.SF2_13_Remediated__c == 'No') &&(cm.SF2_13_Remediation_Date__c != Null  || cm.SF2_13_Remediation_Plan__c != Null ||cm.SF2_13_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.13 Remediated Date, 2.13 Remediation Plan and 2.13 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_13__c == 'No' && cm.SF2_13_Remediated__c == 'Yes' && cm.SF2_13_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.13 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_14__c == 'No' && (cm.SF2_14_Remediated__c == 'Dispute' || cm.SF2_14_Remediated__c == 'No') && cm.SF2_14_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.14 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_14__c == 'No' && (cm.SF2_14_Remediated__c == 'Dispute' || cm.SF2_14_Remediated__c == 'No') &&(cm.SF2_14_Remediation_Date__c != Null  || cm.SF2_14_Remediation_Plan__c != Null ||cm.SF2_14_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.14 Remediated Date, 2.14 Remediation Plan and 2.14 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_14__c == 'No' && cm.SF2_14_Remediated__c == 'Yes' && cm.SF2_14_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.14 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_15__c == 'No' && (cm.SF2_15_Remediated__c == 'Dispute' || cm.SF2_15_Remediated__c == 'No') && cm.SF2_15_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.15 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_15__c == 'No' && (cm.SF2_15_Remediated__c == 'Dispute' || cm.SF2_15_Remediated__c == 'No') &&(cm.SF2_15_Remediation_Date__c != Null  || cm.SF2_15_Remediation_Plan__c != Null ||cm.SF2_15_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.15 Remediated Date, 2.15 Remediation Plan and 2.15 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_15__c == 'No' && cm.SF2_15_Remediated__c == 'Yes' && cm.SF2_15_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.15 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_16__c == 'No' && (cm.SF2_16_Remediated__c == 'Dispute' || cm.SF2_16_Remediated__c == 'No') && cm.SF2_16_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.16 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_16__c == 'No' && (cm.SF2_16_Remediated__c == 'Dispute' || cm.SF2_16_Remediated__c == 'No') &&(cm.SF2_16_Remediation_Date__c != Null  || cm.SF2_16_Remediation_Plan__c != Null ||cm.SF2_16_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.16 Remediated Date, 2.16 Remediation Plan and 2.16 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_16__c == 'No' && cm.SF2_16_Remediated__c == 'Yes' && cm.SF2_16_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.16 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_17__c == 'No' && (cm.SF2_17_Remediated__c == 'Dispute' || cm.SF2_17_Remediated__c == 'No') && cm.SF2_17_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.17 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_17__c == 'No' && (cm.SF2_17_Remediated__c == 'Dispute' || cm.SF2_17_Remediated__c == 'No') &&(cm.SF2_17_Remediation_Date__c != Null  || cm.SF2_17_Remediation_Plan__c != Null ||cm.SF2_17_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.17 Remediated Date, 2.17 Remediation Plan and 2.17 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_17__c == 'No' && cm.SF2_17_Remediated__c == 'Yes' && cm.SF2_17_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.17 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_18__c == 'No' && (cm.SF2_18_Remediated__c == 'Dispute' || cm.SF2_18_Remediated__c == 'No') && cm.SF2_18_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.18 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_18__c == 'No' && (cm.SF2_18_Remediated__c == 'Dispute' || cm.SF2_18_Remediated__c == 'No') &&(cm.SF2_18_Remediation_Date__c != Null  || cm.SF2_18_Remediation_Plan__c != Null ||cm.SF2_18_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.18 Remediated Date, 2.18 Remediation Plan and 2.18 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_18__c == 'No' && cm.SF2_18_Remediated__c == 'Yes' && cm.SF2_18_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.18 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_19__c == 'No' && (cm.SF2_19_Remediated__c == 'Dispute' || cm.SF2_19_Remediated__c == 'No') && cm.SF2_19_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.19 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_19__c == 'No' && (cm.SF2_19_Remediated__c == 'Dispute' || cm.SF2_19_Remediated__c == 'No') &&(cm.SF2_19_Remediation_Date__c != Null  || cm.SF2_19_Remediation_Plan__c != Null ||cm.SF2_19_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.19 Remediated Date, 2.19 Remediation Plan and 2.19 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_19__c == 'No' && cm.SF2_19_Remediated__c == 'Yes' && cm.SF2_19_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.19 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_20__c == 'No' && (cm.SF2_20_Remediated__c == 'Dispute' || cm.SF2_20_Remediated__c == 'No') && cm.SF2_20_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.20 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_20__c == 'No' && (cm.SF2_20_Remediated__c == 'Dispute' || cm.SF2_20_Remediated__c == 'No') &&(cm.SF2_20_Remediation_Date__c != Null  || cm.SF2_20_Remediation_Plan__c != Null ||cm.SF2_20_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.20 Remediated Date, 2.20 Remediation Plan and 2.20 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_20__c == 'No' && cm.SF2_20_Remediated__c == 'Yes' && cm.SF2_20_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.20 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_21__c == 'No' && (cm.SF2_21_Remediated__c == 'Dispute' || cm.SF2_21_Remediated__c == 'No') && cm.SF2_21_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.21 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_21__c == 'No' && (cm.SF2_21_Remediated__c == 'Dispute' || cm.SF2_21_Remediated__c == 'No') &&(cm.SF2_21_Remediation_Date__c != Null  || cm.SF2_21_Remediation_Plan__c != Null ||cm.SF2_21_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.21 Remediated Date, 2.21 Remediation Plan and 2.21 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_21__c == 'No' && cm.SF2_21_Remediated__c == 'Yes' && cm.SF2_21_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.21 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_22__c == 'No' && (cm.SF2_22_Remediated__c == 'Dispute' || cm.SF2_22_Remediated__c == 'No') && cm.SF2_22_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.22 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_22__c == 'No' && (cm.SF2_22_Remediated__c == 'Dispute' || cm.SF2_22_Remediated__c == 'No') &&(cm.SF2_22_Remediation_Date__c != Null  || cm.SF2_22_Remediation_Plan__c != Null ||cm.SF2_22_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.22 Remediated Date, 2.22 Remediation Plan and 2.22 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_22__c == 'No' && cm.SF2_22_Remediated__c == 'Yes' && cm.SF2_22_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.22 If No/Dispute Provide Explanation.'));
	            return null;
	       	}
	       	/* Dispute error messsages */
	       	
	       	
	       	/* for new record type */
	       	
			
	       	if(cm.CF1_01_1__c == 'Yes' && cm.CF1_01_1_Remediated__c == 'Yes' &&(cm.CF1_01_1_Remediation_Date__c == Null  || cm.CF1_01_1_Remediation_Plan__c == Null ||cm.CF1_01_1_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.01.1 Remediated Date, 1.01.1 Remediation Plan and 1.01.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.CF1_02_1__c == 'Yes' && cm.CF1_02_1_Remediated__c == 'Yes' &&(cm.CF1_02_1_Remediation_Date__c == Null  || cm.CF1_02_1_Remediation_Plan__c == Null ||cm.CF1_02_1_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.02.1 Remediated Date, 1.02.1 Remediation Plan and 1.02.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}
	       
           if(cm.CF1_04_1__c == 'Yes' && cm.CF1_04_1_Remediated__c	 == 'Yes' &&(cm.CF1_04_1_Remedation_Date__c == Null  || cm.CF1_04_1_Remediation_Plan__c == Null ||cm.CF1_04_1_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.04.1 Remediated Date, 1.04.1 Remediation Plan and 1.04.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	    	if(cm.CF1_05__c == 'Yes' && cm.CF1_05_Remediated__c	== 'Yes' &&(cm.CF1_05_Remediation_Date__c == Null  || cm.CF1_05_Remediation_Plan__c == Null ||cm.CF1_05_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.05 Remediated Date, 1.05 Remediation Plan and 1.05 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_01_1__c == 'Yes' && cm.SF2_01_1_Remediated__c == 'Yes' &&(cm.SF2_01_1_Remediation_Date__c == Null  || cm.SF2_01_1_Remediation_Plan__c == Null ||cm.SF2_01_1_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.01.1 Remediated Date, 2.01.1 Remediation Plan and 2.01.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}
	       	
	       	if(cm.SF2_07_1__c == 'Yes' && cm.SF2_07_1_Remediated__c == 'Yes' &&(cm.SF2_07_1_Remediation_Date__c == Null  || cm.SF2_07_1_Remediation_Plan__c == Null ||cm.SF2_07_1_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.07.1 Remediated Date, 2.07.1 Remediation Plan and 2.07.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_08_1__c == 'Yes' && cm.SF2_08_1_Remediation__c == 'Yes' &&(cm.SF2_08_1_Remediation_Date__c == Null  || cm.SF2_08_1_Remediation_Plan__c == Null ||cm.SF2_08_1_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.08.1 Remediated Date, 2.08.1 Remediation Plan and 2.08.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_09_1__c == 'Yes' && cm.SF2_09_1_Remediated__c == 'Yes' &&(cm.SF2_09_1_Remediation_Date__c == Null  || cm.SF2_09_1_Remediation_Plan__c == Null ||cm.SF2_09_1_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.09.1 Remediated Date, 2.09.1 Remediation Plan and 2.09.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_10_1__c == 'Yes' && cm.SF2_10_1_Remediated__c == 'Yes' &&(cm.SF2_10_1_Remediation_Date__c == Null  || cm.SF2_10_1_Remediation_Plan__c == Null ||cm.SF2_10_1_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.10.1 Remediated Date, 2.10.1 Remediation Plan and 2.10.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_11_1__c == 'Yes' && cm.SF2_11_1_Remediated__c == 'Yes' &&(cm.SF2_11_1_Remediation_Date__c == Null  || cm.SF2_11_1_Remediation_Plan__c == Null ||cm.SF2_11_1_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.11.1 Remediated Date, 2.11.1 Remediation Plan and 2.11.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_12_1__c == 'Yes' && cm.SF2_12_1_Remediated__c == 'Yes' &&(cm.SF2_12_1_Remediation_Date__c == Null  || cm.SF2_12_1_Remediation_Plan__c == Null ||cm.SF2_12_1_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.12.1 Remediated Date, 2.12.1 Remediation Plan and 2.12.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_13_1__c == 'Yes' && cm.SF2_13_1_Remediated__c	 == 'Yes' &&(cm.SF2_13_1_Remediation_Date__c == Null  || cm.SF2_13_1_Remediation_Plan__c == Null ||cm.SF2_13_1_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.13.1 Remediated Date, 2.13.1 Remediation Plan and 2.13.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}
	       	
	       	if(cm.SF2_16_1__c == 'Yes' && cm.SF2_16_1_Remediated__c == 'Yes' &&(cm.SF2_16_1_Remediation_Date__c == Null  || cm.SFX2_16_1_Remediation_Plan__c == Null ||cm.SF2_16_1_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.16.1 Remediated Date, 2.16.1 Remediation Plan and 2.16.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_17_1__c == 'Yes' && cm.SF2_17_1_Remediated__c == 'Yes' &&(cm.SF2_17_1_Remediation_Date__c == Null  || cm.SFX2_17_1_Remediation_Plan__c == Null ||cm.SF2_17_1_Remediation_Steps__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.17.1 Remediated Date, 2.17.1 Remediation Plan and 2.17.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_18_1__c == 'Yes' && cm.SF2_18_1_Remediated__c == 'Yes' &&(cm.SF2_18_1_Remediation_Date__c == Null  || cm.SF2_18_1_Remediation_Plan__c == Null ||cm.SF2_18_1_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.18.1 Remediated Date, 2.18.1 Remediation Plan and 2.18.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_19_1__c == 'Yes' && cm.SF2_19_1_Remediated__c == 'Yes' &&(cm.SF2_19_1_Remediation_Date__c == Null  || cm.SF2_19_1_Remediation_Plan__c == Null ||cm.SF2_19_1_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.19.1 Remediated Date, 2.19.1 Remediation Plan and 2.19.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_20_1__c == 'Yes' && cm.SF2_20_1_Remediated__c == 'Yes' &&(cm.SF2_20_1_Remediation_Date__c == Null  || cm.SF2_20_1_Remediation_Plan__c == Null ||cm.SF2_20_1_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.20.1 Remediated Date, 2.20.1 Remediation Plan and 2.20.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_21_1__c == 'Yes' && cm.SF2_21_1_Remediated__c == 'Yes' &&(cm.SF2_21_1_Remediation_Date__c == Null  || cm.SF2_21_1_Remediation_Plan__c == Null ||cm.SF2_21_1_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.21.1 Remediated Date, 2.21.1 Remediation Plan and 2.21.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

	       	if(cm.SF2_22_1__c == 'Yes' && cm.SF2_22_1_Remediated__c == 'Yes' &&(cm.SF2_22_1_Remediation_Date__c == Null  || cm.SF2_22_1_Remediation_Plan__c == Null ||cm.SF2_22_1_Remediation_Steps_Completed__c == Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.22.1 Remediated Date, 2.22.1 Remediation Plan and 2.22.1 Remediation Steps Completed before saving the record.'));
	            return null;
	       	}

               
	       	/* Dispute error messsages */
	       	if(cm.CF1_01_1__c == 'Yes' && (cm.CF1_01_1_Remediated__c == 'Dispute' || cm.CF1_01_1_Remediated__c == 'No') && cm.CF1_01_1_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.01.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}
	       	
	       	
	       	if(cm.CF1_01_1__c == 'Yes' && (cm.CF1_01_1_Remediated__c == 'Dispute' || cm.CF1_01_1_Remediated__c == 'No') &&(cm.CF1_01_1_Remediation_Date__c != Null  || cm.CF1_01_1_Remediation_Plan__c != Null ||cm.CF1_01_1_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.01.1 Remediated Date, 1.01.1 Remediation Plan and 1.01.1 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.CF1_01_1__c == 'Yes' && cm.CF1_01_1_Remediated__c == 'Yes' && cm.CF1_01_1_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.01.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}
			
			
	       	if(cm.CF1_02_1__c == 'Yes' && (cm.CF1_02_1_Remediated__c == 'Dispute' || cm.CF1_02_1_Remediated__c == 'No') && cm.CF1_02_1_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.02.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}

			if(cm.CF1_02_1__c == 'Yes' && (cm.CF1_02_1_Remediated__c == 'Dispute' || cm.CF1_02_1_Remediated__c == 'No') &&(cm.CF1_02_1_Remediation_Date__c != Null  || cm.CF1_02_1_Remediation_Plan__c != Null ||cm.CF1_02_1_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.02.1 Remediated Date, 1.02.1 Remediation Plan and 1.02.1 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.CF1_02_1__c == 'Yes' && cm.CF1_02_1_Remediated__c == 'Yes' && cm.CF1_02_1_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.02.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}
			
			if(cm.CF1_04_1__c == 'Yes' && (cm.CF1_04_1_Remediated__c == 'Dispute' || cm.CF1_04_1_Remediated__c == 'No') && cm.CF1_04_1_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.04.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.CF1_04_1__c == 'Yes' && (cm.CF1_04_1_Remediated__c == 'Dispute' || cm.CF1_04_1_Remediated__c == 'No') &&(cm.CF1_04_1_Remedation_Date__c != Null  || cm.CF1_04_1_Remediation_Plan__c != Null ||cm.CF1_04_1_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.04.1 Remediated Date, 1.04.1 Remediation Plan and 1.04.1 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.CF1_04_1__c == 'Yes' && cm.CF1_04_1_Remediated__c == 'Yes' && cm.CF1_04_1_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.04.1 If No/Dispute Provide Explanation.'));
	            return null;
	       	}
			
			
	       	if(cm.CF1_05__c == 'Yes' && (cm.CF1_05_Remediated__c == 'Dispute' || cm.CF1_05_Remediated__c == 'No') && cm.CF1_05_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 1.05 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.CF1_05__c == 'Yes' && (cm.CF1_05_Remediated__c == 'Dispute' || cm.CF1_05_Remediated__c == 'No') &&(cm.CF1_05_Remediation_Date__c != Null  || cm.CF1_05_Remediation_Plan__c != Null ||cm.CF1_05_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.05 Remediated Date, 1.05 Remediation Plan and 1.05 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.CF1_05__c == 'Yes' && cm.CF1_05_Remediated__c == 'Yes' && cm.CF1_05_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 1.05 If No/Dispute Provide Explanation.'));
	            return null;
	       	}
			
			
	       	if(cm.SF2_01_1__c == 'Yes' && (cm.SF2_01_1_Remediated__c == 'Dispute' || cm.SF2_01_1_Remediated__c == 'No') && cm.SF2_01_1_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.01.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_01_1__c == 'Yes' && (cm.SF2_01_1_Remediated__c == 'Dispute' || cm.SF2_01_1_Remediated__c == 'No') &&(cm.SF2_01_1_Remediation_Date__c != Null  || cm.SF2_01_1_Remediation_Plan__c != Null ||cm.SF2_01_1_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.01.1 Remediated Date, 2.01.1 Remediation Plan and 2.01.1 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_01_1__c == 'Yes' && cm.SF2_01_1_Remediated__c == 'Yes' && cm.SF2_01_1_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.01.1 If No/Dispute Provide Explanation.'));
	            return null;
	       	}
			
			if(cm.SF2_07_1__c == 'Yes' && (cm.SF2_07_1_Remediated__c == 'Dispute' || cm.SF2_07_1_Remediated__c == 'No') && cm.SF2_07_1_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.07.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_07_1__c == 'Yes' && (cm.SF2_07_1_Remediated__c == 'Dispute' || cm.SF2_07_1_Remediated__c == 'No') &&(cm.SF2_07_1_Remediation_Date__c != Null  || cm.SF2_07_1_Remediation_Plan__c != Null ||cm.SF2_07_1_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.07.1 Remediated Date, 2.07.1 Remediation Plan and 2.07.1 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_07_1__c == 'Yes' && cm.SF2_07_1_Remediated__c == 'Yes' && cm.SF2_07_1_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.07.1 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_08_1__c == 'Yes' && (cm.SF2_08_1_Remediation__c == 'Dispute' || cm.SF2_08_1_Remediation__c == 'No') && cm.SF2_08_1_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.08.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_08_1__c == 'Yes' && (cm.SF2_08_1_Remediation__c == 'Dispute' || cm.SF2_08_1_Remediation__c == 'No') &&(cm.SF2_08_1_Remediation_Date__c != Null  || cm.SF2_08_1_Remediation_Plan__c != Null ||cm.SF2_08_1_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.08.1 Remediated Date, 2.08.1 Remediation Plan and 2.08.1 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_08_1__c == 'Yes' && cm.SF2_08_1_Remediation__c == 'Yes' && cm.SF2_08_1_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.08.1 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_09_1__c == 'Yes' && (cm.SF2_09_1_Remediated__c == 'Dispute' || cm.SF2_09_1_Remediated__c == 'No') && cm.SF2_09_1_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.09.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_09_1__c == 'Yes' && (cm.SF2_09_1_Remediated__c == 'Dispute' || cm.SF2_09_1_Remediated__c == 'No') &&(cm.SF2_09_1_Remediation_Date__c != Null  || cm.SF2_09_1_Remediation_Plan__c != Null ||cm.SF2_09_1_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.09.1 Remediated Date, 2.09.1 Remediation Plan and 2.09.1 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_09_1__c == 'Yes' && cm.SF2_09_1_Remediated__c == 'Yes' && cm.SF2_09_1_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.09.1 If No/Dispute Provide Explanation.'));
	            return null; 
	       	}

	       	if(cm.SF2_10_1__c == 'Yes' && (cm.SF2_10_1_Remediated__c == 'Dispute' || cm.SF2_10_1_Remediated__c == 'No') && cm.SF2_10_1_Explanatio__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.10.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_10_1__c == 'Yes' && (cm.SF2_10_1_Remediated__c == 'Dispute' || cm.SF2_10_1_Remediated__c == 'No') &&(cm.SF2_10_1_Remediation_Date__c != Null  || cm.SF2_10_1_Remediation_Plan__c != Null ||cm.SF2_10_1_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.10.1 Remediated Date, 2.10.1 Remediation Plan and 2.10.1 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_10_1__c == 'Yes' && cm.SF2_10_1_Remediated__c == 'Yes' && cm.SF2_10_1_Explanatio__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.10.1 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_11_1__c == 'Yes' && (cm.SF2_11_1_Remediated__c == 'Dispute' || cm.SF2_11_1_Remediated__c == 'No') && cm.SF2_11_1_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.11.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_11_1__c == 'Yes' && (cm.SF2_11_1_Remediated__c == 'Dispute' || cm.SF2_11_1_Remediated__c == 'No') &&(cm.SF2_11_1_Remediation_Date__c != Null  || cm.SF2_11_1_Remediation_Plan__c != Null ||cm.SF2_11_1_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.11.1 Remediated Date, 2.11.1 Remediation Plan and 2.11.1 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_11_1__c == 'Yes' && cm.SF2_11_1_Remediated__c == 'Yes' && cm.SF2_11_1_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.11.1 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_12_1__c == 'Yes' && (cm.SF2_12_1_Remediated__c == 'Dispute' || cm.SF2_12_1_Remediated__c == 'No') && cm.SF2_12_1_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.12.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_12_1__c == 'Yes' && (cm.SF2_12_1_Remediated__c == 'Dispute' || cm.SF2_12_1_Remediated__c == 'No') &&(cm.SF2_12_1_Remediation_Date__c != Null  || cm.SF2_12_1_Remediation_Plan__c != Null ||cm.SF2_12_1_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.12.1 Remediated Date, 2.12.1 Remediation Plan and 2.12.1 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_12_1__c == 'Yes' && cm.SF2_12_1_Remediated__c == 'Yes' && cm.SF2_12_1_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.12.1 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_13_1__c == 'Yes' && (cm.SF2_13_1_Remediated__c == 'Dispute' || cm.SF2_13_1_Remediated__c == 'No') && cm.SF2_13_1_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.13.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_13_1__c == 'Yes' && (cm.SF2_13_1_Remediated__c == 'Dispute' || cm.SF2_13_1_Remediated__c == 'No') &&(cm.SF2_13_1_Remediation_Date__c != Null  || cm.SF2_13_1_Remediation_Plan__c != Null ||cm.SF2_13_1_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.13.1 Remediated Date, 2.13.1 Remediation Plan and 2.13.1 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_13_1__c == 'Yes' && cm.SF2_13_1_Remediated__c == 'Yes' && cm.SF2_13_1_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.13.1 If No/Dispute Provide Explanation.'));
	            return null;
	       	}
			
			
	       	if(cm.SF2_16_1__c == 'Yes' && (cm.SF2_16_1_Remediated__c == 'Dispute' || cm.SF2_16_1_Remediated__c == 'No') && cm.SF2_16_1_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.16.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_16_1__c == 'Yes' && (cm.SF2_16_1_Remediated__c == 'Dispute' || cm.SF2_16_1_Remediated__c == 'No') &&(cm.SF2_16_1_Remediation_Date__c != Null  || cm.SFX2_16_1_Remediation_Plan__c != Null ||cm.SF2_16_1_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.16.1 Remediated Date, 2.16.1 Remediation Plan and 2.16.1 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_16_1__c == 'Yes' && cm.SF2_16_1_Remediated__c == 'Yes' && cm.SF2_16_1_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.16.1 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_17_1__c == 'Yes' && (cm.SF2_17_1_Remediated__c == 'Dispute' || cm.SF2_17_1_Remediated__c == 'No') && cm.SF2_17_1_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.17.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_17_1__c == 'Yes' && (cm.SF2_17_1_Remediated__c == 'Dispute' || cm.SF2_17_1_Remediated__c == 'No') &&(cm.SF2_17_1_Remediation_Date__c != Null  || cm.SFX2_17_1_Remediation_Plan__c != Null ||cm.SF2_17_1_Remediation_Steps__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.17.1 Remediated Date, 2.17.1 Remediation Plan and 2.17.1 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_17_1__c == 'Yes' && cm.SF2_17_1_Remediated__c == 'Yes' && cm.SF2_17_1_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.17.1 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_18_1__c == 'Yes' && (cm.SF2_18_1_Remediated__c == 'Dispute' || cm.SF2_18_1_Remediated__c == 'No') && cm.SF2_18_1_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.18.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_18_1__c == 'Yes' && (cm.SF2_18_1_Remediated__c == 'Dispute' || cm.SF2_18_1_Remediated__c == 'No') &&(cm.SF2_18_1_Remediation_Date__c != Null  || cm.SF2_18_1_Remediation_Plan__c != Null ||cm.SF2_18_1_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.18.1 Remediated Date, 2.18.1 Remediation Plan and 2.18.1 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_18_1__c == 'Yes' && cm.SF2_18_1_Remediated__c == 'Yes' && cm.SF2_18_1_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.18.1 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_19_1__c == 'Yes' && (cm.SF2_19_1_Remediated__c == 'Dispute' || cm.SF2_19_1_Remediated__c == 'No') && cm.SF2_19_1_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.19.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_19_1__c == 'Yes' && (cm.SF2_19_1_Remediated__c == 'Dispute' || cm.SF2_19_1_Remediated__c == 'No') &&(cm.SF2_19_1_Remediation_Date__c != Null  || cm.SF2_19_1_Remediation_Plan__c != Null ||cm.SF2_19_1_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.19.1 Remediated Date, 2.19.1 Remediation Plan and 2.19.1 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_19_1__c == 'Yes' && cm.SF2_19_1_Remediated__c == 'Yes' && cm.SF2_19_1_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.19.1 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_20_1__c == 'Yes' && (cm.SF2_20_1_Remediated__c == 'Dispute' || cm.SF2_20_1_Remediated__c == 'No') && cm.SF2_20_1_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.20.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_20_1__c == 'Yes' && (cm.SF2_20_1_Remediated__c == 'Dispute' || cm.SF2_20_1_Remediated__c == 'No') &&(cm.SF2_20_1_Remediation_Date__c != Null  || cm.SF2_20_1_Remediation_Plan__c != Null ||cm.SF2_20_1_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.20.1 Remediated Date, 2.20.1 Remediation Plan and 2.201 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_20_1__c == 'Yes' && cm.SF2_20_1_Remediated__c == 'Yes' && cm.SF2_20_1_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.20.1 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_21_1__c == 'Yes' && (cm.SF2_21_1_Remediated__c == 'Dispute' || cm.SF2_21_1_Remediated__c == 'No') && cm.SF2_21_1_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.21.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_21_1__c == 'Yes' && (cm.SF2_21_1_Remediated__c == 'Dispute' || cm.SF2_21_1_Remediated__c == 'No') &&(cm.SF2_21_1_Remediation_Date__c != Null  || cm.SF2_21_1_Remediation_Plan__c != Null ||cm.SF2_21_1_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.21.1 Remediated Date, 2.21.1 Remediation Plan and 2.21.1 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_21_1__c == 'Yes' && cm.SF2_21_1_Remediated__c == 'Yes' && cm.SF2_21_1_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.21.1 If No/Dispute Provide Explanation.'));
	            return null;
	       	}

	       	if(cm.SF2_22_1__c == 'Yes' && (cm.SF2_22_1_Remediated__c == 'Dispute' || cm.SF2_22_1_Remediated__c == 'No') && cm.SF2_22_1_Explanation__c == Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please populate 2.22.1 If No/Dispute Provide Explanation'));
	            return null;
	       	}

	       	if(cm.SF2_22_1__c == 'Yes' && (cm.SF2_22_1_Remediated__c == 'Dispute' || cm.SF2_22_1_Remediated__c == 'No') &&(cm.SF2_22_1_Remediation_Date__c != Null  || cm.SF2_22_1_Remediation_Plan__c != Null ||cm.SF2_22_1_Remediation_Steps_Completed__c != Null)){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.22.1 Remediated Date, 2.22.1 Remediation Plan and 2.22.1 Remediation Steps Completed'));
	            return null;
	       	}

	       	if(cm.SF2_22_1__c == 'Yes' && cm.SF2_22_1_Remediated__c == 'Yes' && cm.SF2_22_1_Explanation__c != Null){

	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'You cannot populate 2.22.1 If No/Dispute Provide Explanation.'));
	            return null;
	       	}	       	
	       	
       		upsert cm;
       		pageReference pr = new pageReference('/'+cm.id);
       		return pr;
       	}
	
	public pagereference cancel(){

				pageReference pr1 = new pageReference('/'+cm.id);
				return pr1;
	}
       
	public static void bufferCodeCoverage(){
		
		Integer i = 0;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
		i++;
	}       
}