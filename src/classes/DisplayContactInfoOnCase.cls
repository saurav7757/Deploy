/************************************************************
 
 Name: DisplayContactInfoOnCase
 Type: Apex Class  
 Purpose: Apex Class  for  lightning component 
          DisplayPricingInfoOnCase.cmp
 ***********************************************************/

// To Get all the Contact Information and pricing of selected Products.
public without sharing class DisplayContactInfoOnCase {

    @AuraEnabled
    public static List<Product_Information__mdt> getContDetilas(String caseId){
        List<String> productName = new List<String>();
        List<Product_Information__mdt> lstOfProductInfo = new List<Product_Information__mdt>();
        String homeCountry;
        Case cs = [Select Id, Contact.product__c,Contact.home_country__c FROM Case WHERE Id =: caseId];
        if(String.isNotEmpty(cs.Contact.product__c)){
            String productName1 = cs.Contact.product__c;
            productName = productName1.split(';');
        }
        homeCountry = cs.Contact.home_country__c;
        List<Product_Information__mdt> prdLst = [SELECT Id,Product__c,ATM_Fee_in_other_currencies__c,Card_Replacement_Cost__c,Cost_per_Calendar_Month__c FROM Product_Information__mdt WHERE Country__c =: homeCountry];
        
        for(Product_Information__mdt pd : prdLst){
            if(productName.contains(pd.Product__c)){
                lstOfProductInfo.add(pd);
            }
        }
        if(!lstOfProductInfo.isEmpty()){
            return lstOfProductInfo;
        } else {
            return null;
        }
    }

    
    // To Get all the Available product Information and pricing of Products.
    @AuraEnabled
    public static List<Product_Information__mdt> getAvlProducts(String cId){
        List<String> productName = new List<String>();
        List<Product_Information__mdt> lstOfProductInfo = new List<Product_Information__mdt>();
        String homeCountry;
        Case cs = [Select Id, Contact.product__c,Contact.home_country__c FROM Case WHERE Id =: cId];
        if(String.isNotEmpty(cs.Contact.product__c)){
            String productName1 = cs.Contact.product__c;
            productName = productName1.split(';');
        }
        homeCountry = cs.Contact.home_country__c;
        List<Product_Information__mdt> prdLst = [SELECT Id,Product__c,ATM_Fee_in_other_currencies__c,Card_Replacement_Cost__c,Cost_per_Calendar_Month__c FROM Product_Information__mdt WHERE Country__c =: homeCountry];
        
        for(Product_Information__mdt pd : prdLst){
            if(!productName.contains(pd.Product__c)){
                lstOfProductInfo.add(pd);
            }
        }
        if(!lstOfProductInfo.isEmpty()){
            return lstOfProductInfo;
        } else {
            return null;
        }
    }
    
    // Save the selected product Information and pricing.
    @AuraEnabled
    public static Boolean saveProducts(String cId, String stPrdLst){
        Database.SaveResult[] srList = new List<Database.SaveResult>();
        try{
            Type idArrType = Type.forName('List<string>');
            List<string> wrapperPrdList = (List<string>) JSON.deserialize(stPrdLst, idArrType);
            Id conId;
            List<Contact> conLst = new List<Contact>();
            Case cs = [Select Id,ContactId, Contact.product__c,Contact.home_country__c FROM Case WHERE Id =: cId];
            String productName1 = cs.Contact.product__c;
            conId = cs.ContactId;
            if(!wrapperPrdList.contains(productName1)){
                wrapperPrdList.add(productName1);
            }
            
            
            for(Contact ct : [SELECT Id,Product__c FROM Contact WHERE Id =:conId]){
                ct.Product__c = String.join(wrapperPrdList, ';');
                conLst.add(ct);
            }
            srList = Database.update(conLst, false);
        }catch (Exception ex){
            
        }
        if(srList[0].isSuccess()) {
            return true;
        } else {
            return false;
        }
    }
    
    // Remove the selected product Information and pricing.
    @AuraEnabled
    public static boolean removeProduct(String csId,String prdName){
        Database.SaveResult[] srList = new List<Database.SaveResult>();
        try{
            Type idArrType = Type.forName('List<string>');
            List<string> wrapperPrdList = (List<string>) JSON.deserialize(prdName, idArrType);
            List<String> productName = new List<String>();
            Set<String> productNameToRemove = new Set<String>();
            Set<String> productNameToRemoveFromInput = new Set<String>();
            List<Contact> conLst = new List<Contact>();
            Id conId;
            productNameToRemoveFromInput.addAll(wrapperPrdList);
            Case cs = [Select Id,ContactId,Contact.product__c FROM Case WHERE Id =: csId];
            conId = cs.ContactId;
            String productName1 = cs.Contact.product__c;
            productName = productName1.split(';');
            productNameToRemove.addAll(productName);
            productName.clear();
            if(productNameToRemove.containsAll(productNameToRemoveFromInput )){
                productNameToRemove.removeAll(productNameToRemoveFromInput);
                productName.addAll(productNameToRemove);
            }
            
            for(Contact ct : [SELECT Id,Product__c FROM Contact WHERE Id =:conId]){
                ct.Product__c = String.join(productName, ';');
                conLst.add(ct);
            }
            srList = Database.update(conLst, false);
        }catch (Exception ex){
            
        }
        if(srList[0].isSuccess()) {
            return true;
        } else {
            return false;
        }
    }
    
}