public class SCMDEmailCommunicationTemplates {
	
	public static String baseUrl{
		get{
			return baseUrl == null ? String.valueOf(System.Url.getSalesforceBaseUrl().toExternalForm()) : baseUrl;  
		}set;
	}
	
	public static String communityBaseUrl;
	
	static{
		
		communityBaseUrl = communityBaseUrl == null ? String.valueOf(Utils.getCommunityBaseUrl()) : communityBaseUrl;
	}
	
	// templates used for LO start
	public static String getDayOneMonthlyTemplateSCM(Process_Adherence_Monitoring__c pamObj, String contactName, Boolean isCommunityUser){
	
		if(isCommunityUser){
			
			baseUrl = communityBaseUrl;
		}
	
		String emailMessageBody = ''; 
    	
    		emailMessageBody = '<p>Hello '+contactName+',</p>'
                				+'MCM monitors status codes communicated by Firms to ensure accounts are handled in'
                				+'accordance with the MCM Firm Manual. Firms must adhere to the process outlined below to'
                				+'enable MCM to reconcile information received from Firms against its records. <br/><br/>'
                
                
                				+'<b>Required Action</b><br/><br/>'
                
                
                				+'1. Select the link to access the Status Code Monitoring (SCM) record within the LC Partner Access '
                				+'Site: <a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a><br/>'
                				+'2. Prioritize and submit account numbers for ALL open and closed accounts on which the Firm '
                				+'sent the dispute status codes identified below within the previous month (e.g., January 1 – January 31)'
                
                
    							/*+ '<p>To ensure all disputed accounts are handled in accordance with the Firm Manual, '
    							+'MCM monitors the dispute statuses below that are communicated by Firms, and is in the '
    							+'process of reconciling information received from Firms against its records.&nbsp;</p>'*/
    							
    							+'<ul>'
    								+'<li>Oral Dispute&nbsp;</li>'
    								+'<li>Written Dispute&nbsp;</li>'
									+'<li>Mail Out Validation of Debt&nbsp;</li>'	
								+'</ul>'
                				+'3. Submit account numbers for ALL open and closed accounts on which the Firm sent the remaining 15 '
                				+'status codes within the previous month (e.g., January 1 - January 31)<br/><br/>'
                
                				+'The Firm must respond by providing the required information within <b>three (3) business days</b>.<br/><br/>'
                				+'For any questions, contact <a href="mailto:LO-Operational@mcmcg.com">LO-Operational@mcmcg.com</a>.'
                				+'<p>Thank you,</p>'
								+'<p>LO-Operational</p>';
								
								/*+'<p>Select the link below to access the Status Code Monitoring (SCM) record within the LC Partner Access Site. '
								+'Provide a list of MCM account numbers for '
								+'ALL open and closed accounts under each status sent within the previous month (ex:&nbsp; January 1- January 31). '
								+'It is critical that the Firm provides accurate information as this may impact the resolution of the reconciliation.</p>'
								+'<p><span style="text-decoration: underline;">'
								+'<a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a></span></p>'
								+'<p>The Firm must provide responses by filling in the required information within '
								+'<strong><span style="text-decoration: underline;">three (3) business days.</span></strong></p>'
								+'<p>For any questions, contact <a href="mailto:LO-Operational@mcmcg.com">LO-Operational@mcmcg.com</a>.</p>'
								+'<p>Thank you,</p>'
								+'<p>LO-Operational</p>';	*/
									
    	return emailMessageBody;
	}
	
	
	public static String getUnassignedPamOwnerTemplate(){
	
		String emailMessageBody = ''; 
    	
    		emailMessageBody = '<p>Hello,<br /> <br />Firm does not have any LC Partner Access users therefore, '
    								+'the record has been assigned to the System Administrator.<br /><br />'
    								+'Please reach out to the Firm to identify who the user should be and advise them to '
    								+'submit a new user request.&nbsp;&nbsp;Once the user has been set up, '
    								+'please be sure to update the owner of the record accordingly.<br /><br />'
    								+'Thank you,<br /><br />Salesforce System Administrator</p>';	
									
    	return emailMessageBody;
	}
	
