/**
 * Created by User on 10.04.2018.
 */

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