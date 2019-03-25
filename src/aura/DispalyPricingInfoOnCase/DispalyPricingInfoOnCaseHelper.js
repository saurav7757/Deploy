({
	
	showToast : function(component, event, type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    },
	
	getAvalProds : function(recId,component) {
		var action = component.get("c.getAvlProducts");
		action.setParams({
            cId : recId
        });
        action.setCallback(this, function(response){
           var name = response.getState();
            if (name === "SUCCESS" && !$A.util.isUndefinedOrNull(response.getReturnValue())) {
                component.set("v.regAvlToSelPrds", response.getReturnValue());
				component.set("v.isAvlDataNull", true);
            }else if($A.util.isUndefinedOrNull(response.getReturnValue())) {
				component.set("v.isAvlDataNull", false);
			}
        });
     $A.enqueueAction(action);
	},
	
	saveSelectedPrds : function(recId,selProducts,component) {
		var action = component.get("c.saveProducts");
		action.setParams({
            cId : recId,
			stPrdLst : selProducts
        });
        action.setCallback(this, function(response){
           var name = response.getState();
            if (name === "SUCCESS" && response.getReturnValue() == true) {
				component.set("v.IsSpinner", false);
                component.set("v.openModal", false);
				this.showToast(component, event, "success", "Product added successfully!!", 'Success');
				//setTimeout(function(){ location.reload(); }, 1000);
				$A.get('e.force:refreshView').fire();
            }else if(name === "ERROR" || response.getReturnValue() == false){
                this.showToast(component, event, "error", "Error!", "Failed to add Product. Please try again or contact your administrator.");
            }
        });
     $A.enqueueAction(action);
	},
	
	callRemovedPrds : function(recId,selProducts,component) {
		var action = component.get("c.removeProduct");
		action.setParams({
            csId : recId,
			prdName : selProducts
        });
        action.setCallback(this, function(response){
           var name = response.getState();
            if (name === "SUCCESS" && response.getReturnValue() == true) {
				this.showToast(component, event, "success", "Product removed successfully!!", 'Success');
				//setTimeout(function(){ location.reload(); }, 1000);
				$A.get('e.force:refreshView').fire();
            }else if(name === "ERROR" || response.getReturnValue() == false){
                this.showToast(component, event, "error", "Error!", "Failed to add Product. Please try again or contact your administrator.");
            }
        });
     $A.enqueueAction(action);
	}
})