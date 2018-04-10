/**
 * Created by User on 10.04.2018.
 */

public class ConditionManager {

    private final String BRACKET_L = '{';
    private final String BRACKET_R = '}';

    public List<Condition> conditions;
    private String conditionOrder;
    private QueryBuilder queryBuilder;
    private final Query query;

    public ConditionManager(Query query) {
        this.query = query;
        this.conditions = new List<Condition>();
    }

    public ConditionManager cloneConditionManager() {
        ConditionManager result = new ConditionManager(this.query);
        result.conditions = new List<Condition>(this.conditions);
        result.conditionOrder = conditionOrder;
        return result;
    }

    public ConditionManager add(Condition condition) {
        this.conditions.add(condition);
        return this;
    }

    public ConditionManager add(ObjectTypeDependentCondition condition) {
        condition.setRelatedObjectType(this.query.getFromSobject());
        this.conditions.add(condition);
        return this;
    }

    public ConditionManager preview() {
        System.debug('\nCONDITIONS');
        System.debug(this.buildCondition());
        System.debug('\n');
        return this;
    }

    public ConditionManager setConditionOrder(String conditionOrder) {
        this.conditionOrder = conditionOrder;
        return this;
    }

    private  String buildCondition() {
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

    public void setReturnPoint(QueryBuilder queryBuilder) {
        this.queryBuilder = queryBuilder;
    }

    private Boolean hasConditions() {
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
        return this.queryBuilder;
    }

    public override String toString() {
        String result = '';
        if (this.hasConditions()) {
            result = 'WHERE ' +  this.buildCondition();
        }
        return result;
    }
}