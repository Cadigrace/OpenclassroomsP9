public with sharing class OrderService {
    
    public static void checkNetOrderAmount(Order o){
  		o.NetAmount__c = o.TotalAmount - o.ShipmentCost__c; 
	}
    
    public static void computeUpdateAccountCA(Set<Id> accountIds){
       
        
        List<Account> accounts =[SELECT Id, Chiffre_d_affaire__c,(SELECT TotalAmount FROM Orders WHERE Status = 'Activated')FROM Account WHERE Id in :accountIds];
    	for(Account a : accounts) { 
        	a.Chiffre_d_affaire__c = 0;
        	System.debug('bonjour'+a.Orders);
        	for(Order o : a.Orders){
        		a.Chiffre_d_affaire__c = a.Chiffre_d_affaire__c + o.TotalAmount; 
        	}
 
    	}
        update accounts;
        
    }
    
    
}