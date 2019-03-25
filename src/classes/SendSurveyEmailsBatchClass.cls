/************************************************************
 
 Name: SendSurveyEmailsBatchClass
 Type: Apex Class  
 Purpose: Batch Class to send mails to customers based on survey date and preferred language.
 ***********************************************************/



global class SendSurveyEmailsBatchClass implements Database.Batchable<sObject>,Database.Stateful
{
   
   global Database.QueryLocator start(Database.BatchableContext BC)
   {
        String dateFormatString = 'yyyy-MM-dd';
        Date d = Date.today();
        Datetime dt = Datetime.newInstance(d.year(), d.month(),d.day());
        String dateString = dt.format(dateFormatString);

    //Query all contact records with order by survey date and is less than today and limit the results to 1000 to avoid the daily email limit considering unlimited edition.  
      String query = 'SELECT Id , Name , Email , language__c, survey_date__c from Contact WHERE survey_date__c < '+dateString+' ORDER BY survey_date__c ASC LIMIT 1000';
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<Contact> scope)
   {
        Messaging.Email[] listOfAllMails = new List<Messaging.Email>();
        Messaging.SingleEmailMessage [] singleMailList = new List<Messaging.SingleEmailMessage>();
        Set<Id> allContRecIds = new Set<Id>();
        Id EnglishTemplateId =  [SELECT Id, Name from EmailTemplate WHERE developername = 'Survey_Link_Email_English'].Id; // getting English Template Id. 
        Id GermanTemplateId =  [SELECT Id, Name from EmailTemplate WHERE developername = 'Survey_Link_Email_German'].Id; // getting German Template Id. 
        if(!scope.isEmpty()){
            for(Contact con : scope) {
                if(con.language__c == 'en'){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new String[] {con.Email} ); // Contact's external Email address
                    mail.setTargetObjectId(con.Id);   // Setting Record Id to populate the merge fields in template.
                    mail.setSaveAsActivity(false);
                    mail.setTemplateId(EnglishTemplateId);  // Setting respective template Id.
                    singleMailList.add(mail);   // Adding all single email to list to send all emails in once, so as to avoid the limit of 10 sendEmail() in single transaction
                    
                } else if(con.language__c == 'de'){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new String[] {con.Email} ); 
                    mail.setTargetObjectId(con.Id);
                    mail.setSaveAsActivity(false);
                    mail.setTemplateId(GermanTemplateId);
                    singleMailList.add(mail); 
                    
                }
                allContRecIds.add(con.Id); // Adding all Contacts Id to filter the success/failure records in finish after sendEmail().
            }
        }
        
        // Send mails
        if(!singleMailList.isEmpty()){
            for(Integer i = 0; i < singleMailList.size(); i++ ){
                listOfAllMails.add(singleMailList.get(i));  //Adding each element of SingleEmailMessage array separately.
            }
        
            Messaging.SendEmailResult[] results = Messaging.sendEmail(listOfAllMails); // Send all emails.
        
            //Check for failed emails.
            Set<Id> failedRecords = new Set<Id>();
            List<Contact> successContacts = new List<Contact>();
            Messaging.SendEmailError[] errors = new List<Messaging.SendEmailError>();
            for(Messaging.SendEmailResult currentResult : results) {
                errors = currentResult.getErrors();
                if(errors != null) {
                    for( Messaging.SendEmailError currentError : errors ) {
                        failedRecords.add(currentError.getTargetObjectId()); // get failed records Id.
                    }
                }
                if(!failedRecords.isEmpty() && allContRecIds.containsAll(failedRecords)){
                    allContRecIds.removeAll(failedRecords);     // remove the failed record Id to get list of successful record Ids. 
                }
            }
            if(!allContRecIds.isEmpty()){
                for(Contact ct : [SELECT Id, Name, survey_date__c from Contact WHERE Id IN: allContRecIds]){
                    ct.survey_date__c = null;   // Set survey date to null of records where email was sent out successfully. 
                    successContacts.add(ct);
                }
            }
            if(!successContacts.isEmpty()){
                update successContacts;     //update the sucsess contacts list.
            }
        }
   }

   global void finish(Database.BatchableContext BC)
   {
        
    }
}