	public static String getDayThreeMonthlyTemplateSCM(Process_Adherence_Monitoring__c pamObj, String contactName, Boolean isCommunityUser){
	
		if(isCommunityUser){
			
			baseUrl = communityBaseUrl;
		}
		
		String emailMessageBody = ''; 
    	
    		emailMessageBody = '<p>Hello '+contactName+',</p>'
    							+'<p>As a reminder the below information is due <strong><u>today.</u></strong></p>'
                				+'<hr style="border-top: 1px dashed black;margin : 10px 0px 50px 0px; "></hr>'
                				+'<p>MCM monitors status codes communicated by Firms to ensure accounts are handled in '
                				+'MCM monitors status codes communicated by Firms to ensure accounts are handled in '
                				+'enable MCM to reconcile information received from Firms against its records.  </p><br/>'
                
                				+'<b>Required Action</b><br/><br/>'
                					
                				+'<p>1. Select the link to access the Status Code Monitoring (SCM) record within the LC Partner Access '
                				+'Site: <a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a></p>'
                				+'<p>2.	Prioritize and submit account numbers for ALL open and closed accounts on which the Firm '
                				+'sent the dispute status codes identified below within the previous month (e.g., January 1 – January 31)</p>'
                
                
                
								/*+'<p>To ensure all disputed accounts are handled in accordance with the Firm Manual, '
								+'MCM monitors the dispute statuses below that are communicated by Firms, and is in the '
								+'process of reconciling information received from Firms against its records.&nbsp;</p>'*/
								+'<ul>'
								+'<li>Oral Dispute&nbsp;</li>'
								+'<li>Written Dispute&nbsp;</li>'
								+'<li>Mail Out Validation of Debt&nbsp;</li>'
								+'</ul>'
                				
                				+'<p>3.	Submit account numbers for ALL open and closed accounts on 3.which the Firm sent the '
                				+'remaining 15 status codes within the previous month (e.g., January 1 - January 31)</p> '
                					
                				+'The Firm must respond by providing the required information by end of business today. '
                
								/*+'<p>Select the link below to access the Status Code Monitoring (SCM) record within the LC Partner Access Site. '
								+'Provide a list of MCM account numbers for ALL open and closed accounts under each status sent '
								+'within the previous month (ex:&nbsp; January 1- January 31). It is critical that the Firm provides accurate '
								+'information as this may impact the resolution of the reconciliation.</p>'
								+'<p><u><a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a></u></p>'
								+'<p>The Firm must provide responses by filling in the required information within <strong><u>three (3) business days.'
								+'</u></strong></p>'*/
                
								+'<p>For any questions, contact <a href="mailto:LO-Operational@mcmcg.com">LO-Operational@mcmcg.com</a>.</p>'
								+'<p>Thank you,</p>'						
								+'<p>LO-Operational</p>';
									
    	return emailMessageBody;
	}
	
	public static String getSecondEscalationTemplateSCM(Process_Adherence_Monitoring__c pamObj, String contactName, Boolean isCommunityUser){
		
		if(isCommunityUser){
			
			baseUrl = communityBaseUrl;
		}
	
		String emailMessageBody = ''; 
    	
    		emailMessageBody = '<p>Hello '+contactName+',</p>'
    							+'<p>Be advised that the Firm\'s response to the request below is now <strong>past due</strong>.&nbsp;</p>'
    							+'This is time sensitive.&nbsp; Please provide your response <strong><u>today</u></strong>.</p><br/>'
                				+'<hr style="border-top: 1px dashed black;margin : 10px 0px 50px 0px; "></hr>'
                
                				+'<p>MCM monitors status codes communicated by Firms to ensure accounts are handled in accordance with the '
                				+'MCM Firm Manual.  Firms must adhere to the process outlined below to enable MCM to reconcile information received '
                				+'from Firms against its records.</p>'
                				
                				+'<b>Required Action</b>'
                
                				+'<p>1. Select the link to access the Status Code Monitoring (SCM) record within the LC Partner Access site:'
                				+'<a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a></p>'
                		
                				+'<p>2.	Prioritize and submit account numbers for ALL open and closed accounts on which the Firm '
                				+'sent the dispute status codes identified below within the previous month (e.g., January 1 – January 31)</p>'
                
                
								/*+'<p>&nbsp;To ensure all disputed accounts are handled in accordance with the Firm Manual, '
								+'MCM monitors the following dispute statuses communicated by Firms, '
								+'and is in the process of reconciling information received from Firms against its records.&nbsp;&nbsp;</p>'
								*/
								+'<ul>'
								+'<li>Oral Dispute&nbsp;</li>'
								+'<li>Written Dispute&nbsp;</li>'
								+'<li>Mail Out Validation of Debt&nbsp;</li>'
								+'</ul>'	
                
                				+'<p>3.	Submit account numbers for ALL open and closed accounts on which the Firm sent the remaining 15 status '
                				+'codes within the previous month (e.g., January 1 - January 31).</p>'
                
                				
								/*+'<p>Select the link below to access the Status Code Monitoring (SCM) record within the LC Partner Access Site. '
								+'Provide a list of MCM account numbers for ALL open and closed accounts under each status sent '
								+'within the previous month (ex:&nbsp; January 1- January 31). It is critical that the Firm provides accurate '
								+'information as this may impact the resolution of the reconciliation.</p>'
								+'<p><u><a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a></u></p>'*/
								
								+'<p>For any questions, contact <a href="mailto:LO-Operational@mcmcg.com">LO-Operational@mcmcg.com</a>.</p>'
								+'<p>Thank you,</p>'						
								+'<p>LO-Operational</p>';
									
    	return emailMessageBody;
	}
	
