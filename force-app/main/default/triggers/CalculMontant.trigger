trigger CalculMontant on Order (before update) {

	//Order newOrder= trigger.new[0];
	//newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;

    for (integer i=0;i<trigger.new.size(); i++){
       Order o= trigger.new[i];
	   o.NetAmount__c= o.TotalAmount - o.ShipmentCost__c; 
    }
    
}