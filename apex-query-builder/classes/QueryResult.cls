/**
 * Created by User on 10.04.2018.
 */

public class QueryResult {

    private Query query;
    private List<SObject> result;
    private PostQueryFilter postQueryFilter;
    private PostQueryUpdater postQueryUpdater;
    private Integer countResult;

    public QueryResult(Query query){
        this.query = query;
    }

    public QueryResult(List<SObject> result){
        this.result = result;
    }

    public Integer toCount() {
        /*if (this.countResult == null) {
            this.countResult = Database.countQuery(this.toCountString());
        }*/
        return this.countResult;
    }

    public List<SObject> toList() {
        if (this.result == null) {
            this.result = Database.query(this.query.toString());
        }
        return this.result;
    }

    public Map<Id, SObject> toMap() {
        return new Map<Id, SObject>(this.toList());
    }

    public Map<String, List<SObject>> toMap(String fieldName) {
        Map<String, List<SObject>> result = new Map<String, List<SObject>>();
        List<String> fieldPath = fieldName.split('\\.');
        Integer pathSize = fieldPath.size();

        for (SObject sobj : this.toList()) {

            Integer i = 0;
            String key = null;
            SObject tempSobject = sobj;

            for (String pathPart : fieldPath) {
                i++;
                if (i == pathSize) {
                    key = (String) tempSobject.get(pathPart);
                    break;
                }
                tempSobject = sobj.getSObject(pathPart);
            }

            if (!result.containsKey(key)) {
                result.put(key, new List<SObject>());
            }
            result.get(key).add(sobj);
        }
        return result;
    }

    public Map<String, List<SObject>> toMap(SObjectField field) {
        return this.toMap(field.getDescribe().getName());
    }

    public Map<Id, SObject> toMap(Map<Id, SObject> mapToFill) {
        for (SObject sobj : this.toList()) {
            Id sobjId = (Id) sobj.get('Id');
            mapToFill.put(sobjId, sobj);
        }
        return mapToFill;
    }

    public SObject toSObject() {
        List<SObject> result = this.toList();
        if (result.isEmpty()) {
            return null;
        }
        return result[0];
    }

    public Set<Id> toIdSet() {
        return this.toMap().keySet();
    }

    public Set<Id> extractIds(String fieldName) {
        Set<Id> result = new Set<Id>();
        for (SObject sobj : this.toList()) {
            String extractedId = (String) sobj.get(fieldName);
            result.add(extractedId);
        }
        return result;
    }

    //post query filter
    public PostQueryFilter qbFilter() {
        return this.postQueryFilter;
    }

    //post query updater
    public PostQueryUpdater qbUpdater() {
        return this.postQueryUpdater;
    }
}