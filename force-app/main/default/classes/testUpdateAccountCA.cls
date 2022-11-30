@isTest(SeeAllData=false)

private class TestUpdateAccount{
    @isTest static void Test() {
       Account acc1 = new Account(Name = 'Test Account');
       insert acc1;

       //Create 1 product
        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        insert pd1;
 
       //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = System.Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 150,
            IsActive = true);
        insert pbe;

	  //Create 200 order
        Integer size = 200;
        List<Order> listOrder = new List<Order>();
        for(Integer i=0; i<size;i++ ) {
			Order order = new Order(AccountId = acc1.Id,Status = 'Draft', EffectiveDate = date.today(), Pricebook2Id = System.Test.getStandardPricebookId());
            listOrder.add(order);
        }
        insert listOrder;

       //Create 2 OrderItem for each 200 order
        List<OrderItem> listOrderItem = new List<OrderItem>();
        for(Order order : listOrder) {
            OrderItem oi1 = new OrderItem (OrderId = order.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
            OrderItem oi2 = new OrderItem (OrderId = order.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
            listOrderItem.add(oi1);
            listOrderItem.add(oi2);
            order.Status = 'Activated';
        }
        insert listOrderItem;
        
        //Test batch UpdateAccounts
        Test.startTest();
        update listOrder;
        Test.stopTest();


        //Test Chiffre_d_affaire__c is good
	    acc1 = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acc1.Id];
        System.assertEquals(((10*150)+(20*1000))*200, acc1.Chiffre_d_affaire__c);
 
    }
}gggit 