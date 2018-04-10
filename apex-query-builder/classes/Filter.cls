/**
 * Created by User on 10.04.2018.
 */

public abstract class Filter {

    public Filter() {}

    public abstract List<SObject> filterRecords(List<SObject> recordsList);
}