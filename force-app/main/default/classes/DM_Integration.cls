/***********************************************************************************
 * Class Name  : DM_Integration
 * Description : This class is to do the callout with DM server API.
 * Created By  : Prabhakar Joshi
 * Created Date: 22-Nov-2019
 * *******************************************************************************/
public class DM_Integration {
    @future(Callout = true)
    public static void doCallOut(String fromDate){
        Map<String,DM_API_Credentials__c> apiCreds = DM_API_Credentials__c.getAll();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        String endPointURL = apiCreds.get('API 1').Endpoint_URL__c;
        
        if(fromDate != NULL && String.isNotBlank(fromDate)){
            endPointURL +='?fromDate='+fromDate;
        }
        req.setEndpoint(endPointURL);
        req.setMethod('GET');
        req.setHeader('Content-Type','application/json');
        req.setHeader('mcm-appid',apiCreds.get('API 1').mcm_appid__c);
        req.setHeader('mcm-userid', apiCreds.get('API 1').mcm_userid__c);
        req.setHeader('correlation-id', apiCreds.get('API 1').correlation_id__c);
        req.setHeader('apikey', apiCreds.get('API 1').API_Key__c);
        req.setHeader('keysecret', apiCreds.get('API 1').Key_Secret__c);
        req.setTimeout(60000);
        
        HttpResponse res = new HttpResponse();
        try{
            if(Test.isRunningTest()){
                res.setBody(getFakeResponse());
            }else{
                res = http.send(req);
            }
            
            //res.setBody(getFakeResponse2());
            System.debug('>>>>>>>>body>>'+res.getBody());
            if(res.getBody() != NULL && String.isNotBlank(res.getBody())){
                
                DM_Integration_Helper.processJSONData(res.getBody());
            }
        }catch(Exception e){
            DM_Integration_Helper.sendCalloutException(e.getMessage(), res.getBody(),'API 1');
        }
    }
    
    
    /******************************** Fake Response ***********************************************/
    
    private static String getFakeResponse(){
        
        String res = '{"status": {"code": 200,"message": "Success","uniqueErrorId": null,"messageCode": null},';
        res += '"data": [{"consumerAccountId": 180742,"consumerAccountIdentifierAgencyId": 300182755,"originalAccountNumber": "444796228591409",';
        res += '"reactiveFlag": "N/A","proactiveFlag": "No","missingMedia": "Unknown","oaldVerificationStatus": "No",';
        res += '"mediaLegalElgibility": "Yes","reactiveMissingDocTypes": null,"oaldModifiedDate": "2020-01-10T23:33:34",';
        res += '"oaldModifiedBy": "Tester1","proactiveMissingDocTypes": "(chrgoff OR chrgoffev)","lastUpdateDate": "2020-01-16T10:01:06",';
        res += '"proactiveRemediationStatus": null,"reactiveRemediationStatus": null,"originalCreditorName": null,"sellerName": null,';
        res += '"firmID": "CA137","state": "IL","suitTheoryDate": "2019-12-20T12:00:00","placementDate": "2019-12-20T12:00:00",';
        res += '"cotAffidavitSent": "N/A","cotAffidavitRemediation": "N/A"},{"consumerAccountIdentifierAgencyId": 65543221,';
        res += '"proactiveFlag": "No","suitTheoryDate": "2019-12-20T12:00:00","state": "abc","firmID": "CA137"';
        res += '} ],"custom": null,"timestamp": "2020-01-17T07:38:12.042Z"}';
        return res;
    }
    
    /***********************************************************************************************************/
}