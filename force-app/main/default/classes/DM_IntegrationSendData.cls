/***********************************************************************************
 * Class Name  : DM_IntegrationSendData
 * Description : This class is to do the callout with DM server API and send the Data to DM.
 * Created By  : Prabhakar Joshi
 * Created Date: 9-Jan-2020
 * *******************************************************************************/
public class DM_IntegrationSendData {
    
    @future(Callout = true)
    public static void doCallout(Id pamId){
        if(pamId != NULL){
            
            JSONBodyWrapper jsonWrap = getJSONWrapper(pamId); 
            
            System.debug('>>>>jsonWrap>>>>>'+jsonWrap);
            if(jsonWrap != NULL){
                String jsonBodyStr = JSON.serializePretty(jsonWrap, true);
                System.debug('>>>>jsonBodyStr>>>>>'+jsonBodyStr);
                Map<String,DM_API_Credentials__c> apiCreds = DM_API_Credentials__c.getAll();
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                String endPointURL = apiCreds.get('API 2').Endpoint_URL__c;
                req.setEndpoint(endPointURL);
                req.setBody(jsonBodyStr);
                req.setMethod('PUT');
                req.setHeader('Content-Type','application/json');
                req.setHeader('mcm-appid',apiCreds.get('API 2').mcm_appid__c);
                req.setHeader('mcm-userid', apiCreds.get('API 2').mcm_userid__c);
                req.setHeader('correlation-id', apiCreds.get('API 2').correlation_id__c);
                req.setHeader('apikey', apiCreds.get('API 2').API_Key__c);
                req.setHeader('keysecret', apiCreds.get('API 2').Key_Secret__c);
                req.setTimeout(60000);
                System.debug('>>>>>endPointURL>>>>>'+endPointURL);
                HttpResponse res = new HttpResponse();
                
                try{
                    if(Test.isRunningTest()){
                        res.setBody(getFakeResponse());
                    }else{
                        res = http.send(req);    
                    }
                }catch(Exception e){
                    DM_Integration_Helper.sendCalloutException(e.getMessage(), res.getBody(),'API 2');
                }
                
                System.debug('>>>>>>response>>>>>>>>'+res.getBody());
                if(res.getBody() != NULL && String.isNotBlank(res.getBody())){
                    
                    Map<String,Object> jsonResponseMap = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
                    Map<String,String> statusMap = (Map<String,String>)JSON.deserialize(JSON.serialize(jsonResponseMap.get('status')), Map<String,String>.class);
                    
                    if(statusMap.get('message') != 'Success' && Integer.valueOf(statusMap.get('code')) != 200 ){
                        String ACCOUNT_NUMBER = jsonWrap.consumerAccountIdentifierAgencyId;
                        String ERROR_MSG;
                        if(statusMap.get('message').contains('Bad request')){
                            Map<String,String> customErrorMap = (Map<String,String>)JSON.deserialize(JSON.serialize(jsonResponseMap.get('custom')), Map<String,String>.class);
                            ERROR_MSG = 'Bad Request : '+customErrorMap.get('cause');
                        }else{
                            ERROR_MSG = statusMap.get('message');
                        }
                        
                        if(ACCOUNT_NUMBER != NULL && ERROR_MSG != NULL)
                            sendFailureExceptionInMail(ACCOUNT_NUMBER,ERROR_MSG);
                    }
                }
            }
        }
    }
    
