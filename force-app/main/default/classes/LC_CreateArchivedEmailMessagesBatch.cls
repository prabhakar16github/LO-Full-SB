global class LC_CreateArchivedEmailMessagesBatch implements Database.Batchable<sObject>
{
  
  global Database.QueryLocator start(Database.BatchableContext BC)
  {
     Date D1 = System.Today().AddMonths(-18);  
     Map<String,String> mapRecordTypeIdName=new  Map<String,String>();
     Map<String,String> mapRecordTypeNameID=new  Map<String,String>();
      Schema.sObjectType objType = Case.getSObjectType();
      Schema.DescribeSObjectResult sObjReslt = objType.getDescribe();  
      Map<String,Schema.RecordTypeInfo> rtMapByName = sObjReslt.getRecordTypeInfosByName();
      
     for(String str:rtMapByName.keySet())
     {
         Schema.RecordTypeInfo rtByName =  rtMapByName.get(str);
             if(rtByName.isAvailable()){
                 System.debug('RecordTypeName--->'+rtByName.getName());
             if(rtByName.getName()=='Operations' || rtByName.getName()=='Operations - AA' || rtByName.getName() == 'Operations - Account Inquiry' || rtByName.getName() == 'Operations - CAO'
                || rtByName.getName() == 'Operations - IR'){   
                 mapRecordTypeIdName.put(rtByName.getRecordTypeId(),rtByName.getName());
                 mapRecordTypeNameID.put(rtByName.getName(),rtByName.getRecordTypeId());
               }
             }  
     }
     
     return Database.getQueryLocator([Select id,LastModifiedDate,ParentId,RecordTypeId,IsClosed FROM Case WHERE LastModifiedDate <= : D1 AND IsClosed = true AND (RecordTypeId =:mapRecordTypeNameID.get('Operations') OR RecordTypeId =:mapRecordTypeNameID.get('Operations - AA') OR RecordTypeId =:mapRecordTypeNameID.get('Operations - Account Inquiry') OR RecordTypeId =:mapRecordTypeNameID.get('Operations - CAO') OR RecordTypeId =:mapRecordTypeNameID.get('Operations - IR'))]);
     //return Database.getQueryLocator(query);
  }  
  global void execute(Database.BatchableContext BC,  List<Case> caseList)
  
  {  
     Date D = System.Today().AddMonths(-18);
        system.debug('D-->'+D); 
         map<Id,Case> mapCases = new map<Id,Case>(); 
         system.debug('D-->'+caseList.size());
     for(Case cs: caseList){
         mapCases.put(cs.Id,cs);
     }
        
        system.debug('em-->'+mapCases);   
        List<EmailMessage> emailmessage = new List<EmailMessage>();
        emailmessage =  [SELECT ActivityId,BccAddress,CcAddress,
                      CreatedById,CreatedBy.Name,CreatedDate,FromAddress,FromName,HasAttachment,
                      Headers,Id,Incoming,IsDeleted,LastModifiedById,LastModifiedBy.Name,LastModifiedDate,MessageDate,
                      ParentId,ReplyToEmailMessageId,Status,Subject,ToAddress 
                      FROM EmailMessage WHERE LastModifiedDate <= : D AND ParentId IN: mapCases.keyset() LIMIT 9000]; 
                  
         system.debug('emailmessage -->'+emailmessage.size());
         if(emailmessage <> null || emailmessage.size() >0 ){
         delete emailmessage;
         }
  
  }
   global void finish(Database.BatchableContext BC){
        
    }
}