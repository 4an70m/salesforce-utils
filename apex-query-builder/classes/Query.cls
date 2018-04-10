/**
 * Created by User on 10.04.2018.
 */

public abstract class Query {

    protected final String fromSObject;
    private QueryFields queryFields;

    private ConditionManager conditionManager;
    private OrderManager orderManager;
    protected Integer queryLimit;

    //constructors
    public Query(String fromSObject) {
        this.fromSobject = fromSobject.trim();
        this.queryFields = new QueryFields(this);

        //ToDO: move to another methods
        this.conditionManager = new ConditionManager(this);
        this.orderManager = new OrderManager();
        this.queryLimit = -1;
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

    public String getFromSobject() {
        return this.fromSObject;
    }

    //fields
    public QueryFields getFields() {
        return this.queryFields;
    }

    //conditions
    public ConditionManager getConditionManager() {
        if (this.conditionManager == null) {
            this.conditionManager = new ConditionManager(this);
        }
        return this.conditionManager;
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

    //limit
    protected String getLimit() {
        String result = '';
        if (this.queryLimit > 0) {
             result = 'LIMIT ' + this.queryLimit + ' ';
        }
        return result;
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
        result.conditionManager = this.conditionManager.cloneConditionManager();
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