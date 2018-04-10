/**
 * Created by User on 10.04.2018.
 */

public class SimpleQuery extends Query {

    public SimpleQuery(String fromSObject) {
        super(fromSObject);
    }

    public SimpleQuery(SObjectType type) {
        super(type);
    }

    public SimpleQuery(Type type) {
        super(type);
    }

    public SimpleQuery(SObject sobj) {
        super(sobj);
    }

    public override String toString() {
        String result = 'SELECT ';
        result += this.getFields().toString() + ' ';
        result += 'FROM ' + this.fromSobject + ' ';
        result += this.getConditionManager().toString() + ' ';
        result += this.getOrderManager().toString() + ' ';
        result += this.getLimit();
        return result;
    }

    public override String toCountString() {
        String result = 'SELECT ';
        result += 'count() ';
        result += 'FROM ' + this.fromSobject + ' ';
        result += this.getConditionManager().toString() + ' ';
        result += this.getOrderManager().toString() + ' ';
        return result;
    }
}
