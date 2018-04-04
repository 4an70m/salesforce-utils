public interface BeforeUpdateable extends Service{

    void executeBeforeUpdate(List<SObject> newList, Map<Id, SObject> oldMap);

}