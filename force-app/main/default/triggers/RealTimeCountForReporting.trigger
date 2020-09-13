/*
##############################################################################################################################################
# Project Name..........: LO - Customer Community Consumer Inquiries Automate follow up 
# File..................: Class : "RealTimeCountForReporting "
# Version...............: 1.0
# Created by............: Sunny Kumar   
# Created Date..........: 19-June-2014  
# Last Modified by......: Sunny Kumar
# Last Modified Date....: 25-July-2014                         
# Description...........: It will collect all Consumer Enquiry and process them based on active consumers as per Single i.e. MCM/AA or
#                          as Joint Firm which deals in both i.e.MCM and AA respectively. Based on all permutations and combinations will
#                          Further notify all Firms for CI-Monthly Reporting Comply.
##############################################################################################################################################
*/
/*
Select Id, OwnerId, Name, RecordTypeId,RecordType.Name,Consumer_Name__c, Firm_Name__c, Firm_Name__r.Name,Reporting_Year__c,  
Response_to_Consumer__c, Type__c,Account_Number__c, Nature_of_Inquiry__c, Source_of_Inquiry__c, Inquiry_Summary__c, 
Wrong_Party_Complaint__c, If_Yes_Wrong_Party_Phone_and_Address__c, Account_Type__c, AARS__c, MCM__c, 
RecordAccountTypeDevCombination__c 
FROM Consumer_Inquiries__c where Firm_Name__r.Name='Encore' and Reporting_Month__c='' and  
Reporting_Year__c='2013'

Select c.SystemModstamp, c.Reporting_Year__c, c.Reporting_Month__c, c.Reporting_Month_Year__c, c.RC_MCM__c, c.RC_AARS__c, 
                       c.OwnerId, c.Name, c.NCI_RC_MCM__c, c.NCI_RC_AARS__c, c.NCI_CD_MCM__c, c.NCI_CD_AARS__c, c.MCM__c, 
                       c.LastReferencedDate, c.LastModifiedDate, c.LastModifiedById, c.LastActivityDate, c.IsDeleted, c.Id, c.Firm_Type__c, 
                       c.Firm_Name__c, c.CreatedDate, c.CreatedById,c.Reporting_Year_Month_FirmName__c, c.ConnectionSentId, c.ConnectionReceivedId, c.CD_MCM__c, c.CD_AARS__c, 
                       c.AARS__c From CIS_Counts__c c 
                       where c.Reporting_Month__c ='04' and 
                       c.Reporting_Year__c='2013' and
                       c.Firm_Name__c='001K000000ylSjW'

*/

