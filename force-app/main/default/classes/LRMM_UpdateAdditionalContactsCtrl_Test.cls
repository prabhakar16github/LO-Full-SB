@isTest
public class LRMM_UpdateAdditionalContactsCtrl_Test{
    
    public static testMethod void AppealUnitTest(){
        String organizationId = Test_Utility.CreateOrganization();
        
        Appeal__c appealObj = new Appeal__c();
        appealObj.AP_Organization_Name__c = organizationId;
        appealObj.AP_Account_Number__c = '123456789';
        appealObj.AP_Additional_Contacts__c = 'Test Contact 1<test@test.com>;Test Contact 2<test@test.com>';
        appealObj.OwnerId = UserInfo.getUserId();
        appealObj.AP_Pro_Se__c = true;
        insert appealObj;
        
        List<Contact> contactList = new List<Contact>();
        for(Integer i = 0; i < 10; i++){
            contactList.add(new Contact(FirstName='Test',LastName='Contact ' + i,Email='test@test.com',Inactive_Contact__c=false,AccountId=organizationId));
        }
        insert contactList;
        
        ApexPages.currentPage().getParameters().put('id',appealObj.id);
        LRMM_UpdateAdditionalContactsCtrl updateAddConObj = new LRMM_UpdateAdditionalContactsCtrl();
        updateAddConObj.isAddition = true;
        updateAddConObj.availableFieldsList.addAll(new List<String>{'Test Contact 5<test@test.com>','Test Contact 4<test@test.com>'});
        updateAddConObj.addRemoveEmails();
        updateAddConObj.isAddition = false;
        updateAddConObj.selectedFieldsList.addAll(new List<String>{'Test Contact 5<test@test.com>','Test Contact 4<test@test.com>'});
        updateAddConObj.addRemoveEmails();
        
        updateAddConObj.saveDetails();
    }
    
    public static testMethod void TrialWitnessUnitTest(){
        String organizationId = Test_Utility.CreateOrganization();
        
        Trial_Witness_Request__c twObj = new Trial_Witness_Request__c();
        twObj.OrganizationName__c = organizationId;
        twObj.Account_Number__c = '123456789';
        twObj.Additional_Contacts__c = 'Test Contact 1<test@test.com>;Test Contact 2<test@test.com>';
        twObj.OwnerId = UserInfo.getUserId();
        twObj.Pro_Se__c = true;
        insert twObj;
        
        List<Contact> contactList = new List<Contact>();
        for(Integer i = 0; i < 10; i++){
            contactList.add(new Contact(FirstName='Test',LastName='Contact ' + i,Email='test@test.com',Inactive_Contact__c=false,AccountId=organizationId));
        }
        insert contactList;
        
        ApexPages.currentPage().getParameters().put('id',twObj.id);
        LRMM_UpdateAdditionalContactsCtrl updateAddConObj = new LRMM_UpdateAdditionalContactsCtrl();
        updateAddConObj.isAddition = true;
        updateAddConObj.availableFieldsList.addAll(new List<String>{'Test Contact 5<test@test.com>','Test Contact 4<test@test.com>'});
        updateAddConObj.addRemoveEmails();
        updateAddConObj.isAddition = false;
        updateAddConObj.selectedFieldsList.addAll(new List<String>{'Test Contact 5<test@test.com>','Test Contact 4<test@test.com>'});
        updateAddConObj.addRemoveEmails();
        
        updateAddConObj.saveDetails();
    }
}