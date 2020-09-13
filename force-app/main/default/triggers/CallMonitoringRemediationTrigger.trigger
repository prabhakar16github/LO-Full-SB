trigger CallMonitoringRemediationTrigger on Call_Monitoring__c (before update) {
    
    //Depricated on 6/6/2018
    
     // record type assighment moved to workflow on 6/6/2018
     
     
      /*    
      
      Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName();
      Id rtLeadID =  rtMap.get('Call Monitoring Materials Results').getRecordTypeId(); 
      Id rtLeadID1 =  rtMap.get('Call Monitoring Remediation').getRecordTypeId(); 
    
   /* if(Trigger.IsInsert)
    {
        for(Call_Monitoring__c clm : Trigger.new)
      {
        if(clm.RecordTypeId == rtLeadID)
            {
                clm.RecordTypeId = rtLeadID1;  
            }   
      }
    } */
    
    /*
    
    if(Trigger.IsUpdate)
    {
        for(Call_Monitoring__c cmonitoring : Trigger.new)
        {
             if(cmonitoring.RecordTypeId == rtLeadID && (cmonitoring.CF_Violation_Count__c > 0 || cmonitoring.SFViolation_Count__c > 0))
                 {
                    cmonitoring.RecordTypeId = rtLeadID1;  
                 }
            /*      
            if(cmonitoring.CF1_01__c == 'No')
                {
                    cmonitoring.CF1_01_Remidated__c = Null;
                    cmonitoring.CF1_01_Remidiation_Date__c = Null;
                    cmonitoring.CF1_01_Remediation_Plan__c = Null;
                    cmonitoring.CF1_01_Remediation_Steps_Completed__c = Null;
                }
            if(cmonitoring.CF1_02__c == 'No')
                {
                    cmonitoring.CF1_02_Remediated__c = Null;
                    cmonitoring.CF1_02_Remediation_Date__c = Null;
                    cmonitoring.CF1_02_Remediation_Plan__c = Null;
                    cmonitoring.CF1_02_Remediation_Steps_Completed__c = Null;
                }
            if(cmonitoring.CF1_03__c == 'No')
                {
                    cmonitoring.CF1_03_Remediated__c = Null;
                    cmonitoring.CF1_03_Remediation_Date__c = Null;
                    cmonitoring.CF1_03_Remediation_Plan__c = Null;
                    cmonitoring.CF1_03_Remediation_Steps_Completed__c = Null;
                }
            if(cmonitoring.CF1_04__c == 'No')
                {
                    cmonitoring.CF1_04_Remediated__c = Null;
                    cmonitoring.CF1_04_Remediation_Date__c = Null;
                    cmonitoring.CF1_04_Remediation_Plan__c   = Null;
                    cmonitoring.CF1_04_Remediation_Steps_Completed__c = Null;
                }
            if(cmonitoring.CF1_05__c == 'No')
                {
                    cmonitoring.CF1_05_Remediated__c = Null;
                    cmonitoring.CF1_05_Remediation_Date__c = Null;
                    cmonitoring.CF1_05_Remediation_Plan__c = Null;
                    cmonitoring.CF1_05_Remediation_Steps_Completed__c = Null;
                }
            if(cmonitoring.CF1_05__c == 'No')
                {
                    cmonitoring.CF1_05_Remediated__c = Null;
                    cmonitoring.CF1_05_Remediation_Date__c = Null;
                    cmonitoring.CF1_05_Remediation_Plan__c = Null;
                    cmonitoring.CF1_05_Remediation_Steps_Completed__c = Null;
                }
            if(cmonitoring.SF2_01__c == 'Yes')
                {
                    cmonitoring.SF2_01_Remediated__c = Null;
                    cmonitoring.SF2_01_Remediation_Date__c   = Null;
                    cmonitoring.SF2_01_Remediation_Plan__c = Null;
                    cmonitoring.SF2_01_Remediation_Steps_Completed__c = Null;
                }
            if(cmonitoring.SF2_02__c == 'Yes')
                {
                    cmonitoring.SF2_02_Remediated__c = Null;
                    cmonitoring.SF2_02_Remediation_Date__c   = Null;
                    cmonitoring.SF2_02_Remediation_Plan__c = Null;
                    cmonitoring.SF2_02_Remediation_Steps_Completed__c = Null;
                }
            if(cmonitoring.SF2_03__c == 'Yes')
                {
                    cmonitoring.SF2_03_Remediated__c = Null;
                    cmonitoring.SF2_03_Remediation_Date__c   = Null;
                    cmonitoring.SF2_03_Remediation_Plan__c = Null;
                    cmonitoring.SF2_03_Remediation_Steps_Completed__c = Null;
                }
            if(cmonitoring.SF2_04__c == 'Yes')
                {
                    cmonitoring.SF2_04_Remediated__c = Null;
                    cmonitoring.SF2_04_Remediation_Date__c   = Null;
                    cmonitoring.SF2_04_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_04_Remediation_Steps_Completed__c = Null;
                }
            if(cmonitoring.SF2_05__c == 'Yes')
                {
                    cmonitoring.SF2_05_Remediated__c = Null;
                    cmonitoring.SF2_05_Remediation_Date__c   = Null;
                    cmonitoring.SF2_05_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_05_Remediation_Steps_Completed__c = Null;
                }
            if(cmonitoring.SF2_06__c == 'Yes')
                {
                    cmonitoring.SF2_06_Remediated__c = Null;
                    cmonitoring.SF2_06_Remediation_Date__c   = Null;
                    cmonitoring.SF2_06_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_06_Remediation_Steps_Completed__c = Null;
                }
            if(cmonitoring.SF2_07__c == 'Yes')
                {
                    cmonitoring.SF2_07_Remediated__c = Null;
                    cmonitoring.SF2_07_Remediation_Date__c   = Null;
                    cmonitoring.SF2_07_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_07_Remediation_Steps_Completed__c = Null;
                }                           
            if(cmonitoring.SF2_08__c == 'Yes')
                {
                    cmonitoring.SF2_08_Remediated__c = Null;
                    cmonitoring.SF2_08_Remediation_Date__c   = Null;
                    cmonitoring.SF2_08_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_08_Remediation_Steps_Completed__c = Null;
                }
             if(cmonitoring.SF2_09__c == 'Yes')
                {
                    cmonitoring.SF2_09_Remediated__c = Null;
                    cmonitoring.SF2_09_Remediation_Date__c   = Null;
                    cmonitoring.SF2_09_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_09_Remediation_Steps_Completed__c = Null;
                }
             if(cmonitoring.SF2_10__c == 'Yes')
                {
                    cmonitoring.SF2_10_Remediated__c = Null;
                    cmonitoring.SF2_10_Remediation_Date__c   = Null;
                    cmonitoring.SF2_10_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_10_Remediation_Steps_Completed__c = Null;
                }   
              if(cmonitoring.SF2_11__c == 'Yes')
                {
                    cmonitoring.SF2_11_Remediated__c = Null;
                    cmonitoring.SF2_11_Remediation_Date__c   = Null;
                    cmonitoring.SF2_11_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_11_Remediation_Steps_Completed__c = Null;
                }   
              if(cmonitoring.SF2_12__c == 'Yes')
                {
                    cmonitoring.SF2_12_Remediated__c = Null;
                    cmonitoring.SF2_12_Remediation_Date__c   = Null;
                    cmonitoring.SF2_12_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_12_Remediation_Steps_Completed__c = Null;
                }
              if(cmonitoring.SF2_13__c == 'Yes')
                {
                    cmonitoring.SF2_13_Remediated__c = Null;
                    cmonitoring.SF2_13_Remediation_Date__c   = Null;
                    cmonitoring.SF2_13_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_13_Remediation_Steps_Completed__c = Null;
                }
              if(cmonitoring.SF2_14__c == 'Yes')
                {
                    cmonitoring.SF2_14_Remediated__c = Null;
                    cmonitoring.SF2_14_Remediation_Date__c   = Null;
                    cmonitoring.SF2_14_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_14_Remediation_Steps_Completed__c = Null;
                }
              if(cmonitoring.SF2_15__c == 'Yes')
                {
                    cmonitoring.SF2_15_Remediated__c = Null;
                    cmonitoring.SF2_15_Remediation_Date__c = Null;
                    cmonitoring.SF2_15_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_15_Remediation_Steps_Completed__c = Null;
                }
              if(cmonitoring.SF2_16__c == 'Yes')
                {
                    cmonitoring.SF2_16_Remediated__c = Null;
                    cmonitoring.SF2_16_Remediation_Date__c  = Null;
                    cmonitoring.SF2_16_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_16_Remediation_Steps_Completed__c = Null;
                } 
              if(cmonitoring.SF2_17__c == 'Yes')
                {
                    cmonitoring.SF2_17_Remediated__c = Null;
                    cmonitoring.SF2_17_Remediation_Date__c = Null;
                    cmonitoring.SF2_17_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_17_Remediation_Steps_Completed__c = Null;
                } 
              if(cmonitoring.SF2_18__c == 'Yes')
                {
                    cmonitoring.SF2_18_Remediated__c = Null;
                    cmonitoring.SF2_18_Remediation_Date__c = Null;
                    cmonitoring.SF2_18_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_18_Remediation_Steps_Completed__c = Null;
                }
              if(cmonitoring.SF2_19__c == 'Yes')
                {
                    cmonitoring.SF2_19_Remediated__c = Null;
                    cmonitoring.SF2_19_Remediation_Date__c = Null;
                    cmonitoring.SF2_19_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_19_Remediation_Steps_Completed__c = Null;
                }
              if(cmonitoring.SF2_20__c == 'Yes')
                {
                    cmonitoring.SF2_20_Remediated__c = Null;
                    cmonitoring.SF2_20_Remediation_Date__c = Null;
                    cmonitoring.SF2_20_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_20_Remediation_Steps_Completed__c = Null;
                }
              if(cmonitoring.SF2_21__c == 'Yes')
                {
                    cmonitoring.SF2_21_Remediated__c = Null;
                    cmonitoring.SF2_21_Remediation_Date__c = Null;
                    cmonitoring.SF2_21_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_21_Remediation_Steps_Completed__c = Null;
                }
              if(cmonitoring.SF2_22__c == 'Yes')
                {
                    cmonitoring.SF2_22_Remediated__c = Null;
                    cmonitoring.SF2_22_Remediation_Date__c = Null;
                    cmonitoring.SF2_22_Remediation_Plan__c   = Null;
                    cmonitoring.SF2_22_Remediation_Steps_Completed__c = Null;
                }               
                            
                                                
             Integer Date1 = system.now().day();
             Integer Date2 = cmonitoring.CM_CF_Last_Modified_Date__c.Day(); 
             Integer Date3 = Date2 - Date1;
             
             system.debug('Date3-->'+Date3);
             
           
              if(Date2 - Date1 == 7)
              system.debug('Date2-->'+Date2);
              system.debug('Date1-->'+Date1);
            {
                //EmailTemplate et = [SELECT id FROM EmailTemplate WHERE Id = '00X55000000E3xe'];
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> ccAddresses = new List<String>();
                //ccAddresses.add(cmonitoring.CC_Owner_Email__c);
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'lcsalesforceadmin@mcmcg.com'];
                
                
                for(Call_Monitoring__c cmonitoring1 : Trigger.new)
                {
                    String body = 'Dear '+ cmonitoring1.Owner_Name__c+'\n'+'\n'+'This is a reminder that a remediation response is past due for Call'  +'\n'+' Monitoring Remediation record '+ 
                    cmonitoring1.Name+ ' As a'+'\n'+' reminder, critical violations are required to be remediated within 7 days.'
                    +'\n'+'Please log into the Consumer Inquiries System (CIS) or click the link below'+'\n'+'to access the record and provide a remediation response as soon as'+'\n'+'possible'
                    +'\n'+'\n'+'https://cs41.salesforce.com/'+cmonitoring1.id+'\n'+'\n'+'If you have any questions regarding this process or the requirement,'
                    +'\n'+'please email FirmManagement@mcmcg.com'+'\n'+'\n'+'Firm Management Team';
            
                mail.setSubject('Past Due: Critical Violation Remediation Response');
                //mail.setCcAddresses(ccAddresses);
                mail.setPlainTextBody(body);
                mail.setTargetObjectId(cmonitoring1.OwnerId);
                mail.setSaveAsActivity(false);
                if (owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
             }
           }
           */       
       /* }                              
    }  
    */
}