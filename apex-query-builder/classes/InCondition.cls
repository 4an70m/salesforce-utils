/**
 * Created by User on 10.04.2018.
 */

public class InCondition extends FieldCondition {

    public InCondition(String fieldName) {
        super(fieldName);
    }

    public InCondition(SObjectField fieldName) {
        super(fieldName);
    }

    //in - set
    public Condition inCollection(Set<String> inSet) {
        if (inSet.isEmpty()) {
            this.formedCondition = '';
        }
        this.formedCondition = this.fieldName + ' IN ' + this.buildIn(inSet);
        return this;
    }

    public Condition inCollection(Set<Id> inSet) {
        if (inSet.isEmpty()) {
            this.formedCondition = '';
        }
        this.formedCondition = this.fieldName + ' IN ' + this.buildIn(inSet);
        return this;
    }

    public Condition inCollection(Set<Decimal> inSet) {
        if (inSet.isEmpty()) {
            this.formedCondition = '';
        }
        this.formedCondition = this.fieldName + ' IN ' + this.buildInNoQuote(inSet);
        return this;
    }

    private String buildIn(Set<String> inSet) {
        return this.BRACKET_L
                + this.QUOTE
                + String.join(new List<String> (inSet), this.QUOTE + ', ' + this.QUOTE)
                + this.QUOTE
                + this.BRACKET_R;
    }

    private String buildIn(Set<Id> inSet) {
        return this.BRACKET_L
                + this.QUOTE
                + String.join(new List<Id> (inSet), this.QUOTE + ', ' + this.QUOTE)
                + this.QUOTE
                + this.BRACKET_R;
    }

    private String buildInNoQuote(Set<Decimal> inSet) {
        return this.BRACKET_L
                + String.join(new List<Decimal> (inSet), ', ')
                + this.BRACKET_R;
    }

    //in - list
    public Condition inCollection(List<String> inList) {
        if (inList.isEmpty()) {
            this.formedCondition = '';
        }
        this.formedCondition = this.fieldName + ' IN ' + this.buildIn(inList);
        return this;
    }

    public Condition inCollection(List<Id> inList) {
        if (inList.isEmpty()) {
            this.formedCondition = '';
        }
        this.formedCondition = this.fieldName + ' IN ' + this.buildIn(inList);
        return this;
    }

    public Condition inCollection(List<Decimal> inList) {
        if (inList.isEmpty()) {
            this.formedCondition = '';
        }
        this.formedCondition = this.fieldName + ' IN ' + this.buildInNoQuote(inList);
        return this;
    }

    private String buildIn(List<String> inList) {
        return this.BRACKET_L
                + this.QUOTE
                + String.join(inList, this.QUOTE + ', ' + this.QUOTE)
                + this.QUOTE
                + this.BRACKET_R;
    }

    private String buildIn(List<Id> inList) {
        return this.BRACKET_L
                + this.QUOTE
                + String.join(inList, this.QUOTE + ', ' + this.QUOTE)
                + this.QUOTE
                + this.BRACKET_R;
    }

    private String buildInNoQuote(List<Decimal> inList) {
        return this.BRACKET_L
                + String.join(inList, ', ')
                + this.BRACKET_R;
    }
}