	public static String getFinalEscalationTemplateSCM(Process_Adherence_Monitoring__c pamObj, String contactName, Boolean isCommunityUser){
		
		if(isCommunityUser){
			
			baseUrl = communityBaseUrl;
		}
	
		String emailMessageBody = ''; 
    	
    		emailMessageBody = '<p>Hello '+contactName+',</p>'
    							+'<p>Be advised that MCM has not received the Firm&rsquo;s response to this request.&nbsp;'
    							+' This is time sensitive; therefore, it is critical that we receive the response <strong>'
    							+'<u>today</u></strong>.&nbsp; Failure to provide responses may result in further escalation.</p><br/>'
                				+'<hr style="border-top: 1px dashed black;margin : 10px 0px 50px 0px; "></hr>'
                
                				+'<p>MCM monitors status codes communicated by Firms to ensure accounts are handled in accordance with '
                				+'the MCM Firm Manual.  Firms must adhere to the process outlined below to enable MCM to reconcile '
                				+'information received from Firms against its records. </p>'
                
                				+'<b>Required Action</b><br/><br/>'
                				+'<p>1.	Select the link to access the Status Code Monitoring (SCM) record within the LC Partner Access '
                				+'Site: <u><a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a></u></p>'
                				+'<p>2.	Prioritize and submit account numbers for ALL open and closed accounts on which the Firm sent '
                				+'the dispute status codes below within the previous month (e.g., January 1 – January 31) </p>'
                
								/*+'<p>&nbsp;To ensure all disputed accounts are handled in accordance with the Firm Manual, '
								+'MCM monitors the following dispute statuses communicated by Firms, and is in the process of '
								+'reconciling information received from Firms against its records.&nbsp;&nbsp;</p>'*/
								+'<ul>'
								+'<li>Oral Dispute&nbsp;</li>'
								+'<li>Written Dispute&nbsp;</li>'
								+'<li>Mail Out Validation of Debt&nbsp;</li>'
								+'</ul>'
                				+'<p>3.	Submit account numbers for ALL open and closed accounts on which the Firm sent the remaining 15 status'
                				+'codes within the previous month (e.g., January 1 - January 31)'
                				
               					 /*
								+'<p>Select the link below to access the Status Code Monitoring (SCM) record within the LC Partner Access Site.'
								+' Provide a list of MCM account numbers for '
								+'ALL open and closed accounts under each status sent within the previous month (ex:&nbsp; January 1- January 31).'
								+' It is critical that the Firm provides accurate information as this may impact the resolution of the reconciliation.</p>'	
								+'<p><u><a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a></u></p>'
								*/
								+'<p>&nbsp;For any questions, contact <a href="mailto:LO-Operational@mcmcg.com">LO-Operational@mcmcg.com </a></p>'
								+'<p>&nbsp;Thank you,</p>'
								+'<p>LO-Operational&nbsp;</p>';
									
    	return emailMessageBody;
	}
	
    /******************************* Added changes on 12-March-2020 by Prabhakar Joshi****************************/
	public static String send_No_Response_MailToOrgOwner(){
		
		String emailMessageBody = ''; 
    	
    		emailMessageBody = '<p>Hello,</p>'
								+'<p>Be advised that your Firm identified above has not provided the required monthly dispute status code '
								+'information after <strong><u>nine (9)</u></strong> notifications. To remediate, the Vendor Specialist team is '
                				+'scheduling a call with the Firm and Firm Manager to discuss and resolve. </p>'
                				/*
                				+'At this time, the '
								+'Vendor Specialist will be setting up a meeting with you and the Firm for further discussion '
								+'and resolution.</p>'
								*/
								+'<p>&nbsp;</p>'
								+'<p>Thank you,</p>'
								+'<p>LO-Operational&nbsp;</p>';
									
    	return emailMessageBody;
	}
	
