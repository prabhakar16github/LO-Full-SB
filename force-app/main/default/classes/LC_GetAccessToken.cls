public with sharing class LC_GetAccessToken {
  public static string refreshToken;
  public static CaptureResponse resp;
  public static Access_Token__c AT;
  
  @future(callout = true)
  public static void getAccessToken(){
    AT = new Access_Token__c();
    AT = [Select Id, NAme, Token__c, Refresh_Token__c From Access_Token__c];
    refreshToken = AT.Refresh_Token__c;
    string Access_Token;
    string Refresh_Token;
    
    /* Custom Settings for Client and Secret ID */
        BoxDetails__c myBFclientid = BoxDetails__c.getInstance('client_id');
        String clientid = myBFclientid.BOX_Parent_Folder__c;
        System.debug('Sunny------>>>'+clientid);
  
        BoxDetails__c myBF = BoxDetails__c.getInstance('client_secret');
        String clientSecret = myBF.BOX_Parent_Folder__c;
        System.debug('Sunny------>>>'+clientSecret);
        
        
    resp = new CaptureResponse();
    HTTPRequest req = new HTTPRequest();
    HTTPResponse res = new HTTPResponse();
    req.setMethod('POST');
    req.setEndpoint('https://www.box.com/api/oauth2/token');
    req.setBody('grant_type=refresh_token&refresh_token='+refreshToken+'&client_id='+clientid+'&client_secret='+clientSecret);
    req.setHeader('Content-Type','application/x-www-form-urlencoded');
    req.setTimeout(120000);
    HTTP get_Access_Token = new HTTP();
    res = get_Access_Token.send(req);
    String bodyString = res.getBody();
    system.debug('The body string is'+bodyString);
        resp = (CaptureResponse)JSON.deserialize(bodyString,CaptureResponse.class);
    if(res.getStatus() == 'OK'){
      system.debug('The Response contains'+res.getBody());
      Access_Token = resp.access_token;
      Refresh_Token = resp.refresh_token;
    }
    if(Access_Token != Null && Access_Token != ''){
      system.debug('Hello User!!');
      AT.Token__c = Access_Token;
      AT.Refresh_Token__c = Refresh_Token;
      update AT;
    }
  }

  public class CaptureResponse{
    public string access_token;
    public string expires_in;
    public string refresh_token;
    public string token_type;
    
    public CaptureResponse(){
      access_token = '';
      expires_in = '';
      refresh_token = '';
      token_type = '';
    }
  }
}