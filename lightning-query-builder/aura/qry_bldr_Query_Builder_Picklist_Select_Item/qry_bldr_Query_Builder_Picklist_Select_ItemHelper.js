({
	initFields : function(component, helper, sobjectType) {
		var action = component.get("c.getFieldsSelectOutput");
        action.setParams({sobjectType: sobjectType});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var parsedFields = JSON.parse(response.getReturnValue());
                component.set('v.fields', parsedFields);
            } else if (state === "ERROR") {
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
	},
    
    sendRemoveEvent : function(component, order) {
        var removeEvent = component.getEvent("removeEvent");
        removeEvent.setParams({"order" : order});
		removeEvent.fire();
    }
})