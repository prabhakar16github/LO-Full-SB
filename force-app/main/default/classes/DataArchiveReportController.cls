/*
    * @ Class Name  	: 	DataArchiveReportController
    * @ Description 	:	Controller Class for DataArchiveReport VF Page
    * @ Created By  	: 	Prabhakar Joshi
    * @ Created Date	: 	1-Apr-2020
    * @ Last Modified   :   16-Nov-2020
*/
public class DataArchiveReportController{
    /* To check that AttachmentTrigger is Inactive or not. */
    public Boolean AttachmentTriggerActive{
        get;
        private set;
    }
    
    /* To set the current tab name */
    public String tabName{
        get;
        set;
    }
    
    /* To set the chart data */
    public List<PieData> chartData{
        get;
        private set;
    }
    
    /* To set the  count of data for Archive */
    public Integer totalArchiveData{
        get;
        private set;
    }
    
    /* To set the data of current tab */
    public String dataType{
        get;
        private set;
    }
    
    /* To Set the Count of Total Attachments in the Org */
    public Integer totalAttachmentData{
        get;
        private set;
    }
    
    /* To set the value of selected Limit form Page */
    public String selectedLimit{
        get;
        set;
    }
    
    
    /* To hold the date of 6 months before */
    private Date sixMonthBeforeDate = System.today().addMonths( - 6);
    /* To hold the date of 12 months before */
    private Date oneYearBeforeDate = System.today().addMonths( - 12);
    
    
    /* Constructor */
    public DataArchiveReportController(){
        AttachmentTriggerActive = false;
        tabName = 'LRMM_Tab';
        dataType = 'LRMM';
        selectedLimit = '';
        init();
    }
    
