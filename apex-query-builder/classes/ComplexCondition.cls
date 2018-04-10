/**
 * Created by User on 10.04.2018.
 */

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