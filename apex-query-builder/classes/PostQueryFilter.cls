/**
 * Created by User on 10.04.2018.
 */

public class PostQueryFilter {

    private final QueryResult queryResult;
    private final List<Filter> filters;
    private List<SObject> filteredRecords;

    public PostQueryFilter(QueryResult queryResult) {
        this.queryResult = queryResult;
        this.filters = new List<Filter>();
    }

    public PostQueryFilter addFilter(Filter filter) {
        this.filters.add(filter);
        return this;
    }

    public PostQueryFilter applyFilter(Filter filter) {
        List<SObject> result = this.queryResult.toList();
        this.filteredRecords = filter.filterRecords(result);
        return this;
    }

    public PostQueryFilter applyFilters() {
        List<SObject> result = this.queryResult.toList();
        for (Filter filter : this.filters) {
            result = filter.filterRecords(result);
        }
        this.filteredRecords = result;
        return this;
    }

    public PostQueryFilter preview() {
        System.debug('\nPostQueryFilter:');
        System.debug(filteredRecords);
        System.debug('\n');
        return this;
    }

    public List<SObject> toList() {
        return this.filteredRecords;
    }

    public Map<Id, SObject> toMap() {
        return new Map<Id, SObject>(this.filteredRecords);
    }

    public Set<Id> toIdSet() {
        return this.toMap().keySet();
    }

    public Map<Id, SObject> toMap(Map<Id, SObject> mapToFill) {
        for (SObject sobj : this.toList()) {
            Id sobjId = (Id) sobj.get('Id');
            mapToFill.put(sobjId, sobj);
        }
        return mapToFill;
    }
}