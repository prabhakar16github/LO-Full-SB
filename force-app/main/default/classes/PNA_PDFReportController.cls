public class PNA_PDFReportController {
	
	public Account accountObj {set; get;}
	public Final String FIRST_ESCALATTION = 'First Escalation';
	public Final String FINAL_ESCALATTION = 'Final Escalation';
	public Final String EXCLUDED = 'Excluded';
	public PNAWrapper pamWrapObj {set; get;}  
    
    public PNA_PDFReportController(){
    	
    		pamWrapObj = new PNAWrapper();
    	
    	try{
    		
	    	Id accountId = ApexPages.currentPage().getparameters().get('id');
	    	
	    	String PNARecordTypeID = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO PNA').getRecordTypeId();
	    	
	    	List<Account> accountList = [ SELECT Id, Name, PNA_Exceptions_0_3_bucket__c, PNA_Exceptions_4_6_bucket__c, PNA_Exceptions7Plusbucket__c 
	    								 FROM Account WHERE Id = :accountId];
	    	
	    	List<Process_Adherence_Monitoring__c> pna_pamList = [SELECT Id, Name, Account_Number__c, SOL_Placement_Date__c, 
	    															CCM_Excluded_Reason__c, Excluded_Other_Comments__c, 
	    															Account_Standing__c, Status__c   
	    														FROM Process_Adherence_Monitoring__c 
	    														WHERE Organization_Name__c = :accountId 
	    															AND Status__c != 'Closed'
	    															AND recordTypeId = :PNARecordTypeID];
	    															
	    	List<Process_Adherence_Monitoring__c> pna_firstEscalation = new List<Process_Adherence_Monitoring__c>();
	    	List<Process_Adherence_Monitoring__c> pna_finalEscalation = new List<Process_Adherence_Monitoring__c>();
	    	List<Process_Adherence_Monitoring__c> pna_excluded = new List<Process_Adherence_Monitoring__c>(); 
	    	 				 
	    	for(Process_Adherence_Monitoring__c pamObj : pna_pamList){
	    		
	    		if(pamObj.Status__c == FIRST_ESCALATTION){
	    			
	    			pna_firstEscalation.add(pamObj);
	    			
	    		}else if(pamObj.Status__c == FINAL_ESCALATTION){
	    			
	    			pna_finalEscalation.add(pamObj);
	    			
	    		}else if(pamObj.Status__c == EXCLUDED){
	    			
	    			pna_excluded.add(pamObj);
	    		}
	    		
	    	}
	    	
	    	pamWrapObj.pna_firstEscalation = pna_firstEscalation; 
	    	pamWrapObj.pna_finalEscalation = pna_finalEscalation; 
	    	pamWrapObj.pna_excluded = pna_excluded; 
	    								 
	    	accountObj = accountList.get(0);
	    	
    	}catch(Exception ex){
    		
    		system.debug('exception occurs on page '+ex);
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
    	}
    
    }
    
    public class PNAWrapper{
    	
    	public List<Process_Adherence_Monitoring__c> pna_firstEscalation {set; get;}
    	public List<Process_Adherence_Monitoring__c> pna_finalEscalation {set; get;}
	    public List<Process_Adherence_Monitoring__c> pna_excluded {set; get;}
	    
    }
}