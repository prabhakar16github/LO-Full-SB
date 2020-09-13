/* To get the access token, use this script:: 
System.schedule('LC Get Box Access Token '+system.now(), '0 31 * * * ?', new ScheduleAccessToken1());*/

global with sharing class ScheduleAccessToken1 implements Schedulable {
  Access_Token__c AT;
  
  global void execute(SchedulableContext ctx) {
    LC_GetAccessToken.getAccessToken();
  }
}