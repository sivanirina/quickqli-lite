@isTest
public class QuickQliLiteHelperTest {

    @testSetup
    static void setup() {
        // Get Standard Pricebook Id
        Id standardPbId = Test.getStandardPricebookId();

        // Create Account
        Account acc = new Account(Name='Test Account');
        insert acc;

        // Create Opportunity
        Opportunity opp = new Opportunity(
            Name='Test Opportunity',
            StageName='Prospecting',
            CloseDate=System.today().addDays(30),
            AccountId=acc.Id
        );
        insert opp;

        // Create Product
        Product2 prod = new Product2(Name = 'Test Product', ProductCode = 'TP-001', IsActive = true, Family = 'Test');
        insert prod;

        // Add Standard PricebookEntry (must be active)
        PricebookEntry stdPbe = new PricebookEntry(
            Pricebook2Id = standardPbId,
            Product2Id = prod.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert stdPbe;

        // Create a custom Pricebook
        Pricebook2 pb = new Pricebook2(Name = 'Test Pricebook', IsActive = true);
        insert pb;

        // Add custom PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = pb.Id,
            Product2Id = prod.Id,
            UnitPrice = 100,
            IsActive = true,
            UseStandardPrice = false
        );
        insert pbe;

        // Create a Quote using the custom pricebook and related to the opportunity
        Quote q = new Quote(Name = 'Test Quote', Pricebook2Id = pb.Id, Status = 'Draft', OpportunityId = opp.Id);
        insert q;
    }

    @isTest
    static void testGetQuoteLineItems() {
        Quote q = [SELECT Id, Pricebook2Id FROM Quote LIMIT 1];
        Test.startTest();
        Map<String, Object> result = QuickQliLiteHelper.getQuoteLineItems(q.Id);
        List<Map<String, Object>> items = (List<Map<String, Object>>)result.get('items');
        Test.stopTest();
        System.assert(!items.isEmpty(), 'Should return at least one item');
        System.assertEquals('Test Product', (String)items[0].get('productName'));
    }

    @isTest
    static void testCreateQuoteLineItems() {
        Quote q = [SELECT Id, Pricebook2Id FROM Quote LIMIT 1];
        PricebookEntry pbe = [SELECT Id, Product2Id, UnitPrice FROM PricebookEntry WHERE Pricebook2.IsStandard = false LIMIT 1];

        Map<String, Object> dto = new Map<String, Object>{
            'pricebookEntryId' => pbe.Id,
            'product2Id' => pbe.Product2Id,
            'productName' => 'Test Product',
            'productCode' => 'TP-001',
            'unitPrice' => 100,
            'quantity' => 2,
            'discount' => 0,
            'family' => 'Test',
            'listPrice' => 100,
            'description' => 'Test Desc'
        };

        Test.startTest();
        QuickQliLiteHelper.createQuoteLineItems(q.Id, new List<Map<String, Object>>{ dto });
        Test.stopTest();

        List<QuoteLineItem> qlis = [SELECT Id, Quantity, UnitPrice FROM QuoteLineItem WHERE QuoteId = :q.Id];
        System.assertEquals(1, qlis.size(), 'Should have created one QuoteLineItem');
        System.assertEquals(2, qlis[0].Quantity);
        System.assertEquals(100, qlis[0].UnitPrice);
    }
}