/**
* Created by User on 10.04.2018.
*/

public class ChangeFieldUpdater extends FieldUpdater {

    private Object value;

    public ChangeFieldUpdater(String fieldName) {
        super(fieldName);
    }

    public ChangeFieldUpdater(SObjectField fieldName) {
        super(fieldName);
    }

    public Updater set(Object value) {
        this.value = value;
        return this;
    }

    public override Updater applyUpdate(SObject sobj) {
        sobj.put(this.fieldName, this.value);
        return this;
    }
}
