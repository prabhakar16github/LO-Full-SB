global class SCMDisputeMonthlyScheduler implements Schedulable{
    
    global void execute(SchedulableContext sc){
        // for LO
        SCMDisputeMonthlyBatch scmdLOMonthlyJobObj = new SCMDisputeMonthlyBatch();
        Database.executeBatch(scmdLOMonthlyJobObj, 5);
        
        //for ACF
        SCM_ACF_DisputeMonthlyBatch scmdACFMonthlyJobObj = new SCM_ACF_DisputeMonthlyBatch();		
        Database.executeBatch(scmdACFMonthlyJobObj, 5);
        
    }    
}