/**
 * Created by User on 18.03.2018.
 */

public with sharing class QueryBuilder {

    private String fromSobject;
    private Set<String> fieldTokens;
    private ConditionsManager conditionsManager;
    private PostQueryFilter postQueryFilter;
    private Integer queryLimit;

    private List<SObject> result;
    private List<Order> sortingOrder;

    public QueryBuilder() {
        this.fieldTokens = new Set<String>();
        this.sortingOrder = new List<Order>();
        this.conditionsManager = new ConditionsManager(this);
        this.postQueryFilter = new PostQueryFilter(this);
        this.queryLimit = 0;
    }

    public QueryBuilder(String fromSobject) {
        this();
        this.fromSobject = fromSobject.trim();
    }

    public QueryBuilder(List<SObject> resultList) {
        this();
        this.result = resultList;
        if (this.result.isEmpty()) {
            return;
        }
        SObject firstSobj = this.result[0];
        this.qbFrom(firstSobj);
        this.qbFields(firstSobj);
    }

    //query formers
    public QueryBuilder qbFrom(SObject sobj) {
        String sobjectName = sobj.getSObjectType().getDescribe().getName();
        return this.qbFrom(sobjectName);
    }

    public QueryBuilder qbFrom(String sobjName) {
        this.fromSobject = sobjName.trim();
        return this;
    }

    public QueryBuilder qbField(String fieldName) {
        if (fieldName.contains(',')) {
            return this.qbFields(fieldName);
        }
        this.fieldTokens.add(fieldName.trim());
        return this;
    }

    public QueryBuilder qbFields(SObject sobj) {
        Map<String, Object> populatedFields = sobj.getPopulatedFieldsAsMap();
        for (String field : populatedFields.keySet()) {
            this.fieldTokens.add(field);
        }
        return this;
    }

    public QueryBuilder qbFields(String fieldNames) {
        List<String> fields  = fieldNames.trim().split(',');
        for (String field : fields) {
            this.fieldTokens.add(field.trim());
        }
        return this;
    }

    public QueryBuilder qbFields(List<String> fieldNames) {
        for (String fieldName : fieldNames) {
            this.fieldTokens.add(fieldName.trim());
        }
        return this;
    }

    public QueryBuilder qbFields(Set<String> fieldNames) {
        for (String fieldName : fieldNames) {
            this.fieldTokens.add(fieldName.trim());
        }
        return this;
    }

    public QueryBuilder qbFields(FieldSet fieldSet) {
        Set<String> fieldNames = new Set<String>();
        for (FieldSetMember fieldSetMember : fieldSet.getFields()) {
            fieldNames.add(fieldSetMember.getFieldPath());
        }
        this.fieldTokens.addAll(fieldNames);
        return this;
    }

    public QueryBuilder qbFields(String objectName, String fieldSetName) {
        Set<String> result = new Set<String>();
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectTypeObj = GlobalDescribeMap.get(objectName);
        List<FieldSetMember> fields = sObjectTypeObj.getDescribe().FieldSets.getMap().get(fieldSetName).getFields();
        for (FieldSetMember fieldSetMember : fields) {
            result.add(fieldSetMember.getFieldPath());
        }
        this.fieldTokens.addAll(result);
        return this;
    }

    public QueryBuilder qbFieldsAll() {
        if (String.isNotEmpty(this.fromSobject)) {
            return this.qbFieldsAll(this.fromSobject);
        }
        System.debug('qbFieldsAll: SObject is not specified');
        return this;
    }

    public QueryBuilder qbFieldsAll(String sobjectName) {
        Set<String> fieldNames = Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap().keySet();
        this.fieldTokens.addAll(fieldNames);
        return this;
    }

    public QueryBuilder qbFieldSet(String fieldSetName) {
        Set<String> result = new Set<String>();
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectTypeObj = GlobalDescribeMap.get(this.fromSobject);
        List<FieldSetMember> fields = sObjectTypeObj.getDescribe().FieldSets.getMap().get(fieldSetName).getFields();
        for (FieldSetMember fieldSetMember : fields) {
            result.add(fieldSetMember.getFieldPath());
        }
        this.fieldTokens.addAll(result);
        return this;
    }

    public ConditionsManager qbCondition() {
        return this.conditionsManager;
    }

    public QueryBuilder setLimit(Integer queryLimit) {
        this.queryLimit = queryLimit;
        return this;
    }

    public QueryBuilder orderAsc(String field) {
        this.sortingOrder.add(new AscOrder(field));
        return this;
    }

    public QueryBuilder orderDesc(String field) {
        this.sortingOrder.add(new DescOrder(field));
        return this;
    }


    //result or pre-result managers
    public QueryBuilder preview() {
        System.debug('\nRESULTING QUERY');
        System.debug(this.toString());
        System.debug('\n');
        return this;
    }

    public QueryBuilder resetQuery() {
        this.result = null;
        return this;
    }

    public override String toString() {
        String result = 'SELECT ';
        String fields = String.join(new List<String>(this.fieldTokens), ', ');
        result += fields + ' ';
        result += 'FROM ' + this.fromSobject + ' ';
        if (this.conditionsManager.hasConditions()) {
            result += 'WHERE ' + this.conditionsManager.builtCondition + ' ';
        }
        if (!this.sortingOrder.isEmpty()) {
            result += 'ORDER BY ';
            List<String> orders = new List<String>();
            for (Order order : this.sortingOrder) {
                orders.add(order.toString());
            }
            result += String.join(orders, ', ') + ' ';
        }
        if (this.queryLimit > 0) {
            result += 'LIMIT ' + queryLimit + ' ';
        }
        return result;
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

    public PostQueryFilter qbFilter() {
    	return null;
    }

    //helper functions
    public QueryBuilder cloneQueryBuilder() {
        return this.cloneQueryBuilder(false);
    }

    public QueryBuilder cloneQueryBuilder(Boolean includeResult) {
        QueryBuilder result = new QueryBuilder();
        result.fromSobject = this.fromSobject;
        result.fieldTokens = new Set<String>(this.fieldTokens);
        result.conditionsManager = this.conditionsManager.cloneConditionsManager();
        result.queryLimit = this.queryLimit;
        if (includeResult && this.result != null && !this.result.isEmpty()) {
            result.result = new List<SObject>(this.result);
        }
        result.sortingOrder = new List<Order>(this.sortingOrder);
        result.postQueryFilter = new PostQueryFilter(result);
        return result;
    }

    //helper classes

    //conditions
    public class ConditionsManager {

        private final String BRACKET_L = '{';
        private final String BRACKET_R = '}';
        public final String QUOTE = '\'';

        public List<Condition> conditions;
        private String conditionOrder;
        private final QueryBuilder queryBuilder;
        private Integer inCollectionNumber;

        private String builtCondition;

        private Map<String, List<String>> inStringLists;
    	private Map<String, List<Decimal>> inDecimalLists;
    	private Map<String, List<Id>> inIdLists;

    	private Map<String, Set<String>> inStringSets;
    	private Map<String, Set<Decimal>> inDecimalSets;
    	private Map<String, Set<Id>> inIdSets;

        public ConditionsManager(QueryBuilder queryBuilder) {
            this.queryBuilder = queryBuilder;
            this.inCollectionNumber = 1;
            this.conditions = new List<Condition>();
        }

        public ConditionsManager cloneConditionsManager() {
            ConditionsManager result = new ConditionsManager(this.queryBuilder);
            result.conditions = new List<Condition>(this.conditions);
            result.conditionOrder = conditionOrder;
            result.builtCondition = builtCondition;
            return result;
        }

        public ConditionsManager add(Condition condition) {
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
                Condition condition = this.conditions[i];
            	this.handleInCondition(condition);

                String conditionNumber = this.bracket('' + (i + 1));
                if(result.contains(conditionNumber)) {
                    result = result.replace(conditionNumber, condition.toString());
                }
            }
            return result;
        }

        public QueryBuilder endCondition() {
            this.builtCondition = this.buildCondition();
            return this.queryBuilder;
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

        private String getNewCollectionPath(String collectionMap, String collectionName) {
        	return 'conditionsManager.' + collectionMap + '.get(' + QUOTE + collectionName + QUOTE + ')';
        }

        private String getNewInCollectionIdentifier(String collectionType) {
        	return collectionType + this.inCollectionNumber++;
        }

        private void handleInCondition(Condition condition) {
    		if (!(condition instanceof InCondition)) {
    			return;
    		}
    		InCondition inCondition = (InCondition) condition;
    		String newCollectionName = '';
    		String newCollectionPath = '';

    		if(inCondition.inStringList != null) {
    			if(this.inStringLists == null) {
					this.inStringLists = new Map<String, List<String>>();
    			}
    			newCollectionName = this.getNewInCollectionIdentifier('List');
    			newCollectionPath = this.getNewCollectionPath('inStringLists', newCollectionName);
				this.inStringLists.put(newCollectionName, inCondition.inStringList);
    		}
    		inCondition.formCondtition(newCollectionPath);
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

        public override String toString() {
            return String.escapeSingleQuotes(this.formedCondition);
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
    }

    public class NullCondition extends FieldCondition {

    	public NullCondition(String fieldName) {
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

    public class ComparisionCondition extends FieldCondition {

    	public ComparisionCondition(String fieldName) {
    		super(fieldName);
    	}

    	 //string
        public Condition eq(String fieldName, String fieldValue) {
            this.formedCondition = this.fieldName + ' = ' + this.quote(fieldValue);
            return this;
        }

        public Condition ne(String fieldName, String fieldValue) {
            this.formedCondition = this.fieldName + ' != ' + this.quote(fieldValue);
            return this;
        }

        //boolean
        public Condition eq(String fieldName, Boolean fieldValue) {
            this.formedCondition = this.fieldName + ' = ' + fieldValue;
            return this;
        }

        public Condition ne(String fieldName, Boolean fieldValue) {
            this.formedCondition = this.fieldName + ' != ' + fieldValue;
            return this;
        }

        //number
        public Condition eq(String fieldName, Decimal fieldValue) {
            this.formedCondition = this.fieldName + ' = ' + fieldValue;
            return this;
        }

        public Condition lt(String fieldName, Decimal fieldValue) {
            this.formedCondition = this.fieldName + ' < ' + fieldValue;
            return this;
        }

        public Condition gt(String fieldName, Decimal fieldValue) {
            this.formedCondition = this.fieldName + ' > ' + fieldValue;
            return this;
        }

        public Condition lte(String fieldName, Decimal fieldValue) {
            this.formedCondition = this.fieldName + ' >= ' + fieldValue;
            return this;
        }

        public Condition gte(String fieldName, Decimal fieldValue) {
            this.formedCondition = this.fieldName + ' <= ' + fieldValue;
            return this;
        }

        public Condition ne(String fieldName, Decimal fieldValue) {
            this.formedCondition = this.fieldName + ' != ' + fieldValue;
            return this;
        }
    }

    public class LikeCondition extends FieldCondition {

		public LikeCondition(String fieldName) {
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

    public class InCondition extends FieldCondition {

 		private List<String> inStringList;
    	private List<Decimal> inDecimalList;
    	private List<Id> inIdList;

    	private Set<String> inStringSet;
    	private Set<Decimal> inDecimalSet;
    	private Set<Id> inIdSet;

    	public InCondition(String fieldName) {
    		super(fieldName);
    	}

    	public Condition inCollection(List<String> inStringList) {
			this.inStringList = inStringList;
			return this;
    	}

    	public Condition inCollection(List<Decimal> inDecimalList) {
			this.inDecimalList = inDecimalList;
			return this;
    	}

    	public Condition inCollection(List<Id> inIdList) {
			this.inIdList = inIdList;
			return this;
    	}

    	public Condition inCollection(Set<String> inStringSet) {
			this.inStringSet = inStringSet;
			return this;
    	}

    	public Condition inCollection(Set<Decimal> inDecimalSet) {
			this.inDecimalSet = inDecimalSet;
			return this;
    	}

    	public Condition inCollection(Set<Id> inIdSet) {
			this.inIdSet = inIdSet;
			return this;
    	}

    	private void formCondtition(String collectionName) {
    		this.formedCondition = this.fieldName + ' IN :' + collectionName;
    	}
    }

    //post query conditions
    public class PostQueryFilter {

        private final QueryBuilder queryBuilder;
        private final List<Filter> filters;
        private List<SObject> filteredRecords;

        public PostQueryFilter(QueryBuilder queryBuilder) {
            this.queryBuilder = queryBuilder;
            this.filters = new List<Filter>();
        }

        public PostQueryFilter addFilter(Filter filter) {
            this.filters.add(filter);
            return this;
        }

        public PostQueryFilter applyFilter(Filter filter) {
            List<SObject> result = this.queryBuilder.toList();
            this.filteredRecords = filter.filterRecords(result);
            return this;
        }

        public PostQueryFilter applyFilters() {
            List<SObject> result = this.queryBuilder.toList();
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

    //orders
    public virtual class Order {

        private final String sortingField;
        private final String sortingOrder;

        public Order(String sortingField, String sortingOrder) {
            this.sortingField = sortingField;
            this.sortingOrder = sortingOrder;
        }

        public override String toString() {
            return sortingField + ' ' + sortingOrder;
        }
    }

    public class AscOrder extends Order {

        public AscOrder(String sortingField) {
            super(sortingField, 'ASC');
        }
    }

    public class DescOrder extends Order {

        public DescOrder(String sortingField) {
            super(sortingField, 'DESC');
        }
    }

    //exceptions
    public class QueryBuilderException extends Exception {}
}