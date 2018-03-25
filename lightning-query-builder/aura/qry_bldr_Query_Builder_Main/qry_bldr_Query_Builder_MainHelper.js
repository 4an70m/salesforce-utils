({
    createQueryConditions : function(component, helper, queryConditionsInstances) {
        $A.createComponents(
            queryConditionsInstances,
            function(newComponents, status, errorMessage){
                if (status === "SUCCESS") {
                    helper.addNewConditions(component, newComponents);
                    helper.addNewOrderConditions(component, newComponents);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
            }
        );
    },
    
    addNewConditions : function(component, newComponents) {
        var queryConditionItems = component.get("v.queryConditionItems");
        queryConditionItems = queryConditionItems.concat(newComponents);
        component.set("v.queryConditionItems", queryConditionItems);
	},
    
    addNewOrderConditions : function(component, newComponents) {
        var conditionBuilderOrder = component.get("v.conditionBuilderOrder");
        for (var i = 0; i < newComponents.length; i++) {   
            var newComponentOrder = newComponents[i].get("v.order");
            if (conditionBuilderOrder.length === 0) {
                conditionBuilderOrder += newComponentOrder;
            } else {
                conditionBuilderOrder += " AND " + newComponentOrder;
            }
        }
        component.set("v.conditionBuilderOrder", conditionBuilderOrder);
	},
    
    removeItemByOrder : function(component, order) {
        var queryConditionItems = component.get("v.queryConditionItems");
        queryConditionItems = queryConditionItems.filter(function(item) {
            return item.get("v.order") !== order;
        });
        component.set("v.queryConditionItems", queryConditionItems);
    },
    
    buildQuery : function(component, conditionBuilderOrder, conditionItems) {
        for (var i = 1; i < conditionItems.length + 1; i++) {
            var conditionItem = conditionItems.find(function(element, index, array){
                return element.get("v.order") == i;
            });
            var action = conditionItem.get("v.action");
            var field = conditionItem.get("v.field");
            var compareValue = conditionItem.get("v.compareValue");
            if (action == '' || field == '') {
                continue;
            }
            conditionItem = action.replace("{field}", field).replace("{value}", "'" + compareValue + "'");
            conditionBuilderOrder = conditionBuilderOrder.replace('' + i, conditionItem);
        }
        console.log(conditionBuilderOrder);
    }
})