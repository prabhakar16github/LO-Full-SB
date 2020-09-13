trigger LC_InsertOrganizationonCallMonitoring on Call_Monitoring__c (before insert)

{
    Map<String,Contact> contmap = new Map<String,Contact>();
    Id userContactId = [select Id,Name,ContactId from User where Id=:UserInfo.getUserId()].ContactId;
    List<Contact> conList = new List<Contact>([Select id,Name,AccountId,Community_User__c,Email from Contact 
                                               where Community_User__c=true AND Id=:userContactId]);
    Boolean myPosition = [Select IsPortalEnabled  From User Where Id = :UserInfo.getUserId()][0].IsPortalEnabled;
    
    for(Contact con : conList)
    {
        contmap.put(con.Name,con);
    }
    
    Id cmMaterialRecordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Materials').getRecordTypeId();
    
    for(Call_Monitoring__c ci : Trigger.new)
    {
        if(contmap.containskey(userinfo.getName()) && myPosition == True && ci.recordtypeid == cmMaterialRecordTypeId )
        {
            ci.Organization_Name_CM__c = contmap.get(userinfo.getName()).AccountId;
        }
    }    
}