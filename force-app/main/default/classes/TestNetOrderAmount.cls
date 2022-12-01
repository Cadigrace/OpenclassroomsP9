@isTest(SeeAllData=false)

private class TestNetOrderAmount{
    @isTest static void Test() {
        //Account creation
		Account acc1 = new Account(Name = 'Test Account');
		insert acc1;
        
        //Create 1 product
        Product2 pd1 = new Product2(Name = 'test product', Family = 'test family');
        insert pd1;
 
       //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = System.Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 150,
            IsActive = true);
        
        insert pbe;
        
        //Creation of 10 orders linked to Test Account
        Integer size = 10;
        List<Order> listOrder = new List<Order>();
        for(Integer i=0; i<size;i++ ) {
            
            Order order = new Order(AccountId = acc1.Id,
                                    Status = 'Draft',
                                    EffectiveDate = date.today(),
                                    Pricebook2Id = System.Test.getStandardPricebookId(),
                                   	ShipmentCost__c = 1000);
                                   	
            listOrder.add(order);
        }
        insert listOrder;
        
        //creation of orderItem for each order
        List<OrderItem> listOrderItem = new List<OrderItem>();
        for(Order order : listOrder) {
            OrderItem oi1 = new OrderItem (OrderId = order.Id, PricebookEntryId = pbe.Id, Quantity=1, UnitPrice = 5000);
            listOrderItem.add(oi1);
		}
        insert listOrderItem;
        
        //Test run
        Test.startTest();
        update listOrder;
        Test.stopTest();
        
        //Test if NetAmount is ok
        for (Order o : listOrder){
           
        	Order o2 = [SELECT Id, NetAmount__c,ShipmentCost__c,TotalAmount FROM Order WHERE Id = :o.Id];
        	System.assertEquals(o2.TotalAmount - o2.ShipmentCost__c,o2.NetAmount__c);
        }

    }
}