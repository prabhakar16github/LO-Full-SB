/***********************************************************************************
* Class Name 	: DM_Integration_Helper
* Description	: Helper class for DM_Integration
* Created By 	: Prabhakar Joshi
* Created Date	: 22-Nov-2019
* *******************************************************************************/
public class DM_Integration_Helper {
    public static List<OrgWideEmailAddress> orgWideEmail = [SELECT Id, Address, DisplayName, IsAllowAllProfiles 
                                                            FROM OrgWideEmailAddress 
                                                            WHERE Address = 'lcsalesforceadmin@mcmcg.com' LIMIT 1];
    
    /************************************* Method to process the JSON Data **************************************/
    public static void processJSONData(String jsonWrapStr){
        
        /***************************** Deserialize into the JSONWrapper Type ***************************************/
        JSONWrapper jsonWrap = (JSONWrapper)JSON.deserialize(jsonWrapStr, JSONWrapper.class);
        
        if(jsonWrap.status.code == 200 && jsonWrap.status.message == 'Success'){
            
            /********************* To get the Map of Custom Setting for dynamic field Mapping ****************/
            Map<String,DM_API_Field_Mapping__c> fieldMapping = DM_API_Field_Mapping__c.getAll();
            
            /******************************** Final List to insert the PAM Records **********************************/
            List<Process_Adherence_Monitoring__c> pamListToInsert = new List<Process_Adherence_Monitoring__c>();
            
            /******************************* Map of Firm Id and Account Id *********************************/
            Map<String,Account> firmIdToAccMap = new Map<String,Account>();
            
            /***************************** To get the record Type Ids ************************************/
            Id DM_PSNM_RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM PSNM').getRecordTypeId();
            Id DM_RSNM_RecordTypeId = Schema.SObjectType.Process_Adherence_Monitoring__c.getRecordTypeInfosByName().get('DM RSNM').getRecordTypeId();
            
            /*************************** Map of unique key and PAM Id **********************************/
            Map<String,Id> uniqueIdToPAMMap = new Map<String,Id>();
            
            /*************************** Map for JSON data which is coming from response **************************/
            List<Map<String,String>> DataMap = (List<Map<String, String>>)JSON.deserialize(JSON.serialize(jsonWrap.data),List<Map<String, String>>.class);
            
            /**************************** Iterate the JSON Data *******************************/
            for(Map<String,String> dw : DataMap){
                
                if(String.isNotBlank(dw.get('reactiveFlag')) || String.isNotBlank(dw.get('proactiveFlag')) || String.isNotBlank(dw.get('cotAffidavitSent'))){
                    if(String.isNotBlank(dw.get('suitTheoryDate')) && String.isNotBlank(dw.get('consumerAccountIdentifierAgencyId'))){
                        Id recordTypeId = getRecordTypeId(dw,DM_PSNM_RecordTypeId,DM_RSNM_RecordTypeId);
                        if(recordTypeId != NULL){
                            
                            String uniqueKey = dw.get('consumerAccountIdentifierAgencyId')+'@@'+recordTypeId+'@@'+(String.valueOf(dw.get('suitTheoryDate'))).split('T')[0];
                            uniqueIdToPAMMap.put(uniqueKey,NULL);
                        }
                    }
                }
                if(String.isNotBlank(dw.get('firmID'))){
                    firmIdToAccMap.put(dw.get('firmID'),NULL);
                }
            }
            
            if(firmIdToAccMap.keySet().size() > 0){
                for(Account acc : [SELECT Id,Firm_Id__c FROM Account 
                                   WHERE Firm_Id__c IN :firmIdToAccMap.keySet() 
                                   AND Firm_Id__c != NULL]){
                                       if(firmIdToAccMap.containskey(acc.Firm_ID__c)){
                                           firmIdToAccMap.put(acc.Firm_Id__c,acc);
                                       }
                                   }
            }
            
            if(uniqueIdToPAMMap.keySet().size() > 0){
                for(Process_Adherence_Monitoring__c pam : [SELECT Id,RecordTypeId,STNM_Suit_Theory_Code_Date__c,Account_Number__c 
                                                           FROM Process_Adherence_Monitoring__c
                                                           WHERE (RecordTypeId =:DM_PSNM_RecordTypeId 
                                                                  OR RecordTypeId =:DM_RSNM_RecordTypeId)
                                                           AND STNM_Suit_Theory_Code_Date__c != NULL
                                                           AND Account_Number__c != NULL]){
                                                               
                                                               String uniqueKey = pam.Account_Number__c+'@@'+pam.RecordTypeId +'@@'+(String.valueOf(pam.STNM_Suit_Theory_Code_Date__c)).split(' ')[0];
                                                               if(uniqueIdToPAMMap.containsKey(uniqueKey)){
                                                                   uniqueIdToPAMMap.put(uniqueKey,pam.Id);
                                                               }
                                                           }
            }
            System.debug('>>>>>>uniqueIdToPAMMap>>>>>>'+uniqueIdToPAMMap);
            for(Map<String,String> dw : DataMap){
                if(String.isNotBlank(dw.get('reactiveFlag')) || String.isNotBlank(dw.get('proactiveFlag')) || String.isNotBlank(dw.get('cotAffidavitSent'))){
                    if(String.isNotBlank(dw.get('suitTheoryDate')) && String.isNotBlank(dw.get('consumerAccountIdentifierAgencyId'))){
                        Id recordTypeId = getRecordTypeId(dw,DM_PSNM_RecordTypeId,DM_RSNM_RecordTypeId);
                        
                        if(recordTypeId != NULL){
                            String key = dw.get('consumerAccountIdentifierAgencyId')+'@@'+recordTypeId+'@@'+(String.valueOf(dw.get('suitTheoryDate'))).split('T')[0];
                            
                            if(uniqueIdToPAMMap.containsKey(key) && uniqueIdToPAMMap.get(key) == NULL){
                                
                                if(firmIdToAccMap.get(dw.get('firmID')) != NULL){
                                    Process_Adherence_Monitoring__c pam = new Process_Adherence_Monitoring__c();
                                    pam.Organization_Name__c = firmIdToAccMap.get(dw.get('firmID')).Id;
                                    pam.Organization_Name__r = firmIdToAccMap.get(dw.get('firmID'));
                                    
                                    pam.RecordTypeId = key.split('@@')[1];
                                    
                                    if(pam.RecordTypeId ==  DM_PSNM_RecordTypeId){
                                        pam.STNM_Missing_Media_Type__c = String.isNotBlank(dw.get('proactiveMissingDocTypes')) ? dw.get('proactiveMissingDocTypes') : '';
                                    }else if(pam.RecordTypeId == DM_RSNM_RecordTypeId){
                                        pam.STNM_Missing_Media_Type__c = String.isNotBlank(dw.get('reactiveMissingDocTypes')) ? dw.get('reactiveMissingDocTypes') : '';
                                    }
                                    
                                    Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Process_Adherence_Monitoring__c').getDescribe().fields.getMap();
                                    
                                    for(String sfField : fieldMapping.keySet()){
                                        String fielddataType = String.valueOf(fieldMap.get(sfField).getDescribe().getType());
                                        
                                        if(fieldMapping.get(sfField).Active__c){
                                            if(fielddataType == 'Date'){
                                                pam.put(sfField,String.isNotBlank(dw.get(fieldMapping.get(sfField).API_Parameter__c)) ? Date.valueOf(dw.get(fieldMapping.get(sfField).API_Parameter__c)) : NULL);
                                            }
                                            else if(fielddataType == 'DOUBLE' || fielddataType == 'CURRENCY'){
                                                pam.put(sfField,String.isNotBlank(dw.get(fieldMapping.get(sfField).API_Parameter__c)) ?  Decimal.valueOf(dw.get(fieldMapping.get(sfField).API_Parameter__c)) : NULL);
                                            }
                                            else if(fielddataType == 'BOOLEAN'){
                                                pam.put(sfField,String.isNotBlank(dw.get(fieldMapping.get(sfField).API_Parameter__c)) ?  Boolean.valueOf(dw.get(fieldMapping.get(sfField).API_Parameter__c)) : NULL);
                                            }
                                            else{
                                                pam.put(sfField,String.isNotBlank(dw.get(fieldMapping.get(sfField).API_Parameter__c)) ?  dw.get(fieldMapping.get(sfField).API_Parameter__c) : NULL);
                                            }
                                        }
                                    }
                                    pamListToInsert.add(pam);
                                    
                                }else{
                                    sendFailedRecordDescription(dw,NULL,'Firm Id','No Organization found with Firm Id <b>'+dw.get('firmID')+'</b> in Salesforce.');
                                }
                            }
                        }
                    }
                }
            }
            
            System.debug('>>>>>pamListToInsert>>>>>>'+pamListToInsert.size());
            if(pamListToInsert.size() > 0){
                String errorFields ;
                String errorDescription;
                Database.SaveResult[] result = Database.insert(pamListToInsert, false); 
                for(Integer i=0;i<result.size();i++){
                    if(!result[i].isSuccess()){
                        
                        for(Database.Error err : result[i].getErrors()){
                            errorFields = String.join(err.getFields(),',');
                            errorDescription = err.getMessage();
                            sendFailedRecordDescription(NULL,pamListToInsert[i],errorFields,errorDescription);
                        }
                    }
                }
            }
        }
    }
    
