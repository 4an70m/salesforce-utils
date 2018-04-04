public interface BeforeUndeletable extends Service {

    void executeBeforeUndelete(List<SObject> oldList);

}