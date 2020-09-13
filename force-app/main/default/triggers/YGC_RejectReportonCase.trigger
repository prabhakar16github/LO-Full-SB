trigger YGC_RejectReportonCase on Case (after update) { // deprecated on 15 feb 2018
    /*
    if(checkRecursive.runOnce()){
    system.debug('recursive-->'+checkRecursive.runOnce());
    Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Case.getRecordTypeInfosByName();
    Id rtLeadID =  rtMap.get('Operations - YGC Reject Report').getRecordTypeId(); 
    List<Case> caseList = new List<Case>();
    List<Contact> conc = new List<Contact>();
    
    caseList = [Select id,RecordTypeId,ContactId,Firm_ID__c,CaseNumber,Reason FROM Case WHERE Recordtypeid =: rtLeadID and Id IN: trigger.new];
    conc = [Select id,Contact_Type_SME__c,Inactive_Contact__c,Email,Firm_ID__c,FirstName FROM Contact WHERE Contact_Type_SME__c INCLUDES ('YGC Reject Report') AND Inactive_Contact__c = False AND Email != null];
    system.debug('contactemails-->'+caseList);
    system.debug('conc-->'+conc);
    
    List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>();   
        for(Contact cont : conc)
        {
                  for(Case casel : caseList)
                   {
                     if(Trigger.oldMap.get(casel.id).Recordtypeid != rtLeadID)
                     {                   	
                     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                     mail.setTargetObjectId(cont.id);
                     string body =   '<html lang="ja"><body>'+
                                   
                                        'Hello '+cont.FirstName+
                                        '<br><br>'+'Please be advised that the firm may have YGC transactions that have rejected. These rejections'+
                                        '<br>'+'are high priority and will require action taken to correct.'+
                                        '<br><br><br>'+'All records rejected can be viewed by looking at the Returned Mail Inbox on YGC.'+
                                         '<br><br>'+'For court costs rejected the firm will need to resubmit using one of the MCM approved cost'+
                                        '<br>'+'codes (see MCM Firm Manual for approved cost codes).'+
                                         '<br><br>'+'If you have questions please send an email to to LO-Operational@mcmcg.com using the format'+
                                        '<br>'+'below:'+'<br><br>'+'Thank you,'+'<br><br>'+'YGC Reject Report Team';

                     mail.setSubject(cont.Firm_ID__c+' '+'YGC Reject Report'+' '+'Case #'+casel.CaseNumber);
	                     mail.sethtmlBody(body); 
	                     mail.setSaveAsActivity(false);  
	                     lstMails.add(mail);
                     }
                   }
        }
         if(lstMails.size() >0 || lstMails != Null){
           Messaging.sendEmail(lstMails);  
         }
        system.debug('lstMails-->'+lstMails);
      }
      */
    }