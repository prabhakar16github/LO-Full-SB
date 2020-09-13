public class AttachmentTriggerHandler{
	public static final String ACCOUNT_NUMBERS_ADDED = 'Account Numbers Added';
	
	public void beforeInsert(List<Attachment> newAttachmentList){
		lrmm_CopyAttachmentstoCAD(newAttachmentList);
	}

	public void afterInsert(List<Attachment> newAttachmentList){
		/* 
		* @ Calling the Method for update the Attachment checkbox on the parent object of Attachment
		* @ Added on 7-May-2020 by Prabhakar Joshi
		*/
		this.updateAttCheckboxOnParent(newAttachmentList);
		this.processCM_PAM(newAttachmentList);
	}

	public void beforeDelete(List<Attachment> triggerOld){
		/* fetching current user profile to check the permission */
		List<Profile> currentUserProfile = [SELECT Id, Name
		                                    FROM Profile
		                                    WHERE Id = :UserInfo.getProfileId()
		                                    LIMIT 1];
		/* if current user profile list is empty silently exit the process */
		if (currentUserProfile.isEmpty()){
			return;
		}
		for (Attachment att : triggerOld){
			/* If Parent Sobject are Call_Monitoring__c or Consumer_Inquiries__c then only admin should be able to delete the attachment
			  Check if the sObject are not Call_Monitoring__c or Consumer_Inquiries__c then skip the iteration */
			if (att.ParentId.getSobjectType() != Call_Monitoring__c.SobjectType && att.ParentId.getSobjectType() != Consumer_Inquiries__c.SobjectType){
				continue;
			}
			/* check if the profile is not Admin then throw the error */
			if (!currentUserProfile[0].Name.contains('Admin')){
				att.addError('Please submit a “Delete Request” via the User Support Object to delete an attachment and/or record.');
			}
		}
	}

	public void afterDelete(List<Attachment> triggerOld){
		this.updateAttCheckboxOnParent(triggerOld);
	}

	public void afterUndelete(List<Attachment> newAttachmentList){
		this.updateAttCheckboxOnParent(newAttachmentList);
	}

	/*
	 * @ Method for update the Attachment checkbox on the parent object (LRMM Objects, Call_Monitoring__c & Consumer inquiry) of Attachment.
	 * @ Added on 6-May-2020 by Prabhakar Joshi
	 */
	private void updateAttCheckboxOnParent(List<Attachment> attRecords){
        /* Map to store the Parent Object and their checkbox field to update */
		Map<String, String> ParentObjMap = new Map<String, String>{'Trial_Witness_Request__c' => 'Attachments__c', 'Counterclaim__c' => 'CC_Attachments__c', 'Escalated_Contested_Matters__c' => 'ECM_Attachments__c', 'Discovery__c' => 'DY_Attachments__c', 'Business_Record_Affidavit__c' => 'BRA_Attachments__c', 'Purchase_and_Sales_Agreement__c' => 'PSA_Attachment__c', 'Call_Monitoring__c' => 'Attachments__c', 'Consumer_Inquiries__c' => 'Attachments__c'};
		/* Map to store the LRMM Object and their status field to check the status value */
        Map<String, String> statusFieldMap = new Map<String, String>{'Counterclaim__c' => 'CC_Counterclaim_Status__c', 'Business_Record_Affidavit__c' => 'BRA_BRA_Status__c', 'Discovery__c' => 'DY_Discovery_Status__c', 'Escalated_Contested_Matters__c' => 'ECM_Status__c', 'Purchase_and_Sales_Agreement__c' => 'PSA_PSA_Status__c', 'Trial_Witness_Request__c' => 'Status__c'};
		/* Set the hold the ParentId of attachment records coming from trigger */
        Set<Id> parentIdSet = new Set<Id>();
        /* Map to store the LRMM records and their 'Attachments' checkbox value */
        Map<Id, Boolean> parentIdToCheckboxMap = new Map<Id, Boolean>();
		/* Map to store the data of all attachment parent records after fetch the data from query */
        Map<Id, SObject> parentIdToSobjectMap = new Map<Id, SObject>();
        /* value Set to check the status value of LRMM records */
        Set<String> statusValueSet = new Set<String>{'Closed', 'Completed'};
        /* List to store the records for update*/    
		List<Sobject> objListToUpdate = new List<Sobject>();
		/* Iterate the trigger data */
        for (Attachment att : attRecords){
            String objType = att.ParentId.getSobjectType().getDescribe().getName();
            if(ParentObjMap.containsKey(objType)){
                parentIdSet.add(att.ParentId);
                parentIdToCheckboxMap.put(att.ParentId, false);
            }
        }
        /* To check the set of ParentId is Empty or not */
		if (parentIdSet.isEmpty() || parentIdToCheckboxMap.keySet().isEmpty()){
			return;
		}
		
        /* To run, if the trigger is after delete context */
		if (trigger.isDelete){
			for (String objName : statusFieldMap.keySet()){
				String query = 'SELECT Id,' + ParentObjMap.get(objName) + ',' + statusFieldMap.get(objName) + ' FROM ' + objName + ' WHERE Id IN :parentIdSet';
				parentIdToSobjectMap.putAll(Database.query(query));
			}
		}
        /* for query aggregate data with ParentId and checkbox value */
		for (AggregateResult agg : [SELECT COUNT(Id)totalAtt, ParentId
		                            FROM Attachment
		                            WHERE ParentId IN :parentIdSet
		                            GROUP BY ParentId]){
			parentIdToCheckboxMap.put((Id)agg.get('ParentId'), true);
		}
        /* Iterate the Aggregate data and get the updated list of Parent object Records */
		for (Id parentId : parentIdToCheckboxMap.keySet()){
			String objName = parentId.getSobjectType().getDescribe().getName();
			String fieldName = statusFieldMap.get(objName);
			boolean checkBoxVal = parentIdToCheckboxMap.get(parentId);
			sobject obj = Schema.getGlobalDescribe().get(objName).newSObject();
			obj.put('Id', parentId);
			if (parentIdToSobjectMap.containsKey(parentId) && statusValueSet.contains((String)parentIdToSobjectMap.get(parentId).get(fieldName))){
				checkBoxVal = true;
			}
			obj.put(ParentObjMap.get(objName), checkBoxVal);
			objListToUpdate.add(obj);
		}
		if (!objListToUpdate.isEmpty()){
			update objListToUpdate;
		}
	}

	private void processCM_PAM(List<Attachment> newAttachmentList){
		Set<Id> parentPAMIds = new Set<Id>();
		Set<Id> parentCMIds = new Set<Id>();
		Set<Id> attIdSet = new Set<Id>();
		for (Attachment attachment : newAttachmentList){
			Schema.SObjectType objType = attachment.ParentId.getSobjectType();
			if (objType.getDescribe().getName() == 'Process_Adherence_Monitoring__c'){
				parentPAMIds.add(attachment.ParentId);
			}
			if (objType.getDescribe().getName() == 'Call_Monitoring__c'){
				parentCMIds.add(attachment.ParentId);
				attIdSet.add(attachment.Id);
			}
		}
		if (parentPAMIds.size() > 0)
			processPam(parentPAMIds);
		if (parentCMIds.size() > 0 && attIdSet.size() > 0){
			//
			populateAttCreatedByEmailonCM(attIdSet);
			processCM(parentCMIds);
		}

	}

	/************** To Popute the Email of Attachment Created by User on CM (Added on 19-7-2019) *****************/
	private static void populateAttCreatedByEmailonCM(Set<Id> attIdSet){
		Map<Id, String> attToEmailMap = new Map<Id, String>();
		for (Attachment att : [SELECT Id, ParentId, CreatedBy.Email
		                       FROM Attachment
		                       WHERE Id IN :attIdSet]){
			attToEmailMap.put(att.ParentId, att.CreatedBy.Email);
		}
		if (attToEmailMap.keySet().size() > 0){
			List<Call_Monitoring__c> cmListToUpdate = new List<Call_Monitoring__c>();
			for (Call_Monitoring__c cm : [SELECT Id, Name, Attachment_Created_By_Email__c
			                              FROM Call_Monitoring__c
			                              WHERE Id IN :attToEmailMap.keySet()]){
				cm.Attachment_Created_By_Email__c = attToEmailMap.get(cm.Id);
				cmListToUpdate.add(cm);
			}
			if (cmListToUpdate.size() > 0)
				update cmListToUpdate;
		}
	}

	/***************************************************************************************************************/
	private static void processCM(Set<Id> parentCMIds){
		Map<Id, Call_Monitoring__c> contMap = new Map<Id, Call_Monitoring__c>();
		Map<Id, Call_Monitoring__c> orgIdToCMMap = new Map<Id, Call_Monitoring__c>();
		Id QA_RecordType = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring QA').getRecordTypeId();
		List<User> UserList = new List<User>();
		for (Call_Monitoring__c cm : [SELECT Id, Name, Organization_Name_CM__c, Organization_Name_CM__r.Firm_ID__c, Organization_Name_CM__r.Agency_ID__c, Reporting_Month_CM__c, Reporting_Year_CM__c, Notification_Sent__c
		                              FROM Call_Monitoring__c
		                              WHERE Id IN :parentCMIds AND Notification_Sent__c = false AND RecordTypeId = :QA_RecordType]){
			orgIdToCMMap.put(cm.Organization_Name_CM__c, cm);
		}
		if (orgIdToCMMap.keySet().size() > 0){
			for (Contact con : [SELECT Id, AccountId, Community_User__c
			                    FROM Contact
			                    WHERE AccountId IN :orgIdToCMMap.keySet() AND Community_User__c = true AND Inactive_Contact__c = false]){
				contMap.put(con.Id, orgIdToCMMap.get(con.AccountId));
			}
			if (contMap.keySet().size() > 0){
				for (User usr : [SELECT AccountId, contactId, Email, UserName, FirstName, Id, IsActive, IsPortalEnabled, LastName, Name
				                 FROM User
				                 where contactId IN :contMap.keySet() and IsActive = true]){
					UserList.add(usr);
				}
			}
		}
		if (UserList.size() > 0 && contMap.keySet().size() > 0){
			sendNotificationOnAttachmentAdded(UserList, contMap);
		}
	}

	private static void sendNotificationOnAttachmentAdded(List<User> UserList, Map<Id, Call_Monitoring__c> contMap){
		List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
		Map<Id, Call_Monitoring__c> updateCM_NotificationCheckBox = new Map<Id, Call_Monitoring__c>();
		List<Call_Monitoring__c> cmListToUpdate = new List<Call_Monitoring__c>();
		for (User usr : UserList){
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			String firmId = contMap.get(usr.ContactId).Organization_Name_CM__r.Firm_ID__c;
			String agencyId = contMap.get(usr.ContactId).Organization_Name_CM__r.Agency_ID__c;
			if (firmId != NULL){
				mail.setSubject(firmId + ' Action Required : Call Monitoring Materials Submission');
			} else if (agencyId != NULL){
				mail.setSubject(agencyId + ' Action Required : Call Monitoring Materials Submission');
			}
			//mail.setSubject(contMap.get(usr.ContactId).Organization_Name_CM__r.Firm_ID__c+' Action Required : Call Monitoring Materials Submission');
			mail.setToAddresses(new List<String>{usr.Email});
			String[] replyToAddresses = new String[]{'FirmManagement@mcmcg.com'};
			mail.setReplyTo(replyToAddresses[0]);
			OrgWideEmailAddress[] owea = [select Id
			                              from OrgWideEmailAddress
			                              where Address = 'FirmManagement@mcmcg.com'];
			System.debug('owea :: ' + owea);
			if (owea.size() > 0){
				mail.setOrgWideEmailAddressId(owea.get(0).Id);
			}
			String mailBody = 'Dear ' + usr.FirstName + ':' + '<br/><br/>';
			mailBody += 'A list of the collection calls selected for ' + contMap.get(usr.ContactId).Reporting_Month_CM__c + ' - ' + contMap.get(usr.ContactId).Reporting_Year_CM__c + ' QA Review are now accessible in the Record ' + contMap.get(usr.ContactId).Name + ' attachment.' + '<br/><br/>';
			mailBody += '<a href =' + label.LC_Partner_URL + contMap.get(usr.ContactId).Id + '>' + contMap.get(usr.ContactId).Name + ' </a>' + '<br/><br/>';
			mailBody += 'Call Materials are due within <b> 3 </b> calendar days of the creation of the QA record selection.<br/><br/>' + 'Please log into the LC Partner Access Site and enter a <b>Call Monitoring Materials</b> Record for each <u>individual</u> call and attach <u>both</u> the call recording and associated account notes.<br/><br/>' + 'If you have any questions regarding this process or the requirement, first reference the LC Partner Access Site Procedures Manual.  Email <a href="mailto:FirmManagement@mcmcg.com ">FirmManagement@mcmcg.com</a> with any follow-up questions.<br/><br/>' + 'Firm/Agency Management Teams' + '<br/><br/>';
			mail.setHtmlBody(mailBody);
			emails.add(mail);
			Call_Monitoring__c cmObj = new Call_Monitoring__c();
			cmObj.Id = contMap.get(usr.ContactId).Id;
			cmObj.Notification_Sent__c = true;
			cmListToUpdate.add(cmObj);
			updateCM_NotificationCheckBox.putall(cmListToUpdate);
		}
		Messaging.sendEmail(emails);
		if (updateCM_NotificationCheckBox.size() > 0)
			update updateCM_NotificationCheckBox.values();
	}

	private static void processPam(Set<Id> parentPAMIds){
		Id psnmRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO PSNM').getRecordTypeId();
		Id irRecordType = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO IR').getRecordTypeId();
		Id rsnmRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO RSNM').getRecordTypeId();
		Id acf_IrRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('ACF IR').getRecordTypeId();
		//For DM IR - Added on Jan-17-2020
		Id dm_IrRecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM IR').getRecordTypeId();
		List<Process_Adherence_Monitoring__c> pams = getPams(parentPAMIds);
		List<Process_Adherence_Monitoring__c> psnmRecords = getPams(psnmRecordTypeId, pams);
		List<Process_Adherence_Monitoring__c> irRecords = getPams(irRecordType, pams);
		List<Process_Adherence_Monitoring__c> rsnmRecords = getPams(rsnmRecordTypeId, pams);
		List<Process_Adherence_Monitoring__c> acf_irRecords = getPams(acf_IrRecordTypeId, pams);
		List<Process_Adherence_Monitoring__c> dm_irRecords = getPams(dm_IrRecordTypeId, pams);
		if (!psnmRecords.isEmpty()){
			// for suit theory process
			processPSNMOnAttachmentAdded(psnmRecords);
		}
		if (!irRecords.isEmpty()){
			// for Inventory process
			processIrOnAttachmentAdded(irRecords);
		}
		if (!rsnmRecords.isEmpty()){
			processRSNMOnAttachmentAdded(rsnmRecords);
		}
		if (!acf_irRecords.isEmpty()){
			processIR_ACFOnAttachmentAdded(acf_irRecords);
		}
		if (!dm_irRecords.isEmpty()){
			processIR_DMOnAttachmentAdded(dm_irRecords);
		}
	}

	private static List<Process_Adherence_Monitoring__c> getPams(Set<Id> parentPAMIds){
		List<Process_Adherence_Monitoring__c> pams = [SELECT Id, Name, SCMD_Date_Account_Numbers_Received__c, Status__c, Attachment__c, RecordTypeId
		                                              FROM Process_Adherence_Monitoring__c
		                                              WHERE Id IN :parentPAMIds];
		return pams;
	}

	private static List<Process_Adherence_Monitoring__c> getPams(Id recordTypeId, List<Process_Adherence_Monitoring__c> pams){
		List<Process_Adherence_Monitoring__c> filteredPams = new List<Process_Adherence_Monitoring__c>();
		for (Process_Adherence_Monitoring__c pam : pams){
			if (recordTypeId == pam.recordTypeId){
				filteredPams.add(pam);
			}
		}
		return filteredPams;
	}

	private static void processPSNMOnAttachmentAdded(List<Process_Adherence_Monitoring__c> psnmRecords){
		for (Process_Adherence_Monitoring__c pam : psnmRecords){
			pam.Attachment__c = true;
		}
		try{
			update psnmRecords;
		} catch (DmlException dmlException){
			throw new LOException(dmlException.getDmlMessage(0));
		}
	}

	private static void processIrOnAttachmentAdded(List<Process_Adherence_Monitoring__c> irRecords){
		for (Process_Adherence_Monitoring__c pam : irRecords){
			if (pam.SCMD_Date_Account_Numbers_Received__c == null){
				pam.SCMD_Date_Account_Numbers_Received__c = system.today();
				pam.Status__c = ACCOUNT_NUMBERS_ADDED;
			}
		}
		try{
			update irRecords;
		} catch (DmlException dmlException){
			throw new LOException(dmlException.getDmlMessage(0));
		}
	}

	//added on 6-aug-2019 for ACF_IR record type
	//Same as LO IR , on inserting an attachment, update SCMD_Date_Account_Numbers_Received__c and Status__c
	private static void processIR_ACFOnAttachmentAdded(List<Process_Adherence_Monitoring__c> acf_irRecords){
		for (Process_Adherence_Monitoring__c pam : acf_irRecords){
			if (pam.SCMD_Date_Account_Numbers_Received__c == null){
				pam.SCMD_Date_Account_Numbers_Received__c = system.today();
				pam.Status__c = ACCOUNT_NUMBERS_ADDED;
			}
		}
		try{
			update acf_irRecords;
		} catch (DmlException dmlException){
			throw new LOException(dmlException.getDmlMessage(0));
		}
	}

	//added on Jan-17-2020 for DM_IR record type
	//Same as DM IR , on inserting an attachment, update SCMD_Date_Account_Numbers_Received__c and Status__c
	private static void processIR_DMOnAttachmentAdded(List<Process_Adherence_Monitoring__c> dm_irRecords){
		for (Process_Adherence_Monitoring__c pam : dm_irRecords){
			if (pam.SCMD_Date_Account_Numbers_Received__c == null){
				pam.SCMD_Date_Account_Numbers_Received__c = system.today();
				pam.Status__c = ACCOUNT_NUMBERS_ADDED;
			}
		}
		try{
			update dm_irRecords;
		} catch (DmlException dmlException){
			throw new LOException(dmlException.getDmlMessage(0));
		}
	}

	private static void processRSNMOnAttachmentAdded(List<Process_Adherence_Monitoring__c> rsnmRecords){
		for (Process_Adherence_Monitoring__c pam : rsnmRecords){
			pam.Attachment__c = true;
		}
		try{
			update rsnmRecords;
		} catch (DmlException dmlException){
			throw new LOException(dmlException.getDmlMessage(0));
		}
	}

    /* 
     * @ Modified Date : 11-May-2020 
     * @ Modified By : Prabhakar Joshi
     * @ Description : Method to copy the Attachment from LRMM Object to related CAD Object
	*/
    private static void lrmm_CopyAttachmentstoCAD(List<Attachment> newAttachmentList){
        /* Set to store the Parent Id of attachment */
        Set<Id> parentIdSet = new Set<Id>();
        /* List to store the New Attachment record */
        List<Attachment> attListToCopy = new List<Attachment>();
        /* Map to store the all LRMM Objects and lookup field for CAD object for copy the Attachments */
        Map<String,String> LRMM_Obj_Map = new Map<String,String>{'Appeal__c'=>'AP_Consumer_Account_Record__c','Business_Record_Affidavit__c'=>'BRA_Consumer_Account_Details_Record__c','Counterclaim__c'=>'CC_Consumer_Account_Detail_Name__c','Discovery__c'=>'DY_Consumer_Account_Details__c','Purchase_and_Sales_Agreement__c'=>'PSA_Consumer_Account_Detail_Name__c','Trial_Witness_Request__c'=>'TW_Consumer_Account_Records__c','Settlement_Approval__c'=>'SA_Consumer_Account_Details__c'};
        /* Map of Sobject to store the LRMM Records */    
        Map<Id,Sobject> sobjMap = new Map<Id,Sobject>();
        /* Iterate the attachment date coming from trigger*/
        for(Attachment att : newAttachmentList){
            String objType = att.ParentId.getSobjectType().getDescribe().getName();
            if(LRMM_Obj_Map.containsKey(objType)){
                parentIdSet.add(att.ParentId);
            }
        }
        
        if(parentIdSet.isEmpty()){
            return;
        }
        /* Iterate all the LRMM objects for query */
        for(String obj : LRMM_Obj_Map.keySet()){
            String query = 'SELECT Id,'+LRMM_Obj_Map.get(obj)+' FROM '+obj+' WHERE Id IN :parentIdSet AND '+LRMM_Obj_Map.get(obj)+' != NULL ';
            if(obj == 'Trial_Witness_Request__c'){
                query += 'AND RecordType.Name LIKE \'%Live Witness%\' ';
            }if(obj == 'Business_Record_Affidavit__c'){
                query += 'AND RecordType.Name = \'BRA: Record Type\' ';
            }
            sobjMap.putAll(Database.query(query));
        }
        
        if(sobjMap.keySet().isEmpty()){
            return;
        }
        /* Iterate the attachment data coming from trigger for copy and attach with the related CAD record. */
        for(Attachment att : newAttachmentList){
            if(!sobjMap.containsKey(att.ParentId) || sobjMap.get(att.ParentId) == NULL){
                continue;
            }
            String objName = att.ParentId.getSobjectType().getDescribe().getName();
            Attachment attNew = att.clone() ;
            attNew.ParentId = (Id)sobjMap.get(att.ParentId).get(LRMM_Obj_Map.get(objName));
            attListToCopy.add(attNew);
        }
        if(attListToCopy.isEmpty()){
            return;
        }
            
        insert attListToCopy;
    }
}