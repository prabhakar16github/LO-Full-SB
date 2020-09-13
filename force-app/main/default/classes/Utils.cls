/*
	Utility class for supporting some common functions 
	Created On : 1 May 2018
*/

public class Utils {
	
	public static String getCommunityBaseUrl(){
		
		String url = '';
		
			List<Network> networkList = [SELECT Id, Name, Description, Status, UrlPathPrefix FROM Network WHERE Name = 'LC Partner Access'];
			
			Network networkObj = networkList.size() > 0 ? networkList.get(0) : null;   
 			
 			if(networkObj != null){
 				
 				url = Network.getLoginUrl(networkObj.Id);
 				url = url.remove('/login');
 				
 			} 
 			
		return url;
	}
	
	public static String buildBodyFor(List<Exception> exceptionList){
	
		String error = '';
		
		for(Exception exObj : exceptionList){
		
			error += exObj + '\n';
		}
		
		return error;
	}
	
	public static Messaging.SingleEmailMessage getBatchStatusMail(AsyncApexJob a, String batchName){
		
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	   	String[] toAddresses = new String[] {'lcsalesforceadmin@mcmcg.com'};
	   	mail.setToAddresses(toAddresses);
	   	mail.setSubject('Apex Sharing Recalculation ' + a.Status);
	   	mail.setPlainTextBody('The '+batchName+' Apex Batch job processed ' + a.TotalJobItems +
	   	' batches with '+ a.NumberOfErrors + ' failures. ');
		
		
		return mail;
	}
	
	public static Messaging.SingleEmailMessage getErrorMail(String errorBody, String batchName){
	
		Messaging.SingleEmailMessage errorMail = new Messaging.SingleEmailMessage();
        errorMail.setSubject('Errors occurred during '+batchName+' batch process.');
        String[] errorSendToAddresses = new String[] {'lcsalesforceadmin@mcmcg.com'};
        errorMail.setToAddresses(errorSendToAddresses);
        errorMail.setPlainTextBody(errorBody);
        
        return errorMail;
        
	}
	
	public static Messaging.SingleEmailMessage getExceptionErrorMail(List<Exception> errors){
	
		Messaging.SingleEmailMessage errorMail = new Messaging.SingleEmailMessage();
        errorMail.setSubject('Errors occurred during '+errors+' process.');
        String[] errorSendToAddresses = new String[] {'lcsalesforceadmin@mcmcg.com'};
        errorMail.setToAddresses(errorSendToAddresses);
        errorMail.setPlainTextBody(Utils.buildBodyFor(errors));
        
        return errorMail;
        
	}
    
}