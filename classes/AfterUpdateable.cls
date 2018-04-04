public interface AfterUpdateable extends Service {

    void executeAfterUpdate(List<SObject> newList, Map<Id, SObject> oldMap);

}