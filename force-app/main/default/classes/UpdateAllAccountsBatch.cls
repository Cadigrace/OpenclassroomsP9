global class UpdateAllAccountsBatch implements Database.Batchable<SObject>{
    
    global Database.QueryLocator start(Database.BatchableContext info){ 
        //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
        return Database.getQueryLocator([SELECT Id FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Activated')]);
 
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){
        Set<Id> setAccountIds = (new Map<Id,Account>(scope)).keySet();
        Orderservice.computeUpdateAccountCA(setAccountIds);

    }    
     
    global void finish(Database.BatchableContext info){     
        
    } 
 }