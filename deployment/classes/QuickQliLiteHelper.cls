public with sharing class QuickQliLiteHelper {

    @AuraEnabled
    public static void createQuoteLineItems(Id quoteId, List<Map<String, Object>> items) {
        System.debug('items: ' + JSON.serialize(items));
        try {
            List<QuoteLineItem> qlis = new List<QuoteLineItem>();
            for (Map<String, Object> dto : items) {
                Id pbeId = (Id) dto.get('pricebookEntryId');
                Id product2Id = (Id) dto.get('product2Id');
                Decimal quantity = dto.containsKey('quantity') ? (Decimal) dto.get('quantity') : 1;
                Decimal unitPrice = (Decimal) dto.get('unitPrice');
                Decimal discount = dto.containsKey('discount') ? (Decimal) dto.get('discount') : 0;

                if (pbeId == null) throw new AuraHandledException('Missing pricebookEntryId');
                if (product2Id == null) throw new AuraHandledException('Missing product2Id');
                if (unitPrice == null) throw new AuraHandledException('Missing unitPrice');
                if (quantity == null || quantity <= 0) throw new AuraHandledException('Invalid quantity');

                qlis.add(new QuoteLineItem(
                    QuoteId = quoteId,
                    Product2Id = product2Id,
                    PricebookEntryId = pbeId,
                    Quantity = quantity,
                    UnitPrice = unitPrice,
                    Discount = discount
                ));
            }
            System.debug('QuoteLineItems to insert: ' + JSON.serialize(qlis));
            System.debug('Count: ' + qlis.size());
            if (qlis.isEmpty()) {
                throw new AuraHandledException('No valid QuoteLineItems to insert.');
            }
            insert qlis;
        } catch (Exception e) {
            throw new AuraHandledException('Failed to create Quote Line Items: ' + e.getMessage());
        }
    }

     @AuraEnabled(cacheable=true)
    public static Map<String, Object> getQuoteLineItems(Id quoteId) {
        Map<String, Object> result = new Map<String, Object>();

        // Fetch the quote with its pricebook
        Quote quote = [SELECT Id, Pricebook2Id FROM Quote WHERE Id = :quoteId LIMIT 1];
        Id assignedPBId = quote.Pricebook2Id;

        result.put('assignedPricebookId', assignedPBId);

        // Return line items only if pricebook is assigned
        List<Map<String, Object>> lineItems = new List<Map<String, Object>>();
        if (assignedPBId != null) {
            List<PricebookEntry> entries = [
                SELECT Id, UnitPrice, Product2Id, Pricebook2Id,
                       Product2.Name, Product2.Family, Product2.ProductCode
                FROM PricebookEntry
                WHERE Pricebook2Id = :assignedPBId AND IsActive = TRUE AND Product2.IsActive = TRUE
                LIMIT 100
            ];

            for (PricebookEntry entry : entries) {
                Map<String, Object> item = new Map<String, Object>();
                item.put('pricebookEntryId', entry.Id);
                item.put('product2Id', entry.Product2Id); // <-- ADD THIS LINE
                item.put('productName', entry.Product2.Name);
                item.put('productCode', entry.Product2.ProductCode);
                item.put('family', entry.Product2.Family);
                item.put('listPrice', entry.UnitPrice);
                item.put('unitPrice', entry.UnitPrice);
                item.put('quantity', 1);
                item.put('discount', 0);
                lineItems.add(item);
            }
        }

        result.put('items', lineItems);

        // Get active price books
        List<Pricebook2> pricebooks = [SELECT Id, Name FROM Pricebook2 WHERE IsActive = TRUE];
        List<Map<String, String>> pricebookOptions = new List<Map<String, String>>();
        for (Pricebook2 pb : pricebooks) {
            pricebookOptions.add(new Map<String, String>{
                'label' => pb.Name,
                'value' => pb.Id
            });
        }

        result.put('pricebookOptions', pricebookOptions);

        return result;
    }

    @AuraEnabled
    public static void assignPricebookToQuote(Id quoteId, Id pricebookId) {
        if (quoteId == null || pricebookId == null) {
            throw new AuraHandledException('Quote ID and Price Book ID must not be null.');
        }

        Quote quote = [SELECT Id, Pricebook2Id FROM Quote WHERE Id = :quoteId LIMIT 1];
        quote.Pricebook2Id = pricebookId;
        update quote;
    }
}

