@isTest
public class LRMM_CaseCommentExt_Test {
	@isTest
    static void test1(){
        Case cs = new Case();
        cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Operations').getRecordTypeId();
        cs.Status = 'New';
        insert cs;
        
        ApexPages.StandardController sc= new ApexPages.StandardController(cs);
        LRMM_CaseCommentExt obj = new LRMM_CaseCommentExt(sc);
        obj.commentStr = 'Test';
        obj.commitToDB();
        
        obj.commentStr = '';
        obj.commitToDB();
    }
}