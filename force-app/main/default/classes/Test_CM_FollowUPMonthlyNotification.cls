@isTest
private class Test_CM_FollowUPMonthlyNotification{

    static testMethod void myUnitTestCM_FollowUPMonthlyNotification() {
    	
		Test.startTest();
		
		ProfileName__c profileName = new ProfileName__c();
		profileName.ProfileLabel__c = 'CC - CIS & TW';
		profileName.Name = 'TW_CISProfileName';
		
		insert profileName;
		
		ProfileName__c profileName1 = new ProfileName__c();
		profileName1.ProfileLabel__c = 'CC - User Access';
		profileName1.Name = 'CI_ProfileName';
		
		insert profileName1; 
		
		    	
        Account a = new Account();
        a.Name = 'TestAcc';
        a.Firm_ID__c = 'Test';
        a.Firm_Status_IN__c = 'Active';
        insert a;
        
        String currentMonth;

        // For 12 Month
        if(System.Today().month() != 1){
	        currentMonth=String.valueOf(System.Today().month()-1);  
        }
        else{
	        currentMonth='12';
        }
    	
    	String currentYear;
    
        if(currentMonth!='12'){
	        currentYear=String.valueOf(System.Today().Year());
        }else{
	        currentYear=String.valueOf(System.Today().Year()-1);    
        }
        
        Contact conObj = new Contact(firstName = 'Contact Name', LastName = 'LastName', AccountId = a.Id);
        insert conObj;
        
        
        Id recordTypeId = Schema.SObjectType.Call_Monitoring__c.getRecordTypeInfosByName().get('Call Monitoring Log').getRecordTypeId();
		Call_Monitoring__c callMontring1 = new Call_Monitoring__c();
        callMontring1.RecordTypeID = recordTypeId;
        callMontring1.Attachments__c = false;
        callMontring1.Organization_Name_CM__c = a.id;     
        callMontring1.Most_Recent_Attachment_Date__c=system.today()-30;
        callMontring1.Reporting_Year_CM__c = currentYear;
        callMontring1.Reporting_Month_CM__c = currentMonth;      
        insert callMontring1;
    	
        
        list<Profile> objProfile = new list<Profile>();
        objProfile = [Select id from Profile where Name IN ('CC - User Access')];
        
        
        User u = new User();
	        u.FirstName = 'UserName'; 
			u.LastName = 'Test'; 
			u.isActive = true;
			u.profileid = objProfile.get(0).Id; 
			u.ContactId = conObj.Id;
			u.Email = 'test@test.com';
			u.Username = 'test@test.com' + System.currentTimeMillis();
			u.CompanyName = 'TEST';
			u.Title = 'title';
			u.Alias = 'alias';
			u.TimeZoneSidKey = 'America/Los_Angeles';
			u.EmailEncodingKey = 'UTF-8';
			u.LanguageLocaleKey = 'en_US';
			u.LocaleSidKey = 'en_US';
        
        System.runAs(u){
        	
        	Database.executeBatch( new CM_FollowUPMonthlyNotification(currentYear,currentMonth,true,true,true),1);
        	
        }
			
        Test.stopTest();
    }
}