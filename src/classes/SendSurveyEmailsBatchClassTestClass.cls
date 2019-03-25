@IsTest
private class SendSurveyEmailsBatchClassTestClass
{
    private static testMethod void sendSurveyEmailsBatchClassTest() 
    {
        
        Contact ct = new Contact();
        ct.LastName = 'Test';
        ct.Product__c = 'Standard';
        ct.Home_Country__c = 'DE';
        ct.Email = 'abc@abc.com';
        ct.language__c = 'en';
        ct.survey_date__c = Date.newInstance(2016, 12, 9);
        insert ct;
        
        Test.startTest();
        SendSurveyEmailsBatchClassTestClass.sendPlainTextEmail(new List<String>{'test@test.com'}, 'Unit Test X', 'Unit Test');
        SendSurveyEmailsBatchClass obj = new SendSurveyEmailsBatchClass();
        DataBase.executeBatch(obj, 10); 
     
        
        Test.stopTest();
        
    }
    
    

    public static void sendPlainTextEmail(List<String> toAddresses, String subject, String body)
    {       
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.settoAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}