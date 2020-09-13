trigger LC_InsertOrganizationUserSupport on User_Support__c (before insert) 
{
    Map<String,Contact> contmap = new Map<String,Contact>();
    
    List<Contact> conList = new List<Contact>([Select id,Name,AccountId,Community_User__c,Email from Contact]);
    Boolean myPosition = [Select IsPortalEnabled  From User Where Id = :UserInfo.getUserId()][0].IsPortalEnabled;
    
    system.debug('conList-->'+conList);
    
    for(Contact con : conList)
    {
        contmap.put(con.Name,con);
    }
    system.debug('contMap-->'+contmap);
    system.debug('userinfo.getUserName()-->'+userinfo.getName());
    for(User_Support__c ci : Trigger.new)
    {
        if(contmap.containskey(userinfo.getName()) && myPosition == True)
        {
            system.debug('**********-->');
            ci.Organization_Name__c  = contmap.get(userinfo.getName()).AccountId;
            system.debug('ci.Organization_Name__c-->'+ci.Organization_Name__c);
        }
    }        
}