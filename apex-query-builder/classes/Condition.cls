/**
 * Created by User on 10.04.2018.
 */

public abstract class Condition {

    public final String QUOTE = '\'';
    public final String BRACKET_L = '(';
    public final String BRACKET_R = ')';
    protected String formedCondition;

    public Condition() {
        this.formedCondition = '';
    }

    protected String quote(String field) {
        return this.QUOTE + field.trim() + this.QUOTE;
    }

    protected String bracket(String field) {
        return BRACKET_L + field.trim() + BRACKET_R;
    }

    public virtual override String toString() {
        return this.formedCondition;
    }
}