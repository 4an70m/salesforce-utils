public interface BeforeDeletable extends Service {

    void executeBeforeDelete(List<SObject> oldList);

}