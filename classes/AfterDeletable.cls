public interface AfterDeletable extends Service {

    void executeAfterDelete(List<SObject> oldList);

}