/************************************************************
 
 Name: SendSurveyEmailsBatchClassScheduler 
 Type: Apex Class  
 Purpose: Scheduler Class to schedule the SendSurveyEmailsBatchClass as per frequency.
 ***********************************************************/

global  class SendSurveyEmailsBatchClassScheduler implements Schedulable {
   global void execute(SchedulableContext BCWHI) {
      SendSurveyEmailsBatchClass WHI= new SendSurveyEmailsBatchClass();
      database.executeBatch(WHI,50);
   }
}