trigger UpdateAccountCA on Order (after update) {
    
	set<Id> setAccountIds = new set<Id>();
    
    for(integer i=0; i< trigger.new.size(); i++){
        Order newOrder= trigger.new[i];
        setAccountIds.add(newOrder.AccountId);
       
        //Account acc = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id =:newOrder.AccountId ];
        //acc.Chiffre_d_affaire__c = acc.Chiffre_d_affaire__c + newOrder.TotalAmount;
       
    }
     
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