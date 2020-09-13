/*
##########################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: Class : "EmailReminderBatch"
# Version...............: 1.0
# Created by............: Sunny Kumar   
# Created Date..........: 27-May-2014
# Last Modified by......: Sunny Kumar
# Last Modified Date....: 19-Jan-2016                        
# Description...........: It will collect all Consumer Enquiry and process them based on active consumers as per Single i.e. MCM/AA or
#                          as Joint Firm which deals in both i.e.MCM and AA respectively. Based on all permutations and combinations will
#                          Further notify all Firms for CI-Monthly Reporting Comply.
###########################################################################################################################################
*/


global class EmailReminderBatch implements Database.Batchable<sObject> {  

	public boolean isMonthlyReminder{get;set;}
	public String year{get;set;} 
	public String month{get;set;} 
	public boolean isEmailSend{get;set;} 
	public boolean isOverDueReminder{get;set;}
	public static Final String STATUS_ACTIVE = 'Active';
	public static Final String STATUS_INACTIVE = 'Inactive'; 


	public EmailReminderBatch(string year, string month, boolean isEmailSend, boolean isMonthlyReminder, boolean isOverDueReminder){
	    
	    if(isMonthlyReminder && isOverDueReminder){
	        isMonthlyReminder = true;
	    }
	    
	    if(month.length() == 1){
		    this.month = ('0' + month);  // for adding perfix only ex. 1 ==> 01
	    }else{
	        this.month = (month);   // no need for prefix as already of two digits
	    }
	    
	    this.year = (year);
	    this.isMonthlyReminder = isMonthlyReminder;
	    this.isEmailSend = isEmailSend;
	    this.isOverDueReminder = isOverDueReminder;
	    
	}
	
   global Database.QueryLocator start(Database.BatchableContext BC){
    
		 List<Profile> objProfile = [SELECT id FROM Profile WHERE Name IN ('CC - User Access')];
       	 
       	 Set<Id> accId = new Set<Id>();
       	 
       	 System.debug('objProfile---------->'+objProfile);
         
         // It will get only active users portal user with account
         
         for(User objUser : [SELECT id, ContactId, Contact.AccountId FROM User WHERE isActive = true 
                            	AND profileid = :objProfile AND Contact.AccountId != null]){
                            
            accId.add(objUser.Contact.AccountId);
         }
         
        System.debug('accId---------->'+accId); 
        
        String strQuery = 'SELECT id, MultipleAccountTypes__c, Firm_Status_IN_AARS__c, Firm_Status_IN_ACF__c, Firm_Status_IN__c, Agency_Status_IN__c FROM Account WHERE Id IN :accId ';
        
        System.debug('strQuery---------->'+strQuery);
        
        return Database.getQueryLocator(strQuery); 
    
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
     
	     Account objAccount = new Account();
	     
	     for(sObject obj : scope){
	        objAccount = (Account)obj;
	     }
	      
	      system.debug('scope--------->'+scope);
	       
		  startProcess(objAccount);
   } 
   
   public void startProcess( Account objAccount){ 
        
         // Code commented on 23/01/2018 as below code is not using for the calculation
	     /*Map<String,String> mapRecordType = new Map<String,String>();
	     
	     // get record type of consumer inquiries object
	     
	     Schema.sObjectType objType = Consumer_Inquiries__c.getSObjectType();
	     Schema.DescribeSObjectResult sObjReslt = objType.getDescribe();  
	     Map<String,Schema.RecordTypeInfo> rtMapByName = sObjReslt.getRecordTypeInfosByName();
     
	     for(String str : rtMapByName.keySet()){
	     	
	          Schema.RecordTypeInfo rtByName = rtMapByName.get(str);
	          
	         if(rtByName.isAvailable()){
	           
	            mapRecordType.put(rtByName.getRecordTypeId(), rtByName.getName());
	            
	         }  
	     }
    	
    	system.debug('mapRecordType--------->'+mapRecordType);
    	
    	*/
    	
    	// Below map is not used in the code so commented
    	
     	//Map<String,Map<String,Map<String,Consumer_Inquiries__c>>> mapUserInquiryType = new Map<String,Map<String,Map<String,Consumer_Inquiries__c>>>();
     	
     	Map<String,Map<String,String>> mapFirmInquiry = new Map<String,Map<String,String>>();
     
    	InquiryDetail requestType = new InquiryDetail();
    
    	// query all consumer inquiry records related to the organization for year and month // for count purpose start 
    	
    	for(Consumer_Inquiries__c obj : [SELECT id, RecordTypeId, Type__c, Account_Type__c, RecordType.Name, OwnerId 
    										FROM Consumer_Inquiries__c 
    										WHERE Reporting_Month__c = :month 
                                   			AND Reporting_Year__c = :year 
                                   			AND Firm_Name__c = :objAccount.id]){
        	String strInquiryType = '';
        	
        	system.debug('obj------------->'+obj);
        
        	if(obj.RecordType.Name == 'No Consumer Inquiries'){
	            
	            if(obj.Type__c == 'Consumer Dissatisfaction'){
	                strInquiryType = 'CD';
	                System.debug('requestType.NCICDsCount>>'+requestType.NCICDsCount);
	                requestType.NCICDsCount += 1;
	                System.debug('requestType.NCICDsCount>>'+requestType.NCICDsCount);
	                
	             }
	             
	             if(obj.Type__c == 'Regulatory Complaint'){
	                strInquiryType = 'RC';
	                System.debug('requestType.NCIRCsCount>>'+requestType.NCIRCsCount);
	                requestType.NCIRCsCount += 1;
	                System.debug('requestType.NCIRCsCount>>'+requestType.NCIRCsCount);
	             }
	             
	          }else if(obj.RecordType.Name == 'Consumer Dissatisfaction'){
	          	
	            	System.debug('requestType.cDsCount>>'+requestType.cDsCount);
	              	strInquiryType = 'CD';
	              	requestType.cDsCount += 1;
	              	System.debug('requestType.cDsCount>>'+requestType.cDsCount);
	              	
	          }else if(obj.RecordType.Name == 'Regulatory Complaint'){
	          		
	          		strInquiryType = 'RC';
	              	System.debug('requestType.rCsCount>>'+requestType.rCsCount);
	              	requestType.rCsCount += 1;
	              	
	          }
         		
         		system.debug('requestType--------->'+requestType);
         		
	         if(mapFirmInquiry.get(obj.Account_Type__c) == null){
	            mapFirmInquiry.put(obj.Account_Type__c,new Map<String,String>{strInquiryType=>strInquiryType});
	         }else{
	            mapFirmInquiry.get(obj.Account_Type__c).put(strInquiryType,strInquiryType);
	         }
	         
	         system.debug('mapFirmInquiry------------->'+mapFirmInquiry);
        }
        
        // query all consumer inquiry records related to the organization for year and month // for count purpose end 
        
        system.debug('requestType----------->'+requestType);

 		System.debug('============COUNT==============='+requestType +'====CD>>'+requestType.cDsCount +'====RC=>'+requestType.rCsCount+'===NCIRC==>'+requestType.NCIRCsCount+'=====NCICD-->>'+requestType.NCICDsCount);
      
   
		UserDetail obUserDetail = getFirmDetail(objAccount); // get firm details 
		
		system.debug('obUserDetail------------>'+obUserDetail);
		
		InquiryDetail objInquiryDetail = getInquiryDetail(mapFirmInquiry, obUserDetail, (obUserDetail.strFirmType == 'Joint')); // get inquiry details
		
		system.debug('objInquiryDetail------------>'+objInquiryDetail);
      
		String strEmailType = 'Not Found';
		// commented on 24/01/2018 becasue not used anywhere
		//String strAARSEmailType = '';
		
		//below for email type only --------> Start  
		
		if(objInquiryDetail.isJointFirm){
			
			system.debug('objInquiryDetail----------->'+objInquiryDetail);
			
			if( (objInquiryDetail.bMCMCDFound || objInquiryDetail.bAARSCDFound || objInquiryDetail.b_ACF_CD_Found) 
					&& !objInquiryDetail.bAARSRCFound && !objInquiryDetail.b_ACF_RC_Found && ! objInquiryDetail.bMCMRCFound){
				
				// for RC Only block 
				strEmailType = 'RC Only';
				
			}else if( (objInquiryDetail.bAARSRCFound || objInquiryDetail.b_ACF_RC_Found || objInquiryDetail.bMCMRCFound) 
						&& !objInquiryDetail.bMCMCDFound && !objInquiryDetail.bAARSCDFound && !objInquiryDetail.b_ACF_CD_Found ){
				
				// for CD Only block
				strEmailType = 'CD Only';
				
			}else if( (objInquiryDetail.bAARSRCFound || objInquiryDetail.b_ACF_RC_Found || objInquiryDetail.bMCMRCFound) 
						&& (objInquiryDetail.bAARSRCFound || objInquiryDetail.b_ACF_RC_Found || objInquiryDetail.bMCMRCFound) ){
				
				// make it blank
				strEmailType = '';
				
			}else if(!objInquiryDetail.bMCMCDFound && !objInquiryDetail.bAARSCDFound && !objInquiryDetail.b_ACF_CD_Found 
						&& !objInquiryDetail.bAARSRCFound && !objInquiryDetail.b_ACF_RC_Found && !objInquiryDetail.bMCMRCFound){
				
				// for Both 
				strEmailType = 'BOTH';
			}
			
			 // commented as new logic suggested by shelly ludwig 
			/*
			if(!objInquiryDetail.bMCMRCFound  && !objInquiryDetail.bMCMCDFound && !objInquiryDetail.bAARSCDFound  && !objInquiryDetail.bAARSRCFound
			  ||(objInquiryDetail.bMCMRCFound  && !objInquiryDetail.bMCMCDFound && !objInquiryDetail.bAARSCDFound  && !objInquiryDetail.bAARSRCFound) 
			  ||(!objInquiryDetail.bMCMRCFound && objInquiryDetail.bMCMCDFound  &&  !objInquiryDetail.bAARSCDFound && !objInquiryDetail.bAARSRCFound) 
			  ||(!objInquiryDetail.bMCMRCFound && !objInquiryDetail.bMCMCDFound &&  objInquiryDetail.bAARSCDFound  && !objInquiryDetail.bAARSRCFound) 
			  ||(!objInquiryDetail.bMCMRCFound && !objInquiryDetail.bMCMCDFound && !objInquiryDetail.bAARSCDFound  && objInquiryDetail.bAARSRCFound) 
			  ||(objInquiryDetail.bMCMRCFound  && !objInquiryDetail.bMCMCDFound &&  objInquiryDetail.bAARSCDFound  &&  !objInquiryDetail.bAARSRCFound)
			  ||(!objInquiryDetail.bMCMRCFound && objInquiryDetail.bMCMCDFound  &&  !objInquiryDetail.bAARSCDFound && objInquiryDetail.bAARSRCFound)
			  ||(objInquiryDetail.bMCMRCFound  && objInquiryDetail.bMCMCDFound  &&  !objInquiryDetail.bAARSCDFound && !objInquiryDetail.bAARSRCFound)
			  ||(!objInquiryDetail.bMCMRCFound && !objInquiryDetail.bMCMCDFound && objInquiryDetail.bAARSCDFound   && objInquiryDetail.bAARSRCFound)
			 ){
						 
			}else{

	             if((!objInquiryDetail.bMCMRCFound || !objInquiryDetail.bAARSRCFound || !objInquiryDetail.b_ACF_RC_Found) 
	             		&& objInquiryDetail.bMCMCDFound && objInquiryDetail.bAARSCDFound && objInquiryDetail.b_ACF_CD_Found){
	             			
	                strEmailType = 'RC Only';
	             }
	             
	             if((!objInquiryDetail.bMCMCDFound || !objInquiryDetail.bAARSCDFound || !objInquiryDetail.b_ACF_CD_Found)
	             		 && objInquiryDetail.bMCMRCFound && objInquiryDetail.bAARSRCFound && objInquiryDetail.b_ACF_RC_Found){
	             		 	
	                strEmailType = 'CD Only';
	             }
         	} */
         	
         	system.debug('strEmailType----------->'+strEmailType);
         
		}else{
			
			 // below commented code not used anywhere 
			 
	         /*String strDepartMent = '';
	         
	         strDepartMent = obUserDetail.bMCMOnly ? 'MCM' : 'AA'; */
	         
	         if(!objInquiryDetail.bRCFound && !objInquiryDetail.bCDFound){
	            
	            strEmailType = 'BOTH';
	            
	         }else if(objInquiryDetail.bRCFound && !objInquiryDetail.bCDFound){
	            
	            strEmailType = 'CD Only';
	            
	         }else if(!objInquiryDetail.bRCFound && objInquiryDetail.bCDFound){
	            
	            strEmailType = 'RC Only';
	            
	         }
	         
	         system.debug('strEmailType----------->'+strEmailType);
     	}
     	
     	//below for email type only --------> End 
    
		Boolean isActive = true;
    
		if(strEmailType == 'Not Found'){ 
		    isActive = false;
		    strEmailType = '';
		}
		
		system.debug('strEmailType----------->'+strEmailType);
		
		// creating consumer history record ====== if exist then we will update otherwise we will insert a new record 
		
		Consumer_Inquirie_History__c obj = getExistingEnquiry(objAccount.id, year, month);
		
		system.debug('Consumer_Inquirie_History__c obj ------------>'+obj);
   
		obj.Account__c = objAccount.id;        
		
		system.debug('Month-------->'+month+'-------year---------->'+year);
		
		if(month.length() == 1){
	      obj.Name = 'CIS:Month:0' + month + ' Year' + year;  // making the year in two digit format
		}else{
	      obj.Name = 'CIS:Month:' + month + ' Year' + year;  
		}
		
		obj.Year__c = year;      
		obj.Month__c = month;
		obj.Template_Type__c = strEmailType;
		
		//obj.Firm_Type__c=(objInquiryDetail.isJointFirm)?'Joint':'Single';
		
		obj.Firm_Type__c = obUserDetail.strFirmType;
       
		obj.Is_Monthly_Reminder__c = isMonthlyReminder;
		obj.Is_Business_Day_Reminder__c = isOverDueReminder;
    
		obj.RC__c = objInquiryDetail.bRCFound;
		obj.CD__c = objInquiryDetail.bCDFound;
      
		obj.MCM_RC__c = objInquiryDetail.bMCMRCFound;
		obj.MCM_CD__c = objInquiryDetail.bMCMCDFound;
		obj.AARS_RC__c = objInquiryDetail.bAARSRCFound;
		obj.AARS_CD__c = objInquiryDetail.bAARSCDFound;
		obj.ACF_RC__c = objInquiryDetail.b_ACF_RC_Found;
		obj.ACF_CD__c = objInquiryDetail.b_ACF_CD_Found;
		
		//Record Type
		
		obj.RecordTypeID = Utility.getCISCMRecordType('CIS');
		
		//Count Update
		
		obj.CD_Count__c =requestType.cDsCount;
		obj.RC_Count__c = requestType.rCsCount;
		obj.NCI_CD_Count__c = requestType.NCICDsCount;
		obj.NCI_RC_Count__c = requestType.NCIRCsCount;      
		obj.Is_Email_Send__c = isEmailSend;
      
		system.debug('Consumer_Inquirie_History__c obj ------------>'+obj);
		
		if(isOverDueReminder){
		    
		    System.debug('*******Follow Up RUn =====11111111111==========================strEmailType>>>>'+strEmailType+'==isOverDueReminder=='+isOverDueReminder+'---'+obj.Name+'==='+obj.Account__c+'=='+obj.Template_Type__c);
		     
		    if(strEmailType != ''){
		    	System.debug('*******Follow Up RUn =========2222222222======================>>>>'+strEmailType);    
		    	obj.Is_Active__c = true;  
		    }
		     
		}
		
		system.debug('Consumer_Inquirie_History__c obj ------------>'+obj);
      
		System.debug('*******Follow Up RUn =====33333====='+obj.Is_Active__c); 
	    upsert obj;
		
		system.debug('isMonthlyReminder---------->'+isMonthlyReminder);
		system.debug('isOverDueReminder---------->'+isOverDueReminder);
		
		if(isMonthlyReminder && !isOverDueReminder){
			// Entered in this block when schedule monthly class called.
			
			CIS_Counts__c updateCount = new CIS_Counts__c();
			
			System.debug('Hello=========Before====objAccount.id='+objAccount.id+'===YEAR==='+year+'====MONTH==='+month);
			updateCount = getExistingCICount(objAccount.id, year, month);
			
			System.debug('Hello==========After==========updateCount>>>>>'+'----updateCount-----'+updateCount+'==objAccount.id='+objAccount.id+'===YEAR==='+year+'====MONTH==='+month);
    
     
			if(updateCount != null){    
			   
			   if(updateCount.Firm_Type__c == null){
				   updateCount.Firm_Type__c = obUserDetail.strFirmType;
				   
				   system.debug('======entered in the update cis record block =======');
				   
				   system.debug(' isMonthlyReminder && !isOverDueReminder ----------> CIS update count'+updateCount);      
				   update updateCount;
			   }
			   
			}else{
				system.debug('======entered in the insert cis record block =======');	
        		System.debug('====ELSE===');        
				CIS_Counts__c newCount = new CIS_Counts__c();        
				string strMnth = '';
				
				
				if(month != '12'){ // month other than december block
					system.debug('Entered in if block i.e. other than december month ');
					
					strMnth =  String.valueOf(Integer.valueOf(month)+1); // increment month by 1
					system.debug('year value line no 393-------->'+Integer.valueOf(year));
					year = String.valueOf(Integer.valueOf(year));
					
					system.debug('strMnth------------->'+strMnth);
					
				}else{ // december month block
        			
        			system.debug('Entered in else block i.e. december month ');
        			
					strMnth = '01';   // Make it january or increment month by 1
					system.debug('Year Value line no 403----------->'+String.valueOf(Integer.valueOf(year) + 1));
					year = String.valueOf(String.valueOf(Integer.valueOf(year) + 1)); // as it is december month so increase year by 1 also
					
					system.debug('strMnth------------->'+strMnth);
					system.debug('year value ------------->'+year);
        		}
        
				if(strMnth.length() == 1){    
					strMnth = ('0' + strMnth); 
				}  
				
				system.debug('year--------->'+year);
     
				newCount.Reporting_Month__c = strMnth; 
				newCount.Name = 'Month:' + strMnth + ' Year:' + Year;
				newCount.Reporting_Year__c = year;
				newCount.Firm_Name__c = objAccount.id;        
				newCount.Firm_Type__c = obUserDetail.strFirmType;
       
				System.debug('=============newCount>>>>>'+newCount);
				insert newCount;   
    
			}
		}
		
		
		system.debug('Items to be deleted ----------->'+[ SELECT id FROM Email_Reminder__c WHERE Consumer_Inquirie_History__c = :obj.id ]);
		
       delete[ SELECT id FROM Email_Reminder__c WHERE Consumer_Inquirie_History__c = :obj.id ];
       
       List<Email_Reminder__c> lst = new List<Email_Reminder__c>();

       if( !obUserDetail.lstUser.isEmpty() ){
       	
			for(User objUser : obUserDetail.lstUser){
				
			    lst.add(new Email_Reminder__c(Name = obj.Name, RecordTypeID = Utility.getCISCMEmail_ReminderRecordType('CIS'), Consumer_Inquirie_History__c = obj.id, User__c = objUser.id, Last_Email_Alert__c = system.Now()));
			
			}
			
			 system.debug('email remainder list ------------>'+lst);
			 insert lst;
			
		}
  }
  
 	global void finish(Database.BatchableContext BC){
		
		system.debug('executing final block-------->');
		
		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CompletedDate,CreatedBy.Email 
							FROM AsyncApexJob 
							WHERE Id = :BC.getJobId() ];
		if(a != null){
			
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

			String[] toAddresses = new String[] {'lcsalesforceadmin@mcmcg.com'};
		
			// Add all CC Address via Custom Setting....
			List<String> lstEmailId = new List<String>();
			
			for (EmailNotification__c objEmail : EmailNotification__c.getAll().values()){
				lstEmailId.add(objEmail.Email__c);
			}
			
			if(lstEmailId.size()>0){
				mail.setCcAddresses(lstEmailId);
			}
		
			mail.setToAddresses(toAddresses);
			
			if(isMonthlyReminder && isOverDueReminder && isEmailSend){
				
				mail.setSubject('CIS Monthly Follow Up batch completed: ' + a.CompletedDate);   
				mail.setPlainTextBody('The CIS follow up job has processed '+ a.JobItemsProcessed +' firms with '+ a.NumberOfErrors + ' failures.');// for ' +month+'-'+Year);
				
			}else if(isMonthlyReminder && !isOverDueReminder && isEmailSend){
				
				mail.setSubject('CIS Monthly Reminder batch completed: ' + a.CompletedDate);    
				mail.setPlainTextBody('The CIS reminder job has processed  '+ a.JobItemsProcessed +' firms with '+ a.NumberOfErrors + ' failures.');// . for ' +month+'-'+Year);
			}else {
				 //(isMonthlyReminder || isOverDueReminder && !isEmailSend)
				mail.setSubject('CIS Unscheduled Alert/Follow Up batch completed: ' + a.CompletedDate);    
				mail.setPlainTextBody('The CIS Manual Apex job has processed '+ a.JobItemsProcessed +' firms with '+ a.NumberOfErrors + ' failures for ' + month + '-' + Year);
		
			} 
			
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		
		}
	   
	}
	
	
	/* It will create all active firm zero record for each strMonth on last working day so 
             that trigger will update its rest of the counts value*/
             
   public CIS_Counts__c getExistingCICount(String firmId, String strYear, String strMonth){
   	
		system.debug('firm Id------->'+firmId);
		system.debug('strYear------->'+strYear);
		system.debug('strMonth------->'+strMonth);
		
		CIS_Counts__c obj = new CIS_Counts__c();
		obj = null;
       
		if(strMonth.length() == 1){    
			strMonth = ('0' + strMonth); 
		}
		 
		if(strMonth != '12'){
			
        	System.debug('====== Month except december ======');
        	
        	strMonth =  String.valueOf(Integer.valueOf(strMonth) + 1); // adding 1 month
        	         
        }else{
        	
        	system.debug('=========== December month block ==============');
        	
        	strMonth = '01';  // make it january i.e. 01
        	        
        	strYear = String.valueOf( Integer.valueOf(strYear) + 1); // increment year by 1
        }
        
        
		try{
			
			List<CIS_Counts__c> cisCountList = new List<CIS_Counts__c>();
			 
			cisCountList = [SELECT c.SystemModstamp, c.Reporting_Year__c, c.Reporting_Month__c, c.Reporting_Month_Year__c, 
				                  c.RC_MCM__c, c.RC_AARS__c,c.OwnerId, c.Name, c.NCI_RC_MCM__c, c.NCI_RC_AARS__c, c.NCI_CD_MCM__c, 
				                  c.NCI_CD_AARS__c, c.Id, c.Firm_Type__c, 
				                  c.Firm_Name__c,c.Reporting_Year_Month_FirmName__c, c.CD_MCM__c, c.CD_AARS__c, c.CD_ACF__c,
				                  c.NCI_CD_ACF__c, c.RC_ACF__c, c.NCI_RC_ACF__c 
			                  FROM CIS_Counts__c c 
			                  WHERE c.Reporting_Month__c = :strMonth 
			                  AND c.Reporting_Year__c = :strYear 
			                  AND c.Firm_Name__c = :firmId ORDER BY LastModifiedDate DESC LIMIT 1]; //and Is_Active__c=true
			
			system.debug('cisCountList------------>'+cisCountList);
			                  
			if(!cisCountList.isEmpty()){
				obj = cisCountList.get(0); 
			}
	                   
			System.debug('obj----->>>'+obj);
			return obj;
		}catch(Exception ex){
        	System.debug('Exception occurs in getExistingCICount ---------->'+ex);
		}
      	return obj;
   }
   
   
   
   public Consumer_Inquirie_History__c getExistingEnquiry(String firmId, String strYear, String strMonth){
   	
		Consumer_Inquirie_History__c obj = new Consumer_Inquirie_History__c();
		try{
			List<Consumer_Inquirie_History__c> consumerInquiryList = [SELECT c.Year__c, c.User__c, c.Template_Type__c, c.RC__c, c.OwnerId, c.Name, 
																			c.Month__c, c.MCM_RC__c, c.MCM_CD__c, c.LastModifiedDate, 
																			c.LastModifiedById, c.Is_Monthly_Reminder__c, c.Is_Email_Send__c, 
													                  		c.Is_Business_Day_Reminder__c, c.Is_Active__c, c.Id, c.Firm_Type__c, 
													                  		c.CreatedDate, c.CreatedById, c.Contact__c, c.ConnectionSentId, 
													                  		c.ConnectionReceivedId, c.CD__c, c.Account__c, c.AARS_RC__c, c.AARS_CD__c,
													                  		c.ACF_CD__c, c.ACF_RC__c 
													                 	FROM Consumer_Inquirie_History__c c 
													                 	WHERE Month__c = :strMonth 
													                 	AND Year__c = :strYear 
													                 	AND Account__c = :firmId 
													                 	AND RecordTypeID = :Utility.getCISCMRecordType('CIS') 
													                 	ORDER BY LastModifiedDate DESC limit 1]; //and Is_Active__c=true
			if(!consumerInquiryList.isEmpty()){
				obj = consumerInquiryList.get(0);
				return obj;
			}
		}catch(Exception ex){
	        system.debug('exception occurs in getExistingEnquiry method ----->'+ex);
	     }
	     return obj;
   }
   
   public UserDetail getFirmDetail(Account accountObj){
        
        UserDetail objUser = new UserDetail();
        objUser.lstUser = new List<User>();
        
        // commented on 24/01/2018 now we will not use department field to choose MCM or AA
        //Map<String,String> mapDepartment = new  Map<String,String>() ;
        
        List<Profile> getUserProfile = new List<Profile>();
        
        try{
		        getUserProfile = [SELECT id FROM Profile WHERE Name = :Utility.getTW_CISProfileLabel() OR Name = :Utility.getCISProfileNameLabel()];
		        
		        for(User objUserDetail : [SELECT id, Department FROM User WHERE Contact.AccountId = :accountObj.id 
		        							AND isActive = true
		                                	AND profileid = :getUserProfile]){
		              
		              /*if(objUserDetail.Department == null || objUserDetail.Department == ''){
		              
		                	mapDepartment.put('MCM','MCM');
		                	mapDepartment.put('AA','AA');
		                	
		              }else{
		              	
		                    mapDepartment.put(objUserDetail.Department, objUserDetail.Department);
		              }*/
		              
		               objUser.lstUser.add(objUserDetail);
		         }
		      
				// if(mapDepartment.get('MCM') != null && mapDepartment.get('AA') != null){ changing condition 
					
					//setFirmDetail(objUser,'Joint', false, false);
					
				if(accountObj.MultipleAccountTypes__c != null && accountObj.MultipleAccountTypes__c){
						
				    objUser.strFirmType = 'Joint';
					objUser.bAARSOnly = false;
				    objUser.bMCMOnly = false;
				    objUser.bACFOnly = false;
				    
				}else if( (accountObj.Firm_Status_IN__c == STATUS_ACTIVE || accountObj.Firm_Status_IN__c == STATUS_INACTIVE 
								|| accountObj.Agency_Status_IN__c == STATUS_ACTIVE || accountObj.Agency_Status_IN__c == STATUS_INACTIVE ) 
							&& !(accountObj.Firm_Status_IN_AARS__c == STATUS_ACTIVE && accountObj.Firm_Status_IN_AARS__c == STATUS_INACTIVE)
							&& !(accountObj.Firm_Status_IN_ACF__c == STATUS_ACTIVE && accountObj.Firm_Status_IN_ACF__c == STATUS_INACTIVE) ){
					
					// for MCM only 
					// if firm status in or agency status in is active or inactive then we select Firm type is MCM
					//setFirmDetail(objUser, 'MCM', false, true);
					
					objUser.strFirmType = 'MCM';
					objUser.bAARSOnly = false;
				    objUser.bMCMOnly = true;
				    objUser.bACFOnly = false;
				    
				}else if( (accountObj.Firm_Status_IN_AARS__c == STATUS_ACTIVE || accountObj.Firm_Status_IN_AARS__c == STATUS_INACTIVE) 
							&& !(accountObj.Firm_Status_IN__c == STATUS_ACTIVE && accountObj.Firm_Status_IN__c == STATUS_INACTIVE)
							&& !(accountObj.Firm_Status_IN_ACF__c == STATUS_ACTIVE && accountObj.Firm_Status_IN_ACF__c == STATUS_INACTIVE) ){
					// for AA only 
					//setFirmDetail(objUser, 'AA', true, false);
					
					objUser.strFirmType = 'AA';
					objUser.bAARSOnly = true;
				    objUser.bMCMOnly = false;
				    objUser.bACFOnly = false;
				    
				}else if( (accountObj.Firm_Status_IN_ACF__c == STATUS_ACTIVE || accountObj.Firm_Status_IN_ACF__c == STATUS_INACTIVE) 
							&& !(accountObj.Firm_Status_IN__c == STATUS_ACTIVE && accountObj.Firm_Status_IN__c == STATUS_INACTIVE)
							&& !(accountObj.Firm_Status_IN_AARS__c == STATUS_ACTIVE && accountObj.Firm_Status_IN_AARS__c == STATUS_INACTIVE) ){
					
				 	// for ACF only 
				 	objUser.strFirmType = 'ACF';
					objUser.bAARSOnly = false;
				    objUser.bMCMOnly = false;
				    objUser.bACFOnly = true;
				 
				}
		     
		     system.debug('objUser------------>'+objUser);
		      return objUser;
        }catch(Exception ex){
        	system.debug('Exception occurs in getFirmDetail---------->'+ex);
        	return objUser;
        }
   }
   
   public InquiryDetail getInquiryDetail(Map<String,Map<String,String>> mapUserInquiryType, UserDetail objUser, Boolean bJointFirm){
     
     	system.debug('mapUserInquiryType-------->'+mapUserInquiryType);
     	system.debug('objUser-------->'+objUser);
     	system.debug('bJointFirm-------->'+bJointFirm);
     	
		InquiryDetail objUserInquiry = new InquiryDetail();
		
		try{
				objUserInquiry.isJointFirm = bJointFirm;
				if(bJointFirm){
					
		          for(String str : mapUserInquiryType.keySet()){
		               
		               if(str == 'MCM'){
		                  
		                  if(mapUserInquiryType.get(str) != null && mapUserInquiryType.get(str).get('RC') != null){
		                     objUserInquiry.bMCMRCFound=true;
		                  }
		                  
		                  if(mapUserInquiryType.get(str) != null && mapUserInquiryType.get(str).get('CD') != null){
		                    objUserInquiry.bMCMCDFound = true;
		                  }
		                  
		               }
		               
		               if(str == 'AA'){
		               	
		                  if(mapUserInquiryType.get(str) != null && mapUserInquiryType.get(str).get('RC') != null){
		                     objUserInquiry.bAARSRCFound = true;
		                  }
		                  if(mapUserInquiryType.get(str) != null && mapUserInquiryType.get(str).get('CD') != null){
		                    objUserInquiry.bAARSCDFound = true;
		                  }
		                  
		               }
		               
		               if(str == 'ACF'){
		               	  
		               	  if(mapUserInquiryType.get(str) != null && mapUserInquiryType.get(str).get('RC') != null){
		                     objUserInquiry.b_ACF_RC_Found = true;
		                  }
		                  if(mapUserInquiryType.get(str) != null && mapUserInquiryType.get(str).get('CD') != null){
		                    objUserInquiry.b_ACF_CD_Found = true;
		                  }
		                  
		               }
		               
		           }        
		       }else{
		             for(String str : mapUserInquiryType.keySet()){
		                  
		                  if(mapUserInquiryType.get(str) != null && mapUserInquiryType.get(str).get('RC') != null){
		                    objUserInquiry.bRCFound = true;
		                  }
		                  
		                  if(mapUserInquiryType.get(str) != null && mapUserInquiryType.get(str).get('CD') != null){
		                    objUserInquiry.bCDFound = true;
		                  }
		                  
		             }
		       }
		         
		      return objUserInquiry;
		}catch(Exception ex){
			system.debug('exception occurs in getInquiryDetail'+ex);
			return objUserInquiry;
		}
		
   }
   
   // wrapper classes
   
	/*public void setFirmDetail(UserDetail objUser, String strFirmType, Boolean bAARSOnly, Boolean bMCMOnly){
	   	
	    objUser.bAARSOnly = bAARSOnly;
	    objUser.strFirmType = strFirmType;
	    objUser.bMCMOnly = bMCMOnly;
	   
	}*/
   
	global class UserDetail{
	  	
	    public String strFirmType {get;set;}
	    public boolean bMCMOnly {get;set;}
	    public boolean bAARSOnly {get;set;}
	    public boolean bACFOnly {get; set;}
	    public Map<String,Map<String,User>> mapUser {get;set;}
	    public List<User> lstUser {get;set;}
	  
	}
  
	global class InquiryDetail{
		
		public boolean bRCFound {get;set;}
		public boolean bCDFound {get;set;}
		public String strFirmType {get;set;}
		 
		public boolean isJointFirm {get;set;}
		public boolean bMCMRCFound {get;set;}
		public boolean bMCMCDFound {get;set;}
		public boolean bAARSRCFound {get;set;}
		public boolean bAARSCDFound {get;set;}
		public boolean b_ACF_RC_Found {get;set;}
		public boolean b_ACF_CD_Found {get;set;}
		 
		 // Count of all CDs, RCs, NCI-CD, NCI-RC
		public integer cDsCount {get;set;}
		public integer rCsCount {get;set;}
		public integer NCICDsCount {get;set;}
		public integer NCIRCsCount {get;set;}
		 
		public InquiryDetail(){
			bRCFound = false;
		    bCDFound = false;
		    isJointFirm = false;
		    bMCMRCFound = false;
		    bMCMCDFound = false;
		    bAARSRCFound = false;
		    bAARSCDFound = false;
		    b_ACF_RC_Found = false;
			b_ACF_CD_Found = false;
		    cDsCount = 0;
		    rCsCount = 0;
		    NCICDsCount = 0;
		    NCIRCsCount = 0;
		    
		}
	    
	}

}