    private static JSONBodyWrapper getJSONWrapper(Id pamId){
        JSONBodyWrapper jsonWrap;
        Set<String> No_Unknown_ValueSet = new Set<String>{'No','Unknown'};
            Set<String> Yes_NA_valueSet = new Set<String>{'N/A','Yes','',NULL}; 
                
                for(Process_Adherence_Monitoring__c pam : [SELECT Id,Account_Number__c,Change_RSNM_Flag_to_yes__c,RecordType.Name,
                                                           Change_PSNM_Flag_to_yes__c,Change_COT_Affidavit_Flag_to_yes__c,Status__c,
                                                           RSNM_Flag__c,PSNM_Flag__c,SOL_Observation_Description__c,COT_Affidavit_Sent__c
                                                           FROM Process_Adherence_Monitoring__c
                                                           WHERE Id =:pamId
                                                           LIMIT 1]){
                                                               jsonWrap = new JSONBodyWrapper();
                                                               jsonWrap.consumerAccountIdentifierAgencyId = pam.Account_Number__c;	
                                                               
                                                               if(pam.RecordType.Name == 'DM PSNM' ){
                                                                   if(pam.Status__c != 'Closed' && pam.SOL_Observation_Description__c == NULL 
                                                                      && No_Unknown_ValueSet.contains(pam.PSNM_Flag__c)
                                                                      && Yes_NA_valueSet.contains(pam.RSNM_Flag__c) 
                                                                      && Yes_NA_valueSet.contains(pam.COT_Affidavit_Sent__c)){
                                                                          
                                                                          jsonWrap.proactiveFlag = 'Yes';
                                                                      }else if(pam.Status__c == 'Closed' && pam.SOL_Observation_Description__c != NULL){
                                                                          //jsonWrap.proactiveFlag = 'Yes';
                                                                          jsonWrap.proactiveRemediationStatus = pam.SOL_Observation_Description__c;
                                                                      }
                                                               }else if(pam.RecordType.Name == 'DM RSNM'){
                                                                   if(pam.Status__c != 'Closed' && pam.SOL_Observation_Description__c == NULL){
                                                                       if(No_Unknown_ValueSet.contains(pam.RSNM_Flag__c) && Yes_NA_valueSet.contains(pam.COT_Affidavit_Sent__c)){
                                                                           jsonWrap.reactiveFlag = 'Yes';
                                                                       }else if(Yes_NA_valueSet.contains(pam.RSNM_Flag__c) && No_Unknown_ValueSet.contains(pam.COT_Affidavit_Sent__c)){
                                                                           jsonWrap.cotAffidavitSent = 'Yes';
                                                                       }else if(No_Unknown_ValueSet.contains(pam.RSNM_Flag__c) && No_Unknown_ValueSet.contains(pam.COT_Affidavit_Sent__c)){
                                                                           jsonWrap.cotAffidavitSent = 'Yes';
                                                                       }
                                                                   }else if(pam.Status__c == 'Closed' && pam.SOL_Observation_Description__c != NULL){
                                                                       if(Yes_NA_valueSet.contains(pam.COT_Affidavit_Sent__c)){
                                                                           jsonWrap.reactiveRemediationStatus = pam.SOL_Observation_Description__c;
                                                                       }else if(Yes_NA_valueSet.contains(pam.RSNM_Flag__c) && No_Unknown_ValueSet.contains(pam.COT_Affidavit_Sent__c)){
                                                                           jsonWrap.cotAffidavitRemediation = pam.SOL_Observation_Description__c;
                                                                       }else if(No_Unknown_ValueSet.contains(pam.RSNM_Flag__c) && No_Unknown_ValueSet.contains(pam.COT_Affidavit_Sent__c)){
                                                                           jsonWrap.reactiveRemediationStatus = pam.SOL_Observation_Description__c;
                                                                           jsonWrap.cotAffidavitRemediation = pam.SOL_Observation_Description__c;
                                                                       }
                                                                   }
                                                               }
                                                           }
        return jsonWrap;
        
    }
    
    private static void sendFailureExceptionInMail(String ACC_NUMBER,String ERROR_MSG){
        List<OrgWideEmailAddress> orgWideEmail = DM_Integration_Helper.orgWideEmail;
        
        if(orgWideEmail.size() > 0){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Response From DM Server');
            String htmlBody = '<html><body>';
            htmlBody += 'This is the Response from DM Server which is coming after updating the PSNM/RSNM in DM Server.<br/><br/>';
            htmlBody += '<table border="1" cellspacing="0" cellpadding="5"><thead>';
            htmlBody += '<tr><th>Account Number</th><th>Description</th></tr>';
            htmlBody += '<tr><td>'+ACC_NUMBER+'</td><td>'+ERROR_MSG+'</td></tr></thead></table><br/>';
            htmlBody += 'Thanks,<br/><br/>System Administrator</body></html>';
            email.setHtmlBody(htmlBody);
            email.setOrgWideEmailAddressId(orgWideEmail[0].Id);
            //email.toaddresses = new List<String>{'prabhakar.joshi@mcmcg.com'}; // //  
            email.toaddresses = new List<String>{'lcsalesforceadmin@mcmcg.com','LO-Operational@mcmcg.com'};    
                if(!test.isRunningTest())    
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
        }
    }
    
    public class JSONBodyWrapper{
        public String consumerAccountIdentifierAgencyId;
        public String cotAffidavitRemediation;
        public String cotAffidavitSent;
        public String proactiveFlag;
        public String proactiveRemediationStatus;
        public String reactiveFlag;
        public String reactiveRemediationStatus;
    }
    
    
    private static String getFakeResponse(){
        String res = '{"status": {"code": 400,"message": "Bad request","uniqueErrorId": null,"messageCode": "E101"},"data": null,';
        res += '"custom": {"cause": "mcm-appid is empty"},"timestamp": "2020-02-07T07:50:58.053Z"}';
        return res;
    }
}