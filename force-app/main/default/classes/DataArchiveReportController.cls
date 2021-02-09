/*
 * @ Class Name      :     DataArchiveReportController
 * @ Description     :     Controller Class for DataArchiveReport VF Page
 * @ Created By      :     Prabhakar Joshi
 * @ Created Date    :     1-Apr-2020
 * @ Last Modified   :     16-Nov-2020
 */
public class DataArchiveReportController{
	/* To set the current tab name */
	public String tabName{ get; set; }

	/* To set the chart data */
	public List<PieData> chartData{ get;private  set; }

	/* To set the  count of data for Archive */
	public Integer totalArchiveData{ get;private  set; }

	/** To set the count of EmailMessages from Archive on Case Tab. */
	public Integer archiveEmailCount{ get; private set; }

	/* To set the data of current tab */
	public String dataType{ get;private  set; }

	/* To Set the Count of Total Attachments in the Org */
	public Integer totalAttachmentData{ get;private  set; }

	/* To Set the Count of Total EmailMessages in the Org */
	public Integer totalEmailCount{ get;private  set; }

	/* To hold the date of 6 months before */
	private Date sixMonthBeforeDate = System.today().addMonths(-6);

	/* To hold the date of 12 months before */
	private Date oneYearBeforeDate = System.today().addMonths(-12);

	/* To hold the LC Admin Email Id to send the notification after Data Archived. */
	public static FINAL String LCAdminEmail = 'lcsalesforceadmin@mcmcg.com';

	/** To set the limit of data to be Archive using custom label. */
	public static FINAL Integer ARCHIVE_DATA_LIMIT = Integer.valueOf(Label.ArchiveDataLimit) > 40000 ? 40000 : Integer.valueOf(Label.ArchiveDataLimit);
	
	/** To hold the number of records that will archive at one time. */
	public String infoMsg{ get;private set; }
	
	/* Constructor */
	public DataArchiveReportController(){
		infoMsg = ARCHIVE_DATA_LIMIT+' records will be archive at one time. Change the limit from custom label ArchiveDataLimit. Max - 40000';
		totalEmailCount = 0;
		totalAttachmentData = 0;
		
		tabName = 'LRMM_Tab';
		dataType = 'LRMM';

		for (AggregateResult agg : [SELECT count(Id)totalAcc
		                            FROM Attachment]){
			totalAttachmentData = (Integer)agg.get('totalAcc');
		}
		init();
	}

	/* @ Method is Calling from constructor */
	public void init(){

		totalArchiveData = 0;
		archiveEmailCount = 0;
		chartData = new List<PieData>();

		if (tabName == 'LRMM_Tab'){
			chartData = fetchLRMMChartData();
			dataType = 'LRMM';
		} else if (tabName == 'CM_Tab'){
			chartData = fetchCallMonitoringChartData();
			dataType = 'Call Monitoring';
		} else if (tabName == 'PAM_Tab'){
			chartData = fetch_PAM_ChartData();
			dataType = 'PAM';
		} else if (tabName == 'CS_Tab'){
			chartData = fetch_Case_ChartData();
			dataType = 'Case';
		}
	}

	/* @ Method to get the LRMM Chart Data */
	/** Last Modified By - Prabhakar Joshi on 2-Feb-2021. */
	private List<PieData> fetchLRMMChartData(){
		LRMM_DataArchiveHandler handler = new LRMM_DataArchiveHandler();
		return this.setDataForChart(handler.getLRMMDataCountMap());
	}

