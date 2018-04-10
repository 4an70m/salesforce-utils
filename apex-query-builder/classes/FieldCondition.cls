/**
 * Created by User on 10.04.2018.
 */

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