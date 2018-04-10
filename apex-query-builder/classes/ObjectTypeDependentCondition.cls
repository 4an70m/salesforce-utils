/**
 * Created by User on 10.04.2018.
 */

public abstract class ObjectTypeDependentCondition extends Condition {

    protected String objectType;

    public ObjectTypeDependentCondition() {
        super();
    }

    public void setRelatedObjectType(String objectType) {
        this.objectType = objectType;
    }
}