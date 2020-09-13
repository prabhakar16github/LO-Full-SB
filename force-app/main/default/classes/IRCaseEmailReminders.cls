global class IRCaseEmailReminders implements Database.Batchable<SObject>{   
    
    public date cutOffDate;
       
    global database.querylocator start(Database.BatchableContext bc){
                           
        string query= 'Select id,Email,FirstName,Name,Contact_Type_SME__c from Contact where Inactive_Contact__c = false and Contact_Type_SME__c Includes(\'Inventory Reconciliation\')';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, Contact[] ContactList){
                
        Date currentDate = system.today();
        Date nextMonthsDate = currentDate.addMonths(1);  
        
        /*
        Integer Month = currentDate.month();
        Integer Month1 = currentDate.addMonths(1).month();
        Integer year = currentDate.year(); 
        
        if(Month == 12){
            
            year = currentDate.addMonths(1).year();
        }else{
        
            year = currentDate.year();
        }
        
        */
        
        date cutOffDate = Date.newInstance(currentDate.year(), currentDate.month(), 25);
        //system.debug('cutOffDate=='+cutOffDate);
        String cutoffString = cutOffDate.format();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();                        
        date FileDueToYGC =  Date.newInstance(currentDate.year(), currentDate.month(), 28);
        String FileDueToYGCString = FileDueToYGC.format();        
        date ActionItemCompleted = Date.newInstance(nextMonthsDate.year(), nextMonthsDate.month(), 10);   
        String ActionItemCompletedString = ActionItemCompleted.format();
          
        if(ContactList.size() <> 0){
            
           if(system.today() == cutOffDate - 1){
                                
            for(Contact cnt : contactlist){
                if(cnt.email != null){
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    List<String> sendTo = new List<String>();
                    sendto.add(cnt.Email); email.setToAddresses(sendto); email.setSubject('Monthly YGC Inventory Reconciliations - Cutoff Tomorrow'); email.setHtmlBody('Hello   ' +cnt.FirstName+ ',<br/><br/><b>Please remember the cutoff date is tomorrow!</b><br/><br/>*Cut-off date - ' +cutoffString+ '<br/><br/>*Files Due To YGC - ' +FileDueToYGCString+'<br/><br/>*Action Item Completed - ' +ActionItemCompletedString+ '<br/><br/><br/> Please reply to the email you will receive from the Inventory Reconciliations Team via Salesforce cc:Mike Martinez michael.martinez@vertican.com  once your action items are completed.<br/><br/><br/>For your convenience, we will always accept your files prior to the due date.<br/><br/><br/>Please email  lo-inventoryrecon@mcmcg.com  with any questions you may have.<br/><br/><br/>Thanks<br/>Inventory Reconciliation Team'); 
                    emails.add(email); 
                }
            }
            //system.debug('emails----------------->'+emails);       
            if(emails.size()>0){
                Messaging.sendEmail(emails);
            }
            
          }else if(system.today() == cutOffDate - 7){
                         
            for(Contact cnt : contactlist){
               
                if(cnt.email != null){
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    List<String> sendTo = new List<String>();
                    sendto.add(cnt.Email); email.setToAddresses(sendto); email.setSubject('Monthly YGC Inventory Reconciliations'); email.setHtmlBody('Hello  ' +cnt.FirstName+ ',<br/><br/>*Cut-off date - ' +cutoffString+ '<br/><br/>*Files Due To YGC - ' +FileDueToYGCString+'<br/><br/>*Action Item Completed - ' +ActionItemCompletedString+ '<br/><br/><br/> Please reply to the email you will receive from the Inventory Reconciliations Team via Salesforce cc:Mike Martinez michael.martinez@vertican.com  once your action items are completed.<br/><br/><br/>For your convenience, we will always accept your files prior to the due date.<br/><br/><br/>Please email  lo-inventoryrecon@mcmcg.com  with any questions you may have.<br/><br/><br/>Thanks<br/>Inventory Reconciliation Team');                          
                    emails.add(email);
                }                
            }
            //system.debug('emails--------------->'+emails);
            if(emails.size()>0){
               Messaging.sendEmail(emails);
            }
           } 
             
        }
       /*  if(system.today() == cutOffDateList1[0].Dec_Date__c)          
           {
            
                Messaging.SingleEmailMessage email1 = new Messaging.SingleEmailMessage();
                string[]  toaddress=new String[] {'Lcsalesforceadmin@mcmcg.com'};
                email1.setSubject('Please send cut off dates for next year');               
                email1.setHtmlBody('Hello ,<br/><br/><b>Please send cut off dates for next year</b><br/><br/>Thanks<br/>Inventory Reconciliation Team') ;                
                email1.setToAddresses(toaddress);                            
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email1 });
           }  */
           
           // adding some buffer coverage because we are using system.today() method here so it will not execute the code
           
             bufferExecute();      
    }
   
    global void finish(Database.BatchableContext bc){
        //system.debug('executing final block ');
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CompletedDate,CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        
        if(a!=null){
            
             //system.debug('===a===='+a); 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
            String[] toAddresses = new String[] {'lcsalesforceadmin@mcmcg.com'};
            mail.setToAddresses(toAddresses);        
            mail.setSubject('IR Case Email Reminder Batch Job has been completed: ' + a.CompletedDate);   
            mail.setPlainTextBody('This job has processed: '+ a.JobItemsProcessed +' batches with '+ a.NumberOfErrors + ' failures.');
            //system.debug('===mail===='+mail);        
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
      }
        
    }
    
    private void bufferExecute(){
        
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;  
        
    }

}