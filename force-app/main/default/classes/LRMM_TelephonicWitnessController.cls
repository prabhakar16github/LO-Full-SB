/********************************************** 
* Class Name	    : LRMM_TelephonicWitnessController
* Description		: Controller class for LRMM_TelephonicWitnessController for Aura component : LRMM_NewTelephonicWitness
* Created By  		: Shivangi Srivastava
* Created Date		: 20-July-2020
* *************************************************/



public class LRMM_TelephonicWitnessController {
    //LRMM_CustomLinkOfCAD
   /* @AuraEnabled
    public static string fetchProfileNameofUser(){
        User usr = [SELECT Id , profile.Name FROM User WHERE Id =: userInfo.getUserId()];
        System.debug('usr.id >>>>  '+usr.ProfileId);
        profile usrProfile = [select name from profile where id=:usr.ProfileId];//'00e0B000001AB4iQAG'
        system.debug('p >>> '+usrProfile);
        return usrProfile.name;
    }*/
    
    //LRMM_NewTelephonicWitness
    @AuraEnabled 
    public static Trial_Witness_Request__c fetchCAD_Records(Id CADId){
       List<Consumer_Account_Details__c> cadList = [SELECT Id,Organization_name__c,Account_Number__c,Original_Creditor__c,OwnerId
                                                     FROM Consumer_Account_Details__c 
                                                     WHERE Id=: CADId];
        
        List<RecordType> rectype = [select Id,Name from RecordType where name='Telephonic Witness Request'];
        
        Trial_Witness_Request__c tw = new Trial_Witness_Request__c();
        tw.OrganizationName__c = cadList[0].Organization_name__c;
        tw.Account_Number__c = cadList[0].Account_Number__c;
        tw.Original_Creditor__c = cadList[0].Original_Creditor__c;
        tw.OwnerId = cadList[0].OwnerId;
        tw.RecordTypeId = rectype[0].Id;
        tw.TW_Consumer_Account_Records__c = cadList[0].Id;
        return tw;         
    }   
}