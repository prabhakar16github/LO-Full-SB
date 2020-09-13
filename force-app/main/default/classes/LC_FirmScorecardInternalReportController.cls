public class LC_FirmScorecardInternalReportController
{
	public Account acc {get;set;}
	public List<Firm_Scorecard__c> fms {get;set;}
	
	Public string pageId;
	
	public LC_FirmScorecardInternalReportController()
	{
		fms = new List<Firm_Scorecard__c>();
		
		pageId=apexpages.currentpage().getparameters().get('id');
		
		system.debug('pageId-->'+pageId);
		
		
		fms =  [Select Organization_Name__r.Name,Organization_Name__r.Organization_Owner__c,Name,SC_Collections__c,Collections_Comments__c,
						SC_CC_Budget__c,Collections_Score__c,CC_Budget_Score__c,CC_Budget_Comments__c,SC_Liquidation__c,Liquidation_Score__c,
						Liquidation_Comments__c,Performance_Metrics_Score__c,SC_Performance_Metrics__c,Performance_Metrics_Comments__c,
						SC_Financial_Exceptions__c,Financial_Exceptions_Score__c,Financial_Exceptions_Comments__c,SC_Affidavits__c,Affidavits_Score__c,
				        Affidavits_Comments__c,SC_Media__c,Media_Score__c,Media_Comments__c,SC_Data_Doc_Compliance__c,Data_Doc_Compliance_Score__c,
				        Data_Doc_Compliance_Comments__c,SC_Inventory_Recon__c,Inventory_Recon_Score__c,Inventory_Recon_Comments__c ,
				        SC_Response_Performance_Engagement__c,Response_Performance_Engagement_Score__c,FAE_Response_Performance_Engagement__c,
				        SC_Process_Adherence__c,Process_Adherence_Score__c,FAE_Process_Adherence__c,Process_Adherence_Comments__c,
				        SC_Strategic_Opps_Compromise_Comm__c,Strategic_Opps_Compromise_Comm_Score__c,FAE_Strategic_Opps_Compromise_Comm__c,
				        Strategic_Opps_Compromise_Comm_Comments__c,Response_Performance_Engagement_Comments__c,SC_ACD_Regulatory_Complaints__c,
				        ACD_Regulatory_Complaints_Score__c,FAE_ACD_Regulatory_Complaints__c,ACD_Regulatory_Complaints_Comments__c,
				        SC_Inventory_Mgmt_and_Analytics__c,Inventory_Mgmt_and_Analytics_Score__c,FAE_Inventory_Mgmt_and_Analytics__c,
				        Inventory_Mgmt_Analystics_Comments__c,SC_Org_Structure_and_Capacity_Mgmt__c,Org_Structure_and_Capacity_Mgmt_Score__c,
				        FAE_Org_Structure_and_Capacity_Mgmt__c,Org_Structure_and_Capacity_Mgmt_Comments__c,SC_Consumer_Treatment__c,
				        Consumer_Treatment_Score__c,Consumer_Treatment_Comments__c,SC_Best_Practices_and_Technology__c,Best_Practices_and_Technology_Score__c,
				        FAE_Best_Practices_and_Technology__c,Best_Practices_and_Technology_Comments__c,SC_Compliance_and_Audit__c,
				        Compliance_and_Audit_Score__c,FAE_Compliance_and_Audit__c,Compliance_and_Audit_Comments__c,SC_Legal_Comm_Collaboration__c,
				        Legal_Comm_Collaboration_Score__c,FAE_Legal_Comm_Collaboration__c,Legal_Comm_Collaboration_Comments__c,SC_Application_of_Law__c,
				        Application_of_Law_Score__c,FAE_Application_of_Law__c,SC_Industry_Involvement__c,Industry_Involvement_Score__c,
				        Application_of_Law_Comments__c,Industry_Involvement_Comments__c,SC_Overall_Comments__c,SC_Performance_Management_Overall_Score__c,
				        SC_Operations_Overall_Score__c,SC_Focus_1__c,SC_Focus_2__c,SC_P_R_Overall_Score__c,SC_Focus_3__c,SC_Firm_Practices_Overall_Score__c,
				        SC_Compliance_Legal_Expertise_Overall_S__c,SC_Overall_Firm_Score__c,FAE_Overall_Comments__c,FAE_P_R_Overall_Score__c,
				        FAE_Firm_Practices_Overall_Score__c,FAE_Comp_Legal_Expertise_Overall_Score__c,FAE_Overall_Firm_Score__c,FAE_Consumer_Treatment__c,
				        FAE_Industry_Involvement__c,Organization_Name__r.Firm_Scorecard_Count__c,SC_Call_Monitoring__c,Call_Monitoring_Score__c,
				        FAE_Call_Monitoring__c,Call_Monitoring_Comments__c ,RecordTypeid,RecordType.Name, SC_Ops_Adherence_and_Coding__c,
				        FAE_Ops_Adherence_and_Coding__c,Ops_Adherence_and_Coding_Comments__c,Ops_Adherence_and_Coding_Score__c, 
				        SC_POE_and_Bank_Data_Utilization__c, FAE_POE_and_Bank_Data_Utilization__c, POE_and_Bank_Data_Utilization_Comments__c, 
				        POE_and_Bank_Data_Utilization_Score__c 
				  FROM Firm_Scorecard__c  WHERE Organization_Name__c =: pageId ORDER BY CreatedDate DESC LIMIT 2];
			system.debug('fms-->'+fms);
			system.debug('fms size-->'+fms.size());
			system.debug('fms org name-->'+fms[0].Organization_Name__r.Name);
    }
}