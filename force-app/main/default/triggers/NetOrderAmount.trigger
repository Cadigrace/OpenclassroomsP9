trigger NetOrderAmount on Order (before update) {

	for (Order o : Trigger.new){
		OrderService.checkNetOrderAmount(o);
    } 
    
}