	public static String getSCMDUnmatchedOnCreateTemplate(Process_Adherence_Monitoring__c pamObj, String contactName, Boolean isCommunityUser){
		
		
		if(isCommunityUser){
			
			baseUrl = communityBaseUrl;
		}
		
		String emailMessageBody = ''; 
		
		emailMessageBody = '<p>Hello '+contactName+',</p>'
            
            				+'<p>MCM identified potential discrepancies with the status code information submitted by the Firm.'
            				+'To remediate, Firms must adhere to the process outlined below to enable MCM to reconcile '
							+'information received from Firms against its records.</p> '
            				+'<b>Required Action</b><br/>'
            				+'<p>1.	Select the link to access the "Process Adherence Monitoring" tab within the LC Partner Access '
            				+'Site : <u><a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a></u></p>'
            				+'<p>2.	Locate the accounts with discrepancies in the “SCM – Unmatched” section</p>'
            				+'<p>3.	Populate the Reason for Discrepancy and Reason for Discrepancy Comments within each record</p>'
            				+'<p>4.	Send corresponding status codes</p><br/>'
            				+'<p>The Firm must respond by providing the required information within <b>48 hours</b>. </p>'
  							          
            
            				/*
            				+'<p>As a result of MCM&rsquo;s dispute status review, MCM identified potential '
							+'discrepancies with the identified accounts that requires the Firm&rsquo;s remediation.</p>'
							+'<p>In order to reconcile our records, access the account information within the '
							+'"Process Adherence Monitoring" tab of the LC Partner Access Site or by selecting this link '
							+'<u><a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a></u>'
							+' locate the accounts with discrepancies in the &ldquo;SCMD &ndash; Unmatched&rdquo; section and follow the '
							+'<strong><u>required actions</u></strong> below:</p>'
							+'<ul><li>Review the account discrepancy description within the record;</li>'
							+'<li>Send the missing status codes via YGC that corresponds with the dispute status; and</li>'
							+'<li>Select the appropriate reason that best describes the variation from the drop-down '
							+'list in the "Discrepancy Detail" section.</li>'
							+'</ul><p>The Firm must provide a response within <strong><u>48 hours</u></strong>.</p>'
							*/
							+'<p>For any questions, contact <a href="mailto:LO-Operational@mcmcg.com">LO-Operational@mcmcg.com</a>.</p>'
							+'<p>Thank you,</p>'
							+'<p>LO-Operational</p>';
							
		
		return emailMessageBody;
	}
	
	public static String getSCMDUnmatchedFirstEscalation(Process_Adherence_Monitoring__c pamObj, String contactName, Boolean isCommunityUser){
		
		if(isCommunityUser){
			
			baseUrl = communityBaseUrl;
		}
		
		
		String emailMessageBody = ''; 
		
		emailMessageBody = '<p>Hello '+contactName+',</p>'
							+'<p>Be advised that the Firm\'s remediation to the below request is now <strong>past due</strong>.&nbsp; '
							+'This is time sensitive.&nbsp; All action items are due <strong><u>today</u></strong>.</p>'
            				+'<hr style="border-top: 1px dashed black;margin : 10px 0px 50px 0px; "></hr>'
							
            				+'<p>MCM identified potential discrepancies with the status code information submitted by the Firm.'
            				+'To remediate, Firms must adhere to the process outlined below to enable MCM to reconcile '
            				+'information received from Firms against its records.</p><br/>'
            
            				+'<b>Required Action</b><br/>'
            				+'<p>1.	Select the link to access the "Process Adherence Monitoring" tab within the LC Partner Access '
            				+'Site : <u><a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a>,</u></p>'
            				+'<p>2.	Locate the accounts with discrepancies in the “SCM – Unmatched” section.</p>'
            				+'<p>3.	Populate the Reason for Discrepancy and Reason for Discrepancy Comments within each record</p>'
            				+'<p>4.	Send corresponding status codes</p><br/>'
            
            				+'<p>The Firm must respond by providing the required information within <b>48 hours</b>. </p>'			
            
            
            	
            				/*
            				+'<p>As a result of MCM&rsquo;s dispute status review, MCM identified potential discrepancies with '
							+'the identified accounts that requires the Firm&rsquo;s remediation.</p>'
							+'<p>&nbsp;In order to reconcile our records, access the account information within the '+
							'"Process Adherence Monitoring" tab of the LC Partner Access Site or by selecting this link '
							+'<u><a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a>,</u> '
							+' locate the accounts with discrepancies in the &ldquo;SCMD &ndash; Unmatched&rdquo; '
							+'section and follow the <strong><u>required actions</u></strong> below:</p>'
							+'<ul>'
							+'<li>Review the account discrepancy description within the record;</li>'
							+'<li>Send the missing status codes via YGC that corresponds with the dispute status; and</li>'
							+'<li>Select the appropriate reason that best describes the variation from the drop-down list '
							+'in the "Discrepancy Detail" section.</li>'
							+'</ul>'
							+'<p>The Firm must provide a response within <strong><u>48 hours</u></strong>.</p>'
							*/
            
							+'<p>For any questions, contact <a href="mailto:LO-Operational@mcmcg.com">LO-Operational@mcmcg.com</a>.</p>'
							+'<p>Thank you,</p>'
							+'<p>LO-Operational</p>';
							
		return emailMessageBody;
	}
	
