({
   doInit : function(component, event, helper) {
        var action = component.get("c.getContDetilas");
		action.setParams({
            caseId : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var name = response.getState();
            if (name === "SUCCESS" && !$A.util.isUndefinedOrNull(response.getReturnValue())) {
                component.set("v.reg", response.getReturnValue());
				component.set("v.isDataNull", true);
            } else if($A.util.isUndefinedOrNull(response.getReturnValue())) {
				component.set("v.isDataNull", false);
			}
        });
     $A.enqueueAction(action);
    },
	
	
	openModel : function(component, event, helper){
		component.set("v.openModal", true);
		helper.getAvalProds(component.get("v.recordId"), component);
	},
	
	closeModelPopupSave  : function(component, event, helper){
		component.set("v.openModal", false);
	   
	},
	
	handleSelectAllProductsRemove: function(component, event, helper) {
        var getID = component.get("v.reg");
        var checkvalue = component.find("selectAllRem").get("v.value");        
        var checkContact = component.find("checkRemContact"); 
        if(checkvalue == true && !$A.util.isUndefinedOrNull(checkContact)){
            for(var i=0; i<checkContact.length; i++){
                checkContact[i].set("v.value",true);
            }
        }
        else if(!$A.util.isUndefinedOrNull(checkContact)){ 
            for(var i=0; i<checkContact.length; i++){
                checkContact[i].set("v.value",false);
            }
        }
    },
	
	openModelForRemovePrds : function(component, event, helper){
	   var selectedProducts = [];
        var checkvalue = component.find("checkRemContact");
         
        if(!Array.isArray(checkvalue) && !$A.util.isUndefinedOrNull(checkvalue)){
            if (checkvalue.get("v.value") == true) {
                selectedProducts.push(checkvalue.get("v.text"));
            }
        }else if(!$A.util.isUndefinedOrNull(checkvalue)){
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    selectedProducts.push(checkvalue[i].get("v.text"));
                }
            }
        }
		component.find("selectAllRem").set("v.errors", null);
		//component.set("v.IsSpinner", true);
        console.log('selectedProducts-' + selectedProducts);
		console.log('selectedProducts=-' + $A.util.isEmpty(selectedProducts));
		if(!$A.util.isEmpty(selectedProducts)){
			helper.callRemovedPrds(component.get("v.recordId"), JSON.stringify(selectedProducts), component);
		} else if($A.util.isEmpty(selectedProducts) && component.get("v.isDataNull") == true){
			component.find("selectAllRem").set("v.errors", [{message: 'Please Select Products to remove.'}]);
			return;
		}
	},
	
	handleSelectAllProducts: function(component, event, helper) {
        var getID = component.get("v.regAvlToSelPrds");
        var checkvalue = component.find("selectAll").get("v.value");        
        var checkContact = component.find("checkContact"); 
        if(checkvalue == true && !$A.util.isUndefinedOrNull(checkvalue)){
            for(var i=0; i<checkContact.length; i++){
                checkContact[i].set("v.value",true);
            }
        }
        else if(!$A.util.isUndefinedOrNull(checkContact)){ 
            for(var i=0; i<checkContact.length; i++){
                checkContact[i].set("v.value",false);
            }
        }
    },
	
	addSelectedPrds : function(component, event, helper){
	   var selectedProducts = [];
        var checkvalue = component.find("checkContact");
         
        if(!Array.isArray(checkvalue)){
            if (checkvalue.get("v.value") == true) {
                selectedProducts.push(checkvalue.get("v.text"));
            }
        }else{
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    selectedProducts.push(checkvalue[i].get("v.text"));
                }
            }
        }
		component.set("v.IsSpinner", true);
        console.log('selectedProducts-' + selectedProducts);
		helper.saveSelectedPrds(component.get("v.recordId"), JSON.stringify(selectedProducts), component);
	}
})