trigger   generateCI_Connection2CSS on Consumer_Inquiries__c (after insert) {


// Get Record Type ID
map<id,Consumer_Inquiries__c > mapIDCI=new map<id,Consumer_Inquiries__c > ();
List<PartnerNetworkRecordConnection> recordConnectionToInsert  = new List<PartnerNetworkRecordConnection>  ();
Map<String,Schema.RecordTypeInfo> CIRecordTypeInfo = Schema.SObjectType.Consumer_Inquiries__c.getRecordTypeInfosByName(); 
Id recordTypeId = CIRecordTypeInfo.get('Regulatory Complaint').getRecordTypeId();
String connectionNameCSS;

// Get Connection Details
S2S_ConnectionDetails__c getCSSConnectionDetails = S2S_ConnectionDetails__c.getInstance('CSSConnectionName');
if(!test.isrunningTest()){
connectionNameCSS = getCSSConnectionDetails.ConnectionName__c;  
} 
System.debug('Sunny------>>>'+connectionNameCSS);
        
        
if(trigger.isInsert)
{
   if(connectionNameCSS!=null){
    PartnerNetworkConnection conn = [select Id, ConnectionStatus, ConnectionName from PartnerNetworkConnection  
                                     where ConnectionStatus = 'Accepted' and ConnectionName=:connectionNameCSS];
   
   
   
    for (Consumer_Inquiries__c cI:trigger.new)
       {
            if(ci.RecordTypeId == recordTypeId && conn!=null){
        
            PartnerNetworkRecordConnection newrecord = new PartnerNetworkRecordConnection();
            newrecord.ConnectionId = conn.Id;
            newrecord.LocalRecordId = cI.id;  
            newrecord.SendClosedTasks = false;
            newrecord.SendOpenTasks = false;
            newrecord.SendEmails = false;
            recordConnectionToInsert.add(newrecord);
           
           } 
            
            
        }
     }   
        if (!recordConnectionToInsert.isEmpty()){
            System.debug('>>> Sharing ' + recordConnectionToInsert.size() + ' records'+recordConnectionToInsert);
          //  insert recordConnectionToInsert;
          
            Database.Saveresult[] srList = database.insert(recordConnectionToInsert,false); 
        }

}

}