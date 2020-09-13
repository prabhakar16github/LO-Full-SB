public class IR_EmailCommunicationTemplates {
	
	public static String sfbaseUrl{
		get{
			return sfbaseUrl == null ? String.valueOf(System.Url.getSalesforceBaseUrl().toExternalForm()) : sfbaseUrl;  
		}set;
	}
	
	public static String communityBaseUrl;
	
	static{
		
		communityBaseUrl = communityBaseUrl == null ? String.valueOf(Utils.getCommunityBaseUrl()) : communityBaseUrl;
	}
 
 	public static String initialNotificationTemplate(IRCommunicationWrapper irWrapObj){
 	
 		String htmlBody = '<p>Hello '+irWrapObj.contactFirstName+',</p>';
				htmlBody +=	'<p>*Cut-off date - '+(irWrapObj.cutOffDate == null ? '' : irWrapObj.cutOffDate)+'<br /> ';
				htmlBody += '<br />*File Due to MCM - '+(irWrapObj.filesDueToMCM == null ? '' : irWrapObj.filesDueToMCM)+'<br />';
				htmlBody += ' <br />*Action Item Completed - '+(irWrapObj.actionItemCompleted == null ? '' : irWrapObj.actionItemCompleted)+'<br />';
				htmlBody += '<br />For your convenience, we will always accept your file prior to the File Due ';
				htmlBody += 'to MCM due date.<br /> <br />For any questions, contact ';
				htmlBody += '<a href="mailto:lo-inventoryrecon@mcmcg.com">lo-inventoryrecon@mcmcg.com</a>.</p>';
				htmlBody += '<p>Thank you,</p>';
				htmlBody += '<p>LO-Inventoryrecon</p>';
							
		
		return htmlBody;
 	}
 	
 	public static String dayBeforeCutoffNotificationTemplate(IRCommunicationWrapper irWrapObj){
 		
 		
		String baseUrl = getBaseUrl(irWrapObj.isCommmunityUser);
 		
 		String htmlBody = '<p>Hello '+irWrapObj.contactFirstName+',</p>';
				htmlBody +='<p>*Cut-off date - '+(irWrapObj.cutOffDate == null ? '' : irWrapObj.cutOffDate)+'<br /> ';
				htmlBody +=	'<br />*File Due to MCM - '+(irWrapObj.filesDueToMCM == null ? '' : irWrapObj.filesDueToMCM)+'<br /> ';
				htmlBody +=	'<br />*Action Item Completed - '+(irWrapObj.actionItemCompleted == null ? '' : irWrapObj.actionItemCompleted)+'</p>';
				htmlBody +=	'<p>&nbsp;</p>';
				htmlBody +=	'<p>Select the link below to access the Inventory Reconciliation (IR) record within ';
				htmlBody +=	'the LC Partner Access Site.&nbsp; Provide a list of MCM account numbers for all open inventory.';
				htmlBody +=	'&nbsp; It is critical that the Firm provides accurate information as this may ';
				htmlBody +=	'impact the resolution of the reconciliation.</p>';
				htmlBody +=	'<p>&nbsp;<u><a href="'+ baseUrl+'/' + irWrapObj.pamObj.Id+'">'+irWrapObj.pamObj.Name+'</a></u></p>';
				htmlBody +=	'<p>The Firm must provide responses by filling in the required information ';
				htmlBody +=	'by '+irWrapObj.filesDueToMCM == null ? '' : irWrapObj.filesDueToMCM+'.</p>';
				htmlBody +=	'<p>For any questions, contact <a href="mailto:lo-inventoryrecon@mcmcg.com">';
				htmlBody +=	'lo-inventoryrecon@mcmcg.com</a>.</p>';
				htmlBody +=	'<p>&nbsp;</p>';
				htmlBody += '<p>Thank you,</p>';
				htmlBody += '<p>LO-Inventoryrecon</p>';
							
		return htmlBody;
		
 	}
 	
 	
 	public static String reminderNotificationTemplate(IRCommunicationWrapper irWrapObj){
 		
 		
		String baseUrl = getBaseUrl(irWrapObj.isCommmunityUser);
 	
 		String htmlBody = '<p>Hello '+irWrapObj.contactFirstName+',</p>';
				htmlBody += '<p>*Cut-off date - '+(irWrapObj.cutOffDate == null ? '' : irWrapObj.cutOffDate)+'<br /> ';
				htmlBody += '<br />*File Due to MCM - '+(irWrapObj.filesDueToMCM == null ? '' : irWrapObj.filesDueToMCM)+'<br /> ';
				htmlBody += '<br />*Action Item Completed - '+(irWrapObj.actionItemCompleted == null ? '' : irWrapObj.actionItemCompleted)+'</p>';
				htmlBody += '<p>As a reminder the below information is due tomorrow.</p>';
				htmlBody += '<p>Select the link below to access the Inventory Reconciliation (IR) record within ';
				htmlBody += 'the LC Partner Access Site.&nbsp; Provide a list of MCM account numbers for all ';
				htmlBody += 'open inventory.&nbsp; It is critical that the Firm provides accurate information as this ';
				htmlBody += 'may impact the resolution of the reconciliation.</p>';
				htmlBody += '<p><u><a href="'+ baseUrl+'/' + irWrapObj.pamObj.Id+'">'+irWrapObj.pamObj.Name+'</a></u></p>';
				htmlBody += '<p>The Firm must provide responses by filling in the required information ';
				htmlBody += 'by '+irWrapObj.filesDueToMCM == null ? '' : irWrapObj.filesDueToMCM+'.</p>';
				htmlBody += '<p>For any questions, contact ';
				htmlBody += '<a href="mailto:lo-inventoryrecon@mcmcg.com">lo-inventoryrecon@mcmcg.com</a>.</p>';
				htmlBody += '<p></p>';
				htmlBody += '<p>Thank you,</p>';
				htmlBody += '<p>LO-Inventoryrecon</p>';
							
		return htmlBody;
 	}
 	
 	
 	public static String finalReminderNotificationTemplate(IRCommunicationWrapper irWrapObj){
 		
 		
		String baseUrl = getBaseUrl(irWrapObj.isCommmunityUser);
 	
 		String htmlBody = '<p>Hello '+irWrapObj.contactFirstName+',</p>';
				htmlBody += '<p>*Cut-off date - '+(irWrapObj.cutOffDate == null ? '' : irWrapObj.cutOffDate)+'<br />';
				htmlBody += '<br />*File Due to MCM - '+(irWrapObj.filesDueToMCM == null ? '' : irWrapObj.filesDueToMCM)+'<br />';
				htmlBody += '<br />*Action Item Completed - '+(irWrapObj.actionItemCompleted == null ? '' : irWrapObj.actionItemCompleted)+'</p>';
				htmlBody += '<p>As a reminder the below information is due <strong><u>today</u></strong>.</p>';
				htmlBody += '<p>Select the link below to access the Inventory Reconciliation (IR) record within ';
				htmlBody += 'the LC Partner Access Site.&nbsp; Provide a list of MCM account numbers for all open inventory.&nbsp; ';
				htmlBody += 'It is critical that the Firm provides accurate information as this may ';
				htmlBody += 'impact the resolution of the reconciliation.</p>';
				htmlBody += '<p><u><a href="'+ baseUrl+'/' + irWrapObj.pamObj.Id+'">'+irWrapObj.pamObj.Name+'</a></u></p>';
				htmlBody += '<p>The Firm must provide responses by filling in the required information ';
				htmlBody += 'by '+irWrapObj.filesDueToMCM == null ? '' : irWrapObj.filesDueToMCM+'.</p>';
				htmlBody += '<p>For any questions, contact ';
				htmlBody += '<a href="mailto:lo-inventoryrecon@mcmcg.com">lo-inventoryrecon@mcmcg.com</a>.</p>';
				htmlBody += '<p>&nbsp;</p>';
				htmlBody += '<p>Thank you,</p>';
				htmlBody += '<p>LO-Inventoryrecon</p>';
							
			return htmlBody;
 	}
 	
 	
 	public static String finalEscalatiponNotificationTemplate(IRCommunicationWrapper irWrapObj){
 		
 		
		String baseUrl = getBaseUrl(irWrapObj.isCommmunityUser);
 	
 		String htmlBody = '<p>Hello '+irWrapObj.contactFirstName+',</p>';
				htmlBody += '<p>*Cut-off date - '+(irWrapObj.cutOffDate == null ? '' : irWrapObj.cutOffDate)+'<br /> ';
				htmlBody += '<br />*File Due to MCM - '+(irWrapObj.filesDueToMCM == null ? '' : irWrapObj.filesDueToMCM)+'<br /> ';
				htmlBody += '<br />*Action Item Completed - '+(irWrapObj.actionItemCompleted == null ? '' : irWrapObj.actionItemCompleted)+'</p>';
				htmlBody += '<p>Be advised that the Firm\'s response to the request below is now ';
				htmlBody += '<strong>past due</strong>.&nbsp; This is time sensitive.&nbsp; ';
				htmlBody += 'Please provide your response <strong><u>today</u></strong>.</p>';
				htmlBody += '<p>Select the link below to access the Inventory Reconciliation (IR) ';
				htmlBody += 'record within the LC Partner Access Site.&nbsp; Provide a list of ';
				htmlBody += 'MCM account numbers for all open inventory.&nbsp; It is critical that ';
				htmlBody += 'the Firm provides accurate information as this may impact the resolution of the reconciliation.</p>';
				htmlBody += '<p><u><a href="'+ baseUrl+'/' + irWrapObj.pamObj.Id+'">'+irWrapObj.pamObj.Name+'</a></u></p>';
				htmlBody += '<p>The Firm must provide responses by filling in the required information ';
				htmlBody += 'by '+irWrapObj.filesDueToMCM == null ? '' : irWrapObj.filesDueToMCM+'.</p>';
				htmlBody += '<p>For any questions, contact ';
				htmlBody += '<a href="mailto:lo-inventoryrecon@mcmcg.com">lo-inventoryrecon@mcmcg.com</a>.</p>';
				htmlBody += '<p>&nbsp;</p>';
				htmlBody += '<p>Thank you,</p>';
				htmlBody += '<p>LO-Inventoryrecon</p>';
							
			return htmlBody;				
 	}
 	
 	public static String noResponseNotificationTemplate(){
 		
 		String htmlBody = '<p>Hello,</p>';
 				htmlBody += '<p>Be advised that your Firm has not provided the required monthly Inventory reconciliation ';
 				htmlBody += 'open file after <strong><u>seven (7)</u></strong> notifications.&nbsp; At this time, the ';
 				htmlBody += 'Vendor Specialist will be setting up a meeting with you and the Firm for further discussion and resolution.</p>';
 				htmlBody += '<p>Thank you,</p>';
				htmlBody += '<p>LO-Inventoryrecon</p>';
			
		return htmlBody;
 	}
 	
 	
 	// for unmatched process
 	
 	public static String onCreateUnmatched(IRCommunicationWrapper irWrapObj){
 		
 		String baseUrl = getBaseUrl(irWrapObj.isCommmunityUser);
 		
 		String htmlBody = '<p>Hello '+irWrapObj.contactFirstName+',</p>';
			htmlBody += '<p>MCM identified discrepancies with the identified account(s) that require the Firm&rsquo;s remediation.</p>';
			htmlBody += '<p>To reconcile our records, access the account information within the "Process Adherence Monitoring" ';
			htmlBody += 'tab of the LC Partner Access Site or by selecting this link ';
			htmlBody += '<u><a href="'+ baseUrl+'/' + irWrapObj.pamObj.Id+'">'+irWrapObj.pamObj.Name+'</a>,</u> ';
			htmlBody += 'locate the accounts with discrepancies in the &ldquo;IR &ndash; Unmatched&rdquo; section and follow the ';
			htmlBody += '<strong><u>required actions</u></strong> below:&nbsp;</p>';
			htmlBody += '<ul>';
			htmlBody += '<li>Review the account discrepancy description within the record</li>';
			htmlBody += '<li>CA20 Open/Firm Closed:</li>';
			htmlBody += '</ul>';
			htmlBody += '<ul>';
			htmlBody += '<ul>';
			htmlBody += '<li>Open with firm</li>';
			htmlBody += '<li>Timing</li>';
			htmlBody += '<li>Inactive close code used</li>';
			htmlBody += '<li>Close code re-sent</li>';
			htmlBody += '</ul>';
			htmlBody += '</ul>';
			htmlBody += '<ul>';
			htmlBody += '<li>Firm Open/MCM Closed:</li>';
			htmlBody += '</ul>';
			htmlBody += '<ul>';
			htmlBody += '<ul>';
			htmlBody += '<li>Legal obligation</li>';
			htmlBody += '<li>Sent reopen request to <a href="mailto:LO-Operational@mcmcg.com">LO-Operational@mcmcg.com</a></li>';
			htmlBody += '<li>Reopened in error &ndash; now closed</li>';
			htmlBody += '<li>Closed with Firm</li>';
			htmlBody += '</ul>';
			htmlBody += '</ul>';
			htmlBody += '<p>As a reminder the resolution of all action items needs to be completed by the 10<sup>th</sup> of the month.&nbsp;</p>';
			htmlBody += '<p>For any questions, contact <a href="mailto:lo-inventoryrecon@mcmcg.com">lo-inventoryrecon@mcmcg.com</a>.</p>';
			htmlBody += '<p>&nbsp;</p>';
			htmlBody += '<p>Thank you,</p>';
			htmlBody += '<p>LO-Inventoryrecon</p>';
				
		return htmlBody;
 	}
 	
 	
 	public static String reminderNotificationUnmatched(IRCommunicationWrapper irWrapObj){
 		
 		String baseUrl = getBaseUrl(irWrapObj.isCommmunityUser);
 		
		String htmlBody = '<p>Hello '+irWrapObj.contactFirstName+',</p>';
			htmlBody += '<p>MCM identified discrepancies with the identified account(s) that require the Firm&rsquo;s remediation.</p>';
			htmlBody += '<p>To reconcile our records, access the account information within the "Process Adherence Monitoring" tab ';
			htmlBody += 'of the LC Partner Access Site or by selecting this link ';
			htmlBody += '<u><a href="'+ baseUrl+'/' + irWrapObj.pamObj.Id+'">'+irWrapObj.pamObj.Name+'</a>,</u> ';
			htmlBody += ' locate the accounts with discrepancies in the &ldquo;IR &ndash; Unmatched&rdquo; section and ';
			htmlBody += 'follow the <strong><u>required actions</u></strong> below:&nbsp;</p>';
			htmlBody += '<ul>';
			htmlBody += '<li>Review the account discrepancy description within the record</li>';
			htmlBody += '<li>CA20 Open/Firm Closed:</li>';
			htmlBody += '</ul>';
			htmlBody += '<ul>';
			htmlBody += '<ul>';
			htmlBody += '<li>Open with firm</li>';
			htmlBody += '<li>Timing</li>';
			htmlBody += '<li>Inactive close code used</li>';
			htmlBody += '<li>Close code re-sent</li>';
			htmlBody += '</ul>';
			htmlBody += '</ul>';
			htmlBody += '<ul>';
			htmlBody += '<li>Firm Open/MCM Closed:</li>';
			htmlBody += '</ul>';
			htmlBody += '<ul>';
			htmlBody += '<ul>';
			htmlBody += '<li>Legal obligation</li>';
			htmlBody += '<li>Sent reopen request to <a href="mailto:LO-Operational@mcmcg.com">LO-Operational@mcmcg.com</a></li>';
			htmlBody += '<li>Reopened in error &ndash; now closed</li>';
			htmlBody += '<li>Closed with Firm</li>';
			htmlBody += '</ul>';
			htmlBody += '</ul>';
			htmlBody += '<p>As a reminder the resolution of all action items needs to be completed by the 10<sup>th</sup> of the month.&nbsp;</p>';
			htmlBody += '<p>For any questions, contact <a href="mailto:lo-inventoryrecon@mcmcg.com">lo-inventoryrecon@mcmcg.com</a>.</p>';
			htmlBody += '<p>Thank you,</p>';
			htmlBody += '<p>LO-Inventoryrecon</p>'; 		
				
		return htmlBody;
 	}
 	
 	public static String firstEscalationNotificationUnmatched(IRCommunicationWrapper irWrapObj){
 		
 		String baseUrl = getBaseUrl(irWrapObj.isCommmunityUser);
		String htmlBody = '<p>Hello '+irWrapObj.contactFirstName+',</p>';
		        htmlBody += '<p>MCM identified discrepancies with the identified account(s) that require the Firm&rsquo;s remediation.</p>';
		        htmlBody += '<p>To reconcile our records, access the account information within the "Process Adherence Monitoring" '; 
		        htmlBody += 'tab of the LC Partner Access Site or by selecting this link ';
		        htmlBody += '<u><a href="'+ baseUrl+'/' + irWrapObj.pamObj.Id+'">'+irWrapObj.pamObj.Name+'</a>,</u> ';
		        htmlBody += 'locate the accounts with discrepancies in the &ldquo;IR &ndash; Unmatched&rdquo; section and follow the ';
		        htmlBody += '<strong><u>required actions</u></strong> below:</p>';
		        htmlBody += '<ul>';
		        htmlBody += '<li>Review the account discrepancy description within the record</li>';
		        htmlBody += '<li>CA20 Open/Firm Closed:</li>';
		        htmlBody += '</ul>';
		        htmlBody += '<ul>';
		        htmlBody += '<ul>';
		        htmlBody += '<li>Open with firm</li>';
		        htmlBody += '<li>Timing</li>';
		        htmlBody += '<li>Inactive close code used</li>';
		        htmlBody += '<li>Close code re-sent</li>';
		        htmlBody += '</ul>';
		        htmlBody += '</ul>';
		        htmlBody += '<ul>';
		        htmlBody += '<li>Firm Open/MCM Closed:</li>';
		        htmlBody += '</ul>';
		        htmlBody += '<ul>';
		        htmlBody += '<ul>';
		        htmlBody += '<li>Legal obligation</li>';
		        htmlBody += '<li>Sent reopen request to <a href="mailto:LO-Operational@mcmcg.com">LO-Operational@mcmcg.com</a></li>';
		        htmlBody += '<li>Reopened in error &ndash; now closed</li>';
		        htmlBody += '<li>Closed with Firm</li>';
		        htmlBody += '</ul>';
		        htmlBody += '</ul>';
		        htmlBody += '<p>Resolution of action items is now <strong>past due.</strong></p>';
		        htmlBody += '<p>For any questions, contact <a href="mailto:lo-inventoryrecon@mcmcg.com">lo-inventoryrecon@mcmcg.com</a>.</p>';
		        htmlBody += '<p></p>';
		        htmlBody += '<p>Thank you,</p>';
				htmlBody += '<p>LO-Inventoryrecon</p>'; 		
 		return htmlBody;
 	}
 	
 	public static String finalEscalationNotificationUnmatched(IRCommunicationWrapper irWrapObj){
 		
 		String baseUrl = getBaseUrl(irWrapObj.isCommmunityUser);
 		
		String htmlBody = '<p>Hello '+irWrapObj.contactFirstName+',</p>';
			htmlBody += '<p>MCM identified discrepancies with the identified account(s) that require the Firm&rsquo;s remediation.</p>';
			htmlBody += '<p>To reconcile our records, access the account information within the "Process Adherence Monitoring"';
			htmlBody += ' tab of the LC Partner Access Site or by selecting this link ';
			htmlBody += '<u><a href="'+ baseUrl+'/' + irWrapObj.pamObj.Id+'">'+irWrapObj.pamObj.Name+'</a>,</u> ';
			htmlBody += ' locate the accounts with discrepancies in the &ldquo;IR &ndash; Unmatched&rdquo; ';
			htmlBody += 'section and follow the <strong><u>required actions</u></strong> below:&nbsp;</p>';
			htmlBody += '<ul>';
			htmlBody += '<li>Review the account discrepancy description within the record</li>';
			htmlBody += '<li>CA20 Open/Firm Closed:</li>';
			htmlBody += '</ul>';
			htmlBody += '<ul>';
			htmlBody += '<ul>';
			htmlBody += '<li>Open with firm</li>';
			htmlBody += '<li>Timing</li>';
			htmlBody += '<li>Inactive close code used</li>';
			htmlBody += '<li>Close code re-sent</li>';
			htmlBody += '</ul>';
			htmlBody += '</ul>';
			htmlBody += '<ul>';
			htmlBody += '<li>Firm Open/MCM Closed:</li>';
			htmlBody += '</ul>';
			htmlBody += '<ul>';
			htmlBody += '<ul>';
			htmlBody += '<li>Legal obligation</li>';
			htmlBody += '<li>Sent reopen request to <a href="mailto:LO-Operational@mcmcg.com">LO-Operational@mcmcg.com</a></li>';
			htmlBody += '<li>Reopened in error &ndash; now closed</li>';
			htmlBody += '<li>Closed with Firm</li>';
			htmlBody += '</ul>';
			htmlBody += '</ul>';
			htmlBody += '<p>Resolution of action items is now <strong>past due.</strong></p>';
			htmlBody += '<p>For any questions, contact <a href="mailto:lo-inventoryrecon@mcmcg.com">lo-inventoryrecon@mcmcg.com</a>.</p>';
			htmlBody += '<p>&nbsp;</p>';
			htmlBody += '<p>Thank you,</p>';
			htmlBody += '<p>LO-Inventoryrecon</p>';
				
		return htmlBody;
 	}
 	
 	public static String noReponseUnmatched(){

		String htmlBody = '<p>Hello,</p>';
			htmlBody += '<p>Be advised that your firm has not reconciled the discrepancies identified in the monthly ';
			htmlBody += 'inventory reconciliation.&nbsp; At this time, a Vendor Specialist will be setting up a meeting with ';
			htmlBody += 'you and the Firm for further discussion and resolution.</p>';
			htmlBody += '<p>&nbsp;</p>';
			htmlBody += '<p>Thank you,</p>';
			htmlBody += '<p>LO-Inventoryrecon</p>';
			
 		return htmlBody;
 	}
 	
 	public static String getBaseUrl(Boolean isCommunityUser){
 		
 		String baseUrlValue = '';
 		
 		if(isCommunityUser){
 			
 			baseUrlValue = communityBaseUrl;
 			
 		}else{
 			
 			baseUrlValue = sfbaseUrl;
 		}
 		
 		return baseUrlValue;
 		
 	}
 	
 	
 	public class IRCommunicationWrapper{
 		
 		public String contactFirstName {set; get;}
 		public String cutOffDate {set; get;}
 		public String filesDueToMCM {set; get;}
 		public String actionItemCompleted {set; get;}
 		public Process_Adherence_Monitoring__c pamObj {set; get;}
 		public Boolean isCommmunityUser {set; get;}
 		public String contactEmail {set; get;}
 		
 	}   
}