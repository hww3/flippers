import Fins;
inherit Fins.FinsController;
import Tools.Logging;

public void index(Request id, Response response, mixed args) {
  if (!id->misc->session_variables->userid) {
    response->redirect("/");
  }
  else {
    object user = Flippers.Objects.User(id->misc->session_variables->userid);
    mapping page = ([ 
	"title" : "Flippers Admin",
	"name"  : "admin"
      ]);
    object v = view->get_view(page->name);
    v->add("page", page);
    v->add("fins.version", Fins.__version);
    response->set_view(v);
  }
}

