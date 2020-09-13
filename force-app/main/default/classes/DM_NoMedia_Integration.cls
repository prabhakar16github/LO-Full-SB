/***********************************************************************************
 * Class Name  : DM_NoMedia_Integration
 * Description : This class is to do the callout with DM server API.
 * Created By  : Prabhakar Joshi
 * Created Date: 22-Nov-2019
 * *******************************************************************************/
public class DM_NoMedia_Integration {
    
    /********************************** Method to Get the JSON Data From DM Server *************************************/
    @future(Callout = true)
    public static void getData(String fromDate){
        DM_NoMedia_Integration_Helper handler = new DM_NoMedia_Integration_Helper();
        Map<String,DM_API_Credentials__c> apiCreds = DM_API_Credentials__c.getAll();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String endPointURL = apiCreds.get('Get Data For No Media').Endpoint_URL__c;
        
        if(fromDate != NULL && String.isNotBlank(fromDate)){
            endPointURL +='?fromDate='+fromDate;
        }
        req.setEndpoint(endPointURL);
        req.setMethod('GET');
        req.setHeader('Content-Type','application/json');
        req.setHeader('mcm-appid',apiCreds.get('Get Data For No Media').mcm_appid__c);
        req.setHeader('mcm-userid', apiCreds.get('Get Data For No Media').mcm_userid__c);
        req.setHeader('correlation-id', apiCreds.get('Get Data For No Media').correlation_id__c);
        req.setHeader('apikey', apiCreds.get('Get Data For No Media').API_Key__c);
        req.setHeader('keysecret', apiCreds.get('Get Data For No Media').Key_Secret__c);
        req.setTimeout(60000);
        
        HttpResponse res = new HttpResponse();
        try{
            if(Test.isRunningTest()){
                res.setBody(handler.getFakeResponseForGetData());
            }else{
                res = http.send(req);
            }
            
            //res.setBody(getFakeResponse2());
            System.debug('>>>>>>>>body>>'+res.getBody());
            if(res.getBody() != NULL && String.isNotBlank(res.getBody())){
                
                handler.processJSONData(res.getBody());
            }
        }catch(Exception e){
            handler.sendCalloutException(e.getMessage(), res.getBody(),'Get Data For No Media');
        }
    }
    
    /***************************************** End Method *********************************************/
    
    /********************************** Method to Send JSON data to DM Server ******************************/
    @future(Callout = true)
    public static void sendDataToDM(Id pamId){
        if(pamId != NULL){
            DM_NoMedia_Integration_Helper handler = new DM_NoMedia_Integration_Helper();
            DM_NoMedia_Integration_Helper.JSONResponseWrapper jsonWrap = handler.getJSONWrapper(pamId); 
            
            System.debug('>>>>jsonWrap>>>>>'+jsonWrap);
            if(jsonWrap != NULL){
                String jsonBodyStr = JSON.serializePretty(jsonWrap, true);
                System.debug('>>>>jsonBodyStr>>>>>'+jsonBodyStr);
                Map<String,DM_API_Credentials__c> apiCreds = DM_API_Credentials__c.getAll();
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                String endPointURL = apiCreds.get('Send Data For No Media').Endpoint_URL__c;
                req.setEndpoint(endPointURL);
                req.setBody(jsonBodyStr);
                req.setMethod('PUT');
                req.setHeader('Content-Type','application/json');
                req.setHeader('mcm-appid',apiCreds.get('Send Data For No Media').mcm_appid__c);
                req.setHeader('mcm-userid', apiCreds.get('Send Data For No Media').mcm_userid__c);
                req.setHeader('correlation-id', apiCreds.get('Send Data For No Media').correlation_id__c);
                req.setHeader('apikey', apiCreds.get('Send Data For No Media').API_Key__c);
                req.setHeader('keysecret', apiCreds.get('Send Data For No Media').Key_Secret__c);
                req.setTimeout(60000);
                System.debug('>>>>>endPointURL>>>>>'+endPointURL);
                HttpResponse res = new HttpResponse();
                
                try{
                    if(Test.isRunningTest()){
                        res.setBody(handler.getFakeResponseForSendData());
                    }else{
                        res = http.send(req);    
                    }
                }catch(Exception e){
                    handler.sendCalloutException(e.getMessage(), res.getBody(),'Send Data For No Media');
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
                            handler.sendFailureExceptionInMail(ACCOUNT_NUMBER,ERROR_MSG);
                    }
                }
            }
        }
    }
    
    /****************************************** End Method *********************************************/
}