/*
##########################################################################################################################################
# Project Name..........: CM- Monthly and follow up Notifications
# File..................: Class : "CM_FollowUPMonthlyNotification "
# Version...............: 1.0
# Created by............: Sunny Kumar   
# Created Date..........: 27-March-2016
# Last Modified by......: Sunny Kumar
# Last Modified Date....: 06-April-2016                        
# Description...........:  It will collect all Call Monitoring records with "Call Monitoring Log" record type 
and process them based on active consumers. If a Firm have a single record under that Month-Year 
Combination then it first create a record in CIS&CM History table and mark the CML check box 
otherwise will send an email to all Firms which have not submitted any CML record.

###########################################################################################################################################
*/


global class CM_FollowUPMonthlyNotification implements Database.Batchable<sObject> {  
	
	public boolean isMonthlyReminder{get;set;}
	public String year{get;set;} 
	public String month{get;set;} 
	public boolean isEmailSend{get;set;} 
	public boolean isOverDueReminder{get;set;} 
	public static Final String STATUS_ACTIVE = 'Active';
	public static Final String STATUS_INACTIVE = 'Inactive';
	
	
	/*Database.executeBatch(new EmailReminderBatch(currentYear,currentMonth,true,true,true),1);
	
	Query:
	
	SELECT Consumer_Inquirie_History__c,CreatedDate,Email_Template_Type__c,Id,IsDeleted,Is_Active__c,
	Is_Email_Send__c,Is_Monthly_Reminder__c,Is_Overdue_Reminder__c,LastModifiedDate,Last_Email_Alert__c,
	Month__c,Name,Organization__c,RecordTypeId,SystemModstamp,User__c 
	FROM Email_Reminder__c where User__r.profile.name in ('CC - CIS','CC - TW') 
	and name like '%CM%' and User__r.IsActive = true
	
	
	Now added EmailReminderBatch(2016,00,true,true,true),1)
	
	String CRON_EXP = '0 07 18 11 1 ? 2016';
	                   scheduledFollowUpEmailReminder sm = new scheduledFollowUpEmailReminder();
	                   System.schedule('Manual Followup_RUn : '+system.now(), CRON_EXP, sm);
	
	//     FOllow UP
	//CM_FollowUPMonthlyNotification eRB = new CM_FollowUPMonthlyNotification('2016','03',true,true,true);    
	//Database.executeBatch(eRB,1);
	
	// Monthly 
	CM_FollowUPMonthlyNotification eRB = new CM_FollowUPMonthlyNotification('2016','03',true,true,false);    
	Database.executeBatch(eRB,1);
	
	*/
	public CM_FollowUPMonthlyNotification(string year,string month,boolean isEmailSend,boolean isMonthlyReminder,boolean isOverDueReminder){
	    
	    // follow up process 
	    //args isEmailSend = true, isMonthlyReminder = true, isOverDueReminder = false
	    
	    if(isMonthlyReminder && isOverDueReminder){
	        isMonthlyReminder=true;
	    }
	    
	    if(month.length()==1)   
	    this.month=('0'+month);     
	    else
	        this.month=(month);   
	    this.year=(year);
	    this.isMonthlyReminder=isMonthlyReminder;
	    this.isEmailSend=isEmailSend;
	    this.isOverDueReminder=isOverDueReminder;
	    
	}
	
   global Database.QueryLocator start(Database.BatchableContext BC){
    
       // Profile objProfile=[Select id from Profile where Name='CC - CIS'];
        list<Profile> objProfile = new list<Profile>();
        objProfile = [Select id from Profile where Name IN ('CC - User Access')];
      
		Set<Id> accId = new Set<Id>();
         // It will get only active users portal user with account
         // It will include CC-CIS and CC-TW Profiles only
        for(User objUser: [Select id,ContactId,Contact.AccountId from User where isActive=true 
                            and profileid=:objProfile and Contact.AccountId!=null]){
                            
	            accId.add(objUser.Contact.AccountId); //    Contact.AccountId='001U000000BGeNE'
	            
		} 
         
        System.debug('Sunny------->>>>'+accId.size()+'====='+accId); 
        String strQuery='Select id, MultipleAccountTypes__c, Firm_Status_IN_AARS__c, Firm_Status_IN_ACF__c, Firm_Status_IN__c, Agency_Status_IN__c from Account where Id IN :accId';
        return Database.getQueryLocator(strQuery); 
    
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
         
         Account objAccount = new Account();
        
         for(sObject obj : scope){
         	
            objAccount = (Account)obj;
            
         }  
	
		startProcess(objAccount);
   } 
   
	public void startProcess( Account objAccount){ 
	     
	    // Map<String,Map<String,Map<String,Consumer_Inquiries__c>>> mapUserMonitoringType=new Map<String,Map<String,Map<String,Call_Monitoring__c>>>();
		Map<String,Map<String,String>> mapFirmMonitoring=new Map<String,Map<String,String>>();
	     
		list<Call_Monitoring__c> objCM = new   list<Call_Monitoring__c>();
	    
		objCM = [Select id,RecordTypeId,Account_Type_CM__c,RecordType.Name,OwnerId 
	                                   from Call_Monitoring__c where Reporting_Month_CM__c=:month 
	                                   and Reporting_Year_CM__c=:year and Organization_Name_CM__c=:objAccount.id
	                                   and RecordType.Name like '%Log%'];
	     
	
	    System.debug('==========='+objCM.size());
	      
	   
	    UserDetail obUserDetail = getFirmDetail(objAccount);
	    //get CM Record
	    
	    Consumer_Inquirie_History__c obj = getExistingCallMonitoring(objAccount.id,year,month);
	    
	    System.debug('sunny-------month>>>>>'+month+'==='+year+'====='+obj);
	    obj.Account__c = objAccount.id;
	            
	    if(month.length() == 1){
	    	
	    	obj.Name='CM:Month:0'+month+' Year'+year;
	    	
	    }else{
	    	
	    	obj.Name='CM:Month:'+month+' Year'+year;
	    }
	      
	      // System.debug('sunny-------month>>>>>'+month+'========'+obj);
	    obj.Year__c = year;      
	    obj.Month__c = month;
	      
	      //obj.Firm_Type__c=(objInquiryDetail.isJointFirm)?'Joint':'Single';
	    obj.Firm_Type__c = obUserDetail.strFirmType;
	       
	    obj.Is_Monthly_Reminder__c = isMonthlyReminder;
	    obj.Is_Business_Day_Reminder__c = isOverDueReminder;
	    obj.RecordTypeID = Utility.getCISCMRecordType('CM');
	      
	      
	      //Count Update
		if(!objCM.isempty()){
			System.debug('$$$$$$$$$$$$$$$$$>>>>>');
			obj.MCM_CML__c =true;
		}
		
		obj.Is_Email_Send__c = isEmailSend;
	      
		if(isOverDueReminder){
			
			System.debug('*******Follow Up RUn =====11111111111==========================strEmailType>>>>'+'==isOverDueReminder=='+isOverDueReminder+'---'+obj.Name+'==='+obj.Account__c+'==');
		}
	      
		System.debug('*******Follow Up RUn =====33333====='+obj.Is_Active__c); 
		upsert obj;
	    
		delete[select id from Email_Reminder__c where Consumer_Inquirie_History__c=:obj.id
				and RecordTypeID=:Utility.getCISCMEmail_ReminderRecordType('CM')];
		
		Set<String> toExcludeAccountType = new Set<String>();
		toExcludeAccountType.add('AA');
		toExcludeAccountType.add('ACF');
		
		List<Email_Reminder__c> lst = new  List<Email_Reminder__c>();
	
		if(!obUserDetail.lstUser.isEmpty()){
			
			for(User objUser : obUserDetail.lstUser){
				
				if(!toExcludeAccountType.contains(obj.Firm_Type__c)){
					
					lst.add(new Email_Reminder__c(Name=obj.Name,RecordTypeID=Utility.getCISCMEmail_ReminderRecordType('CM'),Consumer_Inquirie_History__c=obj.id,User__c=objUser.id,Last_Email_Alert__c=system.Now()));
				}
				
			}
			System.debug('*******Email_Reminder__c =====11111111111==========='+lst.size()+'==='+lst); 
			insert lst;
		}
		
	}
 
   
	public Consumer_Inquirie_History__c getExistingCallMonitoring(String firmId,String strYear,String strMonth){
		Consumer_Inquirie_History__c obj=new Consumer_Inquirie_History__c();
		
		try{
			return [Select c.Year__c, c.User__c, c.Template_Type__c, c.RC__c, c.OwnerId, c.Name, c.Month__c, c.MCM_RC__c, 
						c.MCM_CD__c, c.LastModifiedDate, c.LastModifiedById, c.Is_Monthly_Reminder__c, c.Is_Email_Send__c, 
						c.Is_Business_Day_Reminder__c, c.Is_Active__c, c.Id, c.Firm_Type__c, c.CreatedDate, c.CreatedById, 
						c.Contact__c, c.ConnectionSentId, c.ConnectionReceivedId, c.CD__c, c.Account__c, c.AARS_RC__c, c.AARS_CD__c
					From Consumer_Inquirie_History__c c 
					where Month__c=:strMonth 
					and Year__c=:strYear 
					and Account__c=:firmId  
					and RecordTypeID=:Utility.getCISCMRecordType('CM') order by LastModifiedDate desc limit 1]; //and Is_Active__c=true 
		}catch(Exception ex){
        
		}
		
      return obj;
   }
   
   public UserDetail getFirmDetail(Account accountObj){
        
        UserDetail objUser=new UserDetail();
        objUser.lstUser=new List<User>();
        list<Profile> getUserProfile = new list<Profile>();
        getUserProfile=[Select id from Profile where Name=:Utility.getTW_CISProfileLabel() OR Name=:Utility.getCISProfileNameLabel()];
          
        Map<String,String> mapDepartment=new  Map<String,String>() ;
        
        for(User objUserDetail:[Select id, Department from User 
                               where Contact.AccountId=:accountObj.Id and isActive=true
                               and profileid=:getUserProfile ]){
              
             /* if(objUserDetail.Department==null || objUserDetail.Department==''){
                mapDepartment.put('MCM','MCM');
                mapDepartment.put('AA','AA');
              }else{
                    mapDepartment.put(objUserDetail.Department,objUserDetail.Department);
              }*/
               objUser.lstUser.add(objUserDetail);
         }
      
      /*if(mapDepartment.get('MCM')!=null && mapDepartment.get('AA')!=null){
        setFirmDetail(objUser,'Joint',false,false);
      }else if(mapDepartment.get('MCM')!=null){
         setFirmDetail(objUser,'MCM',false,true);
      }else{
         setFirmDetail(objUser,'AA',true,false);
      }*/
      
      
		if(accountObj.MultipleAccountTypes__c != null && accountObj.MultipleAccountTypes__c){
				
			setFirmDetail(objUser,'Joint',false,false,false);
			
		}else if( (accountObj.Firm_Status_IN__c == STATUS_ACTIVE || accountObj.Firm_Status_IN__c == STATUS_INACTIVE 
						|| accountObj.Agency_Status_IN__c == STATUS_ACTIVE || accountObj.Agency_Status_IN__c == STATUS_INACTIVE ) 
					&& !(accountObj.Firm_Status_IN_AARS__c == STATUS_ACTIVE && accountObj.Firm_Status_IN_AARS__c == STATUS_INACTIVE)
					&& !(accountObj.Firm_Status_IN_ACF__c == STATUS_ACTIVE && accountObj.Firm_Status_IN_ACF__c == STATUS_INACTIVE) ){
			
			// for MCM only 
			// if firm status in or agency status in is active or inactive then we select Firm type is MCM
			setFirmDetail(objUser, 'MCM', false, true, false);
			
			
		}else if( (accountObj.Firm_Status_IN_AARS__c == STATUS_ACTIVE || accountObj.Firm_Status_IN_AARS__c == STATUS_INACTIVE) 
					&& !(accountObj.Firm_Status_IN__c == STATUS_ACTIVE && accountObj.Firm_Status_IN__c == STATUS_INACTIVE)
					&& !(accountObj.Firm_Status_IN_ACF__c == STATUS_ACTIVE && accountObj.Firm_Status_IN_ACF__c == STATUS_INACTIVE) ){
			// for AA only 
			setFirmDetail(objUser, 'AA', true, false, false);
			
		}else if( (accountObj.Firm_Status_IN_ACF__c == STATUS_ACTIVE || accountObj.Firm_Status_IN_ACF__c == STATUS_INACTIVE) 
					&& !(accountObj.Firm_Status_IN__c == STATUS_ACTIVE && accountObj.Firm_Status_IN__c == STATUS_INACTIVE)
					&& !(accountObj.Firm_Status_IN_AARS__c == STATUS_ACTIVE && accountObj.Firm_Status_IN_AARS__c == STATUS_INACTIVE) ){
			
			// for ACF only
			setFirmDetail(objUser, 'ACF', false, false, true); 
			
		}
      
     
      return objUser;
   }
   
  
   public void setFirmDetail(UserDetail objUser,String strFirmType,boolean bAARSOnly,boolean bMCMOnly, boolean bACFOnly){
   
		objUser.bAARSOnly = bAARSOnly;
		objUser.strFirmType = strFirmType;
		objUser.bMCMOnly = bMCMOnly;
		objUser.bACFOnly = bACFOnly;
   
   }
   
	global class UserDetail{
	    public String strFirmType{get;set;}
	    public boolean bMCMOnly{get;set;}
	    public boolean bAARSOnly{get;set;}
	    public boolean bACFOnly{get;set;}
	    public Map<String,Map<String,User>> mapUser{get;set;}
	    public List<User> lstUser{get;set;}
	}

	global void finish(Database.BatchableContext BC){
		
		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CompletedDate,CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        if(a!=null){
        	
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //String[] toAddresses = new String[] {'FirmManagement@mcmcg.com'};
         String[] toAddresses = new String[] {'lcsalesforceadmin@mcmcg.com'};
         
         // Add all CC Address via Custom Setting....
         List<String> lstEmailId=new List<String>();
         for (EmailNotification__c objEmail : EmailNotification__c.getAll().values()){
           lstEmailId.add(objEmail.Email__c);
         }
         if(lstEmailId.size()>0)
         {
           mail.setCcAddresses(lstEmailId);
         }
          
        mail.setToAddresses(toAddresses);
        if(isMonthlyReminder && isOverDueReminder && isEmailSend){
         mail.setSubject('CM Monthly Follow Up batch completed: ' + a.CompletedDate);   
         mail.setPlainTextBody('The CM follow up job has processed '+ a.JobItemsProcessed +' firms with '+ a.NumberOfErrors + ' failures.');// for ' +month+'-'+Year);
        }
        
        else if(isMonthlyReminder && !isOverDueReminder && isEmailSend){
        mail.setSubject('CM Monthly Reminder batch completed: ' + a.CompletedDate);    
        mail.setPlainTextBody('The CM reminder job has processed  '+ a.JobItemsProcessed +' firms with '+ a.NumberOfErrors + ' failures.');// . for ' +month+'-'+Year);
        } 
        
        else { //(isMonthlyReminder || isOverDueReminder && !isEmailSend)
        mail.setSubject('CM Unscheduled Alert/Follow Up batch completed: ' + a.CompletedDate);    
        mail.setPlainTextBody('The CM Manual Apex job has processed '+ a.JobItemsProcessed +' firms with '+ a.NumberOfErrors + ' failures for ' +month+'-'+Year);
        } 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        }
   
   }
	
	
}