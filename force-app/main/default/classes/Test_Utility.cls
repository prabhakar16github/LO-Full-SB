@isTest
public class Test_Utility{       
   
    @isTest(SeeAllData=true)
    static void testAllMethods()
    {
         //String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Call_Monitoring__c' and Name = 'Call_Monitoring_QA'].Id;
         utility.getProfileNameSettings();
         utility.getTrialWitnessProfileLabel();
         utility.getTW_CISProfileLabel();
         utility.getCISProfileNameLabel();
         utility.getOWDFirmManagmentEmail();
         utility.getCISCMRecordType('QA');
         utility.getCISCMEmail_ReminderRecordType('QA');
         utility.getCMRecordType('012J00000000oN9');
    }
    
    public static String CreateOrganization(){
        Account accObj = new Account();
        accObj.Name = 'Test Organization';
        accObj.Firm_ID__c = '12345678';
        accObj.Phone = '+91-8233223232';
        accObj.Physical_Street__c = 'Sample Street';
        accObj.Physical_Postal_Code__c = '122111';
        accObj.Physical_City__c = 'Sample City';
        accObj.Physical_Country__c = 'Sample Country';
        accObj.Physical_State_Province__c = 'Sample Province';
        accObj.Paralegal__c = UserInfo.getUserId();
        insert accObj;
        return accObj.id;
    }
    
    public static String CreateStateProfile(){
        State_Profile__c stateProfileObj = new State_Profile__c();
        stateProfileObj.Name = 'Test Profile';
        stateProfileObj.State_NPV_Group__c = 'Low';
        stateProfileObj.SP_Paralegal__c = UserInfo.getUserId();
        insert stateProfileObj;
        return stateProfileObj.id;
    }
    
    
}