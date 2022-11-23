global class AccountBatchSchedule implements Schedulable{
    global void execute(SchedulableContext sc) {
        //invoke the batch class
        Database.executeBatch(new UpdateAllAccountsBatch());
    }
}