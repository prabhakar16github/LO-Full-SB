/********************************************************************************************************
 * Class Name       : LRMM_CaseCommentExt
 * Description      : Apex class for 'LRMM_CaseCommentPage' which is using to Post the comment on the 
 * 					  Case and that comment will populate in the Case Comment Section. 
 * Created By       : Prabhakar Joshi
 * Created on       : 19 Sept 2019
 * ******************************************************************************************************/
public class LRMM_CaseCommentExt {
    public Id caseId;
    public Case cs;
    public String commentStr{get;set;}
    public LRMM_CaseCommentExt(ApexPages.StandardController sc){
        caseId = sc.getId();
        cs = (Case)sc.getRecord();
    }
    
    public PageReference commitToDB(){
        if(commentStr != NULL && commentStr != ''){
            CaseComment cc = new CaseComment();
            cc.ParentId = caseId;
            cc.CommentBody = commentStr;
            insert cc;
            
            Id plProfileId = [SELECT Id,Name FROM Profile WHERE Name = 'Paralegal' LIMIT 1].Id;
            List<User> userList = [SELECT Id,Name,ProfileId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            if(userList.size() > 0){
                if(userList[0].ProfileId == plProfileId){
                    cs.Status = 'Comment - Attorney';
                    cs.LRMM_Case_Status__c = 'Comment - Attorney';
                }else{
                    cs.Status = 'Comment - VS';
                    cs.LRMM_Case_Status__c = 'Comment - VS';
                }
            }
            update cs;
            
            return new pageReference('/'+caseId);
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter the comments.'));
            return NULL;
        }
    }
}