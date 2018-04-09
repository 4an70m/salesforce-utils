public with sharing class QueryBuilder {

    private Query query;
    private QueryResult queryResult;

    //constructors
    public QueryBuilder(String fromSObject) {
        this.query = new SimpleQuery(this, fromSObject);
    }

    public QueryBuilder(SObjectType type) {
        this(this, type.getDescribe().getName());
    }

    public QueryBuilder(Type type) {
        this(this, type.getName());
    }

    public QueryBuilder(SObject sobj) {
        this(this, sobj.getSObjectType());
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
    public ConditionsManager qbCondition() {
        return this.query.getConditionsManager();
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

    //helper functions
    public QueryBuilder cloneQueryBuilder() {
        return this.cloneQueryBuilder(false);
    }

    public QueryBuilder cloneQueryBuilder(Boolean includeResult) {
        QueryBuilder result = new QueryBuilder(this.query.fromSobject);
        /*
        result.fromSobject = this.fromSobject;
        result.fieldTokens = new Set<String>(this.fieldTokens);
        result.conditionsManager = this.conditionsManager.cloneConditionsManager();
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

    //query implementations
    private abstract class Query {

        private String fromSObject;
        private QueryFields queryFields;

        private ConditionsManager conditionsManager;
        private OrderManager orderManager;
        private Integer queryLimit;
        
        private PostQueryFilter postQueryFilter;
        private PostQueryUpdater postQueryUpdater;


        //constructors
        private Query() {

        }
        
        public Query(String fromSObject) {
            this.fromSobject = fromSobject.trim();
            this.queryFields = new QueryFields(this.fromSobject);
            
            //ToDO: move to another methods
            //this.conditionsManager = new ConditionsManager(this);
            //this.orderManager = new OrderManager();
            this.queryLimit = -1;
            
            //this.postQueryFilter = new PostQueryFilter(this);
            //this.postQueryUpdater = new PostQueryUpdater(this);
        }

        public Query(SObjectType type) {
            this(type.getDescribe().getName());
        }

        public Query(Type type) {
            this(type.getName());
        }

        public Query(SObject sobj) {
            this(sobj.getSObjectType());
        }

        //fields
        public QueryFields getFields() {
            return this.queryFields;
        }

        //conditions
        public ConditionsManager getConditionsManager() {
            if (this.conditionsManager == null) {
                this.conditionsManager = new ConditionsManager(this.queryBuilder);
            }
            return this.conditionsManager;
        }

        //limits
        public void setLimit(Integer queryLimit) {
            this.queryLimit = queryLimit;
        }

        //orders
        public OrderManager getOrderManager() {
            if (this.orderManager == null) {
                this.orderManager = new OrderManager();
            }
            return this.orderManager;
        }

        //result or pre-result managers
        public void preview() {
            String logRecord = '\n============RESULTING QUERY============\n\n'
                    + this.toString()
                    + '\n\n=======================================\n';
            System.debug(logRecord);
        }

        //results
        public abstract String toCountString();

        //helper functions
        public QueryBuilder cloneQueryBuilder() {
            return this.cloneQueryBuilder(false);
        }

        public QueryBuilder cloneQueryBuilder(Boolean includeResult) {
            QueryBuilder result = new QueryBuilder(this.fromSobject);
            /*result.fromSobject = this.fromSobject;
            result.fieldTokens = new Set<String>(this.fieldTokens);
            result.conditionsManager = this.conditionsManager.cloneConditionsManager();
            result.queryLimit = this.queryLimit;
            if (includeResult && this.result != null && !this.result.isEmpty()) {
                result.result = new List<SObject>(this.result);
            }
            result.sortingOrder = new List<Order>(this.sortingOrder);
            result.postQueryFilter = new PostQueryFilter(result);
            result.postQueryUpdater = new PostQueryUpdater(result);*/
            return result;
        }
    }

    private class SimpleQuery extends Query {

        public SimpleQuery(String fromSObject) {
            super(fromSObject);
        }

        public SimpleQuery(SObjectType type) {
            super(type);
        }

        public SimpleQuery(Type type) {
            super(type);
        }

        public SimpleQuery(SObject sobj) {
            super(sobj);
        }

        public override String toString() {
            String result = 'SELECT ';
            result += this.getFields().toString() + ' ';
            result += 'FROM ' + this.fromSobject + ' ';
            result += this.getConditionsManager().toString() + ' ';
            result += this.getOrderManager().toString() + ' ';
            if (this.queryLimit > 0) {
                result += 'LIMIT ' + queryLimit + ' ';
            }
            return result;
        }

        public override String toCountString() {
            String result = 'SELECT ';
            result += 'count() ';
            result += 'FROM ' + this.fromSobject + ' ';
            result += this.getConditionsManager().toString() + ' ';
            result += this.getOrderManager().toString() + ' ';
            return result;
        }
    }

    //helper classes
    //conditions
    public class ConditionsManager {

        private final String BRACKET_L = '{';
        private final String BRACKET_R = '}';

        public List<Condition> conditions;
        private String conditionOrder;
        private final QueryBuilder queryBuilder;

        public ConditionsManager(QueryBuilder queryBuilder) {
            this.queryBuilder = queryBuilder;
            this.conditions = new List<Condition>();
        }

        public ConditionsManager cloneConditionsManager() {
            ConditionsManager result = new ConditionsManager(this.queryBuilder);
            result.conditions = new List<Condition>(this.conditions);
            result.conditionOrder = conditionOrder;
            return result;
        }

        public ConditionsManager add(Condition condition) {
            this.conditions.add(condition);
            return this;
        }

        public ConditionsManager add(ObjectTypeDependentCondition condition) {
            condition.setRelatedObjectType(this.query.fromSobject);
            this.conditions.add(condition);
            return this;
        }

        public ConditionsManager preview() {
            System.debug('\nCONDITIONS');
            System.debug(this.buildCondition());
            System.debug('\n');
            return this;
        }

        public ConditionsManager setConditionOrder(String conditionOrder) {
            this.conditionOrder = conditionOrder;
            return this;
        }

        public String buildCondition() {
            String result = this.conditionOrder;
            if (String.isEmpty(result)) {
                result = '1';
            }
            result = this.bracketConditions(result);
            for (Integer i = 0; i < this.conditions.size(); i++) {
                Condition condition = conditions[i];
                String conditionNumber = this.bracket('' + (i + 1));
                if(result.contains(conditionNumber)) {
                    result = result.replace(conditionNumber, condition.toString());
                }
            }
            return result;
        }

        public Boolean hasConditions() {
            return !this.conditions.isEmpty();
        }

        private String bracketConditions(String conditions) {
            this.conditions.size();
            for (Integer i = 1; i <= this.conditions.size(); i++) {
                String conditionNumber = '' + i;
                conditions = conditions.replace(conditionNumber, this.bracket(conditionNumber));
            }
            return conditions;
        }

        private String bracket(String condition) {
            return this.BRACKET_L + condition.trim() + this.BRACKET_R;
        }

        public QueryBuilder endCondition() {
            return this.queryBuilder();
        }

        public override String toString() {
            String result = '';
            if (this.hasConditions()) {
                result = 'WHERE ' +  this.buildCondition();
            }
            return result;
        }
    }

    public abstract class Condition {

        public final String QUOTE = '\'';
        public final String BRACKET_L = '(';
        public final String BRACKET_R = ')';
        protected String formedCondition;

        public Condition() {
            this.formedCondition = '';
        }

        protected String quote(String field) {
            return this.QUOTE + field.trim() + this.QUOTE;
        }

        protected String bracket(String field) {
            return BRACKET_L + field.trim() + BRACKET_R;
        }

        public virtual override String toString() {
            return this.formedCondition;
        }
    }

    public class SimpleCondition extends Condition {

        public SimpleCondition() {
            super();
        }

        public SimpleCondition(String condition) {
            super();
            this.formedCondition = condition;
        }
    }

    public abstract class FieldCondition extends Condition {

        protected String fieldName;

        public FieldCondition(String fieldName) {
            super();
            this.fieldName = fieldName;
        }

        public FieldCondition(SObjectField fieldName) {
            super();
            this.fieldName = fieldName.getDescribe().getName();
        }
    }

    public class NullCondition extends FieldCondition {

        public NullCondition(String fieldName) {
            super(fieldName);
        }

        public NullCondition(SObjectField fieldName) {
            super(fieldName);
        }

        //null
        public Condition isNull() {
            this.formedCondition = this.fieldName + ' = NULL';
            return this;
        }

        public Condition notNull() {
            this.formedCondition = this.fieldName + ' != NULL';
            return this;
        }
    }

    public class CompareCondition extends FieldCondition {

        public CompareCondition(String fieldName) {
            super(fieldName);
        }

        public CompareCondition(SObjectField fieldName) {
            super(fieldName);
        }

        //string
        public Condition eq(String fieldValue) {
            this.formedCondition = this.fieldName + ' = ' + this.quote(fieldValue);
            return this;
        }

        public Condition ne(String fieldValue) {
            this.formedCondition = this.fieldName + ' != ' + this.quote(fieldValue);
            return this;
        }

        //boolean
        public Condition eq(Boolean fieldValue) {
            this.formedCondition = this.fieldName + ' = ' + fieldValue;
            return this;
        }

        public Condition ne(Boolean fieldValue) {
            this.formedCondition = this.fieldName + ' != ' + fieldValue;
            return this;
        }

        //number
        public Condition eq(Decimal fieldValue) {
            this.formedCondition = this.fieldName + ' = ' + fieldValue;
            return this;
        }

        public Condition lt(Decimal fieldValue) {
            this.formedCondition = this.fieldName + ' < ' + fieldValue;
            return this;
        }

        public Condition gt(Decimal fieldValue) {
            this.formedCondition = this.fieldName + ' > ' + fieldValue;
            return this;
        }

        public Condition lte(Decimal fieldValue) {
            this.formedCondition = this.fieldName + ' >= ' + fieldValue;
            return this;
        }

        public Condition gte(Decimal fieldValue) {
            this.formedCondition = this.fieldName + ' <= ' + fieldValue;
            return this;
        }

        public Condition ne(Decimal fieldValue) {
            this.formedCondition = this.fieldName + ' != ' + fieldValue;
            return this;
        }
    }

    public class LikeCondition extends FieldCondition {

        public LikeCondition(String fieldName) {
            super(fieldName);
        }

        public LikeCondition(SObjectField fieldName) {
            super(fieldName);
        }

        //like
        public Condition likeAnyBoth(String fieldValue) {
            this.formedCondition = this.fieldName + ' LIKE ' + this.quote('%' + fieldValue + '%');
            return this;
        }

        public Condition likeAnyLeft(String fieldValue) {
            this.formedCondition = this.fieldName + ' LIKE ' + this.quote('%' + fieldValue);
            return this;
        }

        public Condition likeAnyRight(String fieldValue) {
            this.formedCondition = this.fieldName + ' LIKE ' + this.quote(fieldValue + '%');
            return this;
        }
    }

    public class InCondition extends FieldCondition {

        public InCondition(String fieldName) {
            super(fieldName);
        }

        public InCondition(SObjectField fieldName) {
            super(fieldName);
        }

        //in - set
        public Condition inCollection(Set<String> inSet) {
            if (inSet.isEmpty()) {
                this.formedCondition = '';
            }
            this.formedCondition = this.fieldName + ' IN ' + this.buildIn(inSet);
            return this;
        }

        public Condition inCollection(Set<Id> inSet) {
            if (inSet.isEmpty()) {
                this.formedCondition = '';
            }
            this.formedCondition = this.fieldName + ' IN ' + this.buildIn(inSet);
            return this;
        }

        public Condition inCollection(Set<Decimal> inSet) {
            if (inSet.isEmpty()) {
                this.formedCondition = '';
            }
            this.formedCondition = this.fieldName + ' IN ' + this.buildInNoQuote(inSet);
            return this;
        }

        private String buildIn(Set<String> inSet) {
            return this.BRACKET_L
                    + this.QUOTE
                    + String.join(new List<String> (inSet), this.QUOTE + ', ' + this.QUOTE)
                    + this.QUOTE
                    + this.BRACKET_R;
        }

        private String buildIn(Set<Id> inSet) {
            return this.BRACKET_L
                    + this.QUOTE
                    + String.join(new List<Id> (inSet), this.QUOTE + ', ' + this.QUOTE)
                    + this.QUOTE
                    + this.BRACKET_R;
        }

        private String buildInNoQuote(Set<Decimal> inSet) {
            return this.BRACKET_L
                    + String.join(new List<Decimal> (inSet), ', ')
                    + this.BRACKET_R;
        }

        //in - list
        public Condition inCollection(List<String> inList) {
            if (inList.isEmpty()) {
                this.formedCondition = '';
            }
            this.formedCondition = this.fieldName + ' IN ' + this.buildIn(inList);
            return this;
        }

        public Condition inCollection(List<Id> inList) {
            if (inList.isEmpty()) {
                this.formedCondition = '';
            }
            this.formedCondition = this.fieldName + ' IN ' + this.buildIn(inList);
            return this;
        }

        public Condition inCollection(List<Decimal> inList) {
            if (inList.isEmpty()) {
                this.formedCondition = '';
            }
            this.formedCondition = this.fieldName + ' IN ' + this.buildInNoQuote(inList);
            return this;
        }

        private String buildIn(List<String> inList) {
            return this.BRACKET_L
                    + this.QUOTE
                    + String.join(inList, this.QUOTE + ', ' + this.QUOTE)
                    + this.QUOTE
                    + this.BRACKET_R;
        }

        private String buildIn(List<Id> inList) {
            return this.BRACKET_L
                    + this.QUOTE
                    + String.join(inList, this.QUOTE + ', ' + this.QUOTE)
                    + this.QUOTE
                    + this.BRACKET_R;
        }

        private String buildInNoQuote(List<Decimal> inList) {
            return this.BRACKET_L
                    + String.join(inList, ', ')
                    + this.BRACKET_R;
        }
    }

    public class ComplexCondition extends Condition {

        private Condition startCondition;
        private List<String> conditionsOrder;
        private List<Condition> conditions;

        public ComplexCondition() {
            super();
            this.startCondition = null;
            this.conditions = new List<Condition>();
            this.conditionsOrder = new List<String>();
        }

        public ComplexCondition startCondition(Condition condition) {
            this.startCondition = condition;
            return this;
        }

        public ComplexCondition orCondition(Condition condition) {
            if (this.startCondition == null) {
                return this.startCondition(condition);
            }
            this.conditions.add(condition);
            this.conditionsOrder.add('OR');
            return this;
        }

        public ComplexCondition andCondition(Condition condition) {
            if (this.startCondition == null) {
                return this.startCondition(condition);
            }
            this.conditions.add(condition);
            this.conditionsOrder.add('AND');
            return this;
        }

        public ComplexCondition build() {
            if (this.startCondition == null) {
                this.formedCondition = '';
                return this;
            }
            this.formedCondition = BRACKET_L;
            this.formedCondition += this.startCondition.toString() + ' ';
            for (Integer i = 0; i < conditions.size(); i++) {
                String conditionOrder = this.conditionsOrder[i];
                Condition condition = this.conditions[i];
                this.formedCondition += conditionOrder + ' ' + condition.toString() + ' ';
            }
            formedCondition += BRACKET_R;
            return this;
        }
    }

    public abstract class ObjectTypeDependentCondition extends Condition {

        private String objectType;

        public ObjectTypeDependentCondition() {
            super();
        }

        public void setRelatedObjectType(String objectType) {
            this.objectType = objectType;
        }
    }

    public class RecordTypeCondition extends ObjectTypeDependentCondition {

        private String recordTypeName;

        public RecordTypeCondition(String recordTypeName) {
            super();
            this.recordTypeName = recordTypeName;
        }

        private Id getRecordTypeId() {
            return Schema.getGlobalDescribe().get(this.objectType).getDescribe().getRecordTypeInfosByName().get(this.recordTypeName).getRecordTypeId();
        }

        public override String toString() {
            this.formedCondition = 'RecordTypeId = ' + this.quote(this.getRecordTypeId());
            return this.formedCondition;
        }
    }

    //post query conditions
    public class PostQueryFilter {

        private final QueryResult queryResult;
        private final List<Filter> filters;
        private List<SObject> filteredRecords;

        public PostQueryFilter(QueryResult queryResult) {
            this.queryResult = queryResult;
            this.filters = new List<Filter>();
        }

        public PostQueryFilter addFilter(Filter filter) {
            this.filters.add(filter);
            return this;
        }

        public PostQueryFilter applyFilter(Filter filter) {
            List<SObject> result = this.queryResult.toList();
            this.filteredRecords = filter.filterRecords(result);
            return this;
        }

        public PostQueryFilter applyFilters() {
            List<SObject> result = this.queryResult.toList();
            for (Filter filter : this.filters) {
                result = filter.filterRecords(result);
            }
            this.filteredRecords = result;
            return this;
        }

        public PostQueryFilter preview() {
            System.debug('\nPostQueryFilter:');
            System.debug(filteredRecords);
            System.debug('\n');
            return this;
        }

        public List<SObject> toList() {
            return this.filteredRecords;
        }

        public Map<Id, SObject> toMap() {
            return new Map<Id, SObject>(this.filteredRecords);
        }

        public Set<Id> toIdSet() {
            return this.toMap().keySet();
        }

        public Map<Id, SObject> toMap(Map<Id, SObject> mapToFill) {
            for (SObject sobj : this.toList()) {
                Id sobjId = (Id) sobj.get('Id');
                mapToFill.put(sobjId, sobj);
            }
            return mapToFill;
        }
    }

    public abstract class Filter {

        public Filter() {}

        public abstract List<SObject> filterRecords(List<SObject> recordsList);
    }

    //post query updater
    public class PostQueryUpdater {

        public final List<Updater> updaters;
        private final QueryResult queryResult;

        public PostQueryUpdater(QueryResult queryResult) {
            this.queryResult = queryResult;
            this.updaters = new List<Updater>();
        }

        public PostQueryUpdater add(Updater updater) {
            this.updaters.add(updater);
            return this;
        }

        public void performUpdate() {
            List<SObject> toUpdate = this.queryResult.toList();
            for (SObject sobj : toUpdate) {
                for (Updater updater : this.updaters) {
                    updater.applyUpdate(sobj);
                }
            }   
            update toUpdate;
        }
    }

    public abstract class Updater {

        public Updater() {
        }

        protected abstract Updater applyUpdate(SObject sobj);
    }

    public abstract class FieldUpdater extends Updater {

        protected String fieldName;

        public FieldUpdater(String fieldName) {
            super();
            this.fieldName = fieldName;
        }

        public FieldUpdater(SObjectField fieldName) {
            super();
            this.fieldName = fieldName.getDescribe().getName();
        }
    }

    public class FieldUpdate extends FieldUpdater {

        private Object value;

        public FieldUpdate(String fieldName) {
            super(fieldName);
        }

        public FieldUpdate(SObjectField fieldName) {
            super(fieldName);
        }

        public Updater set(Object value) {
            this.value = value;
            return this;
        }

        protected override Updater applyUpdate(SObject sobj) {
            sobj.put(this.fieldName, this.value);
            return this;
        }
    }

    //orders
    public class OrderManager {
        private final List<Order> orders;
        
        public OrderManager() {
            this.orders = new List<Order>();
        }
        
        public Boolean hasOrders() {
            return !this.orders.isEmpty();
        }

        public void orderAsc(String fieldName) {
            this.orders.add(new AscOrder(fieldName));
        }

        public void orderDesc(String fieldName) {
            this.orders.add(new DescOrder(fieldName));
        }

        public void orderAsc(String fieldName, Boolean nullsFirst) {
            this.orders.add(new AscOrder(fieldName, nullsFirst));
        }

        public void orderDesc(String fieldName, Boolean nullsFirst) {
            this.orders.add(new DescOrder(fieldName, nullsFirst));
        }
        
        public override String toString() {
            String result = '';
            if (this.hasOrders()) {
                result += 'ORDER BY ';
                List<String> orders = new List<String>();
                for (Order order : this.orders) {
                    orders.add(order.toString());
                }
                result += String.join(orders, ', ') + ' ';
            }
            return result;
        }
    }
    
    public virtual class Order {

        private final String sortingField;
        private final String sortingOrder;
        private Boolean nullsFirst;

        public Order(String sortingField, String sortingOrder) {
            this.sortingField = sortingField;
            this.sortingOrder = sortingOrder;
            this.nullsFirst = null;
        }

        public Order(String sortingField, String sortingOrder, Boolean nullsFirst) {
            this.sortingField = sortingField;
            this.sortingOrder = sortingOrder;
            this.nullsFirst = nullsFirst;
        }

        public override String toString() {
            String result = this.sortingField + ' ' + this.sortingOrder;
            if (this.nullsFirst != null) {
                result += this.nullsFirst ? 'NULLS FIRST' : 'NULLS LAST';
            }
            return result;
        }
    }

    public class AscOrder extends Order {

        public AscOrder(String sortingField) {
            super(sortingField, 'ASC');
        }

        public AscOrder(String sortingField, Boolean nullsFirst) {
            super(sortingField, 'ASC', nullsFirst);
        }
    }

    public class DescOrder extends Order {

        public DescOrder(String sortingField) {
            super(sortingField, 'DESC');
        }

        public DescOrder(String sortingField, Boolean nullsFirst) {
            super(sortingField, 'DESC', nullsFirst);
        }
    }

    //query fields
    private virtual class QueryFields {

        private final String fromSObject;
        private final Set<String> fieldTokens;

        public QueryFields(String fromSObject) {
            this.fieldTokens = new Set<String>();
            this.fromSObject = fromSObject;
        }

        public void addField(String fieldName) {
            if (fieldName.contains(',')) {
                this.addFields(fieldName);
                return;
            }
            this.fieldTokens.add(fieldName.trim());
        }

        public void addField(SObjectField field) {
            this.fieldTokens.add(field.getDescribe().getName());
        }

        public void addFields(SObject sobj) {
            Map<String, Object> populatedFields = sobj.getPopulatedFieldsAsMap();
            for (String field : populatedFields.keySet()) {
                this.fieldTokens.add(field);
            }
        }

        public void addFields(String fieldNames) {
            List<String> fields  = fieldNames.trim().split(',');
            for (String field : fields) {
                this.fieldTokens.add(field.trim());
            }
        }

        public void addFields(List<String> fieldNames) {
            for (String fieldName : fieldNames) {
                this.fieldTokens.add(fieldName.trim());
            }
        }

        public void addFields(Set<String> fieldNames) {
            for (String fieldName : fieldNames) {
                this.fieldTokens.add(fieldName.trim());
            }
        }

        //all fields
        public void addAllFields() {
            Set<String> fieldNames = Schema.getGlobalDescribe().get(this.fromSobject).getDescribe().fields.getMap().keySet();
            this.fieldTokens.addAll(fieldNames);
        }

        public void addAllCreatableFields() {
            Schema.SObjectType objectType = Schema.getGlobalDescribe().get(this.fromSobject);
            Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe().fields.getMap();

            Set<String> createableFields = new Set<String>{};
            for (Schema.SObjectField field : fieldMap.values()) {
                DescribeFieldResult fieldDescribe = field.getDescribe();
                if (fieldDescribe.isCreateable()) {
                    createableFields.add(fieldDescribe.getName());
                }
            }
            fieldTokens.addAll(createableFields);
        }

        //field sets
        public void addFieldSet(FieldSet fieldSet) {
            Set<String> fieldNames = new Set<String>();
            for (FieldSetMember fieldSetMember : fieldSet.getFields()) {
                fieldNames.add(fieldSetMember.getFieldPath());
            }
            this.fieldTokens.addAll(fieldNames);
        }

        public void addFieldSet(String fieldSetName) {
            Set<String> result = new Set<String>();
            Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
            Schema.SObjectType sObjectTypeObj = GlobalDescribeMap.get(this.fromSobject);
            List<FieldSetMember> fields = sObjectTypeObj.getDescribe().FieldSets.getMap().get(fieldSetName).getFields();
            for (FieldSetMember fieldSetMember : fields) {
                result.add(fieldSetMember.getFieldPath());
            }
            this.fieldTokens.addAll(result);
        }
        
        public override String toString() {
            String fields = '';
            if (this.fieldTokens.isEmpty()) {
                fields = 'Id';
            } else {
                fields = String.join(new List<String>(this.fieldTokens), ', ');
            }
            return fields;
        }
    }

    private class QueryResult {

        private List<SObject> result;
        private PostQueryFilter postQueryFilter;
        private PostQueryUpdater postQueryUpdater;
        private Integer countResult;

        public QueryResult(){ }

        public QueryResult(List<SObject> result){ }

        public Integer toCount() {
            /*if (this.countResult == null) {
                this.countResult = Database.countQuery(this.toCountString());
            }*/
            return this.countResult;
        }

        public List<SObject> toList() {
            if (this.result == null) {
                this.result = Database.query(this.toString());
            }
            return this.result;
        }

        public Map<Id, SObject> toMap() {
            return new Map<Id, SObject>(this.toList());
        }

        public Map<String, List<SObject>> toMap(String fieldName) {
            Map<String, List<SObject>> result = new Map<String, List<SObject>>();
            List<String> fieldPath = fieldName.split('\\.');
            Integer pathSize = fieldPath.size();

            for (SObject sobj : this.toList()) {

                Integer i = 0;
                String key = null;
                SObject tempSobject = sobj;

                for (String pathPart : fieldPath) {
                    i++;
                    if (i == pathSize) {
                        key = (String) tempSobject.get(pathPart);
                        break;
                    }
                    tempSobject = sobj.getSObject(pathPart);
                }

                if (!result.containsKey(key)) {
                    result.put(key, new List<SObject>());
                }
                result.get(key).add(sobj);
            }
            return result;
        }

        public Map<String, List<SObject>> toMap(SObjectField field) {
            return this.toMap(field.getDescribe().getName());
        }

        public Map<Id, SObject> toMap(Map<Id, SObject> mapToFill) {
            for (SObject sobj : this.toList()) {
                Id sobjId = (Id) sobj.get('Id');
                mapToFill.put(sobjId, sobj);
            }
            return mapToFill;
        }

        public SObject toSObject() {
            List<SObject> result = this.toList();
            if (result.isEmpty()) {
                return null;
            }
            return result[0];
        }

        public Set<Id> toIdSet() {
            return this.toMap().keySet();
        }

        public Set<Id> extractIds(String fieldName) {
            Set<Id> result = new Set<Id>();
            for (SObject sobj : this.toList()) {
                String extractedId = (String) sobj.get(fieldName);
                result.add(extractedId);
            }
            return result;
        }

        //post query filter
        public PostQueryFilter qbFilter() {
            return this.postQueryFilter;
        }

        //post query updater
        public PostQueryUpdater qbUpdater() {
            return this.postQueryUpdater;
        }
    }

    //exceptions
    public class QueryBuilderException extends Exception {}
}