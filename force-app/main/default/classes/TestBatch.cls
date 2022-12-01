@isTest(SeeAllData=false)
private class TestBatch{
    @isTest static void BatchTest() {
        //Create 50 Accounts
        List<Account> listAccount = new List<Account>();
        for(Integer i=0; i<50; i++) {
            Account acc1 = new Account(Name = 'Test Account' + i);
            listAccount.add(acc1);
        }
        insert listAccount;

        //Create 1 product
        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        insert pd1;
 
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = System.Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 150,
            IsActive = true
        );
        insert pbe;

        //Create 50 contract with startdate = today 
        date myDate = date.today();
        List<Contract> listContract = new List<Contract>();
        for(Account acc : listAccount) {
            Contract ctt1 = new Contract(AccountId = acc.Id, StartDate = myDate, ContractTerm = 1, Status='Draft');
            listContract.add(ctt1);
        }
        insert listContract;
        
        //Update contract status
        List<Contract> listContractUp = new List<Contract>();
        for(Contract ctt : listContract) {
            Contract ctt2 = new Contract(Id = ctt.Id, Status='Activated');
            listContractUp.add(ctt2);
        }
        update listContractUp;

        //Create 50 order
        Integer size = listAccount.size();
        List<Order> listOrder = new List<Order>();
        for(Integer i=0; i<size;i++ ) {
            Account acc = listAccount.get(i);
            Contract ctt = listContractUp.get(i);
            Order order = new Order(AccountId = acc.Id, ContractId = ctt.Id,Status = 'Draft', EffectiveDate = date.today(), Pricebook2Id = System.Test.getStandardPricebookId(), ShipmentCost__c = 10);
            listOrder.add(order);
        }
        insert listOrder;
		
        //update listOrder;
        
        //Create 2 OrderItem for each 50 order
        List<OrderItem> listOrderItem = new List<OrderItem>();
        for(Order order : listOrder) {
            OrderItem oi1 = new OrderItem (OrderId = order.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
            OrderItem oi2 = new OrderItem (OrderId = order.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
            listOrderItem.add(oi1);
            listOrderItem.add(oi2);
            order.Status = 'Activated';
        }
        insert listOrderItem;
        update listOrder;
        
        //Test batch batchUpdateAccounts
        Test.startTest();
        UpdateAllAccountsBatch MyBatch = new UpdateAllAccountsBatch(); 
        database.executebatch(MyBatch);
        Test.stopTest();


        //Test Chiffre_d_affaire__c is good
        List<Account> updatedAccounts = [
            SELECT Id, Chiffre_d_affaire__c
            FROM Account
            WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Activated')];
        for(Account account :updatedAccounts) {
			System.assertEquals(((10*150)+(20*1000)), account.Chiffre_d_affaire__c);
        }
        
    }
}