	public static String getSCMDUnmatchedFinalEscalation(Process_Adherence_Monitoring__c pamObj, String contactName, Boolean isCommunityUser){
		
		if(isCommunityUser){
			
			baseUrl = communityBaseUrl;
		}
		
		
		String emailMessageBody = ''; 
		
		emailMessageBody = '<p>Hello '+contactName+',</p>'
							+'<p>Be advised that MCM has not received the Firm&rsquo;s remediation to this request.&nbsp; '
							+'This is time sensitive; therefore, it is critical that we receive a response '
							+'<strong><u>today</u></strong>.&nbsp; Failure to provide a response may result in further escalation.</p>'
            				
							+'<hr style="border-top: 1px dashed black;margin : 10px 0px 50px 0px; "></hr>'
            
            				+'<p>MCM identified potential discrepancies with the status code information submitted by the Firm. '
            				+'To remediate, Firms must adhere to the process outlined below to enable MCM to reconcile '
            				+'information received from Firms against its records. </p>'
            				+'<b>Required Action</b><br/>'
            				+'<p>1.	Select the link to access the "Process Adherence Monitoring" tab within the LC Partner Access '
            				+'Site : <u><a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a></u></p>'
            				+'<p>2.	Locate the accounts with discrepancies in the “SCM – Unmatched” section.</p>'
            				+'<p>3.	Populate the Reason for Discrepancy and Reason for Discrepancy Comments within each record. </p>'
            				+'<p>4.	Send corresponding status codes. </p><br/>'
            				+'<p>The Firm must respond by providing the required information within 48 hours to avoid further escalation.  </p>'
            				/*
            				+'<p>&nbsp;As a result of MCM&rsquo;s dispute status review, MCM identified potential discrepancies '
							+'with the identified account that requires the Firm&rsquo;s remediation.</p>'
							+'<p>&nbsp;In order to reconcile our records, access the account information within the '
							+'"Process Adherence Monitoring" tab of the LC Partner Access Site or by selecting this link '
							+'<u><a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a>,</u> '
							+'locate the accounts with discrepancies in the &ldquo;SCMD &ndash; Unmatched&rdquo; '
							+'section and follow the <strong><u>required actions</u></strong> below:</p>'
							+'<ul>'
							+'<li>Review the account discrepancy description within the record;</li>'
							+'<li>Send the missing status codes via YGC that corresponds with the dispute status; and</li>'
							+'<li>Select the appropriate reason that best describes the variation from the drop-down '
							+'list in the "Discrepancy Detail" section.</li>'
							+'</ul>'
							+'<p>&nbsp;The Firm must provide a response within <strong><u>48 hours</u></strong>.</p>'
							*/

							+'<p>&nbsp;For any questions, contact <a href="mailto:LO-Operational@mcmcg.com">LO-Operational@mcmcg.com</a><u>.</u></p>'
							+'<p>Thank you,</p>'
							+'<p>LO-Operational</p>';
							
		return emailMessageBody;
	}	
	
	public static String getSCMDUnmatchedNoResponseFromFirmTemplate(){
		
        
        String emailMessageBody = '';
        
        emailMessageBody = '<p>Hello,</p>'
            +'<p>Be advised that your Firm identified above has not provided the required monthly dispute status code '
            +'information after <strong><u>eight (8) </u></strong>notifications.'
            //+'At this time, '
            +'To remediate, the Vendor Specialist team is scheduling a call with the Firm Manager to discuss and resolve.</p>'
            
            
            /*
			+'a Vendor Specialist will be setting up a meeting with you and the Firm for further '
			+'discussion and resolve.</p>'*/
            +'<p>Thank you,</p>'
            +'<p>LO-Operational</p>'; 
        
        
		return emailMessageBody;
	}
	// templates used for LO ends
	
