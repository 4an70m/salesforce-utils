public interface BeforeInsertable extends Service {

    void executeBeforeInsert(List<SObject> newList);

}