	/* @ Method to get the Call Monitoring Chart Data */
	/** Need to optimize the code. */
	private List<PieData> fetchCallMonitoringChartData(){
		List<PieData> CM_Att_data = new List<PieData>();
		Set<Id> cmIdSet = new Set<Id>();
		Set<String> oneYearBeforeRecordTypeSet = new Set<String>{'CM Materials Results 20180701', 'CM Remediation 20180701'};
		Set<String> otherRecordTypeSet = new Set<String>{'Call Monitoring QA', 'Call Monitoring Log', 'Call Monitoring Materials'};
		for (Call_Monitoring__c cm : [SELECT Id, RecordType.Name
		                              FROM Call_Monitoring__c
		                              WHERE (RecordType.Name IN :otherRecordTypeSet AND LastModifiedDate < :sixMonthBeforeDate) OR (((RecordType.Name = 'CM Remediation 20180701' AND Firm_Remediation_Complete__c = true) OR (RecordType.Name = 'CM Materials Results 20180701')) AND LastModifiedDate < :oneYearBeforeDate)]){
			cmIdSet.add(cm.Id);
		}
		if (cmIdSet.size() > 0){
			Map<String, Integer> recordTypeToAttCountMap = new Map<String, Integer>();
			for (AggregateResult att : [SELECT COUNT(Id)totalCount, Parent.RecordType.Name recordType
			                            FROM Attachment
			                            WHERE ParentId IN :cmIdSet AND ((Parent.RecordType.Name NOT IN :oneYearBeforeRecordTypeSet AND LastModifiedDate < :sixMonthBeforeDate) OR (Parent.RecordType.Name IN :oneYearBeforeRecordTypeSet AND LastModifiedDate < :oneYearBeforeDate))
			                            GROUP BY Parent.RecordType.Name]){
				recordTypeToAttCountMap.put(String.valueOf(att.get('recordType')), (Integer)att.get('totalCount'));

			}
			if (recordTypeToAttCountMap.keySet().size() > 0){
				for (String rt : recordTypeToAttCountMap.keySet()){
					CM_Att_data.add(new PieData(rt + ' : ' + recordTypeToAttCountMap.get(rt), recordTypeToAttCountMap.get(rt)));
					totalArchiveData += recordTypeToAttCountMap.get(rt);
				}
			}
		}
		return CM_Att_data;
	}

	/* @ Method to get the PAM Chart Data */
	/** Last Modified By - Prabhakar Joshi on 2-Feb-2021. */
	private List<PieData> fetch_PAM_ChartData(){
		PAM_DataArchiveHandler handler = new PAM_DataArchiveHandler();
		return this.setDataForChart(handler.getPAMDataCountMap());
	}

	/* @ Method to get the Case Chart Data */
	/* @ Added on 8-July-2020. */
	/** Last Modified By - Prabhakar Joshi on 2-Feb-2021. */
	private List<PieData> fetch_Case_ChartData(){
		Case_DataArchiveHandler handler = new Case_DataArchiveHandler();
		return this.setDataForChart(handler.getCaseDataCountMap());
	}

	private List<PieData> setDataForChart(Map<String, Integer> dataMap){
		List<PieData> dataForChart = new List<PieData>();
		if(tabName == 'CS_Tab'){
			for (AggregateResult agg : [SELECT count(Id)totalEmailCount
										FROM EmailMessage]){
											totalEmailCount = (Integer)agg.get('totalEmailCount');
			}
			 
			totalArchiveData = dataMap.get('Attachment');
			archiveEmailCount = dataMap.get('EmailMessage');
			dataForChart.add(new PieData('Attachment : ' + totalArchiveData, totalArchiveData));
			dataForChart.add(new PieData('EmailMessage : ' + archiveEmailCount, archiveEmailCount));
			
		}else{
			for (String obj : dataMap.keySet()){
				Integer dataCount = dataMap.get(obj);
				if(dataCount > 0){
					dataForChart.add(new PieData(obj + ' : ' + dataCount, dataCount));
					totalArchiveData += dataCount;
				}
			}
		}
		
		return dataForChart;
	}

