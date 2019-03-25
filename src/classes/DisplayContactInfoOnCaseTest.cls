@IsTest
private class DisplayContactInfoOnCaseTest
{
    private static testMethod void DisplayContactInfoOnCaseRecordTest() 
    {
        
        Contact ct = new Contact();
        ct.LastName = 'Test';
        ct.Product__c = 'Standard';
        ct.Home_Country__c = 'DE';
        insert ct;
        
        Case c = new Case(); //Create new case instance
        c.Status = 'New';
        c.Origin = 'Phone';
        c.ContactId = ct.Id;
        insert c;
        
        Contact ct1 = [SELECT Id,Product__c from Contact where Id =: ct.Id];
        ct1.Product__c = 'Metal';
        update ct1;
        
        Test.StartTest();
        DisplayContactInfoOnCase.getContDetilas (Id.valueOf(c.Id));
        DisplayContactInfoOnCase.getAvlProducts (Id.valueOf(c.Id));
        DisplayContactInfoOnCase.saveProducts(Id.valueOf(c.Id), '["Metal"]');
        DisplayContactInfoOnCase.removeProduct(Id.valueOf(c.Id), '["Metal"]');
        Test.StopTest();
        
    }
}