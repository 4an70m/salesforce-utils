/**
 * Created by User on 10.04.2018.
 */

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