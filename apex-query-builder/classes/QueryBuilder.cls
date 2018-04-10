public with sharing class QueryBuilder {

    private Query query;
    private QueryResult queryResult;

    //constructors
    public QueryBuilder(String fromSObject) {
        this.query = new SimpleQuery(fromSObject.trim());
    }

    public QueryBuilder(SObjectType type) {
        this(type.getDescribe().getName());
    }

    public QueryBuilder(Type type) {
        this(type.getName());
    }

    public QueryBuilder(SObject sobj) {
        this(sobj.getSObjectType());
    }

    public QueryBuilder(List<SObject> resultList) {
        this.queryResult = new QueryResult(resultList);
    }

    //fields
    public QueryBuilder qbField(String fieldName) {
        this.query.getFields().addField(fieldName);
        return this;
    }

    public QueryBuilder qbField(SObjectField field) {
        this.query.getFields().addField(field);
        return this;
    }

    public QueryBuilder qbFields(SObject sobj) {
        this.query.getFields().addFields(sobj);
        return this;
    }

    public QueryBuilder qbFields(String fieldNames) {
        this.query.getFields().addFields(fieldNames);
        return this;
    }

    public QueryBuilder qbFields(List<String> fieldNames) {
        this.query.getFields().addFields(fieldNames);
        return this;
    }

    public QueryBuilder qbFields(Set<String> fieldNames) {
        this.query.getFields().addFields(fieldNames);
        return this;
    }

    //all fields
    public QueryBuilder qbFieldsAll() {
        this.query.getFields().addAllFields();
        return this;
    }

    public QueryBuilder qbAllCreatableFields() {
        this.query.getFields().addAllCreatableFields();
        return this;
    }

    //field sets
    public QueryBuilder qbFieldSet(FieldSet fieldSet) {
        this.query.getFields().addFieldSet(fieldSet);
        return this;
    }

    public QueryBuilder qbFieldSet(String fieldSetName) {
        this.query.getFields().addFieldSet(fieldSetName);
        return this;
    }

    //conditions
    public ConditionManager qbCondition() {
        ConditionManager conditionManager = this.query.getConditionManager();
        conditionManager.setReturnPoint(this);
        return conditionManager;
    }

    //limits
    public QueryBuilder setLimit(Integer queryLimit) {
        this.query.setLimit(queryLimit);
        return this;
    }

    //orders
    public QueryBuilder orderAsc(String field) {
        this.query.getOrderManager().orderAsc(field);
        return this;
    }

    public QueryBuilder orderDesc(String field) {
        this.query.getOrderManager().orderDesc(field);
        return this;
    }

    public QueryBuilder orderAscNullsFirst(String field) {
        this.query.getOrderManager().orderAsc(field, true);
        return this;
    }

    public QueryBuilder orderAscNullsLast(String field) {
        this.query.getOrderManager().orderDesc(field, false);
        return this;
    }

    public QueryBuilder orderDescNullsFirst(String field) {
        this.query.getOrderManager().orderAsc(field, true);
        return this;
    }

    public QueryBuilder orderDescNullsLast(String field) {
        this.query.getOrderManager().orderDesc(field, false);
        return this;
    }

    //result or pre-result managers
    public QueryBuilder preview() {
        String logRecord = '\n============RESULTING QUERY============\n\n'
                + this.toString()
                + '\n\n=======================================\n';
        System.debug(logRecord);
        return this;
    }

    //results
    public virtual override String toString() {
        return this.query.toString();
    }

    public String toCountString() {
        return this.query.toCountString();
    }

    public List<SObject> toList() {
        if(this.queryResult == null) {
            this.queryResult = new QueryResult(this.query);
        }
        return this.queryResult.toList();
    }

    //helper functions
    public QueryBuilder cloneQueryBuilder() {
        return this.cloneQueryBuilder(false);
    }

    public QueryBuilder cloneQueryBuilder(Boolean includeResult) {
        QueryBuilder result = new QueryBuilder(this.query.getFromSobject());
        /*
        result.fromSobject = this.fromSobject;
        result.fieldTokens = new Set<String>(this.fieldTokens);
        result.conditionManager = this.conditionManager.cloneConditionManager();
        result.queryLimit = this.queryLimit;
        if (includeResult && this.result != null && !this.result.isEmpty()) {
            result.result = new List<SObject>(this.result);
        }
        result.sortingOrder = new List<Order>(this.sortingOrder);
        result.postQueryFilter = new PostQueryFilter(result);
        result.postQueryUpdater = new PostQueryUpdater(result);
        */
        return result;
    }

    //exceptions
    public class QueryBuilderException extends Exception {}
}