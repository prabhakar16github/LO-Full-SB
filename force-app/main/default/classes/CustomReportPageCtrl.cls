public class CustomReportPageCtrl{

    public List<SelectOption> pamAccountTypeList{get;set;}
    public String pamSelected{get;set;}
    public List<WrapperClass> wrapperClassList{get;set;}
    public String searchString { get; set; }
    //Developer: Sanjana Das
	public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    }
    public void toggleSort() {
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        getRecords();
    }

     public CustomReportPageCtrl(){
      
       //PamAccountTypeList = new List<SelectOption>();
      // PamAccountTypeList.add(new selectOption('ACF','ACF'));
       //PamAccountTypeList.add(new selectOption('Legacy','Legacy'));
       pamSelected = 'Legacy' ;
       
       getRecords();
     }
     
     public void updateStatus() {
          List<Process_Adherence_Monitoring__c> pamToUpdateList;
          for ( WrapperClass wrapper  : wrapperClassList) {
              if (wrapper.isSelected) {
                  if(pamToUpdateList == null)
                      pamToUpdateList = new List<Process_Adherence_Monitoring__c>();
                        
                        if(wrapper.pamRecords.SCMD_NoPCodes_Sent_This_Reporting_Period__c==true && wrapper.pamRecords.No_Dispute_Codes_Sent_in_Report_Period__c==false){
                          wrapper.PamRecords.Status__c = 'Accounts Sent To ISeries';
                          wrapper.PamRecords.Date_Dispute_Account_s_Sent__c = date.today();
                        }else if(wrapper.pamRecords.SCMD_NoPCodes_Sent_This_Reporting_Period__c==false && wrapper.pamRecords.No_Dispute_Codes_Sent_in_Report_Period__c==true){
                          wrapper.PamRecords.Status__c = 'Accounts Sent To ISeries';
                          wrapper.PamRecords.Date_Dispute_Account_s_Sent__c = date.today();
                        }else if(wrapper.pamRecords.SCMD_NoPCodes_Sent_This_Reporting_Period__c==false && wrapper.pamRecords.No_Dispute_Codes_Sent_in_Report_Period__c==false){
                               if(wrapper.PamRecords.Date_Dispute_Account_s_Sent__c == null){
                                  wrapper.PamRecords.Date_Dispute_Account_s_Sent__c = date.today();
                               }/*else{
                                 wrapper.PamRecords.Date_Dispute_Account_s_Sent__c = date.today();
                                 wrapper.PamRecords.Status__c = 'Accounts Sent To ISeries';
                               }*/
                               
                               if(wrapper.pamRecords.SCMD_Date_Account_Numbers_Received__c != null){
                                wrapper.PamRecords.Date_Dispute_Account_s_Sent__c = date.today();
                                wrapper.PamRecords.Status__c = 'Accounts Sent To ISeries';
                               }
                               
                        }
                      
                 
                  pamToUpdateList.add(wrapper.PamRecords);
              }
          }
         update pamToUpdateList;
         getRecords();
     }
     
     
     public void getRecords(){
       String likeParam = '%'+searchString+'%';
       System.debug(' #### searchString '+searchString);
       wrapperClassList = new List<WrapperClass>();
           if(pamSelected != null && pamSelected != ''){
             if(pamSelected == 'ACF'){
               Id recTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF SCM Dispute').getRecordTypeId();
               String Query = 'select id ,Date_Dispute_Account_s_Sent__c,SCMD_Date_Dispute_AccountNumbersReceived__c,SCMD_Date_Account_Numbers_Received__c,SCMD_NoPCodes_Sent_This_Reporting_Period__c,No_Dispute_Codes_Sent_in_Report_Period__c,Name,SCMD_Reporting_Period__c,Organization_Name__c, Organization_Name__r.name,Status__c,(select id , name from SCMD_Account_Numbers__r), Total_PCodes_Sent__c from Process_Adherence_Monitoring__c '+ 
                                        'where Account_Type__c=\'ACF\' and RecordTypeId=:recTypeId and status__c =\'Account Numbers Added\'';
               System.debug('Query '+Query);
               if (searchString != null) 
                   Query += ' AND Organization_Name__r.Name Like : likeParam';
               List<Process_Adherence_Monitoring__c> pamList = Database.Query(Query);
                         
                           for(Process_Adherence_Monitoring__c pam : pamList){
                                if(pam.SCMD_Account_Numbers__r != null && pam.SCMD_Account_Numbers__r.size() > 0){
                                    wrapperClass wc = new WrapperClass(pam , false);
                                    wrapperClassList.add(wc);
                                }
                           }             
             
            }else if(pamSelected == 'Legacy'){
                Id recTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SCM Dispute').getRecordTypeId();
                String Query= 'select id ,Date_Dispute_Account_s_Sent__c,SCMD_Date_Dispute_AccountNumbersReceived__c,SCMD_Date_Account_Numbers_Received__c,Name,SCMD_NoPCodes_Sent_This_Reporting_Period__c,No_Dispute_Codes_Sent_in_Report_Period__c,SCMD_Reporting_Period__c,Organization_Name__c, Organization_Name__r.name,Status__c ,(select id , name from SCMD_Account_Numbers__r), Total_PCodes_Sent__c from Process_Adherence_Monitoring__c '+
                                        ' where Account_Type__c=\'Legacy\' and RecordTypeId=:recTypeId and status__c =\'Account Numbers Added\'';
               
                if (searchString != null) {
                   Query += ' AND Organization_Name__r.Name Like : likeParam';
                }
                //Developer: Sanjana Das
                Query += ' Order By Total_PCodes_Sent__c ' + sortDir;
                List<Process_Adherence_Monitoring__c> pamList = Database.Query(Query);
                         
                         for(Process_Adherence_Monitoring__c pam : pamList){
                                if(pam.SCMD_Account_Numbers__r != null && pam.SCMD_Account_Numbers__r.size() > 0){
                                    wrapperClass wc = new WrapperClass(pam , false);
                                    wrapperClassList.add(wc);
                                }
                         }                            
             }
         }
     }
     

    public class WrapperClass{
        public boolean isSelected{get;set;}
        public Process_Adherence_Monitoring__c PamRecords{get;set;}
            public WrapperClass(Process_Adherence_Monitoring__c PamRecords , boolean isSelected){
              this.PamRecords = PamRecords ;
              this.isSelected = isSelected ;
            }
    }
}