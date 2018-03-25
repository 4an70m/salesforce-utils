({
	doInit : function(component, event, helper) {
        var defaultNumberOfQueryconditions = component.get("v.defaultNumberOfQueryconditions");
        var sobjectType = component.get("v.sobjectType");
        var queryConditionsInstances = [];
        for (var i = 0; i < defaultNumberOfQueryconditions; i++) {
            var queryConditionsInstance = ["c:qry_bldr_Query_Builder_Picklist_Select_Item", {"order": i+1, "sobjectType" : sobjectType}];
            queryConditionsInstances.push(queryConditionsInstance);
        }
		helper.createQueryConditions(component, helper, queryConditionsInstances);
	},
    
    addQueryCondition : function(component, event, helper) {
        var sobjectType = component.get("v.sobjectType");
        var queryConditionPosition = component.get("v.queryConditionItems").length + 1;
        var queryConditionsInstances = [["c:qry_bldr_Query_Builder_Picklist_Select_Item", {"order": queryConditionPosition, "sobjectType" : sobjectType}]];
		helper.createQueryConditions(component, helper, queryConditionsInstances);
    },
    
    removeItemByOrder : function(component, event, helper) {
    	var order = event.getParam("order");
        helper.removeItemByOrder(component, order);
	},
    
    runQueryBuilder : function(component, event, helper) {
        var conditionItems = component.get("v.queryConditionItems");
        var conditionBuilderOrder = component.get("v.conditionBuilderOrder");
        helper.buildQuery(component, conditionBuilderOrder, conditionItems);
    }
})