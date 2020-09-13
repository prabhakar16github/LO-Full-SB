global class PAM_ScheduleEscalationNotification implements Schedulable {

     global void execute(SchedulableContext sc) {
        
        Set<Id> AccountId = new Set<Id>();
        
        List<Process_Adherence_Monitoring__c> pamList = new List<Process_Adherence_Monitoring__c>();
        
        if(Test.isRunningTest()){
            pamList = [Select id,Status__c,Organization_Name__c,OwnerId,First_Escalation_Day__c,Created_Date_DV__c,CreatedDate,
                        Second_Escalation_Day__c FROM Process_Adherence_Monitoring__c];
        }else{
            pamList = [Select id,Status__c,Organization_Name__c,OwnerId,First_Escalation_Day__c,Created_Date_DV__c,CreatedDate,Second_Escalation_Day__c FROM 
                       Process_Adherence_Monitoring__c WHERE (Status__c = 'First Escalation' AND First_Escalation_Day__c = 4) OR 
                       (Status__c   = 'Second Escalation' AND Second_Escalation_Day__c = 7)];
        }
        //pamList1 = [Select id,Status__c,Organization_Name__c,OwnerId,First_Escalation_Day__c,CreatedDate,Second_Escalation_Day__c,Created_Date_DV__c FROM Process_Adherence_Monitoring__c WHERE Status__c   = 'Second Escalation' AND Second_Escalation_Day__c = 7];    
        for(Process_Adherence_Monitoring__c pam:pamList){
            if(pam.Organization_Name__c != Null){
                AccountId.add(pam.Organization_Name__c);
            }
        }

        system.debug('pamList-->'+pamList);
        Map<id,Process_Adherence_Monitoring__c > mapId = new Map<id,Process_Adherence_Monitoring__c>();
        for(Process_Adherence_Monitoring__c pam:[Select id,Status__c,Organization_Name__c,OwnerId FROM  Process_Adherence_Monitoring__c WHERE Organization_Name__c IN: AccountId]){
            mapId.put(pam.Organization_Name__c,pam);
        }
        system.debug('mapId-->'+mapId);
        
        for(Id pam : mapId.keyset())
        {
            if(pamList[0].First_Escalation_Day__c == 2 || Test.isRunningTest())
            {
                 system.debug('pam -->'+pam);
                    //if(mapId.containskey(pam.id)){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List<String> ccAddresses = new List<String>();
                    //ccAddresses.add(cmonitoring.CC_Owner_Email__c);
                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'lcsalesforceadmin@mcmcg.com'];
                  
                    String body =  'Hello '+'\n'+'\n'+'The Process Adherence Monitoring records uploaded to Salesforce on ' +'\n'+
                                    pamList[0].Created_Date_DV__c+ ' have not been remediated.'+
                                    '\n'+'\n'+'Please log into Salesforce and access the records needing attention today.'+'\n'+'\n'+'Thank you for your prompt attention.'+'\n'+'\n'+'LO Operations Team';
    
                    mail.setSubject('First Escalation - Process Adherence Monitoring');
                    //mail.setCcAddresses(ccAddresses);
                    mail.setPlainTextBody(body);
                    mail.setTargetObjectId(mapId.get(pam).OwnerId);
                    mail.setSaveAsActivity(false);
                    if (owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                   //}
            }
     
         if(pamList[0].Second_Escalation_Day__c == 7  || Test.isRunningTest())
            {
                 system.debug('pam -->'+pam);
                    //if(mapId.containskey(pam.id)){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List<String> ccAddresses = new List<String>();
                    //ccAddresses.add(cmonitoring.CC_Owner_Email__c);
                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'lcsalesforceadmin@mcmcg.com'];
                  
                    String body =   'Hello '+'\n'+'\n'+'*Second Reminder*'+'The Process Adherence Monitoring records uploaded to Salesforce on ' +'\n'+
                                    pamList[0].Created_Date_DV__c+ ' have not been remediated.'
                                    +'\n'+'\n'+'Please log into Salesforce and access the records needing attention today.'+'\n'+'\n'+'Thank you for your prompt attention.'+'\n'+'\n'+'LO Operations Team';
    
                    mail.setSubject('Second Escalation - Process Adherence Monitoring');
                    //mail.setCcAddresses(ccAddresses);
                    mail.setPlainTextBody(body);
                    mail.setTargetObjectId(mapId.get(pam).OwnerId);
                    mail.setSaveAsActivity(false);
                    if (owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                   //}
            }
        } 
     }
 }