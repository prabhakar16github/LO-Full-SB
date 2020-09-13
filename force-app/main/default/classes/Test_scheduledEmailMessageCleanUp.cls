@isTest
public with sharing class Test_scheduledEmailMessageCleanUp {

 static testMethod void Test_scheduledEmailMessageCleanUp(){
        Test.startTest();
        scheduledEmailMessageCleanUp objScheduler = new scheduledEmailMessageCleanUp();             
        SchedulableContext sc=null;
        objScheduler.execute(sc); 
       
        Test.stopTest();
}

}