	// templates used for ACF start
	public static String getDayOneACFMonthlyTemplateSCM(Process_Adherence_Monitoring__c pamObj, String contactName, Boolean isCommunityUser){
	
		if(isCommunityUser){
			
			baseUrl = communityBaseUrl;
		}
	
		String emailMessageBody = ''; 
    	
    		emailMessageBody = '<p>Hello '+contactName+',</p>'
								+'<p>To ensure all disputed accounts are handled in accordance with the Firm Manual, '
								+'ACF monitors the dispute statuses below that are communicated by Firms, and is in the process of '
								+'reconciling information received from Firms against its records.&nbsp;</p>'
								+'<ul>'
									+'<li>Oral Dispute&nbsp;</li>'
									+'<li>Written Dispute&nbsp;</li>'
									+'<li>Mail Out Validation of Debt&nbsp;</li>'
								+'</ul>'
								+'<p>Select the link below to access the Status Code Monitoring (SCM) '
								+'record within the LC Partner Access Site. Provide each Pcode sent to '
								+'communicate the appropriate dispute status, and a list of ACF account numbers for ALL open '
								+'and closed accounts under each status sent within the previous month '
								+'(ex:&nbsp; January 1- January 31). It is critical that the Firm provides accurate information '
								+'as this may impact the resolution of the reconciliation.</p>'
								+'<a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a></span></p>'
								+'<p>The Firm must provide responses by filling in the required information within '
								+'<strong><u>three (3) business days.</u></strong></p>'
								+'<p>For any questions, contact <a href="mailto:ACF-LOOperational@mcmcg.com">ACF-LOOperational@mcmcg.com</a>.</p>'
								+'<p>Thank you,</p>'
								+'<p>ACF-LOOperational</p>';    							
									
    	return emailMessageBody;
	}
	
	public static String getDayThreeACFMonthlyTemplateSCM(Process_Adherence_Monitoring__c pamObj, String contactName, Boolean isCommunityUser){
	
		if(isCommunityUser){
			
			baseUrl = communityBaseUrl;
		}
		
		String emailMessageBody = ''; 
    	
    		emailMessageBody = '<p>Hello '+contactName+',</p>'
								+'<p>As a reminder the below information is due <strong><u>today.</u></strong></p>'
								+'<p>To ensure all disputed accounts are handled in accordance with the Firm Manual, '
								+'ACF monitors the dispute statuses below that are communicated by Firms, '
								+'and is in the process of reconciling information received from Firms against its records.&nbsp;</p>'
								+'<ul>'
								+'<li>Oral Dispute&nbsp;</li>'
								+'<li>Written Dispute&nbsp;</li>'
								+'<li>Mail Out Validation of Debt&nbsp;</li>'
								+'</ul>'
								+'<p>Select the link below to access the Status Code Monitoring (SCM) record within '
								+'the LC Partner Access Site. Provide each Pcode sent to communicate the appropriate '
								+'dispute status, and a list of ACF account numbers for ALL open and closed accounts '
								+'under each status sent within the previous month (ex:&nbsp; January 1- January 31). '
								+'It is critical that the Firm provides accurate information as this may impact the resolution of the reconciliation.</p>'
								+'<p><u><a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a></u></p>'
								+'<p>The Firm must provide responses by filling in the required information by '
								+'<strong><u>end of business today.</u></strong></p>'
								+'<p>For any questions, contact <a href="mailto:ACF-LOOperational@mcmcg.com">ACF-LOOperational@mcmcg.com</a>.</p>'
								+'<p>Thank you,</p>'
								+'<p>ACF-LOOperational</p>';
									
    	return emailMessageBody;
	}
	
	public static String getACFSecondEscalationTemplateSCM(Process_Adherence_Monitoring__c pamObj, String contactName, Boolean isCommunityUser){
		
		if(isCommunityUser){
			baseUrl = communityBaseUrl;
		}
		String emailMessageBody = ''; 
    		emailMessageBody = '<p>Hello '+contactName+',</p>'
								+'<p>Be advised that the Firm\'s response to the request below is now '
								+'<strong>past due</strong>.&nbsp; This is time sensitive.&nbsp; Please provide '
								+'your response <strong><u>today</u></strong>.</p>'
								+'<p>To ensure all disputed accounts are handled in accordance with the Firm Manual, '
								+'ACF monitors the following dispute statuses communicated by Firms, and is in the '
								+'process of reconciling information received from Firms against its records.&nbsp;&nbsp;</p>'
								+'<ul>'
								+'<li>Oral Dispute&nbsp;</li>'
								+'<li>Written Dispute&nbsp;</li>'
								+'<li>Mail Out Validation of Debt&nbsp;</li>'
								+'</ul>'
								+'<p>Select the link below to access the Status Code Monitoring (SCM) record within '
								+'the LC Partner Access Site. Provide each Pcode sent to communicate the '
								+'appropriate dispute status, and a list of ACF account numbers for ALL open '
								+'and closed accounts under each status sent within the previous '
								+'month (ex:&nbsp; January 1- January 31). It is critical that the '
								+'Firm provides accurate information as this may impact the resolution of the reconciliation.</p>'
								+'<p><u><a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a></u></p>'
								+'<p>For any questions, contact <a href="mailto:ACF-LOOperational@mcmcg.com">ACF-LOOperational@mcmcg.com</a>.</p>'
								+'<p>Thank you,</p>'
								+'<p>ACF-LOOperational</p>';								
									
    	return emailMessageBody;
	}
	