    private static void sendFailedRecordDescription(Map<String,String> dw,Process_Adherence_Monitoring__c pam,String errorFields,String description){
        
        if(orgWideEmail.size() > 0){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('DM PSNM/RSNM Failed Records Detail');
            String htmlBody = '<html><body>';
            htmlBody += 'An error has occurred during the API Call for PSNM/RSNM/COT Affidavit Process that has prevented a record from being created.<br/><br/>';
            htmlBody += '<table border="1" cellspacing="0" cellpadding="5"><thead>';
            htmlBody += '<tr><th>Account Number</th><th>Error Field</th><th>Description</th></tr>';
            if(pam != NULL){
                htmlBody += '<tr><td>'+pam.Account_Number__c+'</td><td>'+errorFields+'</td><td>'+description+'</td></tr>';
                htmlBody += '</thead></table><br/><br/>';
                htmlBody += 'Please see details of exception below:<br/>';
                htmlBody += '<ul><li>Account Number : '+pam.Account_Number__c+'</li>';
                htmlBody += '<li>Firm Id : '+pam.Organization_Name__r.Firm_Id__c +'</li><li>Original Creditor : '+pam.STNM_Original_Creditor__c +'</li>';
                htmlBody += '<li>State : '+pam.State__c +'</li><li>Placement Date : '+pam.SOL_Placement_Date__c+'</li>';
                htmlBody += '<li>Suit Theory Code Date : '+pam.STNM_Suit_Theory_Code_Date__c+'</li>';
                htmlBody += '<li>Missing Media Type : '+pam.STNM_Missing_Media_Type__c+'</li><li>PSNM Flag : '+pam.PSNM_Flag__c+'</li>';
                htmlBody += '<li>RSNM Flag : '+pam.RSNM_Flag__c+'</li><li>COT Flag : '+pam.COT_Affidavit_Sent__c+'</li></ul>';
                
            }else if(dw != NULL){
                htmlBody += '<tr><td>'+dw.get('consumerAccountIdentifierAgencyId')+'</td><td>'+errorFields+'</td><td>'+description+'</td></tr>';
                htmlBody += '</thead></table><br/><br/>';
                htmlBody += 'Please see details of exception below:<br/>';
                htmlBody += '<ul><li>Account Number : '+dw.get('consumerAccountIdentifierAgencyId')+'</li><li>Firm Id : '+dw.get('firmID')+'</li>';
                htmlBody += '<li>Original Creditor : '+dw.get('originalCreditorName')+'</li><li>State : '+dw.get('state')+'</li>';
                htmlBody += '<li>Placement Date : '+dw.get('placementDate')+'</li><li>Suit Theory Code Date : '+dw.get('suitTheoryDate')+'</li>';
                htmlBody += '<li>Missing Media Type : '+dw.get('proactiveMissingDocTypes')+'</li><li>PSNM Flag : '+dw.get('proactiveFlag')+'</li>';
                htmlBody += '<li>RSNM Flag : '+dw.get('reactiveFlag')+'</li><li>COT Flag : '+dw.get('cotAffidavitSent')+'</li></ul>';
            }
            htmlBody += 'Thanks,<br/><br/>System Administrator</body></html>';
            email.setHtmlBody(htmlBody);
            email.setOrgWideEmailAddressId(orgWideEmail[0].Id);
            //email.toaddresses = new List<String>{'prabhakar.joshi@mcmcg.com'}; // //  
            email.toaddresses = new List<String>{'lcsalesforceadmin@mcmcg.com','LO-Operational@mcmcg.com'};    
                if(!test.isRunningTest())    
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
        }
    }
    
