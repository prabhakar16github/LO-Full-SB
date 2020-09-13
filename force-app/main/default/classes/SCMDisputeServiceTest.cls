@isTest
public class SCMDisputeServiceTest {
	@isTest
    static void test1(){
        Account accountObj = new Account();
        
        accountObj.Firm_ID__c = 'UT-11';
        accountObj.Firm_Status_IN__c = 'Active';
        accountObj.Name = 'Test Organisation';
        insert accountObj;
        
        Contact cont = new Contact();
        cont.LastName = 'test Contact';
        insert cont;
        
        Contact cont2 = new Contact();
        cont2.LastName = 'test Contact';
        cont2.AccountId = accountObj.Id;
        insert cont2;
        
        
        List<AccountContactRelation> acRelation = [SELECT Id,AccountId,ContactId FROM AccountContactRelation ];
        
        Process_Adherence_Monitoring__c pamObj = new Process_Adherence_Monitoring__c();
        pamObj = new Process_Adherence_Monitoring__c(Organization_Name__c = accountObj.id,Account_Number__c='121211',SOL_Firm_Date_Filed_Suit__c=system.today(),
                                                     SOL_Firm_SOL_Date__c=system.today(),SOL_Firm_SOL_Process__c='Test',
                                                     SOL_State_Where_Firm_Filed_Suit__c='AK',
                                                     RecordTypeId=Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('LO SOL').getRecordTypeId());
        
        SCMDisputeService.createMonthlyLOSCMD(new List<Account>{accountObj});
        SCMDisputeService.createMonthlyACFSCMD(new List<Account>{accountObj});
        
        Map<Id,List<Process_Adherence_Monitoring__c>> processAdhMap = new Map<Id,List<Process_Adherence_Monitoring__c>>{accountObj.Id=>new List<Process_Adherence_Monitoring__c>{pamObj}};
        //Map<Id,List<AccountContactRelation>> acRelationMap = new Map<Id,List<AccountContactRelation>>{accountObj.Id=>acRelation};
            //SCMDisputeService.sendFirstEscalationEmailToContacts(processAdhMap,acRelationMap);
            Map<Id,String> accIdToEmilMap = new Map<Id,String>{accountObj.Id=>'test@abc.com'};
                SCMDisputeService.sendNoResponseFirmsMailToOwners(processAdhMap, accIdToEmilMap);
        SCMDisputeService.sendNoResponseACFFirmsMailToOwners(processAdhMap, accIdToEmilMap);
        SCMDisputeService.bufferCode();
    }
}