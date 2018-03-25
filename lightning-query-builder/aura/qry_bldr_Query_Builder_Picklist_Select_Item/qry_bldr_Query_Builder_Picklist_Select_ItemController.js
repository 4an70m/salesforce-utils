({
	doInit : function(component, event, helper) {
        var sobjectType = component.get("v.sobjectType");
		helper.initFields(component, helper, sobjectType);
	},
    
    sendRemoveEvent : function(component, event, helper) {
        var order = component.get("v.order");
    	helper.sendRemoveEvent(component, order);
	}
})