	public static String getACFFinalEscalationTemplateSCM(Process_Adherence_Monitoring__c pamObj, String contactName, Boolean isCommunityUser){
		
		if(isCommunityUser){
			baseUrl = communityBaseUrl;
		}
		String emailMessageBody = ''; 
    		emailMessageBody = '<p>Hello '+contactName+',</p>'
								+'<p>Be advised that MCM has not received the Firm&rsquo;s response to this request.&nbsp; '
								+'This is time sensitive; therefore, it is critical that we receive the response '
								+'<strong><u>today</u></strong>.&nbsp; Failure to provide responses may result in further escalation.</p>'
								+'<p>To ensure all disputed accounts are handled in accordance with the Firm Manual, '
								+'ACF monitors the following dispute statuses communicated by Firms, and is in the '
								+'process of reconciling information received from Firms against its records.&nbsp;&nbsp;</p>'
								+'<ul>'
								+'<li>Oral Dispute&nbsp;</li>'
								+'<li>Written Dispute&nbsp;</li>'
								+'<li>Mail Out Validation of Debt&nbsp;</li>'
								+'</ul>'
								+'<p>Select the link below to access the Status Code Monitoring (SCM) record within '
								+'the LC Partner Access Site. Provide each Pcode sent to communicate the appropriate '
								+'dispute status, and a list of ACF account numbers for ALL open and closed accounts '
								+'under each status sent within the previous month (ex:&nbsp; January 1- January 31). '
								+'It is critical that the Firm provides accurate information as this may impact the '
								+'resolution of the reconciliation.</p>'
								+'<p><u><a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a></u></p>'
								+'<p>For any questions, contact <u>'
								+'<a href="mailto:ACF-LOOperational@mcmcg.com">&nbsp;ACF-LOOperational@mcmcg.com </a></p>'
								+'<p>Thank you,</p>'
								+'<p>ACF-LOOperational</p>';								
									
    	return emailMessageBody;
	}
	
	// for unmatched starts
	
	public static String getSCMDUnmatchedACFOnCreateTemplate(Process_Adherence_Monitoring__c pamObj, String contactName, Boolean isCommunityUser){
		
		if(isCommunityUser){
			baseUrl = communityBaseUrl;
		}
		
		String emailMessageBody = ''; 
		emailMessageBody = '<p>Hello '+contactName+',</p>'
							+'<p>As a result of ACF&rsquo;s dispute status review, MCM identified potential discrepancies with the identified accounts' 
							+' that requires the Firm&rsquo;s remediation.</p>'
							+'<p>&nbsp;In order to reconcile our records, access the account information within ' 
							+'the "Process Adherence Monitoring" tab of the LC Partner Access Site or by selecting this link ' 
							+'<u><a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a></u>'
							+' locate the accounts with discrepancies in the &ldquo;SCMD &ndash; '
							+'Unmatched&rdquo; section and follow the <strong><u>required actions</u></strong> below:</p>'
							+'<p>&nbsp;</p>'
							+'<ul>'
							+'<li>Review the account discrepancy description within the record;</li>'
							+'<li>Send the missing status codes via YGC ' 
							+'that corresponds with the dispute status; and</li>'
							+'<li>Select the appropriate reason that best describes' 
							+'the variation from the drop-down list in the "Discrepancy Detail" section.</li>'
							+'</ul>'
							+'<p>The Firm must provide a response within <strong><u>48 hours</u></strong>.</p>'
							+'<p>For any questions, contact <a href="mailto:ACF-LOOperational@mcmcg.com">ACF-LOOperational@mcmcg.com</a>.</p>'
							+'<p>&nbsp;</p>'
							+'<p>Thank you,</p>'
							+'<p>ACF-LOOperational</p>';
		
		return emailMessageBody;
	}
	