    /* @ Method is Calling from constructor */
    public void init(){
        AttachmentTriggerActive = Trigger_Setting__c.getValues('AttachmentTrigger') != NULL ? Trigger_Setting__c.getValues('AttachmentTrigger').Active__c : false;
        totalAttachmentData = 0;
        totalArchiveData = 0;
        chartData = new List<PieData>();
        for (AggregateResult agg : [SELECT count(Id)totalAcc
                                    FROM Attachment]){
                                        totalAttachmentData = (Integer)agg.get('totalAcc');
                                    }
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
    private List<PieData> fetchLRMMChartData(){
        LRMM_DataArchiveHandler handler = new LRMM_DataArchiveHandler();
        List<PieData> data = new List<PieData>();
        /*
        Date lastDate = LRMM_DataArchiveHandler.lastDate;
        Set<Id> parentIdSet = handler.getParentIds();
        
        if (parentIdSet.size() > 0){
            Map<String, Integer> objectToAttCountMap = new Map<String, Integer>();
            for (AggregateResult att : [SELECT COUNT(Id)totalCount, Parent.Type objectAPIName
                                        FROM Attachment
                                        WHERE ParentId IN :parentIdSet AND LastModifiedDate < :lastDate
                                        GROUP BY Parent.Type]){
                                            String sobjectName = Schema.getGlobalDescribe().get(String.valueOf(att.get('objectAPIName'))).getDescribe().getLabel();
                                            objectToAttCountMap.put(sobjectName, (Integer)att.get('totalCount'));
                                            
                                        }
            if (objectToAttCountMap.keySet().size() > 0){
                for (String obj : objectToAttCountMap.keySet()){
                    data.add(new PieData(obj + ' : ' + objectToAttCountMap.get(obj), objectToAttCountMap.get(obj)));
                    totalArchiveData += objectToAttCountMap.get(obj);
                }
            }
        }*/
        
        Map<String,Integer> dataMap = handler.getAttachmentCountMap();
        for (String obj : dataMap.keySet()){
            data.add(new PieData(obj + ' : ' + dataMap.get(obj), dataMap.get(obj)));
            totalArchiveData += dataMap.get(obj);
        }
            
       return data;
    }
    
    /* @ Method to get the Call Monitoring Chart Data */
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
    private List<PieData> fetch_PAM_ChartData(){
        List<PieData> PAM_Att_data = new List<PieData>();
        Set<Id> pamIdSet = new Set<Id>();
        Set<String> recordTypeNameSet = new Set<String>{'LO IR - Account #\'s Sent'};
            String query = 'SELECT Id, Name, RecordType.Name FROM Process_Adherence_Monitoring__c WHERE RecordType.Name IN :recordTypeNameSet AND Status__c = \'Closed\' ';
        if (!test.isRunningTest())
            query += 'AND LastModifiedDate < :sixMonthBeforeDate';
        for (Process_Adherence_Monitoring__c pam : Database.query(query)){
            pamIdSet.add(pam.Id);
        }
        if (pamIdSet.size() > 0){
            Map<String, Integer> recordTypeToAttCountMap = new Map<String, Integer>();
            for (AggregateResult att : [SELECT COUNT(Id)totalCount, Parent.RecordType.Name recordType
                                        FROM Attachment
                                        WHERE ParentId IN :pamIdSet AND LastModifiedDate < :sixMonthBeforeDate
                                        GROUP BY Parent.RecordType.Name]){
                                            recordTypeToAttCountMap.put(String.valueOf(att.get('recordType')), (Integer)att.get('totalCount'));
                                            
                                        }
            if (recordTypeToAttCountMap.keySet().size() > 0){
                for (String rt : recordTypeToAttCountMap.keySet()){
                    PAM_Att_data.add(new PieData(rt + ' : ' + recordTypeToAttCountMap.get(rt), recordTypeToAttCountMap.get(rt)));
                	totalArchiveData += recordTypeToAttCountMap.get(rt);
                }
            }
        }
        return PAM_Att_data;
    }
    
    /* @ Method to get the Case Chart Data */
    /* @ Added on 8-July-2020. */
    private List<PieData> fetch_Case_ChartData(){
        
        Case_DataArchiveHandler handler = new Case_DataArchiveHandler();
        
        List<PieData> Case_Archive_data = new List<PieData>();
        Map<String,Integer> objToCountMap = new Map<String,Integer>();
        
        objToCountMap.put('EmailMessages',handler.getEmailMessagesCount());
        objToCountMap.put('Attachment',handler.getAttachmentCount());
        
        for(String obj : objToCountMap.keySet()){
            if(objToCountMap.get(obj) > 0){
                Case_Archive_data.add(new PieData(obj+' : '+objToCountMap.get(obj),objToCountMap.get(obj)));
                totalArchiveData += objToCountMap.get(obj);
            }
        }
        return Case_Archive_data;
    }
    
    /* @ Remote Action calling from JAVA Script to invoke the batch class which is Archiving the data. */
    @RemoteAction
    public static Id archiveData(String activeTab){
        if(!toggleAttachmentTrigger()){
            Integer batchSize = Integer.valueOf(label.Data_Archive_Batch_Size) <= 2000 ? Integer.valueOf(label.Data_Archive_Batch_Size) : 2000;
            Id batchJobId;
            if (activeTab == 'LRMM_Tab'){
                batchJobId = Database.executeBatch(new LRMM_DataArchiveBatch(), batchSize);
            } else if (activeTab == 'CM_Tab'){
                batchJobId = Database.executeBatch(new CM_DataArchiveBatch(), batchSize);
            } else if (activeTab == 'PAM_Tab'){
                batchJobId = Database.executeBatch(new IR_DataArchiveBatch(), batchSize);
            } else if (activeTab == 'CS_Tab' ){//&& String.isNotBlank(limitSelected)
                batchJobId = Database.executeBatch(new Case_DataArchiveBatch(), batchSize);//limitSelected
            }
        
            return batchJobId;
        }else{
            
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
    public static Boolean abortJob(String jobId){
        System.abortJob(jobId);
        return toggleAttachmentTrigger();
    }
    
    /* Wrapper class for batch job detail. */
    public class BatchProcessWrapper{
        public Integer percent{
            get;
            set;
        }
        
        public String status{
            get;
            set;
        }
        
        public BatchProcessWrapper(Integer percent, String status){
            this.percent = percent;
            this.status = status;
        }
    }
    
    /* Wrapper class for Chart data. */
    public class PieData{
        public String name{
            get;
            set;
        }
        
        public Integer data{
            get;
            set;
        }
        
        public PieData(String namevalue, Integer datavalue){
            this.name = namevalue;
            this.data = datavalue;
        }
    }
}