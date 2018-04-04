public interface AfterInsertable extends Service {

    void executeAfterInsert(List<SObject> newList);

}