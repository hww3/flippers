import Fins;
import Fins.Model;
inherit Fins.FinsModel;
import Tools.Logging;

public void load_model() {
  // FIXME
  // make this work better, if you run Flippers from the wrong path, you're screwed.
  //
  if (!Stdio.exist("config/flippers.sqlite3")) {
    Log.debug("Data source doesn't exist, creating...");
    string schema = Stdio.read_file("config/flippers.schema");
    object db = Sql.Sql(config["model"]["datasource"]);
    foreach(schema / ";", string query) {
      query = (query / "" - ({ "\n" })) * "";
      if (query == "")
	continue;
      Log.debug("running query %O", query);
      db->query(query);
    }
  }
  ::load_model();
  Flippers.Server.start(Fins.DataSource["_default"]->find->ports(([])));
}
