import Fins;
import Fins.Model;
inherit Fins.FinsModel;
import Tools.Logging;

object datatype_instance_module = Flippers.Objects;
object datatype_definition_module = Flippers.Model;
object repository = Flippers.Repo;

//void register_types() {
//}

public void load_model() {
  // FIXME
  // make this work better, if you run Flippers from the wrong path, you're screwed.
  //
  if (!Stdio.exist("config/flippers.sqlite")) {
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
  Flippers.Server.start(Flippers.Objects.Port()->find(([])));
}
