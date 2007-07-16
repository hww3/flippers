import Fins;
inherit Fins.FinsController;
import Tools.Logging;

public void index(Request id, Response response, mixed args) {
  object v;
  if (sizeof(Flippers.Objects.User()->find(([ "admin" : 1 ])))) {
    mapping page = ([ 
	"title" : "Welcome to Flippers",
	"name"  : "welcome"
      ]);
    v = view->get_view(page->name);
    v->add("page", page);
    v->add("fins.version", Fins.__version);
  }
  else {
    mapping page = ([ 
	"title" : "Welcome to Flippers",
	"name"  : "createfirstuser"
      ]);
    v = view->get_view(page->name);
    v->add("page", page);
    v->add("fins.version", Fins.__version);
  }
  response->set_view(v);
}

public void createfirstuser(Request id, Response response, mixed args) {
  if (sizeof(Flippers.Objects.User()->find(([ "admin" : 1 ])))) {
    response->redirect("/");
  }
  if (id->variables->ajax) {
    int uid = createAdminUser(id->variables->username, id->variables->password);
    if (uid) {
      response->set_data(Tools.JSON.serialize(([ "username" : Flippers.Objects.User(uid)["name"], "uid" : uid ])));
    }
  }
  else {
    mapping page = ([ 
	"title" : "Welcome to Flippers",
	"name"  : "createfirstuser"
      ]);
    object v = view->get_view(page->name);
    v->add("page", page);
    v->add("fins.version", Fins.__version);
    response->set_view(v);
  }
}

static int createAdminUser(string username, string password) { 
  Log.info("Creating admin user %O\n", username);
  object newuser = Flippers.Objects.User();
  newuser["username"] = username;
  newuser["password"] = Crypto.make_crypt_md5(password);
  newuser["admin"] = 1;
  newuser->save();
  return newuser["id"];
}
