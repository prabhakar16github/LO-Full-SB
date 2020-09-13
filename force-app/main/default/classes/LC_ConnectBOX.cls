public with sharing class LC_ConnectBOX {
    
    public LC_ConnectBOX(){
        
    }
    
    public pageReference Redrect(){ 
    	
    	
    	BoxDetails__c myBFclientid = BoxDetails__c.getInstance('client_id');
        String clientid = myBFclientid.BOX_Parent_Folder__c;
        System.debug('Sunny------>>>'+clientid);   
        if(clientid!=null){
        pageReference PR = new pageReference('https://app.box.com/api/oauth2/authorize?response_type=code&client_id='+clientid+'&state=security_token%10031988@Nik');
        return PR;
       	
       } else{
         pageReference PR1 = new pageReference('https://app.box.com/api/oauth2/authorize?response_type=code&client_id=3wciossk97vvab00mrifkgigqo9f0g0b&state=security_token%10031988@Nik');
         System.debug('Sunny---Else---->>>NULL');
         return PR1;
        }
        
    }
}