	/* @ Remote Action calling from JAVA Script to invoke the batch class which is Archiving the data. */
	@RemoteAction
	public static Id archiveData(String activeTab){
		if (!toggleAttachmentTrigger()){
			Integer batchSize = Integer.valueOf(label.Data_Archive_Batch_Size) <= 2000 ? Integer.valueOf(label.Data_Archive_Batch_Size) : 2000;
			Id batchJobId;
			if (activeTab == 'LRMM_Tab'){
				batchJobId = Database.executeBatch(new LRMM_DataArchiveBatch(), batchSize);
			} else if (activeTab == 'CM_Tab'){
				batchJobId = Database.executeBatch(new CM_DataArchiveBatch(), batchSize);
			} else if (activeTab == 'PAM_Tab'){
				batchJobId = Database.executeBatch(new PAM_DataArchiveBatch(), batchSize);
			} else if (activeTab == 'CS_Tab'){
				batchJobId = Database.executeBatch(new Case_DataArchiveBatch(), batchSize);
			}

			return batchJobId;
		} else{

			return NULL;
		}
	}

	/* @ Remote Action calling from JAVA Script to get the batch job processing update. */
	@RemoteAction
	public static BatchProcessWrapper updateProgress(String jobId){
		List<AsyncApexJob> jobList = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, ExtendedStatus
		                              FROM AsyncApexJob
		                              WHERE Id = :jobId];
		if (jobList.isEmpty()){
			return NULL;
		}

		String jobStatus = jobList[0].Status;
		Integer processPer = jobList[0].TotalJobItems > 0 ? ((jobList[0].JobItemsProcessed * 100) / jobList[0].TotalJobItems) : 0;
		return new BatchProcessWrapper(processPer, jobStatus);
	}

	/** Remote Action to Active/Inactive AttachmentTrigger. */
	/** Calling from archiveData method and VF page. */
	/** Added on 18-Nov-2020 */
	@RemoteAction
	public static Boolean toggleAttachmentTrigger(){
		Boolean isTriggerActive = Trigger_Setting__c.getValues('AttachmentTrigger').Active__c;
		Trigger_Setting__c setting = Trigger_Setting__c.getInstance('AttachmentTrigger');
		setting.Active__c = !isTriggerActive;
		update setting;
		return setting.Active__c;
	}

	/** Remote Action to abort the batch job. */
	/** Calling from Abort button in VF page. */
	/** Added on 20-Jan-2021 */
	@RemoteAction
	public static void abortJob(String jobId){
		System.abortJob(jobId);
	}

	/* @ Method definition to send the email notification with Number of deleted Attachments */
	/* @ Calling from Case_DataArchiveBatch. */
	public static void sendNotificationAfterDataArchive(Integer deleteCount, Integer failCount, Map<Id, String> recordIdToErrorMap, String subject){
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		email.setSubject(subject);
		String htmlBody = deleteCount + ' Attachment record has been deleted from '+subject.split(' ')[0]+' Records.<br/><br/>';

		if (failCount > 0){
			htmlBody += failCount + ' Attachment deletion has been failed. The Details are as follows -<br/><br/>';
			htmlBody += '<table border="1" cellspacing="2" cellpadding="5">';
			htmlBody += '<thead><tr><th>Record Id</th><th>Error</th></tr></thead><tbody>';

			for (Id recId : recordIdToErrorMap.keySet()){
				htmlBody += '<tr><td>' + recId + '</td><td>' + recordIdToErrorMap.get(recId)+'</td></tr>';
			}
			htmlBody += '</tbody></table>';
		}
		email.setHtmlBody(htmlBody);
		email.toaddresses = new List<String>{ LCAdminEmail };

		if (!test.isRunningTest()){
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
		}
	}

	/* Wrapper class for batch job detail. */
	public class BatchProcessWrapper{
		public Integer percent{ get; set; }

		public String status{ get; set; }

		public BatchProcessWrapper(Integer percent, String status){
			this.percent = percent;
			this.status = status;
		}
	}

	/* Wrapper class for Chart data. */
	public class PieData{
		public String name{ get; set; }

		public Integer data{ get; set; }

		public PieData(String namevalue, Integer datavalue){
			this.name = namevalue;
			this.data = datavalue;
		}
	}
}