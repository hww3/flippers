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
	"name"  : "admin",
	"nologo" : 1
      ]);
    if (id->misc->session_variables->lastloaded)
      page->lastloaded = id->misc->session_variables->lastloaded;
    object v = view->get_view(page->name);
    v->add("page", page);
    v->add("user", ([ "id" : user["id"], "username" : user["username"], "admin" : user["admin"] ]));
    v->add("fins.version", Fins.__version);
    response->set_view(v);
  }
}

public void welcome(Request id, Response response, mixed args) {
  if (!id->misc->session_variables->userid) {
    response->redirect("/");
  }
  else {
    object user = Flippers.Objects.User(id->misc->session_variables->userid);
    mapping page = ([ 
	"title" : "Flippers Admin",
	"name"  : "admin",
	"nologo" : 1
      ]);
    object v = view->get_view("admin/welcome");
    v->add("page", page);
    v->add("user", ([ "id" : user["id"], "username" : user["username"], "admin" : user["admin"] ]));
    v->add("fins.version", Fins.__version);
    response->set_view(v);
  }
}
public void logout(Request id, Response response, mixed args) {
  foreach(indices(id->misc->session_variables), string key) {
    m_delete(id->misc->session_variables, key);
  }
  response->redirect("/");
}


public void ports(Request id, Response response, mixed args) {
  object user = Flippers.Objects.User(id->misc->session_variables->userid);
  if (!user["admin"])
    response->redirect("/admin");

  id->misc->session_variables->lastloaded = ports;
  object v = view->get_view("admin/ports");
  v->add("user", ([ "id" : user["id"], "username" : user["username"], "admin" : user["admin"] ]));
  v->add("fins.version", Fins.__version);
  v->add("ports", Flippers.Objects.Port()->find(([])));
  response->set_view(v);
}
