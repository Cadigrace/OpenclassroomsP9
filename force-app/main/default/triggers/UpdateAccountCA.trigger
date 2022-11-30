trigger UpdateAccountCA on Order (after update) {
    
	set<Id> setAccountIds = new set<Id>();
	for (Order od : trigger.new){
        setAccountIds.add(od.AccountId);
    }
    
    OrderService.computeUpdateAccountCA(setAccountIds);
}