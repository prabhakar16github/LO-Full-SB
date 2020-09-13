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
			if (email.ParentId == NULL || email.ParentId.getSObjectType().getDescribe().getName() != 'Case'){
				return;
			}

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
			System.debug('>>>>>>>>>>>' + emailSet);

			emailMap.put(email.ParentId, emailSet);

		}

		if (emailMap.keySet().isEmpty()){
			return;
		}

		List<Case> caseListToUpdate = new List<Case>();
		for (Case cs : [SELECT Id, ContactEmail, Additional_Email__c
		                FROM Case
		                WHERE Id IN :emailMap.keySet()]){
			if (!emailMap.containsKey(cs.Id) || emailMap.get(cs.Id).isEmpty()){
				continue;
			}
			if (cs.ContactEmail != NULL && emailMap.get(cs.Id).contains(cs.ContactEmail)){
				emailMap.get(cs.Id).remove(cs.ContactEmail);
			}
			cs.Additional_Email__c = String.join((Iterable<String>)emailMap.get(cs.Id), ';');
			caseListToUpdate.add(cs);

		}

		if (caseListToUpdate.isEmpty()){
			return;
		}

		update caseListToUpdate;
	}
}