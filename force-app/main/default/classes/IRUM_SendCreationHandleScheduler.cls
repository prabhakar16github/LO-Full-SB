global class IRUM_SendCreationHandleScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
		Database.executeBatch( new IRUM_SendCreationCheckBoxBatch() , 10);        
    }
}