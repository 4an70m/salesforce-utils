/**
 * Created by User on 10.04.2018.
 */

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