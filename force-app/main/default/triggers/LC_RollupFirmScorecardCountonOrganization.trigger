trigger LC_RollupFirmScorecardCountonOrganization on Firm_Scorecard__c (after delete, after insert, after undelete, after update) 
{
Set<Id> aId = new Set<Id>();

    if(Trigger.isInsert || Trigger.isUndelete || Trigger.isUpdate){
        for(Firm_Scorecard__c opp : Trigger.New){
            aId.add(opp.Organization_Name__c);
        }
        List<Account> acc = [select id,Firm_Scorecard_Count__c from Account where Id in:aId];
        List<Firm_Scorecard__c> con = [select id from Firm_Scorecard__c where Organization_Name__c in :aId];

        for(Account a : acc){
            a.Firm_Scorecard_Count__c=con.size();

        }update acc;
    }

    if(Trigger.isDelete){
        for(Firm_Scorecard__c opp : Trigger.old){
            aId.add(opp.Organization_Name__c);
        }
        List<Account> acc = [select id,Firm_Scorecard_Count__c from Account where Id in:aId];
        List<Firm_Scorecard__c> con = [select id from Firm_Scorecard__c where Organization_Name__c in :aId];

        for(Account a : acc){
            a.Firm_Scorecard_Count__c=con.size();

        }update acc;
    }

    /*if(Trigger.isUpdate){
       Set<Id> OldAId = new Set<Id>(); 
        for(Firm_Scorecard__c opp : Trigger.new){
        if(opp.Organization_Name__c != Trigger.oldMap.get(opp.id).Organization_Name__c)
            aId.add(opp.Organization_Name__c);
            OldAId.add(Trigger.oldMap.get(opp.id).Organization_Name__c);

        }
        if(!aId.isEmpty()){
        //for new Accounts
        List<Account> acc = [select id,Firm_Scorecard_Count__c from Account where Id in:aId];
        //For New Account Firm_Scorecard__c
        List<Firm_Scorecard__c> con = [select id from Firm_Scorecard__c where Organization_Name__c in :aId];

        /*
        This is For Old Firm_Scorecard__c Count
                            

        //for Old Accounts
        List<Account> Oldacc = [select id,Firm_Scorecard_Count__c from Account where Id in:OldAId];

        //For Old Account Firm_Scorecard__c
        List<Firm_Scorecard__c> OldCon = [select id from Firm_Scorecard__c where Organization_Name__c in :OldAId];

        //For New Accounts
        for(Account a : acc){
            a.Firm_Scorecard_Count__c=con.size();

        }update acc;

        //For Old Accounts
        for(Account a : Oldacc){
            a.Firm_Scorecard_Count__c=OldCon.size();

        }update Oldacc;
        }
    }    */  
}