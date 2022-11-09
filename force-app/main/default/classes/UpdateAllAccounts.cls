global class UpdateAllAccountsBatch implements Database.Batchable<SObject>{
    
    global Database.QueryLocator start(Database.BatchableContext info){ 
        //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
        return Database.getQueryLocator([SELECT Id FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Activated')]);
 
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){
        Set<Id> setAccountIds = (new Map<Id,Account>(scope)).keySet();
        List<Account> accounts =[SELECT Id, Chiffre_d_affaire__c,(SELECT TotalAmount FROM Orders WHERE Status = 'Activated')FROM Account WHERE Id in :setAccountIds];
    	for(Account a : accounts) { 
        	a.Chiffre_d_affaire__c = 0;
        	System.debug('bonjour'+a.Orders);
        	for(Order o : a.Orders){
           		a.Chiffre_d_affaire__c = a.Chiffre_d_affaire__c + o.TotalAmount; 
        	}
  		}
        
    	update accounts;
    }    
     
    global void finish(Database.BatchableContext info){     
        
    } 
 }