/**
 * Created by User on 10.04.2018.
 */

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