    private static Id getRecordTypeId(Map<String,String> dw,Id DM_PSNM_RecordTypeId,Id DM_RSNM_RecordTypeId){
        Id recordTypeId;
        
        if(dw.get('reactiveFlag') == 'No' || dw.get('reactiveFlag') == 'Unknown' || dw.get('cotAffidavitSent') == 'No' || dw.get('cotAffidavitSent') == 'Unknown'){
            recordTypeId = DM_RSNM_RecordTypeId;
        }else if((dw.get('proactiveFlag') == 'Unknown' || dw.get('proactiveFlag') == 'No')){
            recordTypeId = DM_PSNM_RecordTypeId;
        }
        return recordTypeId;
    }
    
    
    public static void sendCalloutException(String error, String resp,String PROCESS_NAME){
        List<OrgWideEmailAddress> orgWideEmail = DM_Integration_Helper.orgWideEmail;
        
        if(orgWideEmail.size() > 0){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String subjectLine = '';
            if(PROCESS_NAME == 'API 1'){
                subjectLine = 'DM API for (get data from DM) Callout Result';
            }else if(PROCESS_NAME == 'API 2'){
                subjectLine = 'DM API for (send data to DM) Callout Result';
            }
            email.setSubject(subjectLine);
                
            String emailBody = 'This is the DM '+PROCESS_NAME+' API Callout notification email.\n\n Error Reason - '+error+'\n\n Response Body\n\n'+resp;
            
            email.setPlainTextBody(emailBody);
            //email.setHtmlBody(errorMsg);
            //email.toaddresses = new List<String>{'prabhakar.joshi@mcmcg.com'};
            email.toaddresses = new List<String>{'lcsalesforceadmin@mcmcg.com','LO-Operational@mcmcg.com'}; 
            email.setOrgWideEmailAddressId(orgWideEmail[0].Id);
            if(!test.isRunningTest())    
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
        }
    }
    
    public class JSONWrapper{
        public StatusWrapper status;
        public List<DataWrapper> data;
        public String custom;
        public String timestamp;
    }
    
    public class StatusWrapper{
        public Integer code;
        public String message;
        public String uniqueErrorId;
        public String messageCode;
    }
    
    public class DataWrapper{
        public String consumerAccountId;
        public String consumerAccountIdentifierAgencyId;
        public String cotAffidavitRemediation;
        public String cotAffidavitSent;
        public String placementDate;
        public String originalAccountNumber;
        public String reactiveFlag;
        public String proactiveFlag;
        public String missingMedia;
        public String oaldVerificationStatus;
        public String mediaLegalElgibility;
        public String reactiveMissingDocTypes;
        public String oaldModifiedDate;
        public String oaldModifiedBy;
        public String proactiveMissingDocTypes;
        public String lastUpdateDate;
        public String proactiveRemediationStatus;
        public String reactiveRemediationStatus;
        public String originalCreditorName;
        public String sellerName;
        public String firmID;
        public String state;
        public String suitTheoryDate;
    }
}