global class CM_MissingMaterialScheduler implements Schedulable {
    global void execute(SchedulableContext ctx){
        Database.executeBatch(new CM_MissingMaterialFirstEscalationBatch());
        Database.executeBatch(new CM_MissingMaterialSecondEscalationBatch());
        Database.executeBatch(new CM_MissingMaterialNoResponseBatch());
    }
}