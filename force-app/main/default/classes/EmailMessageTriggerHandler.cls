/* 
    * @ Class Name      :       EmailMessageTriggerHandler
    * @ Description     :       Handler class for EmailMessageTrigger
    * @ Created By      :       Prabhakar Joshi
    * @ Created Date    :       11-Sept-2020
*/

public with sharing class EmailMessageTriggerHandler{
    /* @ Method for after Insert event. */
    /* @ Calling from EmailMessageTrigger. */
	public void afterInsert(List<EmailMessage> triggerNew){
        /* @ Calling method to populate the Additional Emails on related Case record. */
		this.populateAdditionalEmailOnCase(triggerNew);
	}

    /* @ method definition to populate the Additional Emails on related Case record. */
	private void populateAdditionalEmailOnCase(List<EmailMessage> triggerNew){
		Map<Id, Set<String>> emailMap = new Map<Id, Set<String>>();
		for (EmailMessage email : triggerNew){
			if (!email.Incoming || email.ParentId == NULL || email.ParentId.getSObjectType().getDescribe().getName() != 'Case' || email.ToAddress == NULL){
				return;
			}
			emailMap.put(email.ParentId, this.getEmailSet(email));
		}

		if (emailMap.keySet().isEmpty()){
			return;
		}

		List<Case> caseListToUpdate = new List<Case>();
		for (Case cs : [SELECT Id, ContactEmail, Additional_Email__c
		                FROM Case
						WHERE Id IN :emailMap.keySet() 
						AND Additional_Emails_Processed__c = false]){

            if (!emailMap.containsKey(cs.Id) || emailMap.get(cs.Id).isEmpty()){
				continue;
			}

			if (cs.ContactEmail != NULL && emailMap.get(cs.Id).contains(cs.ContactEmail)){
				emailMap.get(cs.Id).remove(cs.ContactEmail);
			}
			
			Set<String> finalEmailSet = this.getFinalEmailSet(emailMap.get(cs.Id));
			if(!finalEmailSet.isEmpty()){
				cs.Additional_Email__c = String.join((Iterable<String>)finalEmailSet, ';');
			}
			cs.Additional_Emails_Processed__c = true;
			caseListToUpdate.add(cs);
		}

		if (caseListToUpdate.isEmpty()){
			return;
		}
		update caseListToUpdate;
	}
	
	/* @ Private Method definition to get the email set for the case record. */
	/* @ Calling from 'populateAdditionalEmailOnCase' method. */
	private Set<String> getEmailSet(EmailMessage email){
		Set<String> emailSet = new Set<String>();

		if (email.ToAddress.contains(';')){
			emailSet.addAll(email.ToAddress.split(';'));
		} else{
			emailSet.add(email.ToAddress);
		}

		if (email.CcAddress != NULL){
			if (email.CcAddress.contains(';')){
				emailSet.addAll(email.CcAddress.split(';'));
			} else{
				emailSet.add(email.CcAddress);
			}
		}

		if (email.BccAddress != NULL){
			if (email.BccAddress.contains(';')){
				emailSet.addAll(email.BccAddress.split(';'));
			} else{
				emailSet.add(email.BccAddress);
			}
		}
		return emailSet;
	}
	
	/* @ Method to get the final email set by removing some system emails from the existing email set. */
	/* @ Calling from 'populateAdditionalEmailOnCase' method. */
    private Set<String> getFinalEmailSet(Set<String> emailSet){
        Set<String> systemEmailSet =  new Set<String>{
			'rsaccounting@assetacceptance.com','aarsmediarequests@assetacceptance.com','aarsrequest@assetacceptance.com',
			'settlements@assetacceptance.com','acf-looperational@mcmcg.com','attorneyoutsourcing@mcmcg.com','caoplace@mcmcg.com',
			'lo-inventoryrecon@mcmcg.com','lo-judgments@mcmcg.com','mcm-lo-operational@mcmcg.com','lo.operational@mcmcg.com',
			'lo-operational@mcmcg.com','affidavit-legalreview@mcmcg.com','lo-legalreview@mcmcg.com','lo-operationalpr@mcmcg.com',			
			'trial.witness@mcmcg.com'
		};

		for(String email : emailSet){
			if(systemEmailSet.contains(email)){
				emailSet.remove(email);
			}
		}
		return emailSet;
	}
}