	public static String getSCMDUnmatchedACFFirstEscalation(Process_Adherence_Monitoring__c pamObj, String contactName, Boolean isCommunityUser){
		
		if(isCommunityUser){
			baseUrl = communityBaseUrl;
		}
		
		String emailMessageBody = ''; 
		emailMessageBody = '<p>Hello '+contactName+',</p>'
							+'<p>Be advised that MCM has not received the Firm&rsquo;s remediation to this '
							+'request.&nbsp; This is time sensitive; therefore, it is critical that we receive a response'
							+' <strong><u>today</u></strong>.&nbsp; Failure to provide a response may result '
							+'in further escalation.</p>'
							+'<p>As a result of ACF&rsquo;s dispute status review, MCM identified potential discrepancies with '
							+'the identified account that requires the Firm&rsquo;s remediation.</p>'
							+'<p>In order to reconcile our records, access the account information within '
							+'the "Process Adherence Monitoring" tab of the LC Partner Access Site or by '
							+'selecting this link '
							+'<u><a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a>,</u> '
							+'locate the accounts with discrepancies in the &ldquo;SCMD &ndash; Unmatched&rdquo; '
							+'section and follow the <strong><u>required actions</u></strong> below:</p>'
							+'<p>&nbsp;</p>'
							+'<ul>'
							+'<li>Review the account discrepancy description within the record;</li>'
							+'<li>Send the missing status codes via YGC that corresponds with the dispute status; and</li>'
							+'<li>Select the appropriate reason that best describes the variation from the drop-down '
							+'list in the "Discrepancy Detail" section.</li>'
							+'</ul>'
							+'<p>The Firm must provide a response within <strong><u>24 hours</u></strong>.</p>'
							+'<p>For any questions, contact <a href="mailto:ACF-LOOperational@mcmcg.com">ACF-LOOperational@mcmcg.com</a>.</p>'
							+'<p>Thank you,</p>'
							+'<p>ACF-LOOperational</p>';							
		return emailMessageBody;
	}
	
	public static String getSCMDACFUnmatchedFinalEscalation(Process_Adherence_Monitoring__c pamObj, String contactName, Boolean isCommunityUser){
		
		if(isCommunityUser){
			
			baseUrl = communityBaseUrl;
		}
		
		String emailMessageBody = ''; 
		emailMessageBody = '<p>Hello '+contactName+',</p>'
							+'<p>Be advised that MCM has not received the Firm&rsquo;s remediation to this request.&nbsp; '
							+'This is time sensitive; therefore, it is critical that we receive a response '
							+'<strong><u>today</u></strong>.&nbsp; Failure to provide a response may result in further escalation.</p>'
							+'<p>&nbsp;As a result of ACF&rsquo;s dispute status review, MCM identified potential discrepancies '
							+'with the identified account that requires the Firm&rsquo;s remediation.</p>'
							+'<p>&nbsp;In order to reconcile our records, access the account information within the '
							+'"Process Adherence Monitoring" tab of the LC Partner Access Site or by selecting this link '
							+'<u><a href="'+baseUrl+'/'+pamObj.Id+'">'+pamObj.Name+'</a>,</u> '
							+'locate the accounts with discrepancies in the &ldquo;SCMD &ndash; Unmatched&rdquo; '
							+'section and follow the <strong><u>required actions</u></strong> below:</p>'
							+'<ul>'
							+'<li>Review the account discrepancy description within the record;</li>'
							+'<li>Send the missing status codes via YGC that corresponds with the dispute status; and</li>'
							+'<li>Select the appropriate reason that best describes the variation from the drop-down '
							+'list in the "Discrepancy Detail" section.</li>'
							+'</ul>'
							+'<p>&nbsp;The Firm must provide a response within <strong><u>24 hours</u></strong>.</p>'
							+'<p>&nbsp;For any questions, contact <a href="mailto:ACF-LOOperational@mcmcg.com">ACF-LOOperational@mcmcg.com</a>.</p>'
							+'<p>Thank you,</p>'
							+'<p>ACF-LO-Operational</p>';
							
		return emailMessageBody;
	}
	
	public static String getSCMDACFUnmatchedNoResponseFromFirmTemplate(){
		
		
		String emailMessageBody = '';
		
				emailMessageBody = '<p>Hello,</p>'
									+'<p>Be advised that your Firm has not provided the required monthly dispute status code '
									+'information after <strong><u>eight (8) </u></strong>notifications.&nbsp; At this time, '
									+'a Vendor Specialist will be setting up a meeting with you and the Firm for further '
									+'discussion and resolution.</p>'
									+'<p>Thank you,</p>'
									+'<p>ACF-LOOperational</p>'; 
		
							
		return emailMessageBody;
	}
	
	// unmatched ends
	
	// templates used for ACF ends
	
}