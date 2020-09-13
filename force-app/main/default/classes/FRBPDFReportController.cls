public class FRBPDFReportController{
    
    public String orgName{get;set;}
    public List<String> keyList{get;set;}
    
    public Transient  Map<String,Map<String,List<PAMWrapper>>> pamRecordsMap{get;set;}
    
    public FRBPDFReportController(){
        orgName = apexpages.currentpage().getparameters().get('name');
        String orgId = apexpages.currentpage().getparameters().get('id');
        pamRecordsMap = new Map<String,Map<String,List<PAMWrapper>>>();
        keyList = new List<String>();
        
        Integer i = 1;
        String currentStanding = '';
        for(Process_Adherence_Monitoring__c pam : [SELECT Account_Number__c, Exception_Due_Date__c, Account_Standing__c, C1_TOTAL_BAL_THRESHOLD__c, C1_Resolution_Date__c,
                                                    C2_RCVRABLE_COST_COST_SPENT__c, C2_Resolution_Date__c, C3_ATTY_OTHER_FEES_CNTRCT_AMT__c, C3_Resolution_Date__c, 
                                                    C4_ATTY_FEES_STAT_AMT__c, C4_Resolution_Date__c, C5_INTEREST_RATE__c, C5_Resolution_Date__c, C6_INTEREST_THRESHOLD__c, 
                                                    C6_Resolution_Date__c, C7_CALCULATED_BALANCE_FIRM_BAL__c, C7_Resolution_Date__c, C7A_PRIN_AMT_PLACED_PRIN__c, 
                                                    C7A_Resolution_Date__c,C7B_REC30_PMTS_ADJS_REC42_PMTS_ADJS__c, C7B_Resolution_Date__c, C7C_REC30_RCVR_COST_REC42_RCVR_COST__c, 
                                                    C7C_Resolution_Date__c,C7D_CURRENT_BALANCE_0__c,C7D_Resolution_Date__c FROM Process_Adherence_Monitoring__c WHERE Status__c != 'Closed' AND 
                                                    Organization_Name__c =: orgId AND ((Organization_Name__r.Number_of_Exception__c != 0 AND 
                                                    Organization_Name__r.Number_of_Exception__c!= null) OR (Organization_Name__r.Number_of_exceptions_under_4_6_bucket__c != 0 AND 
                                                    Organization_Name__r.Number_of_exceptions_under_4_6_bucket__c != null) OR (Organization_Name__r.Number_of_exceptions_under_7_10_bucket__c != 0 AND 
                                                    Organization_Name__r.Number_of_exceptions_under_7_10_bucket__c != null) OR (Organization_Name__r.Number_of_exceptions_under_11_19_bucket__c != 0 AND 
                                                    Organization_Name__r.Number_of_exceptions_under_11_19_bucket__c != null)) AND Account_Standing__c in 
                                                    ('0-3 Days (Green - New Exception)','4-6 Days (Yellow - Outside Correction Timeframe)','7-10 Days (Orange - Approaching Critical Timeframe)','11-19 Days (Red - Immediate Correction Required)') 
                                                    ORDER BY Day_Counter__c DESC LIMIT 12000]){
            if(currentStanding != pam.Account_Standing__c){
                i = 1;
                currentStanding = pam.Account_Standing__c;
            }
            Map<String,List<PAMWrapper>> tempMap = pamRecordsMap.get(pam.Account_Standing__c);
            if(tempMap == null) tempMap = new Map<String,List<PAMWrapper>>();
            List<PAMWrapper> tempList = tempMap.get(String.valueOf(i));
            if(tempList == null) tempList = new List<PAMWrapper>();
            tempList.add(new PAMWrapper(pam,fetchExceptionList(pam)));
            //new List<String>()
            tempMap.put(String.valueOf(i),tempList);
            pamRecordsMap.put(pam.Account_Standing__c,tempMap);
            if(tempList.size() == 10000) i++;
        }
        if(pamRecordsMap.get('11-19 Days (Red - Immediate Correction Required)') != null) keyList.add('11-19 Days (Red - Immediate Correction Required)');
        if(pamRecordsMap.get('7-10 Days (Orange - Approaching Critical Timeframe)') != null) keyList.add('7-10 Days (Orange - Approaching Critical Timeframe)');
        if(pamRecordsMap.get('4-6 Days (Yellow - Outside Correction Timeframe)') != null) keyList.add('4-6 Days (Yellow - Outside Correction Timeframe)');
        if(pamRecordsMap.get('0-3 Days (Green - New Exception)') != null) keyList.add('0-3 Days (Green - New Exception)');
    }
    
    public List<String> fetchExceptionList(Process_Adherence_Monitoring__c pamObj){
        List<String> exceptionList = new List<String>();
        
        if(pamObj.C1_TOTAL_BAL_THRESHOLD__c && pamObj.C1_Resolution_Date__c == null){
            exceptionList.add('C1. TOTAL BAL THRESHOLD');
        }
        
        if(pamObj.C2_RCVRABLE_COST_COST_SPENT__c && pamObj.C2_Resolution_Date__c == null){
            exceptionList.add('C2. RCVRABLE COST>COST SPENT');
        }
        
        if(pamObj.C3_ATTY_OTHER_FEES_CNTRCT_AMT__c && pamObj.C3_Resolution_Date__c == null){
            exceptionList.add('C3. ATTY/OTHER FEES (CNTRCT_AMT)');
        }
        
        if(pamObj.C4_ATTY_FEES_STAT_AMT__c && pamObj.C4_Resolution_Date__c == null){
            exceptionList.add('C4. ATTY FEES (STAT_AMT)');
        }
        
        if(pamObj.C5_INTEREST_RATE__c && pamObj.C5_Resolution_Date__c == null){
            exceptionList.add('C5. INTEREST RATE');
        }
        
        if(pamObj.C6_INTEREST_THRESHOLD__c && pamObj.C6_Resolution_Date__c == null){
            exceptionList.add('C6. INTEREST THRESHOLD');
        }
        
        if(pamObj.C7_CALCULATED_BALANCE_FIRM_BAL__c && pamObj.C7_Resolution_Date__c == null){
            exceptionList.add('C7. CALCULATED BALANCE = FIRM BAL');
        }
        
        if(pamObj.C7A_PRIN_AMT_PLACED_PRIN__c && pamObj.C7A_Resolution_Date__c == null){
            exceptionList.add('C7A. PRIN_AMT = PLACED PRIN');
        }
        
        if(pamObj.C7B_REC30_PMTS_ADJS_REC42_PMTS_ADJS__c && pamObj.C7B_Resolution_Date__c == null){
            exceptionList.add('C7B. REC30(PMTS+ADJS) = REC42(PMTS+ADJS)');
        }
        
        if(pamObj.C7C_REC30_RCVR_COST_REC42_RCVR_COST__c && pamObj.C7C_Resolution_Date__c == null){
            exceptionList.add('C7C. REC30 RCVR COST = REC42 RCVR COST');
        }
        
        if(pamObj.C7D_CURRENT_BALANCE_0__c && pamObj.C7D_Resolution_Date__c == null){
            exceptionList.add('C7D. CURRENT_BALANCE < 0');
        }
        return exceptionList;
    }
    
    public class PAMWrapper{
        public Process_Adherence_Monitoring__c pamObj{get;set;}
        public List<String> exceptionList{get;set;}
        
        public PAMWrapper(Process_Adherence_Monitoring__c tempPAM, List<String> tempList){
            pamObj = tempPAM;
            exceptionList = new List<String>(tempList);
        }
    }
}