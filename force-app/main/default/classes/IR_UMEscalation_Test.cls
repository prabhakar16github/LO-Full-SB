@isTest
public class IR_UMEscalation_Test {
	@isTest
    static void test1(){
        
        Account acc = new Account();
        acc.Firm_ID__c ='test';
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        insert acc;
        
        Contact con = new Contact();
        //con.AccountId  = acc.Id;
        con.lastName = 'test';
        con.Community_User__c = true;
        insert con;
        
        AccountContactRelation acRel = new AccountContactRelation();
        acRel.AccountId = acc.Id;
        acRel.ContactId = con.Id;
        //insert acRel;
        
        Date todaysDate = System.today().addMonths(-1);
    	String month = String.valueOf(todaysDate.month());
        
        if(month.length() == 1){
        	month = '0' + month; // format month
        }
        String reportingPeriod = todaysDate.year() +'-'+ month;
        
        Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c();
        pamObj.Organization_Name__c = acc.id;
        pamObj.Account_Number__c='121211';
        pamObj.SOL_Firm_Date_Filed_Suit__c=system.today();
        pamObj.SOL_Firm_SOL_Date__c=system.today();
        pamObj.SOL_Firm_SOL_Process__c='Test';
        pamObj.SCMD_Reporting_Period__c = reportingPeriod;
        insert pamObj;
        
        Id pamUMIrFirmClosedRecTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
        
        PAM_Unmatched__c pamUn = new PAM_Unmatched__c();
        pamUn.PAMUM_Process_Adherence_Monitoring__c = pamObj.Id;
        pamUn.PAMUM_Status__c = 'New';
        pamUn.RecordTypeId = pamUMIrFirmClosedRecTypeId;
        insert pamUn;
        
        IR_UMFirstEscalationScheduler obj = new IR_UMFirstEscalationScheduler();
        obj.execute(NULL);
        IRUMReminderNotificationScheduler obj2 = new IRUMReminderNotificationScheduler();
        obj2.execute(NULL);
        
        IR_EmailCommunicationTemplates.IRCommunicationWrapper wrp = new IR_EmailCommunicationTemplates.IRCommunicationWrapper();
        wrp.contactFirstName = con.LastName;
        wrp.cutOffDate = String.valueOf(System.today());
 		wrp.filesDueToMCM =String.valueOf(System.today());
 		wrp.pamObj = pamObj;
 		wrp.isCommmunityUser = true;
 		wrp.contactEmail = 'test@abc.com';
        
        IR_UnmatchedService.ProcessTypeIRUM process = IR_UnmatchedService.ProcessTypeIRUM.INITIAL;
        IR_UnmatchedService.createEmailForIRUnmatched(wrp,'test',process);
        IR_UnmatchedService.ProcessTypeIRUM process2 = IR_UnmatchedService.ProcessTypeIRUM.REMINDER;
        IR_UnmatchedService.createEmailForIRUnmatched(wrp,'test',process2);
        IR_UnmatchedService.ProcessTypeIRUM process3 = IR_UnmatchedService.ProcessTypeIRUM.FIRST_ESCALATION;
        IR_UnmatchedService.createEmailForIRUnmatched(wrp,'test',process3);
        IR_UnmatchedService.ProcessTypeIRUM process4 = IR_UnmatchedService.ProcessTypeIRUM.FINAL_ESCALATION;
        IR_UnmatchedService.createEmailForIRUnmatched(wrp,'test',process4);
        
        /*List<AccountContactRelation> accRel = [SELECT Id,AccountId,ContactId FROM AccountContactRelation 
                                               WHERE AccountId = :acc.Id AND ContactId = :con.Id];
        IR_UnmatchedService.getInitialUnmatchedNotification(accRel[0],pamObj,acc);
            */
    }
    
    @isTest
    static void test2(){
        
        Account acc = new Account();
        acc.Firm_ID__c ='test';
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        
        insert acc;
        
        Date todaysDate = System.today().addMonths(-1);
    	String month = String.valueOf(todaysDate.month());
        
        if(month.length() == 1){
        	month = '0' + month; // format month
        }
        String reportingPeriod = todaysDate.year() +'-'+ month;
        
        Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c();
        pamObj.Organization_Name__c = acc.id;
        pamObj.Account_Number__c='121211';
        pamObj.SOL_Firm_Date_Filed_Suit__c=system.today();
        pamObj.SOL_Firm_SOL_Date__c=system.today();
        pamObj.SOL_Firm_SOL_Process__c='Test';
        //pamObj.SOL_State_Where_Firm_Filed_Suit__c='AK';
        pamObj.SCMD_Reporting_Period__c = reportingPeriod;
        //pamObj.RecordTypeId=Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SOL').getRecordTypeId();
        insert pamObj;
        
        Id pamUMIrFirmClosedRecTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
        
        PAM_Unmatched__c pamUn = new PAM_Unmatched__c();
        pamUn.PAMUM_Process_Adherence_Monitoring__c = pamObj.Id;
        pamUn.PAMUM_Status__c = 'First Escalation';
        pamUn.RecordTypeId = pamUMIrFirmClosedRecTypeId;
        insert pamUn;
        
        IRUM_FinalEscalationScheduler obj2 = new IRUM_FinalEscalationScheduler();
        obj2.execute(NULL);
            
    }
    
    @isTest
    static void test3(){
        
        Account acc = new Account();
        acc.Firm_ID__c ='test';
        acc.Name = 'CA137';
        acc.Phone = '98828383';
        acc.Physical_Street__c= 'test';
        acc.Physical_City__c = 'city';
        acc.Physical_Postal_Code__c = '11111';
        acc.Physical_Country__c = 'test country';
        acc.Physical_State_Province__c = 'Province';
        
        insert acc;
        
        Date todaysDate = System.today().addDays(-1);
    	String month = String.valueOf(todaysDate.month());
        
        if(month.length() == 1){
        	month = '0' + month; // format month
        }
        String reportingPeriod = todaysDate.year() +'-'+ month;
        
        Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c();
        pamObj.Organization_Name__c = acc.id;
        pamObj.Account_Number__c='121211';
        pamObj.SOL_Firm_Date_Filed_Suit__c=system.today();
        pamObj.SOL_Firm_SOL_Date__c=system.today();
        pamObj.SOL_Firm_SOL_Process__c='Test';
        pamObj.SCMD_Reporting_Period__c = reportingPeriod;
        insert pamObj;
        
        Id pamUMIrFirmClosedRecTypeId = Schema.SObjectType.PAM_Unmatched__c.getRecordTypeInfosByName().get('LO IRUM - Firm Open').getRecordTypeId();
        
        PAM_Unmatched__c pamUn = new PAM_Unmatched__c();
        pamUn.PAMUM_Process_Adherence_Monitoring__c = pamObj.Id;
        pamUn.PAMUM_Status__c = 'Final Escalation';
        pamUn.RecordTypeId = pamUMIrFirmClosedRecTypeId;
        insert pamUn;
        
        IRUM_MonthlyNoResponseScheduler obj = new IRUM_MonthlyNoResponseScheduler();
        obj.execute(NULL);
            
    }
}