trigger RealTimeCountForReporting on Consumer_Inquiries__c (after insert,after update,after delete,after undelete) { 
	
	Set<Id> setFirmId = new set<Id>();
	Set<String> setYear = new Set<String>();
	Set<String> setMonth = new Set<String>();
	Set<String> setYearMonthFirmName = new Set<String>();
	map<String,Consumer_Inquiries__c> mapFirmYrMonthCI = new map<String,Consumer_Inquiries__c>();
	Map<String,CIS_Counts__c> mapConsumerHistory = new Map<String,CIS_Counts__c>();
	public string ModifyMonth {get;set;}
	public string FirmId;
	public static Final String STATUS_ACTIVE = 'Active';
	public static Final String STATUS_INACTIVE = 'Inactive';
	
	// Extract CI RecordType.....
	Map<String,Consumer_Inquiries__c> mapConsumerInq=new Map<String,Consumer_Inquiries__c>();
	Map<String,String> mapRecordType=new  Map<String,String>();
	     Schema.sObjectType objType = Consumer_Inquiries__c.getSObjectType();
	     Schema.DescribeSObjectResult sObjReslt = objType.getDescribe();  
	     Map<String,Schema.RecordTypeInfo> rtMapByName = sObjReslt.getRecordTypeInfosByName();
	     
	     for(String str:rtMapByName.keySet()){
	          Schema.RecordTypeInfo rtByName =  rtMapByName.get(str);
	         if(rtByName.isAvailable()){
	            mapRecordType.put(rtByName.getRecordTypeId(),rtByName.getName());
	         }  
	     }
	//........Extracted Record Type.......
	 
	 system.debug('mapRecordType------------->'+mapRecordType);
	 
	for(Consumer_Inquiries__c obj : (!Trigger.isDelete) ? trigger.new : trigger.old){
	// Sunny - Added to get the year, month and firm for old map in case of update required
	  if(Trigger.IsUpdate){
	  	
			if(Trigger.oldMap.get(obj.Id).Firm_Name__c != Null){
				
			 	setFirmId.add(Trigger.oldMap.get(obj.Id).Firm_Name__c);
			 	
			}
	    
		    if(Trigger.oldMap.get(obj.Id).Reporting_Month__c != Null){
		    	
			     string ModifyMonthOld = '';
			     ModifyMonthOld = Trigger.oldMap.get(obj.Id).Reporting_Month__c;
		     
			     if(ModifyMonthOld !='' && ModifyMonthOld != null){      
			        
			        if(ModifyMonthOld.length() == 1){
			        
				         ModifyMonthOld = '0' + ModifyMonthOld ;
				         setMonth.add(ModifyMonthOld);
			        
			        }else{
			        	
				        setMonth.add(ModifyMonthOld );
				        
			        }
			    }
		    }
		    
		    if(Trigger.oldMap.get(obj.Id).Reporting_Year__c != Null){
		    	
			    setYear.add(Trigger.oldMap.get(obj.Id).Reporting_Year__c);
			    
		    }
	   
	   } 
	   
	    setFirmId.add(obj.Firm_Name__c);
	    ModifyMonth = '';
	    ModifyMonth = obj.Reporting_Month__c;
	    if(ModifyMonth != '' && ModifyMonth != null){       //
	        if(ModifyMonth.length() == 1){
	         ModifyMonth = '0' + ModifyMonth;
	         setMonth.add(ModifyMonth);
	        
	        }else{
		        setMonth.add(ModifyMonth);
	        }
	    }
	    
	    setYear.add(obj.Reporting_Year__c);
	    setYearMonthFirmName.add(obj.Reporting_Year__c+'-' +ModifyMonth+'-' +obj.Firm_Name__c);
	    mapFirmYrMonthCI.put(obj.Reporting_Year__c+'-' +obj.Reporting_Month__c+'-' +obj.Firm_Name__c,obj);
	}
	
	system.debug('setYear-------------->'+setYear);
	system.debug('setYearMonthFirmName-------------->'+setYearMonthFirmName);
	system.debug('mapFirmYrMonthCI-------------->'+mapFirmYrMonthCI);
	 
	// Extract Historical data
	if(!mapFirmYrMonthCI.isEmpty()){
	    
	for(CIS_Counts__c obj:[Select c.SystemModstamp, c.Reporting_Year__c, c.Reporting_Month__c, c.Reporting_Month_Year__c, 
	                       c.RC_MCM__c, c.RC_AARS__c,c.OwnerId, c.Name, c.NCI_RC_MCM__c, c.NCI_RC_AARS__c, c.NCI_CD_MCM__c, 
	                       c.NCI_CD_AARS__c,c.IsDeleted, c.Id, c.Firm_Type__c, 
	                       c.Firm_Name__c,c.Reporting_Year_Month_FirmName__c, c.CD_MCM__c, c.CD_AARS__c, 
	                       c.CD_ACF__c, c.NCI_CD_ACF__c, c.RC_ACF__c, c.NCI_RC_ACF__c  
	                       From CIS_Counts__c c
	                       where c.Reporting_Month__c IN:setMonth and 
	                       c.Reporting_Year__c IN:setYear and
	                       c.Firm_Name__c IN: setFirmId 
	                      ]){ //and Is_Active__c=true and  Reporting_Year_Month_FirmName__c IN:mapFirmYrMonthCI.Keyset()
	    
	    mapConsumerHistory.put(obj.Reporting_Year_Month_FirmName__c,obj);
	  }
	}
	
	system.debug('mapConsumerHistory------------>'+mapConsumerHistory);
	
	List<Consumer_Inquirie_History__c> lst=new List<Consumer_Inquirie_History__c>();
	SObjectType objToken = Schema.getGlobalDescribe().get('CIS_Counts__c'); 
	DescribeSObjectResult objDef = objToken.getDescribe();
	Map<String, SObjectField> fields = objDef.fields.getMap();
	
	Map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();  
	Schema.sObjectType sObjType = globalDescription.get('CIS_Counts__c');  
	sObject sObjectToBind = sObjType.newSObject(); 
	sObject sObjectToBindOLD = sObjType.newSObject(); 
	map<ID,string> mapAccDept = new map<ID,string>();
	map<string,string> mapAccName = new map<string,string>();
	
	if(Trigger.isInsert || Trigger.isUpdate){
		
	    String CIProfileName;
	
	    // Get Profile Name from Custom Setting Details
	    ProfileName__c getProfileName = ProfileName__c.getInstance('CI_ProfileName');
	    if(getProfileName != null){
	    	CIProfileName = getProfileName.ProfileLabel__c;  
	    } 
	    
	    if(CIProfileName!=null && CIProfileName!=''){      
	    	// Below line commented on 25/01/2018 not used anywhere
	         //Set<Id> accId = new Set<Id>(); 
	         system.debug('CIProfileName----------->'+CIProfileName); 
	         system.debug('entered in the condition debug point 1----------->'); 
	                 
	         for(User objUser : [Select id, ContactId, profile.name, Department, Contact.AccountId, Contact.Account.Name, 
	         							Contact.Account.MultipleAccountTypes__c, Contact.Account.Firm_Status_IN_AARS__c, 
	         							Contact.Account.Firm_Status_IN_ACF__c, Contact.Account.Firm_Status_IN__c, 
	         							Contact.Account.Agency_Status_IN__c 
	         						FROM User WHERE isActive=true 
	         						AND profile.name=:CIProfileName]){
	         		
	         		system.debug('objUser.Contact.AccountId----------->'+objUser.Contact.AccountId);					
         			if(objUser.Contact.AccountId == null){
         				continue;
         			}
	         			
	                if(objUser.Contact.Account.MultipleAccountTypes__c != null && objUser.Contact.Account.MultipleAccountTypes__c){
		            	
		            		mapAccDept.put(objUser.Contact.AccountId, 'Joint');
		            	
		            }else if( (objUser.Contact.Account.Firm_Status_IN__c == STATUS_ACTIVE || objUser.Contact.Account.Firm_Status_IN__c == STATUS_INACTIVE
		            				|| objUser.Contact.Account.Agency_Status_IN__c == STATUS_ACTIVE || objUser.Contact.Account.Agency_Status_IN__c == STATUS_INACTIVE ) 
								&& !(objUser.Contact.Account.Firm_Status_IN_AARS__c == STATUS_ACTIVE && objUser.Contact.Account.Firm_Status_IN_AARS__c == STATUS_INACTIVE)
								&& !(objUser.Contact.Account.Firm_Status_IN_ACF__c == STATUS_ACTIVE && objUser.Contact.Account.Firm_Status_IN_ACF__c == STATUS_INACTIVE) ){
							
							mapAccDept.put(objUser.Contact.AccountId, 'MCM');
								
					}else if( (objUser.Contact.Account.Firm_Status_IN_AARS__c == STATUS_ACTIVE || objUser.Contact.Account.Firm_Status_IN_AARS__c == STATUS_INACTIVE) 
								&& !(objUser.Contact.Account.Firm_Status_IN__c == STATUS_ACTIVE && objUser.Contact.Account.Firm_Status_IN__c == STATUS_INACTIVE)
								&& !(objUser.Contact.Account.Firm_Status_IN_ACF__c == STATUS_ACTIVE && objUser.Contact.Account.Firm_Status_IN_ACF__c == STATUS_INACTIVE) ){
							
							mapAccDept.put(objUser.Contact.AccountId, 'AA');
							
					}else if( (objUser.Contact.Account.Firm_Status_IN_ACF__c == STATUS_ACTIVE || objUser.Contact.Account.Firm_Status_IN_ACF__c == STATUS_INACTIVE) 
								&& !(objUser.Contact.Account.Firm_Status_IN__c == STATUS_ACTIVE && objUser.Contact.Account.Firm_Status_IN__c == STATUS_INACTIVE)
								&& !(objUser.Contact.Account.Firm_Status_IN_AARS__c == STATUS_ACTIVE && objUser.Contact.Account.Firm_Status_IN_AARS__c == STATUS_INACTIVE) ){
							
							mapAccDept.put(objUser.Contact.AccountId, 'ACF');
							
					}
		            
		            mapAccName.put(objUser.Contact.AccountId,objUser.Contact.Account.Name);
	            	
	            }
	     }
	     
	     system.debug('mapAccDept---------->'+mapAccDept);
	     system.debug('mapAccName---------->'+mapAccName);
	     
	     
        map<string,string> firmName = new map<string,string>();
        for (String s: mapAccDept.Keyset()){
        	             
            if(mapAccName.get(s)!=null && mapAccDept.get(s)!=null)
            firmName.put(mapAccName.get(s),mapAccDept.get(s));
        
        }
	
	system.debug('firmName-------->'+firmName);
	
	}  
	// Manipulating each Consumer Inquires record
	
	for(Consumer_Inquiries__c obj:(!Trigger.isDelete)? trigger.new:trigger.old){
		system.debug('debug point 2------------>');
	    ModifyMonth= '';
	    if(obj.Reporting_Month__c != null){
	    ModifyMonth=obj.Reporting_Month__c;
	    }
	    if(ModifyMonth!=null && ModifyMonth.length()==1){       
	    ModifyMonth=('0'+ModifyMonth);  
	    }     
	    string temp='';
	    if(obj.Firm_Name__c != null){
	     FirmID = obj.Firm_Name__c;
	    }
	    if(obj.Reporting_Year__c != null && ModifyMonth != null && FirmID != null ){
	    temp=obj.Reporting_Year__c+'-'+ModifyMonth+'-'+(FirmID).substring(0, 15);
	    }
	    CIS_Counts__c updateCount = new CIS_Counts__c();
	    CIS_Counts__c oldUpdateCount = new CIS_Counts__c();
	    
	    system.debug('mapConsumerHistory------------>'+mapConsumerHistory);
	    system.debug('temp------------>'+temp);
	    system.debug('mapConsumerHistory.get(temp)---------->'+mapConsumerHistory.get(temp));
	    
	    if(mapConsumerHistory.get(temp)!=null){
	         updateCount = mapConsumerHistory.get(temp);
	         
	        //  start to find out consumer type  
	         
	        String strInquiryType='';
	        String strRecordTypeName = mapRecordType.get(obj.RecordTypeId);
	        // Upadte.................................
	        if(Trigger.isUpdate){
	        	system.debug('mapAccDept.get(obj.Firm_Name__c)-------->'+mapAccDept.get(obj.Firm_Name__c));
	        	system.debug('obj.Firm_Name__c---------->'+obj.Firm_Name__c);
	        	for(String str : mapAccDept.keySet()){
	        		system.debug('str--------->'+str);
	        	}
	        	
	            // Firm Type We need to give as per our need....................Set kerna hai.......     
	            if(mapAccDept.get(obj.Firm_Name__c)!=null && updateCount.Firm_Type__c==null)
	            updateCount.Firm_Type__c = mapAccDept.get(obj.Firm_Name__c); // updating Firm_Type__c  
	            // IF Trigger is Update Trigger.....Start OF Update
	            // Case 1: when RecordtypeCombination new and old are not same but year and month combination are same
	            if(obj.ReportingYearMonthCombination__c ==Trigger.oldMap.get(obj.Id).ReportingYearMonthCombination__c 
	               && obj.RecordAccountTypeDevCombination__c!=Trigger.oldMap.get(obj.Id).RecordAccountTypeDevCombination__c)
	            {  
	                  //setting up a sample list of strings and sobjects
	                    sObjectToBind = updateCount;                                                
	                       for (Schema.SObjectField s:fields.Values())
	                       {
	                        Integer flipflop = 0; 
	                            if(String.ValueOf(s)==String.ValueOf(obj.RecordAccountTypeDevCombination__c))
	                            {
	                            	if(Integer.ValueOf(sObjectToBind.get(String.ValueOf(obj.RecordAccountTypeDevCombination__c))) != null){
			                             flipflop = Integer.ValueOf(sObjectToBind.get(String.ValueOf(obj.RecordAccountTypeDevCombination__c)));
	                            	}
	                            	
	                             flipflop +=1;
	                             sObjectToBind.put(String.ValueOf(obj.RecordAccountTypeDevCombination__c),flipflop); 
	                          
	                           }
	                           if(String.ValueOf(s)==String.ValueOf(Trigger.oldMap.get(obj.Id).RecordAccountTypeDevCombination__c)){
	                           		if(Integer.ValueOf(sObjectToBind.get(String.ValueOf(Trigger.oldMap.get(obj.Id).RecordAccountTypeDevCombination__c))) != null){
		                             	flipflop = Integer.ValueOf(sObjectToBind.get(String.ValueOf(Trigger.oldMap.get(obj.Id).RecordAccountTypeDevCombination__c)));
	                           		}
	                           		
	                             if(flipflop>0)
	                             flipflop -=1;
	                             sObjectToBind.put(String.ValueOf(Trigger.oldMap.get(obj.Id).RecordAccountTypeDevCombination__c),flipflop);
	                             
	                           }
	                   
	                        }
	          }
	          // Case 2: when RecordtypeCombination new and old are same but year and month combination are not same
	          else if(obj.ReportingYearMonthCombination__c !=Trigger.oldMap.get(obj.Id).ReportingYearMonthCombination__c 
	               && obj.RecordAccountTypeDevCombination__c==Trigger.oldMap.get(obj.Id).RecordAccountTypeDevCombination__c)
	            {
	                String OldTemp = Trigger.oldMap.get(obj.Id).ReportingYearMonthCombination__c +'-'+ String.valueOf(obj.Firm_Name__c).substring(0,15);
	                if(OldTemp!=null && mapConsumerHistory.get(OldTemp)!=null)
	                 oldUpdateCount = mapConsumerHistory.get(OldTemp);
	                    sObjectToBind = updateCount; 
	                    sObjectToBindOLD =  oldUpdateCount;             
	                    for (Schema.SObjectField s:fields.Values())
	                       {
	                        Integer flipflop = 0; 
	                        if(String.ValueOf(s)==String.ValueOf(obj.RecordAccountTypeDevCombination__c))
	                        {
	                         flipflop = Integer.ValueOf(sObjectToBind.get(String.ValueOf(obj.RecordAccountTypeDevCombination__c)));
	                         flipflop +=1;
	                         sObjectToBind.put(String.ValueOf(obj.RecordAccountTypeDevCombination__c),flipflop); 
	                         
	                         //set old
	                         Integer flipflopOLD = 0; 
	                         flipflopOLD = Integer.ValueOf(sObjectToBindOLD.get(String.ValueOf(obj.RecordAccountTypeDevCombination__c)));
	                         if(flipflopOLD>0)
	                         flipflopOLD -=1;
	                         
	                         sObjectToBindOLD.put(String.ValueOf(obj.RecordAccountTypeDevCombination__c),flipflopOLD);                       
	                      
	                       }
	                      }
	             }  
	            // if both the year month changes and also RecordType account detail also changes  
	            else if (obj.ReportingYearMonthCombination__c !=Trigger.oldMap.get(obj.Id).ReportingYearMonthCombination__c && 
	              obj.RecordAccountTypeDevCombination__c != Trigger.oldMap.get(obj.Id).RecordAccountTypeDevCombination__c)
	            {
	              String OldTemp = Trigger.oldMap.get(obj.Id).ReportingYearMonthCombination__c +'-'+ String.valueOf(obj.Firm_Name__c).substring(0,15);
	                if(OldTemp!=null && mapConsumerHistory.get(OldTemp)!=null) 
	                   oldUpdateCount = mapConsumerHistory.get(OldTemp);
	                 
	                 sObjectToBind = updateCount;  /// New count record already created 
	                 sObjectToBindOLD =  oldUpdateCount;          // Old count record record   
	                 for (Schema.SObjectField s:fields.Values())
	                       {
	                        
	                        if(String.ValueOf(s)==String.ValueOf(obj.RecordAccountTypeDevCombination__c))  // API OF count cis and ci recordAccoutType field check
	                        {
	                         Integer flipflop = 0; 
	                         flipflop = Integer.ValueOf(sObjectToBind.get(String.ValueOf(obj.RecordAccountTypeDevCombination__c)));
	                         flipflop +=1;
	                         sObjectToBind.put(String.ValueOf(obj.RecordAccountTypeDevCombination__c),flipflop); 
	                      
	                       }
	                       if(String.ValueOf(s)==String.ValueOf(Trigger.oldMap.get(obj.Id).RecordAccountTypeDevCombination__c))
	                        {
	                         Integer flipflopOld  = 0;
	                         flipflopOld = Integer.ValueOf(sObjectToBindOLD.get(String.ValueOf(Trigger.oldMap.get(obj.Id).RecordAccountTypeDevCombination__c)));
	                         if(flipflopOld >0)
	                         flipflopOld -=1;
	                         sObjectToBindOLD.put(String.ValueOf(Trigger.oldMap.get(obj.Id).RecordAccountTypeDevCombination__c),flipflopOld);
	                         
	                       }
	                   
	                  }
	
	
	            }
	            else
	            {  
	            }
	             
	            
	     }  
	     // -------------------  End of Update call
	    else if(Trigger.isDelete)               
	    {
	                    sObjectToBind = updateCount;    
	                       for (Schema.SObjectField s:fields.Values())
	                       {
	                            Integer flipflop = 0; 
	                            if(String.ValueOf(s)==String.ValueOf(obj.RecordAccountTypeDevCombination__c))
	                            {
	                             flipflop = Integer.ValueOf(sObjectToBind.get(String.ValueOf(obj.RecordAccountTypeDevCombination__c)));
	                             if(flipflop>0)
	                             flipflop -=1;
	                             sObjectToBind.put(String.ValueOf(obj.RecordAccountTypeDevCombination__c),flipflop);
	                          
	                           }
	                         }
	                   // -------------------  End of Delete call   ---------------------------- 
	        }
	        else if(Trigger.isInsert || Trigger.isUnDelete)
	        {
	            if(obj.Account_Type__c=='MCM'){
	             if(strRecordTypeName=='No Consumer Inquiries'){
	                if(obj.Type__c=='Consumer Dissatisfaction'){
	                    strInquiryType='CD';
	                    updateCount.NCI_CD_MCM__c = updateCount.NCI_CD_MCM__c == null ? 1 : updateCount.NCI_CD_MCM__c + 1; // updating NCI_CD_MCM__c
	                    //updateCount.NCI_CD_MCM__c += 1; 
	                 }
	                 if(obj.Type__c=='Regulatory Complaint'){
	                    strInquiryType='RC';
	                    updateCount.NCI_RC_MCM__c = updateCount.NCI_RC_MCM__c == null ? 1 : updateCount.NCI_RC_MCM__c + 1; // updating NCI_RC_MCM__c
	                    //updateCount.NCI_RC_MCM__c += 1;   
	                 }
	              }else if(strRecordTypeName=='Consumer Dissatisfaction'){              
	                  strInquiryType='CD';
	                  updateCount.CD_MCM__c = updateCount.CD_MCM__c == null ? 1 : updateCount.CD_MCM__c + 1; // updating CD_MCM__c    
	                  //updateCount.CD_MCM__c += 1;   
	              }else if(strRecordTypeName=='Regulatory Complaint'){
	                  strInquiryType='RC';
	                  updateCount.RC_MCM__c = updateCount.RC_MCM__c == null ? 1 : updateCount.RC_MCM__c + 1; // updating RC_MCM__c 
	                  //updateCount.RC_MCM__c += 1; 
	              }
	              // Otherwise AA
	            }  
	            else if(obj.Account_Type__c == 'AA'){
	                  if(strRecordTypeName=='No Consumer Inquiries'){
	                if(obj.Type__c=='Consumer Dissatisfaction'){
	                    strInquiryType='CD';
	                    updateCount.NCI_CD_AARS__c = updateCount.NCI_CD_AARS__c == null ? 1 : updateCount.NCI_CD_AARS__c + 1; // updating NCI_CD_AARS__c
	                    //updateCount.NCI_CD_AARS__c += 1;  
	                 }
	                 if(obj.Type__c=='Regulatory Complaint'){
	                    strInquiryType='RC';
	                    updateCount.NCI_RC_AARS__c = updateCount.NCI_RC_AARS__c == null ? 1 : updateCount.NCI_RC_AARS__c + 1; // updating NCI_RC_AARS__c 
	                    //updateCount.NCI_RC_AARS__c += 1; 
	                 }
	              }else if(strRecordTypeName=='Consumer Dissatisfaction'){
	                  strInquiryType='CD';
	                  updateCount.CD_AARS__c = updateCount.CD_AARS__c == null ? 1 : updateCount.CD_AARS__c + 1; // updating CD_AARS__c 
	                  //updateCount.CD_AARS__c += 1; 
	              }else if(strRecordTypeName=='Regulatory Complaint'){
	                  strInquiryType='RC';
	                  updateCount.RC_AARS__c = updateCount.RC_AARS__c == null ? 1 : updateCount.RC_AARS__c + 1; // updating RC_AARS__c 
	                  //updateCount.RC_AARS__c += 1; 
	              }
	            }else if(obj.Account_Type__c == 'ACF'){
	            	
					if(strRecordTypeName=='No Consumer Inquiries'){
						
						if(obj.Type__c=='Consumer Dissatisfaction'){
							strInquiryType='CD';
							updateCount.NCI_CD_ACF__c = updateCount.NCI_CD_ACF__c == null ? 1 : updateCount.NCI_CD_ACF__c + 1; // updating NCI_CD_ACF__c
							//updateCount.NCI_CD_ACF__c += 1;  
						}
						
						if(obj.Type__c == 'Regulatory Complaint'){
							strInquiryType='RC';
							updateCount.NCI_RC_ACF__c = updateCount.NCI_RC_ACF__c == null ? 1 : updateCount.NCI_RC_ACF__c + 1; // updating NCI_RC_ACF__c 
							//updateCount.NCI_RC_ACF__c += 1; 
						}
						
					}else if(strRecordTypeName == 'Consumer Dissatisfaction'){
						
						strInquiryType='CD';
						updateCount.CD_ACF__c = updateCount.CD_ACF__c == null ? 1 : updateCount.CD_ACF__c + 1; // updating CD_ACF__c  
						//updateCount.CD_ACF__c += 1; 
						
		            }else if(strRecordTypeName == 'Regulatory Complaint'){
		            	
						strInquiryType='RC';
						updateCount.RC_ACF__c = updateCount.RC_ACF__c == null ? 1 : updateCount.RC_ACF__c + 1; // updating RC_ACF__c 
						//updateCount.RC_ACF__c += 1; 
		            
		            }	
										            
	            }
	        }
	        // End of update......
	        
	     mapConsumerHistory.put(temp,updateCount);  
	    }
	    else //.... means there is no record ......create record for that month
	    {
	      Set<String> ReportingMonthAndYear = new Set<String>{'2012-01','2012-02','2012-03','2012-04','2012-05','2012-06','2012-07','2012-08','2012-09','2012-10','2012-11','2012-12','2013-12','2013-11','2013-10','2013-09','2013-08','2013-07','2013-06','2013-05','2013-04','2013-03','2013-02','2013-01','2014-01','2014-02','2014-03'};
	     // Added code to handle special case if in case new year ,month doesn't exit in mapConsumerHistory Map
	      if(Trigger.IsUpdate)
	      {
	        if (obj.ReportingYearMonthCombination__c !=Trigger.oldMap.get(obj.Id).ReportingYearMonthCombination__c)
	        {
	         String OldTemp = Trigger.oldMap.get(obj.Id).ReportingYearMonthCombination__c +'-'+ String.valueOf(obj.Firm_Name__c).substring(0,15);
	         if((mapConsumerHistory.get(temp)== null) && (mapConsumerHistory.get(OldTemp)!= null) )
	         {
	                oldUpdateCount = mapConsumerHistory.get(OldTemp);
	                 sObjectToBind =  oldUpdateCount;          // Old count record record
	                 String stringChg = '';
	                 if(obj.RecordAccountTypeDevCombination__c==Trigger.oldMap.get(obj.Id).RecordAccountTypeDevCombination__c)
	                 {
	                   stringChg =obj.RecordAccountTypeDevCombination__c;
	                 }
	                 else
	                 {
	                   stringChg = Trigger.oldMap.get(obj.Id).RecordAccountTypeDevCombination__c;
	                 }  
	                 for (Schema.SObjectField s:fields.Values())
	                       {
	                        Integer flipflop = 0; 
	                            if(String.ValueOf(s)==String.ValueOf(stringChg))
	                            {
	                             flipflop = Integer.ValueOf(sObjectToBind.get(String.ValueOf(stringChg)));
	                             if(flipflop>0)
	                             flipflop -=1;
	                             sObjectToBind.put(String.ValueOf(stringChg),flipflop);
	                             
	                           }
	                   
	                        }
	         }
	      } 
	    } // end of Update Variable     
	    
	
	    ModifyMonth= '';
	    ModifyMonth=obj.Reporting_Month__c;
	    if(ModifyMonth!=null && ModifyMonth.length()==1){       
	    ModifyMonth=('0'+ModifyMonth);  
	    }
	       updateCount.Reporting_Month__c = ModifyMonth; // updating Reporting_Month__c
	       updateCount.Reporting_Year__c = obj.Reporting_Year__c; // updating Reporting_Year__c
	       updateCount.Firm_Name__c =obj.Firm_Name__c; // updating Firm_Name__c
	       updateCount.Name = 'Month:'+ModifyMonth+' Year:'+obj.Reporting_Year__c; // updating Name 
	       
	       
	       system.debug('mapAccDept.get(obj.Firm_Name__c)-------->'+mapAccDept.get(obj.Firm_Name__c));
	       if(mapAccDept.get(obj.Firm_Name__c)!=null){
		       updateCount.Firm_Type__c = mapAccDept.get(obj.Firm_Name__c); // updating Firm_Type__c 
	       }
	       
	       // updating counts values 
	       
	       updateCount.CD_AARS__c=0;
	       updateCount.CD_MCM__c=0;
	       updateCount.CD_ACF__c=0;
	       updateCount.RC_AARS__c=0;
	       updateCount.RC_MCM__c=0;
	       updateCount.RC_ACF__c=0;
	       updateCount.NCI_CD_AARS__c=0;
	       updateCount.NCI_CD_ACF__c=0;
	       updateCount.NCI_CD_MCM__c=0;
	       updateCount.NCI_RC_AARS__c=0;
	       updateCount.NCI_RC_MCM__c=0;
	       updateCount.NCI_RC_ACF__c=0;
	       
	
			system.debug('obj----------->'+obj);
	       
	       //start to find out consumer type  
	        String strInquiryType='';
	        String strRecordTypeName=mapRecordType.get(obj.RecordTypeId);
	        if(obj.Account_Type__c=='MCM'){
	        	
	         if(strRecordTypeName=='No Consumer Inquiries'){
	            if(obj.Type__c=='Consumer Dissatisfaction'){
	                strInquiryType='CD';
	                updateCount.NCI_CD_MCM__c=1; // updating NCI_CD_MCM__c 
	             }
	             if(obj.Type__c=='Regulatory Complaint'){
	                strInquiryType='RC';
	                updateCount.NCI_RC_MCM__c=1; // updating NCI_RC_MCM__c 
	             }
	          }else if(strRecordTypeName=='Consumer Dissatisfaction'){
	              strInquiryType='CD';
	              updateCount.CD_MCM__c=1; // updating CD_MCM__c 
	          }else if(strRecordTypeName=='Regulatory Complaint'){
	              strInquiryType='RC';
	              updateCount.RC_MCM__c=1; //updating RC_MCM__c 
	          }
	          // Otherwise AA
	        }else if(obj.Account_Type__c=='AA'){
	              if(strRecordTypeName=='No Consumer Inquiries'){
	            if(obj.Type__c=='Consumer Dissatisfaction'){
	                strInquiryType='CD';
	                updateCount.NCI_CD_AARS__c=1; // updating NCI_CD_AARS__c 
	             }
	             if(obj.Type__c=='Regulatory Complaint'){
	                strInquiryType='RC';
	                updateCount.NCI_RC_AARS__c=1; // updating NCI_RC_AARS__c 
	             }
	          }else if(strRecordTypeName=='Consumer Dissatisfaction'){
	              strInquiryType='CD';
	              updateCount.CD_AARS__c=1; // updating CD_AARS__c 
	          }else if(strRecordTypeName=='Regulatory Complaint'){
	              strInquiryType='RC';
	              updateCount.RC_AARS__c=1; // updating RC_AARS__c
	          }
	        }else if(obj.Account_Type__c == 'ACF'){
	        	
				if(strRecordTypeName == 'No Consumer Inquiries'){
					
					if(obj.Type__c == 'Consumer Dissatisfaction'){
						
						strInquiryType = 'CD';
						updateCount.NCI_CD_ACF__c = 1; // updating NCI_CD_ACF__c
						
					}
					
					if(obj.Type__c == 'Regulatory Complaint'){
						
						strInquiryType = 'RC';
						updateCount.NCI_RC_ACF__c = 1; // updating NCI_RC_ACF__c
						
					}
					
				}else if(strRecordTypeName == 'Consumer Dissatisfaction'){
					
					strInquiryType = 'CD';
					updateCount.CD_ACF__c = 1; // updating CD_ACF__c 
					
				}else if(strRecordTypeName == 'Regulatory Complaint'){
					
					strInquiryType = 'RC';
					updateCount.RC_ACF__c = 1; // updating RC_ACF_c
					
				}
				
				
	        	
	        }
	       if(obj.RecordTypeId=='012U0000000QMUI' || obj.RecordTypeId=='012U0000000QMUN' || obj.RecordTypeId=='012U0000000QMUS'){
	          system.debug('ReportingMonthAndYear------->'+ReportingMonthAndYear);
	          if(!ReportingMonthAndYear.contains(obj.ReportingYearMonthCombination__c)){
	     			mapConsumerHistory.put(temp,updateCount);  
	     		}
	     		system.debug('mapConsumerHistory--------->'+mapConsumerHistory);
	       }
	    }
	     
	} // End of manipulating each consumer inquiry
	    if(!mapConsumerHistory.Values().isEmpty()){
	    	
	      list<CIS_Counts__c> updatecountLst= new list<CIS_Counts__c>();
	      updatecountLst.addALL(mapConsumerHistory.Values());
	      system.debug('updatecountLst------------>'+updatecountLst);
	      if(!updatecountLst.isEmpty()){
	         upsert updatecountLst;      
	        } 
	        
	    }  // */
}