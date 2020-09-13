public class BatchJobProgressBarController {
    private Id batchClassId;
    final public String NOT_START = 'not_started';
    final public String PROCESSING = 'processing';
    final public String FINISHED = 'finished';
    public String batchStatus {get;set;}
    public Id batchId {get;set;}
    public String message {get;set;}
    public Integer errornum {get;set;}
    
    public BatchJobProgressBarController (){
        //here specify the Apex batch class name for which you want to display progress bar
        batchClassId = [Select Name, Id From ApexClass Where Name = 'LRMM_DataArchiveBatch' Limit 1][0].id;
        batchStatus = NOT_START;
        batchId = null;
        message = ''; 
        errornum =0; 
       
    }
    public boolean getShowProgressBar() {
        if(batchStatus == PROCESSING )
            return true;
        return false;
    }
    //this method will fetch apex jobs and will update status,JobItemsProcessed,NumberOfErrors,TotalJobItems
    public BatchJob[] getJobs() {
        
        List<AsyncApexJob> apexJobs = 
            [Select TotalJobItems, Status, NumberOfErrors, ExtendedStatus, JobItemsProcessed, Id, JobType, ApexClassId, CreatedDate From AsyncApexJob Where ApexClassId =: batchClassId Order by CreatedDate DESC];
        
        if(apexJobs.size() == 0) {
            return new List<BatchJob>();
        }

        List<BatchJob> jobs = new List<BatchJob>();      
        for(AsyncApexJob job : apexJobs) {
            if(job.id != batchId)
                continue;
                
            BatchJob bj = new BatchJob();
            bj.isCompleted = false;
            
            if(job.ApexClassId == batchClassId) {
                bj.Job_Type = 'Process 1';
            }            
            bj.aj = job;

            // NOT START YET
            if(job.jobItemsProcessed == 0) {
                bj.Percent= 0;
                jobs.add(bj);
                continue;
            }

            Decimal d = job.jobItemsProcessed;
            d = d.divide(job.TotalJobItems, 2)*100;
            bj.Percent= d.intValue();

            // PROCESSING
            if(bj.Percent != 100){
                jobs.add(bj);
                continue;
            }

            // FINISED
            if(job.ApexClassId == batchClassId) {
                batchStatus = FINISHED;
                                
            }
            errornum += job.NumberOfErrors;
            bj.isCompleted = true;
            jobs.add(bj);           
        }
        return jobs;
    }


    public PageReference StartBactJob() {
        //execute RecordTypeAccessFinder batch
        if(!test.isRunningTest()){
                //string selectedObject='Account';
                
                batchId=database.executebatch(new LRMM_DataArchiveBatch(),10);
                system.debug('************batchid:'+batchid);
  
        }
        batchStatus = PROCESSING;
        return null;
    }
    
    public PageReference updateProgress() {
        if(batchStatus == FINISHED) {
            message = 'COMPLETED';
        }
        return null;
    }
    public class BatchJob{
        public AsyncApexJob aj {get;set;}
        public Integer Percent {get;set;}
        public String Job_Type {get;set;}
        public Boolean isCompleted {get;set;}
        public BatchJob(){}     
    }

}