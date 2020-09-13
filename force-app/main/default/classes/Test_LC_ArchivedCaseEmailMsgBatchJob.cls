/*
##########################################################################################################################################
# Project Name..........: Email messages Clean Up Class
# File..................: Class : "Test_LC_ArchivedCaseEmailMsgBatchJob"
# Version...............: 1.0
# Created by............: Sunny Kumar    
# Created Date..........: 27-april-2015
# Last Modified by......: Sunny Kumar 
# Last Modified Date....: 30-april-2015
# Description...........: This class is a test class to cover code coverage for "LC_ArchivedCaseEmailMsgBatchJob" class. Here, we are doing
#                         Archival then deletion of Email Messages in salesforce.                         
###############################################################################################################################################
*/

@isTest(seealldata=true)
public class Test_LC_ArchivedCaseEmailMsgBatchJob{
    static testMethod void myUnitTest(){   
        
        Date D = System.Today().AddMonths(-18);
        Map<String,Schema.RecordTypeInfo> CaseRecordTypeInfo = Schema.SObjectType.Case.getRecordTypeInfosByName(); 
        id Judgment = CaseRecordTypeInfo.get('Judgment').getRecordTypeId();
        id legalReview = CaseRecordTypeInfo.get('Legal Review').getRecordTypeId();
        
        list<Case> caseList = new list<Case>();
        caseList = [select id, caseNumber,RecordType.Name, CreatedDate, AccountId
        
                                                         
                            From Case where AccountId != null and IsDeleted=False
                            and IsClosed=True and RecordTypeId!=: Judgment 
                            and RecordTypeId!=: legalReview  and LastModifiedDate <=:D limit 2000];
       
        Test.startTest();
        Database.BatchableContext BC;
        LC_ArchivedCaseEmailMessagesBatchJob obj = new LC_ArchivedCaseEmailMessagesBatchJob();
        obj.Start(BC);
        //Id batchprocessId = Database.executeBatch(obj,1);
        obj.execute(BC,caseList);
        //obj.finish(BC);
        Test.stopTest();
     }
}