/**
 * Created by User on 10.04.2018.
 */

public class PostQueryUpdater {

    public final List<Updater> updaters;
    private final QueryResult queryResult;

    public PostQueryUpdater(QueryResult queryResult) {
        this.queryResult = queryResult;
        this.updaters = new List<Updater>();
    }

    public PostQueryUpdater add(Updater updater) {
        this.updaters.add(updater);
        return this;
    }

    public void performUpdate() {
        List<SObject> toUpdate = this.queryResult.toList();
        for (SObject sobj : toUpdate) {
            for (Updater updater : this.updaters) {
                updater.applyUpdate(sobj);
            }
        }
        update toUpdate;
    }
}