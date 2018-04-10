/**
 * Created by User on 10.04.2018.
 */

public class RecordTypeCondition extends ObjectTypeDependentCondition {

    private String recordTypeName;

    public RecordTypeCondition(String recordTypeName) {
        super();
        this.recordTypeName = recordTypeName;
    }

    private Id getRecordTypeId() {
        return Schema.getGlobalDescribe().get(this.objectType).getDescribe().getRecordTypeInfosByName().get(this.recordTypeName).getRecordTypeId();
    }

    public override String toString() {
        this.formedCondition = 'RecordTypeId = ' + this.quote(this.getRecordTypeId());
        return this.formedCondition;
    }
}